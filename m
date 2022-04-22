Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126DF50B2F2
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445182AbiDVIez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445532AbiDVIeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3251852E75
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUsbi5DLh3KC5sV302Hv78SsVKH+21V2ZCaoFSy+U6UIRadzMYRP6zk1qvJFFqmHw9jAq3wo3uUgLEzb1Gq0INpeSMPx6r/mPaxqqnRhl/ie7BAG8K46K3f/Xjw8pNghTc46g8M0V+EkwnuKhNzIzocGVn66qegYFJjtz1WebAvOzBcjZ9vqJC+ZGBwWPgzP8wsHOb0hrHVYBYAncs2kPhhg7k0nCT5YhU2RVEbtq/uQ11sbaJcivWN3f01MYoy9nedAwxL4aESiuMEdZf5mrGQ5w9yy2LJteiA69jIFxQdOzp73BW3RqlDshwECoNFgHH42Dl6ZlUrZzopizodz+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xon3V8m3B3G+2sFOaEz6Hxg7y7D1d5S+/B+mHbrFumQ=;
 b=fFlvoNPcD/s/KnsGTi1Ty4uIm9fT7SLUFT+/eUmFszXKeQSZZkfl4KqntXKrB+IemgzEKInQuBV4E2HSC+EpGMqMSA3KmKYnbmxQ2eXOsJHzI2/s7fdMS8b/D2zWm92KfUdlgJ2BHLbfak3sQAb3oDDeyPpvLe4NFHuscOJt8OZDSVPlcG0hpe6hXE20ksB2NJ4Cwd9m5OXYwgBenoKae/X8RyIHVv9zJ3P9zZ1OuphQgdICs5U+NNmL0nFRReVO1huckcMjBGwDzh2POV1cGKKCEYyQ3QlDMwe1ZvK4buceyyXtt3fVPWgwQqouxzI19cZI9uy6D5crCKBCIdO5UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xon3V8m3B3G+2sFOaEz6Hxg7y7D1d5S+/B+mHbrFumQ=;
 b=VIvZkUGnrpEcyJJ8QBSVjcToa8KokJv0bUfCDuHsU3oFfKV9e3qRPTNTrpkL5XLMrsDREeCjh9fg2ebrwNvQsxr2z855AKac2HbBUnvW9w69+ctuGEnYGn7fWckv1X/3ZrN/6fOkGYkK/M8WuyZNzK6EAlW2GhtGKSuyi1Cd8eMnAdNe9Xh9hu3Rm67GlWvJrozg7XPUgpLb0/mGCyZ2k1UZJMBWK+c73/MeIwbxegem0g6Ok50b6Tml2F5FNXvyjp6l+MwnrGMbyWMkbVkTgNbtSsi4RK3wpRJRSyEDupZ9RRGz9kXf5xnDJ1kcxouJX8X6qBK6woXQYMf0uTc1Hw==
Received: from DM6PR03CA0045.namprd03.prod.outlook.com (2603:10b6:5:100::22)
 by DM6PR12MB3052.namprd12.prod.outlook.com (2603:10b6:5:11e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 22 Apr
 2022 08:31:45 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::72) by DM6PR03CA0045.outlook.office365.com
 (2603:10b6:5:100::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:44 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:42 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 09/11] ipstats: Add offload subgroup "l3_stats"
Date:   Fri, 22 Apr 2022 10:30:58 +0200
Message-ID: <42aace625494db72cb0b7252bbeba12df7703f78.1650615982.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1650615982.git.petrm@nvidia.com>
References: <cover.1650615982.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bc84a5a-8f8e-4240-dbb5-08da243a8912
X-MS-TrafficTypeDiagnostic: DM6PR12MB3052:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB30520C2202497902807E46BED6F79@DM6PR12MB3052.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BsXRlgbR6d1C1sP9fAHdYeCcCCdhpp8uoqu33Y4IcsTXhnCLYgZlZwYwxNsqyYMJxE9dKLjjhRdfOKnBUrmKLDdewsfeOdfj+F3apxg0S7K0Cw78q02QtftBeZExjWPNwcaUvS3adGNVqoW5MCzEw4GD/vA0f8jqpTN0eI5wd9lj6Ud3aoFLLyu6Lk+i+1ZXKqKv8DaFDeQjIsxVKZNhDzf8OHwDbJH2GGnUp1esZMl8/xIc6Kdd2cqzTvtmsQUQhLwQufJ4L0UvxB6nA0S+YIgl7xKZ8+vvkCt8aUCXe60AtYXnVuT6VCEuZ1yX+t3ixhIXm/2u4+WKLpd93CahuhWW2V6ezjZch4x3jyvVOfIexfvBSxrS6QtXCNhYm4elrsM2ivuNyLWIwJuRk/+69bs1d8YfEq28vmhdLSc2FloSeFY7cmFDWhGxLri51m4Gf2uyA72d1C+JLdsKtKPNMVi3b5bJBkrHlYEigKfDBZByvQ/jFQhA8ndFJduVvZBhBADz/0zE6gnLI9uLdHHByVJNm4Peim7FXNM/+EVsKSev+gccsE5gS8Akg7z4/zMEkr8sb3pqeK3HGdrqw6tnUU2XeC87IErDRfi2jqQxnB39+xemeFXuvSaEufgeiUWRWAPcIZZHjZXjHqEghhkR84H7sfAxc2dU4aiKipEX/sFju0LRT3xdRRpNoy5gzvxWa65h8+JFolfCFyHXApX/HA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2616005)(47076005)(81166007)(356005)(70586007)(8936002)(8676002)(4326008)(70206006)(336012)(426003)(186003)(107886003)(6666004)(26005)(6916009)(16526019)(36860700001)(2906002)(83380400001)(316002)(54906003)(40460700003)(82310400005)(5660300002)(508600001)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:45.1514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc84a5a-8f8e-4240-dbb5-08da243a8912
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3052
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add into the group "offload" a subgroup "l3_stats" for showing
L3 statistics.

For example:

 # ip stats show dev swp2.200 group offload subgroup l3_stats
 4212: swp2.200: group offload subgroup l3_stats on used on
     RX: bytes packets errors dropped   mcast
          1920      21      1       0       0
     TX: bytes packets errors dropped
           756       9      0       0

 # ip -j stats show dev swp2.200 group offload subgroup l3_stats | jq
 [
   {
     "ifindex": 4212,
     "ifname": "swp2.200",
     "group": "offload",
     "subgroup": "l3_stats",
     "info": {
       "request": true,
       "used": true
     },
     "stats64": {
       "rx": {
         "bytes": 1920,
         "packets": 21,
         "errors": 1,
         "dropped": 0,
         "multicast": 0
       },
       "tx": {
         "bytes": 756,
         "packets": 9,
         "errors": 0,
         "dropped": 0
       }
     }
   }
 ]

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipstats.c | 158 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index 4cdd5122..29ca0731 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -164,6 +164,82 @@ static int ipstats_show_64(struct ipstats_stat_show_attrs *attrs,
 	return 0;
 }
 
+static void print_hw_stats64(FILE *fp, struct rtnl_hw_stats64 *s)
+{
+	unsigned int cols[] = {
+		strlen("*X: bytes"),
+		strlen("packets"),
+		strlen("errors"),
+		strlen("dropped"),
+		strlen("overrun"),
+	};
+
+	if (is_json_context()) {
+		/* RX stats */
+		open_json_object("rx");
+		print_u64(PRINT_JSON, "bytes", NULL, s->rx_bytes);
+		print_u64(PRINT_JSON, "packets", NULL, s->rx_packets);
+		print_u64(PRINT_JSON, "errors", NULL, s->rx_errors);
+		print_u64(PRINT_JSON, "dropped", NULL, s->rx_dropped);
+		print_u64(PRINT_JSON, "multicast", NULL, s->multicast);
+		close_json_object();
+
+		/* TX stats */
+		open_json_object("tx");
+		print_u64(PRINT_JSON, "bytes", NULL, s->tx_bytes);
+		print_u64(PRINT_JSON, "packets", NULL, s->tx_packets);
+		print_u64(PRINT_JSON, "errors", NULL, s->tx_errors);
+		print_u64(PRINT_JSON, "dropped", NULL, s->tx_dropped);
+		close_json_object();
+	} else {
+		size_columns(cols, ARRAY_SIZE(cols),
+			     s->rx_bytes, s->rx_packets, s->rx_errors,
+			     s->rx_dropped, s->multicast);
+		size_columns(cols, ARRAY_SIZE(cols),
+			     s->tx_bytes, s->tx_packets, s->tx_errors,
+			     s->tx_dropped, 0);
+
+		/* RX stats */
+		fprintf(fp, "    RX: %*s %*s %*s %*s %*s%s",
+			cols[0] - 4, "bytes", cols[1], "packets",
+			cols[2], "errors", cols[3], "dropped",
+			cols[4], "mcast", _SL_);
+
+		fprintf(fp, "    ");
+		print_num(fp, cols[0], s->rx_bytes);
+		print_num(fp, cols[1], s->rx_packets);
+		print_num(fp, cols[2], s->rx_errors);
+		print_num(fp, cols[3], s->rx_dropped);
+		print_num(fp, cols[4], s->multicast);
+		fprintf(fp, "%s", _SL_);
+
+		/* TX stats */
+		fprintf(fp, "    TX: %*s %*s %*s %*s%s",
+			cols[0] - 4, "bytes", cols[1], "packets",
+			cols[2], "errors", cols[3], "dropped", _SL_);
+
+		fprintf(fp, "    ");
+		print_num(fp, cols[0], s->tx_bytes);
+		print_num(fp, cols[1], s->tx_packets);
+		print_num(fp, cols[2], s->tx_errors);
+		print_num(fp, cols[3], s->tx_dropped);
+	}
+}
+
+static int ipstats_show_hw64(const struct rtattr *at)
+{
+	struct rtnl_hw_stats64 *stats;
+
+	stats = IPSTATS_RTA_PAYLOAD(struct rtnl_hw_stats64, at);
+	if (stats == NULL) {
+		fprintf(stderr, "Error: attribute payload too short");
+		return -EINVAL;
+	}
+
+	print_hw_stats64(stdout, stats);
+	return 0;
+}
+
 enum ipstats_maybe_on_off {
 	IPSTATS_MOO_OFF = -1,
 	IPSTATS_MOO_INVALID,
@@ -355,6 +431,57 @@ static int ipstats_show_hw_s_info(struct ipstats_stat_show_attrs *attrs,
 	return __ipstats_show_hw_s_info(at);
 }
 
+static int __ipstats_show_hw_stats(const struct rtattr *at_hwsi,
+				   const struct rtattr *at_stats,
+				   enum ipstats_hw_s_info_idx idx)
+{
+	int err = 0;
+
+	if (at_hwsi != NULL) {
+		struct ipstats_hw_s_info hwsi = {};
+
+		err = ipstats_dissect_hw_s_info(at_hwsi, &hwsi);
+		if (err)
+			return err;
+
+		open_json_object("info");
+		__ipstats_show_hw_s_info_one(hwsi.infos[idx]);
+		close_json_object();
+
+		ipstats_fini_hw_s_info(&hwsi);
+	}
+
+	if (at_stats != NULL) {
+		print_nl();
+		open_json_object("stats64");
+		err = ipstats_show_hw64(at_stats);
+		close_json_object();
+	}
+
+	return err;
+}
+
+static int ipstats_show_hw_stats(struct ipstats_stat_show_attrs *attrs,
+				 unsigned int group,
+				 unsigned int hw_s_info,
+				 unsigned int hw_stats,
+				 enum ipstats_hw_s_info_idx idx)
+{
+	const struct rtattr *at_stats;
+	const struct rtattr *at_hwsi;
+	int err = 0;
+
+	at_hwsi = ipstats_stat_show_get_attr(attrs, group, hw_s_info, &err);
+	if (at_hwsi == NULL)
+		return err;
+
+	at_stats = ipstats_stat_show_get_attr(attrs, group, hw_stats, &err);
+	if (at_stats == NULL && err != 0)
+		return err;
+
+	return __ipstats_show_hw_stats(at_hwsi, at_stats, idx);
+}
+
 static void
 ipstats_stat_desc_pack_cpu_hit(struct ipstats_stat_dump_filters *filters,
 			       const struct ipstats_stat_desc *desc)
@@ -405,9 +532,40 @@ static const struct ipstats_stat_desc ipstats_stat_desc_offload_hw_s_info = {
 	.show = &ipstats_stat_desc_show_hw_stats_info,
 };
 
+static void
+ipstats_stat_desc_pack_l3_stats(struct ipstats_stat_dump_filters *filters,
+				const struct ipstats_stat_desc *desc)
+{
+	ipstats_stat_desc_enable_bit(filters,
+				     IFLA_STATS_LINK_OFFLOAD_XSTATS,
+				     IFLA_OFFLOAD_XSTATS_L3_STATS);
+	ipstats_stat_desc_enable_bit(filters,
+				     IFLA_STATS_LINK_OFFLOAD_XSTATS,
+				     IFLA_OFFLOAD_XSTATS_HW_S_INFO);
+}
+
+static int
+ipstats_stat_desc_show_l3_stats(struct ipstats_stat_show_attrs *attrs,
+				const struct ipstats_stat_desc *desc)
+{
+	return ipstats_show_hw_stats(attrs,
+				     IFLA_STATS_LINK_OFFLOAD_XSTATS,
+				     IFLA_OFFLOAD_XSTATS_HW_S_INFO,
+				     IFLA_OFFLOAD_XSTATS_L3_STATS,
+				     IPSTATS_HW_S_INFO_IDX_L3_STATS);
+}
+
+static const struct ipstats_stat_desc ipstats_stat_desc_offload_l3_stats = {
+	.name = "l3_stats",
+	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
+	.pack = &ipstats_stat_desc_pack_l3_stats,
+	.show = &ipstats_stat_desc_show_l3_stats,
+};
+
 static const struct ipstats_stat_desc *ipstats_stat_desc_offload_subs[] = {
 	&ipstats_stat_desc_offload_cpu_hit,
 	&ipstats_stat_desc_offload_hw_s_info,
+	&ipstats_stat_desc_offload_l3_stats,
 };
 
 static const struct ipstats_stat_desc ipstats_stat_desc_offload_group = {
-- 
2.31.1

