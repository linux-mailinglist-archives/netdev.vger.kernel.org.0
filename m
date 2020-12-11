Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8842D719D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436500AbgLKIX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:23:26 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:27443 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405523AbgLKIXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 03:23:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607674920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GwNK9AUGr2lkOa4ydTlki2cQ1wJTj/0TtBW/FANwqZo=;
        b=LHbIJMHwVNKGFhq/XXbcdegHD7ikniGTXlrz+42o6D8HtrrNZ6Zu4V+FZXiLA4aghGATe6
        6r46jdiqHcZFevGNkaOc4UU9QM3czrdQLCbq/w0mjx46/VRAYKGB+L0s2xdi40d7P+h4LU
        Ej92SKawwFF+aB3esg7CDessa8SnSpA=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2112.outbound.protection.outlook.com [104.47.18.112])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-7-Npcm_kr2NneyXhneXwUa8w-1; Fri, 11 Dec 2020 09:19:23 +0100
X-MC-Unique: Npcm_kr2NneyXhneXwUa8w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+TtzB8R/r6Xx5SpYmNNj2T5MV+gbviw3IQqKBnx9QfcD+l34HeynKbqyt6ja8Cg02vVVFB5JDN7NclRlgMjngSvIchZLdETXeqKZIxG/OntK0WDWsGJcas5Shu7p8CdIEfGTHseIV/nijcPne0Pzfp37ZHaL232Bypez76/8KIDgURgm37cZeDyvD4ZQtMLjVBlXgiaDJWaPuENDdnBh4gX0xePJcsMFh90s1r4YdoZ9v1HkV1Mt/CWCVqFWPdFWCXOvpad5KYiRS2XCYujR+0Ig+piRKR/094IIKRkS0yWNhKec2lUT0xOAfzvZk47z8Tx3DESYRFRx/fRFM4DbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFvvt+yR2QOtESb2E8z5ol6d2Aidfo6vMHqO41srKgw=;
 b=Or8eF5tCPUTvd5wjR9FaOo4E2QU9MNjTQEt+2+5rb35uJc1lFwbTgxwJskaog657VlVGBjDEJCW9NXd9pNCLv7EVrfJccJ0soZiL2ZJqG7sRqMHbvzkqEDsPU9ASZC/2xjC27mObCqNSdtNWCyTTKp5pjCmIa+IWUUa1cOYQPdq4LInWN//7osSL1Jh771Babfw/KsWZJo+3Ec2bQWXL+KPetrAmPND1Zi/EBRZYG0mML6lCbrGts+pLXwig+FNxJyGRUqp4xe6YSlZbds8tInVJUsLygIugfL+Md3QdnEPd9m/413EDfIXOE/C6lv8ahiRPFavt1bTnQjSRSYeAhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB8PR04MB6554.eurprd04.prod.outlook.com (2603:10a6:10:10a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Fri, 11 Dec
 2020 08:19:21 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3654.013; Fri, 11 Dec 2020
 08:19:20 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH] bpf,x64: pad NOPs to make images converge more easily
Date:   Fri, 11 Dec 2020 16:19:03 +0800
Message-ID: <20201211081903.17857-1-glin@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.135.1]
X-ClientProxiedBy: AM0PR04CA0128.eurprd04.prod.outlook.com
 (2603:10a6:208:55::33) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.135.1) by AM0PR04CA0128.eurprd04.prod.outlook.com (2603:10a6:208:55::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 11 Dec 2020 08:19:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 711efeb9-933f-4a65-68b3-08d89dad761d
X-MS-TrafficTypeDiagnostic: DB8PR04MB6554:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6554BA1A26627A8BCD740F87A9CA0@DB8PR04MB6554.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIZs/FqI1TY3PTubnJL4FaNTd4xdMOX+EkVkkmiGw5niL8H9GNDkPLypkmhAYKtw751Rfj11yc+wBAlzZLEoM5vFHbVYQIqpXrVWWzlib42E5SPIFGBwqKiPtCTdlLSjBtGoiV9HEWncK/5EWcJYLR9x0Kjq2+0ouUQj6RroVwJH9qJubIFPaxfJ8+T8ak2ZAeWPwFTEQiGeUXyTo5OjlNVVrvNmmVtMbhYZcekvmzIqA7lDsVe42I0sbnkOt5WUTf8gHAslbKqKGyOkWihug/419gH1a36YDj6aFnQEKTV7eibHx65StDjeXnlODQEB41UgxiKvy3IwhwXIZEYReQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(396003)(346002)(136003)(956004)(26005)(66556008)(36756003)(4326008)(52116002)(8936002)(2906002)(186003)(6666004)(16526019)(83380400001)(2616005)(6506007)(8676002)(316002)(66476007)(66946007)(1076003)(54906003)(6486002)(6512007)(107886003)(5660300002)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QKyv3JJ02eQkTR0PUj4y6TgXt6ricmIzt5igOYthq+UsC8zjbOW8ih0qTA57?=
 =?us-ascii?Q?tyagtnMHeJmZtetlaGgCsYFI6VBzwXdd6fEcxknUSxsKA2Ae2NmxrLwdqWL8?=
 =?us-ascii?Q?LCazqpATpnTBm3OVC2cQ3wYwsazdlKOFukya6XmmWPfunoU0E7UDo3nir46m?=
 =?us-ascii?Q?6ZLVkygVcg7bLUInBmgegG6/ucnViZiKCEK007dbDDTzw8ZFSlImN4QAjcCx?=
 =?us-ascii?Q?twJz//OFqUMHAZO21JfDZdGPYb235ocFf3XErlEroVP8KIG2DiQAHWDWWyLM?=
 =?us-ascii?Q?XSZ2RzKtrC1pnosiuShZsGX+ZjeTiKNVRGhNku/SrIQRSf6AVeapL8wqd7pA?=
 =?us-ascii?Q?2cGaq7zJaN6Vrmu57obxVFsQioMLKOiFRwA1qtTyQCh1nM88MuUrCgl5gyFb?=
 =?us-ascii?Q?VjtKMb/Tg07iZtDGVOp6cT1V3r/DBw5bZv93pnY1FU1vjxsmTCm5iEw2bxpR?=
 =?us-ascii?Q?cRSQWklU/6ESSWEiKExG5i3BjcFCMpdYx074NpUq1cBjkrrUoSg3HiqlNjw/?=
 =?us-ascii?Q?fmrqEuDkGrz3xBnmr4Kw2HrCu+qpMdWtwbjEqdl8z9otrL5VGHkQ5Wo92LMA?=
 =?us-ascii?Q?7/boFrvXSjjfnotLfmn2naU6H2ODSPJGedvy34UzerM1y+B9ZHTrmEWn8JGm?=
 =?us-ascii?Q?ipetA/RZQCveRj9Na5ZHrTrLzAw9NU82HHGFt6RG7kVFHAo8SnqNWEE+Q3KN?=
 =?us-ascii?Q?R9bHKiMMJUZe4RTxU+wv0IPIsBL4B5hPtqGP46YsptWq2PWjQxdGlm53wKfY?=
 =?us-ascii?Q?bos4l4l9s5E2D1o9t0wVZnc8i+k1Tk58PktL5BG7akjsrbcSMgslR1K3yffJ?=
 =?us-ascii?Q?JTraga4p9vuSEAfVDXIyDsNMxrnHbi6eGdotLMJLE1LT7VSj9uNrofTLTeqA?=
 =?us-ascii?Q?YwCricOMnAwhao8cW+M9XQePf6jMmmmaP3Fnklt7bPtKZgmlzqS7KvbmNn4j?=
 =?us-ascii?Q?P0yOw0JmC5txrBXLWYiwXGrpQreVzmnBicduy4rEBn8u1MxCrn88jWlZZOuL?=
 =?us-ascii?Q?sHdd?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 08:19:20.8107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 711efeb9-933f-4a65-68b3-08d89dad761d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdcJXAVyXokKNX1h15Qt4m0fmNCawyyYNThui9TbU2kDDlVsnkjZYReLyePx1IhV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6554
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
      l8:     ld [x+16]
      l9:     ja 41

        [... repeated ja 41 ]

      l40:    ja 41
      l41:    ret #0
      l42:    ld #len
      l43:    ret a

This bpf program contains 32 "ja 41" instructions which are effectively
NOPs and designed to be replaced with valid code dynamically. Ideally,
bpf jit should optimize those "ja 41" instructions out when translating
the bpf instructions into x86_64 machine code. However, do_jit() can
only remove one "ja 41" for offset=3D=3D0 on each pass, so it requires at
least 32 runs to eliminate those JMPs and exceeds the current limit of
passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
is set even though it's legit as a classic socket filter.

To make the image more likely converge within 20 passes, this commit
pads some instructions with NOPs in the last 5 passes:

1. conditional jumps
  A possible size variance comes from the adoption of imm8 JMP. If the
  offset is imm8, we calculate the size difference of this BPF instruction
  between the previous pass and the current pass and fill the gap with NOPs=
.
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

To support bpf-to-bpf, a new flag, padded, is introduced to 'struct bpf_pro=
g'
so that bpf_int_jit_compile() could know if the program is padded or not.

Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/net/bpf_jit_comp.c | 68 ++++++++++++++++++++++++-------------
 include/linux/filter.h      |  1 +
 2 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..30b81c8539b3 100644
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
@@ -1409,6 +1432,8 @@ xadd:			if (is_imm8(insn->off))
 			}
 			jmp_offset =3D addrs[i + insn->off] - addrs[i];
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding)
+					cnt +=3D emit_nops(&prog, INSN_SZ_DIFF - 2);
 				EMIT2(jmp_cond, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
@@ -1431,11 +1456,19 @@ xadd:			if (is_imm8(insn->off))
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
+				if (jmp_padding)
+					cnt +=3D emit_nops(&prog, INSN_SZ_DIFF);
 				break;
+			}
 emit_jmp:
 			if (is_imm8(jmp_offset)) {
+				if (jmp_padding)
+					cnt +=3D emit_nops(&prog, INSN_SZ_DIFF - 2);
 				EMIT2(0xEB, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT1_off32(0xE9, jmp_offset);
@@ -1578,26 +1611,6 @@ static int invoke_bpf_prog(const struct btf_func_mod=
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
@@ -1972,6 +1985,9 @@ struct x64_jit_data {
 	struct jit_context ctx;
 };
=20
+#define MAX_PASSES 20
+#define PADDING_PASSES (MAX_PASSES - 5)
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header =3D NULL;
@@ -1981,6 +1997,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	struct jit_context ctx =3D {};
 	bool tmp_blinded =3D false;
 	bool extra_pass =3D false;
+	bool padding =3D prog->padded;
 	u8 *image =3D NULL;
 	int *addrs;
 	int pass;
@@ -2043,7 +2060,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
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
@@ -2101,6 +2120,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 		prog->bpf_func =3D (void *)image;
 		prog->jited =3D 1;
 		prog->jited_len =3D proglen;
+		prog->padded =3D padding;
 	} else {
 		prog =3D orig_prog;
 	}
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1b62397bd124..cb7ce2b3737a 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -531,6 +531,7 @@ struct bpf_prog {
 				dst_needed:1,	/* Do we need dst entry? */
 				blinded:1,	/* Was blinded */
 				is_func:1,	/* program is a bpf function */
+				padded:1,	/* jitted image was padded */
 				kprobe_override:1, /* Do we override a kprobe? */
 				has_callchain_buf:1, /* callchain buffer allocated? */
 				enforce_expected_attach_type:1, /* Enforce expected_attach_type checki=
ng at attach time */
--=20
2.29.2

