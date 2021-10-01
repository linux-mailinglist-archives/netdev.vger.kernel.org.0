Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A2E41EBFD
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353927AbhJALew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:34:52 -0400
Received: from mail-bn8nam12on2134.outbound.protection.outlook.com ([40.107.237.134]:33569
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353920AbhJALeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 07:34:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLMTL7SKzXbGqTGLBRPBBIGq1Uq1VZfJJr/wy4W52+F2tzCeos/8/ZDjvfAG5D+Z1ZsGdUS6UbINW6MXwa8VUaaK6WCiagrIagmLceG7Dzz6TBiX0FRy2gkntIoW9zRPCBvMMeHKVOBI40pOmUtsvHE1tiBlWJC4O2WkkI+vrW1ZKki/3CcH+ulk6FRpLHrwTrcA/0J43NuTdqtoVCUQo36InCEwdR0QScgeaNDl1Mn8H2lRcDed/BlmIgw4kUxcmGzhuSh8UiiHtOaF0NwcmBZ3/pMwMqhA6cuTphdXXtsE+nt9ffVFD/GVlQ481rEdwfZNhcR/Cs5hGyM6HHsyOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzkvAljhlxUs5fUjeumyA5sbGFpShpyMtdakJeFZom0=;
 b=nQJ/X/CIASNnKB1X4pfc1wh3lhUmMrAIykfO/86wnCpIf1oIXAff7kCE18oQCnFN5q3GzXN9FKbDVSGWuKbHKC8KNL5qbagkflw3R/5CYueG8tT43DiVg4a9mHYjR/Ag9KRo72QGsJ9y2zDeuW941w/9ib/IwjO4sK/iDGafLKmbZ0o9iJuKK/HEU7XlsC7+GCMMSxYXMkobGjkpBsgyaOE8Hqx9s9l3uhzXrlD8KP/k478ehh95fwMPu5sWQq3NHIezHvAQOVmPHmiKLejV29Sh2KUv/Ss6PL3GcojjFJPKyhd8HPWJK5+vxLaiyCh15nxNN4rz0TSStexoW3pqxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzkvAljhlxUs5fUjeumyA5sbGFpShpyMtdakJeFZom0=;
 b=kYjx4/SHxVa6HIiQ9tfRo9ONZP3yeHyNRIkKih4Wg1cEtbJGoD42XsxP2ARU6tAZPLcPpT8ufzipcJg/qUky9ZCwqmdWMKBN9uP5456cRTJYSvJpu0MpNyNFCSC9EsDU9EEeNMac7fvY4fZeArlj7BoiFx5szowPFp3QudUBWpw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY3PR13MB4804.namprd13.prod.outlook.com (2603:10b6:a03:355::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7; Fri, 1 Oct
 2021 11:33:05 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e%8]) with mapi id 15.20.4587.007; Fri, 1 Oct 2021
 11:33:05 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v2 1/5] flow_offload: fill flags to action structure
Date:   Fri,  1 Oct 2021 13:32:33 +0200
Message-Id: <20211001113237.14449-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211001113237.14449-1-simon.horman@corigine.com>
References: <20211001113237.14449-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::28) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM8P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 11:33:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 988a0171-be89-4ac6-662b-08d984cf3c5f
X-MS-TrafficTypeDiagnostic: BY3PR13MB4804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY3PR13MB48044F5D26E6A1197C8D1531E8AB9@BY3PR13MB4804.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fOc3azy0KUzv0xaid9kItHCRgm7bpyHzfvHiLh1fjA0l20Frnki5spLSuMdHjzRiAOlb58qot5vYg+G4JCeFOyYXyXb7YH8JIoUOvKyt8wvQ6W3eqi80tTZoXwIyRiCaLnRU0PyAR/VO3qEJ8uBVeozt8efpYRAkL3F0JfCnIYHbsXBUglOotawfcYvoaHSsbDHgzU4rnjSG/37oiHBlNg/VtvuxUrs5yluZOV7DzSXzi0A+r+33WGJuflM9u63VVc20luMXHtW+N3PfI5zcy6dcP/1GOvCFjLXZvwV7QW0SUqAirfvvqaHtuUc3kxtQWwaAPWuKKQ1nWmpJRYRM8UXcwiO9NVe7DQvEnhgPfTwiNHlSFtHTHWOCoaCIZ7p1xSMejKb9K1sIWzjY8TZAsivH7gv/m2UbY/kg6HaZsEISeeZ2YPgTIVTavT1oVE/H6qJhJgnSy/jJq0wHoxtp8sM7FKT0FT+Hs9Nc+n8Np/mFUX9G390FALI1pCtj6ykf/PiT5hCMyS/Rn1HqrgrbqQudygyCpXRKO9ue6Rr0B8TJzSpBZun3qhx5tywnDZCqLS1HFw94gk8ioxEkMu8DLjo3zHslLf7RjhUBqzmLWqNC64Iqe1Sq+JWMB2nnzAK29uFckToJ88sVmCbnwzjpCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(366004)(39830400003)(2616005)(66946007)(86362001)(36756003)(8676002)(508600001)(8936002)(6486002)(54906003)(1076003)(316002)(66476007)(2906002)(107886003)(66556008)(186003)(52116002)(6666004)(4326008)(6916009)(44832011)(5660300002)(6506007)(6512007)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tY8Ubrw3vWrjeSZ4a/vTHlaV8VwYPw1mT+QChzudw1Yj1LS/AoOX3yn+92tP?=
 =?us-ascii?Q?iY2u5UZCg4QhzdCy5BhbcqYRYyOOkLjIMVzs9K9ER3pneEe9MswvL0MBUt2b?=
 =?us-ascii?Q?QacRCq/2Lless+NKXTLswKponSJpjmkTWJiO/4scEGA0Opd+No9Q2N4CRW0W?=
 =?us-ascii?Q?OUc7T8LgIqU1ySOIZhzLT297D4afcAiHqmMw3GUsyHRusS3hNSFmmLGmSaX6?=
 =?us-ascii?Q?D91kKXSvs2AXc+tXn+5IRUjIm1v5yAFrgH6AWWJFkyXCUVCgg+CN1eX2Rv5L?=
 =?us-ascii?Q?A0bQ/kslxmc/SyFK6iVA4285Iz2ty/cGIZ9zTLK+b/29ujyBYHQScz5Q5Ehe?=
 =?us-ascii?Q?lqWzSktZmDFtJ8JzLc/cbnbeqjZ1+a6czk5HjHBDgT7IbEMtkFoblinuymrj?=
 =?us-ascii?Q?2iYY9QhgTBkTFnOXey2QG028Gwfbxzi14XtMGLSVpeFVK+z3e3jO08NF4Mn8?=
 =?us-ascii?Q?nelqSn9Lm9XujkYz4cyPKss5gdj1Z7acjoxQswe+SUyTFy4htobYtLDZHQ+d?=
 =?us-ascii?Q?cMXruUvTEZV4Pyckl6r38YXzbT1VASyrIU3/jltCT0Dwl8Q4+hYMAy2EPPHY?=
 =?us-ascii?Q?JpsAcgp5BSlZ6wFTO/VAfayQEJe6xNi2LUEr6NEI0TvIT6ZcZ6x5lZz40WM5?=
 =?us-ascii?Q?+zAfL/Z4QMAME7JnZFtbb+Omvd3u4l6Scho5cvlP/9EpMRBYaqzGqHDJmL7K?=
 =?us-ascii?Q?YrADZTN7dGh7l7WSxd4JZxZ3wLJjjbAdcuayo447VXIEMWT5QIBgUTxJKaIS?=
 =?us-ascii?Q?KNvxD+ERDCNLALSjvB0HS1KnN2f8uskH7sgxq0RlLEL12bLF2dDs5cRTT2G6?=
 =?us-ascii?Q?/KjQfMAbH9F5b5M+uShMTH+6KmkdEmcWGSZBtgnvNbAJVqMWNdpUZhvuLaSV?=
 =?us-ascii?Q?k1CSERwpnezYqW7hhGUjLHDTDr18Xuq4MBw4iywi35GdlU5EMPsVtS1vc5V3?=
 =?us-ascii?Q?dx3fK0QqfhJDIAFhvKem7EWJauz7RKs5QLNk8EWWyBhMpDqgDMF1zz5DKyz4?=
 =?us-ascii?Q?ASgVgyoECnC8WPaRKpBWKsmkHu4I/fPV1VdV39P7Wz2JZlsPvbpBQ3SUh06Y?=
 =?us-ascii?Q?UyTVR12iGwUSu8ffoP9lKhk9x6eDSKtVbHDnq9qby3W7TK8eiDIFeeW7TG3A?=
 =?us-ascii?Q?3IqSNHPV2qorBcx3+3UuEod4jlDckJVwAGrPA/K8ywrUPnLvr6kaWEOq3FvU?=
 =?us-ascii?Q?J5AAHTsNCl3+LmmktE9nKdmZIw5N3ih56/jIHpyB0cvJvoNwTZ/blk9+NDqI?=
 =?us-ascii?Q?qVqUF3FrrUJIH7+R1xCFjS4m5l/d4CJ4XnTRIw5S86qbNnoj0Px3d2NR5vT7?=
 =?us-ascii?Q?j8sEMZqt3hH1vCapdasJUz1PUwDImiqT9fXZy/ttVV/0FqDbViw6qDbTTgk+?=
 =?us-ascii?Q?ozV3FZEaqPk7Oq8TdermJ/zMUk2D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 988a0171-be89-4ac6-662b-08d984cf3c5f
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 11:33:05.6692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcNsbL9UqpQYASzxRbnb6yglCULnouzr6eYRAcjmqVWXSoybdoHI9G7j5uV4hAri/D/H0NmqEd91xL/XG3myPKG5N4l0bnGs5EgmX8p7TDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4804
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
index 5c36013339e1..2a05bad56ef3 100644
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
index 7064a365a1a9..ec987ec75807 100644
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
index e4529b428cf4..4eb8751e1ad7 100644
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
index 832157a840fc..d95addd8dec5 100644
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
index 230501eb9e06..ab4ae24ab886 100644
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
index cbbe1861d3a2..788527154025 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -128,7 +128,7 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_simp_ops, bind, false, 0);
+				     &act_simp_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 605418538347..1bb0266e62c2 100644
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
index ecb9ee666095..ee9cc0abf9e1 100644
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

