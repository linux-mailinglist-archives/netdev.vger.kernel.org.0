Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3639330D092
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhBCA5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:57:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231511AbhBCA5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 19:57:40 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 1130atvE028467;
        Tue, 2 Feb 2021 16:56:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=57oh/tjIWi+rirYX3ElxKvoUT9LiqoSok6o/Fmhdim8=;
 b=Zgqtkv2LKT5qqMjBWsp+0pSsOfynZ8GKrIq/3gfiKrpPQL58tyzHKnCYs+4e8QowZNtO
 GbnEHuj0rvURkytF0mZtctDFpNPZtOOZ/8Rzq4KeUdA7IPpxAuw3FWueNGlkcYKRAYll
 aNLpr3EM2Pz6Cayi/X7BS1tL1UxnG974H3U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 36f3ehvy8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Feb 2021 16:56:43 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Feb 2021 16:56:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXc5DjxWMuLUllxdFjGk9QbjRisbXlklb1Xz83e2awKeHmO0KTYMj2jEneJQZpfaqwWCmsCrWHh3MCulyG6t+e7n073w46j9BWWRTjFGLF/cAlXxyp6CoPBfGbxUpAMZrSgLPMVR23Du0W3HUTvPyMqkze9hFcBwPFZdKIfiL/VZwq6ezOtelDApLarui+az5acqoqk/aEZJ6fal8FSIJEwAJuPEQvPxy7vSM7WAq41RFFTD8MEPcnvJBk6tw/XhhQVcYM0091u9YReHj2/AYE2lzRkXLUGG2GxMgprmyeJOUurlBs4rTVb9EOaU6aVG/w4EGIB6wtEXKUm/7fsjCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57oh/tjIWi+rirYX3ElxKvoUT9LiqoSok6o/Fmhdim8=;
 b=Nuz6/Q8oE0QZZpj0H7414UjLsv3VtUSBAtMoJPbkMWlhqfIXk5eFB8buAhmmX0IEvJbEgkDVJ5boaYekOV3Tcu/NVrPhGXKLhFFUFOq8hGXEv0/045qVEaCahzAO0uWVvBkXByRb2wynGjldqD9j3O8cCmw+nF8+7bYxpG5luxDO0qnRLRKYQQhdTmuHLtrKv8b+DYKP6c9n203EPFdIh1P1N1h1i7Y8DMUBJfDrpcyTe6tsBXyI3T3fIariQnWmHfI+BB5laZ0orzp2sh2uGJdb3VoCN6kRX6PjWh4h7OXtSJ+8au/SnflJQWFSKRkag3Aq8OL7XtTo/CIPlejz2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57oh/tjIWi+rirYX3ElxKvoUT9LiqoSok6o/Fmhdim8=;
 b=D48fbo653kndFtqVbaqkJJ68koQrXlE5IBnBJbugmOAeMRhBkcQ6INGNu0ESzGrblr2Qm5VIc4Iv7OMNUyFt8KUjKOpxSNrjCVv2vS6xrFJDJBQVHXyD7NJ8JLZcrYRU8A+ItEOkNBL+/4LhcBk4d/7PcKDGB0eT9poCphTklQc=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.22; Wed, 3 Feb
 2021 00:56:39 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Wed, 3 Feb 2021
 00:56:39 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: Emit explicit NULL pointer checks for
 PROBE_LDX instructions.
Thread-Topic: [PATCH bpf-next] bpf: Emit explicit NULL pointer checks for
 PROBE_LDX instructions.
Thread-Index: AQHW+SXQtvupKOqI8UORYGsvttx/VqpFnI4A
Date:   Wed, 3 Feb 2021 00:56:39 +0000
Message-ID: <A746402C-245A-4FF1-AB54-585537EEBA9B@fb.com>
References: <20210202053837.95909-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20210202053837.95909-1-alexei.starovoitov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:22af]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 003e61a9-21b6-467c-aa3e-08d8c7de9081
x-ms-traffictypediagnostic: BYAPR15MB3461:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3461ACF863492626F6E5E1F2B3B49@BYAPR15MB3461.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: clVB1oxvrAGARqKhmn07iXTxow8w6fzDjEp8O+CHPOmnptofpxPv0W8ZM/vjDF1nFoJexY4bs/txn54h+JnrIJAANC9KLNEafSwbSuCN9ZgKFef+LR5ph0iaoKoOolRG3WfzQxZERT9eo07NNjvfb4wFFq/7Vcl6RpYBi5sIDj825oi2bFmTCOVLU3V6buhqdZJw+xpO/+XdGQ1Q7iyb3HYJmsTyJNBQb9bGOrYWXXumewS7D8oVkWcCYNge+wapO4NEloFILjJnoUM4bcriG9OQw3cB4fcjebNOA1PsZrloo8uhTdhCE0qYQqNZILz+9Zd9XQRWb5xqIbKKGDzs6N8K5+esRvpaBs7XYi294VBPAZodUsaHgFcZoAKTGgHVcSPzRDzrusD+r1vnSqCyBh/3aBv6bvvrsvF6nKn222ZpdNtScPU/bvT8Dwu2gUTxyeRuBopPULbVLRbbCA/A2TC0b1JocJrh0Jvv/1TZgtBT2Ch4Ub9D3RXWU8H6WnvYS2ADNL3HYvTW9VhfE5n96uL9ywR5hkCMOUKVgfaFLB75l8WD5W6dSq0HiJnqb4T9CxRjkiPpu7gOAZHUSwHApQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(366004)(39860400002)(64756008)(2906002)(5660300002)(66476007)(8676002)(91956017)(33656002)(71200400001)(478600001)(36756003)(54906003)(6512007)(2616005)(316002)(86362001)(66946007)(53546011)(186003)(6506007)(66446008)(6486002)(76116006)(6916009)(4326008)(8936002)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qmru3eNn6XRQ6h8io6LN48jVqAM7c+W93Rf1B6jIAVhXmk9e3vkjbOOLdv9D?=
 =?us-ascii?Q?e7f8FMSZoStbtNV3m+0pv0lgJrJpCAP/kb9fuVx/BCtM3NUUnUZQsaag6TBW?=
 =?us-ascii?Q?R+QheR40uMm3jY4B02ub5Cj2otCHuJJSvY/3rK6pCJ9x8HEfizbC1CW/Zl17?=
 =?us-ascii?Q?DVQwv9J41uZuY38FjiSyxvX1NzoYW4VxTDkng+lWWB0jMAdLNibR+1iRIDKS?=
 =?us-ascii?Q?Fs5PYjrUBLaqkns6a0HL2bVPIedBUhTA7sQJCVkFZlieTlt//FAxS4x3dcMq?=
 =?us-ascii?Q?Y0fCZXAco21q+ywNie3rlsgcuZZVtEcBvYVzKIpllNelfSo1nVT/MYYwZSCV?=
 =?us-ascii?Q?DqMh6LiBdN0bJM+3AMDYoLo1scc+PACd8gYfLvHpS95VYKWKmxUf5bTteHKP?=
 =?us-ascii?Q?Qy5b/DpKpEoNanKLdgUzhpyoTdEr1eqeXiXphh+PXXOHxdU5aMB6VvfqDUD9?=
 =?us-ascii?Q?vmcx5ZbRiu3cMsP2DNRBC31leXVhBgvZ3yNuiW7CNwxYbBIMi/7ri0lB/opE?=
 =?us-ascii?Q?zOR6qGomfRhv9cytLnXyigRprZuyxOxmZmABeI+PxRA1f8OhsjLAtoB4dxG6?=
 =?us-ascii?Q?6uX5sPAc4qtUxwQidYBBSVCm0QWdzWgjJZLeZJZW1wy1vTeyDf20t/TtoJk1?=
 =?us-ascii?Q?tllEzIFKFoKeZgxRsgfG6ojb+xFYbcSETCe0mnntl64uqWv9tan3y/tJG5Iu?=
 =?us-ascii?Q?Iz5jSRQ0Vz8BIdSohAOgRjpeXVua7/DAtu2EGL2zcLHYyqpZ05OewFrNyD6h?=
 =?us-ascii?Q?Fkb1WrBzNURhClAzEQUbFVTalgjDylEeRHlUm3KJO3F7STUF1quXJcbxoM6p?=
 =?us-ascii?Q?khuJ69dV/027aEIpcpEVUMs8xTRVKrGKniU9j8M00IExhIHLyIjty0IBCNgD?=
 =?us-ascii?Q?EMeI/8CNVTct9Bl0R+E/ALa6eW6oRbY21WkViSWsbNUmoNkfpz5mBaZy2tpC?=
 =?us-ascii?Q?e4mmHzlnEimmJF3WcvnSLCP67XQvYt3HCUVQ2nkqfMEHdaxVzFDF1Gmpd6xg?=
 =?us-ascii?Q?sr2SXSJLsJurOdUgrXdX4u+ZuRFN/ZOrKp1/oemoe+47mo0SIT8JS4RB50EB?=
 =?us-ascii?Q?Uqy0DI5pYtXtj4QeL1VDhxRYIlFZn3rFkLIoA9rqsxdN/Jpdkd4xnhcGkwaI?=
 =?us-ascii?Q?YlTJNeSZK8xG1wBXtPig3EwYLxiFbbphMV69AucgTdfi90QgEdBBy51S1SAm?=
 =?us-ascii?Q?Y1nuuqef86VO3S8t3p6NUUmm9tODTKniONaJQ/WWkoaHY14QFltCRb9TYdIu?=
 =?us-ascii?Q?s4kWHMg8iEm1gq2pmhhpQrOSQ92ZZ4vbFbDA+0RXbnN/bfl3Ioc55X4ZlvTp?=
 =?us-ascii?Q?AyW/TPxx1qAyRv5/sWSP5NI3kE85UDFcKY2jR3xAStYYh8Jd8tGrANh618VZ?=
 =?us-ascii?Q?f3i60LU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA431747F49B0240AA851588B0AD8981@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 003e61a9-21b6-467c-aa3e-08d8c7de9081
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 00:56:39.2849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y1V0xO79tzjU1DY+ZuOrFJNSOZUL1/7Vxv0MzeN6QFmHHzV2W54OEo/kH1PVqDeB43xeZ6Tnv1kwFZlcwQV48A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_13:2021-02-02,2021-02-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 1, 2021, at 9:38 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> From: Alexei Starovoitov <ast@kernel.org>
>=20
> PTR_TO_BTF_ID registers contain either kernel pointer or NULL.
> Emit the NULL check explicitly by JIT instead of going into
> do_user_addr_fault() on NULL deference.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> arch/x86/net/bpf_jit_comp.c | 19 +++++++++++++++++++
> 1 file changed, 19 insertions(+)
>=20
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index b7a2911bda77..a3dc3bd154ac 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -930,6 +930,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
> 		u32 dst_reg =3D insn->dst_reg;
> 		u32 src_reg =3D insn->src_reg;
> 		u8 b2 =3D 0, b3 =3D 0;
> +		u8 *start_of_ldx;
> 		s64 jmp_offset;
> 		u8 jmp_cond;
> 		u8 *func;
> @@ -1278,12 +1279,30 @@ st:			if (is_imm8(insn->off))
> 		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
> 		case BPF_LDX | BPF_MEM | BPF_DW:
> 		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
> +			if (BPF_MODE(insn->code) =3D=3D BPF_PROBE_MEM) {
> +				/* test src_reg, src_reg */
> +				maybe_emit_mod(&prog, src_reg, src_reg, true); /* always 1 byte */
> +				EMIT2(0x85, add_2reg(0xC0, src_reg, src_reg));
> +				/* jne start_of_ldx */
> +				EMIT2(X86_JNE, 0);
> +				/* xor dst_reg, dst_reg */
> +				emit_mov_imm32(&prog, false, dst_reg, 0);
> +				/* jmp byte_after_ldx */
> +				EMIT2(0xEB, 0);
> +
> +				/* populate jmp_offset for JNE above */
> +				temp[4] =3D prog - temp - 5 /* sizeof(test + jne) */;

IIUC, this case only happens for i =3D=3D 1 in the loop? If so, can we use =
temp[5(?)]=20
instead of start_of_ldx?

Thanks,
Song

> +				start_of_ldx =3D prog;
> +			}
> 			emit_ldx(&prog, BPF_SIZE(insn->code), dst_reg, src_reg, insn->off);
> 			if (BPF_MODE(insn->code) =3D=3D BPF_PROBE_MEM) {
> 				struct exception_table_entry *ex;
> 				u8 *_insn =3D image + proglen;
> 				s64 delta;
>=20
> +				/* populate jmp_offset for JMP above */
> +				start_of_ldx[-1] =3D prog - start_of_ldx;
> +
> 				if (!bpf_prog->aux->extable)
> 					break;
>=20
> --=20
> 2.24.1
>=20

