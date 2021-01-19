Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE94E2FB8D6
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405959AbhASNtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:49:03 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:48667 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390580AbhASKa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 05:30:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611052140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Et/09oALV20Ju9+eB7wAnivLNxilXefAZQNBnrd3cRE=;
        b=Vmq2DkKWW9QUd3KO+gfghjU8ob6+Q7/gOhRAfG3Eviun3+WesRCNGKUaN2pB9mQ4F0U6kD
        BgXHWEy5T4QJNoc6fV5fLfniZq2oAaz4E/r0xGhFDWwnFDk/9YEua8MsgJ068jqmXG0vX/
        KqyYLBnU2oAOFEDu0URp5eMmooxzvjw=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-1dnMtNziN8a0XMrZGANP5A-1; Tue, 19 Jan 2021 11:25:28 +0100
X-MC-Unique: 1dnMtNziN8a0XMrZGANP5A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB3ejDiKbRyb5Tl1bF16AL09LRVTzhCwZ579C37CnCY888Yfo7T3CcJM821IG9Yp/tOEjL4bkTgLGU+Y44B3V2GNDJcwPFiu3+cI3AFPPZget9Up0Aq8/y7vCjN7nxOIuexhW/8p6t38dioAEDO00hY9gzWVFcxjY59/SBMv60uGFTIYgHHK+i9wsYddF+O0vWfiLPrQkptt1gbJF+y6nlYfSu1Y0W4+3YfCe+kdky/nEia/znw6CLsRZVCDwr1IZF+tOEsWgmYbEXh5rBfvnkUfiqZpzDXcv3lFXM/1bB3DvDN94iFMRQ1b8mGDSsSmwMWZg0svHswLqHQMl3VVrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRAWZJ+gwEt/3tPZe71MZ696YnggxgqO6cFB3mjroUg=;
 b=ITcOxNzNTtV1aHaNzhWpoOjHYJ7hM6jqU/cOoh4cbiKW9Tu7JhXjtLNCKbv0zTsIgpewANDo97zlm9lcm8I+/IxuMFSIlZ8Qoj6gU3G72FeNnbCSFm6WHssQknafVny7ET7Wi6wmkanfx5CjYykNn/UVKKyLOrHx25db8c5hVaUQl7534CiQr4UjlolGVkobuaOJVLj5hWhQcGatHnODB+b1nqH7spEzOv4tgVekGgIvbX8mkVbUCfx3gLpkk/XKweHIZeMvk5zqf2V5v0LbVdI0JL/EPuUJZYwkTMnjupdAaUfaPng94iKttB9Qa4V0y8IhHGuA1UucLeJyplSdVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB6PR04MB3109.eurprd04.prod.outlook.com (2603:10a6:6:f::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.14; Tue, 19 Jan 2021 10:25:27 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 10:25:27 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v4 1/3] bpf,x64: pad NOPs to make images converge more easily
Date:   Tue, 19 Jan 2021 18:24:59 +0800
Message-ID: <20210119102501.511-2-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119102501.511-1-glin@suse.com>
References: <20210119102501.511-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.113.126]
X-ClientProxiedBy: FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::10) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.113.126) by FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Tue, 19 Jan 2021 10:25:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97faf096-f4bc-44ca-6ba1-08d8bc648a01
X-MS-TrafficTypeDiagnostic: DB6PR04MB3109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB31097C34020C3F246927B1F9A9A30@DB6PR04MB3109.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cThOngYad6TmqawTMXI8jENnVIIKy3WKF/OTAoeD0cLA3z8OgikBZ0RV2VdN6QJtUZrkjNHqdBDgTXyO+6QJaPIZ8NdC5d0VcCp9LkANKsKyNd04z56KWHJ/dN0A9V8m1DEO9IqJgUdCbQwcKJZolC1qx+7KZpF/X76Y9H5+s4CEsZmx20rccrqRFPMxRfUkbHY33mKBpSrLumZVFrQomO4U42G0SIHqH3/J7gkvBZX6srWXOI80gbvBhS5DjyjyyTOqsHnrHH4OFoOth3BjB34GuqacfmPCqzNF5Y7s3+H6y9aZTtNDn8SFmJropjuNfl0y71WHcwep8+a3WseAMfTBqf1uWo3uP5pRNcyhJGTY+qlakBDqVykvsoA9BleN1UtIJKT77Vv/lQsfK6XccQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(83380400001)(1076003)(186003)(26005)(6486002)(52116002)(316002)(956004)(16526019)(6512007)(6506007)(4326008)(107886003)(8676002)(5660300002)(36756003)(66556008)(2906002)(8936002)(66946007)(66476007)(86362001)(2616005)(478600001)(110136005)(6666004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sAi/WGraxw9yFAiNDj1TywOzQ46KucwjOM4dkXOoKi1bdH2fT/AgPwE7iP5z?=
 =?us-ascii?Q?uIIwQ1IWcvMJQ+0EG4IKAcX2dHaUpqrKynb7NmF8YuMJqWJ1K8uiyzp7Pc9J?=
 =?us-ascii?Q?ymkoGa5BDKGolGxzh+DkLFKnQwvyVE9Dk81SU1OfS/pE1xZkk5pSKQnISL8c?=
 =?us-ascii?Q?X1KaL87C5X0X2p+dVCkwXGXAK9FDu0GaYk7aIINp1yErcebd8X6uTjuJZYt/?=
 =?us-ascii?Q?MbDa2IT9YR6MNEdlF8tQQzUP7+d13XI7AiZBc2RM89RCAXFapar4oBVKLTIO?=
 =?us-ascii?Q?OoSfxEVz2/zIS74TXbXHas812ITjQYZisu+mF64Q15l3UM5SB9+UguJyobLD?=
 =?us-ascii?Q?JW1ywCRxjKCbEvw2sxNKZa8bYqvptD9mBBSaEGOdbkS2G5KHnkoL2NVYDJnf?=
 =?us-ascii?Q?HAEmxIfVOV9UDYiDCKjBfdf3VRE7mWG15PWW5Sn3J68ywvWetsxxl7+2DpND?=
 =?us-ascii?Q?eAUNeHRQOO2CgZicnwt3J8bUN39r3EWqA8qDViVIMlgO0dPHZ0HEDn29P8z6?=
 =?us-ascii?Q?0JauKDRrO4nHqsJ20lssiOMQidxB7vU2mUkaCMTVi30APX7jSLDlv5NwVdX4?=
 =?us-ascii?Q?ANp0E06SFIAu0SZTQUqc1Mqki+Zchx3mof7q5VbRFBoKgLcFKmXt7UQ/lnbJ?=
 =?us-ascii?Q?rlOM5xVhjI35YrCDtQfbWyWiozbQoT61V/8CmYwB7Qkxe+G9eq2qKhtBVG0s?=
 =?us-ascii?Q?el2T4DoGyER5shsMovRDk8ExZFKhojjpqPBJqEtwrgTUaNKKpwdz/WIs/u19?=
 =?us-ascii?Q?Oy6Zzq/ZScn30emYJy0imcT/ZErc3bCoF7LP5AJ1mFOv0KosrU+fCS01DKzc?=
 =?us-ascii?Q?zHn69O7g2btI032YpWV4iKSA16J/+6lrWS+iBHuea8d8Jj9XDVXNjTvkuklZ?=
 =?us-ascii?Q?lNH/108UJBSMsPlISAxMGx1D4b7r0b6+D+wzgmvCaVl0BgxCXw0/GdNY7q7u?=
 =?us-ascii?Q?yTXcBBkCVRg7I9ZNl97q54X41W2oSCsabTxe/7n/oM+gK/mzBzT/OhEHTJA2?=
 =?us-ascii?Q?fAzL?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97faf096-f4bc-44ca-6ba1-08d8bc648a01
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 10:25:27.5922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H0FIcvVpp/pI3qTQ8SmSrT4skidtsCjn8sr9mncm/x3mLEBowbE95503CQBffpUQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The x64 bpf jit expects bpf images converge within the given passes, but
it could fail to do so with some corner cases. For example:

      l0:     ja 40
      l1:     ja 40

        [... repeated ja 40 ]

      l39:    ja 40
      l40:    ret #0

This bpf program contains 40 "ja 40" instructions which are effectively
NOPs and designed to be replaced with valid code dynamically. Ideally,
bpf jit should optimize those "ja 40" instructions out when translating
the bpf instructions into x64 machine code. However, do_jit() can only
remove one "ja 40" for offset=3D=3D0 on each pass, so it requires at least
40 runs to eliminate those JMPs and exceeds the current limit of
passes(20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
is set even though it's legit as a classic socket filter.

To make bpf images more likely converge within 20 passes, this commit
pads some instructions with NOPs in the last 5 passes:

1. conditional jumps
  A possible size variance comes from the adoption of imm8 JMP. If the
  offset is imm8, we calculate the size difference of this BPF instruction
  between the previous and the current pass and fill the gap with NOPs.
  To avoid the recalculation of jump offset, those NOPs are inserted before
  the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
  calculating the NOP number.

2. BPF_JA
  There are two conditions for BPF_JA.
  a.) nop jumps
    If this instruction is not optimized out in the previous pass,
    instead of removing it, we insert the equivalent size of NOPs.
  b.) label jumps
    Similar to condition jumps, we prepend NOPs right before the JMP
    code.

To make the code concise, emit_nops() is modified to use the signed len and
return the number of inserted NOPs.

For bpf-to-bpf, we always enable padding for the extra pass since there
is only one extra run and the jump padding doesn't affected the images
that converge without padding.

After applying this patch, the corner case was loaded with the following
jit code:

    flen=3D45 proglen=3D77 pass=3D17 image=3Dffffffffc03367d4 from=3Djump p=
id=3D10097
    JIT code: 00000000: 0f 1f 44 00 00 55 48 89 e5 53 41 55 31 c0 45 31
    JIT code: 00000010: ed 48 89 fb eb 30 eb 2e eb 2c eb 2a eb 28 eb 26
    JIT code: 00000020: eb 24 eb 22 eb 20 eb 1e eb 1c eb 1a eb 18 eb 16
    JIT code: 00000030: eb 14 eb 12 eb 10 eb 0e eb 0c eb 0a eb 08 eb 06
    JIT code: 00000040: eb 04 eb 02 66 90 31 c0 41 5d 5b c9 c3

     0: 0f 1f 44 00 00          nop    DWORD PTR [rax+rax*1+0x0]
     5: 55                      push   rbp
     6: 48 89 e5                mov    rbp,rsp
     9: 53                      push   rbx
     a: 41 55                   push   r13
     c: 31 c0                   xor    eax,eax
     e: 45 31 ed                xor    r13d,r13d
    11: 48 89 fb                mov    rbx,rdi
    14: eb 30                   jmp    0x46
    16: eb 2e                   jmp    0x46
        ...
    3e: eb 06                   jmp    0x46
    40: eb 04                   jmp    0x46
    42: eb 02                   jmp    0x46
    44: 66 90                   xchg   ax,ax
    46: 31 c0                   xor    eax,eax
    48: 41 5d                   pop    r13
    4a: 5b                      pop    rbx
    4b: c9                      leave
    4c: c3                      ret

At the 16th pass, 15 jumps were already optimized out, and one jump was
replaced with NOPs at 44 and the image converged at the 17th pass.

v4:
  - Add the detailed comments about the possible padding bytes

v3:
  - Copy the instructions of prologue separately or the size calculation
    of the first BPF instruction would include the prologue.
  - Replace WARN_ONCE() with pr_err() and EFAULT
  - Use MAX_PASSES in the for loop condition check
  - Remove the "padded" flag from x64_jit_data. For the extra pass of
    subprogs, padding is always enabled since it won't hurt the images
    that converge without padding.

v2:
  - Simplify the sample code in the description and provide the jit code
  - Check the expected padding bytes with WARN_ONCE
  - Move the 'padded' flag to 'struct x64_jit_data'

Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/net/bpf_jit_comp.c | 140 ++++++++++++++++++++++++++++--------
 1 file changed, 112 insertions(+), 28 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 1d4d50199293..b7a2911bda77 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -869,8 +869,31 @@ static void detect_reg_usage(struct bpf_insn *insn, in=
t insn_cnt,
 	}
 }
=20
+static int emit_nops(u8 **pprog, int len)
+{
+	u8 *prog =3D *pprog;
+	int i, noplen, cnt =3D 0;
+
+	while (len > 0) {
+		noplen =3D len;
+
+		if (noplen > ASM_NOP_MAX)
+			noplen =3D ASM_NOP_MAX;
+
+		for (i =3D 0; i < noplen; i++)
+			EMIT1(ideal_nops[noplen][i]);
+		len -=3D noplen;
+	}
+
+	*pprog =3D prog;
+
+	return cnt;
+}
+
+#define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
+
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
-		  int oldproglen, struct jit_context *ctx)
+		  int oldproglen, struct jit_context *ctx, bool jmp_padding)
 {
 	bool tail_call_reachable =3D bpf_prog->aux->tail_call_reachable;
 	struct bpf_insn *insn =3D bpf_prog->insnsi;
@@ -880,7 +903,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs=
, u8 *image,
 	bool seen_exit =3D false;
 	u8 temp[BPF_MAX_INSN_SIZE + BPF_INSN_SAFETY];
 	int i, cnt =3D 0, excnt =3D 0;
-	int proglen =3D 0;
+	int ilen, proglen =3D 0;
 	u8 *prog =3D temp;
 	int err;
=20
@@ -894,7 +917,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addr=
s, u8 *image,
 		      bpf_prog_was_classic(bpf_prog), tail_call_reachable,
 		      bpf_prog->aux->func_idx !=3D 0);
 	push_callee_regs(&prog, callee_regs_used);
-	addrs[0] =3D prog - temp;
+
+	ilen =3D prog - temp;
+	if (image)
+		memcpy(image + proglen, temp, ilen);
+	proglen +=3D ilen;
+	addrs[0] =3D proglen;
+	prog =3D temp;
=20
 	for (i =3D 1; i <=3D insn_cnt; i++, insn++) {
 		const s32 imm32 =3D insn->imm;
@@ -903,8 +932,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs=
, u8 *image,
 		u8 b2 =3D 0, b3 =3D 0;
 		s64 jmp_offset;
 		u8 jmp_cond;
-		int ilen;
 		u8 *func;
+		int nops;
=20
 		switch (insn->code) {
 			/* ALU */
@@ -1502,6 +1531,30 @@ st:			if (is_imm8(insn->off))
 			}
 			jmp_offset =3D addrs[i + insn->off] - addrs[i];
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding) {
+					/* To keep the jmp_offset valid, the extra bytes are
+					 * padded before the jump insn, so we substract the
+					 * 2 bytes of jmp_cond insn from INSN_SZ_DIFF.
+					 *
+					 * If the previous pass already emits an imm8
+					 * jmp_cond, then this BPF insn won't shrink, so
+					 * "nops" is 0.
+					 *
+					 * On the other hand, if the previous pass emits an
+					 * imm32 jmp_cond, the extra 4 bytes(*) is padded to
+					 * keep the image from shrinking further.
+					 *
+					 * (*) imm32 jmp_cond is 6 bytes, and imm8 jmp_cond
+					 *     is 2 bytes, so the size difference is 4 bytes.
+					 */
+					nops =3D INSN_SZ_DIFF - 2;
+					if (nops !=3D 0 && nops !=3D 4) {
+						pr_err("unexpected jmp_cond padding: %d bytes\n",
+						       nops);
+						return -EFAULT;
+					}
+					cnt +=3D emit_nops(&prog, nops);
+				}
 				EMIT2(jmp_cond, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
@@ -1524,11 +1577,55 @@ st:			if (is_imm8(insn->off))
 			else
 				jmp_offset =3D addrs[i + insn->off] - addrs[i];
=20
-			if (!jmp_offset)
-				/* Optimize out nop jumps */
+			if (!jmp_offset) {
+				/*
+				 * If jmp_padding is enabled, the extra nops will
+				 * be inserted. Otherwise, optimize out nop jumps.
+				 */
+				if (jmp_padding) {
+					/* There are 3 possible conditions.
+					 * (1) This BPF_JA is already optimized out in
+					 *     the previous run, so there is no need
+					 *     to pad any extra byte (0 byte).
+					 * (2) The previous pass emits an imm8 jmp,
+					 *     so we pad 2 bytes to match the previous
+					 *     insn size.
+					 * (3) Similarly, the previous pass emits an
+					 *     imm32 jmp, and 5 bytes is padded.
+					 */
+					nops =3D INSN_SZ_DIFF;
+					if (nops !=3D 0 && nops !=3D 2 && nops !=3D 5) {
+						pr_err("unexpected nop jump padding: %d bytes\n",
+						       nops);
+						return -EFAULT;
+					}
+					cnt +=3D emit_nops(&prog, nops);
+				}
 				break;
+			}
 emit_jmp:
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding) {
+					/* To avoid breaking jmp_offset, the extra bytes
+					 * are padded before the actual jmp insn, so
+					 * 2 bytes is substracted from INSN_SZ_DIFF.
+					 *
+					 * If the previous pass already emits an imm8
+					 * jmp, there is nothing to pad (0 byte).
+					 *
+					 * If it emits an imm32 jmp (5 bytes) previously
+					 * and now an imm8 jmp (2 bytes), then we pad
+					 * (5 - 2 =3D 3) bytes to stop the image from
+					 * shrinking further.
+					 */
+					nops =3D INSN_SZ_DIFF - 2;
+					if (nops !=3D 0 && nops !=3D 3) {
+						pr_err("unexpected jump padding: %d bytes\n",
+						       nops);
+						return -EFAULT;
+					}
+					cnt +=3D emit_nops(&prog, INSN_SZ_DIFF - 2);
+				}
 				EMIT2(0xEB, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT1_off32(0xE9, jmp_offset);
@@ -1671,26 +1768,6 @@ static int invoke_bpf_prog(const struct btf_func_mod=
el *m, u8 **pprog,
 	return 0;
 }
=20
-static void emit_nops(u8 **pprog, unsigned int len)
-{
-	unsigned int i, noplen;
-	u8 *prog =3D *pprog;
-	int cnt =3D 0;
-
-	while (len > 0) {
-		noplen =3D len;
-
-		if (noplen > ASM_NOP_MAX)
-			noplen =3D ASM_NOP_MAX;
-
-		for (i =3D 0; i < noplen; i++)
-			EMIT1(ideal_nops[noplen][i]);
-		len -=3D noplen;
-	}
-
-	*pprog =3D prog;
-}
-
 static void emit_align(u8 **pprog, u32 align)
 {
 	u8 *target, *prog =3D *pprog;
@@ -2065,6 +2142,9 @@ struct x64_jit_data {
 	struct jit_context ctx;
 };
=20
+#define MAX_PASSES 20
+#define PADDING_PASSES (MAX_PASSES - 5)
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header =3D NULL;
@@ -2074,6 +2154,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	struct jit_context ctx =3D {};
 	bool tmp_blinded =3D false;
 	bool extra_pass =3D false;
+	bool padding =3D false;
 	u8 *image =3D NULL;
 	int *addrs;
 	int pass;
@@ -2110,6 +2191,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 		image =3D jit_data->image;
 		header =3D jit_data->header;
 		extra_pass =3D true;
+		padding =3D true;
 		goto skip_init_addrs;
 	}
 	addrs =3D kmalloc_array(prog->len + 1, sizeof(*addrs), GFP_KERNEL);
@@ -2135,8 +2217,10 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog=
 *prog)
 	 * may converge on the last pass. In such case do one more
 	 * pass to emit the final image.
 	 */
-	for (pass =3D 0; pass < 20 || image; pass++) {
-		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx);
+	for (pass =3D 0; pass < MAX_PASSES || image; pass++) {
+		if (!padding && pass >=3D PADDING_PASSES)
+			padding =3D true;
+		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx, padding);
 		if (proglen <=3D 0) {
 out_image:
 			image =3D NULL;
--=20
2.29.2

