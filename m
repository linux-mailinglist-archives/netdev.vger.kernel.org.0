Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E80C2EC804
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 03:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbhAGCSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 21:18:37 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:51888 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbhAGCSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 21:18:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1609985847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvaFd6Z+80ZtUFursgBKsjyF4xxA0kZkZVxgCS0kX7M=;
        b=FSUxhzQLdhILOZw2pAFeAOOdfF83L6HkaqZo8jhmlk07g/bXMk4e1n8toBxOTyRiDeOZwI
        0CBUTa+WcENgRBZC7Jd0rZQKr3SCbUwJcGH7F3BeOc7Wmv8FVdJdAfiYNp8hgQRVjpZJyH
        j1X3QoYM44938fp3xiRBwIzT0+FDImo=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-w1OwT_ReM4GxfcL5JhhmNg-1; Thu, 07 Jan 2021 03:17:25 +0100
X-MC-Unique: w1OwT_ReM4GxfcL5JhhmNg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rbp0frNmudQDULXyGbLUGPNWQcCPXd7VeDHPq3UOeGJMDaojMhP70pdDiNLImtaiDVMGbzZLUY2a3gJPoIjDPvANmp7c8AYproI3dFqYQUNgz6pIfNSyixyRYUM4GPkDGuz2+BjhLXj2PiYbLSNYsKBBj1nfTGbssOBvqpIi+D87JhZvIg/dBjlJRzoPfOd5RDvsk7d9/QQCgcqTeErnipelH8AKBPY514s4YPw+u/CmnbTst49f2ZM8ODijLqLG7l8dFWX9v5vhfynYAO7LdUVgdU+RgvDvsKt+9h/JwvnDf7gH+o80VABA3VSp/vPc0E4iDZ7uqG+l1Lg+sAVmgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yETduEdU0SRv4WXZ967bogU3r/b/oqU+4NpCx+Y/oPg=;
 b=lNs9e+A3DdIRDDjrMXT5AUrCfQeCvtkIFtph9+kkvvUbwd+RR9rZEL/vgtTX4IJAwiI9JzBH7DySMyulGPQOfetDb316mhxUKWhuc+PY32vjqBN9pW6NFGZCYlRnrkOMeYg5fGvdX7Jnlee3ETPFZQu3kDJWl5yJ1xcwmLBWDHXaJKInt2OmoWwxm9VN22jBVKKp4tkEFnVpN6Z+Mr15Uq6iDkJAhrmBJD9YmTHHnP3niEe4EpJOBuSV+km34pNVoiszpGt5VashnZTN42svRJo0ndxlgx286iZY7m/dJHctKWX+Qfn5QoA4d2gLqhKbGVkbUiqA0BG4RaeraKhB8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB7PR04MB5226.eurprd04.prod.outlook.com (2603:10a6:10:21::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Thu, 7 Jan
 2021 02:17:24 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 02:17:24 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH RESEND v2 1/3] bpf,x64: pad NOPs to make images converge more easily
Date:   Thu,  7 Jan 2021 10:16:59 +0800
Message-ID: <20210107021701.1797-2-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107021701.1797-1-glin@suse.com>
References: <20210107021701.1797-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.141.15]
X-ClientProxiedBy: AM4P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::34) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.141.15) by AM4P190CA0024.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Thu, 7 Jan 2021 02:17:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65a32ef5-57f4-41aa-ab7b-08d8b2b25f71
X-MS-TrafficTypeDiagnostic: DB7PR04MB5226:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB52269B9FFC10CFCCAAD603D0A9AF0@DB7PR04MB5226.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jklKD8xRoIAE1lY/Xh/kMPn+VuFSZgdaN0uDrJk9bdPV9y6DzBg+2tLoUVGolheKPt6HxWHPXWMHG2xN2tGsux+2J6mtUjImBhjsg6cKf70wJMtGF7ehdrPio+HkPBnF0gxA4YNcvRkKGQhvbiZj86c56V3PAyDXS4igabiOpECyCqvzKUsayeKZoH2qZBOZZGkgrSM3v1e15yHW2amVxP1YbPryCS7pfGEQxntAKpjRp2l3XIH56mgPwJFnZNiPHJ+cvKRTyfJxZBb5+YAp3xN8yfTdQ4CmLDZQ5DvABd0OHY3RC5KrW5rpKvHBIM/2RQC6JhckVMtyz6J1GTiuyVUZif3V82BGJp01CotZq4GN7P8mX5vDtUAjBViwsWULY/oIeTfsdsijOSBTkS5+fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39850400004)(396003)(478600001)(8676002)(5660300002)(6512007)(54906003)(86362001)(2616005)(956004)(110136005)(4326008)(8936002)(316002)(107886003)(6486002)(36756003)(1076003)(83380400001)(66946007)(66556008)(6666004)(16526019)(2906002)(52116002)(186003)(6506007)(66476007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ILGaG4rXlS4+cix3N+D8MwGH0/O01hoLzW1xZkqVlTp5kRbsG8pWA9LSMFhz?=
 =?us-ascii?Q?usrtllA4iaHIdB0raIHBydjdmBW004JSyEYCVTAtlaHd59MlX77l2eeNqFDd?=
 =?us-ascii?Q?TLBEfTt7nakZ3CLIAsOPB7sikBSWj9wzUZeA7prHwnJ0IRJfuvsOV8Jn45Ki?=
 =?us-ascii?Q?/jHwWVnUph/XxQmyKyVGt1eAbMnS0j2cbwCWcBf6UV8ijxxCaWJ2xQU+8AKg?=
 =?us-ascii?Q?uqkjYnot6YUTVgdEP04k3comQH0TB+Ja0OtDT9a/m3WNArM63Y0Cc5PAnUSK?=
 =?us-ascii?Q?h68Yk/IMCisl0/id1Suu7P0H/C/8NAKkjs9CWKYzmGmOO7SOGfU3ogv3l2Oe?=
 =?us-ascii?Q?7LEob9fQpRnvpRbSZ/skRFEBMspuP7OqrxivqCPwmh1VLTJE6PSqCEnvZgvO?=
 =?us-ascii?Q?4NsLwZaZzi1bM2aSFK4qjM/gEGbl0X1/q6TR8V8cyIszyAHf4Q4DSC5JqyMN?=
 =?us-ascii?Q?nA5nqbd2JgfeRV9wQlGt88IuQAphu4Ix0UEYrvUuBIPEDARaLvIImFsrHqjz?=
 =?us-ascii?Q?vOFCc4JANJKaDCos2nwb+sXxAYb7un2TCEXD045y4F6r45+HE/swgl0krlCs?=
 =?us-ascii?Q?cIG9YIAnPwrFCno488hEKExYSc3S7zH/6L3OuS8sOBmhZRGAlREEcLUZ/2t6?=
 =?us-ascii?Q?A+vuSRuFnpRTAuUUJBKP0ZBUiKNdCOuEN9zDnbju1ebL86/4G+CE+hgd5W0i?=
 =?us-ascii?Q?ciiuXUBhqq2uOTew1aF6q/QSuNA0GlIaFapTb5ClfAIuDbwafsQreoeMmLyB?=
 =?us-ascii?Q?89NJrilqmusNm/sXpR238c3l41GuSzGucaDoPPDOlX1sAJ3KuKQNO0eXKRAp?=
 =?us-ascii?Q?CF0CMyOVXzXKurr9bJIdX6wiwQPyZ+YHSpjRvAuPPzTaHNG4fyx1UcfcXLPl?=
 =?us-ascii?Q?c1ycANuAuPWQoB2cUr9LIe5SkwRk7VO3wtQtaCzhLci/p7INFOez5TMcHaKx?=
 =?us-ascii?Q?lyBmENaYod924NQ7/76B66IKpyNu/FU2RXumilSHXmzS6XzdWw3BqAXTAtU1?=
 =?us-ascii?Q?0InY?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 02:17:24.7593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a32ef5-57f4-41aa-ab7b-08d8b2b25f71
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6WCqnfQDjHTVxpl42Lk2nfk3NoyM1oyQY/T2svpOBXmLJdMWU/Hd51Lua0nDV/7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5226
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

For bpf-to-bpf, the 'padded' flag is introduced to 'struct x64_jit_data' so
that bpf_int_jit_compile() could know whether the program is padded in the
previous run or not.

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

v2:
  - Simplify the sample code in the description and provide the jit code
  - Check the expected padding bytes with WARN_ONCE
  - Move the 'padded' flag to 'struct x64_jit_data'

Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/net/bpf_jit_comp.c | 86 ++++++++++++++++++++++++++-----------
 1 file changed, 62 insertions(+), 24 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..9ecc1fd72b67 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -789,8 +789,31 @@ static void detect_reg_usage(struct bpf_insn *insn, in=
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
@@ -824,6 +847,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs=
, u8 *image,
 		u8 jmp_cond;
 		int ilen;
 		u8 *func;
+		int nops;
=20
 		switch (insn->code) {
 			/* ALU */
@@ -1409,6 +1433,13 @@ xadd:			if (is_imm8(insn->off))
 			}
 			jmp_offset =3D addrs[i + insn->off] - addrs[i];
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding) {
+					nops =3D INSN_SZ_DIFF - 2;
+					WARN_ONCE((nops !=3D 0 && nops !=3D 4),
+						  "unexpected cond_jmp padding: %d bytes\n",
+						  nops);
+					cnt +=3D emit_nops(&prog, nops);
+				}
 				EMIT2(jmp_cond, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
@@ -1431,11 +1462,29 @@ xadd:			if (is_imm8(insn->off))
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
+					nops =3D INSN_SZ_DIFF;
+					WARN_ONCE((nops !=3D 0 && nops !=3D 2 && nops !=3D 5),
+						  "unexpected nop jump padding: %d bytes\n",
+						  nops);
+					cnt +=3D emit_nops(&prog, nops);
+				}
 				break;
+			}
 emit_jmp:
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding) {
+					nops =3D INSN_SZ_DIFF - 2;
+					WARN_ONCE((nops !=3D 0 && nops !=3D 3),
+						  "unexpected jump padding: %d bytes\n",
+						  nops);
+					cnt +=3D emit_nops(&prog, INSN_SZ_DIFF - 2);
+				}
 				EMIT2(0xEB, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT1_off32(0xE9, jmp_offset);
@@ -1578,26 +1627,6 @@ static int invoke_bpf_prog(const struct btf_func_mod=
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
@@ -1970,8 +1999,12 @@ struct x64_jit_data {
 	u8 *image;
 	int proglen;
 	struct jit_context ctx;
+	bool padded;
 };
=20
+#define MAX_PASSES 20
+#define PADDING_PASSES (MAX_PASSES - 5)
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header =3D NULL;
@@ -1981,6 +2014,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	struct jit_context ctx =3D {};
 	bool tmp_blinded =3D false;
 	bool extra_pass =3D false;
+	bool padding =3D false;
 	u8 *image =3D NULL;
 	int *addrs;
 	int pass;
@@ -2010,6 +2044,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 		}
 		prog->aux->jit_data =3D jit_data;
 	}
+	padding =3D jit_data->padded;
 	addrs =3D jit_data->addrs;
 	if (addrs) {
 		ctx =3D jit_data->ctx;
@@ -2043,7 +2078,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	 * pass to emit the final image.
 	 */
 	for (pass =3D 0; pass < 20 || image; pass++) {
-		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx);
+		if (!padding && pass >=3D PADDING_PASSES)
+			padding =3D true;
+		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx, padding);
 		if (proglen <=3D 0) {
 out_image:
 			image =3D NULL;
@@ -2097,6 +2134,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 			jit_data->proglen =3D proglen;
 			jit_data->image =3D image;
 			jit_data->header =3D header;
+			jit_data->padded =3D padding;
 		}
 		prog->bpf_func =3D (void *)image;
 		prog->jited =3D 1;
--=20
2.29.2

