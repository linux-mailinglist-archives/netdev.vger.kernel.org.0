Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E92451FF0B
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbiEIOF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbiEIOFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:18 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5C72AE8
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pk+gzAoSC/PhNUAIEgsY+t/4tryB2E5wRwCpxthiqOZ8YX8ZEu5a6JDrxJNIHB1xdCSBonFCqcRZGnQW+W/UP7bd9yEFCsykctbSbF/C+YQ60dDzdZuppWZ3yIRYRf53ktr82QqUwY9JZR9lN+JnqpHpQE5uCUYV7XrqX9RHQurzJLbOSSWPwEeTsOvfsu2VG6vRv5N/2zCvD26CoZK/Cv+dcpJOklBIxpWjc02YN7AdSCYo/mJvOQHtuOYiCB6k7btOkYmpS8Mog7a9fOkNq4rwwljhYr1u27+ZQPBrBkjqtWsciDT9bRs874pBozQ5i8vI6U64XBk805lQDUn33w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bBTkgHRKwg/LlcxFjTLsCH9SzPWG6ICo4ML+E1IPL8=;
 b=lkHMmIJxs2zOVF8IU0dDNchFhhX/LM/kme8XlwF+xjMo4VZRZraFhHWm9qN9GGBoWQF7loZAeQKcecW1k1um5GujJEOQmrBwoXonIIOi5EfHr9aU/2qZ/XSDisZLxcBRXxKpsejDGIZ2NRrhCZW/87NLLGfEMIUuuHjjRbNWoDy3B5r8ltVkfM9fHgl212JRCVsXADiAmKTe2QYdg/J+toH8BEXqP2Edva8hDmrm2cWTlVjonbZ1ZJRB4pYsdFQvs4jo4R68i9wyZl5edhSYelFRlMIxmP5kU29l2lZ464IstjoISQV3JOxkeui1pXL3HcoIQN3UQB4t4WRi+e4kHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bBTkgHRKwg/LlcxFjTLsCH9SzPWG6ICo4ML+E1IPL8=;
 b=sVQY+cRo9V8GGBD3Sp9hI+yKsDj0gKcPIIHSOirF1FufgofJM0t7teYDYSE/PA7tbhn5j+pWIFF4FgTw+hp3bbeHz6hRKzArRDXROjszse4zfe7qk6Cygyq+td7Lvcuj+rGnRnmwff8EHAvt8ZgkUsT+KPb6lRgQroJhO9cNor7J57/fujZYUS2wR4GW0Y0YvX6shfODM7KG/8anVmKaByD5lxOTb5MOSQ/A+g4WYrdYPi9tCeog142QyfV7Jyw4TZdZ9IMqZskQZCowhn4j1BgDLzx2/M+KkCMm9Ip1zwIdSqzi/9EoOXz60qbb8CYkwGd3DY3+8Yaj3go0zfiLEA==
Received: from MW4PR04CA0109.namprd04.prod.outlook.com (2603:10b6:303:83::24)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 14:01:23 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::e1) by MW4PR04CA0109.outlook.office365.com
 (2603:10b6:303:83::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23 via Frontend
 Transport; Mon, 9 May 2022 14:01:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:22 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:20 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 09/10] ipstats: Expose bond stats in ipstats
Date:   Mon, 9 May 2022 16:00:02 +0200
Message-ID: <5c0de4f4844bd23a3c7035826ec93d6bf71ae666.1652104101.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1652104101.git.petrm@nvidia.com>
References: <cover.1652104101.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1e14ce9-67c9-4e28-ea87-08da31c46671
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4479D5DF050363313659D5BBD6C69@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOsd/2uEnYkPkjCsRmONzJq0b7vqWut6AtVO4lguaRzp2BShmvgHQdVb408HVwoghGP9XwPtWpNqMlKE8weVuiJ1/+1LZIFbgqu7skzRUzG5mAcN6+T9uMpYz90+IQ/hXwS7WfMte47oC6fXVgeEpqkMx2HYbNtreAEodbd9rM0t+KG9qgqHcU/0AT5z77wFtUVcikPmaG1oZCz4HnSeVufaipTIuiLlbf0aW79qk2WIjAdm9rKfhP/1yWinFeP1My87tOBmNQINQlCGI93dnU2jYLtA8aQnSL/L3TVmfGNXRRC7gz+s1Mh4Q/yjUL0seRZrN7wmyDYoCSfDOcqTiutTTv11JTBrFxOjSo8qVl/4pme0ZocIuVK6iZPwKaIvfAPOJ70xlfQ6Uf0Vn9b95IvYZ6hmTnlymmFueNlV6nME97fUtioXM6rUaTszTu2k79Swry2S7Uar0XQeWbxhGx/+EtOIgL82HkBhdi629lFf/4Qyg3ZUd6t8iXL98GrEsVkzdUMD6n3FsRRDU5hRHmoYJBivWoxeridMKtaGX9UT8tUtsXACGH4f4FK69sAgaiZUsARbULmWuohY7BCbjjZF2ziRRxjHQFoOyIsyVEwiZqhFjiYTgeGh58NKUj9Iv6BAOzuaqiks9QVn79Fy4I1lZi3pchd0V1ONqpwFVjgp7cPrdJ2R1dEpIwnFrXOylfla6Ca9Za2M+kXU8g+THQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(5660300002)(6666004)(26005)(54906003)(6916009)(36756003)(8936002)(16526019)(186003)(2906002)(47076005)(426003)(107886003)(336012)(82310400005)(83380400001)(36860700001)(508600001)(356005)(86362001)(4326008)(70206006)(70586007)(2616005)(316002)(8676002)(81166007)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:22.7345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e14ce9-67c9-4e28-ea87-08da31c46671
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe xstats and xstats_slave subgroups for bond netdevices.

For example:

 # ip stats show dev swp1 group xstats_slave subgroup bond
 56: swp1: group xstats_slave subgroup bond suite 802.3ad
                     LACPDU Rx 0
                     LACPDU Tx 0
                     LACPDU Unknown type Rx 0
                     LACPDU Illegal Rx 0
                     Marker Rx 0
                     Marker Tx 0
                     Marker response Rx 0
                     Marker response Tx 0
                     Marker unknown type Rx 0

 # ip -j stats show dev swp1 group xstats_slave subgroup bond | jq
 [
   {
     "ifindex": 56,
     "ifname": "swp1",
     "group": "xstats_slave",
     "subgroup": "bond",
     "suite": "802.3ad",
     "802.3ad": {
       "lacpdu_rx": 0,
       "lacpdu_tx": 0,
       "lacpdu_unknown_rx": 0,
       "lacpdu_illegal_rx": 0,
       "marker_rx": 0,
       "marker_tx": 0,
       "marker_response_rx": 0,
       "marker_response_tx": 0,
       "marker_unknown_rx": 0
     }
   }
 ]

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ip_common.h   |  3 +++
 ip/iplink_bond.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++--
 ip/ipstats.c     |  2 ++
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index c58f2090..ffa633e0 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -145,8 +145,11 @@ int bridge_print_xstats(struct nlmsghdr *n, void *arg);
 extern const struct ipstats_stat_desc ipstats_stat_desc_xstats_bridge_group;
 extern const struct ipstats_stat_desc ipstats_stat_desc_xstats_slave_bridge_group;
 
+/* iplink_bond.c */
 int bond_parse_xstats(struct link_util *lu, int argc, char **argv);
 int bond_print_xstats(struct nlmsghdr *n, void *arg);
+extern const struct ipstats_stat_desc ipstats_stat_desc_xstats_bond_group;
+extern const struct ipstats_stat_desc ipstats_stat_desc_xstats_slave_bond_group;
 
 /* iproute_lwtunnel.c */
 int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp,
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 650411fc..15db19a3 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -15,6 +15,7 @@
 #include <string.h>
 #include <linux/if_bonding.h>
 
+#include "list.h"
 #include "rt_names.h"
 #include "utils.h"
 #include "ip_common.h"
@@ -761,7 +762,7 @@ static void bond_print_xstats_help(struct link_util *lu, FILE *f)
 	fprintf(f, "Usage: ... %s [ 802.3ad ] [ dev DEVICE ]\n", lu->id);
 }
 
-static void bond_print_3ad_stats(struct rtattr *lacpattr)
+static void bond_print_3ad_stats(const struct rtattr *lacpattr)
 {
 	struct rtattr *lacptb[BOND_3AD_STAT_MAX+1];
 	__u64 val;
@@ -912,7 +913,6 @@ int bond_parse_xstats(struct link_util *lu, int argc, char **argv)
 	return 0;
 }
 
-
 struct link_util bond_link_util = {
 	.id		= "bond",
 	.maxattr	= IFLA_BOND_MAX,
@@ -922,3 +922,54 @@ struct link_util bond_link_util = {
 	.parse_ifla_xstats = bond_parse_xstats,
 	.print_ifla_xstats = bond_print_xstats,
 };
+
+static const struct ipstats_stat_desc ipstats_stat_desc_bond_tmpl_lacp = {
+	.name = "802.3ad",
+	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
+	.show = &ipstats_stat_desc_show_xstats,
+	.pack = &ipstats_stat_desc_pack_xstats,
+};
+
+static const struct ipstats_stat_desc_xstats
+ipstats_stat_desc_xstats_bond_lacp = {
+	.desc = ipstats_stat_desc_bond_tmpl_lacp,
+	.xstats_at = IFLA_STATS_LINK_XSTATS,
+	.link_type_at = LINK_XSTATS_TYPE_BOND,
+	.inner_max = BOND_XSTATS_MAX,
+	.inner_at = BOND_XSTATS_3AD,
+	.show_cb = &bond_print_3ad_stats,
+};
+
+static const struct ipstats_stat_desc *
+ipstats_stat_desc_xstats_bond_subs[] = {
+	&ipstats_stat_desc_xstats_bond_lacp.desc,
+};
+
+const struct ipstats_stat_desc ipstats_stat_desc_xstats_bond_group = {
+	.name = "bond",
+	.kind = IPSTATS_STAT_DESC_KIND_GROUP,
+	.subs = ipstats_stat_desc_xstats_bond_subs,
+	.nsubs = ARRAY_SIZE(ipstats_stat_desc_xstats_bond_subs),
+};
+
+static const struct ipstats_stat_desc_xstats
+ipstats_stat_desc_xstats_slave_bond_lacp = {
+	.desc = ipstats_stat_desc_bond_tmpl_lacp,
+	.xstats_at = IFLA_STATS_LINK_XSTATS_SLAVE,
+	.link_type_at = LINK_XSTATS_TYPE_BOND,
+	.inner_max = BOND_XSTATS_MAX,
+	.inner_at = BOND_XSTATS_3AD,
+	.show_cb = &bond_print_3ad_stats,
+};
+
+static const struct ipstats_stat_desc *
+ipstats_stat_desc_xstats_slave_bond_subs[] = {
+	&ipstats_stat_desc_xstats_slave_bond_lacp.desc,
+};
+
+const struct ipstats_stat_desc ipstats_stat_desc_xstats_slave_bond_group = {
+	.name = "bond",
+	.kind = IPSTATS_STAT_DESC_KIND_GROUP,
+	.subs = ipstats_stat_desc_xstats_slave_bond_subs,
+	.nsubs = ARRAY_SIZE(ipstats_stat_desc_xstats_slave_bond_subs),
+};
diff --git a/ip/ipstats.c b/ip/ipstats.c
index 1051976d..5cdd15ae 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -606,6 +606,7 @@ int ipstats_stat_desc_show_xstats(struct ipstats_stat_show_attrs *attrs,
 
 static const struct ipstats_stat_desc *ipstats_stat_desc_xstats_subs[] = {
 	&ipstats_stat_desc_xstats_bridge_group,
+	&ipstats_stat_desc_xstats_bond_group,
 };
 
 static const struct ipstats_stat_desc ipstats_stat_desc_xstats_group = {
@@ -617,6 +618,7 @@ static const struct ipstats_stat_desc ipstats_stat_desc_xstats_group = {
 
 static const struct ipstats_stat_desc *ipstats_stat_desc_xstats_slave_subs[] = {
 	&ipstats_stat_desc_xstats_slave_bridge_group,
+	&ipstats_stat_desc_xstats_slave_bond_group,
 };
 
 static const struct ipstats_stat_desc ipstats_stat_desc_xstats_slave_group = {
-- 
2.31.1

