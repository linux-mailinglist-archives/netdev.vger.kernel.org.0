Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275BB4802B8
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 18:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhL0RVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 12:21:52 -0500
Received: from mail-dm6nam08on2058.outbound.protection.outlook.com ([40.107.102.58]:44545
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229508AbhL0RVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 12:21:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVCSx+5/ZdDxhdhLw3c8MuBifAkkMC+sJxO3T3dNUuMwhzciFdfq2kn8WDmwenjNBShggx2VG7MHQvzWN+YXBBrKCh2Fkq/hzIFs38Zof5T6rif94O4cxBZLFdYZaG2Gz1nlRu8HdCPydFlFt2qxNsQ+No8WrA5CBl97qt0VWioIYXc1GdMRVtYib4BnnGYf6FFfehyDWYx3iEcMb/9tOag+voM6T+pLRvr2aonr09TQAHpD+2uaskMEKigT9KANOnUsenSvJpb4pcl6P3eqIS3nxYsFJe8EeFCfWoQl9kzgeY+gCiFY8fZtNegfAv7VlqxweIvbg1EObvzVIUfBfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Plw6ewk2WQ3De+VOe3rFVcaIDEjdAt9CRAWHaylraU=;
 b=KW17pOjAbNXHtjuvyKQHIJ2RpyFgdrMoQQRVoXL9nz7JuX147nDNUnGNAOQmXqYssYP4V5LyvGV2aOt9BjCsREpGxV5H4oviMDM2mtyaCl814ZYcSAz6W4GSp1eAE1Aa0UGz+CWDkIo+qukxIhjI+sbBBjPNlV/WF0XQiEg4lcndaJBfkXDvSp4//7N8L0XhdUVdgT79uA34GpAySKFWzv+bm8vd1/AZiFrQFtjiFWGrXBmKmAZIsH9RkUmlu0ZPyZ8y1WsrOgUZrDDXymtJL7Sr58aN+P7Tq6oNZHt0BF7TNltME2bEeHvCIOiQWiITT3Yqnrfa6f6zHXp+98bF1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Plw6ewk2WQ3De+VOe3rFVcaIDEjdAt9CRAWHaylraU=;
 b=XWX/2s9w5mreu7IZUczbLiLlQm3jg7uzGTaq/TK4qvXWpXDzRL+cFEdD7f3dvra4Sm9P6+4ivH7i739V1/U8p+Gzm/5USy0VxitMtFKIvX7Z6031KlC7v5XEwnQPUAPAag+UjepoXZVA2lgdg/UUfASJw2WU2a4/cPhuDTbDjo7WCE3hyA5vUaBlcEIRFSEIvIQsveeqtmVHSNEa8+c2P5cuueDjwtiOc8JPvaaH1ne12NcsAlzDwt37PbCPpIPj4oCxWYydlG+97Hv+bqSpbHCT0XcB+9NnJrr8/3EKPz9sY+nqayVG0QLa6bBdzO8F8AyP9z59Ep7Tp5EBSchsvg==
Received: from BN0PR10CA0010.namprd10.prod.outlook.com (2603:10b6:408:143::14)
 by BN6PR1201MB0146.namprd12.prod.outlook.com (2603:10b6:405:59::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Mon, 27 Dec
 2021 17:21:49 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::11) by BN0PR10CA0010.outlook.office365.com
 (2603:10b6:408:143::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19 via Frontend
 Transport; Mon, 27 Dec 2021 17:21:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Mon, 27 Dec 2021 17:21:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Dec
 2021 17:21:48 +0000
Received: from debil.mellanox.com (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 27 Dec 2021
 09:21:44 -0800
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <eric.dumazet@gmail.com>, <stable@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <roopa@nvidia.com>,
        <davem@davemloft.net>, <bridge@lists.linux-foundation.org>,
        <kuba@kernel.org>, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 2/2] net: bridge: mcast: add and enforce startup query interval minimum
Date:   Mon, 27 Dec 2021 19:21:16 +0200
Message-ID: <20211227172116.320768-3-nikolay@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211227172116.320768-1-nikolay@nvidia.com>
References: <20211227172116.320768-1-nikolay@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77ce542c-9d37-4874-2ea7-08d9c95d5de0
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0146:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0146C2E4120C875A9A7A4845DF429@BN6PR1201MB0146.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQtRKPSP584xJflBJfgfxi/ruEnxHWxL3B2SkQ7ImREBkS3hseQgNwZa5cR5MYjNM/20oeIEfagdkm7EM8al9Cc+xseo5DFoUuN4xizbrR8/2dAEZ67E9RXHOnDQKagOLGmC9fJVBK4LVqh0/O5bkPBAJZQIT639Bc0CSTs8YfW56kzjWprJVVk/haOFIForGNvDYzVqKIZHciuenYqFiWdRAoccgwmewrnJwcuUoRKaVdnUREDyYUOkhQ6+iWXDauDLsVzGvoVTcdD17SPEttbehpjY7YdQxNScheGL0hzM/46FSZrsEdwase2sLASmcjsfmgVAHnOGjwZweePxQFSV4nFKAfmoMTBaq5gLF6Cv7OmCpHnBO1+mJpkZ9wZpQhikEa9StzoKUJIwEsYW7mZIgyIjTdHUOtMtc36c2cwwC0ScxV5nJTaSqwh0QDYUujmiynXjPuxQvpCdbcMNfT9wCOKtAzE4hzJDkR7q99rw4RH7B4gzMjHaeW8ALgBGQy5uARNY5IEN4HHvrbjoON+Pwu8W1y85sTExzxC7BriAtuMcnuwYnhN/c/5APyKxZcOdpesOuWbdmhA4QDo380UOnI4RV8Z4VGlfWDnBri68ZUw549GPNk722HXW/1hZi0Y2+XSZCCsq+665ANYn5cd+WITYCAbpf3a1D98AyntXhUmXZi+xXoOYGfct0yFG6n42COJSbmFdcCbCEqiBptmYgevbRUQjPtguLtHBeJLzcbyyb9gLBJsRt2duQxM2t0ABVq8kLAfc91Xa5d7/a8cnhkvy5La49st01XFL4Kmez5KwvevGo4Hvfxd0lXeso5Rlj5+jO4pe86UzAw4HUMyKyAOAqxZ6YArmgH5ZeyV/P4s8PAskYioLJQWo/fGy
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(86362001)(70586007)(4326008)(54906003)(2906002)(508600001)(8936002)(107886003)(36860700001)(966005)(83380400001)(5660300002)(316002)(82310400004)(36756003)(6916009)(81166007)(356005)(426003)(47076005)(26005)(8676002)(40460700001)(16526019)(336012)(6666004)(70206006)(186003)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 17:21:49.1875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ce542c-9d37-4874-2ea7-08d9c95d5de0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported[1] if startup query interval is set too low in combination with
large number of startup queries and we have multiple bridges or even a
single bridge with multiple querier vlans configured we can crash the
machine. Add a 1 second minimum which must be enforced by overwriting the
value if set lower (i.e. without returning an error) to avoid breaking
user-space. If that happens a log message is emitted to let the admin know
that the startup interval has been set to the minimum. It doesn't make
sense to make the startup interval lower than the normal query interval
so use the same value of 1 second. The issue has been present since these
intervals could be user-controlled.

[1] https://lore.kernel.org/netdev/e8b9ce41-57b9-b6e2-a46a-ff9c791cf0ba@gmail.com/

Fixes: d902eee43f19 ("bridge: Add multicast count/interval sysfs entries")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c    | 16 ++++++++++++++++
 net/bridge/br_netlink.c      |  2 +-
 net/bridge/br_private.h      |  3 +++
 net/bridge/br_sysfs_br.c     |  2 +-
 net/bridge/br_vlan_options.c |  2 +-
 5 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 998da4a2d209..de2409889489 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4538,6 +4538,22 @@ void br_multicast_set_query_intvl(struct net_bridge_mcast *brmctx,
 	brmctx->multicast_query_interval = intvl_jiffies;
 }
 
+void br_multicast_set_startup_query_intvl(struct net_bridge_mcast *brmctx,
+					  unsigned long val)
+{
+	unsigned long intvl_jiffies = clock_t_to_jiffies(val);
+
+	if (intvl_jiffies < BR_MULTICAST_STARTUP_QUERY_INTVL_MIN) {
+		br_info(brmctx->br,
+			"trying to set multicast startup query interval below minimum, setting to %lu (%ums)\n",
+			jiffies_to_clock_t(BR_MULTICAST_STARTUP_QUERY_INTVL_MIN),
+			jiffies_to_msecs(BR_MULTICAST_STARTUP_QUERY_INTVL_MIN));
+		intvl_jiffies = BR_MULTICAST_STARTUP_QUERY_INTVL_MIN;
+	}
+
+	brmctx->multicast_startup_query_interval = intvl_jiffies;
+}
+
 /**
  * br_multicast_list_adjacent - Returns snooped multicast addresses
  * @dev:	The bridge port adjacent to which to retrieve addresses
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 701dd8b8455e..2ff83d84230d 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1369,7 +1369,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]);
 
-		br->multicast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
+		br_multicast_set_startup_query_intvl(&br->multicast_ctx, val);
 	}
 
 	if (data[IFLA_BR_MCAST_STATS_ENABLED]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4ed7f11042e8..2187a0c3fd22 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -29,6 +29,7 @@
 
 #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
 #define BR_MULTICAST_QUERY_INTVL_MIN msecs_to_jiffies(1000)
+#define BR_MULTICAST_STARTUP_QUERY_INTVL_MIN BR_MULTICAST_QUERY_INTVL_MIN
 
 #define BR_HWDOM_MAX BITS_PER_LONG
 
@@ -966,6 +967,8 @@ size_t br_multicast_querier_state_size(void);
 size_t br_rports_size(const struct net_bridge_mcast *brmctx);
 void br_multicast_set_query_intvl(struct net_bridge_mcast *brmctx,
 				  unsigned long val);
+void br_multicast_set_startup_query_intvl(struct net_bridge_mcast *brmctx,
+					  unsigned long val);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index f5bd1114a434..7b0c19772111 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -706,7 +706,7 @@ static ssize_t multicast_startup_query_interval_show(
 static int set_startup_query_interval(struct net_bridge *br, unsigned long val,
 				      struct netlink_ext_ack *extack)
 {
-	br->multicast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
+	br_multicast_set_startup_query_intvl(&br->multicast_ctx, val);
 	return 0;
 }
 
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index bf1ac0874279..a6382973b3e7 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -535,7 +535,7 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 		u64 val;
 
 		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]);
-		v->br_mcast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
+		br_multicast_set_startup_query_intvl(&v->br_mcast_ctx, val);
 		*changed = true;
 	}
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER]) {
-- 
2.33.1

