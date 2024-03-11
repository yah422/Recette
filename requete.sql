1.Afficher toutes les recettes disponibles (nom de la recette, catégorie et temps de préparation) triées de façon décroissante sur la durée de réalisation

SELECT recette.nom_recette, categorie.nom_categorie, recette.tpsPrep_recette
FROM recette
JOIN categorie ON recette.id_categorie = categorie.id_categorie
ORDER BY recette.tpsPrep_recette DESC;


2. En modifiant la requête précédente, faites apparaître le nombre d’ingrédients nécessaire par recette

SELECT recette.nom_recette, categorie.nom_categorie, recette.tpsPrep_recette, COUNT(contenir.id_ingredient) AS nombre_ingredients
FROM recette
JOIN categorie ON recette.id_categorie = categorie.id_categorie
LEFT JOIN contenir ON recette.id_recette = contenir.id_recette
GROUP BY recette.id_recette
ORDER BY recette.tpsPrep_recette DESC;

3. Afficher les recettes qui nécessitent au moins 30 min de préparation

SELECT *
FROM recette
WHERE tpsPrep_recette >=30;

4. Afficher les recettes dont le nom contient le mot « Salade » (peu importe où est situé le mot en question)

SELECT *
FROM recette
WHERE nom_recette LIKE '%salade%';

5. Insérer une nouvelle recette : « Pâtes à la carbonara » dont la durée de réalisation est de 20 min avec les instructions de votre choix. Pensez à alimenter votre base de données en conséquence afin de pouvoir lister les détails de cette recettes (ingrédients)

INSERT INTO recette (nom_recette,tpsPrep_recette,instruction_recette) VALUES ("pate carbonara", 20, "faire cuire les pates et ajouter la creme fraiche et les lardons");

6. Modifier le nom de la recette ayant comme identifiant id_recette = 3 (nom de la recette à votre convenance)

UPDATE recette
SET nom_recette ='oeufs pauchee'
WHERE id_recette=3;

7. Supprimer la recette n°2 de la base de données

DELETE FROM contenir
WHERE id_recette =2;

DELETE FROM recette
WHERE id_recette = 2;

8. Afficher le prix total de la recette n°5

SELECT nom_recette, ROUND(SUM(quantite*prix_ingredient),2) AS prixTotal
FROM recette
INNER JOIN contenir ON contenir.id_recette = recette.id_recette 
INNER JOIN ingredient ON contenir.id_ingredient = ingredient.id_ingredient
WHERE recette.id_recette =5;

9. Afficher le détail de la recette n°5 (liste des ingrédients, quantités et prix)

SELECT *
FROM contenir
JOIN ingredient ON contenir.id_ingredient = ingredient.id_ingredient
WHERE contenir.id_recette = 5
AND (contenir.id_ingredient =12 OR contenir.id_ingredient =15 OR contenir.id_ingredient =11);

10. Ajouter un ingrédient en base de données : Poivre, unité : cuillère à café, prix : 2.5 €

INSERT INTO ingredient (nom_ingredient, UniteDeMesure, prix_ingredient) VALUES (‘ poivre ‘, ‘c.a.c ‘, 2.5);

11. - Modifier le prix de l’ingrédient n°12 (prix à votre convenance)

UPDATE ingredient
SET prix_ingredient = 5.3
WHERE id_ingredient = 12 ;

12. Afficher le nombre de recettes par catégories : X entrées, Y plats, Z desserts

SELECT nom_categorie, COUNT(id_recette) as nombre_recettes
FROM recette
INNER JOIN categorie ON recette.id_categorie = categorie.id_categorie
GROUP BY categorie.id_categorie
ORDER BY nombre_recettes DESC

13. Afficher les recettes qui contiennent l’ingrédient « Poulet »

SELECT *
FROM recette
WHERE nom_recette LIKE "%poulet%"

14. Mettez à jour toutes les recettes en diminuant leur temps de préparation de 5 minutes

UPDATE recette
SET tpsPrep_recette = tpsPrep_recette -5

15. Afficher les recettes qui ne nécessitent pas d’ingrédients coûtant plus de 2€ par unité de mesure

SELECT *
FROM ingredient
WHERE prix_ingredient <=2

16. Afficher la / les recette(s) les plus rapides à préparer

SELECT nom_recette, tpsPrep_recette
FROM recette
WHERE tpsPrep_recette = (
SELECT MIN(tpsPrep_recette)
FROM recette);

17. Trouver les recettes qui ne nécessitent aucun ingrédient (par exemple la recette de la tasse d’eau chaude qui consiste à verser de l’eau chaude dans une tasse) 

SELECT nom_recette
FROM recette
WHERE id_recette NOT IN (
SELECT id_recette
FROM contenir
WHERE contenir.id_recette = recette.id_recette)


18.  Trouver les ingrédients qui sont utilisés dans au moins 3 recettes 

SELECT ingredient.id_ingredient, nom_ingredient, COUNT(DISTINCT id_recette) AS nombre_recette
FROM contenir
JOIN ingredient ON contenir.id_ingredient = ingredient.id_ingredient
GROUP BY ingredient.id_ingredient, nom_ingredient
HAVING COUNT(DISTINCT id_recette) >= 3;


19. Ajouter un nouvel ingrédient à une recette spécifique 

INSERT INTO contenir (id_recette, id_ingredient, quantite) VALUES (55, 15, 5);


20.  Bonus : Trouver la recette la plus coûteuse de la base de données (il peut y avoir des ex aequo, il est donc exclu d’utiliser la clause LIMIT

SELECT *
FROM prix_recette
WHERE prixtotal >= ALL(
SELECT prixtotal
FROM prix_recette
