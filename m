Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEC979712
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 21:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404031AbfG2T5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 15:57:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59250 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404020AbfG2T5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 15:57:44 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6TJdtbJ029032;
        Mon, 29 Jul 2019 12:57:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rQEcIiVelYSw7+wTuHgSxj3hfykuAMrpSXFF737tWzg=;
 b=FG14Rr89WCrzkeSCHS9KYnRqeUmxjvETIMo5gCWEsn5gdcnMG4f6NigOL4hIKq7GTf92
 ValJR03UY+U0Rgo5WZuPXdBPKPfE7qvbyB3QKPOVrUhpRGo289nWihW2ktQ5O/aMxWMG
 GzRvoNBvSVmUmGvax4pnhLydPOQarclKyXU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2u234kshd4-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jul 2019 12:57:23 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 29 Jul 2019 12:56:53 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 29 Jul 2019 12:56:53 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jul 2019 12:56:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOnEhqagfUD0THy27CAcXGCisMq8RGLe2s8jP+hBCTnuEmewtYsdg3d819EtKJ5BDF5+hykQl+j7Ev7UaO9AsYot+eEcP/0XznngpLpdzMsG0ul5Tl6iqLgeRwWBrGQ/Q0cP3i+GcouA0Zsdp8RBi/8I77h8iEjKP2ZkUvnvmvKyTJgOUL2h76zM5BO5JQDhZ+wcpFtPzJN7H4Iywb7oou2zzV7lrHJvMggC/EkotK0dKM563NNXhf+5qe8LKZnd8jMk0jQQAVnDPjlIlAVJGrKFYVrVcyVdrRRUfPXdS0/NX0aIugMWRb4znn1qS5GSXLH4N+o8jINhk5Pa4JLaMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQEcIiVelYSw7+wTuHgSxj3hfykuAMrpSXFF737tWzg=;
 b=UIzrnQmDaV03ZXr7HA9kjnKMUUMpxdOuyNpVMLfSIOQbYD4wYBe8hkljeNR/9lSr17AqmQgqWrXzsMzaZzpfqsYPrTconFBxHSZUgVYlvf2Wp/yb2C8Jp4th8gHgu03UGKrEY32INnJUDDFVmnInR5ylqukBzbyGKo6in6eUOiilzRiScct8EVYYidnOrovNICmPNRqI/D+43BGx0j28nmuYxQRu41aktzhmMYdDtxvU3PqJ/JkGu14oPtGRJ5bmg4jd/5pSCs1/wz1CCBfQyMOeX3YQRVfTYZbodpa6l2lFZzEcEuq109tenVf8ZCDbzPvCbeRwjNYhbyOsq5Bjgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQEcIiVelYSw7+wTuHgSxj3hfykuAMrpSXFF737tWzg=;
 b=S0fJEVacCFBUcx6ysaI/449LjaSh/pSdwj5cXnQmgYTNuOeQENmHtHyCOSTFxKnqnydpnY83rco9CEpmHjCGMIHi0Bly9cqCjrRpm1JS8GgLMGVQSmemf/1c8K62CKxRG+b2GYdq5Z4AZKYM8u4ZD6vtGqgtRX/bD7jiDHLxo5Y=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1293.namprd15.prod.outlook.com (10.175.3.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 19:56:51 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 19:56:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Topic: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Index: AQHVQlYfQU29UbcfIEO0wFH+SyI9nKbiCtkA
Date:   Mon, 29 Jul 2019 19:56:51 +0000
Message-ID: <D2243B0B-22AE-4DD4-BB04-2EC60645D075@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-3-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2:d148]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de887129-69bc-49be-d9dc-08d7145ee5fe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1293;
x-ms-traffictypediagnostic: MWHPR15MB1293:
x-microsoft-antispam-prvs: <MWHPR15MB1293D56607E1308A7AA2659DB3DD0@MWHPR15MB1293.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(346002)(376002)(396003)(189003)(199004)(6116002)(6512007)(6246003)(99286004)(5660300002)(305945005)(25786009)(57306001)(66946007)(64756008)(66556008)(66476007)(53946003)(4326008)(53936002)(6862004)(66446008)(86362001)(76116006)(71200400001)(71190400001)(6436002)(36756003)(46003)(50226002)(8676002)(76176011)(81156014)(186003)(14454004)(14444005)(229853002)(30864003)(476003)(53546011)(6636002)(81166006)(8936002)(68736007)(486006)(37006003)(2906002)(478600001)(6506007)(54906003)(316002)(33656002)(102836004)(256004)(2616005)(6486002)(446003)(7736002)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1293;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8UpAZGhO/GzhZ4Cr4Fn6xP3Spk7M+WtceIbxX5Iilcmxk04H81T8rCseRgycyCqBfNXsSO4ucsdeTEn52YfF7yq1e2K8PQUsS4b9FXyLyXO1uUAouBO6EfsUIbLfgDGBCrrnV2tmivIrhQbtdqAn9mRbUQiECqLpJ/APmbKP+4ccCYWbFscMEauaVlQQtF+qSh+kZ1xbs6Cd9jfHi/NN8j6ZeOnPQ2lsQNs2PC064Qvrj2H5x99AvKMRAjbCIXFfMZTPtSlPWwIryffd1oo//qTYD688OgkCsNx2Sy1qCMfJXCB2AHNXHgtKDZgMOY96RqJfnmWnw1AiA4GH3Th1KLy2SKDVyRRDr4QJMuPauMmjlZgDgXecg43p/Br/gB0WcpB1xfGm3PI2vI4oEpJxcnGu43uBq+AV/WxeMxdM+yQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0B17FB4A2CE8A84FAA8203C02332E404@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: de887129-69bc-49be-d9dc-08d7145ee5fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 19:56:51.2218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1293
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907290215
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> This patch implements the core logic for BPF CO-RE offsets relocations.
> All the details are described in code comments.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/libbpf.c | 866 ++++++++++++++++++++++++++++++++++++++++-
> tools/lib/bpf/libbpf.h |   1 +
> 2 files changed, 861 insertions(+), 6 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8741c39adb1c..86d87bf10d46 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -38,6 +38,7 @@
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <sys/vfs.h>
> +#include <sys/utsname.h>
> #include <tools/libc_compat.h>
> #include <libelf.h>
> #include <gelf.h>
> @@ -47,6 +48,7 @@
> #include "btf.h"
> #include "str_error.h"
> #include "libbpf_internal.h"
> +#include "hashmap.h"
>=20
> #ifndef EM_BPF
> #define EM_BPF 247
> @@ -1013,16 +1015,22 @@ static int bpf_object__init_user_maps(struct bpf_=
object *obj, bool strict)
> }
>=20
> static const struct btf_type *skip_mods_and_typedefs(const struct btf *bt=
f,
> -						     __u32 id)
> +						     __u32 id,
> +						     __u32 *res_id)
> {
> 	const struct btf_type *t =3D btf__type_by_id(btf, id);
>=20
> +	if (res_id)
> +		*res_id =3D id;
> +
> 	while (true) {
> 		switch (BTF_INFO_KIND(t->info)) {
> 		case BTF_KIND_VOLATILE:
> 		case BTF_KIND_CONST:
> 		case BTF_KIND_RESTRICT:
> 		case BTF_KIND_TYPEDEF:
> +			if (res_id)
> +				*res_id =3D t->type;
> 			t =3D btf__type_by_id(btf, t->type);
> 			break;
> 		default:
> @@ -1041,7 +1049,7 @@ static const struct btf_type *skip_mods_and_typedef=
s(const struct btf *btf,
> static bool get_map_field_int(const char *map_name, const struct btf *btf=
,
> 			      const struct btf_type *def,
> 			      const struct btf_member *m, __u32 *res) {
> -	const struct btf_type *t =3D skip_mods_and_typedefs(btf, m->type);
> +	const struct btf_type *t =3D skip_mods_and_typedefs(btf, m->type, NULL)=
;
> 	const char *name =3D btf__name_by_offset(btf, m->name_off);
> 	const struct btf_array *arr_info;
> 	const struct btf_type *arr_t;
> @@ -1107,7 +1115,7 @@ static int bpf_object__init_user_btf_map(struct bpf=
_object *obj,
> 		return -EOPNOTSUPP;
> 	}
>=20
> -	def =3D skip_mods_and_typedefs(obj->btf, var->type);
> +	def =3D skip_mods_and_typedefs(obj->btf, var->type, NULL);
> 	if (BTF_INFO_KIND(def->info) !=3D BTF_KIND_STRUCT) {
> 		pr_warning("map '%s': unexpected def kind %u.\n",
> 			   map_name, BTF_INFO_KIND(var->info));
> @@ -2289,6 +2297,845 @@ bpf_program_reloc_btf_ext(struct bpf_program *pro=
g, struct bpf_object *obj,
> 	return 0;
> }
>=20
> +#define BPF_CORE_SPEC_MAX_LEN 64
> +
> +/* represents BPF CO-RE field or array element accessor */
> +struct bpf_core_accessor {
> +	__u32 type_id;		/* struct/union type or array element type */
> +	__u32 idx;		/* field index or array index */
> +	const char *name;	/* field name or NULL for array accessor */
> +};
> +
> +struct bpf_core_spec {
> +	const struct btf *btf;
> +	/* high-level spec: named fields and array indicies only */
> +	struct bpf_core_accessor spec[BPF_CORE_SPEC_MAX_LEN];
> +	/* high-level spec length */
> +	int len;
> +	/* raw, low-level spec: 1-to-1 with accessor spec string */
> +	int raw_spec[BPF_CORE_SPEC_MAX_LEN];
> +	/* raw spec length */
> +	int raw_len;
> +	/* field byte offset represented by spec */
> +	__u32 offset;
> +};
> +
> +static bool str_is_empty(const char *s)
> +{
> +	return !s || !s[0];
> +}
> +
> +static int btf_kind(const struct btf_type *t)
> +{
> +	return BTF_INFO_KIND(t->info);
> +}
> +
> +static bool btf_is_composite(const struct btf_type *t)
> +{
> +	int kind =3D btf_kind(t);
> +
> +	return kind =3D=3D BTF_KIND_STRUCT || kind =3D=3D BTF_KIND_UNION;
> +}
> +
> +static bool btf_is_array(const struct btf_type *t)
> +{
> +	return btf_kind(t) =3D=3D BTF_KIND_ARRAY;
> +}
> +
> +/*=20
> + * Turn bpf_offset_reloc into a low- and high-level spec representation,
> + * validating correctness along the way, as well as calculating resultin=
g
> + * field offset (in bytes), specified by accessor string. Low-level spec
> + * captures every single level of nestedness, including traversing anony=
mous
> + * struct/union members. High-level one only captures semantically meani=
ngful
> + * "turning points": named fields and array indicies.
> + * E.g., for this case:
> + *
> + *   struct sample {
> + *       int __unimportant;
> + *       struct {
> + *           int __1;
> + *           int __2;
> + *           int a[7];
> + *       };
> + *   };
> + *
> + *   struct sample *s =3D ...;
> + *
> + *   int x =3D &s->a[3]; // access string =3D '0:1:2:3'
> + *
> + * Low-level spec has 1:1 mapping with each element of access string (it=
's
> + * just a parsed access string representation): [0, 1, 2, 3].
> + *
> + * High-level spec will capture only 3 points:
> + *   - intial zero-index access by pointer (&s->... is the same as &s[0]=
...);
> + *   - field 'a' access (corresponds to '2' in low-level spec);
> + *   - array element #3 access (corresponds to '3' in low-level spec).
> + *
> + */
> +static int bpf_core_spec_parse(const struct btf *btf,
> +			       __u32 type_id,
> +			       const char *spec_str,
> +			       struct bpf_core_spec *spec)
> +{
> +	int access_idx, parsed_len, i;
> +	const struct btf_type *t;
> +	__u32 id =3D type_id;
> +	const char *name;
> +	__s64 sz;
> +
> +	if (str_is_empty(spec_str) || *spec_str =3D=3D ':')
> +		return -EINVAL;
> +
> +	memset(spec, 0, sizeof(*spec));
> +	spec->btf =3D btf;
> +
> +	/* parse spec_str=3D"0:1:2:3:4" into array raw_spec=3D[0, 1, 2, 3, 4] *=
/
> +	while (*spec_str) {
> +		if (*spec_str =3D=3D ':')
> +			++spec_str;
> +		if (sscanf(spec_str, "%d%n", &access_idx, &parsed_len) !=3D 1)
> +			return -EINVAL;
> +		if (spec->raw_len =3D=3D BPF_CORE_SPEC_MAX_LEN)
> +			return -E2BIG;
> +		spec_str +=3D parsed_len;
> +		spec->raw_spec[spec->raw_len++] =3D access_idx;
> +	}
> +
> +	if (spec->raw_len =3D=3D 0)
> +		return -EINVAL;
> +
> +	for (i =3D 0; i < spec->raw_len; i++) {
> +		t =3D skip_mods_and_typedefs(btf, id, &id);
> +		if (!t)
> +			return -EINVAL;
> +
> +		access_idx =3D spec->raw_spec[i];
> +
> +		if (i =3D=3D 0) {
> +			/* first spec value is always reloc type array index */
> +			spec->spec[spec->len].type_id =3D id;
> +			spec->spec[spec->len].idx =3D access_idx;
> +			spec->len++;
> +
> +			sz =3D btf__resolve_size(btf, id);
> +			if (sz < 0)
> +				return sz;
> +			spec->offset +=3D access_idx * sz;
> +			continue;
> +		}
> +
> +		if (btf_is_composite(t)) {
> +			const struct btf_member *m =3D (void *)(t + 1);
> +			__u32 offset;
> +
> +			if (access_idx >=3D BTF_INFO_VLEN(t->info))
> +				return -EINVAL;
> +
> +			m =3D &m[access_idx];
> +
> +			if (BTF_INFO_KFLAG(t->info)) {
> +				if (BTF_MEMBER_BITFIELD_SIZE(m->offset))
> +					return -EINVAL;
> +				offset =3D BTF_MEMBER_BIT_OFFSET(m->offset);
> +			} else {
> +				offset =3D m->offset;
> +			}
> +			if (m->offset % 8)
> +				return -EINVAL;
> +			spec->offset +=3D offset / 8;
> +
> +			if (m->name_off) {
> +				name =3D btf__name_by_offset(btf, m->name_off);
> +				if (str_is_empty(name))
> +					return -EINVAL;
> +
> +				spec->spec[spec->len].type_id =3D id;
> +				spec->spec[spec->len].idx =3D access_idx;
> +				spec->spec[spec->len].name =3D name;
> +				spec->len++;
> +			}
> +
> +			id =3D m->type;
> +		} else if (btf_is_array(t)) {
> +			const struct btf_array *a =3D (void *)(t + 1);
> +
> +			t =3D skip_mods_and_typedefs(btf, a->type, &id);
> +			if (!t || access_idx >=3D a->nelems)
> +				return -EINVAL;
> +
> +			spec->spec[spec->len].type_id =3D id;
> +			spec->spec[spec->len].idx =3D access_idx;
> +			spec->len++;
> +
> +			sz =3D btf__resolve_size(btf, id);
> +			if (sz < 0)
> +				return sz;
> +			spec->offset +=3D access_idx * sz;
> +		} else {
> +			pr_warning("relo for [%u] %s (at idx %d) captures type [%d] of unexpe=
cted kind %d\n",
> +				   type_id, spec_str, i, id, btf_kind(t));
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (spec->len =3D=3D 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/* Given 'some_struct_name___with_flavor' return the length of a name pr=
efix
> + * before last triple underscore. Struct name part after last triple
> + * underscore is ignored by BPF CO-RE relocation during relocation match=
ing.
> + */
> +static size_t bpf_core_essential_name_len(const char *name)
> +{
> +	size_t n =3D strlen(name);
> +	int i =3D n - 3;
> +
> +	while (i > 0) {
> +		if (name[i] =3D=3D '_' && name[i + 1] =3D=3D '_' && name[i + 2] =3D=3D=
 '_')
> +			return i;
> +		i--;
> +	}
> +	return n;
> +}
> +
> +/* dynamically sized list of type IDs */
> +struct ids_vec {
> +	__u32 *data;
> +	int len;
> +};
> +
> +static void bpf_core_free_cands(struct ids_vec *cand_ids)
> +{
> +	free(cand_ids->data);
> +	free(cand_ids);
> +}
> +
> +static struct ids_vec *bpf_core_find_cands(const struct btf *local_btf,
> +					   __u32 local_type_id,
> +					   const struct btf *targ_btf)
> +{
> +	size_t local_essent_len, targ_essent_len;
> +	const char *local_name, *targ_name;
> +	const struct btf_type *t;
> +	struct ids_vec *cand_ids;
> +	__u32 *new_ids;
> +	int i, err, n;
> +
> +	t =3D btf__type_by_id(local_btf, local_type_id);
> +	if (!t)
> +		return ERR_PTR(-EINVAL);
> +
> +	local_name =3D btf__name_by_offset(local_btf, t->name_off);
> +	if (str_is_empty(local_name))
> +		return ERR_PTR(-EINVAL);
> +	local_essent_len =3D bpf_core_essential_name_len(local_name);
> +
> +	cand_ids =3D calloc(1, sizeof(*cand_ids));
> +	if (!cand_ids)
> +		return ERR_PTR(-ENOMEM);
> +
> +	n =3D btf__get_nr_types(targ_btf);
> +	for (i =3D 1; i <=3D n; i++) {
> +		t =3D btf__type_by_id(targ_btf, i);
> +		targ_name =3D btf__name_by_offset(targ_btf, t->name_off);
> +		if (str_is_empty(targ_name))
> +			continue;
> +
> +		targ_essent_len =3D bpf_core_essential_name_len(targ_name);
> +		if (targ_essent_len !=3D local_essent_len)
> +			continue;
> +
> +		if (strncmp(local_name, targ_name, local_essent_len) =3D=3D 0) {
> +			pr_debug("[%d] (%s): found candidate [%d] (%s)\n",
> +				 local_type_id, local_name, i, targ_name);
> +			new_ids =3D realloc(cand_ids->data, cand_ids->len + 1);
> +			if (!new_ids) {
> +				err =3D -ENOMEM;
> +				goto err_out;
> +			}
> +			cand_ids->data =3D new_ids;
> +			cand_ids->data[cand_ids->len++] =3D i;
> +		}
> +	}
> +	return cand_ids;
> +err_out:
> +	bpf_core_free_cands(cand_ids);
> +	return ERR_PTR(err);
> +}
> +
> +/* Check two types for compatibility, skipping const/volatile/restrict a=
nd
> + * typedefs, to ensure we are relocating offset to the compatible entiti=
es:
> + *   - any two STRUCTs/UNIONs are compatible and can be mixed;
> + *   - any two FWDs are compatible;
> + *   - any two PTRs are always compatible;
> + *   - for ENUMs, check sizes, names are ignored;
> + *   - for INT, size and bitness should match, signedness is ignored;
> + *   - for ARRAY, dimensionality is ignored, element types are checked f=
or
> + *     compatibility recursively;
> + *   - everything else shouldn't be ever a target of relocation.
> + * These rules are not set in stone and probably will be adjusted as we =
get
> + * more experience with using BPF CO-RE relocations.
> + */
> +static int bpf_core_fields_are_compat(const struct btf *local_btf,
> +				      __u32 local_id,
> +				      const struct btf *targ_btf,
> +				      __u32 targ_id)
> +{
> +	const struct btf_type *local_type, *targ_type;
> +	__u16 kind;
> +
> +recur:
> +	local_type =3D skip_mods_and_typedefs(local_btf, local_id, &local_id);
> +	targ_type =3D skip_mods_and_typedefs(targ_btf, targ_id, &targ_id);
> +	if (!local_type || !targ_type)
> +		return -EINVAL;
> +
> +	if (btf_is_composite(local_type) && btf_is_composite(targ_type))
> +		return 1;
> +	if (BTF_INFO_KIND(local_type->info) !=3D BTF_INFO_KIND(targ_type->info)=
)
> +		return 0;
> +
> +	kind =3D BTF_INFO_KIND(local_type->info);
> +	switch (kind) {
> +	case BTF_KIND_FWD:
> +	case BTF_KIND_PTR:
> +		return 1;
> +	case BTF_KIND_ENUM:
> +		return local_type->size =3D=3D targ_type->size;
> +	case BTF_KIND_INT: {
> +		__u32 loc_int =3D *(__u32 *)(local_type + 1);
> +		__u32 targ_int =3D *(__u32 *)(targ_type + 1);
> +
> +		return BTF_INT_OFFSET(loc_int) =3D=3D 0 &&
> +		       BTF_INT_OFFSET(targ_int) =3D=3D 0 &&
> +		       local_type->size =3D=3D targ_type->size &&
> +		       BTF_INT_BITS(loc_int) =3D=3D BTF_INT_BITS(targ_int);
> +	}
> +	case BTF_KIND_ARRAY: {
> +		const struct btf_array *loc_a, *targ_a;
> +
> +		loc_a =3D (void *)(local_type + 1);
> +		targ_a =3D (void *)(targ_type + 1);
> +		local_id =3D loc_a->type;
> +		targ_id =3D targ_a->type;
> +		goto recur;
> +	}
> +	default:
> +		pr_warning("unexpected kind %d relocated, local [%d], target [%d]\n",
> +			   kind, local_id, targ_id);
> +		return 0;
> +	}
> +}
> +
> +/*=20
> + * Given single high-level accessor (either named field or array index) =
in
> + * local type, find corresponding high-level accessor for a target type.=
 Along
> + * the way, maintain low-level spec for target as well. Also keep updati=
ng
> + * target offset.
> + */
> +static int bpf_core_match_member(const struct btf *local_btf,
> +				 const struct bpf_core_accessor *local_acc,
> +				 const struct btf *targ_btf,
> +				 __u32 targ_id,
> +				 struct bpf_core_spec *spec,
> +				 __u32 *next_targ_id)
> +{
> +	const struct btf_type *local_type, *targ_type;
> +	const struct btf_member *local_member, *m;
> +	const char *local_name, *targ_name;
> +	__u32 local_id;
> +	int i, n, found;
> +
> +	targ_type =3D skip_mods_and_typedefs(targ_btf, targ_id, &targ_id);
> +	if (!targ_type)
> +		return -EINVAL;
> +	if (!btf_is_composite(targ_type))
> +		return 0;
> +
> +	local_id =3D local_acc->type_id;
> +	local_type =3D btf__type_by_id(local_btf, local_id);
> +	local_member =3D (void *)(local_type + 1);
> +	local_member +=3D local_acc->idx;
> +	local_name =3D btf__name_by_offset(local_btf, local_member->name_off);
> +
> +	n =3D BTF_INFO_VLEN(targ_type->info);
> +	m =3D (void *)(targ_type + 1);
> +	for (i =3D 0; i < n; i++, m++) {
> +		__u32 offset;
> +
> +		/* bitfield relocations not supported */
> +		if (BTF_INFO_KFLAG(targ_type->info)) {
> +			if (BTF_MEMBER_BITFIELD_SIZE(m->offset))
> +				continue;
> +			offset =3D BTF_MEMBER_BIT_OFFSET(m->offset);
> +		} else {
> +			offset =3D m->offset;
> +		}
> +		if (offset % 8)
> +			continue;
> +
> +		/* too deep struct/union/array nesting */
> +		if (spec->raw_len =3D=3D BPF_CORE_SPEC_MAX_LEN)
> +			return -E2BIG;
> +
> +		/* speculate this member will be the good one */
> +		spec->offset +=3D offset / 8;
> +		spec->raw_spec[spec->raw_len++] =3D i;
> +
> +		targ_name =3D btf__name_by_offset(targ_btf, m->name_off);
> +		if (str_is_empty(targ_name)) {
> +			/* embedded struct/union, we need to go deeper */
> +			found =3D bpf_core_match_member(local_btf, local_acc,
> +						      targ_btf, m->type,
> +						      spec, next_targ_id);
> +			if (found) /* either found or error */
> +				return found;
> +		} else if (strcmp(local_name, targ_name) =3D=3D 0) {
> +			/* matching named field */
> +			struct bpf_core_accessor *targ_acc;
> +
> +			targ_acc =3D &spec->spec[spec->len++];
> +			targ_acc->type_id =3D targ_id;
> +			targ_acc->idx =3D i;
> +			targ_acc->name =3D targ_name;
> +
> +			*next_targ_id =3D m->type;
> +			found =3D bpf_core_fields_are_compat(local_btf,
> +							   local_member->type,
> +							   targ_btf, m->type);
> +			if (!found)
> +				spec->len--; /* pop accessor */
> +			return found;
> +		}
> +		/* member turned out to be not we looked for */

	/* member turned out not to be what we looked for */=20

Or something similar.=20

The rest of this patch looks good to me.=20

Thanks,
Song

