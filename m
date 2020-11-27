Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4FC2C6072
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 08:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405317AbgK0HXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 02:23:20 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:52498 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389455AbgK0HXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 02:23:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606461796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8z/v5RlkO1mt/B8W7JZ6ft49P0LoBPl4qFCSoEDw1Ec=;
        b=gO4Nd16aSXmo8hY3gcdgrJT/9qZULkC5ye9HfGIAeS0yFqRXbHNhFeY1okC+8FdV1DWL+P
        2Py4ZmnskhsKOQF8Xx3MYQ8ahkIejVlBxTpHZFk5IjYZaAJ4H7FoIY2tLRvuiRTVc50DXk
        WcXPP81efwEMF2+b65eJ6I45a1Ez9co=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-11-2YQyJs5wMySzrv8xzCegDg-1; Fri, 27 Nov 2020 08:23:14 +0100
X-MC-Unique: 2YQyJs5wMySzrv8xzCegDg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1dsw8nWPjWXUdxljTT7J/7VBpVzybGZLuneBl5NIbC97o7tE6As7Pwehn4hqtdSkwGyR44h6bdIes2ySfLkkN/P+5cuxdIm/JuFuRkknRYbHKmHZo+PXLQIDLE8S0uuE1MARSGkWeyJjM4QG2qTuInjQoHd+hbUNslY9mOUu/GuxmQLtP1MRLcAI9+xQQYuXO7I9trJa0F+aGHeifeNpSdles/OqV5zDFHxnWZWq5cLFT1kvhpHNRR4MbDlsDGtRuljUmwWIC/fbKxk915XonCkn9hFhaiYr1EAo72zSp5KJ3rlD/Jdgc2TB2/osPm2x77JWWVFn0WZLusui1+zvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCDbwUtbq4X6zj7BRsYRp2H5DB9pzA1eLnOh/t3ErOM=;
 b=JsVSnnRa+xAE4C8bLiT41IM5Er75fdJeWGW/09unlqXv5TztYhiIRHPqZFsnNQF5UJpOF8mEFLObG9Ua0+Q4ljwpcH7JJme8yVw5Fm+nK2wDXvm9Suc6ZTilF1d+m7up8JX4fqk1rjcF1iSgDGE7JekQsJJKg8hC3543EFKP7g/v60Ao1wVbMuiojMLFSWXtdv6nsD9MbyMY5hRPtOtm9FXytB9PB94Vt7EWsZvLZ/Qa0KuURVtO8Cl33XwP8yCGQf/IFlcTw5hQfGklUAfmcFCzfWga5h3k7kbtKpSaOFl7Ejt8Eax2omkU5A1tyg8yxEwNtWqQoelkAGSi2FXZVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBAPR04MB7286.eurprd04.prod.outlook.com (2603:10a6:10:1aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Fri, 27 Nov
 2020 07:23:13 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%7]) with mapi id 15.20.3589.029; Fri, 27 Nov 2020
 07:23:13 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andreas.taschner@suse.com
Subject: [PATCH] bpf, x64: add extra passes without size optimizations
Date:   Fri, 27 Nov 2020 15:22:54 +0800
Message-ID: <20201127072254.1061-1-glin@suse.com>
X-Mailer: git-send-email 2.28.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: FRYP281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::28)
 To DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation.suse.de (60.251.47.115) by FRYP281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6 via Frontend Transport; Fri, 27 Nov 2020 07:23:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5a78616-233f-4ab9-604f-08d892a54cab
X-MS-TrafficTypeDiagnostic: DBAPR04MB7286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB728689F93D24D56ED210FA73A9F80@DBAPR04MB7286.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTqLO+X8qGjlbam2x0926tKNNAj9xz0B5gktqpl9U5IuHVfff1BWcckY3Y2Si9Pz/2/8D0pqSXWznsDgIUDUZkQSG+Xh2JL9voNzkhkaUuN03xaqJ8EPIST0QGyvgGtPGh2dri4QvcQzQgKLXqhQuTOBzrhubA+weVLVCMc5bk8wySjWLhix5AFEwsIjxMhPzH5SHlgIMXkS5K+V5kYiEgAIb0oV18nXcNpm/zdeItnNqubbW32d1EjYeKL7NPuUpDFzUzhvFIAj4FO3o0RiJBnQiX23P277dM5cDcoSOXF4zsoQYp2dU1o2DYfmMT90h2Ix8BDI9kUyqq711i9E2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(8676002)(8936002)(16526019)(2906002)(956004)(186003)(52116002)(55236004)(2616005)(26005)(83380400001)(6506007)(6486002)(36756003)(316002)(6512007)(66556008)(66476007)(107886003)(86362001)(66946007)(4326008)(478600001)(54906003)(5660300002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?79Jz0pqeitdoGlJ6X1hbHiOJk4KQWX9CDk5uat9TwgWMTWkzz0ty+bdY7j05?=
 =?us-ascii?Q?cY3d8ZJODw0BKnzrI5iY3LkXIjxU489AuZYND9t8lQMRErUifTKJWckYBQqM?=
 =?us-ascii?Q?4f+4PCz1P0r/mpbus/+hhy3vpPnSjYG8atEYaqgSri1I/CM1Sl6sa6c8f1Yi?=
 =?us-ascii?Q?Z++XasNhwwhBBaxoc76m7uJ9McESS9y4WMmsCuesXC2mzmLNVjeyYUDOeL2V?=
 =?us-ascii?Q?XIJJUapXBLxoE+fXAlZ1AQprx+bE0BBMI3DYEN6V/b7V2jc1xrfqFp98W0C3?=
 =?us-ascii?Q?PY6NOFo8aujvIue+8cUoFnaud9Z+NQdr0OirXk9PURp2cOrwFSF5JsXQQbwr?=
 =?us-ascii?Q?Zp2HCMaQmBMvYz9GrhwBbNc6o+OdpyYYZ5NtBn8/dlAP2X5qqEsoCVAoQp15?=
 =?us-ascii?Q?G2QVpU3tpjocuUK+COaHElu/AoK4QYugZ+WHkimxmiBuuIZ6tdc3zzKLk2t3?=
 =?us-ascii?Q?qGvppKgcrVod6r/29OPspLbAuQdDetyRA5Pm7qIGmZoSAJygPDVkewlQYAE7?=
 =?us-ascii?Q?mWmxrcmRSr/6m/6ycp2A3EFmr9LVdiWahbEHHyLDN7lwdFqhSjZCFYjKg2LR?=
 =?us-ascii?Q?HZWUTI0ehPtUZagkGqHx90nR9X/jUxIa+oPy1HEUDy/ZY/pFf4guVxxpXKJ6?=
 =?us-ascii?Q?QD7BQXx/0esMTrbRhcC67q0WSLu6re++xPdfT5XmloyqRELin+YMxmL5DPMy?=
 =?us-ascii?Q?GqBa5SbTcXiWvvpT/NbqE3lHWDWVIKf/vBXY+xdoNHYQDl290YBmb5C0s7ea?=
 =?us-ascii?Q?1tER5gix/glKo6A8YfYxUn7QZtj4RvIVMXTMi+AcS8pLIo6ffxxdFXlCMvbR?=
 =?us-ascii?Q?5bQybo5m4axkGj7tUIpyMxikHEzLTXeqAKqajYlJT7KKTzCifUSG+kDSNKh9?=
 =?us-ascii?Q?2l46RpVO8ltC+Gf0Ca3EiYzX5vzFt8CBHbRMXMgSwqMK/d4/ueJN8aWk1V8X?=
 =?us-ascii?Q?htSdARxCg5cbY7ZRhhbsxT8lcKCXggtFF+B7OqKvTC956CbIkbtIMilTj4ab?=
 =?us-ascii?Q?2w7X?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a78616-233f-4ab9-604f-08d892a54cab
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 07:23:12.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JyBWLX5rCAeN9rUskWwMopUOFiGUqneZHwvNPrwCXFmL5e5T4S8aeyP4NywfHheM
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

This bpf program contains 32 "ja 41" instructions which are effectively
NOPs and designed to be replaced with valid code dynamically. Ideally,
bpf jit should optimize those "ja 41" instructions out when translating
translating the bpf instructions into x86_64 machine code. However,
do_jit() can only remove one "ja 41" for offset=3D=3D0 on each pass, so it
requires at least 32 runs to eliminate those JMPs and exceeds the
current limit of passes (20). In the end, the program got rejected when
BPF_JIT_ALWAYS_ON is set even though it's legit as a classic socket
filter.

Instead of pursuing the fully optimized image, this commit adds 5 extra
passes which only use imm32 JMPs and disable the NOP optimization. Since
all imm8 JMPs (2 bytes) are replaced with imm32 JMPs, the image size is
expected to grow, but it could reduce the size variance between passes
and make the images more likely to converge. The NOP optimization is
also disabled to avoid the further jump offset changes.

Due to the fact that the images are not optimized after the extra
passes, a warning is issued to notify the user, but at least the images
are allocated and ready to run.

Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/net/bpf_jit_comp.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..125f373d6e97 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -790,7 +790,8 @@ static void detect_reg_usage(struct bpf_insn *insn, int=
 insn_cnt,
 }
=20
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
-		  int oldproglen, struct jit_context *ctx)
+		  int oldproglen, struct jit_context *ctx, bool no_optz,
+		  bool allow_grow)
 {
 	bool tail_call_reachable =3D bpf_prog->aux->tail_call_reachable;
 	struct bpf_insn *insn =3D bpf_prog->insnsi;
@@ -1408,7 +1409,7 @@ xadd:			if (is_imm8(insn->off))
 				return -EFAULT;
 			}
 			jmp_offset =3D addrs[i + insn->off] - addrs[i];
-			if (is_imm8(jmp_offset)) {
+			if (is_imm8(jmp_offset) && !no_optz) {
 				EMIT2(jmp_cond, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
 				EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
@@ -1431,11 +1432,11 @@ xadd:			if (is_imm8(insn->off))
 			else
 				jmp_offset =3D addrs[i + insn->off] - addrs[i];
=20
-			if (!jmp_offset)
+			if (!jmp_offset && !no_optz)
 				/* Optimize out nop jumps */
 				break;
 emit_jmp:
-			if (is_imm8(jmp_offset)) {
+			if (is_imm8(jmp_offset) && !no_optz) {
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
+#define NO_OPTZ_PASSES (MAX_JIT_PASSES - 5)
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_binary_header *header =3D NULL;
@@ -1981,6 +1985,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	struct jit_context ctx =3D {};
 	bool tmp_blinded =3D false;
 	bool extra_pass =3D false;
+	bool no_optz =3D false;
+	bool allow_grow =3D false;
 	u8 *image =3D NULL;
 	int *addrs;
 	int pass;
@@ -2042,8 +2048,23 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog=
 *prog)
 	 * may converge on the last pass. In such case do one more
 	 * pass to emit the final image.
 	 */
-	for (pass =3D 0; pass < 20 || image; pass++) {
-		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx);
+	for (pass =3D 0; pass < MAX_JIT_PASSES || image; pass++) {
+		/*
+		 * On the 21th pass, if the image still doesn't converge,
+		 * then no_optz is set afterward to make do_jit() disable
+		 * some size optimizations to reduce the size variance.
+		 * The side effect is that the image size may grow, so
+		 * allow_grow is flipped to true only for this pass.
+		 */
+		if (pass =3D=3D NO_OPTZ_PASSES && !image) {
+			pr_warn("bpf_jit: disable optimizations for further passes\n");
+			no_optz =3D true;
+			allow_grow =3D true;
+		} else {
+			allow_grow =3D false;
+		}
+
+		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx, no_optz, allow_=
grow);
 		if (proglen <=3D 0) {
 out_image:
 			image =3D NULL;
--=20
2.28.0

