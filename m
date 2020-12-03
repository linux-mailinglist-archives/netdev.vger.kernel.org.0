Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C352CD246
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 10:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbgLCJOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 04:14:21 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:38823 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388543AbgLCJOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 04:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606986790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sN/TeEik8eYpa6sYdwBpY3A9PwXLBv+x3AnTcoCqiWI=;
        b=BDL+IYKOpJlC/8OgoYy9C1ymaM7ufABL3vzh1knj1He0br3pVflhungJKedVTFbB8NUQPA
        +BMbtrONTad+2S0kjC4ogcMkFb4U7MZOm8kwlD/Ob1aysfAPKH+5afGtWzYQtTR532ojhh
        VwKh/oTCdhXYHHx3LgShAXHOfy/v/kk=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2059.outbound.protection.outlook.com [104.47.1.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-8-fj761_fpMlqDRJkXszrEiw-1;
 Thu, 03 Dec 2020 10:13:09 +0100
X-MC-Unique: fj761_fpMlqDRJkXszrEiw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hb6bp68H8PZ0M7ndZxvZ74c90CMJ2fgCiUyk0jDuPSC6hFBTj1ShwfALXCkr90Ojce1S27eLWc6n3DntWuGquGIJQlxTiff4OUd8fpjZ9JHo43AQDQA7ndsJAq1z+HrL5Cmbs1yM7uy4de2/pIPm8f0PMeBS8+fnnkxKQ+kMYGPT+Rp9AnqbW8dsBJfRJl9AUOH3aaBsEGC5iT64/O/VFcRuoz2CZFbZum98rtfQTgwSapoFPwDpaJa5VCk/e/z5W2Q/OGgEsXG/AG+PRLhNa2+HL3tCQtdPu/9jMx1tLsXriG7zrXO9m36OoK8Yc5UqEpMWT+/5uOeOsC3yIJOx7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8n/TSIPWnMw5abqQcYUt/6+8i+FqDfR5e+uMvDr/w4=;
 b=izO7xTS/lrAAdVgLSrGZzhzOci+GC/EGtsI2RrB/m+Jtoo/pnyqjG8NPjih5R2G/PNscCZHOVgyq/x8hxd4RQh6pjnCJyDzCVsQr9fipHkrdzN/wpusKpxC1/jAf9p9X9YXshp8FfT/v3Sf4szprTmr9lXJirR9qtcOHd/WYdOpX7ntWt0CBTz2AXcpfeAJ84ECqvvSddim10qgpcyeHrBEml/zHmSl6LrbeNwmsGMkyF4/aQPtbcBed7HHkWkmBiQtafTYL9h51mTyIXaoo7++dJr7ulWJFc7gFORpmSm+0YsGn9dnFxiat2aI9qdTcgHt3ClLPqxSybboHnL0pCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB8PR04MB5754.eurprd04.prod.outlook.com (2603:10a6:10:aa::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Thu, 3 Dec
 2020 09:13:07 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%7]) with mapi id 15.20.3589.037; Thu, 3 Dec 2020
 09:13:07 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andreas.taschner@suse.com
Subject: [PATCH] bpf, x64: bump the number of passes to 64
Date:   Thu,  3 Dec 2020 17:12:52 +0800
Message-ID: <20201203091252.27604-1-glin@suse.com>
X-Mailer: git-send-email 2.28.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR06CA0088.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::29) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation.suse.de (60.251.47.115) by AM0PR06CA0088.eurprd06.prod.outlook.com (2603:10a6:208:fa::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Thu, 3 Dec 2020 09:13:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d25a4fe2-566e-49a4-a97d-08d8976ba55c
X-MS-TrafficTypeDiagnostic: DB8PR04MB5754:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB5754E81CE958BC315D77CEE8A9F20@DB8PR04MB5754.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQm9VNtOzGXeTqoF9NZna9xktsC2vJ0FhcRGh5r9pSrJ2kggtGv4ETW9+KIhX+5r46i4hHSYxNhhmQk0eU5hg8O9anxHMLYMW6v5dese1nkSwB+uTaV3ERkHClLFVPYolVMpyxzDm4V2j3LjjCDc2XXR+EviTliBM21g0ziBRmhK0H8/50jrzmBIZgKVdTLPpv5u++KWXiUPhfud+FIkoDC+81dOVyQ7Bgkd8g1PWFpz+4c59J+RQF6d3i1a1LwvB4/ehiJVaQjEwx6t1czQab4Ak3yv8N3Wrn7O2tkRzGkVjlsJvmVHtBrlelQXLCcQG1yGmTxJ2XNFnlqr5Lua1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(136003)(366004)(2906002)(66556008)(6506007)(6512007)(186003)(5660300002)(55236004)(6486002)(26005)(956004)(66476007)(316002)(2616005)(1076003)(16526019)(66946007)(52116002)(86362001)(54906003)(107886003)(6666004)(36756003)(83380400001)(8936002)(478600001)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fEzsf7fXtjbJfUKYnB5iGXkNRTEeqzgNWbRI20sR/V3Btoe2quDAlqSRVbMM?=
 =?us-ascii?Q?ITkr/Pv+/jF+ZOiiWMnKPSZXvuFpxol4t+9m6DGgA79+mr0u3z9KYJ5zsPCG?=
 =?us-ascii?Q?mfWtmiVtRcRHOVPikfQQxS7prBoW6i8XZUMVA0bFCq6RSv+wTdv1NzJ+/YlX?=
 =?us-ascii?Q?CbYRUxg/ACdYLYTJzKapJG7e9RSKpp+ZfR2VmTFOR21V+6JcFcl/SXvYGXa6?=
 =?us-ascii?Q?R5t+dLcJKLByajPaO+NAxcP/djliABYQ0xYJlWso/KPshkOIW7HMho7CzQx4?=
 =?us-ascii?Q?96ZrRtOZ1Bu05oGoCFIPpG/24M3C9Yq0CeSI2JB0If1F4fXWOrY5ZEqC6ZDV?=
 =?us-ascii?Q?sgrP4Dgk7pxQ6cUwMVuum0U+9ZGW0Hc5cCC0eM2/S/6DaCaWhhFZm3IAfKIC?=
 =?us-ascii?Q?JyWeCA6vNljG4yjSvKZZMarHEXjz3eLZxxgzBzW0CEMn+SeWSnRHm2cYZO/j?=
 =?us-ascii?Q?X9VBCsCEpgmMN2mZWXQ55cetPY5sX6m76wKuY0PqI2PNlFEHFkCNPjy7BVAg?=
 =?us-ascii?Q?v+AftfOEC2uHk5T+7NDbK/jHc6FdjvXcsucJUfhVH0ZSOROsSnJM+dera0/9?=
 =?us-ascii?Q?EENunIC08sVVnAiXFFKXLvvvRkyit/No4rnDt96v4tsVXYoThOyYKNCmuFQX?=
 =?us-ascii?Q?lmGxD+glI1XwSh3NbGyLxAnFzc5EY3Yi4ROeFwnYD8fRBIG7YOMcMVqGRct4?=
 =?us-ascii?Q?asFmIvS06o0YyW7cq3ClPlSU/ILdWhqnA1sYp2cMYDdkeYmvi//fIV75u7OI?=
 =?us-ascii?Q?AN45L/8jCtpeO3nGh94ucbpshZmbXjF5nnaOr+fBUcFdiE6z+vQxU/3w1pqT?=
 =?us-ascii?Q?RYht+YDyakG76RFDAFbKLB/3yBQVv8u0rYwMAzCUVDj0Ob7VzDrkt2gJHWV9?=
 =?us-ascii?Q?fjAzxfWT31d+Y+jkZRh6b+FFnfFMa7w7Rw1zEraT1chVk9QxP9pBOQgtqwxu?=
 =?us-ascii?Q?LfIOrRLREMweYFGbA6JU/vZL7kBBY4gFzFJoGF5FZSvCLN3lwrdLHlinq/EF?=
 =?us-ascii?Q?AAST?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d25a4fe2-566e-49a4-a97d-08d8976ba55c
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 09:13:06.9249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p71CYKpE+BYUIQ4T6FAgOO12Ecn4irnXpBxtIoiyS/Awa8a3jqaQAi79Z2YkaiG/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5754
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

Since this kind of programs are usually handcrafted rather than
generated by LLVM, those programs tend to be small. To avoid increasing
the complexity of BPF JIT, this commit just bumps the number of passes
to 64 as suggested by Daniel to make it less likely to fail on such cases.

Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 796506dcfc42..43cc80387548 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2042,7 +2042,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog =
*prog)
 	 * may converge on the last pass. In such case do one more
 	 * pass to emit the final image.
 	 */
-	for (pass =3D 0; pass < 20 || image; pass++) {
+	for (pass =3D 0; pass < 64 || image; pass++) {
 		proglen =3D do_jit(prog, addrs, image, oldproglen, &ctx);
 		if (proglen <=3D 0) {
 out_image:
--=20
2.28.0

