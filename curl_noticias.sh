#!/bin/bash

# Se o arquivo existe, remova
if [ -a ./noticias.html ]; then
	rm noticias.html
fi

if [ -a ./saida.js ]; then
	rm saida.js
fi

touch noticias.html
touch saida.js

curl http://www.demolaypb.com.br/noticias >> noticias.html

LINKS=( $(grep href=\"noticia\/ ./noticias.html | uniq | cut -d'"' -f2 -) )
TITULOS=( $(grep h4 ./noticias.html | cut -d'>' -f2 - | cut -d'<' -f1 - | tr [:blank:] [_] ) )
IMAGENS=( $(grep src=\"imagens\/noticias ./noticias.html | cut -d'"' -f4 -) )

sql="DROP TABLE IF EXISTS noticias;"
sqlite3 banco_dados.db "$sql"
#echo $sql

sql="CREATE TABLE noticias (titulo TEXT, link TEXT, img TEXT)"
sqlite3 banco_dados.db "$sql"
#echo $sql

length=${#LINKS[@]}
for ((i = 0; i != length; i++)); do
	TITULO=`echo ${TITULOS[i]} | tr '_' ' '`
	LINK=http://www.demolaypb.com.br/${LINKS[i]}
	IMAGEM=http://www.demolaypb.com.br/${IMAGENS[i]}
	sql="INSERT INTO noticias ('titulo','link','img') VALUES('${TITULO}','${LINK}','${IMAGEM}');"      
	#echo $sql
	sqlite3 banco_dados.db "$sql"
done