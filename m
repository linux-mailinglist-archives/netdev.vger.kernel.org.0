Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF7D134B4C
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 20:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgAHTMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 14:12:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47188 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbgAHTMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 14:12:12 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008JAwsB023614;
        Wed, 8 Jan 2020 11:11:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=S6L93epVKkAxNevIBuZfAvo153x+UippwZMLgeHZ27A=;
 b=CQ4qR7QgSBDg9VmVwrppew9OMeRhEK7XxZ0skhpk71Ut74AolBpduDdiSBGT99Jr6UxI
 tC2UtiJjRoG9vYhHSGwniCBtqAtJNivRheA4KHQnmKMup41VKREj98xMgLJ52PLEWZYp
 c8ft9A4A+UdKYHZZ7FqdDk5UJINKGh9ysSs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd5auvgkt-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Jan 2020 11:11:56 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 11:11:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5EMdPoL3VmuukQx/VhXAw7Gb++cQwT6w4eavcdpR6EWnTwq5y6yQKNJIzALwlwsWGGQqUJzE9jat/mud6P/jLFx6bu5Hq540LYw43PZBPvVdY8vI17kBpSHxjiDd4giA1xaspbv1ZztguLDnpPs+GKZjTAD3Y0vxym2xInLuKlkum5P+2gG9uV2MraHOQDpE6dLNHobJOudnfBnGavwQtsAc5YvQB5urbHhWwO3wS+p+XAlfN7UumyOTia+O3ITvDyAmHDUhJGblIN1YE3kR1Gsn0rpQIQkkc+h5qPAHechFiUl1hN5LEjJ/+pwYWkHgfmfaAeXkc3pYegrGm8jOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6L93epVKkAxNevIBuZfAvo153x+UippwZMLgeHZ27A=;
 b=JukveMinV9KvIENguijFCgfqOshTEY86xlPt4LTwuxrQJFdXkGvBTwTFv9USXFcDG8JsS/Ka8LxqKo9wS9Bo9WLBQqXKU/0sY14TZTQlyU0Cwp0kaUciZiDi2T/BeF7hrJ7XKfXc2BwbKKzoLgWRGw+0jF9JORpHVW5HWPFdw+xUKTAIESJDgasVPxtC2lDyI5X/WFgqo3xJQ5b2F6K7pwQ7zZEcTj8UiMRA9VLMTu+PpNm+c/W8WvVePXVsyT5kU74VP8s/ckFs40E7OFV89lYSZsET15/gA9qr8hNQQaUZ7jXA3riPH4/+7xT3bHWVo6v12ZtmpYfrvXQ5dpk4ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6L93epVKkAxNevIBuZfAvo153x+UippwZMLgeHZ27A=;
 b=jAxorlqu64nqJMfF5+U7Vx5Be4rw2mbcjEs8XTgsHszM87OWR07kx880nsZBZKN7dG4c2MS82ty5Q3nQq5+gIOUu2mg4x+1w4wE1yg+zV19EEb69kc8K6LkNIq2+E+/OcOYAyBPdLW9o7Ci3BFCb7n5NXl0Q3U0bJNuNnY3XcNA=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB2919.namprd15.prod.outlook.com (20.178.239.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 19:11:00 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 19:11:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/6] bpf: Introduce function-by-function
 verification
Thread-Topic: [PATCH bpf-next 3/6] bpf: Introduce function-by-function
 verification
Thread-Index: AQHVxfUHa80wphBbsEuavS3rckiVo6fhIs6A
Date:   Wed, 8 Jan 2020 19:10:59 +0000
Message-ID: <2A66F154-7F54-4856-B6ED-E787EE215631@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-4-ast@kernel.org>
In-Reply-To: <20200108072538.3359838-4-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:180::c159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3924a8fe-c93d-449a-ab4e-08d7946e7f66
x-ms-traffictypediagnostic: BYAPR15MB2919:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2919DBD1087421A486B97D17B33E0@BYAPR15MB2919.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(376002)(39860400002)(346002)(189003)(199004)(6486002)(66476007)(81166006)(478600001)(5660300002)(66946007)(86362001)(6916009)(66446008)(36756003)(66556008)(71200400001)(4326008)(2906002)(8936002)(8676002)(15650500001)(76116006)(64756008)(54906003)(2616005)(316002)(33656002)(53546011)(81156014)(186003)(6512007)(91956017)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2919;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GjWRaOE1P3JQACPPcedjKFRCYrAKtAI2CjaEvpMtv0G3SQm+iorkFDS5eyEoOFQOpy8V/F64ih/1jF+ztLuYIm/WelA9wbG3Adx2LNqJ20JzwvlUrm+tuwoz5e87pcGklsrOuxbGl9IIAisPwUM1WtSOOg2iVR33hb79IVqu8pqmw/3n/SIFjYLnlY7aQKfwKKAQDVd421nhultdolTMzB6Mt62v152UyIzeeo6c/t8HyPXavJuzkeFIEl1bUY3jIhKfKC2cvGEJx+Dr39gC4KCQSmgbShuL3Q2SZ2BWEmKgH9CO+bc5YFWSyCtP5hjRRiBytwYRCfhKq3Yk5D29e5DWMjcSqw6oNZywL3SL553Z1thUBggCxU8doNNFLIWLk7Y/GGJ8/B371nw1ywVJ1u+wvtVIVi6sbXFBYbz7/SvJHM7XX74A4odY+eTemRHh
Content-Type: text/plain; charset="us-ascii"
Content-ID: <93AEFF90F8DA064880E9B4058B64F98C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3924a8fe-c93d-449a-ab4e-08d7946e7f66
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 19:10:59.8114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+Ek/Vbejl6yd+M3ifBEsUD0I0pHj5jhmXkPElnmt7yrKckAC6jPMRT7gJKhsMQGP1vvlqLI/siuTkkMXd3g2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2919
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_05:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 7, 2020, at 11:25 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> New llvm and old llvm with libbpf help produce BTF that distinguish globa=
l and
> static functions. Unlike arguments of static function the arguments of gl=
obal
> functions cannot be removed or optimized away by llvm. The compiler has t=
o use
> exactly the arguments specified in a function prototype. The argument typ=
e
> information allows the verifier validate each global function independent=
ly.
> For now only supported argument types are pointer to context and scalars.=
 In
> the future pointers to structures, sizes, pointer to packet data can be
> supported as well. Consider the following example:

[...]

> The type information and static/global kind is preserved after the verifi=
cation
> hence in the above example global function f2() and f3() can be replaced =
later
> by equivalent functions with the same types that are loaded and verified =
later
> without affecting safety of this main() program. Such replacement (re-lin=
king)
> of global functions is a subject of future patches.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> include/linux/bpf.h          |   7 +-
> include/linux/bpf_verifier.h |   7 +-
> include/uapi/linux/btf.h     |   6 +
> kernel/bpf/btf.c             | 147 +++++++++++++++++-----
> kernel/bpf/verifier.c        | 228 +++++++++++++++++++++++++++--------
> 5 files changed, 317 insertions(+), 78 deletions(-)
>=20
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index b14e51d56a82..ceb5b6c13abc 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -558,6 +558,7 @@ static inline void bpf_dispatcher_change_prog(struct =
bpf_dispatcher *d,
> #endif
>=20
> struct bpf_func_info_aux {
> +	u32 linkage;

How about we use u16 or even u8 for linkage? We are using BTF_INFO_VLEN() w=
hich=20
is 16-bit long. Maybe we should save some bits for future extensions?

> 	bool unreliable;
> };
>=20
> @@ -1006,7 +1007,11 @@ int btf_distill_func_proto(struct bpf_verifier_log=
 *log,
> 			   const char *func_name,
> 			   struct btf_func_model *m);
>=20
> -int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog);
> +struct bpf_reg_state;
> +int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
> +			     struct bpf_reg_state *regs);
> +int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
> +			  struct bpf_reg_state *reg);
>=20
> struct bpf_prog *bpf_prog_by_id(u32 id);
>=20
[...]

> @@ -3535,11 +3537,12 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *lo=
g, struct btf *btf,
> static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
> 				     struct btf *btf,
> 				     const struct btf_type *t,
> -				     enum bpf_prog_type prog_type)
> +				     enum bpf_prog_type prog_type,
> +				     int arg)
> {
> 	const struct btf_member *prog_ctx_type, *kern_ctx_type;
>=20
> -	prog_ctx_type =3D btf_get_prog_ctx_type(log, btf, t, prog_type);
> +	prog_ctx_type =3D btf_get_prog_ctx_type(log, btf, t, prog_type, arg);
> 	if (!prog_ctx_type)
> 		return -ENOENT;
> 	kern_ctx_type =3D prog_ctx_type + 1;
> @@ -3700,7 +3703,7 @@ bool btf_ctx_access(int off, int size, enum bpf_acc=
ess_type type,
> 	info->btf_id =3D t->type;
>=20
> 	if (tgt_prog) {
> -		ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_prog->type);
> +		ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
> 		if (ret > 0) {
> 			info->btf_id =3D ret;
> 			return true;
> @@ -4043,11 +4046,10 @@ int btf_distill_func_proto(struct bpf_verifier_lo=
g *log,
> 	return 0;
> }
>=20
> -int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog)
> +/* Compare BTF of a function with given bpf_reg_state */
> +int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
> +			     struct bpf_reg_state *reg)

I think we need more comments for the retval of btf_check_func_arg_match().

> {
> -	struct bpf_verifier_state *st =3D env->cur_state;
> -	struct bpf_func_state *func =3D st->frame[st->curframe];
> -	struct bpf_reg_state *reg =3D func->regs;
> 	struct bpf_verifier_log *log =3D &env->log;
> 	struct bpf_prog *prog =3D env->prog;
> 	struct btf *btf =3D prog->aux->btf;
[...]
> +
> +/* Convert BTF of a function into bpf_reg_state if possible */
> +int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
> +			  struct bpf_reg_state *reg)
> +{
> +	struct bpf_verifier_log *log =3D &env->log;
> +	struct bpf_prog *prog =3D env->prog;
> +	struct btf *btf =3D prog->aux->btf;
> +	const struct btf_param *args;
> +	const struct btf_type *t;
> +	u32 i, nargs, btf_id;
> +	const char *tname;
> +
> +	if (!prog->aux->func_info ||
> +	    prog->aux->func_info_aux[subprog].linkage !=3D BTF_FUNC_GLOBAL) {
> +		bpf_log(log, "Verifier bug\n");

IIUC, this should never happen? Maybe we need more details in the log, and=
=20
maybe also WARN_ONCE()?

> +		return -EFAULT;
> +	}
> +
> +	btf_id =3D prog->aux->func_info[subprog].type_id;
> +	if (!btf_id) {
> +		bpf_log(log, "Global functions need valid BTF\n");
> +		return -EINVAL;
> +	}
> +
> +	t =3D btf_type_by_id(btf, btf_id);
> +	if (!t || !btf_type_is_func(t)) {
> +		bpf_log(log, "BTF of func#%d doesn't point to KIND_FUNC\n",
> +			subprog);
> +		return -EINVAL;
> +	}
> +	tname =3D btf_name_by_offset(btf, t->name_off);
> +
> +	if (log->level & BPF_LOG_LEVEL)
> +		bpf_log(log, "Validating %s() func#%d...\n",
> +			tname, subprog);
> +
> +	if (prog->aux->func_info_aux[subprog].unreliable) {
> +		bpf_log(log, "Verifier bug in function %s()\n", tname);
> +		return -EFAULT;

Why -EFAULT instead of -EINVAL? I think we treat them the same?=20
I guess this to highlight verifier bug vs. libbpf/llvm bug? How about=20
we use WARN_ONCE() for all verifier bug?

> +	}
> +
> +	t =3D btf_type_by_id(btf, t->type);
> +	if (!t || !btf_type_is_func_proto(t)) {
> +		bpf_log(log, "Invalid type of function %s()\n", tname);
> +		return -EINVAL;
> +	}
> +	args =3D (const struct btf_param *)(t + 1);
> +	nargs =3D btf_type_vlen(t);
> +	if (nargs > 5) {
> +		bpf_log(log, "Global function %s() with %d > 5 args. Buggy llvm.\n",
> +			tname, nargs);
> +		return -EINVAL;
> +	}
> +	/* check that function returns int */
> +	t =3D btf_type_by_id(btf, t->type);
> +	while (btf_type_is_modifier(t))
> +		t =3D btf_type_by_id(btf, t->type);
> +	if (!btf_type_is_int(t) && !btf_type_is_enum(t)) {
> +		bpf_log(log,
> +			"Global function %s() doesn't return scalar. Only those are supported=
.\n",
> +			tname);
> +		return -EINVAL;
> +	}
> +	/* Convert BTF function arguments into verifier types.
> +	 * Only PTR_TO_CTX and SCALAR are supported atm.
> +	 */
> +	for (i =3D 0; i < nargs; i++) {
> +		t =3D btf_type_by_id(btf, args[i].type);
> +		while (btf_type_is_modifier(t))
> +			t =3D btf_type_by_id(btf, t->type);
> +		if (btf_type_is_int(t) || btf_type_is_enum(t)) {
> +			reg[i + 1].type =3D SCALAR_VALUE;
> +			continue;
> +		}
> +		if (btf_type_is_ptr(t) &&
> +		    btf_get_prog_ctx_type(log, btf, t, prog->type, i)) {
> +			reg[i + 1].type =3D PTR_TO_CTX;
> +			continue;
> +		}
> +		bpf_log(log, "Arg#%d type %s in %s() is not supported yet.\n",
> +			i, btf_kind_str[BTF_INFO_KIND(t->info)], tname);
> +		return -EINVAL;
> +	}
> 	return 0;
> }
[...]

