Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2DC757F0
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfGYTdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:33:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46530 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbfGYTdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:33:38 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6PJTXZi011778;
        Thu, 25 Jul 2019 12:32:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=U2vdaaCBUI/H/OyWckv58T2nhdNAT4nFQqE/u608uN4=;
 b=WoI6DFglAR7aLgzE6pxIugxYouzUL2p0nJYiM05mAgR+y21GYtlUOSXYtL7q9dOmGDhT
 JOv2JAmGc3+2TvtPu1Jzf+7pGYqT2SfF+LSz5HXujyRkbQBHnohX0JQ7Oj7UoBraFUK2
 cnULZFFajYb5dxxnG8C4ZoAtbmoLgrOx/QE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tyh4n0fqr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jul 2019 12:32:58 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 25 Jul 2019 12:32:56 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 25 Jul 2019 12:32:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAzUuFzlP2bVKHuFC19sZNdHRO6BwF0x09ckdsWqjAeIryZKEv6T71yMLgdcXG7g0hYO2PwAWVA+mKp20znJDhBfEF2sE+qDvsfBcchGpN1C6vRKzTdRPPhwUo5ZrMdLbM8tHR84UX/OW7APe6T8Ikm9oeWx19A87yANd167iJZM2r1fdMvCJfj+xMJtFhvvWP4wDanm/Cfaf3qzGK53ZSlEnSQWDpFxT4dot96/NGu5rMPZ8+Toah8ZAN2kn8GbWWR4XvNt71doeMwSBXnk8NrDImhgy+1odaeS5LpN85mw7r0k/YXgwlYyppKkOEWfQkMPmkHLYJMJR8uvEa+5RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2vdaaCBUI/H/OyWckv58T2nhdNAT4nFQqE/u608uN4=;
 b=IUycqEvD4+saoDfQ5LHyQI3b2Qlv0ALLfB9qticQ2jAk64t3ZXRfgNS7VcVGXUE8okjOM/uQLgYiX7WPXzJiZz/94v7deVw2g8iqCLB5UCPBHuoPgV9Sf0l/YsYNuw46fvEFFxtp4BALWCL2v72BKafT44CZq54rnM9R9eGbQJ8BM9voaaObi3Ica9upQmxkzhTIlayt923qRzwqiO1zKAj/gFk6XW8B7OMXyYmEljIK/3FkDsDEasT/ev/6VcK8Wujja6KTBbf0kQaC4+hnQo1cqv/6PbvwGhFAzHwMl6DiHS0KWkrzUKUUkp3wsFim3Xu4I597sDfNwU/P4XmNcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2vdaaCBUI/H/OyWckv58T2nhdNAT4nFQqE/u608uN4=;
 b=AetjtNBDTdkEtIpMnE/nH6S9WX5hkkZtWKg5QzqBxJ9J/AenkE2HLIgVmiGqc9rxk8lygXC3Thn+JaPNaWdIdduRfurNuKJm4KuzXJytGC3cHmukytBy2LhZIpU0sBSGaylxTCzQ3eTBHQsQ7SQ2RldX3W8v13k2tPQmBo1fbaw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1854.namprd15.prod.outlook.com (10.174.96.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Thu, 25 Jul 2019 19:32:55 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 19:32:55 +0000
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
Thread-Index: AQHVQlYfQU29UbcfIEO0wFH+SyI9nKbbutUA
Date:   Thu, 25 Jul 2019 19:32:55 +0000
Message-ID: <2D563869-72E5-4623-B239-173EE2313084@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-3-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:63dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50d37808-93c4-478a-5241-08d71136e444
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1854;
x-ms-traffictypediagnostic: MWHPR15MB1854:
x-microsoft-antispam-prvs: <MWHPR15MB18544979CAF31B1A2D4FD346B3C10@MWHPR15MB1854.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(136003)(39860400002)(396003)(54534003)(199004)(189003)(71200400001)(71190400001)(6636002)(446003)(57306001)(7736002)(6246003)(6506007)(6116002)(6862004)(305945005)(186003)(53946003)(476003)(14454004)(50226002)(53546011)(46003)(6512007)(2616005)(14444005)(256004)(11346002)(486006)(229853002)(6486002)(4326008)(316002)(81156014)(81166006)(8936002)(68736007)(76176011)(478600001)(54906003)(37006003)(86362001)(33656002)(76116006)(5660300002)(25786009)(99286004)(102836004)(66446008)(66946007)(66476007)(8676002)(64756008)(30864003)(66556008)(6436002)(2906002)(53936002)(36756003)(559001)(579004)(569006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1854;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zIj4Q/pGQdmSbPLCwsNZwdeOXeJbtooS505I+mFLPFUP0CluMR3I/CgGZe9MP258fNypXbkqx+YL1pgBHM6cZslH6p5UT6V2SONmK7EVx+6zpmHzJOmhfnbV9Kq1AdYtl5nloAxG5qAx5u7VXfuK1fkXUmActaxI7Sc3eddS/gb0wrza/xShmPHz/cPBLEB/kaPQu5sHS3O0JOx1DwYUmg9NdzH1DPJYISSoUGJ/eceV+GWmO/hA/2Gqhi+Cw7QQBlBLS7MZlsGEvinmcNz7wYbMUzyq0zfyecciRDWmTvl4My1ruCY0ZNBa3s7FvXSQmj9Gq/b/Eh+Xd1dHi//jlS+fXHAHenFZ6TtEUJBCLjzPPgjmmAJ+umTB8C2dljG22NacKpwS38ikmfBh/2PEQdMmwcte8dwh4s5i1CmxTDY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <99078759603EDB42930979EE68077466@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d37808-93c4-478a-5241-08d71136e444
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 19:32:55.0232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1854
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-25_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907250232
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> This patch implements the core logic for BPF CO-RE offsets relocations.
> All the details are described in code comments.

Some description in the change log is still useful. Please at least=20
copy-paste key comments here.=20

And, this is looooong. I think it is totally possible to split it into
multiple smaller patches.=20

I haven't finished all of it. Please see my comments below of parts I
have covered.=20

Thanks,
Song

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

Maybe have a local "__u32 rid;"=20

>=20
> +	if (res_id)
> +		*res_id =3D id;
> +

and do "rid =3D id;" here

> 	while (true) {
> 		switch (BTF_INFO_KIND(t->info)) {
> 		case BTF_KIND_VOLATILE:
> 		case BTF_KIND_CONST:
> 		case BTF_KIND_RESTRICT:
> 		case BTF_KIND_TYPEDEF:
> +			if (res_id)
> +				*res_id =3D t->type;
and here

> 			t =3D btf__type_by_id(btf, t->type);
> 			break;
> 		default:
and "*res_id =3D rid;" right before return?

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

typo: indices

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

IIUC, high-level points are subset of low-level points. How about we introd=
uce
"anonymous" high-level points, so that high-level points and low-level poin=
ts
are 1:1 mapping?=20

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
          spec->offset =3D access_idx * sz;  should be enough

> +			continue;
> +		}

Maybe pull i =3D=3D 0 case out of the for loop?=20

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

Can this ever happen?=20

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

Please describe the recursive algorithm here. I am kinda lost.=20
Also, please document the meaning of zero, positive, negative return values=
.

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
> +		spec->offset -=3D offset / 8;
> +		spec->raw_len--;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Try to match local spec to a target type and, if successful, produce =
full
> + * target spec (high-level, low-level + offset).
> + */
> +static int bpf_core_spec_match(struct bpf_core_spec *local_spec,
> +			       const struct btf *targ_btf, __u32 targ_id,
> +			       struct bpf_core_spec *targ_spec)
> +{
> +	const struct btf_type *targ_type;
> +	const struct bpf_core_accessor *local_acc;
> +	struct bpf_core_accessor *targ_acc;
> +	int i, sz, matched;
> +
> +	memset(targ_spec, 0, sizeof(*targ_spec));
> +	targ_spec->btf =3D targ_btf;
> +
> +	local_acc =3D &local_spec->spec[0];
> +	targ_acc =3D &targ_spec->spec[0];
> +
> +	for (i =3D 0; i < local_spec->len; i++, local_acc++, targ_acc++) {
> +		targ_type =3D skip_mods_and_typedefs(targ_spec->btf, targ_id,
> +						   &targ_id);
> +		if (!targ_type)
> +			return -EINVAL;
> +
> +		if (local_acc->name) {
> +			if (!btf_is_composite(targ_type))
> +				return 0;
> +
> +			matched =3D bpf_core_match_member(local_spec->btf,
> +							local_acc,
> +							targ_btf, targ_id,
> +							targ_spec, &targ_id);
> +			if (matched <=3D 0)
> +				return matched;
> +		} else {
> +			/* for i=3D0, targ_id is already treated as array element
> +			 * type (because it's the original struct), for others
> +			 * we should find array element type first
> +			 */
> +			if (i > 0) {

i =3D=3D 0 case would go into "if (local_acc->name)" branch, no?=20

> +				const struct btf_array *a;
> +
> +				if (!btf_is_array(targ_type))
> +					return 0;
> +
> +				a =3D (void *)(targ_type + 1);
> +				if (local_acc->idx >=3D a->nelems)
> +					return 0;
> +				if (!skip_mods_and_typedefs(targ_btf, a->type,
> +							    &targ_id))
> +					return -EINVAL;
> +			}
> +
> +			/* too deep struct/union/array nesting */
> +			if (targ_spec->raw_len =3D=3D BPF_CORE_SPEC_MAX_LEN)
> +				return -E2BIG;
> +
> +			targ_acc->type_id =3D targ_id;
> +			targ_acc->idx =3D local_acc->idx;
> +			targ_acc->name =3D NULL;
> +			targ_spec->len++;
> +			targ_spec->raw_spec[targ_spec->raw_len] =3D targ_acc->idx;
> +			targ_spec->raw_len++;
> +
> +			sz =3D btf__resolve_size(targ_btf, targ_id);
> +			if (sz < 0)
> +				return sz;
> +			targ_spec->offset +=3D local_acc->idx * sz;
> +		}
> +	}
> +
> +	return 1;
> +}
> +
> +/*
> + * Patch relocatable BPF instruction.
> + * Expected insn->imm value is provided for validation, as well as the n=
ew
> + * relocated value.
> + *
> + * Currently three kinds of BPF instructions are supported:
> + * 1. rX =3D <imm> (assignment with immediate operand);
> + * 2. rX +=3D <imm> (arithmetic operations with immediate operand);
> + * 3. *(rX) =3D <imm> (indirect memory assignment with immediate operand=
).
> + *
> + * If actual insn->imm value is wrong, bail out.
> + */
> +static int bpf_core_reloc_insn(struct bpf_program *prog, int insn_off,
> +			       __u32 orig_off, __u32 new_off)
> +{
> +	struct bpf_insn *insn;
> +	int insn_idx;
> +	__u8 class;
> +
> +	if (insn_off % sizeof(struct bpf_insn))
> +		return -EINVAL;
> +	insn_idx =3D insn_off / sizeof(struct bpf_insn);
> +
> +	insn =3D &prog->insns[insn_idx];
> +	class =3D BPF_CLASS(insn->code);
> +
> +	if (class =3D=3D BPF_ALU || class =3D=3D BPF_ALU64) {
> +		if (BPF_SRC(insn->code) !=3D BPF_K)
> +			return -EINVAL;
> +		if (insn->imm !=3D orig_off)
> +			return -EINVAL;
> +		insn->imm =3D new_off;
> +		pr_debug("prog '%s': patched insn #%d (ALU/ALU64) imm %d -> %d\n",
> +			 bpf_program__title(prog, false),
> +			 insn_idx, orig_off, new_off);
> +	} else if (class =3D=3D BPF_ST && BPF_MODE(insn->code) =3D=3D BPF_MEM) =
{
> +		if (insn->imm !=3D orig_off)
> +			return -EINVAL;
> +		insn->imm =3D new_off;
> +		pr_debug("prog '%s': patched insn #%d (ST | MEM) imm %d -> %d\n",
> +			 bpf_program__title(prog, false),
> +			 insn_idx, orig_off, new_off);
> +	} else {
> +		pr_warning("prog '%s': trying to relocate unrecognized insn #%d, code:=
%x, src:%x, dst:%x, off:%x, imm:%x\n",
> +			   bpf_program__title(prog, false),
> +			   insn_idx, insn->code, insn->src_reg, insn->dst_reg,
> +			   insn->off, insn->imm);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Probe few well-known locations for vmlinux kernel image and try to lo=
ad BTF
> + * data out of it to use for target BTF.
> + */
> +static struct btf *bpf_core_find_kernel_btf(void)
> +{
> +	const char *locations[] =3D {
> +		"/lib/modules/%1$s/vmlinux-%1$s",
> +		"/usr/lib/modules/%1$s/kernel/vmlinux",
> +	};
> +	char path[PATH_MAX + 1];
> +	struct utsname buf;
> +	struct btf *btf;
> +	int i, err;
> +
> +	err =3D uname(&buf);
> +	if (err) {
> +		pr_warning("failed to uname(): %d\n", err);
> +		return ERR_PTR(err);
> +	}
> +
> +	for (i =3D 0; i < ARRAY_SIZE(locations); i++) {
> +		snprintf(path, PATH_MAX, locations[i], buf.release);
> +		pr_debug("attempting to load kernel BTF from '%s'\n", path);
> +
> +		if (access(path, R_OK))
> +			continue;
> +
> +		btf =3D btf__parse_elf(path, NULL);
> +		if (IS_ERR(btf))
> +			continue;
> +
> +		pr_debug("successfully loaded kernel BTF from '%s'\n", path);
> +		return btf;
> +	}
> +
> +	pr_warning("failed to find valid kernel BTF\n");
> +	return ERR_PTR(-ESRCH);
> +}
> +
> +static size_t bpf_core_hash_fn(const void *key, void *ctx)
> +{
> +	return (size_t)key;
> +}
> +
> +static bool bpf_core_equal_fn(const void *k1, const void *k2, void *ctx)
> +{
> +	return k1 =3D=3D k2;
> +}
> +
> +static void *u32_to_ptr(__u32 x)
> +{
> +	return (void *)(uintptr_t)x;
> +}
> +
> +/*=20
> + * CO-RE relocate single instruction.
> + *
> + * The outline and important points of the algorithm:
> + * 1. For given local type, find corresponding candidate target types.
> + *    Candidate type is a type with the same "essential" name, ignoring
> + *    everything after last triple underscore (___). E.g., `sample`,
> + *    `sample___flavor_one`, `sample___flavor_another_one`, are all cand=
idates
> + *    for each other. Names with triple underscore are referred to as
> + *    "flavors" and are useful, among other things, to allow to
> + *    specify/support incompatible variations of the same kernel struct,=
 which
> + *    might differ between different kernel versions and/or build
> + *    configurations.
> + * 2. For each candidate type, try to match local specification to this
> + *    candidate target type. Matching involves finding corresponding
> + *    high-level spec accessors, meaning that all named fields should ma=
tch,
> + *    as well as all array accesses should be within the actual bounds. =
Also,
> + *    types should be compatible (see bpf_core_fields_are_compat for det=
ails).
> + * 3. It is supported and expected that there might be multiple flavors
> + *    matching the spec. As long as all the specs resolve to the same se=
t of
> + *    offsets across all candidates, there is not error. If there is any
> + *    ambiguity, CO-RE relocation will fail. This is necessary to accomo=
date
> + *    imprefection of BTF deduplication, which can cause slight duplicat=
ion of
> + *    the same BTF type, if some directly or indirectly referenced (by
> + *    pointer) type gets resolved to different actual types in different
> + *    object files. If such situation occurs, deduplicated BTF will end =
up
> + *    with two (or more) structurally identical types, which differ only=
 in
> + *    types they refer to through pointer. This should be OK in most cas=
es and
> + *    is not an error.
> + * 4. Candidate types search is performed by linearly scanning through a=
ll
> + *    types in target BTF. It is anticipated that this is overall more
> + *    efficient memory-wise and not significantly worse (if not better)
> + *    CPU-wise compared to prebuilding a map from all local type names t=
o
> + *    a list of candidate type names. It's also sped up by caching resol=
ved
> + *    list of matching candidates per each local "root" type ID, that ha=
s at
> + *    least one bpf_offset_reloc associated with it. This list is shared
> + *    between multiple relocations for the same type ID and is updated a=
s some
> + *    of the candidates are pruned due to structural incompatibility.
> + */
> +static int bpf_core_reloc_offset(struct bpf_program *prog,
> +				 const struct bpf_offset_reloc *relo,
> +				 int relo_idx,
> +				 const struct btf *local_btf,
> +				 const struct btf *targ_btf,
> +				 struct hashmap *cand_cache)
> +{
> +	const char *prog_name =3D bpf_program__title(prog, false);
> +	struct bpf_core_spec local_spec, cand_spec, targ_spec;
> +	const void *type_key =3D u32_to_ptr(relo->type_id);
> +	const struct btf_type *local_type, *cand_type;
> +	const char *local_name, *cand_name;
> +	struct ids_vec *cand_ids;
> +	__u32 local_id, cand_id;
> +	const char *spec_str;
> +	int i, j, err;
> +
> +	local_id =3D relo->type_id;
> +	local_type =3D btf__type_by_id(local_btf, local_id);
> +	if (!local_type)
> +		return -EINVAL;
> +
> +	local_name =3D btf__name_by_offset(local_btf, local_type->name_off);
> +	if (str_is_empty(local_name))
> +		return -EINVAL;
> +
> +	spec_str =3D btf__name_by_offset(local_btf, relo->access_str_off);
> +	if (str_is_empty(spec_str))
> +		return -EINVAL;
> +
> +	pr_debug("prog '%s': relo #%d: insn_off=3D%d, [%d] (%s) + %s\n",
> +		 prog_name, relo_idx, relo->insn_off,
> +		 local_id, local_name, spec_str);
> +
> +	err =3D bpf_core_spec_parse(local_btf, local_id, spec_str, &local_spec)=
;
> +	if (err) {
> +		pr_warning("prog '%s': relo #%d: parsing [%d] (%s) + %s failed: %d\n",
> +			   prog_name, relo_idx, local_id, local_name, spec_str,
> +			   err);
> +		return -EINVAL;
> +	}
> +	pr_debug("prog '%s': relo #%d: [%d] (%s) + %s is off %u, len %d, raw_le=
n %d\n",
> +		 prog_name, relo_idx, local_id, local_name, spec_str,
> +		 local_spec.offset, local_spec.len, local_spec.raw_len);
> +
> +	if (!hashmap__find(cand_cache, type_key, (void **)&cand_ids)) {
> +		cand_ids =3D bpf_core_find_cands(local_btf, local_id, targ_btf);
> +		if (IS_ERR(cand_ids)) {
> +			pr_warning("prog '%s': relo #%d: target candidate search failed for [=
%d] (%s) + %s: %ld\n",
> +				   prog_name, relo_idx, local_id, local_name,
> +				   spec_str, PTR_ERR(cand_ids));
> +			return PTR_ERR(cand_ids);
> +		}
> +		err =3D hashmap__set(cand_cache, type_key, cand_ids, NULL, NULL);
> +		if (err) {
> +			bpf_core_free_cands(cand_ids);
> +			return err;
> +		}
> +	}
> +
> +	for (i =3D 0, j =3D 0; i < cand_ids->len; i++) {
> +		cand_id =3D cand_ids->data[j];
> +		cand_type =3D btf__type_by_id(targ_btf, cand_id);
> +		cand_name =3D btf__name_by_offset(targ_btf, cand_type->name_off);
> +
> +		err =3D bpf_core_spec_match(&local_spec, targ_btf,
> +					  cand_id, &cand_spec);
> +		if (err < 0) {
> +			pr_warning("prog '%s': relo #%d: failed to match spec [%d] (%s) + %s =
to candidate #%d [%d] (%s): %d\n",
> +				   prog_name, relo_idx, local_id, local_name,
> +				   spec_str, i, cand_id, cand_name, err);
> +			return err;
> +		}
> +		if (err =3D=3D 0) {
> +			pr_debug("prog '%s': relo #%d: candidate #%d [%d] (%s) doesn't match =
spec\n",
> +				 prog_name, relo_idx, i, cand_id, cand_name);
> +			continue;
> +		}
> +
> +		pr_debug("prog '%s': relo #%d: candidate #%d ([%d] %s) is off %u, len =
%d, raw_len %d\n",
> +			 prog_name, relo_idx, i, cand_id, cand_name,
> +			 cand_spec.offset, cand_spec.len, cand_spec.raw_len);
> +
> +		if (j =3D=3D 0) {
> +			targ_spec =3D cand_spec;
> +		} else if (cand_spec.offset !=3D targ_spec.offset) {
> +			/* if there are many candidates, they should all
> +			 * resolve to the same offset
> +			 */
> +			pr_warning("prog '%s': relo #%d: candidate #%d ([%d] %s): conflicting=
 offset found (%u !=3D %u)\n",
> +				   prog_name, relo_idx, i, cand_id, cand_name,
> +				   cand_spec.offset, targ_spec.offset);
> +			return -EINVAL;
> +		}
> +
> +		cand_ids->data[j++] =3D cand_spec.spec[0].type_id;
> +	}
> +
> +	cand_ids->len =3D j;
> +	if (cand_ids->len =3D=3D 0) {
> +		pr_warning("prog '%s': relo #%d: no matching targets found for [%d] (%=
s) + %s\n",
> +			   prog_name, relo_idx, local_id, local_name, spec_str);
> +		return -ESRCH;
> +	}
> +
> +	err =3D bpf_core_reloc_insn(prog, relo->insn_off,
> +				  local_spec.offset, targ_spec.offset);
> +	if (err) {
> +		pr_warning("prog '%s': relo #%d: failed to patch insn at offset %d: %d=
\n",
> +			   prog_name, relo_idx, relo->insn_off, err);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +bpf_core_reloc_offsets(struct bpf_object *obj, const char *targ_btf_path=
)
> +{
> +	const struct btf_ext_info_sec *sec;
> +	const struct bpf_offset_reloc *rec;
> +	const struct btf_ext_info *seg;
> +	struct hashmap_entry *entry;
> +	struct hashmap *cand_cache =3D NULL;
> +	struct bpf_program *prog;
> +	struct btf *targ_btf;
> +	const char *sec_name;
> +	int i, err =3D 0;
> +
> +	if (targ_btf_path)
> +		targ_btf =3D btf__parse_elf(targ_btf_path, NULL);
> +	else
> +		targ_btf =3D bpf_core_find_kernel_btf();
> +	if (IS_ERR(targ_btf)) {
> +		pr_warning("failed to get target BTF: %ld\n",
> +			   PTR_ERR(targ_btf));
> +		return PTR_ERR(targ_btf);
> +	}
> +
> +	cand_cache =3D hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
> +	if (IS_ERR(cand_cache)) {
> +		err =3D PTR_ERR(cand_cache);
> +		goto out;
> +	}
> +
> +	seg =3D &obj->btf_ext->offset_reloc_info;
> +	for_each_btf_ext_sec(seg, sec) {
> +		sec_name =3D btf__name_by_offset(obj->btf, sec->sec_name_off);
> +		if (str_is_empty(sec_name)) {
> +			err =3D -EINVAL;
> +			goto out;
> +		}
> +		prog =3D bpf_object__find_program_by_title(obj, sec_name);
> +		if (!prog) {
> +			pr_warning("failed to find program '%s' for CO-RE offset relocation\n=
",
> +				   sec_name);
> +			err =3D -EINVAL;
> +			goto out;
> +		}
> +
> +		pr_debug("prog '%s': performing %d CO-RE offset relocs\n",
> +			 sec_name, sec->num_info);
> +
> +		for_each_btf_ext_rec(seg, sec, i, rec) {
> +			err =3D bpf_core_reloc_offset(prog, rec, i, obj->btf,
> +						    targ_btf, cand_cache);
> +			if (err) {
> +				pr_warning("prog '%s': relo #%d: failed to relocate: %d\n",
> +					   sec_name, i, err);
> +				goto out;
> +			}
> +		}
> +	}
> +
> +out:
> +	btf__free(targ_btf);
> +	if (!IS_ERR_OR_NULL(cand_cache)) {
> +		hashmap__for_each_entry(cand_cache, entry, i) {
> +			bpf_core_free_cands(entry->value);
> +		}
> +		hashmap__free(cand_cache);
> +	}
> +	return err;
> +}
> +
> +static int
> +bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_p=
ath)
> +{
> +	int err =3D 0;
> +
> +	if (obj->btf_ext->offset_reloc_info.len)
> +		err =3D bpf_core_reloc_offsets(obj, targ_btf_path);
> +
> +	return err;
> +}
> +
> static int
> bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
> 			struct reloc_desc *relo)
> @@ -2396,14 +3243,21 @@ bpf_program__relocate(struct bpf_program *prog, s=
truct bpf_object *obj)
> 	return 0;
> }
>=20
> -
> static int
> -bpf_object__relocate(struct bpf_object *obj)
> +bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
> {
> 	struct bpf_program *prog;
> 	size_t i;
> 	int err;
>=20
> +	if (obj->btf_ext) {
> +		err =3D bpf_object__relocate_core(obj, targ_btf_path);
> +		if (err) {
> +			pr_warning("failed to perform CO-RE relocations: %d\n",
> +				   err);
> +			return err;
> +		}
> +	}
> 	for (i =3D 0; i < obj->nr_programs; i++) {
> 		prog =3D &obj->programs[i];
>=20
> @@ -2804,7 +3658,7 @@ int bpf_object__load_xattr(struct bpf_object_load_a=
ttr *attr)
> 	obj->loaded =3D true;
>=20
> 	CHECK_ERR(bpf_object__create_maps(obj), err, out);
> -	CHECK_ERR(bpf_object__relocate(obj), err, out);
> +	CHECK_ERR(bpf_object__relocate(obj, attr->target_btf_path), err, out);
> 	CHECK_ERR(bpf_object__load_progs(obj, attr->log_level), err, out);
>=20
> 	return 0;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 5cbf459ece0b..6004bfe1ebf0 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -92,6 +92,7 @@ LIBBPF_API void bpf_object__close(struct bpf_object *ob=
ject);
> struct bpf_object_load_attr {
> 	struct bpf_object *obj;
> 	int log_level;
> +	const char *target_btf_path;
> };
>=20
> /* Load/unload object into/from kernel */
> --=20
> 2.17.1
>=20

