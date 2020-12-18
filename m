Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F852DDF3F
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 08:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732698AbgLRHu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 02:50:56 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:33486 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732322AbgLRHuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 02:50:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1608277785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hyrYqRtTXMHSyqoUwmKQEUTSYec7i3mrrG1VEpyCw98=;
        b=cCvsSsN6oTSECfZkwAM9irArvAihsSbyJTIU6NnWdi2tAoKLMJNky0e3qTkDKgAoIZTXv1
        DrkIt6OIf1WMf91Hoaxx0YjngqK734hZDHXnpGa0kSr9MQfOC4XZS9pE/4MX6VYlHkC39c
        CKOgZWyIqaU8g774KKsAExxoI9G1j5c=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2058.outbound.protection.outlook.com [104.47.8.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-bpqHbXHBOuy-SwDRA5_j4w-4; Fri, 18 Dec 2020 08:49:44 +0100
X-MC-Unique: bpqHbXHBOuy-SwDRA5_j4w-4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2BLMN9BIwc+UCPfmznCM2c/TefV5u4wsWM3dvgRrGQFvsd0r/stKoBpwGnUMFbS9xREhCCfBEvQlkaBMjl8khdVRJWSxkoC99XoREP1/uYQJB44P8l9eFM8PnYsnwjJmKc9yt5+NJqT5EBbBV/k9FNksKJ9Nj1I+I9zQU7i4nXR2piMko3DCtXRNL3ahLHyKbJCI6oTer9j9oGcDkObKTnjKPM6dHfMvyRaibhZgdxUMXfAlvv8NK6wHyyZq+K6gjNkKwR13n7RMpGPaMp8ohZ9xMM57J8/d048dnCOzES3jJQXOYLbkkqBzIDWhYdmBq7eL9CMQk7IKt3jHMZE2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfsH9zmb27Cp6M9alTjweF2YknHyXXP5e6uFAYUAYj8=;
 b=BQk1wottZTm5vb7miMKLGv+OIrTDexXjxuNBC16iKBKXehp18eBEgJ+iDwLBxc9wd8ofBisiL0qsH4Gr6cOYLOFsQ32BtP3T4v23XWPYAep2cWEirMCC8hGRA+jWAkz6WGsalpfkPgjeTcBP/do+TqFcZuu9cDrTrsb0RGJ5ts7Ur6O0RgKpB5zCyzfoYrO0UJ0IMsAzuMXm/4nS4sSP5CHRwGe4TMCPmx5Jh3x0f6d3NJnBH+Cn0NTTKoDYfNjUPjJRKSQADC5Pu1LPbUPx2ZZKwD7dWO1JpeO92lkeOkwiX9/xOtFmJpLLaXqj+BkCzc3raUDXXN4qnC9mHtKJeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB8PR04MB5755.eurprd04.prod.outlook.com (2603:10a6:10:ac::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Fri, 18 Dec
 2020 07:49:40 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 07:49:40 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v2 3/3] selftests/bpf: Add verifier test for x64 jit jump padding
Date:   Fri, 18 Dec 2020 15:49:15 +0800
Message-ID: <20201218074915.22242-4-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201218074915.22242-1-glin@suse.com>
References: <20201218074915.22242-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.227.5.136]
X-ClientProxiedBy: AM0PR10CA0037.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::17) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (36.227.5.136) by AM0PR10CA0037.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 07:49:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6904bf3f-5bdc-478f-8b3a-08d8a32979f6
X-MS-TrafficTypeDiagnostic: DB8PR04MB5755:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB57556D59EE9886CF84BE086CA9C30@DB8PR04MB5755.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cKkVOkGxktNTE98UNmPjIpQN/zGYg8NxshuTHohzD/9S0x7nrFNsKcxpArQu/CKmQjXVSq+whTagePCGS6V7991sNL1DeEHodL4EKdeauaAcOZZOhAWwU8BqI1RO6i0e76UDu7ojxfL46nCHGrxKddu3cdrnF+g90X7tJsW1Rol0dDIsQgwk2sRXdTb0UsFyP8Ehns/z9Oo7THstPSh9T4LS0T5tUzPoX1qqaKLFL/cioy1EU2DEL6V/EQ7QSpRSN/+1here4kd2B5IBhDv4YrYEEiy8+MhXiEZ+ye0IkGmY/1icmKdAAiTlckfSZqpM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(376002)(346002)(6506007)(956004)(54906003)(66556008)(66946007)(52116002)(186003)(2906002)(66476007)(2616005)(26005)(8936002)(107886003)(86362001)(1076003)(16526019)(6486002)(4326008)(8676002)(6512007)(5660300002)(6666004)(478600001)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RnpWqsQklstf43Ljx1x+4kaRhfgt/CkH0fh3r/Oj9O3YOBZLGd/CII7/1ttU?=
 =?us-ascii?Q?xnQf+Fxepnr0ctgMTFzTIXpfjc+zqNnkk4CYFTKOzPGQvumRCq4nksCW4/nQ?=
 =?us-ascii?Q?fa/jfQx4kapLmZKxjMT5Ogp4f2FOHXTtOecYTm51YaPXcFXtYTyP+L5VyaNT?=
 =?us-ascii?Q?6/q857VkD9nxtTNWmA4oeAiz1xnBFntWvKy/ZA+66Gvaoc2GSy7PS1xmjzt3?=
 =?us-ascii?Q?LscCxXpiZP5X5DZ2W8cvtElVd3YwqjZ+m7OZPaOfd1M0kM6S2ZEwSxebFEOc?=
 =?us-ascii?Q?EK1dZqndTbZ1ZNzb8y8MMhrvHO+tiwKWQuPMj0p6cM99RDae75bzq3+tof4h?=
 =?us-ascii?Q?UunC69pLpSePc9Yo0QChuaSf0yTq08euGITBvN+oSU20DOGxbTRrWjL8HsZ1?=
 =?us-ascii?Q?7sFNoUQiedamA2UiFXGZ8uJ9WuxEzkWhGZIxcPb/Ds9uEuagQe+GlkVOhXvY?=
 =?us-ascii?Q?XbKBPW0DCPry+PukYAsp6OFoPD7BmCb49uOQm3RdeNF9QrJdX77OkYhZlFkM?=
 =?us-ascii?Q?DqLuPJgkLk6UDCmgfcfReiX3Oi6JSWA6JDXgoItC4DQ2y9S3RPtlQbewrbng?=
 =?us-ascii?Q?67H3kvrV76jI+ilZEgpXVoP4m0awtoL6G0uN67zF2RBGNZHBTe0EWw6IDC2o?=
 =?us-ascii?Q?liJJuv/fIKM0fBMH5Yc4PEJPIglfbzquueRo6OyrZ4SNDuKCPTM9j2fi1mPL?=
 =?us-ascii?Q?llWwFN7teDaKWfojbeMswWT5v396cs20XJV2k+hgQvRpROJnr8jP8oKSyRI5?=
 =?us-ascii?Q?n6pIaEOkrB5wMSUemSoARsfiqm9TV9oSWYbaaF+xYCNJvjjftVx4owOawrgh?=
 =?us-ascii?Q?5QDse85NtR6/uRCBOGEJDY25mn//UL12k7VHHO/cR21Wziy+3gGaOhdBetSX?=
 =?us-ascii?Q?dWe//BXVpE2GwD6MxxnXjAGapoOgW/oKu2UIDr5dP/dX0xvHDieB48qxHf2d?=
 =?us-ascii?Q?rNM4RKw2/5/kf7JMV4B8O8QGdh5ygI5etoQzznr6+DY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 07:49:40.6703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 6904bf3f-5bdc-478f-8b3a-08d8a32979f6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kluwO/jFeS6wiTvG1BJGLPMrMnqALF1M6PzXWHaY72sgecd0w9CKrKsy80V67oQB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5755
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

