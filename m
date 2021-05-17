Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C33383C0A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244069AbhEQSRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:17:35 -0400
Received: from azhdrrw-ex01.nvidia.com ([20.51.104.162]:1784 "EHLO
        AZHDRRW-EX01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239501AbhEQSRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:17:33 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by mxs.oss.nvidia.com (10.13.234.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBAeHJsyUREL3u2m7/h0f5IodVg2u++oBkkaiUAtAATIoqFexqrQkcUSCTmTShsFCJPBCWg7ORKkGfgWfy/+qkGQefESXag7Mk42Ne+f36n00bcRxVCbbeyfxnk8F+gsbc0X9SK6tZ5FJwp3GtvyeQ5XbeJjMCg1r0CsjsMv1a1FFk+YpN5h2WiMBqNMLeTvzfOE4MCLlQo6FVfAm3ZovH634Cgy/AhicA4VLMSCGBDBt6falbfHLFO9NhRUF6t/LOmYkMP5yCYxmRDs/tBBLp/x4K7O1CsMoUU2yClvf0H7f/jN740ZCFqQ555eQytAl3BuuQPsPGkXMtT/QNjbTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMoYPF/D8tNbwYOsv1o3rsyk7NvYR0H1vt+a2IUXdXk=;
 b=DNFXT/VcQEJ4/SyYJf5VoaG53LoDjp6JgBaDrYTDckvzdUDbnvI4t40oNXBdbe+e7ig0G5jh6NNJY9mlZ38oKkxsJDeUPb/WZ3kTlPMKfFsX4yAs7fUDncUQ/I7Skd1VUhqwAWB5+FLmxv0mCRT8h+IpqEWdNfOga0mIvVqgYXhO+QSBDOYoAv5x4eXnS3x6tHAdsC9mZSIQWD3Hi+56DRXCaRskfr0PLJhjMvUVe10ExP1wehbn7yX/RDTALvLoufP7ZUm4gGs02YFqBWmUHy6cb0DZ5NtmhBtoZVm9UgjvMPDUhY6PQU+B5fTxMNrG9slBp3L3nEVWoZLmGVKTdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMoYPF/D8tNbwYOsv1o3rsyk7NvYR0H1vt+a2IUXdXk=;
 b=Gd2v+4LmEst6kqiZ6QKc0zu7QsdJ9qzqRTne/pycwO4Z+BXxSCZLmBbd/JKN0b4nXPlUJcXmnF1nyOV8FZw+Trm0JMjk8Mq9gyeOGReq8ohHhX8VZCZA2bhmHYz9HkaWfMtI9UTKRE6xG7KunmpmhxhE27yUAlruCuGA/HcUNnu7rF9qflrfKoqc38ZynHUw3SmhydaWUXOANy94OqwQb3VIPPjKQbuI4rfuB2SPp4ALKpRd058w2f84MGmxTJkUheRtSYh5U0LNU6Ghimpaxgvpk6L7NBWM9VfxOojGQ1KqBny77IGwbpQxDQIKseegVL26hoVcINSwT1TqGYZQlA==
Received: from BN7PR02CA0032.namprd02.prod.outlook.com (2603:10b6:408:20::45)
 by CH2PR12MB3863.namprd12.prod.outlook.com (2603:10b6:610:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 18:16:15 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::47) by BN7PR02CA0032.outlook.office365.com
 (2603:10b6:408:20::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 18:16:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:15 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:11 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 02/10] ipv4: Add a sysctl to control multipath hash fields
Date:   Mon, 17 May 2021 21:15:18 +0300
Message-ID: <20210517181526.193786-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517181526.193786-1-idosch@nvidia.com>
References: <20210517181526.193786-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87d4c172-6f66-44a3-0aa0-08d9195fdc0f
X-MS-TrafficTypeDiagnostic: CH2PR12MB3863:
X-Microsoft-Antispam-PRVS: <CH2PR12MB386315ADA83B2BBE935E0DB5B22D9@CH2PR12MB3863.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVRHyPn9rIFgzUKLHtzfF1aG47YbCqaOr8l9quk8vkrWUZL7UqB88DwlI73MEgChkF2LXjpLV8rzEOF9tyEp5imyxfMTjGY957z83jnUaKuAMnlXFAwxWtb3kTXTS3c4y7QBo2t4B3rtllFDzEAz9NlC/WuJWj36jPszo7tGkAqw31TkVbNoWg1Y8wK2BqCAvl39uK8C1zWGdL7rr8Etx0BCcWS3XgE5VkKawDag4WHda/0a4fKXo9SgiqJzjB4w7wHOIoeDrEkqg1Ig/AkFmMgn8Fd6fNATcJzIA+d/Q6zZhZo0FqV8JCOpXIdS5b8NZ6U9zh3PBSHaIh83IICi2maGgiQxCJf4GGWlzUb08wJj6+aJGxA+gKhEk2glIoC1ynLHl1QrvVaIZ1HBJeQlCGSePs0SFHXHMHn0fIJhWziZldBrO3E8U2SK3XCEn33n3O0cVObWQSYS4gkNI9YbQkudSVHBgGLWyA7iPWUydlBqR9ajmPe9pWe7rW18OAdkbNTUeEy3wHPRQo8TSqOcHsX6JoPfrrR2jNES5I8/hp7XNuXbVitR4aIoidZHYumB3yrOlHI8BBNZqX4YDUyUaqyvOyxoadOEzg5YA7oNgfNbswvgGYjHz3HWCrqvP0YG9Cd1F6yy2oscv5HIIZOjLQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(46966006)(36840700001)(7636003)(70206006)(36860700001)(356005)(107886003)(82310400003)(6916009)(8936002)(8676002)(36906005)(47076005)(5660300002)(26005)(70586007)(4326008)(54906003)(86362001)(1076003)(2616005)(2906002)(16526019)(478600001)(186003)(316002)(83380400001)(426003)(336012)(82740400003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:15.2407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d4c172-6f66-44a3-0aa0-08d9195fdc0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A subsequent patch will add a new multipath hash policy where the packet
fields used for multipath hash calculation are determined by user space.
This patch adds a sysctl that allows user space to set these fields.

The packet fields are represented using a bitmask and are common between
IPv4 and IPv6 to allow user space to use the same numbering across both
protocols. For example, to hash based on standard 5-tuple:

 # sysctl -w net.ipv4.fib_multipath_hash_fields=0x0037
 net.ipv4.fib_multipath_hash_fields = 0x0037

The kernel rejects unknown fields, for example:

 # sysctl -w net.ipv4.fib_multipath_hash_fields=0x1000
 sysctl: setting key "net.ipv4.fib_multipath_hash_fields": Invalid argument

More fields can be added in the future, if needed.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 27 ++++++++++++++++
 include/net/ip_fib.h                   | 43 ++++++++++++++++++++++++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/fib_frontend.c                |  6 ++++
 net/ipv4/sysctl_net_ipv4.c             | 12 +++++++
 5 files changed, 89 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c2ecc9894fd0..47494798d03b 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -100,6 +100,33 @@ fib_multipath_hash_policy - INTEGER
 	- 1 - Layer 4
 	- 2 - Layer 3 or inner Layer 3 if present
 
+fib_multipath_hash_fields - UNSIGNED INTEGER
+	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
+	fields used for multipath hash calculation are determined by this
+	sysctl.
+
+	This value is a bitmask which enables various fields for multipath hash
+	calculation.
+
+	Possible fields are:
+
+	====== ============================
+	0x0001 Source IP address
+	0x0002 Destination IP address
+	0x0004 IP protocol
+	0x0008 Unused (Flow Label)
+	0x0010 Source port
+	0x0020 Destination port
+	0x0040 Inner source IP address
+	0x0080 Inner destination IP address
+	0x0100 Inner IP protocol
+	0x0200 Inner Flow Label
+	0x0400 Inner source port
+	0x0800 Inner destination port
+	====== ============================
+
+	Default: 0x0007 (source IP, destination IP and IP protocol)
+
 fib_sync_mem - UNSIGNED INTEGER
 	Amount of dirty memory from fib entries that can be backlogged before
 	synchronize_rcu is forced.
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index a914f33f3ed5..3ab2563b1a23 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -466,6 +466,49 @@ int fib_sync_up(struct net_device *dev, unsigned char nh_flags);
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu);
 void fib_nhc_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig);
 
+/* Fields used for sysctl_fib_multipath_hash_fields.
+ * Common to IPv4 and IPv6.
+ *
+ * Add new fields at the end. This is user API.
+ */
+#define FIB_MULTIPATH_HASH_FIELD_SRC_IP			BIT(0)
+#define FIB_MULTIPATH_HASH_FIELD_DST_IP			BIT(1)
+#define FIB_MULTIPATH_HASH_FIELD_IP_PROTO		BIT(2)
+#define FIB_MULTIPATH_HASH_FIELD_FLOWLABEL		BIT(3)
+#define FIB_MULTIPATH_HASH_FIELD_SRC_PORT		BIT(4)
+#define FIB_MULTIPATH_HASH_FIELD_DST_PORT		BIT(5)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP		BIT(6)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP		BIT(7)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO		BIT(8)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL	BIT(9)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT		BIT(10)
+#define FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT		BIT(11)
+
+#define FIB_MULTIPATH_HASH_FIELD_OUTER_MASK		\
+	(FIB_MULTIPATH_HASH_FIELD_SRC_IP |		\
+	 FIB_MULTIPATH_HASH_FIELD_DST_IP |		\
+	 FIB_MULTIPATH_HASH_FIELD_IP_PROTO |		\
+	 FIB_MULTIPATH_HASH_FIELD_FLOWLABEL |		\
+	 FIB_MULTIPATH_HASH_FIELD_SRC_PORT |		\
+	 FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+
+#define FIB_MULTIPATH_HASH_FIELD_INNER_MASK		\
+	(FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT |	\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT)
+
+#define FIB_MULTIPATH_HASH_FIELD_ALL_MASK		\
+	(FIB_MULTIPATH_HASH_FIELD_OUTER_MASK |		\
+	 FIB_MULTIPATH_HASH_FIELD_INNER_MASK)
+
+#define FIB_MULTIPATH_HASH_FIELD_DEFAULT_MASK		\
+	(FIB_MULTIPATH_HASH_FIELD_SRC_IP |		\
+	 FIB_MULTIPATH_HASH_FIELD_DST_IP |		\
+	 FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		       const struct sk_buff *skb, struct flow_keys *flkeys);
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index f6af8d96d3c6..746c80cd4257 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -210,6 +210,7 @@ struct netns_ipv4 {
 #endif
 #endif
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
+	u32 sysctl_fib_multipath_hash_fields;
 	u8 sysctl_fib_multipath_use_neigh;
 	u8 sysctl_fib_multipath_hash_policy;
 #endif
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 84bb707bd88d..129213b7d834 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1516,6 +1516,12 @@ static int __net_init ip_fib_net_init(struct net *net)
 	if (err)
 		return err;
 
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+	/* Default to 3-tuple */
+	net->ipv4.sysctl_fib_multipath_hash_fields =
+		FIB_MULTIPATH_HASH_FIELD_DEFAULT_MASK;
+#endif
+
 	/* Avoid false sharing : Use at least a full cache line */
 	size = max_t(size_t, size, L1_CACHE_BYTES);
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a62934b9f15a..45bab3733621 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -19,6 +19,7 @@
 #include <net/snmp.h>
 #include <net/icmp.h>
 #include <net/ip.h>
+#include <net/ip_fib.h>
 #include <net/route.h>
 #include <net/tcp.h>
 #include <net/udp.h>
@@ -48,6 +49,8 @@ static int ip_ping_group_range_min[] = { 0, 0 };
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
+static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
+	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
 
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
@@ -1052,6 +1055,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "fib_multipath_hash_fields",
+		.data		= &init_net.ipv4.sysctl_fib_multipath_hash_fields,
+		.maxlen		= sizeof(u32),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= &fib_multipath_hash_fields_all_mask,
+	},
 #endif
 	{
 		.procname	= "ip_unprivileged_port_start",
-- 
2.31.1

