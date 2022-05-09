Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF0751FF1D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236856AbiEIOFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbiEIOF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:26 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2082.outbound.protection.outlook.com [40.107.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D570831234
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flXwTQc8+PcSbOfdbopIAQcBZplr3/Q32dpNpq5/nn79DlMTY28EDqajxdCnDMlqZOYjsGJK2PAOilonTYCif8lJ3t/Ctplus7afZhToYSDhxo7ZvRuxlEDhFUcPZHRLkksK2OpBnoqfdPzqrdHSvy4j6ffk9Y1drPpNzhELJp9H5AuCqDTHdEllByt7NTiaoWkksvRArB8nXE5gLxdJX9AuQKeHE93O3pWsBEZCGA+PHjEK7XH2x3WXCWSCyhNKMklPBMfzd/ZrFlbVek+6jyeL/pGGBWlBNpp6Vyl6GqcmrDKIeSt9w5Sk6ext5g3bgI5sbhoWuLKVZIPaP9EqMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fma9NAmGZocXH40kOe1xPxHsgdtefIcKNESgKfCIwao=;
 b=Kd5DoF8X2Z4NJL4dZjcd7qemT+mAOL5+0KXfzo0qXWMyAer/YyJNBVNWd2xd6oEEhHVLg/clf2j470oaj10UhTWzJvUt8Abtcg8WVXunBfTXzn8ohNZgiukUvxgf4uDn+QCr/cNVFwZxz0CWDEzJXJnTRca86caHPX5Ba2Z/7ZowGaq74wKkLr2NrIA2f2yl9BMTTrySr+BrYX1lIMrBRMwwFv6ASOZ7Pzs1M6lsoLdwqtxbwzyt4yozMuKWp5HaDZf01xOXDBZUk+w0M9OXIV2iBehXVuFw7mR5XASp075z76Wxw86MvaMCyuEx6+QS/BvPahkj41pZCfuCXUGKsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fma9NAmGZocXH40kOe1xPxHsgdtefIcKNESgKfCIwao=;
 b=F3zAvmQLvBrDQ+nqZw/IwG08voEV7oV8WbvCksxCyT6hEvksgcoDYZ7lXavs6CNoGjiSJCInCXUDLSTnB7Gs5kKKOdi8w8Hkw4DW8O8ptMLvL4p47E5wRtoBlr8viF8ectZixF7fEpN2wS8Y/eGMloLOz7Cngo7obsjzv9U2eCkTPPD1lnx45uLNZP8HMC4UpT2dLM1faxLeTLMOC5xFd7m0yQeoQxzBjaM/emU+8B1UynxY7h1+Pcg4H9S930IthREscNbU3exC1vWwoZGo9ZL9u3IgGrdzOLGdZorCX6P9Qmzqc7ep2qc9a6mnaOn0ulHbyAu9wIKsH5KPSlnCJA==
Received: from MW4PR03CA0046.namprd03.prod.outlook.com (2603:10b6:303:8e::21)
 by LV2PR12MB5822.namprd12.prod.outlook.com (2603:10b6:408:179::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 14:01:28 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::b7) by MW4PR03CA0046.outlook.office365.com
 (2603:10b6:303:8e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Mon, 9 May 2022 14:01:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:20 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:19 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 08/10] ipstats: Expose bridge stats in ipstats
Date:   Mon, 9 May 2022 16:00:01 +0200
Message-ID: <538c811d36953b024e4da1f8bd937cedd8d918b3.1652104101.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 01171cf8-adf3-489b-10c9-08da31c4696b
X-MS-TrafficTypeDiagnostic: LV2PR12MB5822:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB58220891A2894BE1B51A7897D6C69@LV2PR12MB5822.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xK69ja37Q8Ks6xScIDk+4flcBh1whfMLJ3NFVWgVaHUFYqKi6MXL0H4+cDeNhaN+Y8KmyLOTbEK4cCWr0Qa4uIBrGK/syBqUh4E4JRhDz535TX5aNTKUdBm83lYeAq5mBNryIUy8U555TbNLni08aoKYlhAj/dh0SpO1t846v8EpQIFZyoXK/5kT0RagJJXbcN8wsEk1fdfE8h3Gwyr2GzLff1t6hWVegqkB9vJB9DjUI1K5WZBBrMIp6sO6AkuUaD1vl7hKjlhnXHtAm/9iSWk/+sVmskONqlCAulV6k/iIFj9imw4TZ5OtyEzd/eo9c4GmiI9AwItDmtR7/MOWJGvtY5UTG+NEmIia3kGfh70MAXNxXAWT5jJpvINlNew1Ifq4gOSTRMpXzx0S8GQg7ckEcitIMzXe2EFyy1QJqRLEL6EyS+IOLwAsM/+szRJTUZJ4qf9sCuLHQ01YNuelUEat/B304wnc0LwGch97lJ9W2aJdVFp1Muij8sHRbzMnXYPGDMLmSN3CPPnDHjpOP4b/PX0zU4JODIHDwaJd4SaEbtOi/fYqniVa1xqd+nBbmHBbyD6NiVT57sIrbNNLftU2cSgapB+Gu+9qTtuxF1ORg4QRiWFr0mZC3U5Zt/aIkWVpGOIRsuyzPsvdY3Ky818s6yiCmVRHQVpT/GqViPE/cqtGV/QnmgKDrYdGVSARs3M4P17Ynb3F3/fkc32/EA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(81166007)(82310400005)(26005)(83380400001)(356005)(36756003)(8936002)(4326008)(6916009)(70206006)(54906003)(70586007)(8676002)(2616005)(47076005)(426003)(40460700003)(316002)(107886003)(36860700001)(336012)(508600001)(2906002)(5660300002)(16526019)(186003)(6666004)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:27.7228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01171cf8-adf3-489b-10c9-08da31c4696b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5822
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bridge supports two suites, STP and IGMP, carried by attributes
BRIDGE_XSTATS_STP and BRIDGE_XSTATS_MCAST. Expose them as suites "stp" and
"mcast" (to correspond to the attribute name).

For example:

 # ip stats show dev swp1 group xstats_slave subgroup bridge
 56: swp1: group xstats_slave subgroup bridge suite mcast
                     IGMP queries:
                       RX: v1 0 v2 0 v3 0
                       TX: v1 0 v2 0 v3 0
                     IGMP reports:
                       RX: v1 0 v2 0 v3 0
                       TX: v1 0 v2 0 v3 0
                     IGMP leaves: RX: 0 TX: 0
                     IGMP parse errors: 0
                     MLD queries:
                       RX: v1 0 v2 0
                       TX: v1 0 v2 0
                     MLD reports:
                       RX: v1 0 v2 0
                       TX: v1 0 v2 0
                     MLD leaves: RX: 0 TX: 0
                     MLD parse errors: 0

 56: swp1: group xstats_slave subgroup bridge suite stp
                     STP BPDU:  RX: 0 TX: 0
                     STP TCN:   RX: 0 TX: 0
                     STP Transitions: Blocked: 1 Forwarding: 0

 # ip -j stats show dev swp1 group xstats_slave subgroup bridge | jq
 [
   {
     "ifindex": 56,
     "ifname": "swp1",
     "group": "xstats_slave",
     "subgroup": "bridge",
     "suite": "mcast",
     "multicast": {
       "igmp_queries": {
         "rx_v1": 0,
         "rx_v2": 0,
         "rx_v3": 0,
         "tx_v1": 0,
         "tx_v2": 0,
         "tx_v3": 0
       },
       "igmp_reports": {
         "rx_v1": 0,
         "rx_v2": 0,
         "rx_v3": 0,
         "tx_v1": 0,
         "tx_v2": 0,
         "tx_v3": 0
       },
       "igmp_leaves": {
         "rx": 0,
         "tx": 0
       },
       "igmp_parse_errors": 0,
       "mld_queries": {
         "rx_v1": 0,
         "rx_v2": 0,
         "tx_v1": 0,
         "tx_v2": 0
       },
       "mld_reports": {
         "rx_v1": 0,
         "rx_v2": 0,
         "tx_v1": 0,
         "tx_v2": 0
       },
       "mld_leaves": {
         "rx": 0,
         "tx": 0
       },
       "mld_parse_errors": 0
     }
   },
   {
     "ifindex": 56,
     "ifname": "swp1",
     "group": "xstats_slave",
     "subgroup": "bridge",
     "suite": "stp",
     "stp": {
       "rx_bpdu": 0,
       "tx_bpdu": 0,
       "rx_tcn": 0,
       "tx_tcn": 0,
       "transition_blk": 1,
       "transition_fwd": 0
     }
   }
 ]

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ip_common.h     |  2 ++
 ip/iplink_bridge.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++
 ip/ipstats.c       |  2 ++
 3 files changed, 84 insertions(+)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index 8b7ec645..c58f2090 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -142,6 +142,8 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type);
 void br_dump_bridge_id(const struct ifla_bridge_id *id, char *buf, size_t len);
 int bridge_parse_xstats(struct link_util *lu, int argc, char **argv);
 int bridge_print_xstats(struct nlmsghdr *n, void *arg);
+extern const struct ipstats_stat_desc ipstats_stat_desc_xstats_bridge_group;
+extern const struct ipstats_stat_desc ipstats_stat_desc_xstats_slave_bridge_group;
 
 int bond_parse_xstats(struct link_util *lu, int argc, char **argv);
 int bond_print_xstats(struct nlmsghdr *n, void *arg);
diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 493be6fe..3feb6109 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -936,3 +936,83 @@ struct link_util bridge_link_util = {
 	.parse_ifla_xstats = bridge_parse_xstats,
 	.print_ifla_xstats = bridge_print_xstats,
 };
+
+static const struct ipstats_stat_desc ipstats_stat_desc_bridge_tmpl_stp = {
+	.name = "stp",
+	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
+	.show = &ipstats_stat_desc_show_xstats,
+	.pack = &ipstats_stat_desc_pack_xstats,
+};
+
+static const struct ipstats_stat_desc ipstats_stat_desc_bridge_tmpl_mcast = {
+	.name = "mcast",
+	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
+	.show = &ipstats_stat_desc_show_xstats,
+	.pack = &ipstats_stat_desc_pack_xstats,
+};
+
+static const struct ipstats_stat_desc_xstats
+ipstats_stat_desc_xstats_bridge_stp = {
+	.desc = ipstats_stat_desc_bridge_tmpl_stp,
+	.xstats_at = IFLA_STATS_LINK_XSTATS,
+	.link_type_at = LINK_XSTATS_TYPE_BRIDGE,
+	.inner_max = BRIDGE_XSTATS_MAX,
+	.inner_at = BRIDGE_XSTATS_STP,
+	.show_cb = &bridge_print_stats_stp,
+};
+
+static const struct ipstats_stat_desc_xstats
+ipstats_stat_desc_xstats_bridge_mcast = {
+	.desc = ipstats_stat_desc_bridge_tmpl_mcast,
+	.xstats_at = IFLA_STATS_LINK_XSTATS,
+	.link_type_at = LINK_XSTATS_TYPE_BRIDGE,
+	.inner_max = BRIDGE_XSTATS_MAX,
+	.inner_at = BRIDGE_XSTATS_MCAST,
+	.show_cb = &bridge_print_stats_mcast,
+};
+
+static const struct ipstats_stat_desc *
+ipstats_stat_desc_xstats_bridge_subs[] = {
+	&ipstats_stat_desc_xstats_bridge_stp.desc,
+	&ipstats_stat_desc_xstats_bridge_mcast.desc,
+};
+
+const struct ipstats_stat_desc ipstats_stat_desc_xstats_bridge_group = {
+	.name = "bridge",
+	.kind = IPSTATS_STAT_DESC_KIND_GROUP,
+	.subs = ipstats_stat_desc_xstats_bridge_subs,
+	.nsubs = ARRAY_SIZE(ipstats_stat_desc_xstats_bridge_subs),
+};
+
+static const struct ipstats_stat_desc_xstats
+ipstats_stat_desc_xstats_slave_bridge_stp = {
+	.desc = ipstats_stat_desc_bridge_tmpl_stp,
+	.xstats_at = IFLA_STATS_LINK_XSTATS_SLAVE,
+	.link_type_at = LINK_XSTATS_TYPE_BRIDGE,
+	.inner_max = BRIDGE_XSTATS_MAX,
+	.inner_at = BRIDGE_XSTATS_STP,
+	.show_cb = &bridge_print_stats_stp,
+};
+
+static const struct ipstats_stat_desc_xstats
+ipstats_stat_desc_xstats_slave_bridge_mcast = {
+	.desc = ipstats_stat_desc_bridge_tmpl_mcast,
+	.xstats_at = IFLA_STATS_LINK_XSTATS_SLAVE,
+	.link_type_at = LINK_XSTATS_TYPE_BRIDGE,
+	.inner_max = BRIDGE_XSTATS_MAX,
+	.inner_at = BRIDGE_XSTATS_MCAST,
+	.show_cb = &bridge_print_stats_mcast,
+};
+
+static const struct ipstats_stat_desc *
+ipstats_stat_desc_xstats_slave_bridge_subs[] = {
+	&ipstats_stat_desc_xstats_slave_bridge_stp.desc,
+	&ipstats_stat_desc_xstats_slave_bridge_mcast.desc,
+};
+
+const struct ipstats_stat_desc ipstats_stat_desc_xstats_slave_bridge_group = {
+	.name = "bridge",
+	.kind = IPSTATS_STAT_DESC_KIND_GROUP,
+	.subs = ipstats_stat_desc_xstats_slave_bridge_subs,
+	.nsubs = ARRAY_SIZE(ipstats_stat_desc_xstats_slave_bridge_subs),
+};
diff --git a/ip/ipstats.c b/ip/ipstats.c
index 0691a3f0..1051976d 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -605,6 +605,7 @@ int ipstats_stat_desc_show_xstats(struct ipstats_stat_show_attrs *attrs,
 }
 
 static const struct ipstats_stat_desc *ipstats_stat_desc_xstats_subs[] = {
+	&ipstats_stat_desc_xstats_bridge_group,
 };
 
 static const struct ipstats_stat_desc ipstats_stat_desc_xstats_group = {
@@ -615,6 +616,7 @@ static const struct ipstats_stat_desc ipstats_stat_desc_xstats_group = {
 };
 
 static const struct ipstats_stat_desc *ipstats_stat_desc_xstats_slave_subs[] = {
+	&ipstats_stat_desc_xstats_slave_bridge_group,
 };
 
 static const struct ipstats_stat_desc ipstats_stat_desc_xstats_slave_group = {
-- 
2.31.1

