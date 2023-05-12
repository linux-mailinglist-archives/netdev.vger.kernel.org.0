Return-Path: <netdev+bounces-1992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E17746FFE3B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84E79281713
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 843C17F0;
	Fri, 12 May 2023 01:03:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725767EF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:03:18 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2080.outbound.protection.outlook.com [40.107.117.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F72765B9;
	Thu, 11 May 2023 18:03:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYnq8N6+50E32t+Z9g4aZAGBFJk4tEyJD9+hR9DUbkSFAywPR9PNE8eLhwzt74W6K6P4lLSmrhEcuXPjQEyjgzcbq0SjxfgIWTvVM4p8nYuLtnJMU0ffXnwTmltNwDiVuQhDenm5ZiCViGXOiBiMGjUPrKrk2WamXFzeEqNdt3tLH/BU1DsV0BoC1aiBZ50Qw7aDwiDMgKaarJx4h+DTSQUOYoTI/wziqcpAPPP6xkKV0scfAhMfAg13xFHlLcwVSlk7QfPvsVWMehtEyr+90bz68U3MOiRTPRrZ1ztKT+p+DVrs+DoHBxEygQlc6lwzI2uzmbtF3pSJfK3ENloNVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpwOEHtpxwLrB+O2jQ/Sa9CuMj3r5nehXMnk9iF6rZY=;
 b=NFtTVEqkJn/840DiQHaYwqNU8bv6rEHOyEKgAUzK7uyyz6gHX1gmor0GkLZGBb9dzbWRC0er9rsrLZHeuLXGJwFs4Gh57SSzXHo9aT3qfQ7CSgLVWkTINO5BKewdkVmFQwqPE46i6V8VbXSR7HQROB+t87ZyexMP+LnJg5p/9YUba9jcx8TuCqDFJpwSiC9faYFMn+7eMKXtYt9ujqjG9UxXd5WBRJH1s4wvAMhU7MeNxSVNmJ2S9zCiVjh02vEvvD9BRYW9+dROpRPS9qS8dw05Fo4G6RHWyaS016a+JnlOYPt75ey7hukp+F/VvnN2s0Nim44BpT281QSLpqKJEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpwOEHtpxwLrB+O2jQ/Sa9CuMj3r5nehXMnk9iF6rZY=;
 b=E17a5GX/oHUsjLKRut4t+J0ZlP5/+J6vhY/pUbs4pu/PENnPT+a7prX3ge3UhSmEKvfpwHzTuoyWa9viG6ONzIN6bg2J5UMbo7NPewlPsVmXuFelUgF9mAELmSB80v1nUYKH3n28h47yqqQD8drrVwfM/6hrWM8zMuXDLS4TwzKyBtFurwstoO7WiTdDfoGlCpzGMaZnD3UvhNmxPjy27s1LZV7QMSkT8n7ipe/ZMAIgLiaZKOjricorijyhQnZd2cZ1BLZoo4hT0C0i6o94Y0Dhe8eh3LsFQaXTkBZqFe3vzaLfnuDQR0bYHjlwzsn/dBlGyjMj3CJvbYfRbYpcJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by KL1PR0601MB4065.apcprd06.prod.outlook.com (2603:1096:820:28::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.23; Fri, 12 May
 2023 01:03:06 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::6012:86c1:192:4d46]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::6012:86c1:192:4d46%6]) with mapi id 15.20.6363.033; Fri, 12 May 2023
 01:03:06 +0000
From: Angus Chen <angus.chen@jaguarmicro.com>
To: davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Angus Chen <angus.chen@jaguarmicro.com>
Subject: [PATCH v2] net: Remove low_thresh in ip defrag
Date: Fri, 12 May 2023 09:01:52 +0800
Message-Id: <20230512010152.1602-1-angus.chen@jaguarmicro.com>
X-Mailer: git-send-email 2.33.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To TY2PR06MB3424.apcprd06.prod.outlook.com
 (2603:1096:404:104::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY2PR06MB3424:EE_|KL1PR0601MB4065:EE_
X-MS-Office365-Filtering-Correlation-Id: c25ddfde-34c6-4293-6e24-08db5284a4ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	slTeS2a+eM5I/fY8mgZDVnUafN52tAMStdRDqPDpVdAMPNcXhqE2HO5ABh2OggBP980PyazCmsnUqALSA6kW7sgr6DN9wWB3oljCxpTlM3vLMDmAQnQTkA1QU563G5v/UHVz06+7UZQ1UGVZ++nh+PFXO20eGA5qH+Ztp8hT5JXeJ/uoVxw9AfrvJU8Z2f91/TngSFbQ/ZanDHgfTUY9eDToyGnnxGfLoSyM5r+ZdeqiCku7VYZvCM+INYh+YxdkpD20kWFWLGk1c09aPDPI0t9YIq2TBkAwQpsLRaUaIJr+wecPUj2OahgXwBwxXvLJQSYh1Arw0TfK24H1CWEaHQpPGEKuHFe4M92Sbsx02h3rq7V+UpEatT5AhR6JT9/yF54xZ1Tu/2LFbodjfmBBPYDw8ITbJkO9KB+3dFiYD77T45XxxaA5BLvYaA7e8hS611SrpSH+Q+F407qmQYhB/2fV1XjGw5itX+aYSZZk5+OMWK+sq26ML3t0pjUYOIfnWgaRMHh9l5f8ZQBbE+WQsbLWKFwD7Pu9UqNmlYGeH/ptkPqFaqzXcOEnR/5QPE04609vje3XkSD6gQsQaRnkQMMTamMWWJTV4Zqwa2kkkFa31ZTprmt66k+wemQf2IJ5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(136003)(366004)(39840400004)(451199021)(83380400001)(2616005)(2906002)(186003)(41300700001)(66946007)(66476007)(4326008)(6666004)(316002)(66556008)(478600001)(6486002)(44832011)(5660300002)(26005)(1076003)(6506007)(107886003)(6512007)(52116002)(8936002)(8676002)(38100700002)(38350700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qlN5g60LU0s2Pi9VNpaleiscB4WqsUa7mkscKl73NNjboduX/Mb+FMGroDTV?=
 =?us-ascii?Q?x25EwO/8d6cJbYch9Cg9iKHZf0kkE0krNl/V18sW9DDTdAosE/P0RIcWqFdL?=
 =?us-ascii?Q?uIZDrjCDt0AObixpr3MEeO/YOftNmi3ap9N/cdNxURJ3Hsp0+YpqzXENLShw?=
 =?us-ascii?Q?ArMArSfOSnbqNhdtqLxlVmr34aeTC6CcjHed3esJzsElFjw8LN1TgXHrbRLn?=
 =?us-ascii?Q?iN5AW4ydXBeafvh+1RBSbQT9Rvw5VO2fBX28CKtov4bcW2qol8xN2SPJ0Ip7?=
 =?us-ascii?Q?cDTv6maqfgwAKAN1OAnstwGYRbHhiLmnvleub4qcyJdnmEyITViIE3oH5Tnr?=
 =?us-ascii?Q?f1msUOpielrc6cKr8wIXXWUuxKp1oy6+hLYUFKpsu6Pr5pvqjIRl2z8ArWr+?=
 =?us-ascii?Q?qWTUa6vtANDGrBSfE9KZ9V/VqRF70efFvrM9yM7eW8nA/AK8OX+ecxEuCG7J?=
 =?us-ascii?Q?82EzYVM6HkLb/6oseFWpbbLBZjJ0mUD85+wJYnks/Pgd4K/K/p3Hpv9Ngtkw?=
 =?us-ascii?Q?b5F0zZc7917PhNPyZ24ZaAAa1OdyQICo4Hg3iJVEmGKl+sSctwVvTiHnAAZP?=
 =?us-ascii?Q?u8MEg1IxBkDmTEc6osIsyDmX7yqtr00YH3d0107MnNvC9EdE+pTaKpqF4wIA?=
 =?us-ascii?Q?hfM2d17/uygFez+zBLtHUOiAtn9JTcWk26x7aQvvbqas5IAwqXwaFnvJCcH6?=
 =?us-ascii?Q?Pn8Ao2w85KkpU+MyUdr3pMMzshAGt9dp4eMn1hSWe0kPBTpmn32WDRyjda3x?=
 =?us-ascii?Q?bPhLVUtUhsqv5Osx6KIu042MNnpNABPGwRUm19NIIoKDPMI2HE8EA11mfMre?=
 =?us-ascii?Q?vWOhOR23YrtVyJOzvkKEL6fcCjge/eKv1BOHNRO7ZRwiGWYn0++6YqBaqihB?=
 =?us-ascii?Q?ZGj3OnmrWyyHo2Z+WRVGvh9Nmw74bDt9u+4rWWbadkPEj/lfnk1YnEGEJSy0?=
 =?us-ascii?Q?/GwFMXDNT/b7iCQWP8iexelW9yfUXTZCZqyOUOxW5JAcOArSq1TJsb9bF1ty?=
 =?us-ascii?Q?NgbidS+d0m5p2TyC0KoVIhpgNLLO1eDWI0bs8F9zp4UN3fIKItt4wqku6ilf?=
 =?us-ascii?Q?lMSBsxRmZlQALCrfGHqc1RenWKm0eVYCt6ziyTItGzAOyTKPSJ4Euc3S1Clp?=
 =?us-ascii?Q?IGfERnTlIyMPPxhIMgTSusb6KgzX9PfwsaCwSsjSUhM3fiD0AFinVvpIJBIy?=
 =?us-ascii?Q?tgVPLwnYUJ+WfAYA7eGOrQoMzeSwWMGuyGjP5knZZa8qtKUeilJcB4DmGrzo?=
 =?us-ascii?Q?gdaaDDwi/bVSjyewnDpVYK/4GSZ5NxGSDhmlkEdpU0XeUi7LAbHqCP+1qYDx?=
 =?us-ascii?Q?sRqB2IxQnM3ZB1CQJzQYWm6FIV/S4ieRPKVlUYfiNrB4141SKNOTx0y4lab5?=
 =?us-ascii?Q?fCtBt/r/GLJPRzd8FODCGI43sO6e8i9YpDqdiTybzjnv8oH+X6MugeCVAbwX?=
 =?us-ascii?Q?GkK1jCYth6m89hHBuLrA1rv2y75mvVc1kPsqDkPZOprsn9NoReks2YG7ryux?=
 =?us-ascii?Q?OoMio1+QYOr01vC2J5smf+t6UaFzQGsmep+S4Sj+wT9kQ/jNeHqw38TEhV/8?=
 =?us-ascii?Q?7hLU6IHxOckbhU7kl04+zv25rdN6xiWSx5xLyCmrjm87tdACCTAPZ6zh4aQf?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c25ddfde-34c6-4293-6e24-08db5284a4ec
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 01:03:06.1236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6EJXvwIF0umMJMjt+jhTBmvyKjxPQx/mPqTBzNXLzT1ce2HdnhsFzjyBmxcPIgVL/950z2JrbA4kBQEryduHCy0r3BSK9npwZxG2xqlUQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4065
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As low_thresh has no work in fragment reassembles,del it.
And Mark it deprecated in sysctl Document.

Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
---

v2:
 Fix some spelling errors,and remove low_thresh from struct fqdir.
 suggested by Jakub Kicinski <kuba@kernel.org>.
 
 Documentation/networking/nf_conntrack-sysctl.rst |  1 +
 include/net/inet_frag.h                          |  1 -
 net/ieee802154/6lowpan/reassembly.c              |  9 ++++-----
 net/ipv4/ip_fragment.c                           | 13 +++++--------
 net/ipv6/netfilter/nf_conntrack_reasm.c          |  9 ++++-----
 net/ipv6/reassembly.c                            |  9 ++++-----
 6 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 8b1045c3b59e..9ca356bc7217 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -55,6 +55,7 @@ nf_conntrack_frag6_high_thresh - INTEGER
 	nf_conntrack_frag6_low_thresh is reached.
 
 nf_conntrack_frag6_low_thresh - INTEGER
+	(Obsolete since linux-4.17)
 	default 196608
 
 	See nf_conntrack_frag6_low_thresh
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index b23ddec3cd5c..79f88ecb6467 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -13,7 +13,6 @@
 struct fqdir {
 	/* sysctls */
 	long			high_thresh;
-	long			low_thresh;
 	int			timeout;
 	int			max_dist;
 	struct inet_frags	*f;
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index a91283d1e5bf..3ba4c0f27af9 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -318,7 +318,7 @@ int lowpan_frag_rcv(struct sk_buff *skb, u8 frag_type)
 }
 
 #ifdef CONFIG_SYSCTL
-
+static unsigned long lowpanfrag_low_thresh_unuesd = IPV6_FRAG_LOW_THRESH;
 static struct ctl_table lowpan_frags_ns_ctl_table[] = {
 	{
 		.procname	= "6lowpanfrag_high_thresh",
@@ -374,9 +374,9 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 	}
 
 	table[0].data	= &ieee802154_lowpan->fqdir->high_thresh;
-	table[0].extra1	= &ieee802154_lowpan->fqdir->low_thresh;
-	table[1].data	= &ieee802154_lowpan->fqdir->low_thresh;
-	table[1].extra2	= &ieee802154_lowpan->fqdir->high_thresh;
+	table[0].extra1 = &lowpanfrag_low_thresh_unuesd;
+	table[1].data   = &lowpanfrag_low_thresh_unuesd;
+	table[1].extra2 = &ieee802154_lowpan->fqdir->high_thresh;
 	table[2].data	= &ieee802154_lowpan->fqdir->timeout;
 
 	hdr = register_net_sysctl(net, "net/ieee802154/6lowpan", table);
@@ -451,7 +451,6 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 		return res;
 
 	ieee802154_lowpan->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	ieee802154_lowpan->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	ieee802154_lowpan->fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = lowpan_frags_ns_sysctl_register(net);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 69c00ffdcf3e..0db5eb3dec83 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -553,7 +553,7 @@ EXPORT_SYMBOL(ip_check_defrag);
 
 #ifdef CONFIG_SYSCTL
 static int dist_min;
-
+static unsigned long ipfrag_low_thresh_unused;
 static struct ctl_table ip4_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ipfrag_high_thresh",
@@ -609,9 +609,9 @@ static int __net_init ip4_frags_ns_ctl_register(struct net *net)
 
 	}
 	table[0].data	= &net->ipv4.fqdir->high_thresh;
-	table[0].extra1	= &net->ipv4.fqdir->low_thresh;
-	table[1].data	= &net->ipv4.fqdir->low_thresh;
-	table[1].extra2	= &net->ipv4.fqdir->high_thresh;
+	table[0].extra1 = &ipfrag_low_thresh_unused;
+	table[1].data	= &ipfrag_low_thresh_unused;
+	table[1].extra2 = &net->ipv4.fqdir->high_thresh;
 	table[2].data	= &net->ipv4.fqdir->timeout;
 	table[3].data	= &net->ipv4.fqdir->max_dist;
 
@@ -674,12 +674,9 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 	 * A 64K fragment consumes 129736 bytes (44*2944)+200
 	 * (1500 truesize == 2944, sizeof(struct ipq) == 200)
 	 *
-	 * We will commit 4MB at one time. Should we cross that limit
-	 * we will prune down to 3MB, making room for approx 8 big 64K
-	 * fragments 8x128k.
+	 * We will commit 4MB at one time. Should we cross that limit.
 	 */
 	net->ipv4.fqdir->high_thresh = 4 * 1024 * 1024;
-	net->ipv4.fqdir->low_thresh  = 3 * 1024 * 1024;
 	/*
 	 * Important NOTE! Fragment queue must be destroyed before MSL expires.
 	 * RFC791 is wrong proposing to prolongate timer each fragment arrival
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index d13240f13607..dc8a2854e7f3 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -42,7 +42,7 @@ static struct nft_ct_frag6_pernet *nf_frag_pernet(struct net *net)
 }
 
 #ifdef CONFIG_SYSCTL
-
+static unsigned long nf_conntrack_frag6_low_thresh_unused = IPV6_FRAG_LOW_THRESH;
 static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_frag6_timeout",
@@ -82,10 +82,10 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 	nf_frag = nf_frag_pernet(net);
 
 	table[0].data	= &nf_frag->fqdir->timeout;
-	table[1].data	= &nf_frag->fqdir->low_thresh;
-	table[1].extra2	= &nf_frag->fqdir->high_thresh;
+	table[1].data	= &nf_conntrack_frag6_low_thresh_unused;
+	table[1].extra2 = &nf_frag->fqdir->high_thresh;
 	table[2].data	= &nf_frag->fqdir->high_thresh;
-	table[2].extra1	= &nf_frag->fqdir->low_thresh;
+	table[2].extra1 = &nf_conntrack_frag6_low_thresh_unused;
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
 	if (hdr == NULL)
@@ -500,7 +500,6 @@ static int nf_ct_net_init(struct net *net)
 		return res;
 
 	nf_frag->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	nf_frag->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	nf_frag->fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = nf_ct_frag6_sysctl_register(net);
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 5bc8a28e67f9..eb8373c25675 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -416,7 +416,7 @@ static const struct inet6_protocol frag_protocol = {
 };
 
 #ifdef CONFIG_SYSCTL
-
+static unsigned long ip6_frags_low_thresh_unused = IPV6_FRAG_LOW_THRESH;
 static struct ctl_table ip6_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ip6frag_high_thresh",
@@ -465,9 +465,9 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 
 	}
 	table[0].data	= &net->ipv6.fqdir->high_thresh;
-	table[0].extra1	= &net->ipv6.fqdir->low_thresh;
-	table[1].data	= &net->ipv6.fqdir->low_thresh;
-	table[1].extra2	= &net->ipv6.fqdir->high_thresh;
+	table[0].extra1 = &ip6_frags_low_thresh_unused;
+	table[1].data   = &ip6_frags_low_thresh_unused;
+	table[1].extra2 = &net->ipv6.fqdir->high_thresh;
 	table[2].data	= &net->ipv6.fqdir->timeout;
 
 	hdr = register_net_sysctl(net, "net/ipv6", table);
@@ -536,7 +536,6 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 		return res;
 
 	net->ipv6.fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
-	net->ipv6.fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	net->ipv6.fqdir->timeout = IPV6_FRAG_TIMEOUT;
 
 	res = ip6_frags_ns_sysctl_register(net);
-- 
2.25.1


