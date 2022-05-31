Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7D4538FF0
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 13:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242819AbiEaLgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 07:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiEaLgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 07:36:10 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2055.outbound.protection.outlook.com [40.107.100.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE9A9B1A4
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 04:36:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dprTRQeERP3N2dMG36BuPrjbITiF5GuvdfgZ4DrCP1A621gJjX4/FPDE369HN6tdRp5IgVXYqXV5aw8ks6NmD78Zc5d/8Cu+LXrXgbhcMixwEIo8OkZQBr8mlWZCq/Nh+TUQG566A+3NCQwvJDt9PmZncZiPFHMTxvXHNDUNqyTJBKOtSJ6wodKQZxinMgsqHoaF8KC2dAN09Rg2TswZRam5/oem75fP+KBVdy4m2o0xkMEgkG8vxlYWSH8vQqfj9inQh4l98PZfswhyC2LQBCciXkuOd99LWR1Y3zDqgGoXdf9d2RH7jipmFN9MhwtzVB3zldiVxyGeSTDXstT7zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mYRKqJwJd24viRQ4z6XflnC4Du+m24P7GmJueIrDoSo=;
 b=P0PciTCc/OKk60amcSAImp4BzFUUtzL0dUpG0e0hSYvHVGBFavA3KUpjgxlE7bzP2ANa03YFp60dVAxnPjBCqpOjcAF7XS7nYTeu0zr0sigtvL02p1ljzfzIKZ1GDaiIT4RJyku4NZ9TnJ6gXXkCf07Vq2ULTA3ehodcoyFvR97kzg2wA8eWCGiHTYb3yfLFuwteH4X/lGrlN6E8U6+5otIjoykpoAPoD85fdPQNWJVlVyXiNFro4H2azhyvtLk2TcM57SROuEmtJWMLJoXuOdnJoVcVAZvnehzFZivHb8kugm8NYPpftqi23SccbIudEvcDG9g9fuMiUZnFrusl8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYRKqJwJd24viRQ4z6XflnC4Du+m24P7GmJueIrDoSo=;
 b=FcLhbij9NbzF1b3p116UVPlozsIe2W63fljTxLEgU4Fuxf4Hr9i3Aju1X7/JgBUsYkHFVmiLVoZp4NZy2CpD3nP/yrJCQthAFRyh4q2KbKHBWU20C/JtSFeN2h+j3M7p52bGSH/oxA/deyN0hDvGVKmDtWg+Z8RxTGyAmzjSvgAt+OO7XQwxF79Eaub3T7CJSdQSjyu9u2RUWDIpoVCEkJGKhGXKndCr4xlkfT4KWxLF/D+VNPWXawgthpjn9EDuDMgXNw/xFqvRhv2kq7E6irORw15AcutN44o64zSXpSsTXcbQO/405gtBKuSh2xuDQfa2JMXf2bClabTOthQVdw==
Received: from BN6PR13CA0004.namprd13.prod.outlook.com (2603:10b6:404:10a::14)
 by CY4PR12MB1704.namprd12.prod.outlook.com (2603:10b6:903:11d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.18; Tue, 31 May
 2022 11:36:04 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::58) by BN6PR13CA0004.outlook.office365.com
 (2603:10b6:404:10a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Tue, 31 May 2022 11:36:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5293.13 via Frontend Transport; Tue, 31 May 2022 11:36:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 31 May
 2022 11:36:02 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 31 May 2022 04:36:00 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] ip: Convert non-constant initializers to macros
Date:   Tue, 31 May 2022 13:35:48 +0200
Message-ID: <7feecdf0b0354cd31de7f716e10ed122066ba061.1653996204.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31c4b669-8d57-4b95-9353-08da42f9bea3
X-MS-TrafficTypeDiagnostic: CY4PR12MB1704:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1704AD9421289D79DC5D0B0CD6DC9@CY4PR12MB1704.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gcBcmkh6mS6MIXkV07YpwlZHHgbmaX1QioLU62l6UFQFLjtCsxdLmq+wcX6ItOGiRKg5pObjsfq7bV6NKMF2pjis8GznqxYcOLA8tXhNI67FrAaBj/pREj/nmQSa/rulde1YmTPy1w9pRXhja/zXsdTvwSuJtWAfsMqZ9iPbHNWlJJMKMoPutP20X4umSQWg4qWs4ACdvMsGBQOw/8TdqDaKXIm9a9u0SE9HIaK/ibzngIGUKVehweYU49PGblAaQo+/DLspDTgDobXHiUY/sS7GpZaP3Ts6hISBu4U+XU82uLArxKUqXv9rqUkriXwJ0gknLM8Tw9ONzbX5nlce1DKmtq9onyPNpqpisM0hEgunRAOKYPa7mo2LwdG92HSxglJSYe9GjSWXhwDGstXMWEzEdGLPwEuPjylGA+Sz05B0hTUZQMMMjTf4tRjeCdCibtOZHYGvsZwISh+C2A58lbou4vZ6hH4c+zj99xuLva+t1H2VtI8abpKg4fSUANqX1yicgonzaXTmvpJdp4r6RzM896lpb7p3SBGhAYlJW7/ieA871tFzmJUruaUWzUeveCPv7ft51dPVXxH92qibSTAl7w1GRf8Vxixn+MpA92wHMbbSuONHU0zdcp3WEWDtiL87/Qvd+8E5oX0jtkxDQlXzyHwRsGckJ4IlU9Xua5YJsAYA4aFWdcTDRlSJWHBZI6tDLCFfTzluu767WZZmfQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(70586007)(70206006)(356005)(4326008)(8676002)(186003)(16526019)(5660300002)(7696005)(508600001)(336012)(83380400001)(6666004)(47076005)(426003)(8936002)(2906002)(54906003)(36756003)(316002)(6916009)(2616005)(36860700001)(81166007)(82310400005)(26005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 11:36:03.7152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c4b669-8d57-4b95-9353-08da42f9bea3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1704
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per the C standard, "expressions in an initializer for an object that
has static or thread storage duration shall be constant expressions".
Aggregate objects are not constant expressions. Newer GCC doesn't mind, but
older GCC and LLVM do.

Therefore convert to a macro. And since all these macros will look very
similar, extract a generic helper, IPSTATS_STAT_DESC_XSTATS_LEAF, which
takes the leaf name as an argument and initializes the rest as appropriate
for an xstats descriptor.

Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 ip/ip_common.h     |  7 +++++++
 ip/iplink_bond.c   | 11 ++---------
 ip/iplink_bridge.c | 22 ++++------------------
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index ffa633e0..c4cb1bcb 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -205,6 +205,13 @@ void ipstats_stat_desc_pack_xstats(struct ipstats_stat_dump_filters *filters,
 int ipstats_stat_desc_show_xstats(struct ipstats_stat_show_attrs *attrs,
 				  const struct ipstats_stat_desc *desc);
 
+#define IPSTATS_STAT_DESC_XSTATS_LEAF(NAME) {		\
+		.name = (NAME),				\
+		.kind = IPSTATS_STAT_DESC_KIND_LEAF,	\
+		.show = &ipstats_stat_desc_show_xstats,	\
+		.pack = &ipstats_stat_desc_pack_xstats,	\
+	}
+
 #ifndef	INFINITY_LIFE_TIME
 #define     INFINITY_LIFE_TIME      0xFFFFFFFFU
 #endif
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 15db19a3..7943499e 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -923,16 +923,9 @@ struct link_util bond_link_util = {
 	.print_ifla_xstats = bond_print_xstats,
 };
 
-static const struct ipstats_stat_desc ipstats_stat_desc_bond_tmpl_lacp = {
-	.name = "802.3ad",
-	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
-	.show = &ipstats_stat_desc_show_xstats,
-	.pack = &ipstats_stat_desc_pack_xstats,
-};
-
 static const struct ipstats_stat_desc_xstats
 ipstats_stat_desc_xstats_bond_lacp = {
-	.desc = ipstats_stat_desc_bond_tmpl_lacp,
+	.desc = IPSTATS_STAT_DESC_XSTATS_LEAF("802.3ad"),
 	.xstats_at = IFLA_STATS_LINK_XSTATS,
 	.link_type_at = LINK_XSTATS_TYPE_BOND,
 	.inner_max = BOND_XSTATS_MAX,
@@ -954,7 +947,7 @@ const struct ipstats_stat_desc ipstats_stat_desc_xstats_bond_group = {
 
 static const struct ipstats_stat_desc_xstats
 ipstats_stat_desc_xstats_slave_bond_lacp = {
-	.desc = ipstats_stat_desc_bond_tmpl_lacp,
+	.desc = IPSTATS_STAT_DESC_XSTATS_LEAF("802.3ad"),
 	.xstats_at = IFLA_STATS_LINK_XSTATS_SLAVE,
 	.link_type_at = LINK_XSTATS_TYPE_BOND,
 	.inner_max = BOND_XSTATS_MAX,
diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 3feb6109..0f950d37 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -937,23 +937,9 @@ struct link_util bridge_link_util = {
 	.print_ifla_xstats = bridge_print_xstats,
 };
 
-static const struct ipstats_stat_desc ipstats_stat_desc_bridge_tmpl_stp = {
-	.name = "stp",
-	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
-	.show = &ipstats_stat_desc_show_xstats,
-	.pack = &ipstats_stat_desc_pack_xstats,
-};
-
-static const struct ipstats_stat_desc ipstats_stat_desc_bridge_tmpl_mcast = {
-	.name = "mcast",
-	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
-	.show = &ipstats_stat_desc_show_xstats,
-	.pack = &ipstats_stat_desc_pack_xstats,
-};
-
 static const struct ipstats_stat_desc_xstats
 ipstats_stat_desc_xstats_bridge_stp = {
-	.desc = ipstats_stat_desc_bridge_tmpl_stp,
+	.desc = IPSTATS_STAT_DESC_XSTATS_LEAF("stp"),
 	.xstats_at = IFLA_STATS_LINK_XSTATS,
 	.link_type_at = LINK_XSTATS_TYPE_BRIDGE,
 	.inner_max = BRIDGE_XSTATS_MAX,
@@ -963,7 +949,7 @@ ipstats_stat_desc_xstats_bridge_stp = {
 
 static const struct ipstats_stat_desc_xstats
 ipstats_stat_desc_xstats_bridge_mcast = {
-	.desc = ipstats_stat_desc_bridge_tmpl_mcast,
+	.desc = IPSTATS_STAT_DESC_XSTATS_LEAF("mcast"),
 	.xstats_at = IFLA_STATS_LINK_XSTATS,
 	.link_type_at = LINK_XSTATS_TYPE_BRIDGE,
 	.inner_max = BRIDGE_XSTATS_MAX,
@@ -986,7 +972,7 @@ const struct ipstats_stat_desc ipstats_stat_desc_xstats_bridge_group = {
 
 static const struct ipstats_stat_desc_xstats
 ipstats_stat_desc_xstats_slave_bridge_stp = {
-	.desc = ipstats_stat_desc_bridge_tmpl_stp,
+	.desc = IPSTATS_STAT_DESC_XSTATS_LEAF("stp"),
 	.xstats_at = IFLA_STATS_LINK_XSTATS_SLAVE,
 	.link_type_at = LINK_XSTATS_TYPE_BRIDGE,
 	.inner_max = BRIDGE_XSTATS_MAX,
@@ -996,7 +982,7 @@ ipstats_stat_desc_xstats_slave_bridge_stp = {
 
 static const struct ipstats_stat_desc_xstats
 ipstats_stat_desc_xstats_slave_bridge_mcast = {
-	.desc = ipstats_stat_desc_bridge_tmpl_mcast,
+	.desc = IPSTATS_STAT_DESC_XSTATS_LEAF("mcast"),
 	.xstats_at = IFLA_STATS_LINK_XSTATS_SLAVE,
 	.link_type_at = LINK_XSTATS_TYPE_BRIDGE,
 	.inner_max = BRIDGE_XSTATS_MAX,
-- 
2.35.3

