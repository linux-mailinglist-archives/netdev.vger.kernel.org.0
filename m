Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529045E5B47
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiIVGWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiIVGWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:22:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA08FB5A7A
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:22:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Okn3hIUwdJXrY17zUYSO+3A0Rto9GgjRTx8XbxogHZLS0NbZOaFGiUckrjVy/JAjtZun1NLk6csV2AbcnTevSbIbbx0PBZ0JOjhix7zUiD37WX7lp/+TkfGAt3j5js4wmVDeGDWeOVdN5GZ0ZXRW4za13CzpyKHg7YMdQ3jeRw1mk/5IfggQm7DrBOqr0iJm0YdQsD/sQqLOyAJt9qmoMF7OajeDqV8OFA3nZOwViPu32HG24fd/9HofBBS4E6xJ9tWpvwCsACDsgtHlRT/k+vhXZrnMtaVCUnwQ1Ag8Fwo6yw8y/zFtaio9pMmFEnaIJmv3nCQrtqedKjn/mG/gbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wd0Kj+R7UdldQ6sDd/n8+z1wyFi6Zae1fJQV93rinJw=;
 b=JMTsssNvVNG7KEGo7f/zajs61N1sdUHifeRz4mJQ3C2QviE+RTI5mlsglvsoAK1dGxpR6mTJNG7EmbXFgnG+FI6CVsvbccZMgrqsI86LgmGWRdFNZaT85H07MSrhw/MwX3KbN2rVU2EiVGl9nJTKX49WkpG4ycMwfzpgI/qZhkJF0z8W9GkzZxa0OtP7UO+9hMzP+6HS88xUE9BmoogzUy/X6qQwp6aYxQBfOW2lusUW92aNNgrGuQk7O+Pw1jLw+NpiFXR5dMeSPP1ClnKQM62CIBOcXQMfe1gQtvRP6Xx21EB5D/2SIRikBYXmaB5YSxki7lfnB5BbUffubYsZuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wd0Kj+R7UdldQ6sDd/n8+z1wyFi6Zae1fJQV93rinJw=;
 b=CnK0YujzC4IBmelzDuT260JxwvThxx64jjIBdhSQ86pAtiqcQVrR29U5rye417BKdS2lJ2yel3QFlf2XxO/UXpzT8Ef38OHZdHI8m6oBcAR8578kQIapGy1LzQ4Y7bR40OdqK+siF/9mFcTph/jva+B5N4BOcJXl1RKRa/H1RlteLy6Ipeb2vetW0U15yrSjPl4FWR0eCdxf3rJ6QXDk15X0+7p0n4xYYCbCvhINF/kwH6CIwoARQi+0y4Mcfnyt0dJ2zv464Th9hOqR7sWtHGaVzLeyM6hZfrKOvX084H4sUChtKQhBt17V9Q+FxutOZHuZMfz73uEoSozQJGsAng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by DS7PR12MB6237.namprd12.prod.outlook.com (2603:10b6:8:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Thu, 22 Sep
 2022 06:22:32 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f%4]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 06:22:32 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2 4/4] ip-monitor: Fix the selection of rtnl groups when listening for all object types
Date:   Thu, 22 Sep 2022 15:19:38 +0900
Message-Id: <20220922061938.202705-5-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220922061938.202705-1-bpoirier@nvidia.com>
References: <20220922061938.202705-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0185.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::29) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|DS7PR12MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: 788def3b-a500-4ff1-f4a7-08da9c62d544
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPGrj9kSl0FnbxgACnpiADbbxbZdH64vughhOYr/QjEKqIJo2GCjLjw36ZqHlkuUCs0DERTrryj3gOTFw0Lt8odSaQkNc9Q2hGG4Om45C5hLaJ0ny7R0LC7bt7r/D/POk96y88Iro99/Ted93lG5sa3cv7wQpbu2XB9t8vKH5O+2T7WyfbzOgM11TeQCll2zD/8dFr89xqzHvyilJWz7WTRfxBLJ8H6qPufZnvDsT93yW0lYbpRBjQX3hkqhxoSVxYNT14V4s/PY0k/sDpwMR3XxEWae9bF/v2MJ6rz02z9AoA8acWGfPI/XfQgcsX3LEczD15IeQKix/xPbgOYivV8qDcGFxEfaJq814V08aXj5ij691kKR26GwqPLYxl2BXySefHgsp9hBQr/hdxD7z0WFZsW8/wQAqB3gCyp9FB0sUjMp2Brb64FPXqH6dCkwZrcyF4mjWYMeCBnMygK3JyaoceYIiOsOgBL4RPgk9JvfDAXdhNanlOqfzyeifTg2GkLoc6YQhiGdXvfiOPR1H6s9HsvzWPIchEdactOt+xqy8uiUjIwPmKmJV2e2X9ybLY38sA1lAfJXXUznqacm9i0df5s5zCim9vOzQw9TR1BH4PhzpttSwOANG81tyheQsAEDStqPeIPb2qGM4FHqUsjZQmtPY5lxzrf6lYfd9hOOy2VG+U9dBJyS3cZrP+9+bYPjS0VsWK/KZtoOF5Mx0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(6916009)(54906003)(4326008)(478600001)(316002)(6486002)(86362001)(8676002)(66946007)(66556008)(41300700001)(66476007)(8936002)(83380400001)(26005)(6506007)(186003)(6512007)(5660300002)(107886003)(38100700002)(2616005)(1076003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6kqE+Ta8rBsRajxwL26HH6e17pXh52B7eJJWuoo/IEQoSdNbShxSCMlLA9cn?=
 =?us-ascii?Q?42G2EYt8d7WQgTn4DBXtggCm+umtbDdqhk60vFN5gHD6UlCz7oshEIjAUzXm?=
 =?us-ascii?Q?rYYy3bpIqAP2jneOkB/grEhPXzbFgd126Pgq/oVWcoPTn1mgmqWHrNqNcPDM?=
 =?us-ascii?Q?A2XYPpmfENBX+XOGwKHb+uR7YrXCUymlVpXhwyer8IWxVlMSz5smVqNv4HFn?=
 =?us-ascii?Q?nZdIj4JKFrpvWfXWnnitNFLtQhC6yQUvVzBVcTrDjRm4GhxrD4+lxqLG7IXN?=
 =?us-ascii?Q?Wjv+y+WDiWtUQZCxSThg/eJLBuQlFgFUtf2eeENPtP1SlTjbS0/PG4ypucJK?=
 =?us-ascii?Q?6to0bTix/NBOuTivKUDHTYClLuZ0jKV3Rd8LUv4YiUtzK+RoqtHd5+4JHICS?=
 =?us-ascii?Q?OOonpD+ij6DTGd+Fvz5zqoCgPZTELQ1Fb0p6FZHlsG7gTLHwYgdoJqQvwsA7?=
 =?us-ascii?Q?UScZkB06OT96QWhvH/jmGbGhfgKFJazI73I9HTjeTS2M2FB3TAdheV9FQUjE?=
 =?us-ascii?Q?s/scPY0Rp0GLO550G4WInTjsGVFcn3DTvsdT44Df59nMmkY7vofgqf9w729+?=
 =?us-ascii?Q?sDCVtI8mAe1cajVdDjs5XB2OfHGipB85pfHyXNkRUHhs72peabM52VSa37zL?=
 =?us-ascii?Q?ygGKpjnFHS0M9BeVEUJ5VzAnKhFSGWCF6wb8boGUgFsaa4ycRrtAku2L/bCs?=
 =?us-ascii?Q?q81ffF3Qd6N59XWaoaeWMUBe/KdKvTPwezonO4NkWJwYmfYNBPVqxkR50nmE?=
 =?us-ascii?Q?+awt6UZ+TvgtktltCEK2iBxVYy3LAR3iERTebmZkf+4lseaBxbcGFb8JkGWw?=
 =?us-ascii?Q?t26ihrEQ9N6bsCputkWwZ1Je+qpUNnhdxZIHi2SwxOf5cCWZHsS8Y3GVI661?=
 =?us-ascii?Q?qqblkrpjKWI48vX8UX5AgdDLYlGkWrjvOiVYbfPBimQ4VqbSk66qSkJmUKgm?=
 =?us-ascii?Q?3dDRHNkNQPTII/F0zvNQ/1Rtx6X0FFV7XWyH6Xto7a6eOjiwhDVO3agl8paj?=
 =?us-ascii?Q?NJ1o9KjnleEyvdf7Hlsy1zyQRSTLP7XA+P/5fXJ/wZ6xiE1uQ97s0z8iWLbx?=
 =?us-ascii?Q?/Gy6cJ79HFKF30j3dlKLG+M9/xW5rD6SqU8QYYcj1RVyJTMSfgQJNRT8IvPa?=
 =?us-ascii?Q?VyZO9Gk+M8LnuUejRuTI5ei4D8lb6spQ1ntgGP+goGQg/VNySymCjzVhws48?=
 =?us-ascii?Q?DYKrIPY4vfSVTi8/wQZcXbcclcpbFxL9vgXwvrO8lh09Hoktj/8NXgqHGxFD?=
 =?us-ascii?Q?QCWXBWoxUWMwmoXnHu8YjMtdOPaDpIlhIwxMD8kpYVJtqFe/wuquTojfSHCK?=
 =?us-ascii?Q?wQfm8qUDzWvuIUXVYpVUyI5yFqKFkgT14Ksq+b0K7q3u92EDoMrP8TY2V2rM?=
 =?us-ascii?Q?czRTmNiJCje1aqlRHgxfNM2HgSEJeDA6JZ8SunGBJKZadAmyWansJbTjF2SA?=
 =?us-ascii?Q?VO2uyiyZpWupxqsbwzelq1IcCgVLBkLTy2gyw5KmtYYi12josMJKTVnS4w09?=
 =?us-ascii?Q?n/Y8E2oNuNzHIOHed5u4aO0pxjbA2WSUcjjnkvggUpKbMzaOp/OcBQAUrQ6U?=
 =?us-ascii?Q?WIOzZD5T/Gcf9ZLv9//+eK9K4JBIc7aQhyw4k9gQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 788def3b-a500-4ff1-f4a7-08da9c62d544
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 06:22:32.7639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BE545xnkwnUD19Ng3nQtCg3tfnUgp13K1f6RsNDh82tn9Mn0YdBoWiIBwR0bvvSXtnEzQ4gk6T32iSfyA3z91w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6237
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when using `ip monitor`, family-specific rtnl multicast groups
(ex. RTNLGRP_IPV4_IFADDR) are used when specifying the '-family' option (or
one of its short forms) and an object type is specified (ex. `ip -4 monitor
addr`) but not when listening for changes to all object types (ex. `ip -4
monitor`). In that case, multicast groups for all families, regardless of
the '-family' option, are used. Depending on the object type, this leads to
ignoring the '-family' selection (MROUTE, ADDR, NETCONF), or printing stray
prefix headers with no event (ROUTE, RULE).

Rewrite the parameter parsing code so that per-family rtnl multicast groups
are selected in all cases.

The issue can be witnessed while running `ip -4 monitor label` at the same
time as the following command:
	ip link add dummy0 address 02:00:00:00:00:01 up type dummy
The output includes:
[ROUTE][ROUTE][ADDR]9: dummy0    inet6 fe80::ff:fe00:1/64 scope link
       valid_lft forever preferred_lft forever
Notice the stray "[ROUTE]" labels (related to filtered out ipv6 routes) and
the ipv6 ADDR entry. Those do not appear if using `ip -4 monitor label
route address`.

Fixes: aba5acdfdb34 ("(Logical change 1.3)")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 ip/ipmonitor.c | 128 ++++++++++++++++---------------------------------
 1 file changed, 42 insertions(+), 86 deletions(-)

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index cb2195d1..8a72ea42 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -178,40 +178,26 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 	return 0;
 }
 
+#define IPMON_LLINK		BIT(0)
+#define IPMON_LADDR		BIT(1)
+#define IPMON_LROUTE		BIT(2)
+#define IPMON_LMROUTE		BIT(3)
+#define IPMON_LPREFIX		BIT(4)
+#define IPMON_LNEIGH		BIT(5)
+#define IPMON_LNETCONF		BIT(6)
+#define IPMON_LSTATS		BIT(7)
+#define IPMON_LRULE		BIT(8)
+#define IPMON_LNSID		BIT(9)
+#define IPMON_LNEXTHOP		BIT(10)
+
+#define IPMON_L_ALL		(~0)
+
 int do_ipmonitor(int argc, char **argv)
 {
-	int lstats = 0, stats_set = 1;
-	int lnexthop = 0, nh_set = 1;
+	unsigned int groups = 0, lmask = 0;
 	char *file = NULL;
-	unsigned int groups = 0;
-	int llink = 0;
-	int laddr = 0;
-	int lroute = 0;
-	int lmroute = 0;
-	int lprefix = 0;
-	int lneigh = 0;
-	int lnetconf = 0;
-	int lrule = 0;
-	int lnsid = 0;
 	int ifindex = 0;
 
-	groups |= nl_mgrp(RTNLGRP_LINK);
-	groups |= nl_mgrp(RTNLGRP_IPV4_IFADDR);
-	groups |= nl_mgrp(RTNLGRP_IPV6_IFADDR);
-	groups |= nl_mgrp(RTNLGRP_IPV4_ROUTE);
-	groups |= nl_mgrp(RTNLGRP_IPV6_ROUTE);
-	groups |= nl_mgrp(RTNLGRP_MPLS_ROUTE);
-	groups |= nl_mgrp(RTNLGRP_IPV4_MROUTE);
-	groups |= nl_mgrp(RTNLGRP_IPV6_MROUTE);
-	groups |= nl_mgrp(RTNLGRP_IPV6_PREFIX);
-	groups |= nl_mgrp(RTNLGRP_NEIGH);
-	groups |= nl_mgrp(RTNLGRP_IPV4_NETCONF);
-	groups |= nl_mgrp(RTNLGRP_IPV6_NETCONF);
-	groups |= nl_mgrp(RTNLGRP_IPV4_RULE);
-	groups |= nl_mgrp(RTNLGRP_IPV6_RULE);
-	groups |= nl_mgrp(RTNLGRP_NSID);
-	groups |= nl_mgrp(RTNLGRP_MPLS_NETCONF);
-
 	rtnl_close(&rth);
 
 	while (argc > 0) {
@@ -221,58 +207,27 @@ int do_ipmonitor(int argc, char **argv)
 		} else if (matches(*argv, "label") == 0) {
 			prefix_banner = 1;
 		} else if (matches(*argv, "link") == 0) {
-			llink = 1;
-			groups = 0;
-			nh_set = 0;
-			stats_set = 0;
+			lmask |= IPMON_LLINK;
 		} else if (matches(*argv, "address") == 0) {
-			laddr = 1;
-			groups = 0;
-			nh_set = 0;
-			stats_set = 0;
+			lmask |= IPMON_LADDR;
 		} else if (matches(*argv, "route") == 0) {
-			lroute = 1;
-			groups = 0;
-			nh_set = 0;
-			stats_set = 0;
+			lmask |= IPMON_LROUTE;
 		} else if (matches(*argv, "mroute") == 0) {
-			lmroute = 1;
-			groups = 0;
-			nh_set = 0;
-			stats_set = 0;
+			lmask |= IPMON_LMROUTE;
 		} else if (matches(*argv, "prefix") == 0) {
-			lprefix = 1;
-			groups = 0;
-			nh_set = 0;
-			stats_set = 0;
+			lmask |= IPMON_LPREFIX;
 		} else if (matches(*argv, "neigh") == 0) {
-			lneigh = 1;
-			groups = 0;
-			nh_set = 0;
-			stats_set = 0;
+			lmask |= IPMON_LNEIGH;
 		} else if (matches(*argv, "netconf") == 0) {
-			lnetconf = 1;
-			groups = 0;
-			nh_set = 0;
-			stats_set = 0;
+			lmask |= IPMON_LNETCONF;
 		} else if (matches(*argv, "rule") == 0) {
-			lrule = 1;
-			groups = 0;
-			nh_set = 0;
-			stats_set = 0;
+			lmask |= IPMON_LRULE;
 		} else if (matches(*argv, "nsid") == 0) {
-			lnsid = 1;
-			groups = 0;
-			nh_set = 0;
-			stats_set = 0;
+			lmask |= IPMON_LNSID;
 		} else if (matches(*argv, "nexthop") == 0) {
-			lnexthop = 1;
-			groups = 0;
-			stats_set = 0;
+			lmask |= IPMON_LNEXTHOP;
 		} else if (strcmp(*argv, "stats") == 0) {
-			lstats = 1;
-			groups = 0;
-			nh_set = 0;
+			lmask |= IPMON_LSTATS;
 		} else if (strcmp(*argv, "all") == 0) {
 			prefix_banner = 1;
 		} else if (matches(*argv, "all-nsid") == 0) {
@@ -298,15 +253,18 @@ int do_ipmonitor(int argc, char **argv)
 	ipneigh_reset_filter(ifindex);
 	ipnetconf_reset_filter(ifindex);
 
-	if (llink)
+	if (!lmask)
+		lmask = IPMON_L_ALL;
+
+	if (lmask & IPMON_LLINK)
 		groups |= nl_mgrp(RTNLGRP_LINK);
-	if (laddr) {
+	if (lmask & IPMON_LADDR) {
 		if (!preferred_family || preferred_family == AF_INET)
 			groups |= nl_mgrp(RTNLGRP_IPV4_IFADDR);
 		if (!preferred_family || preferred_family == AF_INET6)
 			groups |= nl_mgrp(RTNLGRP_IPV6_IFADDR);
 	}
-	if (lroute) {
+	if (lmask & IPMON_LROUTE) {
 		if (!preferred_family || preferred_family == AF_INET)
 			groups |= nl_mgrp(RTNLGRP_IPV4_ROUTE);
 		if (!preferred_family || preferred_family == AF_INET6)
@@ -314,20 +272,20 @@ int do_ipmonitor(int argc, char **argv)
 		if (!preferred_family || preferred_family == AF_MPLS)
 			groups |= nl_mgrp(RTNLGRP_MPLS_ROUTE);
 	}
-	if (lmroute) {
+	if (lmask & IPMON_LMROUTE) {
 		if (!preferred_family || preferred_family == AF_INET)
 			groups |= nl_mgrp(RTNLGRP_IPV4_MROUTE);
 		if (!preferred_family || preferred_family == AF_INET6)
 			groups |= nl_mgrp(RTNLGRP_IPV6_MROUTE);
 	}
-	if (lprefix) {
+	if (lmask & IPMON_LPREFIX) {
 		if (!preferred_family || preferred_family == AF_INET6)
 			groups |= nl_mgrp(RTNLGRP_IPV6_PREFIX);
 	}
-	if (lneigh) {
+	if (lmask & IPMON_LNEIGH) {
 		groups |= nl_mgrp(RTNLGRP_NEIGH);
 	}
-	if (lnetconf) {
+	if (lmask & IPMON_LNETCONF) {
 		if (!preferred_family || preferred_family == AF_INET)
 			groups |= nl_mgrp(RTNLGRP_IPV4_NETCONF);
 		if (!preferred_family || preferred_family == AF_INET6)
@@ -335,19 +293,15 @@ int do_ipmonitor(int argc, char **argv)
 		if (!preferred_family || preferred_family == AF_MPLS)
 			groups |= nl_mgrp(RTNLGRP_MPLS_NETCONF);
 	}
-	if (lrule) {
+	if (lmask & IPMON_LRULE) {
 		if (!preferred_family || preferred_family == AF_INET)
 			groups |= nl_mgrp(RTNLGRP_IPV4_RULE);
 		if (!preferred_family || preferred_family == AF_INET6)
 			groups |= nl_mgrp(RTNLGRP_IPV6_RULE);
 	}
-	if (lnsid) {
+	if (lmask & IPMON_LNSID) {
 		groups |= nl_mgrp(RTNLGRP_NSID);
 	}
-	if (nh_set)
-		lnexthop = 1;
-	if (stats_set)
-		lstats = 1;
 
 	if (file) {
 		FILE *fp;
@@ -366,12 +320,14 @@ int do_ipmonitor(int argc, char **argv)
 	if (rtnl_open(&rth, groups) < 0)
 		exit(1);
 
-	if (lnexthop && rtnl_add_nl_group(&rth, RTNLGRP_NEXTHOP) < 0) {
+	if (lmask & IPMON_LNEXTHOP &&
+	    rtnl_add_nl_group(&rth, RTNLGRP_NEXTHOP) < 0) {
 		fprintf(stderr, "Failed to add nexthop group to list\n");
 		exit(1);
 	}
 
-	if (lstats && rtnl_add_nl_group(&rth, RTNLGRP_STATS) < 0) {
+	if (lmask & IPMON_LSTATS &&
+	    rtnl_add_nl_group(&rth, RTNLGRP_STATS) < 0) {
 		fprintf(stderr, "Failed to add stats group to list\n");
 		exit(1);
 	}
-- 
2.37.2

