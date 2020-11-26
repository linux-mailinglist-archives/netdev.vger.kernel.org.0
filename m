Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3813B2C4FED
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 09:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbgKZIBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 03:01:55 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:41931 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731087AbgKZIBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 03:01:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606377710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DGlHq3F42sGIqF1ptuXkzY9rrstab1ImSegVADSVIZY=;
        b=jV9DzqLKuel1A/sk04/KLk05M3VHcOhsgkMXKFDHmjiGOLGNhT2d4F/8yNejjGfkYrvVG2
        A5E3bKjjjw7WARU9N94KBK5Jf0R62eYR0XSUp0qDiGRG5gL9EE6mY/SW34lZomEEMYQjVs
        WUsfN/b92a7RqehU3YyGB+sg8oS31Kw=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2055.outbound.protection.outlook.com [104.47.1.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-8g_Y-V5NOhu2NOr9mLmWdQ-1; Thu, 26 Nov 2020 09:01:48 +0100
X-MC-Unique: 8g_Y-V5NOhu2NOr9mLmWdQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lk7eZhBPwdJiaSRCLbgpfAwv4xu+jFTYsCTBYLMtVq7exRr9zIt39GQhjttENoBrqOiVyHnslffsDdwY5pAVEnlrBaUIjPmrpV+OjmoLvmAhaNr08ybpZtxtNNptQKjG3bswtaPDVUK53jh0MOcEQUss5iyZLxETjJLh19Ode+GF5StwPCvGW7Fxs6hA+9ZmEfbGBK6Kayy/JKgMMC1/c0xe0w5qYqQpopraQXNHbES+kd2heKOGAAoT3RPjsS83XbkUwrBlLOpubwmgAi/Ed4/5UW18pc75swj//AP3MHcrcysvRLpG1JCwOfM3g2A7vt86ioJ7xf7em47TeYqz5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI8oSUJUYu4/kwv1GOXiNRR2384kMWcJScsjjbxAWEU=;
 b=W2+HBlLfdRIRJj8wEHrYOTGu7GFI7Qn+J5J18dtQb+CSOAVP+lAGgm/rNHbxxGDl4dLVdct69AyATrd+RyXHwQjIcrCDgDIoeGycS6IKRA+fl65uGYEDLPTbiIbJwt0ar7hAEiwRRKk26Ivbl2RjORFsTAC4J9fffSHF91jqJP9BWy6kcoFUMJFsiesXYymi15jT35PPG7bYGrvK5KBUIs/Bw1UnGR+8OmlmB2E6pFMwdlpdQVtFQqvk1tkHqC0fPSahTGVh88ww6ysXq6Rtr+sEjOTvngk+gG9tCGl04eTsx5N3kliibwtS4K64ryscZnY3JrPhbXTBpY7O8xY/tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBAPR04MB7286.eurprd04.prod.outlook.com (2603:10a6:10:1aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Thu, 26 Nov
 2020 08:01:45 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%7]) with mapi id 15.20.3589.029; Thu, 26 Nov 2020
 08:01:45 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andreas.taschner@suse.com
Subject: [RFC PATCH] bpf, x64: add extra passes and relax size convergence check
Date:   Thu, 26 Nov 2020 16:01:30 +0800
Message-ID: <20201126080130.23303-1-glin@suse.com>
X-Mailer: git-send-email 2.28.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR04CA0131.eurprd04.prod.outlook.com
 (2603:10a6:208:55::36) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation.suse.de (60.251.47.115) by AM0PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:208:55::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Thu, 26 Nov 2020 08:01:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9215ed7-c1c9-4bdf-d3be-08d891e18483
X-MS-TrafficTypeDiagnostic: DBAPR04MB7286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB72860FFBCC2F634BB1967342A9F90@DBAPR04MB7286.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nRKt04gibabfxIF8mIms09CBWPLX35c+IOkhFIJ++nIT0Yjjn7V3kawy5vwMecQmithYqNdjp0hCGrWG249rljo7/1Mrpb2zHETePp/2ao/dQDFmF7dAxFGEzCPW8aakswp6an1jFkNGKnSeQlrSvW623MF5qxm6kewPA2tTVeGfHk28hOujfUqy328aiVWb6filXxXj8T29uNYUVJYBRf21bP5LSgU+FH4h9ylQCGtzrF4MAPGp0XH0L6xjrvwuYcdnUreboIYqnIt8X5F53VfURcEoMLyFcfrVQs7KLRJNPZ5IawUhQEFdGWeK8nYr+WJ3NHbcPrGN/1MMIMBFqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(376002)(136003)(8936002)(8676002)(2906002)(52116002)(16526019)(956004)(186003)(55236004)(2616005)(26005)(6506007)(83380400001)(36756003)(6512007)(316002)(107886003)(86362001)(66556008)(66946007)(66476007)(4326008)(54906003)(478600001)(5660300002)(1076003)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oJPaLhywAX+xZ1S7hxHFfnJmYJDx8Wg/poidTyB06UN0lQVRGWxmCN1fe1Rz?=
 =?us-ascii?Q?G8NTmFsSwoWR5Ul3ZEJNMJ3GfElklJPGZZyL00nv+cc78oL0R0xkPN6i07Pr?=
 =?us-ascii?Q?4uYnjh5RtLAjxtqpAHUry/J10n+FwtDB/Sxi89Wubcv6GIUWbnF7WS2vXSIS?=
 =?us-ascii?Q?STiAu0vYgHX0nO5nGRH4G1dDTVB8qMBDhxZldy7VGs8XVmHoUe3Jtr0JC5tH?=
 =?us-ascii?Q?CDSQoHiqqB8HgNw3DeHRVr1aUzBcVHkcZkX7pCdNdw/ZiQF7p6LUkKqQ4KeC?=
 =?us-ascii?Q?DYBgsCKkyviq6wNEH6mhpWa0VLKrsVStvhB5GPD/sdglz9Wg+jC2oj5nGXkm?=
 =?us-ascii?Q?od/95QPCNAxT2iPqq3T1SjeBLKJM8chrjjCliXIgJ2hecTtd/l2e8Dj1Bwg5?=
 =?us-ascii?Q?6OkvQlARhT94OxLaqELgsnKyCEqM8Y9s2B/NHOcNxQxKL5T8tFOO+Sw1Fdzg?=
 =?us-ascii?Q?vx2BZ1RX610YvYR9FV/etXZZx7Npsyz1Q/ONIkt+dd5faOwU+z5/Ec+g72PH?=
 =?us-ascii?Q?b6j4TPg3weLyf9Vi8qQ0lesf3lI/yT2cQfpCNED2c4nUZM8SjcyMfA9WJdSZ?=
 =?us-ascii?Q?n1oqw+T8PrTNil6TRi9q3lBlkpHQwGTRcq2Ck2xzwAPUjgQmIQYPjSpGzSXM?=
 =?us-ascii?Q?tLRekQjEN+PtTRVaxb3AbNZF3jxFcun1OUMIY6JP7tqeKD767bKr+i3rO8mD?=
 =?us-ascii?Q?gmBsbdehdDvY3fuspVnUT2t6EWoUmJfvSm/h9SkQFUX1RiIQbBa8GJznzwIS?=
 =?us-ascii?Q?Uz2mUqIxjJpRiwMqjauGJ10+UEtjCxui6QdLNpljRj/pZHldDTsbqUUWo5uI?=
 =?us-ascii?Q?D1Bac1zw4pOhCI8EGNAb3iuBu3vSrk5UCA1tHwO51N+eAVwrGVRQAOseLz4h?=
 =?us-ascii?Q?oZiUTli1ki12s298B/KftHxUg/7/o6p8G9h2Ro0fFyfX+0sjf68Nm7NROXwd?=
 =?us-ascii?Q?5zE9j3IwzhbD+CqmwK5AN+oQEPluKtnb4MYkuLItzQaB/nofzz8H5DnzfFcj?=
 =?us-ascii?Q?IraF?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9215ed7-c1c9-4bdf-d3be-08d891e18483
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2020 08:01:45.4248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WT4tViKe/1A+hdMqoRwpBScp70tt3vP6x5RyivqbGabgIJG+c9S/fAifXPrlJXMC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7286
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The x64 bpf jit expects bpf images converge within the given passes, but
it could fail to do so with some corner cases. For example:

      l0:     ldh [4]
      l1:     jeq #0x537d, l2, l40
      l2:     ld [0]
      l3:     jeq #0xfa163e0d, l4, l40
      l4:     ldh [12]
      l5:     ldx #0xe
      l6:     jeq #0x86dd, l41, l7
      l7:     jeq #0x800, l8, l41
      l8:     ld [x+16]
      l9:     ja 41

        [... repeated ja 41 ]

      l40:    ja 41
      l41:    ret #0
      l42:    ld #len
      l43:    ret a

This bpf program contains 32 "ja 41" instructions which are effectivly
NOPs and designed to be replaced with valid code dynamically. Ideally,
bpf jit should optimize those "ja 41" instructions out when translating
translating the bpf instrctions into x86_64 machine code. However,
do_jit() can only remove one "ja 41" for offset=3D=3D0 on each pass, so it
requires at least 32 runs to eliminate those JMPs and exceeds the
current limit of passes (20). In the end, the program got rejected when
BPF_JIT_ALWAYS_ON is set even though it's legit as a classic socket
filter.

To allow the not-converged images, one possible solution is to only use
JMPs with imm32 to guarantee the correctness of jump offsets.

There are two goals of this commit:
  1. reduce the size variance by generating only jumps with imm32
  2. relax the requirement of size convergence

Since imm32 jump occupies 5 bytes compared with 2 bytes by imm8 jump,
the image size may swell. To minimize the impact, 5 extra passes are
introduced and the imm32-only rule is only applied to the extra passes,
so the bpf images converge within the original 20 passes won't be
affected.

If the image doesn't converge after the 5 extra passes, the image is
still allocated and a warning is issued to notify the user.

Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/net/bpf_jit_comp.c | 47 +++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..6fe933e9e8c2 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -790,7 +790,8 @@ static void detect_reg_usage(struct bpf_insn *insn, int=
 insn_cnt,
 }
=20
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
-		  int oldproglen, struct jit_context *ctx)
+		  int oldproglen, struct jit_context *ctx, bool force_jmp32,
+		  bool allow_grow)
 {
 	bool tail_call_reachable =3D bpf_prog->aux->tail_call_reachable;
 	struct bpf_insn *insn =3D bpf_prog->insnsi;
@@ -1408,7 +1409,7 @@ xadd:			if (is_imm8(insn->off))
 				return -EFAULT;
 			}
 			jmp_offset =3D addrs[i + insn->off] - addrs[i];
-			if (is_imm8(jmp_offset)) {
+			if (is_imm8(jmp_offset) && !force_jmp32) {
 				EMIT2(jmp_cond, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
@@ -1435,7 +1436,7 @@ xadd:			if (is_imm8(insn->off))
 				/* Optimize out nop jumps */
 				break;
 emit_jmp:
-			if (is_imm8(jmp_offset)) {
+			if (is_imm8(jmp_offset) && !force_jmp32) {
 				EMIT2(0xEB, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT1_off32(0xE9, jmp_offset);
@@ -1476,7 +1477,7 @@ xadd:			if (is_imm8(insn->off))
 		}
=20
 		if (image) {
-			if (unlikely(proglen + ilen > oldproglen)) {
+			if (unlikely(proglen + ilen > oldproglen) && !allow_grow) {
 				pr_err("bpf_jit: fatal error\n");
 				return -EFAULT;
 			}
@@ -1972,6 +1973,9 @@ struct x64_jit_data {
 	struct jit_context ctx;
 };
=20
+#define MAX_JIT_PASSES 25
+#define JMP32_ONLY_PASSES 20
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header =3D NULL;
@@ -1981,6 +1985,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	struct jit_context ctx =3D {};
 	bool tmp_blinded =3D false;
 	bool extra_pass =3D false;
+	bool force_jmp32 =3D false;
+	bool allow_grow =3D false;
 	u8 *image =3D NULL;
 	int *addrs;
 	int pass;
@@ -2042,8 +2048,24 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog=
 *prog)
 	 * may converge on the last pass. In such case do one more
 	 * pass to emit the final image.
 	 */
-	for (pass =3D 0; pass < 20 || image; pass++) {
-		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx);
+	for (pass =3D 0; pass < MAX_JIT_PASSES || image; pass++) {
+		/*
+		 * On the 21th pass, if the image still doesn't converge,
+		 * then force_jmp32 is set afterward to make do_jit() always
+		 * generate 32bit offest JMP to reduce the chance of size
+		 * variance. The side effect is that the image size may grow
+		 * since the 8bit offset JMPs are now replaced with 32bit
+		 * offset JMPs, so allow_grow is flipped to true only for
+		 * this pass.
+		 */
+		if (pass =3D=3D JMP32_ONLY_PASSES && !image) {
+			force_jmp32 =3D true;
+			allow_grow =3D true;
+		} else {
+			allow_grow =3D false;
+		}
+
+		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx, force_jmp32, al=
low_grow);
 		if (proglen <=3D 0) {
 out_image:
 			image =3D NULL;
@@ -2054,13 +2076,18 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_pro=
g *prog)
 		}
 		if (image) {
 			if (proglen !=3D oldproglen) {
-				pr_err("bpf_jit: proglen=3D%d !=3D oldproglen=3D%d\n",
-				       proglen, oldproglen);
-				goto out_image;
+				if (pass < MAX_JIT_PASSES) {
+					pr_err("bpf_jit: proglen=3D%d !=3D oldproglen=3D%d\n",
+					       proglen, oldproglen);
+					goto out_image;
+				} else {
+					pr_warn("bpf_jit: proglen=3D%d !=3D oldproglen=3D%d, pass=3D%d\n",
+						proglen, oldproglen, pass);
+				}
 			}
 			break;
 		}
-		if (proglen =3D=3D oldproglen) {
+		if (proglen =3D=3D oldproglen || pass =3D=3D (MAX_JIT_PASSES - 1)) {
 			/*
 			 * The number of entries in extable is the number of BPF_LDX
 			 * insns that access kernel memory via "pointer to BTF type".
--=20
2.28.0

