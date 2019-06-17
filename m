Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4029348FB0
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfFQTjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:39:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33426 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727419AbfFQTjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:39:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJULbs012666;
        Mon, 17 Jun 2019 12:39:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ifgI2NMkL05mi1uQ/pxiyA75aOBiuoCaHSsvUrvsZww=;
 b=fULs18cWLEqt+ipYVrlqZDfWAUm/qap0QtphxsLLu/Sb4s7JeyJ1AOnPkeb5H3Yd7B12
 iA5LrATlAZpyBgO4aW9TYPoLHcEGI+tHeS8hKud9mJEhcxUsHsMwae+zR5QIuziEZIkb
 qYLf38RZPKV3g5/9Eg14ut/cAVlQp3c0Dm4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6a3hsn9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 12:39:28 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 17 Jun 2019 12:39:26 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Jun 2019 12:39:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifgI2NMkL05mi1uQ/pxiyA75aOBiuoCaHSsvUrvsZww=;
 b=oijJdugBqswHILqWrqTL60wQBzPTUZ2Wk03l0WiV6zmJtW1GV00gpBhpqx+zWJV1QJrSIkp5mkCjRG6UKdpt7wUaqBjJZHnnAG/j8+b7w9o95rf9ASR06Exg9Zl/Xa26C+KX0ZS6U3zPP1SX1x5aJilRw9QBdaD+x2yKyyNRqD4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1389.namprd15.prod.outlook.com (10.173.235.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Mon, 17 Jun 2019 19:39:24 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:39:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 04/11] libbpf: refactor map initialization
Thread-Topic: [PATCH v2 bpf-next 04/11] libbpf: refactor map initialization
Thread-Index: AQHVJULQfOUezYoyDUq1vfcmTui9yqagPjSA
Date:   Mon, 17 Jun 2019 19:39:24 +0000
Message-ID: <ABF2D537-3BE9-4225-B2F5-DD7695F61F43@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
 <20190617192700.2313445-5-andriin@fb.com>
In-Reply-To: <20190617192700.2313445-5-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:da81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86dd47d9-65b8-44cd-2c17-08d6f35b80cf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1389;
x-ms-traffictypediagnostic: MWHPR15MB1389:
x-microsoft-antispam-prvs: <MWHPR15MB13891F3FFCE9568BB9D38E43B3EB0@MWHPR15MB1389.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:45;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(39860400002)(346002)(136003)(189003)(199004)(66946007)(476003)(50226002)(37006003)(30864003)(54906003)(14444005)(305945005)(53546011)(57306001)(316002)(76176011)(6506007)(14454004)(102836004)(7736002)(86362001)(81156014)(8676002)(81166006)(5660300002)(478600001)(6246003)(2906002)(36756003)(6862004)(186003)(6512007)(46003)(8936002)(66446008)(64756008)(66556008)(11346002)(66476007)(446003)(68736007)(4326008)(33656002)(99286004)(6486002)(229853002)(6436002)(71190400001)(6116002)(71200400001)(53936002)(76116006)(73956011)(25786009)(2616005)(486006)(256004)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1389;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W/kY4lunFJagxxbsmZzg2lMfOiiYHVw2Dy9nIlCNldjvOvdDuKQVxx8FhXnf+RBuHbIfFxkPx6fcAgiGMgcg4f/r7hgPJ7wT+mMVfIPtpAcTvkg2zUyNLG9QCR5sdPxSCvsMspN4ykkWHLDzqI6xIU3INDB0W4Ny9+YgcrnEw62+JlQ2XTNNSQ2AzlfldmdpHf3pfWoLxB5tseG0M5zSYxewhfRc7r3ilKZt5bEoIsA0oc0s4W0hc5MPqv8bPsc63Aw0xAf6JKYT7yIA3DO8EgWTeuKz46k8V0g6GTDto7MeLf+grx88hOXycwPVFJUXj23QcUZdtpHEVcO1/L0sA3IDhUFtwecCph+djJelyuFCo5UfMYNsJnSHuzGK+6QZmYUvTuWdtcvBadpgJXfHGr64/yxJWr8Y5UJ+UCf15eg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <85308078E1BC674A937490E1B1C4C7B9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 86dd47d9-65b8-44cd-2c17-08d6f35b80cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:39:24.5756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1389
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 17, 2019, at 12:26 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> User and global data maps initialization has gotten pretty complicated
> and unnecessarily convoluted. This patch splits out the logic for global
> data map and user-defined map initialization. It also removes the
> restriction of pre-calculating how many maps will be initialized,
> instead allowing to keep adding new maps as they are discovered, which
> will be used later for BTF-defined map definitions.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/lib/bpf/libbpf.c | 247 ++++++++++++++++++++++-------------------
> 1 file changed, 133 insertions(+), 114 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7ee44d8877c5..88609dca4f7d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -234,6 +234,7 @@ struct bpf_object {
> 	size_t nr_programs;
> 	struct bpf_map *maps;
> 	size_t nr_maps;
> +	size_t maps_cap;
> 	struct bpf_secdata sections;
>=20
> 	bool loaded;
> @@ -763,21 +764,51 @@ int bpf_object__variable_offset(const struct bpf_ob=
ject *obj, const char *name,
> 	return -ENOENT;
> }
>=20
> -static bool bpf_object__has_maps(const struct bpf_object *obj)
> +static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
> {
> -	return obj->efile.maps_shndx >=3D 0 ||
> -	       obj->efile.data_shndx >=3D 0 ||
> -	       obj->efile.rodata_shndx >=3D 0 ||
> -	       obj->efile.bss_shndx >=3D 0;
> +	struct bpf_map *new_maps;
> +	size_t new_cap;
> +	int i;
> +
> +	if (obj->nr_maps < obj->maps_cap)
> +		return &obj->maps[obj->nr_maps++];
> +
> +	new_cap =3D max(4ul, obj->maps_cap * 3 / 2);
> +	new_maps =3D realloc(obj->maps, new_cap * sizeof(*obj->maps));
> +	if (!new_maps) {
> +		pr_warning("alloc maps for object failed\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	obj->maps_cap =3D new_cap;
> +	obj->maps =3D new_maps;
> +
> +	/* zero out new maps */
> +	memset(obj->maps + obj->nr_maps, 0,
> +	       (obj->maps_cap - obj->nr_maps) * sizeof(*obj->maps));
> +	/*
> +	 * fill all fd with -1 so won't close incorrect fd (fd=3D0 is stdin)
> +	 * when failure (zclose won't close negative fd)).
> +	 */
> +	for (i =3D obj->nr_maps; i < obj->maps_cap; i++) {
> +		obj->maps[i].fd =3D -1;
> +		obj->maps[i].inner_map_fd =3D -1;
> +	}
> +
> +	return &obj->maps[obj->nr_maps++];
> }
>=20
> static int
> -bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *ma=
p,
> -			      enum libbpf_map_type type, Elf_Data *data,
> -			      void **data_buff)
> +bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_ty=
pe type,
> +			      Elf_Data *data, void **data_buff)
> {
> -	struct bpf_map_def *def =3D &map->def;
> 	char map_name[BPF_OBJ_NAME_LEN];
> +	struct bpf_map_def *def;
> +	struct bpf_map *map;
> +
> +	map =3D bpf_object__add_map(obj);
> +	if (IS_ERR(map))
> +		return PTR_ERR(map);
>=20
> 	map->libbpf_type =3D type;
> 	map->offset =3D ~(typeof(map->offset))0;
> @@ -789,6 +820,7 @@ bpf_object__init_internal_map(struct bpf_object *obj,=
 struct bpf_map *map,
> 		return -ENOMEM;
> 	}
>=20
> +	def =3D &map->def;
> 	def->type =3D BPF_MAP_TYPE_ARRAY;
> 	def->key_size =3D sizeof(int);
> 	def->value_size =3D data->d_size;
> @@ -808,29 +840,58 @@ bpf_object__init_internal_map(struct bpf_object *ob=
j, struct bpf_map *map,
> 	return 0;
> }
>=20
> -static int bpf_object__init_maps(struct bpf_object *obj, int flags)
> +static int bpf_object__init_global_data_maps(struct bpf_object *obj)
> +{
> +	int err;
> +
> +	if (!obj->caps.global_data)
> +		return 0;
> +	/*
> +	 * Populate obj->maps with libbpf internal maps.
> +	 */
> +	if (obj->efile.data_shndx >=3D 0) {
> +		err =3D bpf_object__init_internal_map(obj, LIBBPF_MAP_DATA,
> +						    obj->efile.data,
> +						    &obj->sections.data);
> +		if (err)
> +			return err;
> +	}
> +	if (obj->efile.rodata_shndx >=3D 0) {
> +		err =3D bpf_object__init_internal_map(obj, LIBBPF_MAP_RODATA,
> +						    obj->efile.rodata,
> +						    &obj->sections.rodata);
> +		if (err)
> +			return err;
> +	}
> +	if (obj->efile.bss_shndx >=3D 0) {
> +		err =3D bpf_object__init_internal_map(obj, LIBBPF_MAP_BSS,
> +						    obj->efile.bss, NULL);
> +		if (err)
> +			return err;
> +	}
> +	return 0;
> +}
> +
> +static int bpf_object__init_user_maps(struct bpf_object *obj, bool stric=
t)
> {
> -	int i, map_idx, map_def_sz =3D 0, nr_syms, nr_maps =3D 0, nr_maps_glob =
=3D 0;
> -	bool strict =3D !(flags & MAPS_RELAX_COMPAT);
> 	Elf_Data *symbols =3D obj->efile.symbols;
> +	int i, map_def_sz =3D 0, nr_maps =3D 0, nr_syms;
> 	Elf_Data *data =3D NULL;
> -	int ret =3D 0;
> +	Elf_Scn *scn;
> +
> +	if (obj->efile.maps_shndx < 0)
> +		return 0;
>=20
> 	if (!symbols)
> 		return -EINVAL;
> -	nr_syms =3D symbols->d_size / sizeof(GElf_Sym);
> -
> -	if (obj->efile.maps_shndx >=3D 0) {
> -		Elf_Scn *scn =3D elf_getscn(obj->efile.elf,
> -					  obj->efile.maps_shndx);
>=20
> -		if (scn)
> -			data =3D elf_getdata(scn, NULL);
> -		if (!scn || !data) {
> -			pr_warning("failed to get Elf_Data from map section %d\n",
> -				   obj->efile.maps_shndx);
> -			return -EINVAL;
> -		}
> +	scn =3D elf_getscn(obj->efile.elf, obj->efile.maps_shndx);
> +	if (scn)
> +		data =3D elf_getdata(scn, NULL);
> +	if (!scn || !data) {
> +		pr_warning("failed to get Elf_Data from map section %d\n",
> +			   obj->efile.maps_shndx);
> +		return -EINVAL;
> 	}
>=20
> 	/*
> @@ -840,16 +901,8 @@ static int bpf_object__init_maps(struct bpf_object *=
obj, int flags)
> 	 *
> 	 * TODO: Detect array of map and report error.
> 	 */
> -	if (obj->caps.global_data) {
> -		if (obj->efile.data_shndx >=3D 0)
> -			nr_maps_glob++;
> -		if (obj->efile.rodata_shndx >=3D 0)
> -			nr_maps_glob++;
> -		if (obj->efile.bss_shndx >=3D 0)
> -			nr_maps_glob++;
> -	}
> -
> -	for (i =3D 0; data && i < nr_syms; i++) {
> +	nr_syms =3D symbols->d_size / sizeof(GElf_Sym);
> +	for (i =3D 0; i < nr_syms; i++) {
> 		GElf_Sym sym;
>=20
> 		if (!gelf_getsym(symbols, i, &sym))
> @@ -858,79 +911,56 @@ static int bpf_object__init_maps(struct bpf_object =
*obj, int flags)
> 			continue;
> 		nr_maps++;
> 	}
> -
> -	if (!nr_maps && !nr_maps_glob)
> -		return 0;
> -
> 	/* Assume equally sized map definitions */
> -	if (data) {
> -		pr_debug("maps in %s: %d maps in %zd bytes\n", obj->path,
> -			 nr_maps, data->d_size);
> -
> -		map_def_sz =3D data->d_size / nr_maps;
> -		if (!data->d_size || (data->d_size % nr_maps) !=3D 0) {
> -			pr_warning("unable to determine map definition size "
> -				   "section %s, %d maps in %zd bytes\n",
> -				   obj->path, nr_maps, data->d_size);
> -			return -EINVAL;
> -		}
> -	}
> -
> -	nr_maps +=3D nr_maps_glob;
> -	obj->maps =3D calloc(nr_maps, sizeof(obj->maps[0]));
> -	if (!obj->maps) {
> -		pr_warning("alloc maps for object failed\n");
> -		return -ENOMEM;
> -	}
> -	obj->nr_maps =3D nr_maps;
> -
> -	for (i =3D 0; i < nr_maps; i++) {
> -		/*
> -		 * fill all fd with -1 so won't close incorrect
> -		 * fd (fd=3D0 is stdin) when failure (zclose won't close
> -		 * negative fd)).
> -		 */
> -		obj->maps[i].fd =3D -1;
> -		obj->maps[i].inner_map_fd =3D -1;
> +	pr_debug("maps in %s: %d maps in %zd bytes\n",
> +		 obj->path, nr_maps, data->d_size);
> +
> +	map_def_sz =3D data->d_size / nr_maps;
> +	if (!data->d_size || (data->d_size % nr_maps) !=3D 0) {
> +		pr_warning("unable to determine map definition size "
> +			   "section %s, %d maps in %zd bytes\n",
> +			   obj->path, nr_maps, data->d_size);
> +		return -EINVAL;
> 	}
>=20
> -	/*
> -	 * Fill obj->maps using data in "maps" section.
> -	 */
> -	for (i =3D 0, map_idx =3D 0; data && i < nr_syms; i++) {
> +	/* Fill obj->maps using data in "maps" section.  */
> +	for (i =3D 0; i < nr_syms; i++) {
> 		GElf_Sym sym;
> 		const char *map_name;
> 		struct bpf_map_def *def;
> +		struct bpf_map *map;
>=20
> 		if (!gelf_getsym(symbols, i, &sym))
> 			continue;
> 		if (sym.st_shndx !=3D obj->efile.maps_shndx)
> 			continue;
>=20
> -		map_name =3D elf_strptr(obj->efile.elf,
> -				      obj->efile.strtabidx,
> +		map =3D bpf_object__add_map(obj);
> +		if (IS_ERR(map))
> +			return PTR_ERR(map);
> +
> +		map_name =3D elf_strptr(obj->efile.elf, obj->efile.strtabidx,
> 				      sym.st_name);
> 		if (!map_name) {
> 			pr_warning("failed to get map #%d name sym string for obj %s\n",
> -				   map_idx, obj->path);
> +				   i, obj->path);
> 			return -LIBBPF_ERRNO__FORMAT;
> 		}
>=20
> -		obj->maps[map_idx].libbpf_type =3D LIBBPF_MAP_UNSPEC;
> -		obj->maps[map_idx].offset =3D sym.st_value;
> +		map->libbpf_type =3D LIBBPF_MAP_UNSPEC;
> +		map->offset =3D sym.st_value;
> 		if (sym.st_value + map_def_sz > data->d_size) {
> 			pr_warning("corrupted maps section in %s: last map \"%s\" too small\n"=
,
> 				   obj->path, map_name);
> 			return -EINVAL;
> 		}
>=20
> -		obj->maps[map_idx].name =3D strdup(map_name);
> -		if (!obj->maps[map_idx].name) {
> +		map->name =3D strdup(map_name);
> +		if (!map->name) {
> 			pr_warning("failed to alloc map name\n");
> 			return -ENOMEM;
> 		}
> -		pr_debug("map %d is \"%s\"\n", map_idx,
> -			 obj->maps[map_idx].name);
> +		pr_debug("map %d is \"%s\"\n", i, map->name);
> 		def =3D (struct bpf_map_def *)(data->d_buf + sym.st_value);
> 		/*
> 		 * If the definition of the map in the object file fits in
> @@ -939,7 +969,7 @@ static int bpf_object__init_maps(struct bpf_object *o=
bj, int flags)
> 		 * calloc above.
> 		 */
> 		if (map_def_sz <=3D sizeof(struct bpf_map_def)) {
> -			memcpy(&obj->maps[map_idx].def, def, map_def_sz);
> +			memcpy(&map->def, def, map_def_sz);
> 		} else {
> 			/*
> 			 * Here the map structure being read is bigger than what
> @@ -959,37 +989,30 @@ static int bpf_object__init_maps(struct bpf_object =
*obj, int flags)
> 						return -EINVAL;
> 				}
> 			}
> -			memcpy(&obj->maps[map_idx].def, def,
> -			       sizeof(struct bpf_map_def));
> +			memcpy(&map->def, def, sizeof(struct bpf_map_def));
> 		}
> -		map_idx++;
> 	}
> +	return 0;
> +}
>=20
> -	if (!obj->caps.global_data)
> -		goto finalize;
> +static int bpf_object__init_maps(struct bpf_object *obj, int flags)
> +{
> +	bool strict =3D !(flags & MAPS_RELAX_COMPAT);
> +	int err;
>=20
> -	/*
> -	 * Populate rest of obj->maps with libbpf internal maps.
> -	 */
> -	if (obj->efile.data_shndx >=3D 0)
> -		ret =3D bpf_object__init_internal_map(obj, &obj->maps[map_idx++],
> -						    LIBBPF_MAP_DATA,
> -						    obj->efile.data,
> -						    &obj->sections.data);
> -	if (!ret && obj->efile.rodata_shndx >=3D 0)
> -		ret =3D bpf_object__init_internal_map(obj, &obj->maps[map_idx++],
> -						    LIBBPF_MAP_RODATA,
> -						    obj->efile.rodata,
> -						    &obj->sections.rodata);
> -	if (!ret && obj->efile.bss_shndx >=3D 0)
> -		ret =3D bpf_object__init_internal_map(obj, &obj->maps[map_idx++],
> -						    LIBBPF_MAP_BSS,
> -						    obj->efile.bss, NULL);
> -finalize:
> -	if (!ret)
> +	err =3D bpf_object__init_user_maps(obj, strict);
> +	if (err)
> +		return err;
> +
> +	err =3D bpf_object__init_global_data_maps(obj);
> +	if (err)
> +		return err;
> +
> +	if (obj->nr_maps) {
> 		qsort(obj->maps, obj->nr_maps, sizeof(obj->maps[0]),
> 		      compare_bpf_map);
> -	return ret;
> +	}
> +	return 0;
> }
>=20
> static bool section_have_execinstr(struct bpf_object *obj, int idx)
> @@ -1262,14 +1285,10 @@ static int bpf_object__elf_collect(struct bpf_obj=
ect *obj, int flags)
> 		return -LIBBPF_ERRNO__FORMAT;
> 	}
> 	err =3D bpf_object__load_btf(obj, btf_data, btf_ext_data);
> -	if (err)
> -		return err;
> -	if (bpf_object__has_maps(obj)) {
> +	if (!err)
> 		err =3D bpf_object__init_maps(obj, flags);
> -		if (err)
> -			return err;
> -	}
> -	err =3D bpf_object__init_prog_names(obj);
> +	if (!err)
> +		err =3D bpf_object__init_prog_names(obj);
> 	return err;
> }
>=20
> --=20
> 2.17.1
>=20

