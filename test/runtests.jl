using GLMNet, Distributions, Base.Test

X = [74    1  93  93  79  18
     98   36   2  27  65  70
     61    8  99  53  77  92
     47   51  67  84  87  80
     81   32   9  18  32  10
     78   67  92  98   4  65
     67   94  30  20  85  73
     51  100  75  76  86  18
     93   71  76  64  70  91
     30    5  13  89  19  2]
y = [9, 67, 91, 80, 2, 61, 70, 13, 83, 21]

## LEAST SQUARES
# True data from R glmnet
df_true = [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,4,4,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6]
dev_ratio = [0,0.1611406847,0.2949225122,0.4059905356,0.4982011599,0.5747560401,0.6383132466,0.6910795561,0.7348870732,0.7712568435,0.8014516657,0.8265199376,0.8473320574,0.8646106448,0.8789556317,0.8908650918,0.9007525347,0.9089612636,0.9157762946,0.921434253,0.9261315894,0.9300314007,0.9332690925,0.9359570811,0.9398657226,0.945705192,0.9505511735,0.954574392,0.9579145386,0.9606875869,0.9629898204,0.9663259092,0.9704791586,0.9740634616,0.9773275819,0.9800320948,0.9822774198,0.9841415281,0.9856891436,0.9869684203,0.988036043,0.988922438,0.9898389202,0.9907513046,0.9915176738,0.9921544907,0.9926832231,0.9931161877,0.9934811105,0.993784561,0.9940365343,0.9942415128,0.9944153885,0.9945601976,0.9946804775,0.9947772389,0.9948601574,0.9949294264,0.9949870099,0.9950348299,0.9950724417,0.9951053024,0.9951329295,0.9951559502,0.9951750831,0.9951909727,0.9952041658,0.9952151193,0.9952242131]
lambda = [31.8289169496,29.0013236919,26.4249260262,24.0774084281,21.9384378235,19.9894874721,18.2136764984,16.5956236773,15.1213142093,13.777978331,12.5539807098,11.4387196638,10.4225353353,9.4966260218,8.6529719398,7.8842657613,7.183849321,6.5456559468,5.9641579131,5.434318562,4.9515486786,4.511666741,4.1108627024,3.7456649899,3.4129104357,3.109716879,2.8334582022,2.5817415848,2.352386778,2.1434072201,1.9529928302,1.7794943298,1.621408958,1.477367455,1.3461222021,1.2265364157,1.117574301,1.0182920803,0.9278298184,0.8454039745,0.7703006155,0.7018692318,0.6395171037,0.5827041668,0.5309383346,0.4837712363,0.440794333,0.4016353793,0.3659551992,0.3334447479,0.3038224355,0.2768316877,0.2522387236,0.2298305306,0.2094130197,0.1908093442,0.1738583679,0.1584132697,0.1443402714,0.1315174795,0.1198338291,0.109188122,0.0994881502,0.0906498971,0.0825968101,0.0752591371,0.0685733228,0.0624814578,0.0569307773]
a0 = [49.7,45.3564158503177,41.3987037450736,37.7925838753477,34.5068217559655,31.5129576873293,28.7850602511156,26.2995017047348,24.034753329128,21.971198957302,20.090965068475,18.3777659761895,16.8167627694882,15.394434785365,14.0984624992512,12.9176208191865,11.8416818594426,10.8613263514704,9.96806292485341,9.15415455911991,8.41255156937272,7.73683054529119,7.12113871462388,6.56014324927526,6.58063782500258,7.46077449978637,8.2619969650005,8.99204080542006,9.65722956306944,10.2633247848263,10.8155761775506,11.752323523965,13.1190988923835,14.3906024051726,15.6144444818097,16.7269990088934,17.7407121192727,18.6643697413071,19.5059721658893,20.2682389137493,20.9673256125271,21.604339554904,21.8013580787941,21.6435121171738,21.4854892971093,21.3405100552143,21.20834094952,21.1018083210422,20.9922078184326,20.8911096494637,20.7988719397475,20.7285942864877,20.652704588566,20.5818972051069,20.5171522427852,20.4717556882645,20.4195164444671,20.3696925422545,20.3238654536683,20.282026786402,20.25582230825,20.2237130253272,20.1917640015501,20.1619151307503,20.134518070829,20.109500814449,20.0866913936042,20.0659043415446,20.0469628833773]
# Only check 3 random models; if these are right the rest should be too
models = [11, 46, 54]
betas = [0.0000000000000000 -0.26106259863474601 -0.26999306570454373
         0.0000000000000000 -0.03329369198952250 -0.04052553140335470
         0.0000000000000000 -0.08096633358970667 -0.11301841848092280
         0.0000000000000000  0.02497015329885828  0.05893642256095720
         0.0000000000000000 -0.05815325804765525 -0.05965937657889149
         0.5705016364455693  1.04279276932443676  1.07097251257554626]

path = glmnet(X, y)
@test nactive(path.betas) == df_true
@test_approx_eq path.dev_ratio dev_ratio
@test_approx_eq path.lambda lambda
@test_approx_eq path.a0 a0
@test_approx_eq path.betas[:, models] betas
@test_approx_eq predict(path, X, 16) [25.67451533276341,62.52776614976348,78.11952611080198,69.61492976841734,20.00478443784032,58.98418434043655,64.65391523535965,25.67451533276341,77.41080974893660,14.33505354291723]
@test_approx_eq predict(path, X, 62) [9.688463955335449,65.513664866328625,89.537586892649699,84.299096349896985,5.711287928399321,61.686267113123805,69.396354069847447,12.253877034216755,81.104769545494065,17.808632244707766]

# Cross-validation
cv = glmnetcv(X, y; folds=[1,1,1,1,2,2,2,3,3,3])
@test_approx_eq cv.meanloss [1196.1831818915,1054.30217435069,882.722957995572,741.473677317198,625.29834407298,529.842805475268,451.500787886456,387.286154256594,334.726918037371,291.777313661086,256.744852390135,228.229814266579,205.075060158504,186.324407566207,171.188112416484,159.014246914545,149.264969255241,141.496851770503,135.344575845549,130.507419601832,126.738062011939,123.833308177869,121.759979920248,123.405730733183,126.246475207591,130.300029294795,134.761617424352,135.84097109272,132.80732564575,130.057460381724,128.005183135106,127.353126005167,126.824352828159,127.510894580506,129.064310693711,131.249132705201,133.907064001153,136.827616882974,139.928881336838,143.120700230896,146.332889852076,149.286567860237,151.61758331725,153.537686814315,155.046024586371,156.494509129635,157.92336668661,159.254825641564,160.643241643709,162.137490923151,163.22393927254,163.624361032528,163.978112109613,164.435716089929,164.84767780055,165.234398704213,165.601909217979,165.95148431663,166.230877652317,166.539460931986,166.875169226736,167.148637657379,167.275437267899,166.992396955946,166.616831516085,165.25092839651,163.61729314233,162.198795211718,160.897087329777]
@test_approx_eq cv.stdloss [136.322352820689,170.710376306389,158.691785362096,149.610624475054,141.590228420862,133.64026444338,125.33164947624,116.552349747324,107.352477960962,97.8544509429927,88.2039985031141,78.5452407441376,69.0096336322921,59.7130670089858,50.7583758079413,42.2429251584245,34.2740325064648,27.0013413441031,20.6899967909112,15.8753047499791,13.485443750424,14.1317298603899,16.8747291292415,17.9688088705902,19.8689642526276,22.1123049318325,24.7083122571353,28.8139356563517,35.2791792848051,41.602749957491,47.3664947235114,51.4960276606513,54.2327783234582,55.9898175438816,57.000021758347,57.454958993556,57.5146092798421,57.285786773287,56.8687037939543,56.3361885934346,55.7431439753733,55.1982860337284,54.834071724466,54.0236060402016,52.8046590627462,51.7567432518268,50.8616576545451,50.0980343683626,49.3954918208392,48.6977684709033,47.7514256092116,46.2657337696719,44.9747304799199,43.7894874404512,42.7755317831402,41.8995181623959,41.1403608219021,40.4820861373618,39.9181019712624,39.4230393851226,39.0299829401119,38.6558452183199,38.3368612982388,37.7398448319383,37.046892340522,35.445787686226,33.8969088663738,32.3960089022261,31.1017204353906]
@test_approx_eq cv.lambda[indmin(cv.meanloss)] 4.110862702400506

## LOGISTIC
yl = [(y .< 50) (y .>= 50)]
df_true = [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
dev_ratio = [1.64963414313275e-16,0.11711409141227,0.215355515482448,0.299124156820257,0.371452163154872,0.434519100824185,0.48994501848197,0.538967475327471,0.582553711470932,0.621474546827564,0.656354669001616,0.687707802733412,0.715961888735986,0.741477479641649,0.764561421958809,0.785477194493997,0.804452832547669,0.821687081201179,0.837354231243534,0.851607962712688,0.864584432266733,0.876404778287493,0.887177173209025,0.896998520484262,0.905955870151843,0.914127609638224,0.921584473506577,0.928390406143291,0.934603304005683,0.940275658432526,0.945455115701383,0.950184967680937,0.95450458383433,0.958449793303743,0.962053224214272,0.965344606076493,0.96835104016623,0.971097241959162,0.973605759053103,0.97589716748811,0.97799024894814,0.979902150977602,0.981648532056303,0.98324369313484,0.984700697029953,0.986031476908355,0.987246934942176,0.988357032094864,0.989370869889387,0.990296764918051,0.991142316808738,0.991914469989512,0.992619570550384,0.993264376639891,0.993863141910281,0.994408265381351,0.994904846477669,0.995357235896248,0.995769384495201,0.996144886365329,0.996487011855463,0.996798571795001,0.997082614746819,0.997341437065679,0.997577278908065,0.997792184610203,0.997988015990938,0.998164616595545,0.998324910186123,0.998472761768518,0.998608017888962,0.998731273611304,0.998843586844649,0.998945929885174,0.999039188732365]
lambda = [0.472385796995596,0.430420344740319,0.392182987601768,0.357342531884834,0.325597206229472,0.296672047811549,0.270316520746397,0.246302346066837,0.224421524479971,0.20448453477681,0.186318692290232,0.169766653183001,0.154685051610726,0.140943257955496,0.128422247374626,0.117013568864409,0.106618405909405,0.097146720581053,0.0885164736722136,0.0806529141127983,0.0734879315117631,0.0669594662174844,0.0610109717867451,0.055590925206495,0.05065238062616,0.0461525627351428,0.0420524962635457,0.0383166683970286,0.0349127211817999,0.0318111712555004,0.0289851544764236,0.0264101932391713,0.024063984461346,0.0219262064049203,0.0199783426590643,0.0182035217598527,0.0165863710577156,0.0151128835669024,0.0137702966436712,0.0125469814423754,0.0114323421919646,0.0104167244204859,0.00949133133266545,0.00864814761627675,0.00787987001734032,0.00717984408283161,0.00654200652299234,0.00596083269401521,0.00543128874622221,0.00494878802326687,0.00450915133471117,0.00410857075787727,0.00374357665544295,0.00341100762310301,0.00310798310699748,0.0028318784537322,0.00258030217688671,0.00235107524310289,0.00214221219834052,0.00195190397082417,0.00177850220172892,0.00162050496788479,0.00147654377283674,0.00134537169358309,0.00122585258032493,0.00111695121568015,0.00101772434812567,0.000927312522004027,0.000844932633329594,0.000769871146916511,0.000701477916078241,0.000639160551368,0.000582379289584763,0.000530642318602633,0.000483501517529489]
a0 = [0.405465108108164,0.140176250683885,-0.0992662243829889,-0.319608698902845,-0.525409097953002,-0.719885442468768,-0.905389595220399,-1.08368869575178,-1.25614090672509,-1.42380976563256,-1.58754120288427,-1.74801696751657,-1.90579264599685,-2.06132532875521,-2.21499414433491,-2.36711576882579,-2.51795632378459,-2.66774063081715,-2.81665949916895,-2.96487552732337,-3.1125277663898,-3.25973550065908,-3.40660133558763,-3.55321373690158,-3.69964913072979,-3.84597364983478,-3.99224459250411,-4.13851164670196,-4.28481792141641,-4.43120081890042,-4.57769277507076,-4.72432189025576,-4.87111246844492,-5.01808547995481,-5.16525895980933,-5.31264835200644,-5.4602668081074,-5.60812544716003,-5.75623358279608,-5.90459892237519,-6.05322774224805,-6.20212504254884,-6.35129468437678,-6.50073951177017,-6.65046146049643,-6.80046165536594,-6.95074049751441,-7.1012977428796,-7.2521325729155,-7.40324365843486,-7.55462922409908,-7.7062870639621,-7.85821464755726,-7.99932508790125,-8.11668361040175,-8.23348460150408,-8.35048882547683,-8.46771934008979,-8.58517055863943,-8.70283615332831,-8.82071007847779,-8.93767800185906,-9.05589708552983,-9.17434994300337,-9.29299151174596,-9.41181545568595,-9.53081715612812,-9.64820567909124,-9.76230364686411,-9.87801013770701,-9.99814423223738,-10.1185820160268,-10.2391455402066,-10.3598264290273,-10.4806229814092]
betas = [0.00000000000000000  0.0000000000000000  0.0000000000000000000
         0.00000000000000000  0.0000000000000000  0.0000000000000000000
         0.00000000000000000  0.0000000000000000  0.0000000000000000000
         0.00000000000000000  0.0000000000000000  0.0000000000000000000
         0.00000000000000000  0.0000000000000000 -0.0001247956998235217
         0.04118567893498771  0.1609132092629401  0.1892922463930407362]
path = glmnet(X, float64(yl), Binomial())
@test nactive(path.betas) == df_true
@test_approx_eq path.dev_ratio dev_ratio
@test_approx_eq path.lambda lambda
@test_approx_eq path.a0 a0
@test_approx_eq path.betas[:, models] betas
@test_approx_eq predict(path, X, 16) [-1.315519391606169,1.722425698139390,3.007710159185589,2.306645907705844,-1.782895559259332,1.430315593356164,1.897691761009327,-1.315519391606169,2.949288138228943,-2.250271726912495]
@test_approx_eq predict(path, X, 62) [-5.328152634222764,5.936301834664929,10.640103977849353,8.017225144937120,-6.891307125813680,5.068602350662909,6.514278565882654,-5.352339338181535,10.448596815251006,-8.571939893775767]

# Cross-validation
cv = glmnetcv(X, yl, Binomial(); folds=[1,1,1,1,2,2,2,3,3,3])
@test_approx_eq cv.meanloss [1.49234494227531,1.38615874813194,1.21206306885012,1.06938422155755,0.949875638682754,0.84818653887696,0.760619411495895,0.684499772151965,0.617824998106308,0.559054283779918,0.506975881877881,0.460619433279447,0.419195969393922,0.382055625434977,0.348657088658388,0.318545052280019,0.29133326797243,0.266691597927214,0.24433627920335,0.224020834249451,0.205531611970948,0.188681551501474,0.173306394777185,0.159261342834698,0.147368020298803,0.136699609430587,0.126934205926672,0.117983090992767,0.109768795839977,0.102221967284434,0.0952806756386943,0.0888895012371177,0.0829987636185712,0.0775736978512928,0.0725540880255287,0.0679138959143045,0.0636204958669189,0.059644378248784,0.0559588188407036,0.0525396034632594,0.0493647721615075,0.0464149845115113,0.0438885286918041,0.0415648183109769,0.0393880552813593,0.037412240745235,0.0355198769989625,0.0338060631606874,0.0321245595301596,0.0305385706645483,0.0290435001371547,0.0276332290131986,0.0263020599339708,0.0250447416347534,0.0238738643934179,0.022751733444602,0.0216880755914549,0.0206807961837729,0.0197258850129326,0.0188274844276983,0.0179679487131716,0.017152180594888,0.0163967624210619,0.0156637702157366,0.0149654747253692,0.0143014629592538,0.0136700523455744,0.0130774322884263,0.0125742406075745,0.01201857694645,0.0115141599108009,0.0110162823352125,0.0105391162882984,0.0100840421173995,0.00965031914545527]
@test_approx_eq cv.stdloss [0.187060173197517,0.22273150331026,0.163351159153125,0.120895548472081,0.0900954329570021,0.0679529498380942,0.0526822714656782,0.0430887015773504,0.0380449266593047,0.0362015782104566,0.0361867026216357,0.0369624242039427,0.0379129755829989,0.0387310532630642,0.0392875002055681,0.0395453408028881,0.0395122013932508,0.0392156026918759,0.0386903233587006,0.0379727291204197,0.0370970328557178,0.036094517845387,0.0349929751507034,0.0338166992847067,0.0336121185365895,0.0335191571967878,0.0333149229727694,0.0330141932095069,0.0326315415182149,0.0321794867353544,0.0316690701104404,0.0311100181569407,0.0305108839999973,0.0298898465017382,0.0292318484097091,0.028553641633265,0.0278603480392838,0.0271563997738183,0.0264456755919868,0.0257315559872075,0.0250169781298095,0.02430420325763,0.023493706428999,0.0226873659825436,0.0219027584425963,0.021112392565624,0.0203623347562156,0.0197122054680127,0.0190103977308472,0.018328542165785,0.0176682457997885,0.0170290342298315,0.016410374135178,0.0158117398711901,0.0152262850090591,0.0146656693560881,0.0141242636540344,0.0136009351489045,0.0130944159825915,0.0126121488504006,0.0121380119329156,0.0116798254015767,0.0112315301235836,0.0108040966052367,0.0103923207487864,0.00999520188520515,0.00961220428730636,0.00924051700774145,0.00886477594661837,0.00852442044437749,0.00818770900372676,0.00786679453386089,0.00755849967608126,0.00726182299196856,0.00697625960941014]
@test_approx_eq cv.lambda[indmin(cv.meanloss)] 0.0004835015175294886

## POISSON
df_true = [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6]
dev_ratio = [2.10776820091544e-15,0.129499719201302,0.239325227393499,0.332756261637284,0.412419034330521,0.480447537636416,0.538597411801271,0.588328162818986,0.630863724924858,0.667237894689116,0.69832899036659,0.724886715537185,0.747552190988958,0.766879176679815,0.783341347630716,0.797347629076165,0.809250481079259,0.819353708820943,0.827867126722369,0.835129029028939,0.841271292889768,0.846459986169433,0.850838203184118,0.854528529849663,0.857635809191639,0.860249563071499,0.862446106023579,0.864290388358122,0.865837600747228,0.87024882370441,0.877838953536573,0.887048285858874,0.894821137912394,0.901533254197496,0.908005870885221,0.913975691849986,0.919004729966386,0.923239050540764,0.926802391152063,0.929856128747474,0.932438106932731,0.934609596967992,0.936434631876595,0.937967462237984,0.939246396953886,0.940326244894833,0.94123167999682,0.94199023178731,0.942625338546279,0.943156780499723,0.943596822001636,0.943968773522655,0.944279719090146,0.944539403174367,0.94475303637534,0.944934203202931,0.945085491710908,0.945211649758519,0.945314660880556,0.94540245165069,0.945475746712709,0.945535086694157,0.945586015306406,0.945628578314843,0.945664021548074,0.945692375897329,0.945716936034065,0.945737508360072,0.945753733472061]
lambda = [31.828916949571,29.0013236919422,26.4249260261475,24.0774084281324,21.9384378234955,19.9894874721244,18.2136764984369,16.5956236773117,15.1213142092748,13.7779783310111,12.5539807097836,11.4387196637471,10.4225353352523,9.49662602177952,8.6529719398027,7.88426576126062,7.18384932097722,6.54565594681999,5.96415791308824,5.43431856199749,4.95154867855919,4.511666740996,4.1108627024005,3.74566498993161,3.41291043571138,3.1097168789781,2.83345820218854,2.58174158484415,2.35238677802457,2.1434072201145,1.95299283015737,1.77949432979998,1.62140895803243,1.47736745499118,1.34612220208509,1.2265364157201,1.11757430102354,1.01829208028445,0.927829818402553,0.845403974541804,0.770300615474499,0.701869231833202,0.639517103709802,0.582704166799218,0.530938334620755,0.483771236300415,0.440794332996884,0.40163537933353,0.365955199187029,0.333444747906046,0.303822435514307,0.276831687712937,0.252238723556622,0.229830530554905,0.209413019659892,0.190809344159774,0.173858367917209,0.158413269685185,0.144340271411619,0.131517479517869,0.119833829114864,0.109188122012172,0.0994881501876848,0.0906498971258426,0.0825968101067684,0.0752591371432308,0.0685733228222997,0.0624814578187638,0.0569307773122585]
a0 = [3.90600493310258,3.81615915287671,3.7296257400607,3.64635863874153,3.56633117205771,3.48952773267281,3.41593759318923,3.34555023117952,3.27835180534108,3.21432253879281,3.15343485615309,3.09565215455879,3.0409309303677,2.98920981521004,2.94042506772435,2.89450138100357,2.85135497197824,2.81089451459511,2.77326369602453,2.73785515894495,2.70482313685092,2.67406100995043,2.64545699541384,2.61889854554542,2.59427340316953,2.57147051013186,2.55038080090296,2.53089787905072,2.51291857818673,2.52550542082938,2.56714966854802,2.62798052445864,2.68348283424091,2.73447408488909,2.7637781406602,2.77781761543208,2.7907394251353,2.80270647930086,2.81379257524928,2.82388625976162,2.83323853310462,2.84192239314805,2.84997766574341,2.85744356769894,2.86427333689674,2.8706683385745,2.87658286366337,2.88204558215813,2.88708645522167,2.89173406815677,2.89592519702993,2.89986670463064,2.90349677187641,2.90683396068613,2.90980494186521,2.91261921980539,2.91520770608182,2.91758204956143,2.91966398048419,2.92165606430228,2.92348868389537,2.92506743758983,2.9265985653882,2.92801059174214,2.92930338808513,2.93038947157531,2.93146131254934,2.93245469378524,2.93326333724211]
betas = [0.00000000000000000 -0.0066873359849929682 -0.0077845592006229557
         0.00000000000000000  0.0002507962038842651  0.0004117855769762398
         0.00000000000000000 -0.0053947765627613622 -0.0064339448768741484
         0.00000000000000000  0.0023364619386537213  0.0029034875586347879
         0.00000000000000000 -0.0043227868018046491 -0.0051301925856918635
         0.01281032818820803  0.0302846637885923545  0.0318823278949361619]

path = glmnet(X, y, Poisson())
@test nactive(path.betas) == df_true
@test_approx_eq path.dev_ratio dev_ratio
@test_approx_eq path.lambda lambda
@test_approx_eq path.a0 a0
@test_approx_eq path.betas[:, models] betas
@test_approx_eq predict(path, X, 16) [3.195043339285695,4.063275663211828,4.430604723334422,4.230243417813007,3.061469135604752,3.979791785911238,4.113365989592181,3.195043339285695,4.413907947874304,2.927894931923808]
@test_approx_eq predict(path, X, 62) [2.108607974403907,4.125962319203899,4.481867295351227,4.492300995443095,2.410180465556811,4.082152789977005,4.183424906852268,2.381251991983247,4.446875861428943,2.829218161240957]

# Make sure we can handle zeros in data
path = glmnet([1 1; 2 2; 3 4], [0, 0, 1], Poisson())
@test !any(isnan(GLMNet.loss(path, [1 1; 2 2; 4 4], [0, 0, 1])))

# Cross-validation
cv = glmnetcv(X, y, Poisson(); folds=[1,1,1,1,2,2,2,3,3,3])
@test_approx_eq cv.meanloss [29.7515432302351,26.9128224177608,23.2024175329887,20.1012770470289,17.5025174320807,15.3217890739747,13.4912722269543,11.9556272690486,10.6691459920728,9.59369850809317,8.69722143042285,7.95258991548616,7.33673351810465,6.82995026084187,6.41541967540457,6.0787261954151,5.80752947794416,5.5928000772443,5.43265831176434,5.37440262046897,5.35141704017946,5.35738075147372,5.41839073328288,5.50358645211099,5.61118760451865,5.74189696185588,5.82915774578826,6.06175190913025,6.57254958683204,7.36716065336177,8.39802765915763,9.57501032701551,10.88456865483,12.3337958292993,13.9090368622838,15.5907726781557,17.3699233918889,19.2066919027929,21.1336701550044,22.9975966545825,24.9042386067264,26.9239552447894,29.8200139130383,33.1113673955084,36.7250407581343,40.1615764718134,43.4192199067406,46.6314533468376,49.7910412446358,52.8842905798375,55.8893498009287,58.7957234860874,61.6188250270722,64.3279425332569,66.935098317955,69.3987047274251,72.3006909181736,75.4936810720162,78.6004910177112,81.5921471604477,84.4458871433569,87.168697548816,89.8025024290424,92.2583829608394,94.6072178118165,96.7973528917335,98.889028932225,100.85199839458,102.686973534136]
@test_approx_eq cv.stdloss [0.929045442985902,1.9793372349195,2.24295908393241,2.5600677172544,2.8382422486085,3.05238105931541,3.2006204604586,3.28871941433876,3.32469582300924,3.31689989419443,3.27330386611427,3.2012580979422,3.10739247435709,2.99766614596957,2.87736710828526,2.75117047993348,2.62316941740516,2.49746675065126,2.36954282868792,2.21563300734029,2.0811001612364,1.97124613304679,1.92335487712492,1.91007201179998,1.91321450839458,1.92862489486617,2.00382128288819,1.97652381864096,1.83640173508678,1.6339613691988,1.41241513491217,1.42333233354805,1.6767196334075,2.15405628913207,2.80169453718841,3.57754363653747,4.45859366906664,5.41494964476543,6.45978309072323,7.55953304656567,8.73452488894318,9.98163271349227,11.2852147440033,12.8089595236019,14.5196142858428,16.2227023806985,17.9159069154244,19.5933569308061,21.2529745816155,22.8871609031234,24.4884304660586,26.0392267883189,27.5562067593993,29.0252121690157,30.4420225903754,31.7881951118393,33.0983238093267,34.3586704629462,35.5839385054062,36.7477618643608,37.8623065808433,38.9298616880719,39.96822172491,40.942379819046,41.8717798806583,42.7470115700663,43.5811301275153,44.3783103885374,45.1212386961703]
@test_approx_eq cv.lambda[indmin(cv.meanloss)] 4.951548678559192

## COMPRESSEDPREDICTORMATRIX
betas = path.betas
cbetas = convert(Matrix, path.betas)
for j = 1:size(betas, 2), i = 1:size(betas, 1)
    @assert betas[i, j] == cbetas[i, j]
    @assert betas[1:i, j] == cbetas[1:i, j]
    @assert betas[i:end, j] == cbetas[i:end, j]
    @assert betas[i, 1:j] == cbetas[i, 1:j]
    @assert betas[i, j:end] == cbetas[i, j:end]
    @assert betas[1:i, 1:j] == cbetas[1:i, 1:j]
    @assert betas[i:end, j:end] == cbetas[i:end, j:end]
end