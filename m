Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD48951FF08
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiEIOFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbiEIOFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150922AE8
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICtl5QnnQEbyXqf2K2bh0BqzROcLSc6rHeIJlpzZPHLeH68q6OJBhhtXkOyQtwso7AogXU+CpvXyBjPgwWENDKMm/UUI08YZgE+P/hbCGDkwTHNuTXxfHS5QiJ7BS1IGieu3E0J6irm5xmcXyyCGi4whIVQv9jWDqWry/0GIBkgk88ksQ1UvEtInzZ/DzsFe1U6wGKbMWtTInHRAY1X2PUMNflVOtYCb/+peCvChU55+HCK3TRnvr2rpYfBIU0NcUyd92dbTnKdhdJDNOH/KJKO0qrOoswH6pdD4Ro/qkMB41haHqpMzXYHbdlt/iQPNJJRPOAeH3cBWThzD5SUnlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFvrfBGy1WdLlIBul8/wohn13mk8UoHDtjsDDSts2lA=;
 b=U9gEu2ZopTvsmLyvZxAmerrS0I3KAiyj/6gSxD5QuBlu8LP3iLFCo7Werg0wEfr+Aqn9epoiTczDa00thHVEnrJt860ax7tP/llvygG2/Lclh5qZymf3VpKQ6eIob0w2yxET/LQU/CP/xmkNlv6xrk3zCUaLC1mcrdo09cUWArcq2NgKCnWRtelJSjxrFM0hk/74zOlGfvVwgvrfGGhl+znrK8nJt0k3dnszkoil3CsFKRB7YfiLBPIb/PmZRc0KDZfwYdlmWfpqJoZ9MhN19+0FkWJptGmYAQ/8hUr5CUv4LHDEHOs96yYPsn1noBiPxEQs7ad/PkJuvgSaJzKo7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFvrfBGy1WdLlIBul8/wohn13mk8UoHDtjsDDSts2lA=;
 b=GbtM5FAvSW819K31CmTBgXOiaBioA1yqrFlvqBVQXYOayM9er/yHh5hQ5OGony32eQ7uSs6r7Tb6eaSrFuWtDz3kejtYX8TSa52m8qEDwznKcUkXe5hC9/TIaZKKMAJBaYTOF3c3KzfrTJ+N22dPNQkemGP2Cy/wmxCvz8frc02jFg93xOUK363mVvmvrPi8+SxeRNLbCZgEWooM6tZM124aQPf7bMLz65zd/CymCiawK2VAF26Jd5pEYTQkhDTi0a0Q/QE+XrIpoRY9Q6A0ptMcbMKk+P8+salnCKR1lQCZlYR0Iks070njfUw58tCaaGYvp8AtfAJO6uINZ8FJpw==
Received: from DS7PR03CA0040.namprd03.prod.outlook.com (2603:10b6:5:3b5::15)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 14:01:13 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::3e) by DS7PR03CA0040.outlook.office365.com
 (2603:10b6:5:3b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Mon, 9 May 2022 14:01:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:12 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:11 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 03/10] ipstats: Add a group "afstats", subgroup "mpls"
Date:   Mon, 9 May 2022 15:59:56 +0200
Message-ID: <be51b43e2d47850a043947bb0d80537665f225c1.1652104101.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 51c5b734-e978-42db-ceba-08da31c460f2
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5311B5485B564F7CE8CDDAF1D6C69@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ApggOswXBkcVEYl7MXrVFHqvGq0V9nOiFkEFU/a8iPYWKzrEYbfhLgkf9knF5pm3oJlZdecBrc0CTHzJ0UEGGg0G2xVAs93/XvloogRInCJd9739dPBi4gtDgJGYYJzZ2oUDNeezPXy296GsbC4JBKo9gMnjgSv7bJpkZpW/VHyBQ6l0GKE3mTlYe6g/2KfXWUZdrd+TqAhEUAsq3wW61FWUnia8w60K51pAJWkMkjMoeNyGt870VFgjv7y1a40uuic3Ttjc36KhwrCTFqIdCZfcgtPnUCjFZup6L3ox4usW8zeFFHRVs8y705CxJgjzEwOOYMo2LtAMz7a2YcP4L0nWa7QT/2YMywIfQ5HbfoRfTuUJasAnQvUgOjBZDS9rF8P57h/Zj5v7vqswzFnrCKWuxN9OkcgxWlhJ7KRmC5XBuHBTUdmh0bce5Xb+0NFt8O7je+ERk0epNG1Ltm5CLm3W35rvgPyfM+qyivV25fY+ACrN5Y9G0j4hmeaska9e/nJkTmvajiE+4fAhFPxh8DotR696QR02Kq7ilyseaLqd2XwMO8zphqsPowu2sPqPveDiWeJIm3+p92LnHksZ1K9H8dJ3YfpSxdfltgAbBMQ8aLlq5L4OGsx0MxHPivqLKCfdj2oLuJEIK/x7RPJ9brAhU8uG/AtcjhMuTPrpLcMtEYDN6KOPKDX3eUuuogZ8CJ1rNBesqbsGlcQStK9zDw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(81166007)(82310400005)(36756003)(316002)(83380400001)(356005)(2616005)(8936002)(6916009)(8676002)(4326008)(70206006)(70586007)(54906003)(36860700001)(426003)(47076005)(336012)(26005)(107886003)(40460700003)(508600001)(2906002)(5660300002)(16526019)(186003)(6666004)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:13.5129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c5b734-e978-42db-ceba-08da31c460f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new group, "afstats", for showing counters from the
IFLA_STATS_AF_SPEC nest, and a subgroup "mpls" for the AF_MPLS
specifically.

For example:

 # ip -n ns0-NrdgY9sx stats show dev veth01 group afstats
 3: veth01: group afstats subgroup mpls
     RX: bytes packets errors dropped noroute
             0       0      0       0       0
     TX: bytes packets errors dropped
           108       1      0       0

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 ip/iplink.c  |  2 +-
 ip/ipstats.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index c3ff8a5a..d6662343 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1555,7 +1555,6 @@ void print_mpls_link_stats(FILE *fp, const struct mpls_link_stats *stats,
 	print_num(fp, cols[1], stats->tx_packets);
 	print_num(fp, cols[2], stats->tx_errors);
 	print_num(fp, cols[3], stats->tx_dropped);
-	fprintf(fp, "\n");
 }
 
 static void print_mpls_stats(FILE *fp, struct rtattr *attr)
@@ -1571,6 +1570,7 @@ static void print_mpls_stats(FILE *fp, struct rtattr *attr)
 	stats = RTA_DATA(mrtb[MPLS_STATS_LINK]);
 	fprintf(fp, "    mpls:\n");
 	print_mpls_link_stats(fp, stats, "        ");
+	fprintf(fp, "\n");
 }
 
 static void print_af_stats_attr(FILE *fp, int ifindex, struct rtattr *attr)
diff --git a/ip/ipstats.c b/ip/ipstats.c
index 5b9689f4..5b9333e3 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -589,9 +589,63 @@ static const struct ipstats_stat_desc ipstats_stat_desc_toplev_link = {
 	.show = &ipstats_stat_desc_show_link,
 };
 
+static const struct ipstats_stat_desc ipstats_stat_desc_afstats_group;
+
+static void
+ipstats_stat_desc_pack_afstats(struct ipstats_stat_dump_filters *filters,
+			       const struct ipstats_stat_desc *desc)
+{
+	ipstats_stat_desc_enable_bit(filters, IFLA_STATS_AF_SPEC, 0);
+}
+
+static int
+ipstats_stat_desc_show_afstats_mpls(struct ipstats_stat_show_attrs *attrs,
+				    const struct ipstats_stat_desc *desc)
+{
+	struct rtattr *mrtb[MPLS_STATS_MAX+1];
+	struct mpls_link_stats stats;
+	const struct rtattr *at;
+	int err;
+
+	at = ipstats_stat_show_get_attr(attrs, IFLA_STATS_AF_SPEC,
+					AF_MPLS, &err);
+	if (at == NULL)
+		return err;
+
+	parse_rtattr_nested(mrtb, MPLS_STATS_MAX, at);
+	if (mrtb[MPLS_STATS_LINK] == NULL)
+		return -ENOENT;
+
+	IPSTATS_RTA_PAYLOAD(stats, mrtb[MPLS_STATS_LINK]);
+
+	print_nl();
+	open_json_object("mpls_stats");
+	print_mpls_link_stats(stdout, &stats, "    ");
+	close_json_object();
+	return 0;
+}
+
+static const struct ipstats_stat_desc ipstats_stat_desc_afstats_mpls = {
+	.name = "mpls",
+	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
+	.pack = &ipstats_stat_desc_pack_afstats,
+	.show = &ipstats_stat_desc_show_afstats_mpls,
+};
+
+static const struct ipstats_stat_desc *ipstats_stat_desc_afstats_subs[] = {
+	&ipstats_stat_desc_afstats_mpls,
+};
+
+static const struct ipstats_stat_desc ipstats_stat_desc_afstats_group = {
+	.name = "afstats",
+	.kind = IPSTATS_STAT_DESC_KIND_GROUP,
+	.subs = ipstats_stat_desc_afstats_subs,
+	.nsubs = ARRAY_SIZE(ipstats_stat_desc_afstats_subs),
+};
 static const struct ipstats_stat_desc *ipstats_stat_desc_toplev_subs[] = {
 	&ipstats_stat_desc_toplev_link,
 	&ipstats_stat_desc_offload_group,
+	&ipstats_stat_desc_afstats_group,
 };
 
 static const struct ipstats_stat_desc ipstats_stat_desc_toplev_group = {
-- 
2.31.1

