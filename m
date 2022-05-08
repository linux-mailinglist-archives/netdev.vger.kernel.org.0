Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8388351EBD9
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 06:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiEHE5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 00:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiEHE5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 00:57:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06198E0B8
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 21:53:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUQ3cslEP01RQR/33CdofHxFD5aXOGUoXRyjgVhaEYUJNkw9zFDCofYkyDI2wCjvxVsUvj2wGqUBcMceDBfmJhD5CP8W1StzDUvUB2goWgINY4Vfh/WKrS+FFVziin6bqHaxIpo/R71poaYtLjLuBlqNoLcckQG99SKaslw1ngK6uyC9NbnfM9XAP8ekI7J82P0R4phAoHesxSh8urzQ0mMYDpp/SULcjd34cXCN0WMeTzw23P8/hRBmwLLmurvqzTZC8djBXdw1SeA+HK8lhrqZu0/jQ5KI+EOKXbu0xVsgyYOXisds/TNtSXK3EAriu3VxcR6vj4a62iwGBTZv/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yb7WJJk/rKkiZrfJ2hbnnXP/GjqdCPGLEHhz5EOHov0=;
 b=ga3+OguJlKpip0tIOOTJgbMiDIb2ueMNhYTNCAd32iu+H9MSTl9NACjujta9+2eK6I5uHDSbaKGUYmeu+6kN9NVOwx56mAp6FZnzQli3aAKR0xbzjWDdD8cxzh8VD1QpuzVwf3nhkyG5J0eV7LsHr00VaKwDKcVwUASdB+5PdPMUB9TbSiNKP64UpWOmWww+ulg684x+qMYA6JDnb51gghoXkG5PwmgeJqsmM+7btf4dk3AsWo6Xn9DzeVHaq9Uu6w3J9nLXAum5hNWpj4evVDtKxVfW2i5XdNo5A6DqGrtfMGdXApOMfH5OgEuRW4s4M5Jziyjk1nLUlNchIegvzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yb7WJJk/rKkiZrfJ2hbnnXP/GjqdCPGLEHhz5EOHov0=;
 b=jIFdf9guzJtJDSooa+p/NlT8NHN7TvU0tZln2tZww2YuJmKE63dHvF8E8MCUeogjqDBVglTbnASkvZX+LGguN8A0JepbIVaIwzK4D+FETzD9Q2Ik5t0uoY7A13FT8OjqD6od/aM+hVfChX5M4gqesocA0QNf7ryB0vUQbA6To+nmi6VBX/ZPSOpIzuDWyjs9R5FXZk6zmaDaDhHZSFGZUflLUY86ZGIQkWNj70oM3soOxC/K14QddUXbrLgT1yEw6ZSlwaDS0Efi1kkbW8k+n8CV3RvZyMeuyGoBzXybHb6V/ID1NYPPlENWbw0X+pXguYFyyM1owMZ4YEOTKdOtVg==
Received: from DM6PR08CA0023.namprd08.prod.outlook.com (2603:10b6:5:80::36) by
 SN6PR12MB2638.namprd12.prod.outlook.com (2603:10b6:805:6f::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Sun, 8 May 2022 04:53:41 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::38) by DM6PR08CA0023.outlook.office365.com
 (2603:10b6:5:80::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Sun, 8 May 2022 04:53:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 04:53:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 8 May 2022 04:53:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Sat, 7 May 2022 21:53:39 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sat, 7 May 2022 21:53:39 -0700
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <razor@blackwall.org>
Subject: [PATCH iproute2 net-next v2 3/3] bridge: vni: add support for stats dumping
Date:   Sun, 8 May 2022 04:53:40 +0000
Message-ID: <20220508045340.120653-4-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508045340.120653-1-roopa@nvidia.com>
References: <20220508045340.120653-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2369d559-3c25-484f-dcbf-08da30aeb8f5
X-MS-TrafficTypeDiagnostic: SN6PR12MB2638:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB263821509AA71DD6842A88AFCBC79@SN6PR12MB2638.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9j6rHBhKuYQFfUrEcOtEugx7H1hhlBt3T22+QcKvpDTnpiNHKm0PmOfHik1pvslN+VQ3O/UUSpHAAXYRACbtTXsICoQBE1FPzng/wxDedPPxWLG8jT/cA1XRbpsDk4HnTapXgIvxxCQFUAoi9HsqEizjxoUx5VGNoLcomo96TDRaoI8raaYOyKBEwCm2dwwN0mL65LAYkD00dlNPXzqCKJsiwTZH++qlABRl6mkK9pzI9nOd6J1ty1FT+IFejVkCLdepNrUik2wZ40k4rP+r0JaNWLI3eu7YFT/CyP64QjvuVKLVNVI6yeUo2shTmPkazhp/TnfAIIsLKUZziJC1K3QlZwcTB5any+Y87QMphvIbaoHJg3VW6xZ0g9dV1w3c9aQ+SgkaOEcz5YOXEuP4dD4r0oo2E1nTXwjJgEp68mVbt7Ctw35OXTYpJETG3KHexU4YRTZgjZoP6IsPdJeew0PEvApWnFlft1P65/YdUDK3BUgQQNwa3o4bnHLzaogDTTyXDscahnEQsDramC2EHuRwj6S/75mAUPf2+dVgw5tvjoB/sjFSQE47AdW37v1ioEcjOVC9PHBCPjHj54F2VQVs0zwF2M/AOexoD2zloi4zr3Hx4ekQGmIWUirNSakbX9O1uOXxAEtdQiknfG7fZJU5XSM7FqjPE4ks2gNplNswvWqZuMzwVjZYbqvHgbnoaCEbTVjrZMn8NjxqVoA+FQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(336012)(47076005)(2906002)(5660300002)(83380400001)(54906003)(426003)(186003)(6916009)(8936002)(36756003)(1076003)(316002)(2616005)(36860700001)(86362001)(40460700003)(70206006)(70586007)(82310400005)(26005)(8676002)(4326008)(6666004)(508600001)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 04:53:41.0659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2369d559-3c25-484f-dcbf-08da30aeb8f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2638
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for "-s" option which causes bridge vni to dump per-vni
statistics. Note that it disables vni range compression.

Example:
$ bridge -s vni | more
 dev               vni              group/remote
 vxlan0             1024  239.1.1.1
                     RX: bytes 0 pkts 0 drops 0 errors 0
                     TX: bytes 0 pkts 0 drops 0 errors 0
                    1025  239.1.1.1
                     RX: bytes 0 pkts 0 drops 0 errors 0
                     TX: bytes 0 pkts 0 drops 0 errors 0

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 bridge/vni.c         | 93 ++++++++++++++++++++++++++++++++++++--------
 include/libnetlink.h |  3 +-
 lib/libnetlink.c     |  4 +-
 3 files changed, 81 insertions(+), 19 deletions(-)

diff --git a/bridge/vni.c b/bridge/vni.c
index 79dff005..a0c2792c 100644
--- a/bridge/vni.c
+++ b/bridge/vni.c
@@ -186,6 +186,59 @@ static void print_range(const char *name, __u32 start, __u32 id)
 
 }
 
+static void print_vnifilter_entry_stats(struct rtattr *stats_attr)
+{
+	struct rtattr *stb[VNIFILTER_ENTRY_STATS_MAX+1];
+	__u64 stat;
+
+	open_json_object("stats");
+	parse_rtattr_flags(stb, VNIFILTER_ENTRY_STATS_MAX, RTA_DATA(stats_attr),
+			   RTA_PAYLOAD(stats_attr), NLA_F_NESTED);
+
+	print_nl();
+	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s   ", "");
+	print_string(PRINT_FP, NULL, "RX: ", "");
+
+	if (stb[VNIFILTER_ENTRY_STATS_RX_BYTES]) {
+		stat = rta_getattr_u64(stb[VNIFILTER_ENTRY_STATS_RX_BYTES]);
+		print_lluint(PRINT_ANY, "rx_bytes", "bytes %llu ", stat);
+	}
+	if (stb[VNIFILTER_ENTRY_STATS_RX_PKTS]) {
+		stat = rta_getattr_u64(stb[VNIFILTER_ENTRY_STATS_RX_PKTS]);
+		print_lluint(PRINT_ANY, "rx_pkts", "pkts %llu ", stat);
+	}
+	if (stb[VNIFILTER_ENTRY_STATS_RX_DROPS]) {
+		stat = rta_getattr_u64(stb[VNIFILTER_ENTRY_STATS_RX_DROPS]);
+		print_lluint(PRINT_ANY, "rx_drops", "drops %llu ", stat);
+	}
+	if (stb[VNIFILTER_ENTRY_STATS_RX_ERRORS]) {
+		stat = rta_getattr_u64(stb[VNIFILTER_ENTRY_STATS_RX_ERRORS]);
+		print_lluint(PRINT_ANY, "rx_errors", "errors %llu ", stat);
+	}
+
+	print_nl();
+	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s   ", "");
+	print_string(PRINT_FP, NULL, "TX: ", "");
+
+	if (stb[VNIFILTER_ENTRY_STATS_TX_BYTES]) {
+		stat = rta_getattr_u64(stb[VNIFILTER_ENTRY_STATS_TX_BYTES]);
+		print_lluint(PRINT_ANY, "tx_bytes", "bytes %llu ", stat);
+	}
+	if (stb[VNIFILTER_ENTRY_STATS_TX_PKTS]) {
+		stat = rta_getattr_u64(stb[VNIFILTER_ENTRY_STATS_TX_PKTS]);
+		print_lluint(PRINT_ANY, "tx_pkts", "pkts %llu ", stat);
+	}
+	if (stb[VNIFILTER_ENTRY_STATS_TX_DROPS]) {
+		stat = rta_getattr_u64(stb[VNIFILTER_ENTRY_STATS_TX_DROPS]);
+		print_lluint(PRINT_ANY, "tx_drops", "drops %llu ", stat);
+	}
+	if (stb[VNIFILTER_ENTRY_STATS_TX_ERRORS]) {
+		stat = rta_getattr_u64(stb[VNIFILTER_ENTRY_STATS_TX_ERRORS]);
+		print_lluint(PRINT_ANY, "tx_errors", "errors %llu ", stat);
+	}
+	close_json_object();
+}
+
 static void print_vni(struct rtattr *t, int ifindex)
 {
 	struct rtattr *ttb[VXLAN_VNIFILTER_ENTRY_MAX+1];
@@ -242,6 +295,10 @@ static void print_vni(struct rtattr *t, int ifindex)
 							 &addr));
 		}
 	}
+
+	if (ttb[VXLAN_VNIFILTER_ENTRY_STATS])
+		print_vnifilter_entry_stats(ttb[VXLAN_VNIFILTER_ENTRY_STATS]);
+
 	close_json_object();
 	print_string(PRINT_FP, NULL, "%s", _SL_);
 }
@@ -310,6 +367,7 @@ static int print_vnifilter_rtm_filter(struct nlmsghdr *n, void *arg)
 static int vni_show(int argc, char **argv)
 {
 	char *filter_dev = NULL;
+	__u8 flags = 0;
 	int ret = 0;
 
 	while (argc > 0) {
@@ -330,25 +388,26 @@ static int vni_show(int argc, char **argv)
 
 	new_json_obj(json);
 
-	if (!show_stats) {
-		if (rtnl_tunneldump_req(&rth, PF_BRIDGE, filter_index) < 0) {
-			perror("Cannot send dump request");
-			exit(1);
-		}
+	if (show_stats)
+		flags = TUNNEL_MSG_FLAG_STATS;
 
-		if (!is_json_context()) {
-			printf("%-" __stringify(IFNAMSIZ) "s  %-"
-			       __stringify(VXLAN_ID_LEN) "s  %-"
-			       __stringify(15) "s",
-			       "dev", "vni", "group/remote");
-			printf("\n");
-		}
+	if (rtnl_tunneldump_req(&rth, PF_BRIDGE, filter_index, flags) < 0) {
+		perror("Cannot send dump request");
+		exit(1);
+	}
 
-		ret = rtnl_dump_filter(&rth, print_vnifilter_rtm_filter, NULL);
-		if (ret < 0) {
-			fprintf(stderr, "Dump ternminated\n");
-			exit(1);
-		}
+	if (!is_json_context()) {
+		printf("%-" __stringify(IFNAMSIZ) "s  %-"
+		       __stringify(VXLAN_ID_LEN) "s  %-"
+		       __stringify(15) "s",
+		       "dev", "vni", "group/remote");
+		printf("\n");
+	}
+
+	ret = rtnl_dump_filter(&rth, print_vnifilter_rtm_filter, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "Dump ternminated\n");
+		exit(1);
 	}
 
 	delete_json_obj();
diff --git a/include/libnetlink.h b/include/libnetlink.h
index a1ec91ec..a7b0f352 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -112,7 +112,8 @@ int rtnl_nexthop_bucket_dump_req(struct rtnl_handle *rth, int family,
 				 req_filter_fn_t filter_fn)
 	__attribute__((warn_unused_result));
 
-int rtnl_tunneldump_req(struct rtnl_handle *rth, int family, int ifindex)
+int rtnl_tunneldump_req(struct rtnl_handle *rth, int family, int ifindex,
+			__u8 flags)
 	__attribute__((warn_unused_result));
 
 struct rtnl_ctrl_data {
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index b3c3d0ba..c27627fe 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1610,7 +1610,8 @@ void nl_print_policy(const struct rtattr *attr, FILE *fp)
 	}
 }
 
-int rtnl_tunneldump_req(struct rtnl_handle *rth, int family, int ifindex)
+int rtnl_tunneldump_req(struct rtnl_handle *rth, int family, int ifindex,
+			__u8 flags)
 {
 	struct {
 		struct nlmsghdr nlh;
@@ -1622,6 +1623,7 @@ int rtnl_tunneldump_req(struct rtnl_handle *rth, int family, int ifindex)
 		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
 		.nlh.nlmsg_seq = rth->dump = ++rth->seq,
 		.tmsg.family = family,
+		.tmsg.flags = flags,
 		.tmsg.ifindex = ifindex,
 	};
 
-- 
2.25.1

