Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415E750B2F6
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445518AbiDVIer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445527AbiDVIeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383D352E65
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WS3+Z8eAFeDiPyA11+rIyUQ9UUJEYODyktbYZgIBH05QnwriHY5HR2zPCmMoK/nap6S3fj4dcSC4EPIvy2S2FguTAf/aP3SQgIh2HpygGVvHwJMi2T61VFxsiMdOYKMxfQuGD1fs/JzMr+0NaszX+9TDt9i0N9KFQWhlZNVHvx5nPxxIikx6+ouYG0S1Vavjz4bzaZWlRHctT1NRQ15z143wBnMYeUMUWxyO/dqvLApguAOhqygSLwgNw2xRlXn4gK4ax5Q2TouTZRFIp1AxjdfkZYDmIR9ySLlbzOjm2r4JxZXgQIcwuoPqMEg58iC4MldpRoojPOzQCkxjIVLscg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckMCROME+WX4LEg6mdRK4Hx+V09UqspIiEM5/B0+Owg=;
 b=j0vJz2R+SBjB2xM1GQLgrRkxPPUCEz2f5SJbj1C5g0MHvCScNzJQZX3gOrV9pjysiEeZtcbRVn/aMnxQ7JPlIXBvfmBrlxZwB8iplSC0A1jMCYvgzDeQ9bQbRwwbj7M6Lss1z4qjcPYOKTXLZdeiL7c4j4jAD2uwud+tuZtlXFUCKlbUQu3UQgXClhF5grp6eESotjs58R0gjT5cc074usLJqF717RoRX5OC1fO4exJQMeedCNXEgQZYXEGEl3qYcSCYL+2buY73TS5fKVRo1eaTC9A1ouhPFBscaN0DM9FiZ1YNH7vI4GS5GbvIrXCmkpoyjZT0TQRX/2gGCxsEzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckMCROME+WX4LEg6mdRK4Hx+V09UqspIiEM5/B0+Owg=;
 b=TEul+EGCn9/rvGoHkYmIf4EuYoyWj/s0yqo0wBbNe1+IVGUk/gn+BXi3mbh/Q4p/QK5l/lr6G7PfwtvMDl8glvJpqZs9aAjW4dxeXIkB+XUpyUGesKaXqKDBccaEBxzRlGKhoPCcPamahsFj0dDcbPQTC0khVjVazwu1WXGX6P/WRKwrfI5yo0HbAQvdCY07CPhWeXr3daXCuxZ+H8bN7Wugbh/dQIop35yt8oQPsdAEkvzAsFRhtUsdq4ndpQYdnUImjHHeYEBVT33ACjUzcN3WtsKOGp+ESFuUvjRNHTWTr9c8fnH0zeC4CTBRX66BEbUgFzt2Vw18IDAHplDhzw==
Received: from MW4PR04CA0207.namprd04.prod.outlook.com (2603:10b6:303:86::32)
 by BN8PR12MB3235.namprd12.prod.outlook.com (2603:10b6:408:6e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 08:31:42 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::dc) by MW4PR04CA0207.outlook.office365.com
 (2603:10b6:303:86::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:40 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:39 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 07/11] ipstats: Add a group "offload", subgroup "cpu_hit"
Date:   Fri, 22 Apr 2022 10:30:56 +0200
Message-ID: <a785c2d5c8a0b11f4e9b401907c143a185caf98b.1650615982.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: ac09d0a0-951a-4b1f-75cb-08da243a86dd
X-MS-TrafficTypeDiagnostic: BN8PR12MB3235:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3235F5E44D49610FCC687DE8D6F79@BN8PR12MB3235.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PoYeVVWHDiHXND+KdnwwMFbLEgTjFhLWNXpqhIlBgWBqaT/n3wGVkXgwL36euR4jsAFcJszYeSwcl9jNMCNEXfTapIf2BYNO5sbp1vWV0Wq2bRblTAyF1hWZRFNtZ/oFWg/MwJWkya+sUktdrxIOxXpclNJLZWzLyO1OwE//qhK1t08LpC5hyWf115NaphskFTKKNxX88h9NDCphMJZY/f6EW8ntyBOST2GuRU/Mt9PDyxyjjqZANWkRLjTzydWa5fvTv6h8qzj5CpuaTiGyxbey9810WHdaIiF6+kfqYe5tiIErjcg0C0IfpmALxG5zeMKmtGRQnTaylzv8uxWpckoCaTxOUONrZeLrJqpKFQzvF2VA6HS6sbYRMl3UGQF+BlLXcNcfkzp02dr6TI01MtvC5fPyHWIZpPOHg32k0kHXqpWf9Vf41DWdDtxE/w+Yzl2cqxeFYsNPz9Y+15LJfJL5CdU2ZWKyEShRrH2PFnQ6bkxtg59vKu8RIujAYPK/0bCLecIN/+oz1Mjhf5QBmL0ocP9xXo9GDUOFjRCTsngdwyNOtSOeUIdUJUo3JUHBo140CDOiYVz8yL1LJnd1h9FPIFfzfvyy1JohSZaw4AUefFJcYzrZkpkZ1+pvdmHaLX3nohuslQybWyi9EYi1JGaOwNn7NcGzlB2Be01eJIqMdL41B07FLiscZDU/+NPxQn3b/y1u8ZrAIxwNeYCOfg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2906002)(426003)(356005)(8936002)(6666004)(26005)(508600001)(70206006)(70586007)(107886003)(186003)(336012)(16526019)(54906003)(6916009)(316002)(2616005)(81166007)(36756003)(86362001)(40460700003)(36860700001)(8676002)(4326008)(47076005)(82310400005)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:41.4616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac09d0a0-951a-4b1f-75cb-08da243a86dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3235
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new group, "offload", for showing counters from the
IFLA_STATS_LINK_OFFLOAD_XSTATS nest, and a subgroup "cpu_hit" for the
IFLA_OFFLOAD_XSTATS_CPU_HIT stats suite.

For example:

 # ip stats show dev swp1 group offload subgroup cpu_hit
 4178: swp1: group offload subgroup cpu_hit
     RX:  bytes packets errors dropped  missed   mcast
          45522     353      0       0       0       0
     TX:  bytes packets errors dropped carrier collsns
          46054     355      0       0       0       0

 # ip -j stats show dev swp1 group offload subgroup cpu_hit | jq
 [
   {
     "ifindex": 4178,
     "ifname": "swp1",
     "group": "offload",
     "subgroup": "cpu_hit",
     "stats64": {
       "rx": {
         "bytes": 45522,
         "packets": 353,
         "errors": 0,
         "dropped": 0,
         "over_errors": 0,
         "multicast": 0
       },
       "tx": {
         "bytes": 46054,
         "packets": 355,
         "errors": 0,
         "dropped": 0,
         "carrier_errors": 0,
         "collisions": 0
       }
     }
   }
 ]

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipstats.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index e4f97ddd..283fba4e 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -164,6 +164,42 @@ static int ipstats_show_64(struct ipstats_stat_show_attrs *attrs,
 	return 0;
 }
 
+static void
+ipstats_stat_desc_pack_cpu_hit(struct ipstats_stat_dump_filters *filters,
+			       const struct ipstats_stat_desc *desc)
+{
+	ipstats_stat_desc_enable_bit(filters,
+				     IFLA_STATS_LINK_OFFLOAD_XSTATS,
+				     IFLA_OFFLOAD_XSTATS_CPU_HIT);
+}
+
+static int ipstats_stat_desc_show_cpu_hit(struct ipstats_stat_show_attrs *attrs,
+					  const struct ipstats_stat_desc *desc)
+{
+	print_nl();
+	return ipstats_show_64(attrs,
+			       IFLA_STATS_LINK_OFFLOAD_XSTATS,
+			       IFLA_OFFLOAD_XSTATS_CPU_HIT);
+}
+
+static const struct ipstats_stat_desc ipstats_stat_desc_offload_cpu_hit = {
+	.name = "cpu_hit",
+	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
+	.pack = &ipstats_stat_desc_pack_cpu_hit,
+	.show = &ipstats_stat_desc_show_cpu_hit,
+};
+
+static const struct ipstats_stat_desc *ipstats_stat_desc_offload_subs[] = {
+	&ipstats_stat_desc_offload_cpu_hit,
+};
+
+static const struct ipstats_stat_desc ipstats_stat_desc_offload_group = {
+	.name = "offload",
+	.kind = IPSTATS_STAT_DESC_KIND_GROUP,
+	.subs = ipstats_stat_desc_offload_subs,
+	.nsubs = ARRAY_SIZE(ipstats_stat_desc_offload_subs),
+};
+
 static void
 ipstats_stat_desc_pack_link(struct ipstats_stat_dump_filters *filters,
 			    const struct ipstats_stat_desc *desc)
@@ -189,6 +225,7 @@ static const struct ipstats_stat_desc ipstats_stat_desc_toplev_link = {
 
 static const struct ipstats_stat_desc *ipstats_stat_desc_toplev_subs[] = {
 	&ipstats_stat_desc_toplev_link,
+	&ipstats_stat_desc_offload_group,
 };
 
 static const struct ipstats_stat_desc ipstats_stat_desc_toplev_group = {
-- 
2.31.1

