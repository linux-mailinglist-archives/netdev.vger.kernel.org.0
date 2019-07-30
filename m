Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760DF7B65C
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 01:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfG3Xo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 19:44:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54650 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726699AbfG3Xo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 19:44:27 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UNhZbw029497;
        Tue, 30 Jul 2019 16:44:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zIodkakGLlmb2BQ89l/mBS8g4TRa/RnrH+2q7qGIUFg=;
 b=Omi4UMmsuVZMJiUboOecX1aw9a+zbp4fMxCxx0cRgLJIqdGApNGB8jkqcimEF3vK9X8w
 L/SB64iBF6LLiBrLO704zlDHJe3P3BKNGDZi+tw3v82YlHIZlEsPxNlSqSIgHV+b7lVE
 e4cggK9prsciDiuZ2JwCRmKiG05a8CJR1JQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2wufrcv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 30 Jul 2019 16:44:01 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 16:44:00 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 16:44:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Knb/1x8EuPMKFstkLrasRhm6hyJO3r6N6UzXQ7mNIEG0UMlvlgN4SPhfeOPOHhG/PWxPswMUxeRNni+Nq7EZDCFjizjAlF6/d04VXXKy54vOrZVFNWWAT3ltL5EOflxHrh4mai1zV/wvvkY3nwVChVoqWw+XeoC2QYQXH+5saCiaV9zJqk/ic52VA+gK/wGRr4qIiZtWwibNU3axYhTjrGa3Xw/v3P4vG85gmhFRf7OEMln3f4/Yl4QSTJioZXuK3RuAdab0Vs5oKCEvSdDxeAr9w+iErIWBDd7CklwDSrFakCidhW6f6Bit4ekFLJbwI1MFU9j+a6YNReO2OCrbqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIodkakGLlmb2BQ89l/mBS8g4TRa/RnrH+2q7qGIUFg=;
 b=jC+e4Q2WgsYRfDBF5yDW3cOFoOyFnSDOWVg+fhXiySBxgUNf9bJhV5WZ4tqS/8gAQk2nLk3WD+d8CclL7aAjcCKR04BPVRL/wpQFk87Gg875oiEbuG2Ac0CvYik2pEnPlpJCIfb4yxxsW3ubEe0GG7/h4Sf1qaQhHDRpe4AEV88lIrhNRSwJmh4ZpWIpnNBkJKAdK+t3iIb0i0JxzdEPhXKLE9groE896OxnoY1odFfUQFPpryMsPUbzcr1WXPESD+yhu7X8t1KLYHEPy008BF7w2gcZhel3HZLIYMGzCcJk6Gw/0DhTIp8U+oDR8vJSlyDUawx1vBfH4+/w78HHxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIodkakGLlmb2BQ89l/mBS8g4TRa/RnrH+2q7qGIUFg=;
 b=ii90VKXBt7tmz5zZx6IiBG5p/Z5cEDh8f/NoYN1z1Y91hwvIZEBhtrAXeqSotp3Vcn0ZEJiutw91Y1iYl0apPkRScv60BT5hXfDvHdWW0Q23qaZzIvvhD3EHY3QEuFjwe/zvr0wb11/OP81LhlTzG1AAQ1QBBZPLYcvWATvpeeg=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1824.namprd15.prod.outlook.com (10.174.99.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Tue, 30 Jul 2019 23:43:58 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 23:43:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Topic: [PATCH v2 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Index: AQHVRxC6gG08pF4S5U2u3sEqys7j0abj0y2A
Date:   Tue, 30 Jul 2019 23:43:58 +0000
Message-ID: <9C1CFF6F-F661-46F4-B6EB-B42D7F4204F0@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
 <20190730195408.670063-3-andriin@fb.com>
In-Reply-To: <20190730195408.670063-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:5cb8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c14f5ed-97f4-42aa-8f0e-08d71547cb0b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1824;
x-ms-traffictypediagnostic: MWHPR15MB1824:
x-microsoft-antispam-prvs: <MWHPR15MB1824A223483A3932CAB92FB7B3DC0@MWHPR15MB1824.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(346002)(376002)(396003)(199004)(189003)(446003)(11346002)(2616005)(476003)(2906002)(316002)(5660300002)(46003)(6636002)(50226002)(4326008)(186003)(30864003)(76116006)(66446008)(66556008)(66946007)(64756008)(66476007)(68736007)(37006003)(256004)(36756003)(54906003)(57306001)(6116002)(33656002)(478600001)(14444005)(229853002)(25786009)(6486002)(14454004)(6436002)(102836004)(81156014)(81166006)(6862004)(71200400001)(6506007)(53546011)(71190400001)(8936002)(305945005)(7736002)(486006)(99286004)(53936002)(86362001)(53946003)(6246003)(8676002)(6512007)(76176011)(559001)(579004)(569006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1824;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: w1xlOxcPUXA9T7fSeoT+0dp363XcZ7yHxrDqze1HkGXh7fb6PpCsU4ZV/eOfu1e9FrSZeHmvhet+Pg1HO7q3fM23qy3yAg7Peb928yIFeH4qWwrzenFVuPRPARlDSgOaJigcvHfWOkURV52hMf/Sq+9cPqw7SmCHnvpcd1LtTkys9ikYAAW2DMPD5wLD++98EIYTMGvDJ3+CLfWPIXWj/aRZ8lcQtrb7hby4uWV6H/LNB75kJX4nItX4xk+G7OmC5mqMCSF2/XGuBT0A8p52Sd3wJYZcXjP4O3NbJnGC6fNseWWOeVxvcI7u4UzXeAUN8E8vgypa7nKHqjvX/f2HNOGddWJmMUwujvw6ShQ9BeQNrUtXNAJCIib2+6R4SAsoFuY2j9H8o9z4s/397fhyrFqHXqldEm1y2KYgzq4vrpo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B8C2B4FCB4CC9419B7F9142F01909A9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c14f5ed-97f4-42aa-8f0e-08d71547cb0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 23:43:58.8227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1824
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300239
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> This patch implements the core logic for BPF CO-RE offsets relocations.
> Every instruction that needs to be relocated has corresponding
> bpf_offset_reloc as part of BTF.ext. Relocations are performed by trying
> to match recorded "local" relocation spec against potentially many
> compatible "target" types, creating corresponding spec. Details of the
> algorithm are noted in corresponding comments in the code.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/libbpf.c | 915 ++++++++++++++++++++++++++++++++++++++++-
> tools/lib/bpf/libbpf.h |   1 +
> 2 files changed, 909 insertions(+), 7 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ead915aec349..75da90928257 100644
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
> @@ -1015,17 +1017,22 @@ static int bpf_object__init_user_maps(struct bpf_=
object *obj, bool strict)
> 	return 0;
> }
>=20
> -static const struct btf_type *skip_mods_and_typedefs(const struct btf *b=
tf,
> -						     __u32 id)
> +static const struct btf_type *
> +skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
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

So btf->types[*res_id] =3D=3D retval, right? Then with retval and btf, we c=
an
calculate *res_id without this change?

> 			break;
> 		default:
> @@ -1044,7 +1051,7 @@ static const struct btf_type *skip_mods_and_typedef=
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
> @@ -1110,7 +1117,7 @@ static int bpf_object__init_user_btf_map(struct bpf=
_object *obj,
> 		return -EOPNOTSUPP;
> 	}
>=20
> -	def =3D skip_mods_and_typedefs(obj->btf, var->type);
> +	def =3D skip_mods_and_typedefs(obj->btf, var->type, NULL);
> 	if (BTF_INFO_KIND(def->info) !=3D BTF_KIND_STRUCT) {
> 		pr_warning("map '%s': unexpected def kind %u.\n",
> 			   map_name, BTF_INFO_KIND(var->info));
> @@ -2292,6 +2299,893 @@ bpf_program_reloc_btf_ext(struct bpf_program *pro=
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
> +	/* high-level spec: named fields and array indices only */
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
> +	const char *name;
> +	__u32 id;
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
> +	/* first spec value is always reloc type array index */
> +	t =3D skip_mods_and_typedefs(btf, type_id, &id);
> +	if (!t)
> +		return -EINVAL;
> +
> +	access_idx =3D spec->raw_spec[0];
> +	spec->spec[0].type_id =3D id;
> +	spec->spec[0].idx =3D access_idx;
> +	spec->len++;
> +
> +	sz =3D btf__resolve_size(btf, id);
> +	if (sz < 0)
> +		return sz;
> +	spec->offset =3D access_idx * sz;
> +
> +	for (i =3D 1; i < spec->raw_len; i++) {
> +		t =3D skip_mods_and_typedefs(btf, id, &id);
> +		if (!t)
> +			return -EINVAL;
> +
> +		access_idx =3D spec->raw_spec[i];
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
> + * Given single high-level named field accessor in local type, find
> + * corresponding high-level accessor for a target type. Along the way,
> + * maintain low-level spec for target as well. Also keep updating target
> + * offset.
> + *
> + * Searching is performed through recursive exhaustive enumeration of al=
l
> + * fields of a struct/union. If there are any anonymous (embedded)
> + * structs/unions, they are recursively searched as well. If field with
> + * desired name is found, check compatibility between local and target t=
ypes,
> + * before returning result.
> + *
> + * 1 is returned, if field is found.
> + * 0 is returned if no compatible field is found.
> + * <0 is returned on error.
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
> +		/* member turned out not to be what we looked for */
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
> +/* Output spec definition in the format:
> + * [<type-id>] (<type-name>) + <raw-spec> =3D> <offset>@<spec>,
> + * where <spec> is a C-syntax view of recorded field access, e.g.: x.a[3=
].b
> + */
> +static void bpf_core_dump_spec(int level, const struct bpf_core_spec *sp=
ec)
> +{
> +	const struct btf_type *t;
> +	const char *s;
> +	__u32 type_id;
> +	int i;
> +
> +	type_id =3D spec->spec[0].type_id;
> +	t =3D btf__type_by_id(spec->btf, type_id);
> +	s =3D btf__name_by_offset(spec->btf, t->name_off);
> +	libbpf_print(level, "[%u] (%s) + ", type_id, s);
> +
> +	for (i =3D 0; i < spec->raw_len; i++)
> +		libbpf_print(level, "%d%s", spec->raw_spec[i],
> +			     i =3D=3D spec->raw_len - 1 ? " =3D> " : ":");
> +
> +	libbpf_print(level, "%u @ &x", spec->offset);
> +
> +	for (i =3D 0; i < spec->len; i++) {
> +		if (spec->spec[i].name)
> +			libbpf_print(level, ".%s", spec->spec[i].name);
> +		else
> +			libbpf_print(level, "[%u]", spec->spec[i].idx);
> +	}
> +
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
> + *
> + *    N.B. Struct "flavors" could be generated by bpftool's BTF-to-C
> + *    converter, when deduplicated BTF of a kernel still contains more t=
han
> + *    one different types with the same name. In that case, ___2, ___3, =
etc
> + *    are appended starting from second name conflict. But start flavors=
 are
> + *    also useful to be defined "locally", in BPF program, to extract sa=
me
> + *    data from incompatible changes between different kernel
> + *    versions/configurations. For instance, to handle field renames bet=
ween
> + *    kernel versions, one can use two flavors of the struct name with t=
he
> + *    same common name and use conditional relocations to extract that f=
ield,
> + *    depending on target kernel version.
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
> +	err =3D bpf_core_spec_parse(local_btf, local_id, spec_str, &local_spec)=
;
> +	if (err) {
> +		pr_warning("prog '%s': relo #%d: parsing [%d] (%s) + %s failed: %d\n",
> +			   prog_name, relo_idx, local_id, local_name, spec_str,
> +			   err);
> +		return -EINVAL;
> +	}
> +
> +	pr_debug("prog '%s': relo #%d: spec is ", prog_name, relo_idx);
> +	bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
> +	libbpf_print(LIBBPF_DEBUG, "\n");
> +
> +	if (!hashmap__find(cand_cache, type_key, (void **)&cand_ids)) {
> +		cand_ids =3D bpf_core_find_cands(local_btf, local_id, targ_btf);
> +		if (IS_ERR(cand_ids)) {
> +			pr_warning("prog '%s': relo #%d: target candidate search failed for [=
%d] (%s): %ld",
> +				   prog_name, relo_idx, local_id, local_name,
> +				   PTR_ERR(cand_ids));
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
> +		cand_id =3D cand_ids->data[i];
> +		cand_type =3D btf__type_by_id(targ_btf, cand_id);
> +		cand_name =3D btf__name_by_offset(targ_btf, cand_type->name_off);
> +
> +		err =3D bpf_core_spec_match(&local_spec, targ_btf,
> +					  cand_id, &cand_spec);
> +		if (err < 0) {
> +			pr_warning("prog '%s': relo #%d: failed to match spec ",
> +				   prog_name, relo_idx);
> +			bpf_core_dump_spec(LIBBPF_WARN, &local_spec);
> +			libbpf_print(LIBBPF_WARN,
> +				     " to candidate #%d [%d] (%s): %d\n",
> +				     i, cand_id, cand_name, err);
> +			return err;
> +		}
> +		if (err =3D=3D 0) {
> +			pr_debug("prog '%s': relo #%d: candidate #%d [%d] (%s) doesn't match =
spec ",
> +				 prog_name, relo_idx, i, cand_id, cand_name);
> +			bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
> +			libbpf_print(LIBBPF_DEBUG, "\n");
> +			continue;
> +		}
> +
> +		pr_debug("prog '%s': relo #%d: candidate #%d matched as spec ",
> +			 prog_name, relo_idx, i);
> +		bpf_core_dump_spec(LIBBPF_DEBUG, &cand_spec);
> +		libbpf_print(LIBBPF_DEBUG, "\n");
> +
> +		if (j =3D=3D 0) {
> +			targ_spec =3D cand_spec;
> +		} else if (cand_spec.offset !=3D targ_spec.offset) {
> +			/* if there are many candidates, they should all
> +			 * resolve to the same offset
> +			 */
> +			pr_warning("prog '%s': relo #%d: candidate #%d spec ",
> +				   prog_name, relo_idx, i);
> +			bpf_core_dump_spec(LIBBPF_WARN, &cand_spec);
> +			libbpf_print(LIBBPF_WARN,
> +				     " conflicts with target spec ");
> +			bpf_core_dump_spec(LIBBPF_WARN, &targ_spec);
> +			libbpf_print(LIBBPF_WARN, "\n");
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
> @@ -2399,14 +3293,21 @@ bpf_program__relocate(struct bpf_program *prog, s=
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
> @@ -2807,7 +3708,7 @@ int bpf_object__load_xattr(struct bpf_object_load_a=
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
> index 8a9d462a6f6d..e8f70977d137 100644
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

