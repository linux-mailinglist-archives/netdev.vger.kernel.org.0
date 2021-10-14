Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBE842DF4A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhJNQmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:42:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231839AbhJNQmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:42:12 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EGGqhN029341;
        Thu, 14 Oct 2021 09:40:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FIfuEQ2kMVXVm7rHB9ZiVZjoQEDmtw68wQPHxd2JeQ4=;
 b=GemaQomJmcG08x3+LZeuXIyCaEn3Gm6RHvIGc7/x5MNTaWcWPtD2XAL/9O3gneMkxWEJ
 weBzfxSRxTwCBv8eKqrEhaOWwjGpXuWbMPBMJANGDaW942OpKDYSxdtGp7ZsI+kdlsv5
 X6bLVjhtMU0N1aE92vWdiQglX0O9JINQdRE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bpqx6r5tq-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Oct 2021 09:40:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 14 Oct 2021 09:39:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNJgx509Aq3PQMeGZSSkweGoQvhYSjp8K/ep+vnkC1dyQh1CSFuO69wypc1pu/2zFbah8BMJMlb9j85Wl66nOS4jX3H0bv5kC0nvmcHu6T/Fjh54d/1LXmrtMqFIjRnpRuqyuYznjTJi1wEAQYM4/j09AhXQvzRW9qreu7Sfo97ycDWEbVLHasDdRt3/b2PmVl5U55wFJvNYQ5B5aG8qU/ocs8R9YSMJTEkrX7H9D9IrOR/+lXFGaQTaGRMi4EZgP4kO0zmQzy/l0XHUe7eLUf5wCemLRqxxu1sSM89iJEu8OjGtVZvuzld/yraRWvqQ3oFTadIZ3VuN9YdeeNLI+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIfuEQ2kMVXVm7rHB9ZiVZjoQEDmtw68wQPHxd2JeQ4=;
 b=Wli8fNXUG8oB0Ilw49VdqI+qync/t9ETrDVrw9JRiGWjtfHHJbb3A/6c/gXSS2uTlvONuvZytAAFMJa0whgcQZ30IrIOH0ceaZDLAvCtZNsg/eV3nTwZyjo/0PLL8WjOjQAxZrN7oC4RfYwiNWeJYxeTnAxcni9H8c3nCAyAXR4r8LWgmplTf34fLLd8iEiM1fZSzyznd2liG8yn5DPhTy7kXURwZAb7etjKlVQBbcxmo7lNKURoFPfGcEEikRpKL3RuibZnAVb0vG8ueKuP5Mq4rovqu4pAASvyCJG13J/AWS5ZOwPp0cAwqM3a+9hw1ACEuaI4FLT0t0VBIklkHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5233.namprd15.prod.outlook.com (2603:10b6:806:228::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 14 Oct
 2021 16:39:43 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 16:39:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 2/8] libbpf: Add typeless ksym support to
 gen_loader
Thread-Topic: [PATCH bpf-next v2 2/8] libbpf: Add typeless ksym support to
 gen_loader
Thread-Index: AQHXwASx++unaISYJEyX6u07mIr+66vStCMA
Date:   Thu, 14 Oct 2021 16:39:43 +0000
Message-ID: <F745CD84-E520-4DCB-B9F1-0C4F0014CBFF@fb.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
 <20211013073348.1611155-3-memxor@gmail.com>
In-Reply-To: <20211013073348.1611155-3-memxor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac3ccaa5-2b34-4c94-b001-08d98f3139c6
x-ms-traffictypediagnostic: SA1PR15MB5233:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB523316EBE797A5F46979532BB3B89@SA1PR15MB5233.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ls1ntBTLihdkbJs9gm5hsXq9QZovzQUufkS2w2GwtE4tVzjotlO2EJoqxHSR4+cbKkoGeBIcidX1eLJFyyBBJWc4GD4kQcJk7OkecBrlt6xezpjEB8VsTj/s0lJi8OzlPBqi9vwoPYrfuDEr17eeu8zJ3fVFDFiOz6dqdppqh5dGQYj1VZN0UUiyOGPR28CuWrHD6YBKHM+mW03qdi6Z+9bWaTyC5m7G4nwjsHliEUr3i4qjc7evSu08hIv5OkMyBnfU5pSNjSrRNBVD6yQoV9OJ7qAeWePTHsKTFnidb1hEPJdShWou26ZPvDs779QPcZaOeifAPybiYR5dQw82wr9HsoDHtE8tx5sBX3yKnRNxaxuhRtj8astjAmU6+63nILzR63WzoRIBgMivOjj3LS7tBo6gEalHtBbVpqDo8snp77rQF3/SWkl7b0NCiHGcrkOqYFtBVagUyDuG9SFxDWmm7ggXY4fseQa25miLx1abesR3yJm2Md6UYYqWqTe8G02cseYoHMfQkyV3kfP0lUtbUQbLUmS/wnAqXPJY+Am+w/vA5kR7vRHqC4lWnxMSQ90LAdnjS1yv0X5FfH8lctGc/zC7XMdrq2r4Z+/Cg5p+QKgfQ/GXTTPf8me3PLSYi1CbM1VcZMlIEqsJxIzcr7GomR8sHigCzMo+V3X0jptb3y7Vidkw0R8bDqvw62VMLvvKujD5bneyUYd2qqswIHpiCyw3G+grn6ZKP3Fj/RT53AsaDET4PBVmZaPYHCD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(2616005)(38100700002)(38070700005)(91956017)(76116006)(6512007)(66476007)(6506007)(6916009)(8936002)(5660300002)(316002)(186003)(508600001)(54906003)(64756008)(71200400001)(66946007)(33656002)(66556008)(6486002)(8676002)(83380400001)(53546011)(86362001)(66446008)(2906002)(36756003)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?1TC5PxeZbZ/9UWpMI2La55HupE+jFsm7QmgW2Y7hubmj/nKHIJyBx5Tfd7?=
 =?iso-8859-1?Q?0R7gSECNrehDXBQi87wmvza1LSA5zt/NzxR7qcu8pY3q4+dNV4cBq9+bM/?=
 =?iso-8859-1?Q?4TUKpr/ONk80kcx1qXg8Bnl403O21UgQawghCXW8q9lETLK8WauqyX3oVd?=
 =?iso-8859-1?Q?WyvV1I0VXP1PDQv1C0Vw+T45Xqfix7dxQwDP0hsz9syx9ND2mSZeJuRs87?=
 =?iso-8859-1?Q?nrySxUk6THaMsYKFeCBqcvmqR3avOxUOFbwupWNAZmKggiJj1qmXyZ5/Mk?=
 =?iso-8859-1?Q?ltja9s+80zMqvM+Y8agEkCLSjT+Cs95v5Ux1WDSWmVBx6INrEeBAPCV0ER?=
 =?iso-8859-1?Q?B4Wr4q9Dtl55seth7vFRedz5BPeCR8/3mD58+UGn1chvMLS27pd/rnG8sh?=
 =?iso-8859-1?Q?Yl8jvTHGWvYvPz2ocTcXzWA4yLK2ExzJZDcxXvpO+UAPKKBiF/SDOzXVxT?=
 =?iso-8859-1?Q?Kf1dBDcA2+Yrwv5q5BO3RXw7Eqhb/HfFnkfWPBv3AaWxPGMDITzbssN/mR?=
 =?iso-8859-1?Q?l4Wdr52Egd/6ErW+vQakIHy/Ywa/h+AZZ2pt9kdQMb/2K/TTK2OTjRb5Cc?=
 =?iso-8859-1?Q?KEeoLkzpbF3CMiDyL0YGdqXgSgvvRGydOMQT7ifJMflpP0/r7YypxFVOfx?=
 =?iso-8859-1?Q?pqIUi+ANP30svf39mFxmb+GjvgJWT1xSB2BAahAztYqmyWGrCAJ9Hj/aou?=
 =?iso-8859-1?Q?kWOQQvj4dWB+4zqQnaUxoAcjatMwaKyfbiuWASzz30m6TxHm9reNr6gstx?=
 =?iso-8859-1?Q?C25q6bmb1dV2hiAdvy9HJ+beXzsW46lWQ9iA5ucJi9ruSCDPCGDSHxiBtJ?=
 =?iso-8859-1?Q?IpuwGPoE7iDTEWuJ23TxRCzeKI8F83VhCaouvJdMBPyV4Lsphu3lL5SceU?=
 =?iso-8859-1?Q?vtyn1KIxKRoSNLFu7ARHnRZ+KEVDRa88C5rtgqpBx0jKPu8k5+Np5Xo/qB?=
 =?iso-8859-1?Q?h2/29CaEoLLT/wt6z0Z3UQX4G7HBTc3sgqqYluDJlN2ZaEgR9vVi7pMRXo?=
 =?iso-8859-1?Q?CvRWyamS+aDIMKfirCiLYujDCswXNH44IzJG9oHnDLbDXP88eE4bxAKQlJ?=
 =?iso-8859-1?Q?bYcUPULuYkfenjen26spDkvlbc+O5kA2L4HW//oy6ZDMI+GXd74y5mgSD3?=
 =?iso-8859-1?Q?JrbwcMVQ3EvcVJ4LZfENOSLP5aQ2zlb+LbYE5+KrQkEG4Ya1+kkOXw/ZuY?=
 =?iso-8859-1?Q?ugd1ZCHEFC5tgCHFFiHO/9sZjOCf8QQ0ZEiGgZhInI34tb4qrKW2f8DuwR?=
 =?iso-8859-1?Q?ATfeiWG9uKt6CqkxTU4wnuFDEipAQ2dn+bCJr26oi6M0nRQahHa2j/7XwY?=
 =?iso-8859-1?Q?jC6lhwxm8+4TRTbQWgVZKoPiOirQ5xfaF1nj2qzxnaaAeLcPUApOePvNXe?=
 =?iso-8859-1?Q?if5tiRRrD3ztFwv2+XdniUUkNe8bTI/S2UA6lJ7eFPniJ/vLE9T9c=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <5CDFB74D9949FB44901E31736E2353B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3ccaa5-2b34-4c94-b001-08d98f3139c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 16:39:43.3569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sE+nH6jaXR6MIzkCjFw7VV2CWFqAMYJtgDEjbYd4uqi501MLPcKEhHYTKVbKgT5DyU5MQxHe9BhGtWezGVLPIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5233
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Bx4ImrWy9emHe20zsgX19_Y18s8PQiLc
X-Proofpoint-ORIG-GUID: Bx4ImrWy9emHe20zsgX19_Y18s8PQiLc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_09,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 13, 2021, at 12:33 AM, Kumar Kartikeya Dwivedi <memxor@gmail.com> =
wrote:
>=20
> This uses the bpf_kallsyms_lookup_name helper added in previous patches
> to relocate typeless ksyms. The return value ENOENT can be ignored, and
> the value written to 'res' can be directly stored to the insn, as it is
> overwritten to 0 on lookup failure. For repeating symbols, we can simply
> copy the previously populated bpf_insn.
>=20
> Also, we need to take care to not close fds for typeless ksym_desc, so
> reuse the 'off' member's space to add a marker for typeless ksym and use
> that to skip them in cleanup_relos.
>=20
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
[...]
> }
>=20
> +/* Expects:
> + * BPF_REG_8 - pointer to instruction
> + */
> +static void emit_relo_ksym_typeless(struct bpf_gen *gen,
> +				    struct ksym_relo_desc *relo, int insn)

This function has quite some duplicated logic as emit_relo_ksym_btf().
I guess we can somehow reuse the code here. Say, we pull changes from
3/8 first to handle weak type. Then we extend the function to handle=20
typeless. Would this work?=20

> +{
> +	struct ksym_desc *kdesc;
> +
> +	kdesc =3D get_ksym_desc(gen, relo);
> +	if (!kdesc)
> +		return;
> +	/* try to copy from existing ldimm64 insn */
> +	if (kdesc->ref > 1) {
> +		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
> +			       kdesc->insn + offsetof(struct bpf_insn, imm));
> +		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct b=
pf_insn, imm), 4,
> +			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_in=
sn, imm));
> +		goto log;
> +	}
> +	/* remember insn offset, so we can copy ksym addr later */
> +	kdesc->insn =3D insn;
> +	/* skip typeless ksym_desc in fd closing loop in cleanup_relos */
> +	kdesc->typeless =3D true;
> +	emit_bpf_kallsyms_lookup_name(gen, relo);
> +	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_7, -ENOENT, 1));
> +	emit_check_err(gen);
> +	/* store lower half of addr into insn[insn_idx].imm */
> +	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9, offsetof(struct bpf_=
insn, imm)));
> +	/* store upper half of addr into insn[insn_idx + 1].imm */
> +	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_9, 32));
> +	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9,
> +		      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
> +log:
> +	if (!gen->log_level)
> +		return;
> +	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
> +			      offsetof(struct bpf_insn, imm)));
> +	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8, sizeof(struct bpf_in=
sn) +
> +			      offsetof(struct bpf_insn, imm)));
> +	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var t=3D0 w=3D%d (%s:count=3D%d=
): imm[0]: %%d, imm[1]: %%d",
> +		   relo->is_weak, relo->name, kdesc->ref);
> +	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct b=
pf_insn, code)));
> +	debug_regs(gen, BPF_REG_9, -1, " var t=3D0 w=3D%d (%s:count=3D%d): insn=
.reg",
> +		   relo->is_weak, relo->name, kdesc->ref);
>=20
[...]

> +++ b/tools/lib/bpf/libbpf.c
> @@ -6355,17 +6355,14 @@ static int bpf_program__record_externs(struct bpf=
_program *prog)
> 		case RELO_EXTERN_VAR:
> 			if (ext->type !=3D EXT_KSYM)
> 				continue;
> -			if (!ext->ksym.type_id) {
> -				pr_warn("typeless ksym %s is not supported yet\n",
> -					ext->name);
> -				return -ENOTSUP;
> -			}
> -			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
> +			bpf_gen__record_extern(obj->gen_loader, ext->name,
> +					       ext->is_weak, !ext->ksym.type_id,
> 					       BTF_KIND_VAR, relo->insn_idx);
> 			break;
> 		case RELO_EXTERN_FUNC:
> -			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
> -					       BTF_KIND_FUNC, relo->insn_idx);
> +			bpf_gen__record_extern(obj->gen_loader, ext->name,
> +					       ext->is_weak, 0, BTF_KIND_FUNC,

nit: Prefer use "false" for bool arguments.=20

> +					       relo->insn_idx);
> 			break;
> 		default:
> 			continue;
> --=20
> 2.33.0
>=20

