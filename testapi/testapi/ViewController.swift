import UIKit
var arreglo = [String]()
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            print(searchPokemon(name: "Charmander"))
    }
}
func searchPokemon(name:String) -> Array<String> {
    
    let headers = [
        "x-rapidapi-key": "ba10129780msh9ac6cdee0e85fc1p112a06jsn7e996f8cd5ed",
        "x-rapidapi-host": "pokemon-go1.p.rapidapi.com"
    ]

    let request = NSMutableURLRequest(url: NSURL(string: "https://pokemon-go1.p.rapidapi.com/pokemon_stats.json")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error!.localizedDescription)
        } else {
            let httpResponse = response as? HTTPURLResponse
            guard let urlAPI = httpResponse?.url else { return }
            //print("La respuesta del server es: \(urlAPI.absoluteString)")
            
            
            
            let objetoUrl = URL(string: urlAPI.absoluteString)
            
            let tarea = URLSession.shared.dataTask(with: objetoUrl!) { (datos, respuesta, error) in
                if error != nil {
                    print(error!)
                } else {
                    do{
                        var c=0
                        var stop=false
                        while c<=1252{
                            if let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                                
                                if let dict = json[c] as? NSDictionary {
                                    if dict["pokemon_name"] as! String == name && dict["form"] as! String == "Normal"{
                                        arreglo.append("\(dict["pokemon_name"]!)")
                                        arreglo.append("\(dict["pokemon_id"]!)")
                                        arreglo.append("\(dict["base_attack"]!)")
                                        arreglo.append("\(dict["base_defense"]!)")
                                        arreglo.append("\(dict["base_stamina"]!)")
                                        print("Pokemon: \(dict["pokemon_name"]!)")
                                        print("ID: \(dict["pokemon_id"]!)")
                                        print("Ataque:\(dict["base_attack"]!)")
                                        print("Defensa: \(dict["base_defense"]!)")
                                        print("Stamina: \(dict["base_stamina"]!)")
                                        //for pokemons in dict {
                                            //print("\(pokemons.key) -> \(pokemons.value)")
                                        //}
                                        stop=true
                                        
                                    }
                                    
                                    //print("La pokedex tiene: \(json.count) estadisticas de pokemon")
                                    //print(dic)
                                    //print(dict["pokemon_name"]!)
                                    //para acceder a los diferentes pokemon necesitas acceder a la pocision "n" del array
                                }
                            }
                            if (stop) {break}
                            c+=1
                        }
                        
                    }catch {
                        print("El Procesamiento del JSON tuvo un error")
                    }
                    
                }
                
            }
            tarea.resume()
        }
    })
    dataTask.resume()
    return arreglo
}
