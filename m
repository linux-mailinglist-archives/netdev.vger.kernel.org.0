Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297B0455C4F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhKRNLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:23 -0500
Received: from mail-dm6nam12on2106.outbound.protection.outlook.com ([40.107.243.106]:52384
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229674AbhKRNLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxHAE4S0wCyQjl7rB3HtkE+/4gqBnDFmtPUbeCr6/tXe6TO76dAuE7Ys05oHYpIsDvsNdlEFcrngdOmJglvTRruJwKzTDMxlMi/ZOYAnZfzj+2X8kZKRnHn15TCwnU6Ywk58ig2uLYKkqSWV2hsIMAIfP8HWqDuJcXHiAgKDhVsKL8ttPcgCuWe62Mhc2S5NkUFAqnSUjHo7kc/arf6vrwknXMqlHqIDLYQ4rP8lerSeFpxe0QpTgVkHznd5RZyNIwS9hA0DjxZQYeByxhJuewTP1me2vsnMv28xEWffj4Xpx2+XobeQpWxR0BwQ2hxjfahWSD+8Xo63v9CXIGXvTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRp1HCPVPqPJU3OHFquMchwhifHi9LhY7LZW7gk03f4=;
 b=SN86wcMTwXleQFYy6RsxgUHQShK+9WSEo0+gNF89zZ/Iffv3hQqw3iaabd6kqEDZEna3AZphZ+9N0DHhIke6BQxrZZncJ+o+h+hdfK/+y5uEi+CykSBM2SE9FWT4hEhdV4YB/YUBWJy1tely34fvWwrwC4h5Yu6NQX/fJ/GMlouzronDljE63LcrfL87I9Lak4+RH2R0jQZhA7tgIdBqaYx7Kn13ejjyDykc9R2TaUB8DmWRg8F4k0e7OIil/UWKRbsXDrxSimm2xatu97gevvN4tAp8Qr802fbXJ4vpdG8wda+ic4rMNWbraJpfoVXL+6R4JgSPOYynpwyoVSXHEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRp1HCPVPqPJU3OHFquMchwhifHi9LhY7LZW7gk03f4=;
 b=rPprk3IPAEr3WBuxkSGiPQ0sbZhgzdxzEAXU12EzCwoqV7/l2ws1oS0C+py3sskXulVsjo/4Ut6UfRXi9csCp3fI5gBdfaL86YhYzktkg6d3FqG4hpNRCadty2SbDvNVyH2wq8ooEkFUejayZUiYygGoQtVZByCeQlMxy/5t8YE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5422.namprd13.prod.outlook.com (2603:10b6:510:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.10; Thu, 18 Nov
 2021 13:08:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:20 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: [PATCH v4 01/10] flow_offload: fill flags to action structure
Date:   Thu, 18 Nov 2021 14:07:56 +0100
Message-Id: <20211118130805.23897-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd74c7ff-8fab-4778-8465-08d9aa947e15
X-MS-TrafficTypeDiagnostic: PH0PR13MB5422:
X-Microsoft-Antispam-PRVS: <PH0PR13MB542257824178DFA443DEBC16E89B9@PH0PR13MB5422.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FvoWj+IC4zPtQ5Th3BArXmkqJz3xOSQ075ifMw/ZiolX6ZDzXPmvQUZ4wn/OHds7VIVmV9yGM/FlEsqpycZ1OFLbF63J+accjnZ9eh5LkndM83dhpqVYQnU8pqGoawhJZAB8m8FMXBLlYoaQTu6SgHAr4+WbeagIM7bYu3WzEB3viA1D57kRpzbOdEhq7wy9eQeYmL5g5dYPCEbJ7HK7gAwkMzYFa2i0PDcOLzmzhY08UFB/ktLRRgXJHURVbfbfP6bd+q+nngQmvyMCh0OZHzVp12w4agKjwumdlxOw6T5oLk9q/m5qIi23Fvq52AfzWpDAw3p2V/d38vGPD6Wwev4nzEbzfY3L+2ejT/6Mje5O1GU/AIHQ9koIVcntP78FWNX1y1l2vR6rx2Bjrpg+7U+SWT+z8LBOq3XCOgW20h7KKxZWSWQ81y5dLzKrPfZ4a/qGB6o1snGHjgWuBmS0xzUCn1uA7/pMBi53qNRTFu519d4PVOl8yQsVezgmjxySgMOXS925uG81t2SukfLYRXDj7g7QvkAGOzaZla25hwL7n2ke4s+7K+yzRURVetw7W/EgnWNjDUL+rk9ippS9Uq+iITdrew+qXkBFUHSS408QJBMVQRAULmpxbx3aSsYjsjs/4hl9r/VyJg5uD6yOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(136003)(376002)(346002)(6486002)(2906002)(54906003)(6666004)(316002)(86362001)(52116002)(6506007)(1076003)(38100700002)(186003)(6916009)(107886003)(2616005)(44832011)(5660300002)(4326008)(8676002)(508600001)(66946007)(8936002)(36756003)(83380400001)(6512007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e4iaHZlQbGoe90ZoHvIE8grgBxLeKYSIJctTdP2dH5Sqly86+GKXBc/YvEoF?=
 =?us-ascii?Q?pKJIdJ8oNnuDixHwy2/Iv4GyxWqhhPoi8HLQViJRFwzbAX46TloC6NZA3wzO?=
 =?us-ascii?Q?4ioKTS6vsWHSGTklGusyE+LUj52Z8xXgUrk1WBdbQYCGs6+NUhiWLQ0mqtMK?=
 =?us-ascii?Q?3cchS7g6GMWxejJqUSjEynCuHDS1f2eZaYwrWEbAwoBgCBZm6cACPxO0krJk?=
 =?us-ascii?Q?WrA8J21Jk/D2ng17WAqGlcQaYcdQ+n2dN+EgmQUglwrOQsORQ8HhVEXRg7yd?=
 =?us-ascii?Q?2llpYkOr18KyJovukO5vLhGU5bxNBkiLcFZt4IQAUMWfJUiUhoQgfp+8XzuR?=
 =?us-ascii?Q?pND1QJpzfJuGnrmIi817zQee3DmoCSEEgmtNTM6Gk03OCynMM6AuvLtfXxDX?=
 =?us-ascii?Q?aiBzergHuE+5gjdyGqytz16YryXIcdeBgiBxmQzaxGl64oakZo6oH5+sbaM5?=
 =?us-ascii?Q?nRVinFjFWfD8LOEtH/SVAmEVpHBiQ3G6SPIqbGxrttT0XreY7UQBgKOGYa9q?=
 =?us-ascii?Q?+2VM1sLRCGDmgxYVOXE/1qrq28ToiIO1Wna4tDMNY8SvTSZl4zVPlGWV/EBZ?=
 =?us-ascii?Q?3goIpfUD5W0pwlYoZkx5grCFll/AVxijMjg6MhIbCSGgGQIwgrVG1/Z0W2yF?=
 =?us-ascii?Q?exs2aJA67fYs0LWnAUaM4J0NPqqjLhPI+nOwHfJdrbvBsYAgYr9pCnt/OLVh?=
 =?us-ascii?Q?H5+84zVX/uhZ/Emc1ITtosdQ223LCKzv7fYJeb+QJ9guwTY84q7M4cLzSa1W?=
 =?us-ascii?Q?v6BVSU9hR75EHQY00q2kaBKJuAp87WPodXnh+fle7p2EGuZDR7aL02B8Tn9j?=
 =?us-ascii?Q?MhGrrlXo+H91CQqg04ZB7cf7xgiaKL19aK13+NY2/CLgoP5dHPCDXZeO8ns+?=
 =?us-ascii?Q?h8q/RMaQhVMTtPGSBjbr3vB2fH2tlawpQQYKg+JTu0o6pE9yEHAZXGYYl85Y?=
 =?us-ascii?Q?4bnsTr0KMMePFQZFd0bXtsECN1y4ge4Hu6enGABWOCs5UR7PrGxwEKHB0Jag?=
 =?us-ascii?Q?DGAMKfxViB28C90vnN0rtbUtZaVd3qFHpaxoQktLHWPZpO6xc1ZbTuf/lsyL?=
 =?us-ascii?Q?KgI5u8NzDzhgiX+NvrO1S7Hs3SFE9Ir3q/keb4rd51ufQaVHeWtkb5uBPFm3?=
 =?us-ascii?Q?1LzytjifIvB7941UU4n3hBNKHA3rxL4qnKLrb5QlrtC64uEGyF/xuvFtm3Vz?=
 =?us-ascii?Q?8SaZyPTNmXo406wLOrXUmJ1yJ7vqCs3Gb+gkD3FDH+3kYC2yAaGHM4y5Pw+x?=
 =?us-ascii?Q?/9nuiBLPU/3F5XufD0UgbE+mitpCZgfNnnJwkkVfTX09akaztsc6TmpNiKwJ?=
 =?us-ascii?Q?V8h3fKSphw3j4XVH6bX3rpL+uD00NzwChD6Nj9gEVO4ciL1qitJEwBdk/Pu0?=
 =?us-ascii?Q?kMG5K5O4hbBsUKGDIIYPq2NqEHNhUWrTzrJ+CKsoEVNkRp3SSPTHeIGpoB4X?=
 =?us-ascii?Q?BavgVgL9ekRm9AcgzaEGkk2SDCWlmpCKoajOnEwF26oRiejQ5H70U2dn9xtH?=
 =?us-ascii?Q?ZhH6VRqOq1drlaQz9GV3TJE0WFkINiP6NQHlAQcJaQigvu22HoH6W5tiguxn?=
 =?us-ascii?Q?5LIvqz9taoQxLZow84hsR4+62f0fGIH2+gg7e+mhZ9D1lJ1SBZXcHvfi8KXt?=
 =?us-ascii?Q?E3WWPvBqxmw5bRduT7AU+9ZU8HNf6dF8pLGkyCYiVAUr4psAXLj74fSE19mM?=
 =?us-ascii?Q?mKddMKl1DLaEwychSApwqan8+hlY29ZiJIb8E0KPUTalVXoi9bc9rXctg19o?=
 =?us-ascii?Q?14TtxVZUClkGgbW3I4KL+KHHiVjVigg=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd74c7ff-8fab-4778-8465-08d9aa947e15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:19.8479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhs9yZ6UjmAjo7VK/8qEr7MbNPiexUdXYxwWOp8y1wNPfNGFtcpjnphs+jy//mkZhckuHssFSzk2aBwdF6WFrTmFBdrrkUZcJeLRCq4z2I4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5422
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Fill flags to action structure to allow user control if
the action should be offloaded to hardware or not.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/act_bpf.c      | 2 +-
 net/sched/act_connmark.c | 2 +-
 net/sched/act_ctinfo.c   | 2 +-
 net/sched/act_gate.c     | 2 +-
 net/sched/act_ife.c      | 2 +-
 net/sched/act_ipt.c      | 2 +-
 net/sched/act_mpls.c     | 2 +-
 net/sched/act_nat.c      | 2 +-
 net/sched/act_pedit.c    | 2 +-
 net/sched/act_police.c   | 2 +-
 net/sched/act_sample.c   | 2 +-
 net/sched/act_simple.c   | 2 +-
 net/sched/act_skbedit.c  | 2 +-
 net/sched/act_skbmod.c   | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index f2bf896331a5..a77d8908e737 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -305,7 +305,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, act, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, act,
-				     &act_bpf_ops, bind, true, 0);
+				     &act_bpf_ops, bind, true, flags);
 		if (ret < 0) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 94e78ac7a748..09e2aafc8943 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -124,7 +124,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_connmark_ops, bind, false, 0);
+				     &act_connmark_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 549374a2d008..0281e45987a4 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -212,7 +212,7 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false, 0);
+				     &act_ctinfo_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 7df72a4197a3..ac985c53ebaf 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -357,7 +357,7 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_gate_ops, bind, false, 0);
+				     &act_gate_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index b757f90a2d58..41ba55e60b1b 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -553,7 +553,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, &act_ife_ops,
-				     bind, true, 0);
+				     bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			kfree(p);
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 265b1443e252..2f3d507c24a1 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -145,7 +145,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, ops, bind,
-				     false, 0);
+				     false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 8faa4c58305e..2b30dc562743 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -248,7 +248,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mpls_ops, bind, true, 0);
+				     &act_mpls_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 7dd6b586ba7f..2a39b3729e84 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -61,7 +61,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_nat_ops, bind, false, 0);
+				     &act_nat_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c6c862c459cc..cd3b8aad3192 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -189,7 +189,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_pedit_ops, bind, false, 0);
+				     &act_pedit_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			goto out_free;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 9e77ba8401e5..c13a6245dfba 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -90,7 +90,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, NULL, a,
-				     &act_police_ops, bind, true, 0);
+				     &act_police_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index ce859b0e0deb..91a7a93d5f6a 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -70,7 +70,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_sample_ops, bind, true, 0);
+				     &act_sample_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index e617ab4505ca..8c1d60bde93e 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -129,7 +129,7 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_simp_ops, bind, false, 0);
+				     &act_simp_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index d30ecbfc8f84..cb2d10d3dcc0 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -176,7 +176,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbedit_ops, bind, true, 0);
+				     &act_skbedit_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 9b6b52c5e24e..2083612d8780 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -168,7 +168,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbmod_ops, bind, true, 0);
+				     &act_skbmod_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.20.1

