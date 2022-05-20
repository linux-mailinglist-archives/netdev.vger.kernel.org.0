Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24E552EAFB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348631AbiETLi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 07:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348638AbiETLiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 07:38:54 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B26015A778
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 04:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653046693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nUgKGJ3O0a2AcI0M7Li2xW8xlIFt0nekuPR5p7Jv008=;
        b=bmPyAsZnsUDAWhgLjtJwnZ4YhTUsEttz45AhWOCU6Nfqvt9V8WCX8ypi0hAvgFQaHfCsim
        Xg9lAlHcgFGVek9SHNOp+fDDDNH3uSMLKjHsAmQyyCMzFbdy71yw49fd4w6TbkDA3arwol
        Om8ivXBtsaFUk/+fCdwUhk2wcLS18Fc=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-20-xSRJOZfWPQaJ_cWg9diAQw-1; Fri, 20 May 2022 13:38:09 +0200
X-MC-Unique: xSRJOZfWPQaJ_cWg9diAQw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VM5Xoy+UaQPnNlVGzIO4679rwjwD7qjZRqZH3LOCdyrSFvWOlC9A0cDEwc2ehm8SYccyyLFDNF2x6irS6JiYwCsC5O64/wYNMJk8ai32VA2GAC8Z0kDUdt0Gln/7jSpXeJRIrkt+U1E9EJJD9KN2c5pdp2pU66QJ7xLTYQs3wgDSIz78Us3eHy2alDoi+K6XrF/e6OychbwK1qIzuiUUfWPscTOwggonoXlZ8H8+lN9Mpua+YJLIvdcBYcXZ5YIsxbf/WHn4h4T3Vo5xhX8Af2KwiUTCGfc7RHfsdIJnQcxt5KHGiQc6DREJo0/dppeqbo8Oh1VdIqnWz+ag+8ML6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xmzjpod21e6Cbz4kt7krDw3PSKbJIqoBQQasfgfdzH0=;
 b=FLnsmrU3b/QBBbmHZ3FUouMr5nacQm7ZhrTFLo1L+8VsfrBpnmLVoAksdVrpZ/PPkIvlZpnGnBzxQbwnQDrOKGod2PipBuqTKOJR3aEIi3M8hDNZjj3LHsHkbmAX9xIo82L8TwhFVzAvq1YURknLETBu/UbLkCgrT7V2ll5GEMq6Ht4LKB+up8VNcFAvCrGWx4XR25S7rEI8Dknsg9uMLYl/wFBQTEISqpcaTd/t+sAvSVRTCBHD8B5FogbOvsCgvIglk/Osxln+cbpdyDlbSJ8fUbLXpmMMCDRUab7DhYAenA+8H/n88AePc5gLOH/QlZzl0+9U4yMZeSUFtUjdVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 11:38:06 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa%5]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 11:38:06 +0000
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH bpf-next 4/4] selftests/bpf: add reason of rejection in ld_imm64
Date:   Fri, 20 May 2022 19:37:28 +0800
Message-ID: <20220520113728.12708-5-shung-hsi.yu@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220520113728.12708-1-shung-hsi.yu@suse.com>
References: <20220520113728.12708-1-shung-hsi.yu@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0502CA0010.eurprd05.prod.outlook.com
 (2603:10a6:203:91::20) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1f51714-7f93-4ca1-63d0-08da3a5534e1
X-MS-TrafficTypeDiagnostic: VI1PR04MB6014:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6014E63194B8ED142E1B5580BFD39@VI1PR04MB6014.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3HDc22kyX/23JRo+VeW6sX8hz01WC2XlEhzFUZ5+uTPAVUuR7b3l/hvrqTCAQLALlezN9/CDan9eh8qCvZh/CUMOqCwkxm3784vcvMl1aJgNAgdAfd6KmRBiOUXtqAePr+ZoG5ohLTuMlqOBgVW2yreGcLODa19paKMwC0Q20oawS8MwYd/COuGTIOSSDscMPnKzpApfqnPmg5RDBGZcfd0blCwvgi++vnzgXONiNnHsa9x7tbrC67Bhzm+YwCQLGHlvtqLZSvivsNiw5waXS96sLTKcoNvTlx1f5BTuL0JmU8vNoQpprD5h+CNgq1mACPQPCJC3E3ktBl4tnxM0pT4igjRfu11Fe/Fj/uCoeejrgq2aj1xEQ/M+0kOaPKv0uwweJSjGjl87uINc9jq7WeWchDannPXbJW5+N3BGlZ9n9tHAoZOtu0NbNUJAZJBywo9LSPQv2+q250OZKUjqW0Wj1E41qZ6GB3JxSYvxOAP3tIMjtiSkTtlNsInRpb/wzGX0r2RhzVaUu5fuRGsP7uEjDouu0zoY9RfcoYs5T5jIQoz+iQ5Svcrv8OKoz412Wl0jKFs6umHYJoF8/3HNTGF6Ozh0adXfIjuCos/1XMt5/yodOw87XlAYK1x9tJOG+4/YEPc9lilTXBoxkcYkbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(5660300002)(38100700002)(36756003)(66476007)(8936002)(66556008)(66946007)(7416002)(8676002)(86362001)(4326008)(186003)(6486002)(83380400001)(1076003)(2616005)(26005)(2906002)(316002)(54906003)(6512007)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?13iNxCmyS4ttz4BJKKZxII+Y2qPXOjbPuJNuC90e5HK44O3sUPCnURwO+kkX?=
 =?us-ascii?Q?dCj8dU3qLFoDOiiL62zpIfHrWHIKWsJqB3fzS2mEiJy37DRTVeKCwCYzobob?=
 =?us-ascii?Q?pH4PnYNSITWXAq/hqqW3K/Mag8vw5RCZlHVlBdMgX/rPeY3W/qx/PWSnYspp?=
 =?us-ascii?Q?qeQJiei6N5g4wejGvTdBTb3rasZ9f8k5+5OsgqnDaxFBhCmYZO/ldagTPWFE?=
 =?us-ascii?Q?cqJzttld3EFFQJKXO/oLis/I/5zvoNM0tQK/G/n2E39gKXvJ9k0d0nJA4r32?=
 =?us-ascii?Q?+EPvc16NaR05c/J1M8OxlC+KIgc9JYs0qxeLumExww8nz/LAWehjcF8bgczf?=
 =?us-ascii?Q?/G7oAQ4VSNYhSZe2YK6nuIU3yf5BoJjEWQNAnr3omY0VR8ycYIf8d+e0oagw?=
 =?us-ascii?Q?ZN0bCGTg2ohAiAaO/ZTEOXYirTG8TPdYr6NptbohWNSohP9Q08ergwNZc/pN?=
 =?us-ascii?Q?hU9aTI3FjLSvsWhLt4JY8zAKtQhMKAc+7wB3AINritTb1cI9uEhU6wyCI37b?=
 =?us-ascii?Q?9u2SY9OD1Sc7Yu/Y8gl1Bo/5JZMkTnN1jkmoq1uqF1G991/62ok+Vj8qd8JE?=
 =?us-ascii?Q?uBywx0I7+kTUm+z5XPSpqLAbX1ffhDhhf2Hq58mqWhlrhGkumwkdWdhlI1GR?=
 =?us-ascii?Q?bRiATstxJVURk/wcH8cgUA0FMTute0KZ9Izu63gS6xF4Lw63IQfy8pJ6kKi5?=
 =?us-ascii?Q?ofTz7jtA6oyKmlaLIrZa9FRwamjR0Iz49el506FMjdUddOFqYZh2rku5+0Dm?=
 =?us-ascii?Q?TkWHXNvlzMTYaDmH4YXVZqpHLn+JzhZS4IyRJp4zIPf6wAzTTova78phWkqH?=
 =?us-ascii?Q?zXH6DD2mpeaS5dQqCzw8PKOVC+xq6m95TtBfIklEY4nvhyLBpEjUIxtCPfCb?=
 =?us-ascii?Q?HdKICcbpC3om7WY4NrjMJIGsHFAbmobGNOYpF0cxdgRH/CX9XqvHg2EyhNMz?=
 =?us-ascii?Q?+tIBJ5YWUvW/N/usbR8Zte4q3kmCmvtRKfoxeoYdWCdN3LDrg/4kyK1pvywn?=
 =?us-ascii?Q?sn40ey/uuUEDC9ukFq3++2Fg+uSDoZSH18m2swoovwHeFzWgP0bARF+cztVU?=
 =?us-ascii?Q?gAISSAnX28+zQQE9KvCj/PGpLCdC4Lp0WR9YTfh4Mrz7+ls0FVkQt1BxjNkW?=
 =?us-ascii?Q?9ngcDEQ3Hs9PSmsm64TbK9UIsgTIsSexEJ6u2okcX9yEP80KXESJP6jdyo00?=
 =?us-ascii?Q?HV2qYbNHwYxYkRTffWwTHyYDgHL4K5QJxIAZMCAqAvE1aw+GlhEVS6+9Kyq1?=
 =?us-ascii?Q?GAg54gNbZPsQXuKOg5yznrjhiLUQCgJon9jAycYb5K9++arJMSyvPC4tycpc?=
 =?us-ascii?Q?qMy90MueELrZ8s7rCZ3/6juWmDN9bn+d6NLraPb90QLlH8vkU6CWyRyQ5KXu?=
 =?us-ascii?Q?zXDiG8pTCSe9bomb8OxtPwv5HUFkm6S3ImxVE1en0NhjKQDXbRnZrGsEN9le?=
 =?us-ascii?Q?0Lz5HiJXwABnW5y9YNpay6UyuWQsK3NQizXWzFx2P2V7ShETa2tP6Tf5haiZ?=
 =?us-ascii?Q?v/v2AT56yoOVUEG3ZcxLUFpjv8RwtjuZX9GDZY6w7LTXlye7oyVXqWej+SOh?=
 =?us-ascii?Q?4W9K2ucQBUBJadAIhpO4zUYJ2nMm2c4G4uNAZpZnMZBkI2chfUQdfBSaCx/f?=
 =?us-ascii?Q?yI4aQQktzAXgb9JcjV9+Rfvrr+tsmZY8x3/k1Xekdb0yZVRoCSb8xnDhB//Y?=
 =?us-ascii?Q?NqAcHbEKu/Zbcsu7+mQBBz11Le84SfRU1WT4X5QgMe01Q+Cnh55sWHRMQ13Z?=
 =?us-ascii?Q?SaihelwNWA=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f51714-7f93-4ca1-63d0-08da3a5534e1
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 11:38:06.1101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6aHrWjv2aPSAzCmP6OGJK2/r52hPVIny4FIJNq56hKMhFzPpJtN9uDtE51+wl93kC2Eah1eWcV7/plD5PWQpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It may not be immediately clear why that ld_imm64 test cases are
rejected, especially for test1 and test2 where JMP to the 2nd
instruction of BPF_LD_IMM64 is performed.

Add brief explaination of why each test case in verifier/ld_imm64.c
should be rejected.

Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
---
 .../testing/selftests/bpf/verifier/ld_imm64.c | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testin=
g/selftests/bpf/verifier/ld_imm64.c
index f9297900cea6..021312641aaf 100644
--- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
+++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
@@ -1,5 +1,6 @@
+/* Note: BPF_LD_IMM64 is composed of two instructions of class BPF_LD */
 {
-	"test1 ld_imm64",
+	"test1 ld_imm64: reject JMP to 2nd instruction of BPF_LD_IMM64",
 	.insns =3D {
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 1),
 	BPF_LD_IMM64(BPF_REG_0, 0),
@@ -14,7 +15,7 @@
 	.result =3D REJECT,
 },
 {
-	"test2 ld_imm64",
+	"test2 ld_imm64: reject JMP to 2nd instruction of BPF_LD_IMM64",
 	.insns =3D {
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 1),
 	BPF_LD_IMM64(BPF_REG_0, 0),
@@ -28,7 +29,7 @@
 	.result =3D REJECT,
 },
 {
-	"test3 ld_imm64",
+	"test3 ld_imm64: reject incomplete BPF_LD_IMM64 instruction",
 	.insns =3D {
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 1),
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
@@ -42,7 +43,7 @@
 	.result =3D REJECT,
 },
 {
-	"test4 ld_imm64",
+	"test4 ld_imm64: reject incomplete BPF_LD_IMM64 instruction",
 	.insns =3D {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
 	BPF_EXIT_INSN(),
@@ -70,7 +71,7 @@
 	.retval =3D 1,
 },
 {
-	"test8 ld_imm64",
+	"test8 ld_imm64: reject 1st off!=3D0",
 	.insns =3D {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 1, 1),
 	BPF_RAW_INSN(0, 0, 0, 0, 1),
@@ -80,7 +81,7 @@
 	.result =3D REJECT,
 },
 {
-	"test9 ld_imm64",
+	"test9 ld_imm64: reject 2nd off!=3D0",
 	.insns =3D {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
 	BPF_RAW_INSN(0, 0, 0, 1, 1),
@@ -90,7 +91,7 @@
 	.result =3D REJECT,
 },
 {
-	"test10 ld_imm64",
+	"test10 ld_imm64: reject 2nd dst_reg!=3D0",
 	.insns =3D {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
 	BPF_RAW_INSN(0, BPF_REG_1, 0, 0, 1),
@@ -100,7 +101,7 @@
 	.result =3D REJECT,
 },
 {
-	"test11 ld_imm64",
+	"test11 ld_imm64: reject 2nd src_reg!=3D0",
 	.insns =3D {
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
 	BPF_RAW_INSN(0, 0, BPF_REG_1, 0, 1),
@@ -113,6 +114,7 @@
 	"test12 ld_imm64",
 	.insns =3D {
 	BPF_MOV64_IMM(BPF_REG_1, 0),
+	/* BPF_REG_1 is interpreted as BPF_PSEUDO_MAP_FD */
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, BPF_REG_1, 0, 1),
 	BPF_RAW_INSN(0, 0, 0, 0, 0),
 	BPF_EXIT_INSN(),
@@ -121,7 +123,7 @@
 	.result =3D REJECT,
 },
 {
-	"test13 ld_imm64",
+	"test13 ld_imm64: 2nd src_reg!=3D0",
 	.insns =3D {
 	BPF_MOV64_IMM(BPF_REG_1, 0),
 	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, BPF_REG_1, 0, 1),
--=20
2.36.1

