Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7569650B2F0
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445527AbiDVIew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445530AbiDVIeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCCF52E77
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0RkFdiwWfMuOxBLXhgcM4OJrw22C0wcshyt/ZasshrlA8EUBs4ViWInynJCf+33U5io6B4EhmFEn52U4Z8DqJCmRES9dcNbf/zifrGhEwD4WSJ4ORetxqSRv6RIEL8lIDJq/jKGf2Je524j7BcJjhBWmVx0aRwfsT9VxILPYKO0xSsGb0LwFkk+dmgPusmhC2piBDSQxM+3eij+wrVQeM++vbbWprzc766FLhEOEF+o35bXSWUkqIQ5YlfDwViHDrIYDraorFOIQ/CmlYcLqQDD7HOK9cxHm4XMUi898pYqC+0bE6E9u4yXOMunqvc146BGb/IIiLMflUOGnWpZ6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roINls9zHxI0KLFTVbHBZSRS3ArvIzeIf0TBJ+gJYDI=;
 b=S0ZZT1HpHUiCORWdu7pADB3Xp3h7NZWuwATri0+7b3xBdFkaQT3yd6ZJzupVkYvJy9TdP8KVl1uwKvjDtadvxLMD3NQI4dTFbKaVa7Lq1cORvCdy4Dtj9wB8CJ+eBD2vdTPpfKMABqAPVWm8z7OWU6galmlazbRE8o07GgtpSTDYHQNql3EIqpSKlrVBoZ7ohIPgr7HMCijVXNNX1dekB5rlhWdQSFXL8XAsjtF+DMk9ttyOR6hkfhF0yZOEgOKlIVn67tNjzoyCCnnoTORn4BwDvjAO77h/djniklcoz0DxWv1lKrBaga90DIg56mi0HEWvNr5Is4+oYkaYWizccg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roINls9zHxI0KLFTVbHBZSRS3ArvIzeIf0TBJ+gJYDI=;
 b=lOywx6+B7XQNfg9p8J5oVMrgY5JlRiZzfhXwa5pevTgNNuf1ELPT+ngY8RZf583V+wn+P7TFbGrMy9gc/wLDMcyDHQYUyOj0DmJsuP75fO0kevOSUuIDEJL+SfmeiiQuhwagzjuTHjtrJrO3EYNLIr/JV27NBJ2wKIljudMpe/ItzX5kMgraQ0GAAucsQ+lI4D1XjnPQXzXYQ8I51DAgt8po9A1DEa+zB0puJfedCpdaLnOCFs+3kTrcR/Xr2EzBPVscvRNg/CnqKiASwZo+m1Kx9T0owYUKGp2j3u2B+NDvR5kLwFGhYgsS7RaX8DWEg2MBizLQJZPPQAazgmBxsw==
Received: from BN1PR10CA0026.namprd10.prod.outlook.com (2603:10b6:408:e0::31)
 by DS7PR12MB5960.namprd12.prod.outlook.com (2603:10b6:8:7f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 08:31:47 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::ef) by BN1PR10CA0026.outlook.office365.com
 (2603:10b6:408:e0::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:46 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:44 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 10/11] ipmonitor: Add monitoring support for stats events
Date:   Fri, 22 Apr 2022 10:30:59 +0200
Message-ID: <ae995f60da050d62842b4657e160be47b0786678.1650615982.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: a7337dc7-aa9d-4620-a400-08da243a8a32
X-MS-TrafficTypeDiagnostic: DS7PR12MB5960:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5960A92C480BF1A2AA15CEC2D6F79@DS7PR12MB5960.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBpWi+sDna/x2NIgzg8Bt8Uw35htZxIB+bVoCCh2/IaheK1KRDTIdAKCPg3Niw1tb0HlxEqtGI4pnRNRB3RmpRSSTYlWxO/6nNn0+wGN9JpxdH1CLfJvKymN0Js1FhLRoaAN2h2tGpyEQIqg9EGuy2PLqMoUU6U7qmcDp/Dn5QHscVcOb60iA9D2EnQ5wuqU3em5mIQ8L5ZcfAEUnjRd6o6AZwPIuxe1HKdpcXBseF/V+F0K8zNF39da9CvtWir8WdybZkYs6xHCBQCvR8R49pWOWDS9fFrEkcUBXdGrbXnNfyRDq1NDBUymraY69jj63U9uLYegBUWQf1CNyWSindPAAs7tMoW2DRM3Y8nZM1h8X2uTlkAa9h59koYvBr1uH4lgJOJctEeYRXYIrejdGQe4ajD1EAV28Fvt7Sy6M/TN1MyJFsThdqdlJJzcyLhQFzmixqxUMoBdeUQfiTrkMREzb8hPak6AAqkpupFYDfrXEij2h4DakRQ97OdRaKhFEMWilfv4G+rx+ZcmStrReGuaiT5imhn8H6NeFkiofzRgZmKOjQN0k4GgI72argcuxw93V+EGJ8Aq2mbelajocw5aRFpegSveCbLB61URbvAzI2FODffmo+AEYjpBhpgLFU5x35cET0yVT++GmxduhZB7+4mGYyTEgJTAK1V4pohyH3cUyV9zR96fmYSBi+3Tgjm0WKMMXIlydDDBZl6VTA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2906002)(26005)(81166007)(356005)(36860700001)(8936002)(36756003)(5660300002)(107886003)(2616005)(16526019)(186003)(40460700003)(6666004)(4326008)(508600001)(83380400001)(82310400005)(47076005)(336012)(426003)(6916009)(8676002)(86362001)(316002)(54906003)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:46.9905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7337dc7-aa9d-4620-a400-08da243a8a32
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5960
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toggles and offloads of HW statistics cause emission of and RTM_NEWSTATS
event. Add support to "ip monitor" for these events.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ip_common.h |  1 +
 ip/ipmonitor.c | 16 +++++++++++++++-
 ip/ipstats.c   | 20 ++++++++++++++++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index 8b0a6426..9eeeb387 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -57,6 +57,7 @@ int print_nexthop_bucket(struct nlmsghdr *n, void *arg);
 void netns_map_init(void);
 void netns_nsid_socket_init(void);
 int print_nsid(struct nlmsghdr *n, void *arg);
+int ipstats_print(struct nlmsghdr *n, void *arg);
 char *get_name_from_nsid(int nsid);
 int get_netnsid_from_name(const char *name);
 int set_netnsid_from_name(const char *name, int nsid);
diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 0badda4e..a4326d2a 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -34,7 +34,7 @@ static void usage(void)
 		"Usage: ip monitor [ all | OBJECTS ] [ FILE ] [ label ] [ all-nsid ]\n"
 		"                  [ dev DEVICE ]\n"
 		"OBJECTS :=  address | link | mroute | neigh | netconf |\n"
-		"            nexthop | nsid | prefix | route | rule\n"
+		"            nexthop | nsid | prefix | route | rule | stats\n"
 		"FILE := file FILENAME\n");
 	exit(-1);
 }
@@ -158,6 +158,11 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 		print_nsid(n, arg);
 		return 0;
 
+	case RTM_NEWSTATS:
+		print_headers(fp, "[STATS]", ctrl);
+		ipstats_print(n, arg);
+		return 0;
+
 	case NLMSG_ERROR:
 	case NLMSG_NOOP:
 	case NLMSG_DONE:
@@ -185,6 +190,7 @@ int do_ipmonitor(int argc, char **argv)
 	int lprefix = 0;
 	int lneigh = 0;
 	int lnetconf = 0;
+	int lstats = 0;
 	int lrule = 0;
 	int lnsid = 0;
 	int ifindex = 0;
@@ -253,6 +259,9 @@ int do_ipmonitor(int argc, char **argv)
 		} else if (matches(*argv, "nexthop") == 0) {
 			lnexthop = 1;
 			groups = 0;
+		} else if (strcmp(*argv, "stats") == 0) {
+			lstats = 1;
+			groups = 0;
 		} else if (strcmp(*argv, "all") == 0) {
 			prefix_banner = 1;
 		} else if (matches(*argv, "all-nsid") == 0) {
@@ -349,6 +358,11 @@ int do_ipmonitor(int argc, char **argv)
 		exit(1);
 	}
 
+	if (lstats && rtnl_add_nl_group(&rth, RTNLGRP_STATS) < 0) {
+		fprintf(stderr, "Failed to add stats group to list\n");
+		exit(1);
+	}
+
 	if (listen_all_nsid && rtnl_listen_all_nsid(&rth) < 0)
 		exit(1);
 
diff --git a/ip/ipstats.c b/ip/ipstats.c
index 29ca0731..39ddca01 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -1219,3 +1219,23 @@ int do_ipstats(int argc, char **argv)
 
 	return rc;
 }
+
+int ipstats_print(struct nlmsghdr *n, void *arg)
+{
+	struct ipstats_stat_enabled_one one = {
+		.desc = &ipstats_stat_desc_offload_hw_s_info,
+	};
+	struct ipstats_stat_enabled enabled = {
+		.enabled = &one,
+		.nenabled = 1,
+	};
+	FILE *fp = arg;
+	int rc;
+
+	rc = ipstats_process_ifsm(n, &enabled);
+	if (rc)
+		return rc;
+
+	fflush(fp);
+	return 0;
+}
-- 
2.31.1

