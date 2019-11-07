Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B38F3B8D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfKGWho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:37:44 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52866 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfKGWho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:37:44 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7MYNnH023103;
        Thu, 7 Nov 2019 14:37:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HjXHiuP8p4nFuPixuKwxRbPs0+Ofmg92JhKxPxTomcg=;
 b=difWpaO191YDAdEfSONBDakTAhSEQtsSP8HEylJJ7+/V0ConAJBA2CoKlWCrY/UMv6zT
 3hVvQRq/f05UGKZ36EEZGFweBYCX0npq/atMEG+Y57jP5SQYjwcKykOmxL3Nl8nFLuJb
 GbcIGT2QRD8ZntM85NwG/N2OkVBK4HKgyuk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0quh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:37:24 -0800
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 14:37:22 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 14:37:22 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 14:37:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNRIuubtKJ+Ls0JbNHWNPLBvOA9CmPl3kYRUXGXO8PLGaeNn/csTibpY+k/ZhpOj2wotOgB1Dov9y1a9nT3WKswQvmfbT6DLoXw7ngnopaPt5nWjPCPba/8/4rVEFUz12EdpA1bg8Dj+YjVdjkZj8kYk+VziKYwcC9/NKbNna4oMQ2F9Vsr644aQIE8adqU8v58kRM3g9GVBjDgXI4+3jAFTQ6PeacQJVsS4xcePbLg2WtO+cdNazG5vLGUaQErinjGJpyySdZ8bOHrPDMZt6ChxlkVmCwgydVbgOIgZo5qiYp6v6NwlaPC783yT9/yMtbYAq3X26+ijH6t1RJRpqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjXHiuP8p4nFuPixuKwxRbPs0+Ofmg92JhKxPxTomcg=;
 b=GU2UwMnNpmRxBBEt1vJoZriTCUl0oKpEtkWBXDb/gluXfEp4a6LKVa3tVBd4z8NJ0YaEabyfVnOS0i0tSqjK5Af1BsGo+DGhCJrnhnLHRhoczBAYB9DjraXxgOjYa+cGILVaAB6cnSGRpjomYHDPQZvOTRGAK77dyD7nmFj50WXjWTFW3TWP1BDwkSe/s0FH2/Sn3lRHRO5hwJNCVh8BiayquMLBaGpWJp8Ngxo7E5N76Gihw/2tas6M4POqxsSoJtm8rfHv21XUSa55sPAbgqP7QS1I+O/n2J5yDLPOjD71W+SVUDNOIn60T3sKdSH0cNoKlC0Bs4G9FBs17OcJwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjXHiuP8p4nFuPixuKwxRbPs0+Ofmg92JhKxPxTomcg=;
 b=fq0apvD5pyR5GG7CJzbatXO//y07ZOvmlb6BT/cM9L12A3WvUVxG6Z1oB7IN5Qcm1SExMhmjxHHLuxgDVmSnB+qqRIsu4K9TLyTlSLP7JYqvx63Xx/wyXRiDRq0OwupMWJfPoRLgKxGALrtHR3xzLXt++tr+UaLCARxgpHtK7pQ=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1152.namprd15.prod.outlook.com (10.175.3.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 22:37:19 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:37:19 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Thread-Topic: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Thread-Index: AQHVlS7H2riFVn1w60W5YsSPSMrqRaeATXQA
Date:   Thu, 7 Nov 2019 22:37:19 +0000
Message-ID: <5967F93A-235B-447E-9B70-E7768998B718@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-4-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-4-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b458be7-b80e-4f15-f341-08d763d30c5a
x-ms-traffictypediagnostic: MWHPR15MB1152:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1152D7D28FAE7E62868E8105B3780@MWHPR15MB1152.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(366004)(346002)(396003)(199004)(189003)(76176011)(2616005)(14444005)(36756003)(54906003)(33656002)(446003)(11346002)(71200400001)(6512007)(8936002)(102836004)(316002)(71190400001)(4326008)(6246003)(86362001)(186003)(53546011)(256004)(6506007)(486006)(99286004)(476003)(2906002)(305945005)(6916009)(229853002)(6436002)(6486002)(5660300002)(30864003)(66556008)(6116002)(66476007)(66946007)(64756008)(66446008)(25786009)(76116006)(478600001)(50226002)(5024004)(46003)(81166006)(81156014)(14454004)(7736002)(8676002)(569006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1152;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dyC0PhlPctiADUEjsNwALNrbqwp+YF69+uprn15wutvtiI4nNtWOnSgoVPZazAYLU6hqFOXSd5RD27TnjcAuTb9LeeguvK89HJBhQe8SAzMmx3Fulo4g214ocjDYHbzZIfvL1NRJvY1Vp2RSPxRfQgYXe+NC36Af9LiWhD9KOL35efnIN1j4D0llQI45RpoAXH15DNOZ8WFVOohL4dcT+5CrXYgKYHmChejuFGYAeSU4HJwbBkFCqLFtp2+TIeFcH8t50u1P0TGeKp+nCgMkXnHaBUXb69LgoiBAJAtg8i0zMbhKlCDL+6KCYfcG5i6P8CXh42bz9NHyMQDRv8v19dmf81d5g+Pwq1zNaFYqLkjpZMGEinK55phqASljj/jtxsOvtvIsWbxvpjLfsDmgz+P6cZUZ8YqKb0yvcpwJi92sYQtaluv4iCwjziJBvQOV
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB36908F190DAC44BCF5FA9CB1E3F5B2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b458be7-b80e-4f15-f341-08d763d30c5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:37:19.1141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ub5JmbeIG0vH4qeGr4oQO1bVYWZCrx/55N1/tKXjY/kIiFS0DPvBI49Ap+MEcqvkAWAohpXdt4P98gZJoN+4OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1152
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20

[...]

>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> ---
> arch/x86/net/bpf_jit_comp.c | 227 ++++++++++++++++++++++++++++++--
> include/linux/bpf.h         |  98 ++++++++++++++
> include/uapi/linux/bpf.h    |   2 +
> kernel/bpf/Makefile         |   1 +
> kernel/bpf/btf.c            |  77 ++++++++++-
> kernel/bpf/core.c           |   1 +
> kernel/bpf/syscall.c        |  53 +++++++-
> kernel/bpf/trampoline.c     | 252 ++++++++++++++++++++++++++++++++++++
> kernel/bpf/verifier.c       |  39 ++++++
> 9 files changed, 732 insertions(+), 18 deletions(-)
> create mode 100644 kernel/bpf/trampoline.c
>=20
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 8631d3bd637f..44169e8bffc0 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -98,6 +98,7 @@ static int bpf_size_to_x86_bytes(int bpf_size)
>=20
> /* Pick a register outside of BPF range for JIT internal work */
> #define AUX_REG (MAX_BPF_JIT_REG + 1)
> +#define X86_REG_R9 (MAX_BPF_JIT_REG + 2)
>=20
> /*
>  * The following table maps BPF registers to x86-64 registers.
> @@ -123,6 +124,7 @@ static const int reg2hex[] =3D {
> 	[BPF_REG_FP] =3D 5, /* RBP readonly */
> 	[BPF_REG_AX] =3D 2, /* R10 temp register */
> 	[AUX_REG] =3D 3,    /* R11 temp register */
> +	[X86_REG_R9] =3D 1, /* R9 register, 6th function argument */

We should update the comment above this:

 * Also x86-64 register R9 is unused. ...

> };
>=20
> static const int reg2pt_regs[] =3D {
> @@ -150,6 +152,7 @@ static bool is_ereg(u32 reg)
> 			     BIT(BPF_REG_7) |
> 			     BIT(BPF_REG_8) |
> 			     BIT(BPF_REG_9) |
> +			     BIT(X86_REG_R9) |
> 			     BIT(BPF_REG_AX));
> }
>=20
> @@ -492,8 +495,8 @@ static int emit_call(u8 **pprog, void *func, void *ip=
)
> int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> 		       void *old_addr, void *new_addr)
> {
> -	u8 old_insn[NOP_ATOMIC5] =3D {};
> -	u8 new_insn[NOP_ATOMIC5] =3D {};
> +	u8 old_insn[X86_CALL_SIZE] =3D {};
> +	u8 new_insn[X86_CALL_SIZE] =3D {};
> 	u8 *prog;
> 	int ret;
>=20
> @@ -507,9 +510,9 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_t=
ype t,
> 		if (ret)
> 			return ret;
> 	}
> -	if (old_addr) {
> +	if (new_addr) {
> 		prog =3D new_insn;
> -		ret =3D emit_call(&prog, old_addr, (void *)ip);
> +		ret =3D emit_call(&prog, new_addr, (void *)ip);
> 		if (ret)
> 			return ret;
> 	}
> @@ -517,19 +520,19 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke=
_type t,
> 	mutex_lock(&text_mutex);
> 	switch (t) {
> 	case BPF_MOD_NOP_TO_CALL:
> -		if (memcmp(ip, ideal_nops, 5))
> +		if (memcmp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE))
> 			goto out;
> -		text_poke(ip, new_insn, 5);
> +		text_poke(ip, new_insn, X86_CALL_SIZE);
> 		break;
> 	case BPF_MOD_CALL_TO_CALL:
> -		if (memcmp(ip, old_insn, 5))
> +		if (memcmp(ip, old_insn, X86_CALL_SIZE))
> 			goto out;
> -		text_poke(ip, new_insn, 5);
> +		text_poke(ip, new_insn, X86_CALL_SIZE);
> 		break;
> 	case BPF_MOD_CALL_TO_NOP:
> -		if (memcmp(ip, old_insn, 5))
> +		if (memcmp(ip, old_insn, X86_CALL_SIZE))
> 			goto out;
> -		text_poke(ip, ideal_nops, 5);
> +		text_poke(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE);
> 		break;
> 	}
> 	ret =3D 0;
> @@ -1234,6 +1237,210 @@ xadd:			if (is_imm8(insn->off))
> 	return proglen;
> }
>=20
> +static void save_regs(struct btf_func_model *m, u8 **prog, int nr_args,
> +		      int stack_size)
> +{
> +	int i;
> +	/* Store function arguments to stack.
> +	 * For a function that accepts two pointers the sequence will be:
> +	 * mov QWORD PTR [rbp-0x10],rdi
> +	 * mov QWORD PTR [rbp-0x8],rsi
> +	 */
> +	for (i =3D 0; i < min(nr_args, 6); i++)
> +		emit_stx(prog, bytes_to_bpf_size(m->arg_size[i]),
> +			 BPF_REG_FP,
> +			 i =3D=3D 5 ? X86_REG_R9 : BPF_REG_1 + i,
> +			 -(stack_size - i * 8));
> +}
> +
> +static void restore_regs(struct btf_func_model *m, u8 **prog, int nr_arg=
s,
> +			 int stack_size)
> +{
> +	int i;
> +
> +	/* Restore function arguments from stack.
> +	 * For a function that accepts two pointers the sequence will be:
> +	 * EMIT4(0x48, 0x8B, 0x7D, 0xF0); mov rdi,QWORD PTR [rbp-0x10]
> +	 * EMIT4(0x48, 0x8B, 0x75, 0xF8); mov rsi,QWORD PTR [rbp-0x8]
> +	 */
> +	for (i =3D 0; i < min(nr_args, 6); i++)
> +		emit_ldx(prog, bytes_to_bpf_size(m->arg_size[i]),
> +			 i =3D=3D 5 ? X86_REG_R9 : BPF_REG_1 + i,
> +			 BPF_REG_FP,
> +			 -(stack_size - i * 8));
> +}
> +
> +static int invoke_bpf(struct btf_func_model *m, u8 **pprog,
> +		      struct bpf_prog **progs, int prog_cnt, int stack_size)
> +{
> +	u8 *prog =3D *pprog;
> +	int cnt =3D 0, i;
> +
> +	for (i =3D 0; i < prog_cnt; i++) {
> +		if (emit_call(&prog, __bpf_prog_enter, prog))
> +			return -EINVAL;
> +		/* remember prog start time returned by __bpf_prog_enter */
> +		emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
> +
> +		/* arg1: lea rdi, [rbp - stack_size] */
> +		EMIT4(0x48, 0x8D, 0x7D, -stack_size);
> +		/* arg2: progs[i]->insnsi for interpreter */
> +		if (!progs[i]->jited)
> +			emit_mov_imm64(&prog, BPF_REG_2,
> +				       (long) progs[i]->insnsi >> 32,
> +				       (u32) (long) progs[i]->insnsi);
> +		/* call JITed bpf program or interpreter */
> +		if (emit_call(&prog, progs[i]->bpf_func, prog))
> +			return -EINVAL;
> +
> +		/* arg1: mov rdi, progs[i] */
> +		emit_mov_imm64(&prog, BPF_REG_1, (long) progs[i] >> 32,
> +			       (u32) (long) progs[i]);
> +		/* arg2: mov rsi, rbx <- start time in nsec */
> +		emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
> +		if (emit_call(&prog, __bpf_prog_exit, prog))
> +			return -EINVAL;
> +	}
> +	*pprog =3D prog;
> +	return 0;
> +}
> +
> +/* Example:
> + * __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
> + * its 'struct btf_func_model' will be nr_args=3D2
> + * The assembly code when eth_type_trans is executing after trampoline:
> + *
> + * push rbp
> + * mov rbp, rsp
> + * sub rsp, 16                     // space for skb and dev
> + * push rbx                        // temp regs to pass start time
> + * mov qword ptr [rbp - 16], rdi   // save skb pointer to stack
> + * mov qword ptr [rbp - 8], rsi    // save dev pointer to stack
> + * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
> + * mov rbx, rax                    // remember start time in bpf stats a=
re enabled
> + * lea rdi, [rbp - 16]             // R1=3D=3Dctx of bpf prog
> + * call addr_of_jited_FENTRY_prog
> + * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats ar=
e off
> + * mov rsi, rbx                    // prog start time
> + * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable an=
d stats math
> + * mov rdi, qword ptr [rbp - 16]   // restore skb pointer from stack
> + * mov rsi, qword ptr [rbp - 8]    // restore dev pointer from stack
> + * pop rbx
> + * leave
> + * ret
> + *
> + * eth_type_trans has 5 byte nop at the beginning. These 5 bytes will be
> + * replaced with 'call generated_bpf_trampoline'. When it returns
> + * eth_type_trans will continue executing with original skb and dev poin=
ters.
> + *
> + * The assembly code when eth_type_trans is called from trampoline:
> + *
> + * push rbp
> + * mov rbp, rsp
> + * sub rsp, 24                     // space for skb, dev, return value
> + * push rbx                        // temp regs to pass start time
> + * mov qword ptr [rbp - 24], rdi   // save skb pointer to stack
> + * mov qword ptr [rbp - 16], rsi   // save dev pointer to stack
> + * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
> + * mov rbx, rax                    // remember start time if bpf stats a=
re enabled
> + * lea rdi, [rbp - 24]             // R1=3D=3Dctx of bpf prog
> + * call addr_of_jited_FENTRY_prog  // bpf prog can access skb and dev
> + * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats ar=
e off
> + * mov rsi, rbx                    // prog start time
> + * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable an=
d stats math
> + * mov rdi, qword ptr [rbp - 24]   // restore skb pointer from stack
> + * mov rsi, qword ptr [rbp - 16]   // restore dev pointer from stack
> + * call eth_type_trans+5           // execute body of eth_type_trans
> + * mov qword ptr [rbp - 8], rax    // save return value
> + * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
> + * mov rbx, rax                    // remember start time in bpf stats a=
re enabled
> + * lea rdi, [rbp - 24]             // R1=3D=3Dctx of bpf prog
> + * call addr_of_jited_FEXIT_prog   // bpf prog can access skb, dev, retu=
rn value
> + * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats ar=
e off
> + * mov rsi, rbx                    // prog start time
> + * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable an=
d stats math
> + * mov rax, qword ptr [rbp - 8]    // restore eth_type_trans's return va=
lue
> + * pop rbx
> + * leave
> + * add rsp, 8                      // skip eth_type_trans's frame
> + * ret                             // return to its caller
> + */
> +int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u=
32 flags,
> +				struct bpf_prog **fentry_progs, int fentry_cnt,
> +				struct bpf_prog **fexit_progs, int fexit_cnt,
> +				void *orig_call)
> +{
> +	int cnt =3D 0, nr_args =3D m->nr_args;
> +	int stack_size =3D nr_args * 8;
> +	u8 *prog;
> +
> +	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
> +	if (nr_args > 6)
> +		return -ENOTSUPP;
> +
> +	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
> +	    (flags & BPF_TRAMP_F_SKIP_FRAME))
> +		return -EINVAL;
> +
> +	if (flags & BPF_TRAMP_F_CALL_ORIG)
> +		stack_size +=3D 8; /* room for return value of orig_call */
> +
> +	if (flags & BPF_TRAMP_F_SKIP_FRAME)
> +		/* skip patched call instruction and point orig_call to actual
> +		 * body of the kernel function.
> +		 */
> +		orig_call +=3D X86_CALL_SIZE;
> +
> +	prog =3D image;
> +
> +	EMIT1(0x55);		 /* push rbp */
> +	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
> +	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
> +	EMIT1(0x53);		 /* push rbx */
> +
> +	save_regs(m, &prog, nr_args, stack_size);
> +
> +	if (fentry_cnt)
> +		if (invoke_bpf(m, &prog, fentry_progs, fentry_cnt, stack_size))
> +			return -EINVAL;
> +
> +	if (flags & BPF_TRAMP_F_CALL_ORIG) {
> +		if (fentry_cnt)
> +			restore_regs(m, &prog, nr_args, stack_size);
> +
> +		/* call original function */
> +		if (emit_call(&prog, orig_call, prog))
> +			return -EINVAL;
> +		/* remember return value in a stack for bpf prog to access */
> +		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
> +	}
> +
> +	if (fexit_cnt)
> +		if (invoke_bpf(m, &prog, fexit_progs, fexit_cnt, stack_size))
> +			return -EINVAL;
> +
> +	if (flags & BPF_TRAMP_F_RESTORE_REGS)
> +		restore_regs(m, &prog, nr_args, stack_size);
> +
> +	if (flags & BPF_TRAMP_F_CALL_ORIG)
> +		/* restore original return value back into RAX */
> +		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
> +
> +	EMIT1(0x5B); /* pop rbx */
> +	EMIT1(0xC9); /* leave */
> +	if (flags & BPF_TRAMP_F_SKIP_FRAME)
> +		/* skip our return address and return to parent */
> +		EMIT4(0x48, 0x83, 0xC4, 8); /* add rsp, 8 */
> +	EMIT1(0xC3); /* ret */
> +	/* One half of the page has active running trampoline.
> +	 * Another half is an area for next trampoline.
> +	 * Make sure the trampoline generation logic doesn't overflow.
> +	 */
> +	if (WARN_ON_ONCE(prog - (u8 *)image > PAGE_SIZE / 2 - BPF_INSN_SAFETY))
> +		return -EFAULT;

Given max number of args, can we catch this error at compile time?=20

> +	return 0;
> +}
> +
> struct x64_jit_data {
> 	struct bpf_binary_header *header;
> 	int *addrs;
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 8b90db25348a..9206b7e86dde 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -14,6 +14,7 @@
> #include <linux/numa.h>
> #include <linux/wait.h>
> #include <linux/u64_stats_sync.h>
> +#include <linux/refcount.h>
>=20
> struct bpf_verifier_env;
> struct bpf_verifier_log;
> @@ -384,6 +385,94 @@ struct bpf_prog_stats {
> 	struct u64_stats_sync syncp;
> } __aligned(2 * sizeof(u64));
>=20
> +struct btf_func_model {
> +	u8 ret_size;
> +	u8 nr_args;
> +	u8 arg_size[MAX_BPF_FUNC_ARGS];
> +};
> +
> +/* Restore arguments before returning from trampoline to let original fu=
nction
> + * continue executing. This flag is used for fentry progs when there are=
 no
> + * fexit progs.
> + */
> +#define BPF_TRAMP_F_RESTORE_REGS	BIT(0)
> +/* Call original function after fentry progs, but before fexit progs.
> + * Makes sense for fentry/fexit, normal calls and indirect calls.
> + */
> +#define BPF_TRAMP_F_CALL_ORIG		BIT(1)
> +/* Skip current frame and return to parent.  Makes sense for fentry/fexi=
t
> + * programs only. Should not be used with normal calls and indirect call=
s.
> + */
> +#define BPF_TRAMP_F_SKIP_FRAME		BIT(2)
> +
> +/* Different use cases for BPF trampoline:
> + * 1. replace nop at the function entry (kprobe equivalent)
> + *    flags =3D BPF_TRAMP_F_RESTORE_REGS
> + *    fentry =3D a set of programs to run before returning from trampoli=
ne
> + *
> + * 2. replace nop at the function entry (kprobe + kretprobe equivalent)
> + *    flags =3D BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME
> + *    orig_call =3D fentry_ip + MCOUNT_INSN_SIZE
> + *    fentry =3D a set of program to run before calling original functio=
n
> + *    fexit =3D a set of program to run after original function
> + *
> + * 3. replace direct call instruction anywhere in the function body
> + *    or assign a function pointer for indirect call (like tcp_congestio=
n_ops->cong_avoid)
> + *    With flags =3D 0
> + *      fentry =3D a set of programs to run before returning from trampo=
line
> + *    With flags =3D BPF_TRAMP_F_CALL_ORIG
> + *      orig_call =3D original callback addr or direct function addr
> + *      fentry =3D a set of program to run before calling original funct=
ion
> + *      fexit =3D a set of program to run after original function
> + */
> +int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u=
32 flags,
> +				struct bpf_prog **fentry_progs, int fentry_cnt,
> +				struct bpf_prog **fexit_progs, int fexit_cnt,
> +				void *orig_call);
> +/* these two functions are called from generated trampoline */
> +u64 notrace __bpf_prog_enter(void);
> +void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
> +
> +enum bpf_tramp_prog_type {
> +	BPF_TRAMP_FENTRY,
> +	BPF_TRAMP_FEXIT,
> +	BPF_TRAMP_MAX
> +};
> +
> +struct bpf_trampoline {
> +	struct hlist_node hlist;
> +	refcount_t refcnt;
> +	u64 key;
> +	struct {
> +		struct btf_func_model model;
> +		void *addr;
> +	} func;
> +	struct hlist_head progs_hlist[BPF_TRAMP_MAX];
> +	int progs_cnt[BPF_TRAMP_MAX];
> +	void *image;
> +	u64 selector;
> +};
> +#ifdef CONFIG_BPF_JIT
> +struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
> +int bpf_trampoline_link_prog(struct bpf_prog *prog);
> +int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
> +void bpf_trampoline_put(struct bpf_trampoline *tr);
> +#else
> +static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> +{
> +	return NULL;
> +}
> +static inline int bpf_trampoline_link_prog(struct bpf_prog *prog)
> +{
> +	return -ENOTSUPP;
> +}
> +static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
> +{
> +	return -ENOTSUPP;
> +}
> +static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
> +#endif
> +
> struct bpf_prog_aux {
> 	atomic_t refcnt;
> 	u32 used_map_cnt;
> @@ -398,6 +487,9 @@ struct bpf_prog_aux {
> 	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
> 	bool offload_requested;
> 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
> +	enum bpf_tramp_prog_type trampoline_prog_type;
> +	struct bpf_trampoline *trampoline;
> +	struct hlist_node tramp_hlist;
> 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
> 	const struct btf_type *attach_func_proto;
> 	/* function name for valid attach_btf_id */
> @@ -784,6 +876,12 @@ int btf_struct_access(struct bpf_verifier_log *log,
> 		      u32 *next_btf_id);
> u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *, int);
>=20
> +int btf_distill_func_proto(struct bpf_verifier_log *log,
> +			   struct btf *btf,
> +			   const struct btf_type *func_proto,
> +			   const char *func_name,
> +			   struct btf_func_model *m);
> +
> #else /* !CONFIG_BPF_SYSCALL */
> static inline struct bpf_prog *bpf_prog_get(u32 ufd)
> {
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index df6809a76404..69c200e6e696 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -201,6 +201,8 @@ enum bpf_attach_type {
> 	BPF_CGROUP_GETSOCKOPT,
> 	BPF_CGROUP_SETSOCKOPT,
> 	BPF_TRACE_RAW_TP,
> +	BPF_TRACE_FENTRY,
> +	BPF_TRACE_FEXIT,
> 	__MAX_BPF_ATTACH_TYPE
> };
>=20
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index e1d9adb212f9..3f671bf617e8 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -6,6 +6,7 @@ obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode=
.o helpers.o tnum.o
> obj-$(CONFIG_BPF_SYSCALL) +=3D hashtab.o arraymap.o percpu_freelist.o bpf=
_lru_list.o lpm_trie.o map_in_map.o
> obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o
> obj-$(CONFIG_BPF_SYSCALL) +=3D disasm.o
> +obj-$(CONFIG_BPF_JIT) +=3D trampoline.o
> obj-$(CONFIG_BPF_SYSCALL) +=3D btf.o
> ifeq ($(CONFIG_NET),y)
> obj-$(CONFIG_BPF_SYSCALL) +=3D devmap.o
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 128d89601d73..78d9ceaabc00 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3441,13 +3441,18 @@ bool btf_ctx_access(int off, int size, enum bpf_a=
ccess_type type,
> 		args++;
> 		nr_args--;
> 	}
> -	if (arg >=3D nr_args) {
> +
> +	if (prog->expected_attach_type =3D=3D BPF_TRACE_FEXIT &&
> +	    arg =3D=3D nr_args) {
> +		/* function return type */
> +		t =3D btf_type_by_id(btf_vmlinux, t->type);
> +	} else if (arg >=3D nr_args) {
> 		bpf_log(log, "func '%s' doesn't have %d-th argument\n",
> -			tname, arg);
> +			tname, arg + 1);
> 		return false;
> +	} else {
> +		t =3D btf_type_by_id(btf_vmlinux, args[arg].type);
> 	}
> -
> -	t =3D btf_type_by_id(btf_vmlinux, args[arg].type);
> 	/* skip modifiers */
> 	while (btf_type_is_modifier(t))
> 		t =3D btf_type_by_id(btf_vmlinux, t->type);
> @@ -3647,6 +3652,70 @@ u32 btf_resolve_helper_id(struct bpf_verifier_log =
*log, void *fn, int arg)
> 	return btf_id;
> }
>=20
> +static int __get_type_size(struct btf *btf, u32 btf_id,
> +			   const struct btf_type **bad_type)
> +{
> +	const struct btf_type *t;
> +
> +	if (!btf_id)
> +		/* void */
> +		return 0;
> +	t =3D btf_type_by_id(btf, btf_id);
> +	while (t && btf_type_is_modifier(t))
> +		t =3D btf_type_by_id(btf, t->type);
> +	if (!t)
> +		return -EINVAL;
> +	if (btf_type_is_ptr(t))
> +		/* kernel size of pointer. Not BPF's size of pointer*/
> +		return sizeof(void *);
> +	if (btf_type_is_int(t) || btf_type_is_enum(t))
> +		return t->size;
> +	*bad_type =3D t;
> +	return -EINVAL;
> +}
> +
> +int btf_distill_func_proto(struct bpf_verifier_log *log,
> +			   struct btf *btf,
> +			   const struct btf_type *func,
> +			   const char *tname,
> +			   struct btf_func_model *m)
> +{
> +	const struct btf_param *args;
> +	const struct btf_type *t;
> +	u32 i, nargs;
> +	int ret;
> +
> +	args =3D (const struct btf_param *)(func + 1);
> +	nargs =3D btf_type_vlen(func);
> +	if (nargs >=3D MAX_BPF_FUNC_ARGS) {
> +		bpf_log(log,
> +			"The function %s has %d arguments. Too many.\n",
> +			tname, nargs);
> +		return -EINVAL;
> +	}
> +	ret =3D __get_type_size(btf, func->type, &t);
> +	if (ret < 0) {
> +		bpf_log(log,
> +			"The function %s return type %s is unsupported.\n",
> +			tname, btf_kind_str[BTF_INFO_KIND(t->info)]);
> +		return -EINVAL;
> +	}
> +	m->ret_size =3D ret;
> +
> +	for (i =3D 0; i < nargs; i++) {
> +		ret =3D __get_type_size(btf, args[i].type, &t);
> +		if (ret < 0) {
> +			bpf_log(log,
> +				"The function %s arg%d type %s is unsupported.\n",
> +				tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
> +			return -EINVAL;
> +		}
> +		m->arg_size[i] =3D ret;
> +	}
> +	m->nr_args =3D nargs;
> +	return 0;
> +}
> +
> void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
> 		       struct seq_file *m)
> {
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 856564e97943..7352f5514e57 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2011,6 +2011,7 @@ static void bpf_prog_free_deferred(struct work_stru=
ct *work)
> 	if (aux->prog->has_callchain_buf)
> 		put_callchain_buffers();
> #endif
> +	bpf_trampoline_put(aux->trampoline);
> 	for (i =3D 0; i < aux->func_cnt; i++)
> 		bpf_jit_free(aux->func[i]);
> 	if (aux->func_cnt) {
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 6d9ce95e5a8d..e2e37bea86bc 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1799,6 +1799,49 @@ static int bpf_obj_get(const union bpf_attr *attr)
> 				attr->file_flags);
> }
>=20
> +static int bpf_tracing_prog_release(struct inode *inode, struct file *fi=
lp)
> +{
> +	struct bpf_prog *prog =3D filp->private_data;
> +
> +	WARN_ON_ONCE(bpf_trampoline_unlink_prog(prog));
> +	bpf_prog_put(prog);
> +	return 0;
> +}
> +
> +static const struct file_operations bpf_tracing_prog_fops =3D {
> +	.release	=3D bpf_tracing_prog_release,
> +	.read		=3D bpf_dummy_read,
> +	.write		=3D bpf_dummy_write,
> +};
> +
> +static int bpf_tracing_prog_attach(struct bpf_prog *prog)
> +{
> +	int tr_fd, err;
> +
> +	if (prog->expected_attach_type !=3D BPF_TRACE_FENTRY &&
> +	    prog->expected_attach_type !=3D BPF_TRACE_FEXIT) {
> +		err =3D -EINVAL;
> +		goto out_put_prog;
> +	}
> +
> +	err =3D bpf_trampoline_link_prog(prog);
> +	if (err)
> +		goto out_put_prog;
> +
> +	tr_fd =3D anon_inode_getfd("bpf-tracing-prog", &bpf_tracing_prog_fops,
> +				 prog, O_CLOEXEC);
> +	if (tr_fd < 0) {
> +		WARN_ON_ONCE(bpf_trampoline_unlink_prog(prog));
> +		err =3D tr_fd;
> +		goto out_put_prog;
> +	}
> +	return tr_fd;
> +
> +out_put_prog:
> +	bpf_prog_put(prog);
> +	return err;
> +}
> +
> struct bpf_raw_tracepoint {
> 	struct bpf_raw_event_map *btp;
> 	struct bpf_prog *prog;
> @@ -1850,14 +1893,16 @@ static int bpf_raw_tracepoint_open(const union bp=
f_attr *attr)
>=20
> 	if (prog->type =3D=3D BPF_PROG_TYPE_TRACING) {
> 		if (attr->raw_tracepoint.name) {
> -			/* raw_tp name should not be specified in raw_tp
> -			 * programs that were verified via in-kernel BTF info
> +			/* The attach point for this category of programs
> +			 * should be specified via btf_id during program load.
> 			 */
> 			err =3D -EINVAL;
> 			goto out_put_prog;
> 		}
> -		/* raw_tp name is taken from type name instead */
> -		tp_name =3D prog->aux->attach_func_name;
> +		if (prog->expected_attach_type =3D=3D BPF_TRACE_RAW_TP)
> +			tp_name =3D prog->aux->attach_func_name;
> +		else
> +			return bpf_tracing_prog_attach(prog);
> 	} else {
> 		if (strncpy_from_user(buf,
> 				      u64_to_user_ptr(attr->raw_tracepoint.name),
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> new file mode 100644
> index 000000000000..214c964cfd72
> --- /dev/null
> +++ b/kernel/bpf/trampoline.c
> @@ -0,0 +1,252 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2019 Facebook */
> +#include <linux/hash.h>
> +#include <linux/bpf.h>
> +#include <linux/filter.h>
> +
> +/* btf_vmlinux has ~22k attachable functions. 1k htab is enough. */
> +#define TRAMPOLINE_HASH_BITS 10
> +#define TRAMPOLINE_TABLE_SIZE (1 << TRAMPOLINE_HASH_BITS)
> +
> +static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
> +
> +static DEFINE_MUTEX(trampoline_mutex);
> +
> +struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> +{
> +	struct bpf_trampoline *tr;
> +	struct hlist_head *head;
> +	void *image;
> +	int i;
> +
> +	mutex_lock(&trampoline_mutex);
> +	head =3D &trampoline_table[hash_64(key, TRAMPOLINE_HASH_BITS)];
> +	hlist_for_each_entry(tr, head, hlist) {
> +		if (tr->key =3D=3D key) {
> +			refcount_inc(&tr->refcnt);
> +			goto out;
> +		}
> +	}
> +	tr =3D kzalloc(sizeof(*tr), GFP_KERNEL);
> +	if (!tr)
> +		goto out;
> +
> +	/* is_root was checked earlier. No need for bpf_jit_charge_modmem() */
> +	image =3D bpf_jit_alloc_exec(PAGE_SIZE);
> +	if (!image) {
> +		kfree(tr);
> +		tr =3D NULL;
> +		goto out;
> +	}
> +
> +	tr->key =3D key;
> +	INIT_HLIST_NODE(&tr->hlist);
> +	hlist_add_head(&tr->hlist, head);
> +	refcount_set(&tr->refcnt, 1);
> +	for (i =3D 0; i < BPF_TRAMP_MAX; i++)
> +		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
> +
> +	set_vm_flush_reset_perms(image);
> +	/* Keep image as writeable. The alternative is to keep flipping ro/rw
> +	 * everytime new program is attached or detached.
> +	 */
> +	set_memory_x((long)image, 1);
> +	tr->image =3D image;
> +out:
> +	mutex_unlock(&trampoline_mutex);
> +	return tr;
> +}
> +
> +/* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is =
~50
> + * bytes on x86.  Pick a number to fit into PAGE_SIZE / 2
> + */
> +#define BPF_MAX_TRAMP_PROGS 40
> +
> +static int bpf_trampoline_update(struct bpf_prog *prog)

Seems argument "prog" is not used at all?=20

> +{
> +	struct bpf_trampoline *tr =3D prog->aux->trampoline;
> +	void *old_image =3D tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/2;
> +	void *new_image =3D tr->image + (tr->selector & 1) * PAGE_SIZE/2;
> +	struct bpf_prog *progs_to_run[BPF_MAX_TRAMP_PROGS];
> +	int fentry_cnt =3D tr->progs_cnt[BPF_TRAMP_FENTRY];
> +	int fexit_cnt =3D tr->progs_cnt[BPF_TRAMP_FEXIT];
> +	struct bpf_prog **progs, **fentry, **fexit;
> +	u32 flags =3D BPF_TRAMP_F_RESTORE_REGS;
> +	struct bpf_prog_aux *aux;
> +	int err;
> +
> +	if (fentry_cnt + fexit_cnt =3D=3D 0) {
> +		err =3D bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL_TO_NOP,
> +					 old_image, NULL);
> +		tr->selector =3D 0;
> +		goto out;
> +	}
> +
> +	/* populate fentry progs */
> +	fentry =3D progs =3D progs_to_run;
> +	hlist_for_each_entry(aux, &tr->progs_hlist[BPF_TRAMP_FENTRY], tramp_hli=
st)
> +		*progs++ =3D aux->prog;
> +
> +	/* populate fexit progs */
> +	fexit =3D progs;
> +	hlist_for_each_entry(aux, &tr->progs_hlist[BPF_TRAMP_FEXIT], tramp_hlis=
t)
> +		*progs++ =3D aux->prog;
> +
> +	if (fexit_cnt)
> +		flags =3D BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
> +
> +	err =3D arch_prepare_bpf_trampoline(new_image, &tr->func.model, flags,
> +					  fentry, fentry_cnt,
> +					  fexit, fexit_cnt,
> +					  tr->func.addr);
> +	if (err)
> +		goto out;
> +
> +	if (tr->selector)
> +		/* progs already running at this address */
> +		err =3D bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL_TO_CALL,
> +					 old_image, new_image);
> +	else
> +		/* first time registering */
> +		err =3D bpf_arch_text_poke(tr->func.addr, BPF_MOD_NOP_TO_CALL,
> +					 NULL, new_image);
> +
> +	if (err)
> +		goto out;
> +	tr->selector++;

Shall we do selector-- for unlink?

> +out:
> +	return err;
> +}
> +
> +static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach=
_type t)
> +{
> +	switch (t) {
> +	case BPF_TRACE_FENTRY:
> +		return BPF_TRAMP_FENTRY;
> +	default:
> +		return BPF_TRAMP_FEXIT;
> +	}
> +}
> +
> +int bpf_trampoline_link_prog(struct bpf_prog *prog)
> +{
> +	enum bpf_tramp_prog_type kind;
> +	struct bpf_trampoline *tr;
> +	int err =3D 0;
> +
> +	tr =3D prog->aux->trampoline;
> +	kind =3D bpf_attach_type_to_tramp(prog->expected_attach_type);
> +	mutex_lock(&trampoline_mutex);
> +	if (tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT]
> +	    >=3D BPF_MAX_TRAMP_PROGS) {
> +		err =3D -E2BIG;
> +		goto out;
> +	}
> +	if (!hlist_unhashed(&prog->aux->tramp_hlist)) {
> +		/* prog already linked */
> +		err =3D -EBUSY;
> +		goto out;
> +	}
> +	hlist_add_head(&prog->aux->tramp_hlist, &tr->progs_hlist[kind]);
> +	tr->progs_cnt[kind]++;
> +	err =3D bpf_trampoline_update(prog);
> +	if (err) {
> +		hlist_del(&prog->aux->tramp_hlist);
> +		tr->progs_cnt[kind]--;
> +	}
> +out:
> +	mutex_unlock(&trampoline_mutex);
> +	return err;
> +}
> +
> +/* bpf_trampoline_unlink_prog() should never fail. */
> +int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
> +{
> +	enum bpf_tramp_prog_type kind;
> +	struct bpf_trampoline *tr;
> +	int err;
> +
> +	tr =3D prog->aux->trampoline;
> +	kind =3D bpf_attach_type_to_tramp(prog->expected_attach_type);
> +	mutex_lock(&trampoline_mutex);
> +	hlist_del(&prog->aux->tramp_hlist);
> +	tr->progs_cnt[kind]--;
> +	err =3D bpf_trampoline_update(prog);
> +	mutex_unlock(&trampoline_mutex);
> +	return err;
> +}
> +
> +void bpf_trampoline_put(struct bpf_trampoline *tr)
> +{
> +	if (!tr)
> +		return;
> +	mutex_lock(&trampoline_mutex);
> +	if (!refcount_dec_and_test(&tr->refcnt))
> +		goto out;
> +	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FENTRY])))
> +		goto out;
> +	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
> +		goto out;
> +	bpf_jit_free_exec(tr->image);
> +	hlist_del(&tr->hlist);
> +	kfree(tr);
> +out:
> +	mutex_unlock(&trampoline_mutex);
> +}
> +
> +/* The logic is similar to BPF_PROG_RUN, but with explicit rcu and preem=
pt that
> + * are needed for trampoline. The macro is split into
> + * call _bpf_prog_enter
> + * call prog->bpf_func
> + * call __bpf_prog_exit
> + */
> +u64 notrace __bpf_prog_enter(void)
> +{
> +	u64 start =3D 0;
> +
> +	rcu_read_lock();
> +	preempt_disable();
> +	if (static_branch_unlikely(&bpf_stats_enabled_key))
> +		start =3D sched_clock();
> +	return start;
> +}
> +
> +void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
> +{
> +	struct bpf_prog_stats *stats;
> +
> +	if (static_branch_unlikely(&bpf_stats_enabled_key) &&
> +	    /* static_key could be enabled in __bpf_prog_enter
> +	     * and disabled in __bpf_prog_exit.
> +	     * And vice versa.
> +	     * Hence check that 'start' is not zero.
> +	     */
> +	    start) {
> +		stats =3D this_cpu_ptr(prog->aux->stats);
> +		u64_stats_update_begin(&stats->syncp);
> +		stats->cnt++;
> +		stats->nsecs +=3D sched_clock() - start;
> +		u64_stats_update_end(&stats->syncp);
> +	}
> +	preempt_enable();
> +	rcu_read_unlock();
> +}
> +
> +int __weak
> +arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 f=
lags,
> +			    struct bpf_prog **fentry_progs, int fentry_cnt,
> +			    struct bpf_prog **fexit_progs, int fexit_cnt,
> +			    void *orig_call)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int __init init_trampolines(void)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < TRAMPOLINE_TABLE_SIZE; i++)
> +		INIT_HLIST_HEAD(&trampoline_table[i]);
> +	return 0;
> +}
> +late_initcall(init_trampolines);
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 2f2374967b36..36542edd4936 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9382,8 +9382,11 @@ static int check_attach_btf_id(struct bpf_verifier=
_env *env)
> 	struct bpf_prog *prog =3D env->prog;
> 	u32 btf_id =3D prog->aux->attach_btf_id;
> 	const char prefix[] =3D "btf_trace_";
> +	struct bpf_trampoline *tr;
> 	const struct btf_type *t;
> 	const char *tname;
> +	long addr;
> +	int ret;
>=20
> 	if (prog->type !=3D BPF_PROG_TYPE_TRACING)
> 		return 0;
> @@ -9432,6 +9435,42 @@ static int check_attach_btf_id(struct bpf_verifier=
_env *env)
> 		prog->aux->attach_func_proto =3D t;
> 		prog->aux->attach_btf_trace =3D true;
> 		return 0;
> +	case BPF_TRACE_FENTRY:
> +	case BPF_TRACE_FEXIT:
> +		if (!btf_type_is_func(t)) {
> +			verbose(env, "attach_btf_id %u is not a function\n",
> +				btf_id);
> +			return -EINVAL;
> +		}
> +		t =3D btf_type_by_id(btf_vmlinux, t->type);
> +		if (!btf_type_is_func_proto(t))
> +			return -EINVAL;
> +		tr =3D bpf_trampoline_lookup(btf_id);
> +		if (!tr)
> +			return -ENOMEM;
> +		prog->aux->attach_func_name =3D tname;
> +		prog->aux->attach_func_proto =3D t;
> +		if (tr->func.addr) {
> +			prog->aux->trampoline =3D tr;
> +			return 0;
> +		}
> +		ret =3D btf_distill_func_proto(&env->log, btf_vmlinux, t,
> +					     tname, &tr->func.model);
> +		if (ret < 0) {
> +			bpf_trampoline_put(tr);
> +			return ret;
> +		}
> +		addr =3D kallsyms_lookup_name(tname);
> +		if (!addr) {
> +			verbose(env,
> +				"The address of function %s cannot be found\n",
> +				tname);
> +			bpf_trampoline_put(tr);
> +			return -ENOENT;
> +		}
> +		tr->func.addr =3D (void *)addr;
> +		prog->aux->trampoline =3D tr;
> +		return 0;
> 	default:
> 		return -EINVAL;
> 	}
> --=20
> 2.23.0
>=20

