Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6A651FF22
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiEIOFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbiEIOFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2071.outbound.protection.outlook.com [40.107.95.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74FD10D9
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KH7ZUvfqfPnBIEg9VFI+dWtx5tyltwd/WoPMSQ2+8QSrXQv2Lk/jlEBGNOrsxPLF5s0DLDiOYi/j8ghWauvjUUUfvxiO/f2Hc2Z68e1DFkEX3lHmPU/90EVSQKtNsStge5OXrykbw4DqAtJQl3Gshf9HORVLu59p93yMFK2ci9eWrblPEZPhq0AmjetMXbkzEResBb4xkoxc7cppNFnpNGLtNPvzYn0lgqsHgXLEafYhMJlpV2raqw/NGjJrEYvF66NN1WjAU1d+Hkq0cAbjW4sQj5nZNY4W4IPkLKrbsW48/axN5rIq0joK18AnLVVLI+2Iy/VuR79U/nsAxZMLfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XH7ajTe6LAk/nu5tK9rGnRiBeyV8VN07dUCrz451cI8=;
 b=fJqfJxzarL8NapzrILUSkyVss0WPSsVccB0YrK0jWXFOCHlNZuX9wr/v51FGq1HniNC7fQ1T+LSJmujBVGlxNvakpat1jM3eQGrDNhHN/BMHBILH09mz7tOQyyriE8qUDyyku8yHgQqsbiR1raBw8ZlolO7juChls4heCuFK7E1rWUbTLdAPMTEDVBUI3cfnDPoBlUjDOnfobsUofxURmKxIcJbnwUS5XYhfmSzkp78j5B/6/pGzjInmlnv171dd5TbtxaTbohwxF69PU+QiulSweezqVK9Zw+jgXr3fkeVZca0sl0I8hnSAh1tW2WZoSnLEinlgMfrcanjjCYw+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XH7ajTe6LAk/nu5tK9rGnRiBeyV8VN07dUCrz451cI8=;
 b=f5swuhVVo3UTsK/oYU2whSFeElw5wynXrUh5gstHaw1BdvH6hiJsU45BCZbJb1fpg/a3+2OH9NUiONboPjYhTiBK2w/8XEA8BUZBIkTpmFcCa37Phk596VC4usOM0VhMJolbBeRHy2iYeYbILzXTEdhazDA8DjqoEKWgjxOa2fdi5/8nEofoTGDDKdTEXGc+wTNynh7BR8OP7kiEjpmgmRRfJ+boFaTze882cD7H2bUJShYcPvwtEue/GEKNIIEc1cmiggELxh/bd4zE2sXnPoMlI8iIV9Ke5MEV54tPL9zRlFwx1xijWFk8+vTO+Yeh5jygGPt99H8nDl2lVAAwJQ==
Received: from DS7PR03CA0281.namprd03.prod.outlook.com (2603:10b6:5:3ad::16)
 by MW3PR12MB4571.namprd12.prod.outlook.com (2603:10b6:303:5c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 9 May
 2022 14:01:21 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::b) by DS7PR03CA0281.outlook.office365.com
 (2603:10b6:5:3ad::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Mon, 9 May 2022 14:01:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:19 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:17 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 07/10] iplink_bridge: Split bridge_print_stats_attr()
Date:   Mon, 9 May 2022 16:00:00 +0200
Message-ID: <8f0e48fde7949992f88a2be277143308728bceba.1652104101.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 49ba2c33-f120-4edc-2317-08da31c464bd
X-MS-TrafficTypeDiagnostic: MW3PR12MB4571:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB45718B0C9E393F55EB9079C4D6C69@MW3PR12MB4571.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UybOccefA84FeEPp0OevGWkUR68Ep+N7tkzKzO7IUg8AxtLvJDSpKHb2QuexNTZIdq9xIfIzlqyKuCGoFsCBjYC9KukzsBRYlN2aaJCACqcCy5aamKIlhTl/yhESd/ARljZ4r76jKOKj8LAUVNPZl6ZrqplAM4nExrfE0obyKPgy0WdKJICF8Dd8ndWOBpLHGs7pPGzh6pJBcifMZXyqzLezgTm5oOUHBCjLMDIQAwo2usVuqRUSFD2Uj3JEfgVgnHlWKzSAgcv5z25Ruuec4NVqgpDhAa8R+8Dpou4I30U5FVVpt3Q+QqAdwNnrH0IkKA5CmDzfTqOrvHd2B+Q68X0OCQtQ8zKGr+W7D9VDt2sk5oheCsJhGEddzr+gir1GX0el9b+wuuEONHUG/GXN3TNy4d5I7wEoDaux7TtaKsgdIV917GdDoPV2+wdiFviFMjlHBmFWy0BiFHyNVr8lPi+7BcfCkMJUpesSRcPLGcVE95TIgf8TNvhCOB1F3UGJGrokv4CjvnxpmAKoj0Im1R4b02UCH+Ulx96OrdwVIYUpjwkBJrZRo8vjWguEhnfFN0P3ixiHKmYL4nVhMSPqvjK5on9wQY+rJhFTDJ87rEftlNetCW3wlPVLXtIGd61qy0S7Jwi2G0ogLts7i1dRarJTN2yAcSxxs/9fdhes7T1ZSxgTYrS70QDfsNAjY06ch79/3Gk6UeIL5OMqH1LzLg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2616005)(107886003)(54906003)(86362001)(6916009)(8936002)(316002)(4326008)(70206006)(356005)(6666004)(81166007)(26005)(8676002)(70586007)(2906002)(508600001)(426003)(336012)(40460700003)(82310400005)(83380400001)(47076005)(16526019)(5660300002)(36756003)(36860700001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:19.8251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ba2c33-f120-4edc-2317-08da31c464bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4571
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract from bridge_print_stats_attr() two helpers, one for dumping the
multicast attribute, one for dumping the STP attribute.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/iplink_bridge.c | 254 ++++++++++++++++++++++++---------------------
 1 file changed, 133 insertions(+), 121 deletions(-)

diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index c2e63f6e..493be6fe 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -714,11 +714,140 @@ static void bridge_print_xstats_help(struct link_util *lu, FILE *f)
 	fprintf(f, "Usage: ... %s [ igmp ] [ dev DEVICE ]\n", lu->id);
 }
 
+static void bridge_print_stats_mcast(const struct rtattr *attr)
+{
+	struct br_mcast_stats *mstats;
+
+	mstats = RTA_DATA(attr);
+	open_json_object("multicast");
+	open_json_object("igmp_queries");
+	print_string(PRINT_FP, NULL,
+		     "%-16s    IGMP queries:\n", "");
+	print_string(PRINT_FP, NULL, "%-16s      ", "");
+	print_u64(PRINT_ANY, "rx_v1", "RX: v1 %llu ",
+		  mstats->igmp_v1queries[BR_MCAST_DIR_RX]);
+	print_u64(PRINT_ANY, "rx_v2", "v2 %llu ",
+		  mstats->igmp_v2queries[BR_MCAST_DIR_RX]);
+	print_u64(PRINT_ANY, "rx_v3", "v3 %llu\n",
+		  mstats->igmp_v3queries[BR_MCAST_DIR_RX]);
+	print_string(PRINT_FP, NULL, "%-16s      ", "");
+	print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
+		  mstats->igmp_v1queries[BR_MCAST_DIR_TX]);
+	print_u64(PRINT_ANY, "tx_v2", "v2 %llu ",
+		  mstats->igmp_v2queries[BR_MCAST_DIR_TX]);
+	print_u64(PRINT_ANY, "tx_v3", "v3 %llu\n",
+		  mstats->igmp_v3queries[BR_MCAST_DIR_TX]);
+	close_json_object();
+
+	open_json_object("igmp_reports");
+	print_string(PRINT_FP, NULL,
+		     "%-16s    IGMP reports:\n", "");
+	print_string(PRINT_FP, NULL, "%-16s      ", "");
+	print_u64(PRINT_ANY, "rx_v1", "RX: v1 %llu ",
+		  mstats->igmp_v1reports[BR_MCAST_DIR_RX]);
+	print_u64(PRINT_ANY, "rx_v2", "v2 %llu ",
+		  mstats->igmp_v2reports[BR_MCAST_DIR_RX]);
+	print_u64(PRINT_ANY, "rx_v3", "v3 %llu\n",
+		  mstats->igmp_v3reports[BR_MCAST_DIR_RX]);
+	print_string(PRINT_FP, NULL, "%-16s      ", "");
+	print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
+		  mstats->igmp_v1reports[BR_MCAST_DIR_TX]);
+	print_u64(PRINT_ANY, "tx_v2", "v2 %llu ",
+		  mstats->igmp_v2reports[BR_MCAST_DIR_TX]);
+	print_u64(PRINT_ANY, "tx_v3", "v3 %llu\n",
+		  mstats->igmp_v3reports[BR_MCAST_DIR_TX]);
+	close_json_object();
+
+	open_json_object("igmp_leaves");
+	print_string(PRINT_FP, NULL,
+		     "%-16s    IGMP leaves: ", "");
+	print_u64(PRINT_ANY, "rx", "RX: %llu ",
+		  mstats->igmp_leaves[BR_MCAST_DIR_RX]);
+	print_u64(PRINT_ANY, "tx", "TX: %llu\n",
+		  mstats->igmp_leaves[BR_MCAST_DIR_TX]);
+	close_json_object();
+
+	print_string(PRINT_FP, NULL,
+		     "%-16s    IGMP parse errors: ", "");
+	print_u64(PRINT_ANY, "igmp_parse_errors", "%llu\n",
+		  mstats->igmp_parse_errors);
+
+	open_json_object("mld_queries");
+	print_string(PRINT_FP, NULL,
+		     "%-16s    MLD queries:\n", "");
+	print_string(PRINT_FP, NULL, "%-16s      ", "");
+	print_u64(PRINT_ANY, "rx_v1", "RX: v1 %llu ",
+		  mstats->mld_v1queries[BR_MCAST_DIR_RX]);
+	print_u64(PRINT_ANY, "rx_v2", "v2 %llu\n",
+		  mstats->mld_v2queries[BR_MCAST_DIR_RX]);
+	print_string(PRINT_FP, NULL, "%-16s      ", "");
+	print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
+		  mstats->mld_v1queries[BR_MCAST_DIR_TX]);
+	print_u64(PRINT_ANY, "tx_v2", "v2 %llu\n",
+		  mstats->mld_v2queries[BR_MCAST_DIR_TX]);
+	close_json_object();
+
+	open_json_object("mld_reports");
+	print_string(PRINT_FP, NULL,
+		     "%-16s    MLD reports:\n", "");
+	print_string(PRINT_FP, NULL, "%-16s      ", "");
+	print_u64(PRINT_ANY, "rx_v1", "RX: v1 %llu ",
+		  mstats->mld_v1reports[BR_MCAST_DIR_RX]);
+	print_u64(PRINT_ANY, "rx_v2", "v2 %llu\n",
+		  mstats->mld_v2reports[BR_MCAST_DIR_RX]);
+	print_string(PRINT_FP, NULL, "%-16s      ", "");
+	print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
+		  mstats->mld_v1reports[BR_MCAST_DIR_TX]);
+	print_u64(PRINT_ANY, "tx_v2", "v2 %llu\n",
+		  mstats->mld_v2reports[BR_MCAST_DIR_TX]);
+	close_json_object();
+
+	open_json_object("mld_leaves");
+	print_string(PRINT_FP, NULL,
+		     "%-16s    MLD leaves: ", "");
+	print_u64(PRINT_ANY, "rx", "RX: %llu ",
+		  mstats->mld_leaves[BR_MCAST_DIR_RX]);
+	print_u64(PRINT_ANY, "tx", "TX: %llu\n",
+		  mstats->mld_leaves[BR_MCAST_DIR_TX]);
+	close_json_object();
+
+	print_string(PRINT_FP, NULL,
+		     "%-16s    MLD parse errors: ", "");
+	print_u64(PRINT_ANY, "mld_parse_errors", "%llu\n",
+		  mstats->mld_parse_errors);
+	close_json_object();
+}
+
+static void bridge_print_stats_stp(const struct rtattr *attr)
+{
+	struct bridge_stp_xstats *sstats;
+
+	sstats = RTA_DATA(attr);
+	open_json_object("stp");
+	print_string(PRINT_FP, NULL,
+		     "%-16s    STP BPDU:  ", "");
+	print_u64(PRINT_ANY, "rx_bpdu", "RX: %llu ",
+		  sstats->rx_bpdu);
+	print_u64(PRINT_ANY, "tx_bpdu", "TX: %llu\n",
+		  sstats->tx_bpdu);
+	print_string(PRINT_FP, NULL,
+		     "%-16s    STP TCN:   ", "");
+	print_u64(PRINT_ANY, "rx_tcn", "RX: %llu ",
+		  sstats->rx_tcn);
+	print_u64(PRINT_ANY, "tx_tcn", "TX: %llu\n",
+		  sstats->tx_tcn);
+	print_string(PRINT_FP, NULL,
+		     "%-16s    STP Transitions: ", "");
+	print_u64(PRINT_ANY, "transition_blk", "Blocked: %llu ",
+		  sstats->transition_blk);
+	print_u64(PRINT_ANY, "transition_fwd", "Forwarding: %llu\n",
+		  sstats->transition_fwd);
+	close_json_object();
+}
+
 static void bridge_print_stats_attr(struct rtattr *attr, int ifindex)
 {
 	struct rtattr *brtb[LINK_XSTATS_TYPE_MAX+1];
-	struct bridge_stp_xstats *sstats;
-	struct br_mcast_stats *mstats;
 	struct rtattr *i, *list;
 	const char *ifname = "";
 	int rem;
@@ -738,127 +867,10 @@ static void bridge_print_stats_attr(struct rtattr *attr, int ifindex)
 			continue;
 		switch (i->rta_type) {
 		case BRIDGE_XSTATS_MCAST:
-			mstats = RTA_DATA(i);
-			open_json_object("multicast");
-			open_json_object("igmp_queries");
-			print_string(PRINT_FP, NULL,
-				     "%-16s    IGMP queries:\n", "");
-			print_string(PRINT_FP, NULL, "%-16s      ", "");
-			print_u64(PRINT_ANY, "rx_v1", "RX: v1 %llu ",
-				  mstats->igmp_v1queries[BR_MCAST_DIR_RX]);
-			print_u64(PRINT_ANY, "rx_v2", "v2 %llu ",
-				  mstats->igmp_v2queries[BR_MCAST_DIR_RX]);
-			print_u64(PRINT_ANY, "rx_v3", "v3 %llu\n",
-				  mstats->igmp_v3queries[BR_MCAST_DIR_RX]);
-			print_string(PRINT_FP, NULL, "%-16s      ", "");
-			print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
-				  mstats->igmp_v1queries[BR_MCAST_DIR_TX]);
-			print_u64(PRINT_ANY, "tx_v2", "v2 %llu ",
-				  mstats->igmp_v2queries[BR_MCAST_DIR_TX]);
-			print_u64(PRINT_ANY, "tx_v3", "v3 %llu\n",
-				  mstats->igmp_v3queries[BR_MCAST_DIR_TX]);
-			close_json_object();
-
-			open_json_object("igmp_reports");
-			print_string(PRINT_FP, NULL,
-				     "%-16s    IGMP reports:\n", "");
-			print_string(PRINT_FP, NULL, "%-16s      ", "");
-			print_u64(PRINT_ANY, "rx_v1", "RX: v1 %llu ",
-				  mstats->igmp_v1reports[BR_MCAST_DIR_RX]);
-			print_u64(PRINT_ANY, "rx_v2", "v2 %llu ",
-				  mstats->igmp_v2reports[BR_MCAST_DIR_RX]);
-			print_u64(PRINT_ANY, "rx_v3", "v3 %llu\n",
-				  mstats->igmp_v3reports[BR_MCAST_DIR_RX]);
-			print_string(PRINT_FP, NULL, "%-16s      ", "");
-			print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
-				  mstats->igmp_v1reports[BR_MCAST_DIR_TX]);
-			print_u64(PRINT_ANY, "tx_v2", "v2 %llu ",
-				  mstats->igmp_v2reports[BR_MCAST_DIR_TX]);
-			print_u64(PRINT_ANY, "tx_v3", "v3 %llu\n",
-				  mstats->igmp_v3reports[BR_MCAST_DIR_TX]);
-			close_json_object();
-
-			open_json_object("igmp_leaves");
-			print_string(PRINT_FP, NULL,
-				     "%-16s    IGMP leaves: ", "");
-			print_u64(PRINT_ANY, "rx", "RX: %llu ",
-				  mstats->igmp_leaves[BR_MCAST_DIR_RX]);
-			print_u64(PRINT_ANY, "tx", "TX: %llu\n",
-				  mstats->igmp_leaves[BR_MCAST_DIR_TX]);
-			close_json_object();
-
-			print_string(PRINT_FP, NULL,
-				     "%-16s    IGMP parse errors: ", "");
-			print_u64(PRINT_ANY, "igmp_parse_errors", "%llu\n",
-				  mstats->igmp_parse_errors);
-
-			open_json_object("mld_queries");
-			print_string(PRINT_FP, NULL,
-				     "%-16s    MLD queries:\n", "");
-			print_string(PRINT_FP, NULL, "%-16s      ", "");
-			print_u64(PRINT_ANY, "rx_v1", "RX: v1 %llu ",
-				  mstats->mld_v1queries[BR_MCAST_DIR_RX]);
-			print_u64(PRINT_ANY, "rx_v2", "v2 %llu\n",
-				  mstats->mld_v2queries[BR_MCAST_DIR_RX]);
-			print_string(PRINT_FP, NULL, "%-16s      ", "");
-			print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
-				  mstats->mld_v1queries[BR_MCAST_DIR_TX]);
-			print_u64(PRINT_ANY, "tx_v2", "v2 %llu\n",
-				  mstats->mld_v2queries[BR_MCAST_DIR_TX]);
-			close_json_object();
-
-			open_json_object("mld_reports");
-			print_string(PRINT_FP, NULL,
-				     "%-16s    MLD reports:\n", "");
-			print_string(PRINT_FP, NULL, "%-16s      ", "");
-			print_u64(PRINT_ANY, "rx_v1", "RX: v1 %llu ",
-				  mstats->mld_v1reports[BR_MCAST_DIR_RX]);
-			print_u64(PRINT_ANY, "rx_v2", "v2 %llu\n",
-				  mstats->mld_v2reports[BR_MCAST_DIR_RX]);
-			print_string(PRINT_FP, NULL, "%-16s      ", "");
-			print_u64(PRINT_ANY, "tx_v1", "TX: v1 %llu ",
-				  mstats->mld_v1reports[BR_MCAST_DIR_TX]);
-			print_u64(PRINT_ANY, "tx_v2", "v2 %llu\n",
-				  mstats->mld_v2reports[BR_MCAST_DIR_TX]);
-			close_json_object();
-
-			open_json_object("mld_leaves");
-			print_string(PRINT_FP, NULL,
-				     "%-16s    MLD leaves: ", "");
-			print_u64(PRINT_ANY, "rx", "RX: %llu ",
-				  mstats->mld_leaves[BR_MCAST_DIR_RX]);
-			print_u64(PRINT_ANY, "tx", "TX: %llu\n",
-				  mstats->mld_leaves[BR_MCAST_DIR_TX]);
-			close_json_object();
-
-			print_string(PRINT_FP, NULL,
-				     "%-16s    MLD parse errors: ", "");
-			print_u64(PRINT_ANY, "mld_parse_errors", "%llu\n",
-				  mstats->mld_parse_errors);
-			close_json_object();
+			bridge_print_stats_mcast(i);
 			break;
 		case BRIDGE_XSTATS_STP:
-			sstats = RTA_DATA(i);
-			open_json_object("stp");
-			print_string(PRINT_FP, NULL,
-				     "%-16s    STP BPDU:  ", "");
-			print_u64(PRINT_ANY, "rx_bpdu", "RX: %llu ",
-				  sstats->rx_bpdu);
-			print_u64(PRINT_ANY, "tx_bpdu", "TX: %llu\n",
-				  sstats->tx_bpdu);
-			print_string(PRINT_FP, NULL,
-				     "%-16s    STP TCN:   ", "");
-			print_u64(PRINT_ANY, "rx_tcn", "RX: %llu ",
-				  sstats->rx_tcn);
-			print_u64(PRINT_ANY, "tx_tcn", "TX: %llu\n",
-				  sstats->tx_tcn);
-			print_string(PRINT_FP, NULL,
-				     "%-16s    STP Transitions: ", "");
-			print_u64(PRINT_ANY, "transition_blk", "Blocked: %llu ",
-				  sstats->transition_blk);
-			print_u64(PRINT_ANY, "transition_fwd", "Forwarding: %llu\n",
-				  sstats->transition_fwd);
-			close_json_object();
+			bridge_print_stats_stp(i);
 			break;
 		}
 	}
-- 
2.31.1

