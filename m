Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE1A4802B2
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 18:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhL0RVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 12:21:50 -0500
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:62829
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229736AbhL0RVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 12:21:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k02m1/7r/7iTZ+BiSLtKljq/kUMPVaF417qthAs0dmxQi6FSh1C8sh6ZGdI+JUXa847SG6HUJwFpzJzIgaXhZrjiPTJpTyhWCwzZMit2mfou0zZQKVU05Vxed9tWrQbHqtaNgNU8Ki00sG/yIijOWQYy/9DNhA1GdSl1bnO8DAvvUph17VKhg3pjTDA8CfNE4cI92Yd6CQB6rGBBdogFOtq8uErBOVRwTDDf2r8V9iuPaStEY9SMXBWREKT/Z3RYZ0hKZJt4C1h2pHkARZiJ1ofEAGrB4GhYj0/YalYycJ2DoII8o08I7uo8jWh0wleQJZjHRcF09XUYRkMGtgKK9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzJfyIHpqppYIF33yoT+0q0MjMg5VzgsxAgg2Ui5d5I=;
 b=N346irNnKMGjivodL8axlfu5Cdh30PvmURQKnLbwASrGKJwDJUghqUxPmMRd7mr4z5ocxPvFqozVGJ6GnAoj9PezmRy7Jbb026QQZX7/NbksJVpN/MhJ/K7NQ+Gi0dW7en3v8Oq2kY9TmEgRjWIV+Ek/KYu5enI4rhoBMXn97EQhWu8875xDu89jAr5TAwsctl0RDH1NPSZswWz4S7Z3kOYUYMnAuB4vUW8qtOsvRQPti2DDA65NOloZ0TCorJ7Kxz0oAnjxAGZ6doOmedIOdoM+2KhoYZGgn+TbuG6W6BAZhBNcLxr7dpueyvKEdoOPcuUveGruFqB8F3hk95Tyxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzJfyIHpqppYIF33yoT+0q0MjMg5VzgsxAgg2Ui5d5I=;
 b=REsc5emyJHyd/up/Ez59NkKnbR1utI6sd2sUD6QDjMeMSmemgsaQXliIf6RbN/ODABCtu0hYbktcUhr72YOKEKI4R4EhlT2cgkc6WsA/w0yXXbQ5xcuUwUvxB+KSSBT8izr2l9+qujWcUS3HiT+NcJzUrnYw7oqqoNafoQBLzavmPtcUT04cVZ6qOHtqXvVZmGxBLD9BRA72OyRHsay1HuQWxV968cUSF7Vd1LtdRrfp1o1Uyi3RTEDsqEFlH44BoNnmqDw+IajiQ2TpliZLzqAbD8qG0V/Yh+fvADqAghE3ridB02/qEsCkDblYUSWI6Uz2BdW9y3qX8/cLqIQZQQ==
Received: from BN6PR20CA0053.namprd20.prod.outlook.com (2603:10b6:404:151::15)
 by DM6PR12MB4386.namprd12.prod.outlook.com (2603:10b6:5:28f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Mon, 27 Dec
 2021 17:21:45 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::5c) by BN6PR20CA0053.outlook.office365.com
 (2603:10b6:404:151::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19 via Frontend
 Transport; Mon, 27 Dec 2021 17:21:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Mon, 27 Dec 2021 17:21:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Dec
 2021 17:21:44 +0000
Received: from debil.mellanox.com (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 27 Dec 2021
 09:21:40 -0800
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <eric.dumazet@gmail.com>, <stable@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <roopa@nvidia.com>,
        <davem@davemloft.net>, <bridge@lists.linux-foundation.org>,
        <kuba@kernel.org>, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 1/2] net: bridge: mcast: add and enforce query interval minimum
Date:   Mon, 27 Dec 2021 19:21:15 +0200
Message-ID: <20211227172116.320768-2-nikolay@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 84ff01b6-d101-4ab6-5896-08d9c95d5b8f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4386:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4386836B53618D252EB18C23DF429@DM6PR12MB4386.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiClWSApVRUIO5tdjVObbRyRMINsr3T4jU3EnNwAZ+CZ7lR0WHOAQbIrBVwy9xC0YJP6H5oRYuFF0rdGLhhbX5D2JmmOOaSuh9+7c68CQH3k3/Dbkhen8XlkSM1cCp6Q3wD4YM5MouWEjG3qo+2C2sdPagOa/VvvUPXwqZIxG/OH7o0k0lPJswHrvfcMcChYaScXZv/vdfLZbwlSbnTrUa3Mx3m70yfwikQvz7jziO4QS7U6c1DxQBPFqS1qUfUdbjvRXtBDMqQO7vnx1Eyq4R8ooKWVrK81RGiEvsT+BfWlri4p3C+7/kZr2Dbk+MyejhKE+fn5G6Mwik/7vE5yNA42wCNeTwnj0vUDFASooo94oW5YnqXj8pkvsrtWIdZ/HW0LkEeRcwVc70vjiNp+G6a9MeRFH7tzbgbLQwobGZYVLEoTYA1v06YFxBrEYbzO5xtcDW2fRYQ0J3XjJSdiJ2etYOTrAF7YW2IyxbC6JHgVg+tBblKbSf4s/iKKi5qzGZXnp7XMjS9BI+mpeVOhE+sKF8UQws1j898FG7VNbqEnfgYITI6bnqbaGolFM0WdNweUbeB8rCECG9jujFj4CHHkLrtUl5/Tg9TWFyFMXVjGnoAp6sUtBjoZ9vm3IvWWASk7l1f1VU+r+HvEwf815rvykTRpt/41vqw03jCbIcmlS1/SavqZFS+Njm/cq55ewOzmZIHYzglKMYZAM6i9nprNPjh27Gf4fMwxWnEU9awBtNxJRv8tAe8bY7IiUPDkbAhGlm6rRd29ak6yF55abgGaMzsaszZrrupjErAp1F8PThWyPhkp5mp0m7cbqNlimK5L3QcLR2jHgHhaphAfSrFUTgn4R6O9f4Sd8Xa8d47iWhLm9xz3xa+CvhKNBNeu
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(107886003)(83380400001)(26005)(81166007)(6916009)(8936002)(2906002)(356005)(1076003)(6666004)(316002)(54906003)(36860700001)(70206006)(4326008)(47076005)(5660300002)(426003)(70586007)(2616005)(86362001)(8676002)(966005)(36756003)(16526019)(186003)(508600001)(336012)(82310400004)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 17:21:45.3179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ff01b6-d101-4ab6-5896-08d9c95d5b8f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4386
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported[1] if query interval is set too low and we have multiple
bridges or even a single bridge with multiple querier vlans configured
we can crash the machine. Add a 1 second minimum which must be enforced
by overwriting the value if set lower (i.e. without returning an error) to
avoid breaking user-space. If that happens a log message is emitted to let
the administrator know that the interval has been set to the minimum.
The issue has been present since these intervals could be user-controlled.

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
index f3d751105343..998da4a2d209 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4522,6 +4522,22 @@ int br_multicast_set_mld_version(struct net_bridge_mcast *brmctx,
 }
 #endif
 
+void br_multicast_set_query_intvl(struct net_bridge_mcast *brmctx,
+				  unsigned long val)
+{
+	unsigned long intvl_jiffies = clock_t_to_jiffies(val);
+
+	if (intvl_jiffies < BR_MULTICAST_QUERY_INTVL_MIN) {
+		br_info(brmctx->br,
+			"trying to set multicast query interval below minimum, setting to %lu (%ums)\n",
+			jiffies_to_clock_t(BR_MULTICAST_QUERY_INTVL_MIN),
+			jiffies_to_msecs(BR_MULTICAST_QUERY_INTVL_MIN));
+		intvl_jiffies = BR_MULTICAST_QUERY_INTVL_MIN;
+	}
+
+	brmctx->multicast_query_interval = intvl_jiffies;
+}
+
 /**
  * br_multicast_list_adjacent - Returns snooped multicast addresses
  * @dev:	The bridge port adjacent to which to retrieve addresses
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 0c8b5f1a15bc..701dd8b8455e 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1357,7 +1357,7 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 	if (data[IFLA_BR_MCAST_QUERY_INTVL]) {
 		u64 val = nla_get_u64(data[IFLA_BR_MCAST_QUERY_INTVL]);
 
-		br->multicast_ctx.multicast_query_interval = clock_t_to_jiffies(val);
+		br_multicast_set_query_intvl(&br->multicast_ctx, val);
 	}
 
 	if (data[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c0efd697865a..4ed7f11042e8 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -28,6 +28,7 @@
 #define BR_MAX_PORTS	(1<<BR_PORT_BITS)
 
 #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
+#define BR_MULTICAST_QUERY_INTVL_MIN msecs_to_jiffies(1000)
 
 #define BR_HWDOM_MAX BITS_PER_LONG
 
@@ -963,6 +964,8 @@ int br_multicast_dump_querier_state(struct sk_buff *skb,
 				    int nest_attr);
 size_t br_multicast_querier_state_size(void);
 size_t br_rports_size(const struct net_bridge_mcast *brmctx);
+void br_multicast_set_query_intvl(struct net_bridge_mcast *brmctx,
+				  unsigned long val);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index d9a89ddd0331..f5bd1114a434 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -658,7 +658,7 @@ static ssize_t multicast_query_interval_show(struct device *d,
 static int set_query_interval(struct net_bridge *br, unsigned long val,
 			      struct netlink_ext_ack *extack)
 {
-	br->multicast_ctx.multicast_query_interval = clock_t_to_jiffies(val);
+	br_multicast_set_query_intvl(&br->multicast_ctx, val);
 	return 0;
 }
 
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 8ffd4ed2563c..bf1ac0874279 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -521,7 +521,7 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 		u64 val;
 
 		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL]);
-		v->br_mcast_ctx.multicast_query_interval = clock_t_to_jiffies(val);
+		br_multicast_set_query_intvl(&v->br_mcast_ctx, val);
 		*changed = true;
 	}
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL]) {
-- 
2.33.1

