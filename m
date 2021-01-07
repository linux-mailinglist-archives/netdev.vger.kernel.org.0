Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363302EC806
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 03:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbhAGCSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 21:18:47 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:41937 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726260AbhAGCSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 21:18:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1609985857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hyrYqRtTXMHSyqoUwmKQEUTSYec7i3mrrG1VEpyCw98=;
        b=bR3X4z3Ij/dmvKi02R62WCCbez2sr5OAfT74MoxhfUO9ROJGajqhCKOg2YzODCV3RkcUL5
        ZvCkg/RWwYyPDR43paFT6Z7/7+6FUaOzrvD7o+dNzyd/A1GJ3t1KtsxP6mLESgPrAspK98
        hP0eOQLOPtL8lrdRgPHekqaqutVVeSA=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2051.outbound.protection.outlook.com [104.47.14.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-haxsaQd4PCSPFsW-e1LydA-1; Thu, 07 Jan 2021 03:17:32 +0100
X-MC-Unique: haxsaQd4PCSPFsW-e1LydA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvnzrxzObSeWQg5x9RosmmQNx3uMw18l9xEZMcDDyIyxOgg2NwRh8si+n3QAMeheE0mC4N2cVZGDPc+ajyVhqRE8JZ/cXwf/TVx285ydlZsVjsRx24YjPRa/AoRSG8TtaOIRfAu0AZAeifLK4pC9mbmIxa3sq3VZpgLa1UHhcUQlbgfPvzZB4atnNOZTgM45MzdL+x4bFc16vQcARuEsOz0JaG9OI8HBwlUCQPjCGAkoj+AqtjrlKNN2FfRYXi0uyt4sneSegS+Pcf+XPAhK9INNo7ygx4PCHCmTGH9c2mu8ebOluPzy2Mw6bPYxWkGhCGB2Ri+Nh7aeBH+CEWJTaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfsH9zmb27Cp6M9alTjweF2YknHyXXP5e6uFAYUAYj8=;
 b=LxrNnyJBAAh4rCMtw6GRFrWUpYYfwyQJxEisAYw3Qa/Y7S/SmGVd0GyXxUsoizqBX3dXOlHmQZpGkzK3HHAajPO9BRTFbcas7iynHokYibScLQm54ImOv+nlm5tILfKZF6+d1006Neblmh7dd/+c37KpG2zq9ZHJ+KYJ7gji0SInZlyKSvbkn1jLo+joFp8cpialUOqOrwLU/i+qPZUJY3zifMIaY0Ok1Th+cI3nc3p/8PLtkpS8wILzklYyrPDwPmxNBZqDwlTu485zVILlAB3eIkT84DXlf1xGITZLbuW/mFoZ0s5Xzc+yT+GkHwE/3t9BXJotomA+uDoDOYKGCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB7PR04MB5226.eurprd04.prod.outlook.com (2603:10a6:10:21::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Thu, 7 Jan
 2021 02:17:31 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 02:17:31 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH RESEND v2 3/3] selftests/bpf: Add verifier test for x64 jit jump padding
Date:   Thu,  7 Jan 2021 10:17:01 +0800
Message-ID: <20210107021701.1797-4-glin@suse.com>
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
Received: from GaryLaptop.prv.suse.net (111.240.141.15) by AM4P190CA0024.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Thu, 7 Jan 2021 02:17:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f25e1b13-09ce-4806-5436-08d8b2b2633c
X-MS-TrafficTypeDiagnostic: DB7PR04MB5226:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB52264ACF426F2C299344B542A9AF0@DB7PR04MB5226.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ojkTUUcOa87gSunBkIwkXszTqV03OKpQQ9Tba34t6ZTCqRZG1+WWJvQi71Zc14DV2qrT78CvwMku9gd9nQgxwA8WltATX5baQP8SbEzp0h+7QnlrXxoiRX5vIu+qxHLHILxuxNfOKnqbKXfaoCguUUcI1idrArDIedgjMWXe5JiIUaXu1o5JFEGfpwcyLtMD/WwgdDSSFvDzBePepmCdz60Oh6T8RqFnwFzHNBMwKf8zdN7jkZuGsuSAIj9Ev4dTh7wUzdGS2ZxpgVdc2rS0Ei4F7Mm+gvxfb2GaNhL1oGbFiXpOJkllOrKIFaXv/b3Mb4/S+/HhQaLlnGz62splhcApijh3/8oafAtMlOjxmWOdoNourlwx7DU7O64rXOhQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39850400004)(396003)(478600001)(8676002)(5660300002)(6512007)(54906003)(86362001)(2616005)(956004)(110136005)(4326008)(8936002)(316002)(107886003)(6486002)(36756003)(1076003)(66946007)(66556008)(6666004)(16526019)(2906002)(52116002)(186003)(6506007)(66476007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EdB7hoUk+KXYqhVx7mRIrMl/jU65QgxdJG5hdeNRXNjm68I90NlZyaw8NUlF?=
 =?us-ascii?Q?2nNavZ7yN9Gb13ZlwY3hHUi7ckE1xEjD1/suVyv7idX3Uvle+I0o7I4ECJAg?=
 =?us-ascii?Q?j6p0tJzvYbMMLrKVQywweQDrCYCaSIL0h4gsKvCbnO2DrffGoEPn+B0xRa2G?=
 =?us-ascii?Q?SgBzRGJ/JHheStMIERwDeX/wUT8Wz+w7AVoUpuGuBkJkH5dvMD7+mGIZTuH4?=
 =?us-ascii?Q?WwWV45ehi091a9l432CGPBEV4++p1YpZMMgMMIUBluHGvlOFUnYPSFkg5Vxu?=
 =?us-ascii?Q?a8z3hvJanRdQT0biSMQF65zM82NKDzQOAuO2q1P2JzigP7nnkGIVD9W9LPZd?=
 =?us-ascii?Q?84irw1wSHFuwJNOhl/sY17WUzfQ78SPMde87HScpi+2J6EV6lynjFpfuuNvE?=
 =?us-ascii?Q?YbyRl1k2FY3Jn3QjG+C2B9BClzEu7UuR3MwoIuQ5UHj3s4Ya8HX4QWdfHOor?=
 =?us-ascii?Q?FBZPRY4UsB7FWO/l9ckfVzSrJZc5SeVS797Q69yyK29gf0NFkPGmLxXNyY9O?=
 =?us-ascii?Q?D+IlSUrWFLhXAoWVczEUu6L4256g4rqZduFrduPXlxbfFFV36tT0OOI0AMua?=
 =?us-ascii?Q?RnI5aVGAN4H+PyDiJZ87VqT80JwHTSn9GxqqGAklC3AfOyp+MW0Xtvl1nZ4p?=
 =?us-ascii?Q?Xb322EkIuU/1aV+mR/Z4Jj5KH8I9Q4eDQVw1p2hI1er2w4jtAEmcuWuVQSdu?=
 =?us-ascii?Q?eSdgx89GktmRROOiDrJ5ztuoMdf9Rc0LYf3RCq4qh74yjuZ4eJpX4EuoV9C4?=
 =?us-ascii?Q?6knF76fT3SHMJrRRjBgmKAzlBaT1FvKnoV6b5jC7Zug33qKqeHJO4joFiR9s?=
 =?us-ascii?Q?F2HQnogn3TpXje3vmLOrKVwXmtJKEa9c031UA1sPVovkiX24DKHdm/1UQadX?=
 =?us-ascii?Q?zo2taEiX8BMqa0CHGtjmnJCGWMfaLEVswStdCVVzdNckxweL79OYTt+RDLSY?=
 =?us-ascii?Q?74vayRr55hpjL/4bu25MWeK78Lrh/+RCJIAaIHSUGu/oATO/KoULCW7VdMT8?=
 =?us-ascii?Q?9bl/?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 02:17:31.0916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: f25e1b13-09ce-4806-5436-08d8b2b2633c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: brwJlbt2peCNYqaPphYeVEAkZnxdNg/pYz8upAKvHrG8fgNDE9IDXg0bKEeXscv0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5226
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two tests added into verifier's jit tests to trigger x64
jit jump padding. The first test can be represented as the following
assembly code:

      1: bpf_call bpf_get_prandom_u32
      2: if r0 =3D=3D 0 goto pc+128
      3: if r0 =3D=3D 1 goto pc+128
         ...
    129: if r0 =3D=3D 127 goto pc+128
    130: goto pc+128
    131: goto pc+127
         ...
    256: goto pc+1
    257: goto pc+0
    258: r0 =3D 1
    259: ret

We first store a random number to r0 and add the corresponding
conditional jumps (2~129) to make verifier believe that those jump
instructions from 130 to 257 are reachable. When the program is sent to
x64 jit, it starts to optimize out the NOP jumps backwards from 257.
Since there are 128 such jumps, the program easily reaches 15 passes and
triggers jump padding.

Here is the x64 jit code of the first test:

      0:    0f 1f 44 00 00          nop    DWORD PTR [rax+rax*1+0x0]
      5:    66 90                   xchg   ax,ax
      7:    55                      push   rbp
      8:    48 89 e5                mov    rbp,rsp
      b:    e8 4c 90 75 e3          call   0xffffffffe375905c
     10:    48 83 f8 01             cmp    rax,0x1
     14:    0f 84 fe 04 00 00       je     0x518
     1a:    48 83 f8 02             cmp    rax,0x2
     1e:    0f 84 f9 04 00 00       je     0x51d
      ...
     f6:    48 83 f8 18             cmp    rax,0x18
     fa:    0f 84 8b 04 00 00       je     0x58b
    100:    48 83 f8 19             cmp    rax,0x19
    104:    0f 84 86 04 00 00       je     0x590
    10a:    48 83 f8 1a             cmp    rax,0x1a
    10e:    0f 84 81 04 00 00       je     0x595
      ...
    500:    0f 84 83 01 00 00       je     0x689
    506:    48 81 f8 80 00 00 00    cmp    rax,0x80
    50d:    0f 84 76 01 00 00       je     0x689
    513:    e9 71 01 00 00          jmp    0x689
    518:    e9 6c 01 00 00          jmp    0x689
      ...
    5fe:    e9 86 00 00 00          jmp    0x689
    603:    e9 81 00 00 00          jmp    0x689
    608:    0f 1f 00                nop    DWORD PTR [rax]
    60b:    eb 7c                   jmp    0x689
    60d:    eb 7a                   jmp    0x689
      ...
    683:    eb 04                   jmp    0x689
    685:    eb 02                   jmp    0x689
    687:    66 90                   xchg   ax,ax
    689:    b8 01 00 00 00          mov    eax,0x1
    68e:    c9                      leave
    68f:    c3                      ret

As expected, a 3 bytes NOPs is inserted at 608 due to the transition
from imm32 jmp to imm8 jmp. A 2 bytes NOPs is also inserted at 687 to
replace a NOP jump.

The second test is to invoke the first test as a subprog to test
bpf2bpf. Per the system log, there was one more jit happened with only
one pass and the same jit code was produced.

Signed-off-by: Gary Lin <glin@suse.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 43 +++++++++++++++++++++
 tools/testing/selftests/bpf/verifier/jit.c  | 16 ++++++++
 2 files changed, 59 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/se=
lftests/bpf/test_verifier.c
index 9be395d9dc64..0671e88bc15d 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -296,6 +296,49 @@ static void bpf_fill_scale(struct bpf_test *self)
 	}
 }
=20
+static int bpf_fill_torturous_jumps_insn(struct bpf_insn *insn)
+{
+	unsigned int len =3D 259, hlen =3D 128;
+	int i;
+
+	insn[0] =3D BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32);
+	for (i =3D 1; i <=3D hlen; i++) {
+		insn[i]        =3D BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, i, hlen);
+		insn[i + hlen] =3D BPF_JMP_A(hlen - i);
+	}
+	insn[len - 2] =3D BPF_MOV64_IMM(BPF_REG_0, 1);
+	insn[len - 1] =3D BPF_EXIT_INSN();
+
+	return len;
+}
+
+static void bpf_fill_torturous_jumps(struct bpf_test *self)
+{
+	struct bpf_insn *insn =3D self->fill_insns;
+	int i =3D 0;
+
+	switch (self->retval) {
+	case 1:
+		self->prog_len =3D bpf_fill_torturous_jumps_insn(insn);
+		return;
+	case 2:
+		/* main */
+		insn[i++] =3D BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 3);
+		insn[i++] =3D BPF_ST_MEM(BPF_B, BPF_REG_10, -32, 0);
+		insn[i++] =3D BPF_MOV64_IMM(BPF_REG_0, 2);
+		insn[i++] =3D BPF_EXIT_INSN();
+
+		/* subprog */
+		i +=3D bpf_fill_torturous_jumps_insn(insn + i);
+
+		self->prog_len =3D i;
+		return;
+	default:
+		self->prog_len =3D 0;
+		break;
+	}
+}
+
 /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up maps */
 #define BPF_SK_LOOKUP(func)						\
 	/* struct bpf_sock_tuple tuple =3D {} */				\
diff --git a/tools/testing/selftests/bpf/verifier/jit.c b/tools/testing/sel=
ftests/bpf/verifier/jit.c
index c33adf344fae..b7653a334497 100644
--- a/tools/testing/selftests/bpf/verifier/jit.c
+++ b/tools/testing/selftests/bpf/verifier/jit.c
@@ -105,3 +105,19 @@
 	.result =3D ACCEPT,
 	.retval =3D 2,
 },
+{
+	"jit: torturous jumps",
+	.insns =3D { },
+	.fill_helper =3D bpf_fill_torturous_jumps,
+	.prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
+	.result =3D ACCEPT,
+	.retval =3D 1,
+},
+{
+	"jit: torturous jumps in subprog",
+	.insns =3D { },
+	.fill_helper =3D bpf_fill_torturous_jumps,
+	.prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
+	.result =3D ACCEPT,
+	.retval =3D 2,
+},
--=20
2.29.2

