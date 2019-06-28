Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E063F5A353
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF1SRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:17:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbfF1SRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:17:48 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SI8GdM023245;
        Fri, 28 Jun 2019 11:17:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rKLXyhwPJ8DvlDYBE04m+2fG0urhZpm8XuJRfzeN3Mg=;
 b=USg9ryh81cBONbO6xUFlRqv0XZKzCpyqs1gmbG+P53fgW6eUe918Zd/EZUUNwdPiBe5L
 hugLh0kc1fpMgodKRfsKTJMJKHIJ0U1J/cbwyPxYgxtQV806iCgr8xKPOKdqoAzdH+VS
 CJSMYegC+Jz4OxGB/NVeKGN4l5CYsVBAnjA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdgdkht2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 Jun 2019 11:17:28 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 11:17:26 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Jun 2019 11:17:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=BLO9N7wco1a3Det+aADrd5h/TLgDrGY5JhYp6jZ+/f4oNk3ZQNc5MqdxKjbcAden+JbBSXKq37oh2iIdj5Fr5ogOORXGeRnBCVwm1p6w2C0LTs58tAFFTzIQIBeKR1kYlqwhurhibm9r83qqfcTFtrl8H2M01xuV3pAknIKVdec=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKLXyhwPJ8DvlDYBE04m+2fG0urhZpm8XuJRfzeN3Mg=;
 b=NqF6rFJ47d13gztLujM+dZgPbBlYLnmmCFc+dx2YAciLWEmnO55/Cb8rozzwazL5AvI1MkG4+RwokaVsgbzWBKP7/2nbHLuQVfFIDyGWJCyPFgxYppsRgf2s4LKXODFlfN+2W0vWlzNg3RB/GpynbLPqoJJDLANINZV1tBhrK0k=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKLXyhwPJ8DvlDYBE04m+2fG0urhZpm8XuJRfzeN3Mg=;
 b=pokMEbUFBhlBFvDbQdTI01EDWlKmPkPDZLiiSklplpfD8nOAslHOGh4RjHuFt0N71/E9DjXQemjBKQwqK6HyNRAB8NaYqDcJk+oec+iVa7iSHEw+8HLEwjf7dzMb4KD224/OOT61Q+deQIEZHxTAiC0dNFUZYhqX4WbG3lj07s8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1677.namprd15.prod.outlook.com (10.175.135.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 18:17:25 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Fri, 28 Jun 2019
 18:17:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] libbpf: capture value in BTF type info
 for BTF-defined map defs
Thread-Topic: [PATCH v2 bpf-next 1/4] libbpf: capture value in BTF type info
 for BTF-defined map defs
Thread-Index: AQHVLcXFbLN1ePIFZUiVbnESdM/pZ6axX+wA
Date:   Fri, 28 Jun 2019 18:17:25 +0000
Message-ID: <EDAC3B34-D613-4169-9BEB-6FEDC9122A32@fb.com>
References: <20190628152539.3014719-1-andriin@fb.com>
 <20190628152539.3014719-2-andriin@fb.com>
In-Reply-To: <20190628152539.3014719-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52e7c636-4ac3-4a70-bf76-08d6fbf4df1e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1677;
x-ms-traffictypediagnostic: MWHPR15MB1677:
x-microsoft-antispam-prvs: <MWHPR15MB16772D837A3AEB9B06BAC638B3FC0@MWHPR15MB1677.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:12;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(366004)(396003)(376002)(199004)(189003)(73956011)(71190400001)(36756003)(11346002)(6862004)(8936002)(81166006)(6506007)(86362001)(486006)(81156014)(8676002)(57306001)(446003)(5660300002)(478600001)(76176011)(99286004)(6246003)(102836004)(53546011)(68736007)(476003)(4326008)(6116002)(6636002)(46003)(2906002)(305945005)(14454004)(7736002)(25786009)(229853002)(64756008)(66556008)(2616005)(186003)(66476007)(50226002)(6486002)(76116006)(6436002)(316002)(37006003)(66946007)(6512007)(256004)(14444005)(71200400001)(33656002)(66446008)(53936002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1677;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nF4Uzs5UDQmg0lz4vHITqYBCMEmauk+pcTdySaAvdyjDzoiTRGyuDJu6f1Q47kXf31A3HES0HgOg2CCLbiZP1i5TCChgOkb4N1EZ6UW6ORuykGT9IK82jatu9p24GGluGwIKA36WwxiVo8nzKrCRkEX7OpssNR/ShuAAb5Va1uGbKudnoClX3Q5VT5+c10iCr57bnQg63Lnajtcc3iQm8EK3HSP0fQMhN1wyZzhvPHgMrwMR5ETu7VEWLdbGEU1UP/e8B63t6cb4YJGCY+EqZJZFt1nJA7/eR2v0P0Mzcm2dtgcEVYQucIPpYQ7Ot+Z/zq7N2FSeTHUKy0eCC6Mt9IZvgZNax0/AHk13WVf29A0FxDGlKTYmReqWLH16FqfRy3MwSvaVV8SWJ/jLwFUAyZSs0HBrL/54GfL6TGZow7w=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <721A5A6047E2F041A25B5727606553EF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e7c636-4ac3-4a70-bf76-08d6fbf4df1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 18:17:25.1228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1677
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 28, 2019, at 8:25 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Change BTF-defined map definitions to capture compile-time integer
> values as part of BTF type definition, to avoid split of key/value type
> information and actual type/size/flags initialization for maps.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/lib/bpf/libbpf.c | 58 ++++++++++++++++++++----------------------
> 1 file changed, 28 insertions(+), 30 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6e6ebef11ba3..9e099ecb2c2b 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1028,40 +1028,40 @@ static const struct btf_type *skip_mods_and_typed=
efs(const struct btf *btf,
> 	}
> }
>=20
> -static bool get_map_field_int(const char *map_name,
> -			      const struct btf *btf,
> +/*
> + * Fetch integer attribute of BTF map definition. Such attributes are
> + * represented using a pointer to an array, in which dimensionality of a=
rray
> + * encodes specified integer value. E.g., int (*type)[BPF_MAP_TYPE_ARRAY=
];
> + * encodes `type =3D> BPF_MAP_TYPE_ARRAY` key/value pair completely usin=
g BTF
> + * type definition, while using only sizeof(void *) space in ELF data se=
ction.
> + */
> +static bool get_map_field_int(const char *map_name, const struct btf *bt=
f,
> 			      const struct btf_type *def,
> -			      const struct btf_member *m,
> -			      const void *data, __u32 *res) {
> +			      const struct btf_member *m, __u32 *res) {
> 	const struct btf_type *t =3D skip_mods_and_typedefs(btf, m->type);
> 	const char *name =3D btf__name_by_offset(btf, m->name_off);
> -	__u32 int_info =3D *(const __u32 *)(const void *)(t + 1);
> +	const struct btf_array *arr_info;
> +	const struct btf_type *arr_t;
>=20
> -	if (BTF_INFO_KIND(t->info) !=3D BTF_KIND_INT) {
> -		pr_warning("map '%s': attr '%s': expected INT, got %u.\n",
> +	if (BTF_INFO_KIND(t->info) !=3D BTF_KIND_PTR) {
> +		pr_warning("map '%s': attr '%s': expected PTR, got %u.\n",
> 			   map_name, name, BTF_INFO_KIND(t->info));
> 		return false;
> 	}
> -	if (t->size !=3D 4 || BTF_INT_BITS(int_info) !=3D 32 ||
> -	    BTF_INT_OFFSET(int_info)) {
> -		pr_warning("map '%s': attr '%s': expected 32-bit non-bitfield integer,=
 "
> -			   "got %u-byte (%d-bit) one with bit offset %d.\n",
> -			   map_name, name, t->size, BTF_INT_BITS(int_info),
> -			   BTF_INT_OFFSET(int_info));
> -		return false;
> -	}
> -	if (BTF_INFO_KFLAG(def->info) && BTF_MEMBER_BITFIELD_SIZE(m->offset)) {
> -		pr_warning("map '%s': attr '%s': bitfield is not supported.\n",
> -			   map_name, name);
> +
> +	arr_t =3D btf__type_by_id(btf, t->type);
> +	if (!arr_t) {
> +		pr_warning("map '%s': attr '%s': type [%u] not found.\n",
> +			   map_name, name, t->type);
> 		return false;
> 	}
> -	if (m->offset % 32) {
> -		pr_warning("map '%s': attr '%s': unaligned fields are not supported.\n=
",
> -			   map_name, name);
> +	if (BTF_INFO_KIND(arr_t->info) !=3D BTF_KIND_ARRAY) {
> +		pr_warning("map '%s': attr '%s': expected ARRAY, got %u.\n",
> +			   map_name, name, BTF_INFO_KIND(arr_t->info));
> 		return false;
> 	}
> -
> -	*res =3D *(const __u32 *)(data + m->offset / 8);
> +	arr_info =3D (const void *)(arr_t + 1);
> +	*res =3D arr_info->nelems;
> 	return true;
> }
>=20
> @@ -1074,7 +1074,6 @@ static int bpf_object__init_user_btf_map(struct bpf=
_object *obj,
> 	const struct btf_var_secinfo *vi;
> 	const struct btf_var *var_extra;
> 	const struct btf_member *m;
> -	const void *def_data;
> 	const char *map_name;
> 	struct bpf_map *map;
> 	int vlen, i;
> @@ -1131,7 +1130,6 @@ static int bpf_object__init_user_btf_map(struct bpf=
_object *obj,
> 	pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
> 		 map_name, map->sec_idx, map->sec_offset);
>=20
> -	def_data =3D data->d_buf + vi->offset;
> 	vlen =3D BTF_INFO_VLEN(def->info);
> 	m =3D (const void *)(def + 1);
> 	for (i =3D 0; i < vlen; i++, m++) {
> @@ -1144,19 +1142,19 @@ static int bpf_object__init_user_btf_map(struct b=
pf_object *obj,
> 		}
> 		if (strcmp(name, "type") =3D=3D 0) {
> 			if (!get_map_field_int(map_name, obj->btf, def, m,
> -					       def_data, &map->def.type))
> +					       &map->def.type))
> 				return -EINVAL;
> 			pr_debug("map '%s': found type =3D %u.\n",
> 				 map_name, map->def.type);
> 		} else if (strcmp(name, "max_entries") =3D=3D 0) {
> 			if (!get_map_field_int(map_name, obj->btf, def, m,
> -					       def_data, &map->def.max_entries))
> +					       &map->def.max_entries))
> 				return -EINVAL;
> 			pr_debug("map '%s': found max_entries =3D %u.\n",
> 				 map_name, map->def.max_entries);
> 		} else if (strcmp(name, "map_flags") =3D=3D 0) {
> 			if (!get_map_field_int(map_name, obj->btf, def, m,
> -					       def_data, &map->def.map_flags))
> +					       &map->def.map_flags))
> 				return -EINVAL;
> 			pr_debug("map '%s': found map_flags =3D %u.\n",
> 				 map_name, map->def.map_flags);
> @@ -1164,7 +1162,7 @@ static int bpf_object__init_user_btf_map(struct bpf=
_object *obj,
> 			__u32 sz;
>=20
> 			if (!get_map_field_int(map_name, obj->btf, def, m,
> -					       def_data, &sz))
> +					       &sz))
> 				return -EINVAL;
> 			pr_debug("map '%s': found key_size =3D %u.\n",
> 				 map_name, sz);
> @@ -1207,7 +1205,7 @@ static int bpf_object__init_user_btf_map(struct bpf=
_object *obj,
> 			__u32 sz;
>=20
> 			if (!get_map_field_int(map_name, obj->btf, def, m,
> -					       def_data, &sz))
> +					       &sz))
> 				return -EINVAL;
> 			pr_debug("map '%s': found value_size =3D %u.\n",
> 				 map_name, sz);
> --=20
> 2.17.1
>=20

