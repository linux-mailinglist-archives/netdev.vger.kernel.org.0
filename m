Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED61E4876D3
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 12:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347251AbiAGLwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 06:52:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57684 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1347204AbiAGLwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 06:52:06 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207AcbK7011446;
        Fri, 7 Jan 2022 11:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=zN9hBf5/b8hYf+c4edxKBImj472NvKS4LOJuAwc0DvY=;
 b=UJ+T/jGZ6Q77u2n9YNk8oIKWyeGq2RJZ23x+ky1n4jeCMfDy5I4abNAOf608qs25vnc6
 j4y5KU9/LV5oMKrz8sPDRMLEz+kcSAsmuxEJLWlCh/x+fSCoZ3R0b1nFq8dBsu5xveDc
 XlFg2T0heyHpIuBvYnsw+scCeFfk4qkl5hoPqpcBh9rq/PPuM4J8zd9TozVyl2z0y8vx
 +x6o2+fnpAzb/OZVm3ou6D9mlcIx56PVAb/JnpzqitZY0haRNX5BmXV+jyRYbr2X3qAM
 VUxiQArd+1UAaz4Vg12oVZ+bNRJ2xypOak6WMlr6gTN1bZkRfSyM/EfvGsnbvoELgZLr rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4whr174-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 11:51:25 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 207BU69A022708;
        Fri, 7 Jan 2022 11:51:25 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3de4whr16n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 11:51:24 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 207Bkmdv024963;
        Fri, 7 Jan 2022 11:51:23 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3de4y2njcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jan 2022 11:51:23 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 207BpKPD34734338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jan 2022 11:51:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5955A4051;
        Fri,  7 Jan 2022 11:51:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 332E7A404D;
        Fri,  7 Jan 2022 11:51:20 +0000 (GMT)
Received: from localhost (unknown [9.43.90.227])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jan 2022 11:51:19 +0000 (GMT)
Date:   Fri, 07 Jan 2022 17:21:19 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH v2 8/8] powerpc/bpf: Reallocate BPF registers to volatile
 registers when possible on PPC32
To:     andrii@kernel.org, ast@kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, sandipan@linux.ibm.com,
        songliubraving@fb.com, yhs@fb.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
References: <cover.1616430991.git.christophe.leroy@csgroup.eu>
        <b94562d7d2bb21aec89de0c40bb3cd91054b65a2.1616430991.git.christophe.leroy@csgroup.eu>
In-Reply-To: <b94562d7d2bb21aec89de0c40bb3cd91054b65a2.1616430991.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
User-Agent: astroid/v0.16-1-g4d6b06ad (https://github.com/astroidmail/astroid)
Message-Id: <1641556157.ms6rd82ggh.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S78ijfzqiXBSNKzrbMvcxNOETxg8mHnP
X-Proofpoint-ORIG-GUID: DuApjOv2WQaYAnZrm_G8vRjmt5RC5w9p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_04,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070078
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe Leroy wrote:
> When the BPF routine doesn't call any function, the non volatile
> registers can be reallocated to volatile registers in order to
> avoid having to save them/restore on the stack.
>=20
> Before this patch, the test #359 ADD default X is:
>=20
>    0:	7c 64 1b 78 	mr      r4,r3
>    4:	38 60 00 00 	li      r3,0
>    8:	94 21 ff b0 	stwu    r1,-80(r1)
>    c:	60 00 00 00 	nop
>   10:	92 e1 00 2c 	stw     r23,44(r1)
>   14:	93 01 00 30 	stw     r24,48(r1)
>   18:	93 21 00 34 	stw     r25,52(r1)
>   1c:	93 41 00 38 	stw     r26,56(r1)
>   20:	39 80 00 00 	li      r12,0
>   24:	39 60 00 00 	li      r11,0
>   28:	3b 40 00 00 	li      r26,0
>   2c:	3b 20 00 00 	li      r25,0
>   30:	7c 98 23 78 	mr      r24,r4
>   34:	7c 77 1b 78 	mr      r23,r3
>   38:	39 80 00 42 	li      r12,66
>   3c:	39 60 00 00 	li      r11,0
>   40:	7d 8c d2 14 	add     r12,r12,r26
>   44:	39 60 00 00 	li      r11,0
>   48:	7d 83 63 78 	mr      r3,r12
>   4c:	82 e1 00 2c 	lwz     r23,44(r1)
>   50:	83 01 00 30 	lwz     r24,48(r1)
>   54:	83 21 00 34 	lwz     r25,52(r1)
>   58:	83 41 00 38 	lwz     r26,56(r1)
>   5c:	38 21 00 50 	addi    r1,r1,80
>   60:	4e 80 00 20 	blr
>=20
> After this patch, the same test has become:
>=20
>    0:	7c 64 1b 78 	mr      r4,r3
>    4:	38 60 00 00 	li      r3,0
>    8:	94 21 ff b0 	stwu    r1,-80(r1)
>    c:	60 00 00 00 	nop
>   10:	39 80 00 00 	li      r12,0
>   14:	39 60 00 00 	li      r11,0
>   18:	39 00 00 00 	li      r8,0
>   1c:	38 e0 00 00 	li      r7,0
>   20:	7c 86 23 78 	mr      r6,r4
>   24:	7c 65 1b 78 	mr      r5,r3
>   28:	39 80 00 42 	li      r12,66
>   2c:	39 60 00 00 	li      r11,0
>   30:	7d 8c 42 14 	add     r12,r12,r8
>   34:	39 60 00 00 	li      r11,0
>   38:	7d 83 63 78 	mr      r3,r12
>   3c:	38 21 00 50 	addi    r1,r1,80
>   40:	4e 80 00 20 	blr
>=20
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
>  arch/powerpc/net/bpf_jit.h        | 16 ++++++++++++++++
>  arch/powerpc/net/bpf_jit64.h      |  2 +-
>  arch/powerpc/net/bpf_jit_comp.c   |  2 ++
>  arch/powerpc/net/bpf_jit_comp32.c | 30 ++++++++++++++++++++++++++++--
>  arch/powerpc/net/bpf_jit_comp64.c |  4 ++++
>  5 files changed, 51 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
> index a45b8266355d..776abef4d2a0 100644
> --- a/arch/powerpc/net/bpf_jit.h
> +++ b/arch/powerpc/net/bpf_jit.h
> @@ -116,6 +116,15 @@ static inline bool is_nearbranch(int offset)
>  #define SEEN_STACK	0x40000000 /* uses BPF stack */
>  #define SEEN_TAILCALL	0x80000000 /* uses tail calls */
> =20
> +#define SEEN_VREG_MASK	0x1ff80000 /* Volatile registers r3-r12 */
> +#define SEEN_NVREG_MASK	0x0003ffff /* Non volatile registers r14-r31 */
> +
> +#ifdef CONFIG_PPC64
> +extern const int b2p[MAX_BPF_JIT_REG + 2];
> +#else
> +extern const int b2p[MAX_BPF_JIT_REG + 1];
> +#endif
> +
>  struct codegen_context {
>  	/*
>  	 * This is used to track register usage as well
> @@ -129,6 +138,7 @@ struct codegen_context {
>  	unsigned int seen;
>  	unsigned int idx;
>  	unsigned int stack_size;
> +	int b2p[ARRAY_SIZE(b2p)];
>  };
> =20
>  static inline void bpf_flush_icache(void *start, void *end)
> @@ -147,11 +157,17 @@ static inline void bpf_set_seen_register(struct cod=
egen_context *ctx, int i)
>  	ctx->seen |=3D 1 << (31 - i);
>  }
> =20
> +static inline void bpf_clear_seen_register(struct codegen_context *ctx, =
int i)
> +{
> +	ctx->seen &=3D ~(1 << (31 - i));
> +}
> +
>  void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx,=
 u64 func);
>  int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_c=
ontext *ctx,
>  		       u32 *addrs, bool extra_pass);
>  void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
>  void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
> +void bpf_jit_realloc_regs(struct codegen_context *ctx);
> =20
>  #endif
> =20
> diff --git a/arch/powerpc/net/bpf_jit64.h b/arch/powerpc/net/bpf_jit64.h
> index b05f2e67bba1..7b713edfa7e2 100644
> --- a/arch/powerpc/net/bpf_jit64.h
> +++ b/arch/powerpc/net/bpf_jit64.h
> @@ -39,7 +39,7 @@
>  #define TMP_REG_2	(MAX_BPF_JIT_REG + 1)
> =20
>  /* BPF to ppc register mappings */
> -static const int b2p[] =3D {
> +const int b2p[MAX_BPF_JIT_REG + 2] =3D {
>  	/* function return value */
>  	[BPF_REG_0] =3D 8,
>  	/* function arguments */
> diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_c=
omp.c
> index efac89964873..798ac4350a82 100644
> --- a/arch/powerpc/net/bpf_jit_comp.c
> +++ b/arch/powerpc/net/bpf_jit_comp.c
> @@ -143,6 +143,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*fp)
>  	}
> =20
>  	memset(&cgctx, 0, sizeof(struct codegen_context));
> +	memcpy(cgctx.b2p, b2p, sizeof(cgctx.b2p));
> =20
>  	/* Make sure that the stack is quadword aligned. */
>  	cgctx.stack_size =3D round_up(fp->aux->stack_depth, 16);
> @@ -167,6 +168,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*fp)
>  		}
>  	}
> =20
> +	bpf_jit_realloc_regs(&cgctx);
>  	/*
>  	 * Pretend to build prologue, given the features we've seen.  This will
>  	 * update ctgtx.idx as it pretends to output instructions, then we can
> diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit=
_comp32.c
> index 29ce802d7534..003843273b43 100644
> --- a/arch/powerpc/net/bpf_jit_comp32.c
> +++ b/arch/powerpc/net/bpf_jit_comp32.c
> @@ -37,7 +37,7 @@
>  #define TMP_REG	(MAX_BPF_JIT_REG + 0)
> =20
>  /* BPF to ppc register mappings */
> -static const int b2p[] =3D {
> +const int b2p[MAX_BPF_JIT_REG + 1] =3D {
>  	/* function return value */
>  	[BPF_REG_0] =3D 12,
>  	/* function arguments */
> @@ -60,7 +60,7 @@ static const int b2p[] =3D {
> =20
>  static int bpf_to_ppc(struct codegen_context *ctx, int reg)
>  {
> -	return b2p[reg];
> +	return ctx->b2p[reg];
>  }
> =20
>  /* PPC NVR range -- update this if we ever use NVRs below r17 */
> @@ -77,6 +77,32 @@ static int bpf_jit_stack_offsetof(struct codegen_conte=
xt *ctx, int reg)
>  	return BPF_PPC_STACKFRAME(ctx) - 4;
>  }
> =20
> +void bpf_jit_realloc_regs(struct codegen_context *ctx)
> +{
> +	if (ctx->seen & SEEN_FUNC)
> +		return;

Can't you remap BPF_REG_5, BPF_REG_AX and TMP_REG regardless of=20
SEEN_FUNC?

- Naveen

