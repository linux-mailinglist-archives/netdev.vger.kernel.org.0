Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A32B50B2F7
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445524AbiDVIec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445513AbiDVIe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:28 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33E852E4D
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVngiv6mNEenOcqws36XwQf7AHlF5dXGeaEIK22zwbpaqBr8KKgDqR/R2R9GXMkzTrfA1wCYkMvsK04FYoKSvIj1Mx7t+pj8MdGLjonEbW2e5xgiM5m/PFvljrim/ifEDqMfhpXw35ojU9mVohXi1AKin3sD7lXHgBZhvCDAciiKxLeXcd2UPKi5QtMQ1x2c3Y1bQmCQRatA5joK9yG/YBA3oCNVK9io5/2FejVOUSDf3I+ZJiSU/2WTo+L4SjFcdlZdzZp8/kWrDV7UxAE5Vpo6GTvpd1e/ER9+CLHtp8+UpBclicfhXCAX7LQRybPe/lpHw/WBc9acXGolJsfzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ti9qkNLUjZZzjnR8TBB/HmItok1HQ11ZfgUYNsRHNjk=;
 b=QaTzUBR2leeyoO9+k0HIwXKbJIZXZJHcDbwigeCzr86AtmFF4knO3jv2bK38pFQ/hxuC7/kaheK8o2IfwCMv+Ftu0utVSzLSxhZXxIpTggw4700tY1GpSPpOC29d6OWRSxrz71BF7DMRvck73OM9qKUyPDqLDKwi4YagRrhXmYc6kDbJpcgOheDdJaxz59LDnXHnwR+inhDh8H1G4o1nscRy1iCE27wAyvax4S+i7JAenxCPj8UlqsagaTai/aYXtnKfCNCT16adhjfurv+5IhznE/8M0mjF+PX6pGj8cl7fjtceeEmiAKAd1357WVUes4UMczOTOTV8D1J6ZB7wZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ti9qkNLUjZZzjnR8TBB/HmItok1HQ11ZfgUYNsRHNjk=;
 b=k2axw7qUcTJhayVVszrr5GR40OV5srMOYAAdosJNkEf8r29SBTYzTB4xfcQ2hSVcWboX+4w0yJKreJ8Lq/l573kAY+GiR/OMyvrkG5i3UTbPEejXu7pPYpflc2ZNxRccoBVon2BEZeimJ/3FBeg0Lns2ZQ0HJ/kvd09wxl4L79rWVis0NS3JEE3ekHuHlbT2T3RWAsFzPm5Hx4TCeSGqlxy8DSi55VK2LKzGY2+mZo8fvdtDZPF53YafuYzcLLdZB5+tO7f+ewvl998nJb5XBNPNqo2YlcACqEU6rIY4Z2pTxLg8UFr8kt5N3jrKDtDmfuwPHu6w+e4ByRnDEWf0mg==
Received: from DM6PR06CA0089.namprd06.prod.outlook.com (2603:10b6:5:336::22)
 by MN2PR12MB4302.namprd12.prod.outlook.com (2603:10b6:208:1de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 08:31:31 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::bd) by DM6PR06CA0089.outlook.office365.com
 (2603:10b6:5:336::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:30 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:28 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 01/11] libnetlink: Add filtering to rtnl_statsdump_req_filter()
Date:   Fri, 22 Apr 2022 10:30:50 +0200
Message-ID: <0a0459d981354797db52a1c037c677f75d24b0e2.1650615982.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6362c433-efa1-4d55-cd19-08da243a80aa
X-MS-TrafficTypeDiagnostic: MN2PR12MB4302:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4302F71AE07CF6767F2239A1D6F79@MN2PR12MB4302.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WI3kesQiZTZG33/7Ck2nJcuZGbeFDdronbmHZ9c59klAYUH5NfwQP7wZn9SFEHrqTqPriMpaioCy605iHkfIP52j72kjU0z1tul7mXLnyyOxug0a+RYn3jgKO+342H0KQkOnNrCMguvEBM8pIRYjA4JGvNDXpW862et1sGuw2ABn2fZR4Bq11axb3rapZuZHFJRCEYJGzuTWQyjd8ekcTqIwoO9Pv8koie62fDBar34mBd7HfGn25fX0Xa5ChSDkqcAlFMUf3DA5Y1hvwDqaizio0v0WJfjCzDqyuTrE59UjSxTFm1R8wYHXy50pQWR8pZ4jO6Ie5tWHRQ4bzBKQ2ETkxglBDQ8Ry2Okvm/WMGXC8YkdK7VLTPPjELFl/s5iv0FuHbAC2Ou3NNDWcxjEu5BIumFqaTGT0R6HSJOzDRIZgjDT3CJFEgVvPFvE66D0MunrHDAbvFZhyxKLiyq+z/MNCJhH7jrDgDTO3rNsdtrWdDtHBplVv+XLvxPHAQ8ux++TuJfy5erMGCJF8nZ9lQSOrtfkelxCt927EWm+rh2ZGC6c1YlM5KCUQo0iR4rQXSe0R1T6ETdWQAw/tsqgGtDb2rpQ6CADYIEgtTAlH1FmWCHdKISW4oswIWpBDysA5P59Y4QeC4sxP0h8bUlFbvHvCPHgfEgudXnkZ6D5eI19D9gqaIR3m2EbsCYliSOS9LZWLWwx1SThEGy0Rb0V2Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36756003)(316002)(40460700003)(8676002)(70586007)(81166007)(70206006)(356005)(6666004)(4326008)(6916009)(2906002)(5660300002)(82310400005)(86362001)(54906003)(8936002)(107886003)(83380400001)(508600001)(36860700001)(47076005)(26005)(16526019)(336012)(2616005)(426003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:31.0476
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6362c433-efa1-4d55-cd19-08da243a80aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4302
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of functions in the rtnl_*_req family accept a caller-provided
callback to set up arbitrary filtering. rtnl_statsdump_req_filter()
currently only allows setting a field in the IFSM header, not custom
attributes. So far these were not necessary, but with introduction of more
detailed filtering settings, the callback becomes necessary.

To that end, add a filter_fn and filter_data arguments to the function.
Unlike the other filters, this one is typed to expect an IFSM pointer, to
permit tweaking the header itself as well.

Pass NULLs in the existing callers.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/vlan.c        |  6 ++++--
 include/libnetlink.h | 11 ++++++++++-
 ip/iplink.c          |  3 ++-
 ip/iplink_xstats.c   |  3 ++-
 lib/libnetlink.c     | 19 ++++++++++++++-----
 misc/ifstat.c        |  2 +-
 6 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 8300f353..390a2037 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -1179,7 +1179,8 @@ static int vlan_show(int argc, char **argv, int subject)
 		__u32 filt_mask;
 
 		filt_mask = IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_XSTATS);
-		if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask) < 0) {
+		if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask,
+					      NULL, NULL) < 0) {
 			perror("Cannot send dump request");
 			exit(1);
 		}
@@ -1194,7 +1195,8 @@ static int vlan_show(int argc, char **argv, int subject)
 		}
 
 		filt_mask = IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_XSTATS_SLAVE);
-		if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask) < 0) {
+		if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask,
+					      NULL, NULL) < 0) {
 			perror("Cannot send slave dump request");
 			exit(1);
 		}
diff --git a/include/libnetlink.h b/include/libnetlink.h
index 9e4cc101..372c3706 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -37,6 +37,12 @@ struct nlmsg_chain {
 	struct nlmsg_list *tail;
 };
 
+struct ipstats_req {
+	struct nlmsghdr nlh;
+	struct if_stats_msg ifsm;
+	char buf[128];
+};
+
 extern int rcvbuf;
 
 int rtnl_open(struct rtnl_handle *rth, unsigned int subscriptions)
@@ -88,7 +94,10 @@ int rtnl_fdb_linkdump_req_filter_fn(struct rtnl_handle *rth,
 int rtnl_nsiddump_req_filter_fn(struct rtnl_handle *rth, int family,
 				req_filter_fn_t filter_fn)
 	__attribute__((warn_unused_result));
-int rtnl_statsdump_req_filter(struct rtnl_handle *rth, int fam, __u32 filt_mask)
+int rtnl_statsdump_req_filter(struct rtnl_handle *rth, int fam, __u32 filt_mask,
+			      int (*filter_fn)(struct ipstats_req *req,
+					       void *data),
+			      void *filter_data)
 	__attribute__((warn_unused_result));
 int rtnl_dump_request(struct rtnl_handle *rth, int type, void *req,
 			     int len)
diff --git a/ip/iplink.c b/ip/iplink.c
index dc76a12b..23eb6c6e 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1644,7 +1644,8 @@ static int iplink_afstats(int argc, char **argv)
 		}
 	}
 
-	if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask) < 0) {
+	if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask,
+				      NULL, NULL) < 0) {
 		perror("Cannont send dump request");
 		return 1;
 	}
diff --git a/ip/iplink_xstats.c b/ip/iplink_xstats.c
index c64e6885..1d180b0b 100644
--- a/ip/iplink_xstats.c
+++ b/ip/iplink_xstats.c
@@ -65,7 +65,8 @@ int iplink_ifla_xstats(int argc, char **argv)
 	else
 		filt_mask = IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_XSTATS);
 
-	if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask) < 0) {
+	if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask,
+				      NULL, NULL) < 0) {
 		perror("Cannont send dump request");
 		return -1;
 	}
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 6d1b1187..4d33e4dd 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -619,12 +619,13 @@ int rtnl_fdb_linkdump_req_filter_fn(struct rtnl_handle *rth,
 	return send(rth->fd, &req, sizeof(req), 0);
 }
 
-int rtnl_statsdump_req_filter(struct rtnl_handle *rth, int fam, __u32 filt_mask)
+int rtnl_statsdump_req_filter(struct rtnl_handle *rth, int fam,
+			      __u32 filt_mask,
+			      int (*filter_fn)(struct ipstats_req *req,
+					       void *data),
+			      void *filter_data)
 {
-	struct {
-		struct nlmsghdr nlh;
-		struct if_stats_msg ifsm;
-	} req;
+	struct ipstats_req req;
 
 	memset(&req, 0, sizeof(req));
 	req.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct if_stats_msg));
@@ -635,6 +636,14 @@ int rtnl_statsdump_req_filter(struct rtnl_handle *rth, int fam, __u32 filt_mask)
 	req.ifsm.family = fam;
 	req.ifsm.filter_mask = filt_mask;
 
+	if (filter_fn) {
+		int err;
+
+		err = filter_fn(&req, filter_data);
+		if (err)
+			return err;
+	}
+
 	return send(rth->fd, &req, sizeof(req), 0);
 }
 
diff --git a/misc/ifstat.c b/misc/ifstat.c
index d4a33429..291f288b 100644
--- a/misc/ifstat.c
+++ b/misc/ifstat.c
@@ -202,7 +202,7 @@ static void load_info(void)
 		ll_init_map(&rth);
 		filter_mask = IFLA_STATS_FILTER_BIT(filter_type);
 		if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC,
-					      filter_mask) < 0) {
+					      filter_mask, NULL, NULL) < 0) {
 			perror("Cannot send dump request");
 			exit(1);
 		}
-- 
2.31.1

