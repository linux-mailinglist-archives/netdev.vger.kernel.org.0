Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3120358850
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfF0R2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:28:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbfF0R2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:28:14 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RHP1ao017069;
        Thu, 27 Jun 2019 10:27:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tTJIK2Lr7P8tnwHcRPyoHTQzPlNCeWpFT/JkX6/uR+4=;
 b=LLmPssdRMU7DAcEDeE+X1yW/yaRVpX56WJuT0xAiQHuj6VRxLkN0Pcr5lt6Cman7isem
 7+B2JCtNZ6AZmI6e8DGbJWP88KwQgn7dx0Rx2tNLRMl/Ru/+FwHuo/NLajZO8md94kza
 jwUQacO2ccgPTiluvbrv+zndyW3wBbnzG6Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2td0y50c8y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Jun 2019 10:27:53 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 10:27:51 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Jun 2019 10:27:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=qVnRU9EDpJ4R3wbEGin5YDweyhBOhYjzZ8/uWEUl/pHUQHc9hVN0GW31754q6bmEjO1VipnuQN2FlTJOFXnZpr+15YHyqMxGO6FNs0o5Aktja9gkhQ9CmuQ39g2zi5iTiXClMtoT47srasLaT4xCi00LHtup2+xImTVsptw94yQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTJIK2Lr7P8tnwHcRPyoHTQzPlNCeWpFT/JkX6/uR+4=;
 b=UTUbW+AuLzl2+zML/+hSvTSYMYWuCc0NY2mv3gxJO5PD2CxpV8wD1gO4mdFA8b5AxF4tABZ+Yv4mzD0rQITyYiIJDIzUOyAeWCdL8OTAx3BTJrpJ5d9GXNuqYtaFHU5KwxDSmMlFtCYeLqHTB7cTHLof5FDoqd78AKLnFJpLMWg=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTJIK2Lr7P8tnwHcRPyoHTQzPlNCeWpFT/JkX6/uR+4=;
 b=AxpDy+j/8ibV0xly/uh9vBiBFV2stnHfsr09nismtBF0v4GgepWqxzm3oUixlk6Y1h6K/7i6XPVnq510TYj3yDYurUI8aJqHMkFbn9XlNQg5oJUEZeJ/AJ0S5ZweMaeT008H2+kNe5AmOqDq+ErvEN0y6uBlsTKYtDHFLXA+QoI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1342.namprd15.prod.outlook.com (10.175.2.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 17:27:49 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 17:27:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: capture value in BTF type info for
 BTF-defined map defs
Thread-Topic: [PATCH bpf-next 1/3] libbpf: capture value in BTF type info for
 BTF-defined map defs
Thread-Index: AQHVLHX5c/0tlkdQh02ogvUGijo9IKavwlqA
Date:   Thu, 27 Jun 2019 17:27:48 +0000
Message-ID: <E28D922F-9D97-4836-B687-B4CBC3549AE1@fb.com>
References: <20190626232133.3800637-1-andriin@fb.com>
 <20190626232133.3800637-2-andriin@fb.com>
In-Reply-To: <20190626232133.3800637-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:a913]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 670440ec-77b8-49a0-547f-08d6fb24c6be
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1342;
x-ms-traffictypediagnostic: MWHPR15MB1342:
x-microsoft-antispam-prvs: <MWHPR15MB134234E32D2F35CA892ADB68B3FD0@MWHPR15MB1342.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:24;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(136003)(346002)(376002)(189003)(199004)(478600001)(446003)(6116002)(14454004)(68736007)(2906002)(50226002)(229853002)(33656002)(476003)(486006)(53936002)(2616005)(46003)(6486002)(6636002)(6512007)(11346002)(6436002)(6862004)(186003)(6246003)(305945005)(7736002)(66476007)(99286004)(76116006)(71200400001)(71190400001)(66946007)(66446008)(57306001)(64756008)(66556008)(73956011)(91956017)(25786009)(53546011)(4326008)(102836004)(6506007)(76176011)(14444005)(37006003)(54906003)(256004)(81166006)(81156014)(8936002)(86362001)(316002)(8676002)(36756003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1342;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t5J5yXZZ9hdtkdyCZVbdSAjWQLaV0xezV5nXpzY0+Kp6q+921EILOo1U9JzhZGzQq9G5Z3jYGU0gWvTfuLzLwgFqZJLX57n/qw1aRYD5079RzB0L4jDRmmAbiQPz99v6Pnn7TfNfEc4PJsKSUekcryR5pWo6x2fO0FhMz8VFngCW77z1McfxoyXgVyPQCMmiZqV7YZaCYPsMj8t2DVCy4/z6HUvavv0RVlaklYiJxRGIbBSf6zTzDTk0wl7cwjSqq+NNdc75vTwySX1iyRx9DVXcIqvVb0TW52q3GD3W+JKXy4D00sbFzvCrOyvv88j9DRJtJSpNsqvrjRIgCKvQ7drtBJmUM7DSLua8s5U54ElNASmc+HtzBSpTK7vgzGIjGJ3pRQd8sp7mHC72awyLDwvqnfyuvQPZ3qfCxve9op0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7AED6A786211A340BD3ED3897977880D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 670440ec-77b8-49a0-547f-08d6fb24c6be
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 17:27:48.8918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1342
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2019, at 4:21 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Change BTF-defined map definitions to capture compile-time integer
> values as part of BTF type definition, to avoid split of key/value type
> information and actual type/size/flags initialization for maps.

If I have an old bpf program and compiled it with new llvm, will it =20
work with new libbpf?=20


>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/libbpf.c                    | 58 +++++++++++------------
> tools/testing/selftests/bpf/bpf_helpers.h |  3 ++
> 2 files changed, 31 insertions(+), 30 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 68f45a96769f..f2b02032a8e6 100644
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
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/se=
lftests/bpf/bpf_helpers.h
> index 1a5b1accf091..aa5ddf58c088 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -8,6 +8,9 @@
>  */
> #define SEC(NAME) __attribute__((section(NAME), used))
>=20
> +#define __int(name, val) int (*name)[val]
> +#define __type(name, val) val *name
> +

I think we need these two in libbpf.=20

Thanks,
Song

> /* helper macro to print out debug messages */
> #define bpf_printk(fmt, ...)				\
> ({							\
> --=20
> 2.17.1
>=20

