Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5919E2F5E24
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 10:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbhANJzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:55:53 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:31550 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728160AbhANJzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:55:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610618081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hyrYqRtTXMHSyqoUwmKQEUTSYec7i3mrrG1VEpyCw98=;
        b=TJdzrI29mTLdP4YgZyHOslJlGyXcZrDDe6PUOgc5bYe77Cnr1izIeYc0sTUNtpzXsdfs90
        RYuE2f1IKq1LKfPTAfObBr8ToeggpDISjCYdaLKFNmUWjlwwiUXfSy1Gb9V6Qx6Qqkyz5W
        eiOLwCMg1Rs4g/1nw5p2rEOc2o6O26Q=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2057.outbound.protection.outlook.com [104.47.13.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-1-xTsiowqBPIq9eRA1HRLM0A-1;
 Thu, 14 Jan 2021 10:54:40 +0100
X-MC-Unique: xTsiowqBPIq9eRA1HRLM0A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etjIhXPFP/+DT2R/IMsNxaEUtxbSEcit851a8O+IMID5nlR+sBE3L0+G1j7GUF0kuZwfg1E4itv1XTkAjC3OiwGXzFhHRvY5e93CE/Ik/W5BnSQu0JPfoWy6Cu2MkiMzUMgbDGFlFtltGvdwSZ+wM728KbrQLE1sdGbbGAjenogrGuhQ6qH3IK+hBjAQknLVzcBXhYEkvVDLJT7nFcMJwHyWtLrLox0x6+CMnRoYV1Vyy1l69DCxrdapXuUXRg/yhhBLDsW1UmyUhOm2vPherJFXjjv/FLeNgGV+SyKtNQY9gb0JkCXG1HIzqLjJiRwH9TRKutRwJqdk44thKFZUbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfsH9zmb27Cp6M9alTjweF2YknHyXXP5e6uFAYUAYj8=;
 b=GwVToAE0nsRQzAMJfxsn3kC5awlirK9GN4wMK9zQ/cmhwJLHylgELLaRrAI66mOR57RVjr3o5We5Wu1kV2oZ68I2E5g1hV7qRvll9txnhP2yB2zhEVazaqheu1eSictEx0TVEpN2pV/1XVIFwhaZXZvm7nxSpqvI2jVxK+qnEJsYuT+0HYvNpxHhBnqqly6FXOdr23eI1miWqnpjoP0aUJ4VBkTQHV4gynzMPumoEzRJKddnkuwIM7ZVK5bCSszlRbxZx9oGEgYI/hpcV55Apmyx23yzO5u0z58U0g82vtErBbuRWS69+EyIwtKr7I6ZoQWRB5d1PsOfEce8NvF3Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBBPR04MB6156.eurprd04.prod.outlook.com (2603:10a6:10:cd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 14 Jan
 2021 09:54:38 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 09:54:38 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v3 3/3] selftests/bpf: Add verifier test for x64 jit jump padding
Date:   Thu, 14 Jan 2021 17:54:11 +0800
Message-ID: <20210114095411.20903-4-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114095411.20903-1-glin@suse.com>
References: <20210114095411.20903-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.145.171]
X-ClientProxiedBy: AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::28) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.145.171) by AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 09:54:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e368f792-f7bf-4788-899e-08d8b8726826
X-MS-TrafficTypeDiagnostic: DBBPR04MB6156:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6156158466B1215E602E9AFDA9A80@DBBPR04MB6156.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2u0f8mxeHNdOIgaXvqVx1jmfRXCwIIhFgIPrScIuMtZaxul6jQa0q4tA6vNIJZRuBewcL7W2oLAhpTAhczW6nTqz2FhA540sk3XhLo19MEv/5OOtWUgA7Atjfi9N2hZpVwH2DjjKwpMtoF4nScGkhL37GzTQE9zXm/NsZsDw2cRyryQ91r5BLWAGZ9VrDgSl+Bs6b11esF+KTE8rYuotHabazLVTVhjmvdCKYfKNXWiqZ9hfmTluDZK1YD8XWNKiC5aW8PU4hhiZ/ITkVCkonomm3fl/R1je7RgDrrRElILAGbOyznIml4hYYvPEV01TVk22S6DEaJYX8ad2pgWKau1MeFzXKi9nlA3uSmy4al1PY8/sf4lK/E9Yx4j4ZcdM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(376002)(136003)(1076003)(66946007)(186003)(6506007)(5660300002)(86362001)(2906002)(4326008)(66476007)(66556008)(16526019)(2616005)(956004)(6512007)(316002)(52116002)(6486002)(478600001)(54906003)(110136005)(36756003)(8676002)(26005)(107886003)(6666004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ie9JPWxgqhIoacDcBfDUGtbyqmK12rZhFjaki+S6ysYAsSVJEYi729KfOXsR?=
 =?us-ascii?Q?jNA8Tqv8yXxd7/MYIVgxtBGNFN6dba6qkxOUBja1ygxoEyzbGJYm/kW8uIac?=
 =?us-ascii?Q?ri1PsII7HUWDAnF8d17CHKfE92foiQ5Vo1Z2lbe3hYrTvOuDtlHDrPpCXbHy?=
 =?us-ascii?Q?oBnsdrEnN7w9TPPMus7qz5j/Y5TMf+S1UnyTsZxJcS46QS79r38MHcYwojuX?=
 =?us-ascii?Q?jKTofU6QIySxU0WWrQoESspX5QBV9evu7f2ZCksecHLN2t3Qx23W6ZWe1uNN?=
 =?us-ascii?Q?F/FWq+isW1kXdsgzVszki2j36pe84Y8+u62ehbtf6QAyiPfF19oWpnQvtXU0?=
 =?us-ascii?Q?HH4mi48/WO49JPy8wMeR12d8HmCjA896k6MQPf3phfmX4TJzN429zhpOsFG9?=
 =?us-ascii?Q?uhWwVZ8mSPYkhxhFL7879u9H96ZJwCTzEExeMV7etPuDo1f8VevFooCugs9u?=
 =?us-ascii?Q?EoghiS3PBHVGlodCTXr0/MtrTawDTBsYcFfxqYq2WBzzb/A+tqRFnwsHUxqq?=
 =?us-ascii?Q?tGZoRIZldO6mewFydpscQJbOMfucMk8sJ8C+fc4nVEgxvRDlKMz6no2oUIPs?=
 =?us-ascii?Q?K2VNJ03KUDAAC0R9Yk4uxvF8a88UPmdkpHyLwxM1Ak80p6DhiG2AFcTNGwRH?=
 =?us-ascii?Q?W/x3GH7y7SxcCPhlFfrok8RXdZcGVfXJvgilY0B+XU0+K3k6XHah4rYNO95x?=
 =?us-ascii?Q?TnvT2W2Duh9wiFsLcazI+LBzKFE8EC7zdqZY+XI1alklCBQPn7NS9RqaOkqm?=
 =?us-ascii?Q?DAfHaD1/EAcUTSxS9YPYtNkqamfdfByxOs+cPE1I1As5K9loLAt7RvFirL8Y?=
 =?us-ascii?Q?3oQRvo5n0qdMiT4f+1fC3Z7x/QllojGFlFlSsddws05bkh0fHCDTJhHhG6hh?=
 =?us-ascii?Q?xhw+cW/51ZzhFaknpx97z5X1W3YI7NzGrpNqtopsS7QWPEeiCRcjr7jFQVZN?=
 =?us-ascii?Q?K+u4o61k7JEQD67aE2mF1miLZ6ihvWijDzeOpCq96n4KoJz9Icq1/dhvhNMv?=
 =?us-ascii?Q?ZQGY?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 09:54:38.5234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: e368f792-f7bf-4788-899e-08d8b8726826
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GDvqt3/ulJ/fNcdvAOGzJe+3bOg3YyFJPGUvHtcQwMdyrzmW14DEC6Qt5ZZ04rur
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6156
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

