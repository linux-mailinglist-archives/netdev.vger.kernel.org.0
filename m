Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18E7516117
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 02:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbiEAAPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 20:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbiEAAPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 20:15:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719213A1BB
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 17:12:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbM6Lc/U/QSfndN9ecoeUhm8QTpGWiyzS+o7ZPamvklIhPHb5OvFZwUfoqBrU/ih89P91NQuDrdn9QvAdiv2kD8kXBvyofsJ/9eVzPFeoJ0OKU/QkwDjeXkU8E+WqXr3Qd2b1EUmfEnkm3DmMV1ldLQhKSDxaWmMIhxXbb1n8XxIbfmhGwM9ZwOB7CXSnOP4RjpeO6feIBcgWETWLNHC4ZA5eMVLI8mybdHZjnDL9baXMac942QEk/mOXy7gCTP6MJR9S1krnzEuz024/CJQWpq6DSBq0tglO2Ni9kPEtLWesU4jSiIBvIE4vVSfGv9yEm1RA+p8bpEBl+mXuUtx3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21uXHeiJ1Cidj9Bh8U4y4fNHbFw2QOJDe6CzL+eCcY0=;
 b=Zcgr2MUWuqsrsvQTo73woc4i8I48Ur44U8nRtEwyX6Rm1LZBBmLNGrI3OLYyT5HNKhhLO/pys22WyfGOzkvsW0yrbnMSRniTSvi5X7q2ygIrJ2bEn7obK6X+XZBKcp5LqoLwHAO4QtAGeCczO6oUj/puqEWEXcLGE/qZgU+RG9ISMo38Xi3CFB5SqrocDi2BkZy1eCg6STCGvBWIJmxvHZTRui4VPef9dE4zk5NX3rqGRXJh5DT6QZfO2RffKG0oZ/nAsPr6SzDIWnZT14/NfhgNsa6uIBCwEj1Y47rERfLGrrN5b9OgPomLKQOYfDggWWMLHUl01CxJyGY0wXbvzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21uXHeiJ1Cidj9Bh8U4y4fNHbFw2QOJDe6CzL+eCcY0=;
 b=nFsCklsvMD9mGY24F0gh92xkHUxV37JWGQy8U/2PafHkpdZZ433GAOn11hwUIjxxZC0pZsI6TZnwEtqS56XlQcQqOneyDAHCf2FlCP3k6Sl1GIVF9VAfWI47/o1UGLU6rbQJ479a5ULxsib+SDBrjGPssZ6c80QtAcMmljzHfEDpRnlE/5qzw466n1LOrXXYB118pwczA+W96gOPwWxgTeQtd+7UxAswkH8aZCD8KzZGv6Wrqu1xUE+vck3x8x4prxDYnlmXOGDtqeZdZ+psZ7PbU6UjjVZxlhoLJGgq8umOcEGo3KvD+cLW0UFe/WDWVg6ZReqRz6cIU7wQkRjVXA==
Received: from MW4PR02CA0030.namprd02.prod.outlook.com (2603:10b6:303:16d::18)
 by CY4PR12MB1413.namprd12.prod.outlook.com (2603:10b6:903:39::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Sun, 1 May
 2022 00:12:08 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::5f) by MW4PR02CA0030.outlook.office365.com
 (2603:10b6:303:16d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Sun, 1 May 2022 00:12:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Sun, 1 May 2022 00:12:08 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 1 May 2022 00:12:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Sat, 30 Apr 2022 17:12:07 -0700
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sat, 30 Apr 2022 17:12:07 -0700
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <razor@blackwall.org>
Subject: [PATCH iproute2 net-next 3/3] bridge: vni: add support for stats dumping
Date:   Sun, 1 May 2022 00:12:05 +0000
Message-ID: <20220501001205.33782-4-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220501001205.33782-1-roopa@nvidia.com>
References: <20220501001205.33782-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ee0be7c-8a7d-45ab-3d3a-08da2b073b16
X-MS-TrafficTypeDiagnostic: CY4PR12MB1413:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1413D328972149ABCEACD009CBFE9@CY4PR12MB1413.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9n9MQElkpQ7uCI89LgqdBtmJ7GypzGawSkhfkerfRqRTVuE4qLuhzlpcX/ZyRFklh/oC0SYxdhLfH4Ow0vV59jhxjQmXp8WA/f3XQ55+7Up/N08ME6SvBlwYWqa63juPAXmxBKZuFO50tUJDLhUkGqZh4j4tXdg9ZanhKh3Q78tA3aCL6J2nHtDPskrl682eyzGkFCgavJU+wsnYzCLUuw4Nt96RSDN1GzkAqpKl9PnMQOqc70zkzBYUPYnwANuP/ZU2af6bOwsNLbq75DclmsMXoVMNxY3DaRFzKcYkzNTNO8fArpkXpKzkPG4N87sprQ576NM5LwVhtCcNl+LOvo7coDPUfPijQdiI/0GtgHnun9KSo0Yiiarrr1Ot0Dr4I390pZma7g3+50W8IQJUUiH2I1lCWRJO+n8ruhRPbUH6FKZLezUmUzkUxGTP8QtuqmY7tGc0wDcT9XOEZBxLGSK1LZt37qxOcRqBNgwjC+J4IMrW7Mc9MAdlaVUpoN+NROwlpZAtOfoLP/tYwEqt6MnzHwqNQUdUHMQi6d9vdnp8DvTafRyaOzlG6bX3S22tuwccnvkFEiqclQtEUIIXr7avI/CjwW3W9fjyLYNUXcLhGkyPGCC4jXOrP2NFDqlR+bqPhVttH73wdVupLqEi2HPdj3L6K3GS7lT//uvvy9W60dbXwcNgmDFzP2SMxgPxKuVeBwEd6jPg7ukO/E3eg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8936002)(316002)(6916009)(83380400001)(40460700003)(82310400005)(5660300002)(36860700001)(2906002)(36756003)(4326008)(86362001)(8676002)(1076003)(2616005)(47076005)(336012)(426003)(186003)(356005)(81166007)(54906003)(70206006)(70586007)(508600001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2022 00:12:08.1331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee0be7c-8a7d-45ab-3d3a-08da2b073b16
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1413
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 65939b34..28485f8e 100644
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

