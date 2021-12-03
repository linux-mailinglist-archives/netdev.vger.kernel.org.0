Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B1846773F
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbhLCM22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:28 -0500
Received: from mail-bn8nam12on2112.outbound.protection.outlook.com ([40.107.237.112]:29079
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233378AbhLCM21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lbc13lNBI9uqTu3p5nK6FB7x89zdydMap0xF2/QZk0Cpu++ImMbJlZqw2BHmKPrN0VbIvG7L4BvmzyVO2BKqO0/o95tuSw75z8KAukY14Olx1lasw/spe9afy/u1cX5G2QBE1Po2PEKTNh0RX7AH3ToT5//hW/y5WjEOw6xRQ4uyNFd84xHJUjicSFBT9QMdLuRhnEQm2OlsnNc/s20QhnqMLtwOKpnSm39nuXgmS4XDh9gF4Chz+40w9ZsbjLq3Fjg+GLxMr6kDj45wJRcyGZC5w0dhbcjydVKR2y7wyuH6vdPfJeH3yVrwerfUX5zkthBD3VHqIaj2gvmNXKPmtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRp1HCPVPqPJU3OHFquMchwhifHi9LhY7LZW7gk03f4=;
 b=nY38to/AwRDUYwZmz7i2aTpZHbmhAk/8SJCx0+6767a9h99W4PIRmDKhM5qUKPIE9zAMUIm3yOm+bue/4c+W6fzjWmdWhqJ0IC7tX/wcP9baWesHRrfIlJI5aCvJstctGOOuvA8Pz/9aDeDNVNSp995j9DlA7rh5JyjUGe9lcN5PBfgzHt4U1eS+CLkQv3LIEJboaqHiUy7lRjnBIsEgKoe299hL3QDT5JXir6neO4si6x6jsvbX9kkjnhJ6MCSaDkVUxHk55H8t6FDT0MjiMdWWF8HI3+7EhFdiwIpE7F2hP9ukFrp6BH1xpXUCHGfb635XDBO2H7lIty2LD5pwoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRp1HCPVPqPJU3OHFquMchwhifHi9LhY7LZW7gk03f4=;
 b=Zfnw7G7g93iL9kOB1oC/fbix+0vxFPWb6Gi/wTLaO22WkJqjO3s/eKEv7MnI4yq3iWjWhEGOE0bi/BLTeoRdVmA9DahYidx7mzUW44Cm4U2/i0kkD2o1DP8kMpc2kRe9yvljzoM2iKWGxJmss1W11TDEzP1E3UQUlekCiv3CDro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5423.namprd13.prod.outlook.com (2603:10b6:510:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7; Fri, 3 Dec
 2021 12:25:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:01 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 01/12] flow_offload: fill flags to action structure
Date:   Fri,  3 Dec 2021 13:24:33 +0100
Message-Id: <20211203122444.11756-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:24:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8b6a9cd-d868-4090-48ab-08d9b657edc1
X-MS-TrafficTypeDiagnostic: PH0PR13MB5423:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5423FC2469623C085AA75FE1E86A9@PH0PR13MB5423.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ZR7FdKVMckJ+5zcpP7Xg+t4Yf+v5yjSYruPy1m5ddUKW1cNIpV0lcgOvqbLWZtOrjymHd4q4eRaz++aHetU6IOn4H4Pcd3alV5x7GE9htXhFPTJIRiDb+GbE5fobGLkPBQbcJSvjbUF689Za9DDpbszGeukvvx35KuylIwACoRhGgLbztfy0k7domXuGiKEu0iuyysgl5HtXlS8RlJlAKmLnV0qvO+j17SYbF1LXgj2fkMDIUCtZSO+YNAcfKT9/fFoxuPW3ym4WQO6ot5QoeSAD53EoSxJHs0VwgRyKhYzdL39/n47871cawABUev77Dc4b4lWOCMXvnvHT3J3PJWzGjFzMJJlXArCkJ+N7yXtUK4l6go/CZ/uWCTtUSVWOgmSjMMoswMyaazWsXxSeUNRzEuX8UNmYlcvSPZkZf+F4LfwZof01kqKdLmRkkaZiIWn/GTJU8QyM6+rrB16cCsqPvLrKpJ08owlxacGmVeYPAlP3CUkYsplo4M+SQBiNl4I8n4juduh4/pcDFWRxg7LLi+fRM3fADrXNv6fFCEmTkb68X2DT/sMMko8Re6UIpNnY8u0W6iw06LCtPSHA5keosyLZOnfr/iWByjUO7yCZZmImbcmhLSi0rRbueyuDqxg55STRxcnEHHcBlgiCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39830400003)(396003)(136003)(6666004)(8936002)(38100700002)(2616005)(6506007)(4326008)(66946007)(66556008)(8676002)(36756003)(186003)(316002)(1076003)(44832011)(6486002)(508600001)(66476007)(5660300002)(107886003)(54906003)(52116002)(86362001)(83380400001)(6916009)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Jj+34IeTPT5pU0GcXj+vrv0GFKNb0NKaY1+ylp0iD2RZKbH4MWUemvnbcaM?=
 =?us-ascii?Q?Uo199eU3mxpEgC9K0VTILn4HHC9npkFvdzEOiMB0OyDambHTy4nnaouc9Rd4?=
 =?us-ascii?Q?i9vzWl/BLuIlYcRNsmUf+7DNGWcyu9rdcTVJOQBEmAGr/pBpa8+1sYq+cldw?=
 =?us-ascii?Q?PrX2EOFhW7ih5v/g0LAcOyNUTMQRBAkTAtig6aF3KElsTvNRmR/+j+nsOIyf?=
 =?us-ascii?Q?Eq7hmQCdRP1le10oBKg238euSSbaUQNkWuvzwBlFSX78HNhaFCP8hbjcDSMY?=
 =?us-ascii?Q?ZOWMjqwRleczvEvJmbms5xHIwsJwxX7nTxda3p4rDXbS/j1DiTmv7EMfjdZt?=
 =?us-ascii?Q?j81yFqo/JkbpVpzNWP+Y9id1RdyGeLXcNO8tNSrSfnnsKZtpzTpXJiC/06Zp?=
 =?us-ascii?Q?oNPyaITPJJhxIGU73WBJKyO0LYDe27NTBWsO3tgAgMRF7pcxQEjAwaFEm2iy?=
 =?us-ascii?Q?02RNJS0b+uvF3sgHucReJaw03qkmXHJWeWvb6P8oRW+PI0RF21nFEL973JYj?=
 =?us-ascii?Q?97XwZpRr/wbqHKGh5idtIG/Sz21uusBttU5S2oHJeHkbUjp+hJ4Dzp+KT14a?=
 =?us-ascii?Q?C0cPVE+y9Ulh2vQcywTAkpS2UjCGmSIweD2rCp6gZAIwGG+62XBm49uYPA7u?=
 =?us-ascii?Q?13gR98YGboz4NnFzkcx10Lfc7yot11AmerUgHqv6f4dVGZVVGyLDiR0MfW7A?=
 =?us-ascii?Q?OYsNFiyvwsny8UjPNdlUiffSMhjGY45P7puHbzzNq6jhw6WBVb16rD/x4JLd?=
 =?us-ascii?Q?HgnzosBWqK5S+2Y2jb8Kg4SRaJulWT4K8152pj+g4/ay3SOQiYFL96pyxmr5?=
 =?us-ascii?Q?sAf4qUAgrrn6Nkq8hHaz4Fa0qRjv1PFn8Uk9HgO4ktIVj4uere6gt6iDXc6D?=
 =?us-ascii?Q?PWcL9Ld/duPGdv1HoGWkXoBr/wMRfwIggQj15s9S/Ku9yx+EuwvFIMpn9Z+t?=
 =?us-ascii?Q?N9BxwXwgpRDBrVjHuZB2QotPWMl16zJrNwuyOa49cxgFuYDfeF9f58uXtfsc?=
 =?us-ascii?Q?R5KhaQR2dOiE2YR911v1tSeOgP/lZADIcK+9ik0pbsEvCKAgZrO1huLaLsst?=
 =?us-ascii?Q?ZsPEkZlk2faCSAoqhMp58NdQnQsooTOGoi05JJOUpNhlMijJoZKPJ4dxQg28?=
 =?us-ascii?Q?M8XC6+JTC9fI/451EUgQ/kp4MRXkYQXcgGFK66X/F1GndnYU9ZLbNXlI0CyX?=
 =?us-ascii?Q?xxjTGOJ4XKsxhVRPSzl56Tqskq7SmCe0Z1tFVZN3JGXx7aN215cxS9sP/Oh1?=
 =?us-ascii?Q?Ha2H/YdVSxreLg7nkwNGULQP4FXRRvhycPs3mpYsE5dROLWbjf142qAl9V19?=
 =?us-ascii?Q?sDEekYoPpQhbJUO6Jt+OrG1VSyG3pLBsXLbUCf2HWiALCfCa5KC72C6eeP+r?=
 =?us-ascii?Q?me/TBai4zbHxb6vDogU6XSym1POe7mdij2H5Hf2CkucXVhss4lXQOP7BNGG0?=
 =?us-ascii?Q?icZChAvl1lrrH/Cbr4ViP9U46XaZfEIV1/YwCuSfRP61ulmAWLhoA45Cj6K3?=
 =?us-ascii?Q?F5o7ba741bUSWb1POaGVQaJFUqSvEU0kW/yvhXV/vA++1yv1GnZ6tczD4dxk?=
 =?us-ascii?Q?ehWoxWeEtoQJp97ABCusxBzJyAIP2wdF6GqNIwW8yHofrmzg2Zbha4g4ei6V?=
 =?us-ascii?Q?2EsqYlvh0CvpwXJueWjuZwZfx5XYSxEeBvVryQv1pyFWA59UHUX0+L1tx4VE?=
 =?us-ascii?Q?Bbq5/iAfq908ywoolqaNiqiA7YhlFcczvAC6EtzUtF8RmIMurMdaGtRMde/5?=
 =?us-ascii?Q?/yjiMenCag=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b6a9cd-d868-4090-48ab-08d9b657edc1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:01.8157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DtFzaKkKaCAn0mBERXIfH4qtCTbw59azO+5rm7C3qK1y1u6UIZp1l24toDIwUBreqbn2nvcbZdMS1vrfJGlxT2uwuxNhBcpMXYLGl8rYxw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5423
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

