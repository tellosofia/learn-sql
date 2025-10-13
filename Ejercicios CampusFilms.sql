-- 1- Devuelve todas las películas
SELECT 
	*
FROM
	MOVIES;

-- 2- Devuelve todos los géneros existentes
SELECT 
	*
FROM	
	GENRES;

-- 3- Devuelve la lista de todos los estudios de grabación que estén activos
SELECT 	
	STUDIO_NAME AS ACTIVE_STUDIOS
FROM
	STUDIOS
WHERE 
	STUDIO_ACTIVE = 1;

-- 4- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma
SELECT
	USER_NAME 
FROM
	USERS
ORDER BY 
	USER_JOIN_DATE DESC
LIMIT 
	20;

-- 5- Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor
SELECT
	MOVIE_DURATION,
	COUNT(MOVIE_DURATION) AS DURATION_COUNT
FROM
	MOVIES
GROUP BY 
	MOVIE_DURATION
ORDER BY
	DURATION_COUNT DESC
LIMIT
	20;

-- 6- Devuelve las películas del año 2000 en adelante que empiecen por la letra A.
SELECT
	*
FROM
	MOVIES
WHERE
	MOVIE_RELEASE_DATE >= '2000-01-01'
	AND
	MOVIE_NAME LIKE 'A%';

-- 7- Devuelve los actores nacidos un mes de Junio
SELECT
	*
FROM
	ACTORS
WHERE
	EXTRACT(MONTH FROM ACTOR_BIRTH_DATE) = 6;

-- 8- Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos
SELECT
	*
FROM
	ACTORS
WHERE
	EXTRACT(MONTH FROM ACTOR_BIRTH_DATE) <> 6
	AND
	ACTOR_DEAD_DATE IS NULL;

-- 9- Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
SELECT
	DIRECTOR_NAME AS DIRECTOR,
	YEAR(NOW) - YEAR(DIRECTOR_BIRTH_DATE) AS AGE
FROM
	DIRECTORS
WHERE
	(YEAR(NOW) - YEAR(DIRECTOR_BIRTH_DATE)) <= 50
	AND
	DIRECTOR_DEAD_DATE IS NULL
ORDER BY
	AGE;

-- 10- Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT
	ACTOR_NAME,
	YEAR(ACTOR_DEAD_DATE) - YEAR(ACTOR_BIRTH_DATE) AS AGE
FROM
	ACTORS
WHERE 	
	(YEAR(NOW) - YEAR(ACTOR_BIRTH_DATE)) <= 50
	AND
	ACTOR_DEAD_DATE IS NOT NULL;

-- 11 - Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT
	DIRECTOR_NAME
FROM
	DIRECTORS
WHERE
	(YEAR(NOW) - YEAR(DIRECTOR_BIRTH_DATE)) <= 40;

-- 12- Indica la edad media de los directores vivos
SELECT 
	AVG(YEAR(NOW) - YEAR(DIRECTOR_BIRTH_DATE))
FROM
	DIRECTORS
WHERE
	DIRECTOR_DEAD_DATE IS NULL;

-- 13- Indica la edad media de los actores que han fallecido
SELECT 
	AVG(YEAR(ACTOR_DEAD_DATE) - YEAR(ACTOR_BIRTH_DATE))
FROM
	ACTORS
WHERE 
	ACTOR_DEAD_DATE IS NOT NULL;

-- 14- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT
	m.MOVIE_NAME,
	s.STUDIO_NAME
FROM
	MOVIES m
LEFT OUTER JOIN 
	STUDIOS s 
	ON 
		m.STUDIO_ID = s.STUDIO_ID
ORDER BY
	s.STUDIO_NAME,
	m.MOVIE_NAME;
	
-- 15- Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015
SELECT
	u.*
FROM
	USERS u 
INNER JOIN
	USER_MOVIE_ACCESS uma 
	ON
		u.USER_ID = uma.USER_ID
WHERE
	uma.ACCESS_DATE BETWEEN '2010-01-01' AND '2015-12-31';

SELECT * FROM USER_MOVIE_ACCESS uma;

-- 16- Devuelve cuantas películas hay de cada país
SELECT 
	n.NATIONALITY_NAME AS COUNTRY,
	COUNT(m.MOVIE_NAME) AS MOVIES_PER_COUNTRY
FROM 	
	MOVIES m
LEFT OUTER JOIN
	NATIONALITIES n
	ON
		m.NATIONALITY_ID = n.NATIONALITY_ID
GROUP BY
	COUNTRY
ORDER BY
	MOVIES_PER_COUNTRY DESC;
	
-- 17- Devuelve todas las películas que hay de género documental
SELECT 
	m.*
FROM 
	MOVIES m
WHERE
	m.GENRE_ID = 2;
	
-- 18- Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT
	m.*
FROM
	MOVIES m 
INNER JOIN
	DIRECTORS d
	ON
		m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE
	d.DIRECTOR_BIRTH_DATE >= '1980-01-01'
	AND
	d.DIRECTOR_DEAD_DATE IS NULL;

/* 19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y 
 los directores */
SELECT 
	u.USER_TOWN,
	d.DIRECTOR_BIRTH_PLACE 
FROM
	USERS u
INNER JOIN
	DIRECTORS d
	ON 	
		u.USER_TOWN = d.DIRECTOR_BIRTH_PLACE;

-- 20- Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo
SELECT
	m.MOVIE_NAME,
	EXTRACT(YEAR FROM m.MOVIE_RELEASE_DATE) AS "YEAR"
FROM
	MOVIES m
INNER JOIN
	STUDIOS s
	ON
		m.STUDIO_ID = s.STUDIO_ID
WHERE
	s.STUDIO_ACTIVE = 0
ORDER BY
	"YEAR";

-- 21- Devuelve una lista de las últimas 10 películas a las que se ha accedido
SELECT 
	m.MOVIE_NAME,
	uma.ACCESS_DATE 
FROM
	MOVIES m
INNER JOIN
	USER_MOVIE_ACCESS uma 
	ON
		m.MOVIE_ID = uma.MOVIE_ID
ORDER BY 
	uma.ACCESS_DATE DESC
LIMIT
	10;

-- 22- Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT
	d.DIRECTOR_NAME AS DIRECTOR,
	COUNT(m.MOVIE_NAME) AS MOVIES_MADE
FROM
	MOVIES m 
RIGHT JOIN
	DIRECTORS d 
	ON
	m.DIRECTOR_ID = d.DIRECTOR_ID
	AND
	(m.MOVIE_RELEASE_DATE - d.DIRECTOR_BIRTH_DATE) < 41
GROUP BY
	DIRECTOR
ORDER BY
	MOVIES_MADE DESC;

SELECT * FROM DIRECTORS d 

-- 23- Indica cuál es la media de duración de las películas de cada director
SELECT
	d.DIRECTOR_NAME AS DIRECTOR,
	ROUND(AVG(m.MOVIE_DURATION), 0) AS AVG_DURATION
FROM
	MOVIES m 
INNER JOIN
	DIRECTORS d 
	ON
	m.DIRECTOR_ID = d.DIRECTOR_ID
GROUP BY
	DIRECTOR
ORDER BY
	AVG_DURATION;

/* 24- Indica cuál es la el nombre y la duración mínima de las películas a las que se ha accedido en los últimos 2 años por los 
miembros del plataforma (La “fecha de ejecución” de esta consulta es el 25-01-2019) */
SELECT
	m.MOVIE_NAME,
	MIN(m.MOVIE_DURATION) AS DURATION
FROM
	MOVIES m 
INNER JOIN
	USER_MOVIE_ACCESS uma
	ON
		m.MOVIE_ID = uma.MOVIE_ID 
WHERE
	ACCESS_DATE >= '2015-12-19' -- last access date is '2017-12-19'
GROUP BY
	m.MOVIE_NAME
ORDER BY
	DURATION;

-- SELECT * FROM USER_MOVIE_ACCESS uma ORDER BY ACCESS_DATE DESC;

/* 25- Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra 
 “The” en cualquier parte del título */
SELECT 
	d.DIRECTOR_NAME AS DIRECTOR,
	COUNT(m.MOVIE_ID) AS "60s_70s_80s_MOVIES"
FROM
	MOVIES m
INNER JOIN
	DIRECTORS d 
	ON
		m.DIRECTOR_ID = d.DIRECTOR_ID 
WHERE
	LOWER(m.MOVIE_NAME) LIKE '%the%'
	AND
	m.MOVIE_RELEASE_DATE BETWEEN '1960-01-01' AND '1989-12-31'
GROUP BY
	DIRECTOR;

-- 26- Lista nombre, nacionalidad y director de todas las películas
SELECT 
	m.MOVIE_NAME AS MOVIE,
	n.NATIONALITY_NAME AS NATIONALITY,
	d.DIRECTOR_NAME AS DIRECTOR
FROM
	MOVIES m
INNER JOIN
	DIRECTORS d 
	ON
		m.DIRECTOR_ID = d.DIRECTOR_ID
INNER JOIN
	NATIONALITIES n 
	ON 
	m.NATIONALITY_ID = n.NATIONALITY_ID
ORDER BY 
	NATIONALITY,
	MOVIE,
	DIRECTOR;

-- 27- Muestra las películas con los actores que han participado en cada una de ellas
SELECT
	m.MOVIE_NAME AS MOVIE,
	a.ACTOR_NAME AS "ACTORS"
FROM
	MOVIES m 
INNER JOIN
	MOVIES_ACTORS ma 
	ON
		m.MOVIE_ID = ma.MOVIE_ID
INNER JOIN 
	ACTORS a 
	ON
		ma.ACTOR_ID = a.ACTOR_ID
ORDER BY
	MOVIE,
	"ACTORS";

-- 28- Indica cual es el nombre del director del que más películas se ha accedido
SELECT
	d.DIRECTOR_NAME AS DIRECTOR,
	COUNT(uma.ACCESS_DATE) AS "ACCESS_#"
FROM
	DIRECTORS d 
INNER JOIN
	MOVIES m 
	ON
		d.DIRECTOR_ID = m.DIRECTOR_ID
INNER JOIN
	USER_MOVIE_ACCESS uma 
	ON
		m.MOVIE_ID = uma.MOVIE_ID
GROUP BY 
	DIRECTOR
ORDER BY 
	"ACCESS_#" DESC
LIMIT
	1;

-- 29- Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT 
	s.STUDIO_NAME AS STUDIO,
	m.MOVIE_NAME AS MOVIE,
	SUM(a.AWARD_WIN) AS AWARDS_PER_MOVIE
FROM
	STUDIOS s
INNER JOIN
	MOVIES m 
	ON
		s.STUDIO_ID = m.STUDIO_ID
INNER JOIN
	AWARDS a 
	ON
		m.MOVIE_ID = a.MOVIE_ID
GROUP BY
	STUDIO,
	MOVIE
ORDER BY 
	STUDIO,
	AWARDS_PER_MOVIE ,
	MOVIE;

SELECT 
	s.STUDIO_NAME AS STUDIO,
	SUM(a.AWARD_WIN) AS TOTAL_AWARDS
FROM
	STUDIOS s
INNER JOIN
	MOVIES m 
	ON
		s.STUDIO_ID = m.STUDIO_ID
INNER JOIN
	AWARDS a 
	ON
		m.MOVIE_ID = a.MOVIE_ID
GROUP BY
	STUDIO
ORDER BY 
	TOTAL_AWARDS DESC;

/* 30- Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada 
a un premio, su actor también lo está) */
SELECT
	a2.ACTOR_NAME AS ACTOR,
	m.MOVIE_NAME AS MOVIE,
	SUM(a.AWARD_ALMOST_WIN) AS NOT_WON_NOMINATION
FROM
	AWARDS a 
INNER JOIN
	MOVIES m 
	ON
		a.MOVIE_ID = m.MOVIE_ID
INNER JOIN
	MOVIES_ACTORS ma 
	ON
		m.MOVIE_ID = ma.MOVIE_ID 
INNER JOIN
	ACTORS a2 
	ON
		ma.ACTOR_ID = a2.ACTOR_ID
GROUP BY
	ACTOR,
	MOVIE
ORDER BY 
	ACTOR,
	NOT_WON_NOMINATION;

SELECT
	a2.ACTOR_NAME AS ACTOR,
	SUM(a.AWARD_ALMOST_WIN) AS NOT_WON_NOMINATION
FROM
	AWARDS a 
INNER JOIN
	MOVIES m 
	ON
		a.MOVIE_ID = m.MOVIE_ID
INNER JOIN
	MOVIES_ACTORS ma 
	ON
		m.MOVIE_ID = ma.MOVIE_ID 
INNER JOIN
	ACTORS a2 
	ON
		ma.ACTOR_ID = a2.ACTOR_ID
GROUP BY
	ACTOR
ORDER BY 
	NOT_WON_NOMINATION;

-- 31- Indica cuantos actores y directores hicieron películas para los estudios no activos
SELECT 
	s.STUDIO_NAME AS STUDIO,
	COUNT(DISTINCT a.ACTOR_NAME) AS ACTOR_COUNT,
	COUNT(DISTINCT d.DIRECTOR_NAME) AS DIRECTOR_COUNT
FROM
	STUDIOS s
INNER JOIN
	MOVIES m 
	ON
		s.STUDIO_ID = m.STUDIO_ID
INNER JOIN
	DIRECTORS d 
	ON
		m.DIRECTOR_ID = d.DIRECTOR_ID
INNER JOIN
	MOVIES_ACTORS ma 
	ON
		m.MOVIE_ID = ma.MOVIE_ID
INNER JOIN
	ACTORS a 
	ON
		ma.ACTOR_ID = a.ACTOR_ID
WHERE
	s.STUDIO_ACTIVE = 0
GROUP BY
	STUDIO;

/* 32- Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma que hayan accedido películas que hayan sido 
nominadas a más de 150 premios y ganaran menos de 50 */
SELECT 
	u.USER_NAME AS USER,
	u.USER_TOWN AS CITY,
	u.USER_PHONE AS PHONE
FROM 
	USERS u 
INNER JOIN
	USER_MOVIE_ACCESS uma 
	ON
		u.USER_ID = uma.USER_ID
INNER JOIN
	MOVIES m 
	ON 
		uma.MOVIE_ID = m.MOVIE_ID 
INNER JOIN
	AWARDS a 
	ON
		m.MOVIE_ID = a.MOVIE_ID
WHERE
	a.AWARD_NOMINATION > 150
	AND
	a.AWARD_WIN < 50;

/* 33- Comprueba si hay errores en la BD entre las películas y directores (un director muerto en el 76 no puede dirigir una película 
en el 88)*/
SELECT
	*
FROM
	MOVIES m 
INNER JOIN
	DIRECTORS d
	ON
		m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE 
	m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE;
 
/* 34- Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película 
(mediante sentencia SQL)*/

-- UPDATE DIRECTORS SET DIRECTOR_DEAD_DATE ... WHERE DIRECTOR_ID = 27 
-- UPDATE DIRECTORS SET DIRECTOR_DEAD_DATE = '2010-04-08' WHERE DIRECTOR_ID = 47;

/* otra opción */

/* UPDATE
	DIRECTORS
SET
	DIRECTOR_DEAD_DATE = (
	SELECT
		DATE_ADD(MOVIE_RELEASE_DATE , INTERVAL '1' YEAR)
	FROM
		MOVIES)
WHERE
	DIRECTOR ID IN (
	SELECT
			DISTINCT m.DIRECTOR_ID
	FROM
			MOVIES m
	INNER JOIN
			DIRECTORS d
			ON
				m.DIRECTOR_ID = d.DIRECTOR_ID
	WHERE 
			m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE
		AND
			m.DIRECTOR_ID = d.DIRECTOR_ID); */

-- 35- Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película
WITH G_COUNT AS(
		SELECT
			d.DIRECTOR_NAME AS DIRECTOR,
			g.GENRE_NAME AS GENRE,
			COUNT(g.GENRE_NAME) AS GENRE_COUNT
		FROM
			MOVIES m
		INNER JOIN
			GENRES g
			ON
				m.GENRE_ID = g.GENRE_ID 
		INNER JOIN 
			DIRECTORS d 
			ON
				m.DIRECTOR_ID = d.DIRECTOR_ID
		GROUP BY
			DIRECTOR,
			GENRE
),
MAX_GEN AS (
SELECT
		DIRECTOR,
		MAX(GENRE_COUNT) AS MAX_COUNT
FROM
		G_COUNT
GROUP BY
		DIRECTOR 
)
SELECT
	gen.DIRECTOR,
	gen.GENRE AS FAV_GENRE,
	gen.GENRE_COUNT
FROM
	G_COUNT gen
INNER JOIN
	MAX_GEN mx
	ON
		gen.DIRECTOR = mx.DIRECTOR
	AND
		gen.GENRE_COUNT = mx.MAX_COUNT 
ORDER BY
	gen.DIRECTOR,
	gen.GENRE_COUNT;
	

SELECT 
	DIRECTOR,
	MAX(GENRE_COUNT)
FROM (
		SELECT
			d.DIRECTOR_NAME AS DIRECTOR,
			g.GENRE_NAME AS GENRE,
			COUNT(g.GENRE_NAME) AS GENRE_COUNT
		FROM
			MOVIES m
		INNER JOIN
			GENRES g
			ON
				m.GENRE_ID = g.GENRE_ID 
		INNER JOIN 
			DIRECTORS d 
			ON
				m.DIRECTOR_ID = d.DIRECTOR_ID
		GROUP BY
			DIRECTOR,
			GENRE)
GROUP BY
	DIRECTOR
ORDER BY 
	MAX(GENRE_COUNT) DESC;

-- 36- Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas
SELECT
	s.STUDIO_NAME AS STUDIO,
	n.NATIONALITY_NAME AS COUNTRY,
	COUNT(m.MOVIE_NAME) AS COUNTRY_COUNT
FROM
	NATIONALITIES n 
INNER JOIN
	MOVIES m 
	ON
		n.NATIONALITY_ID = m.NATIONALITY_ID
INNER JOIN 
	STUDIOS s 
	ON
		m.STUDIO_ID = s.STUDIO_ID
GROUP BY
	STUDIO,
	COUNTRY;

WITH COUNTS AS (
		SELECT
		s.STUDIO_NAME AS STUDIO,
		n.NATIONALITY_NAME AS COUNTRY,
		COUNT(m.MOVIE_NAME) AS COUNTRY_COUNT
		FROM
			NATIONALITIES n 
		INNER JOIN
			MOVIES m 
			ON
				n.NATIONALITY_ID = m.NATIONALITY_ID
		INNER JOIN 
			STUDIOS s 
			ON
				m.STUDIO_ID = s.STUDIO_ID
		GROUP BY
			STUDIO,
			COUNTRY
),
MAX_COUNT AS (
		SELECT
			STUDIO,
			MAX(COUNTRY_COUNT) AS TOP_COUNTRY
		FROM
			COUNTS 
		GROUP BY
			STUDIO
)
SELECT 
	c.STUDIO,
	c.COUNTRY,
	mx.TOP_COUNTRY 
FROM 
	COUNTS c
INNER JOIN
	MAX_COUNT mx
	ON
		c.STUDIO = mx.STUDIO 
		AND
		c.COUNTRY_COUNT = mx.TOP_COUNTRY
ORDER BY
	c.STUDIO,
	mx.TOP_COUNTRY DESC;

/* 37- Indica cuál fue la primera película a la que accedieron los miembros de la plataforma cuyos teléfonos tengan como último 
dígito el ID de alguna nacionalidad*/
WITH MEMBER_MOVIE AS (
		SELECT
			m.MOVIE_NAME AS MOVIE,
			u.USER_NAME AS MEMBER,
			u.USER_PHONE AS PHONE,
			u.USER_ID,
			uma.ACCESS_DATE 
		FROM
			MOVIES m 
		INNER JOIN
			USER_MOVIE_ACCESS uma 
			ON
				m.MOVIE_ID = uma.MOVIE_ID
		INNER JOIN
			USERS u
			ON
				uma.USER_ID = u.USER_ID
		WHERE
			CAST(RIGHT(u.USER_PHONE, 1) AS INT) IN (SELECT NATIONALITY_ID FROM NATIONALITIES)
),
FIRST_ACCESS AS (	
		SELECT USER_ID, MIN(ACCESS_DATE) AS FIRST_DATE FROM USER_MOVIE_ACCESS GROUP BY USER_ID
)
SELECT
	mm.MOVIE,
	mm.MEMBER,
	mm.PHONE,
	f.FIRST_DATE 
FROM
	MEMBER_MOVIE mm
INNER JOIN
	FIRST_ACCESS f
	ON
		mm.USER_ID = f.USER_ID 
		AND
		mm.ACCESS_DATE = f.FIRST_DATE
ORDER BY
	f.FIRST_DATE;
		
	
	