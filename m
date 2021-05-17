Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BF5383C0F
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbhEQSRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:17:51 -0400
Received: from azhdrrw-ex01.nvidia.com ([20.51.104.162]:1790 "EHLO
        AZHDRRW-EX01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244198AbhEQSRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:17:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by mxs.oss.nvidia.com (10.13.234.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnmaI3qVwejlEnSkL10HH0aRqAAXd8NoxSPxM2izpIdaROFeEiCvEgKmrT67lKiPmrsLkMU7p/LA8+OM3bR+h2iiCszPZcmXs6qfz4pmrg02fzCSo8iJjoYui2zCT1hqpAJKmzuawukZ58l6qptdRv7d9Ppbu6BZ4stSnCFp3ARSzAk7IumXJ2BXmC6DUgelhD4+XJi9mp0LMY0nEWiNrgnavD9wTURtzPGyDBTRMHy+Qq2cSjCgl+B2TguAs9NcmNb2N0qo02D76BFlJsoaQLBc/H+2cOeNvmTWecd0DClvItiwO5btYdbjTN3yZQ82WdmFpaTGzeMxql3Zfm0Ffg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBDQZogAc4aiM5VWcGPukjWAHdzWGmP6RribKq8XE44=;
 b=Vfy7fE7vDLto+RePcvV7x5s55SBpEuUtTMUbSwwUk3HtetiLab0lPpvVM0nodXrkwd4Uq63lww/oMSBkXSegl+psUpEYXEVfgKX12IVLItFuuSmFaI0vXhOeOUV5vu2nUfbIZe0BT4P3JlHqA3QUTUcmI2t6nQaoo2HECBslvjS7+VFl3lTktIDTyy5akD/uN7tMYt3OaBb8Dwf5hnXiIYGebYQ3YQdAKfUplCvvvpHdgNzz7RtS4T1keZQ1nsS2jipGO3cuQO7y6u91xPxDGPlVy0ZA41LDx0WHE6hj0Rih5GOOTuZxicJWGuAu5wwi7D376QChgHqoXEEIv4kfEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBDQZogAc4aiM5VWcGPukjWAHdzWGmP6RribKq8XE44=;
 b=LZ9aRdti06acoAC0J4a4BPqjYXaVdalsIFY+/634UPfGepWh2/EvXuAKVDRbxn9A5MF0HTeGazjHYYc6kZf31yr/5yQc50fjXdZWQwHXqy6UYDxvLqJDxxh9notmOEHDpzE/d5d13ietn27U5FJ7P/S2uMOJb6pvQS6U59fALi9umokQvBcoC3CjS2GZBFC6RvR0U1C47dL+6Y+kB3o7JEWfQmqKZDs53tEbH9iabuKFB5PCXzziCt3WvKAGV5ZTSHBHcjSfDWxHctFB1ZuQ6/j3CKpqeqjDKrx6ccuTl2FmFQ1wOaOC1MQpRPF2xh0yJLCyNImDUS69oX/c7d1eIw==
Received: from BN6PR22CA0068.namprd22.prod.outlook.com (2603:10b6:404:ca::30)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 18:16:30 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:ca:cafe::fb) by BN6PR22CA0068.outlook.office365.com
 (2603:10b6:404:ca::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Mon, 17 May 2021 18:16:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:30 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:26 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 06/10] ipv6: Add a sysctl to control multipath hash fields
Date:   Mon, 17 May 2021 21:15:22 +0300
Message-ID: <20210517181526.193786-7-idosch@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 907b19e4-7dc5-4dae-ba8a-08d9195fe52f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:
X-Microsoft-Antispam-PRVS: <CH2PR12MB42629E8FB2924E49904100C7B22D9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5BJIlm0dspQ+d3pmcjEuKAYiR/OBfa/JVi2/+T7KHwJQWJtsY2S78gSpgAtxfesPURVuSqgSMPmIjoCBoOYmsCludVNDLNCao6A7UpZPlI/l94rherqhjf7u73FDdISY6jH6ilu+xA75qq0pxoL/4GzogrP/1aYaaUE3MpJjyeet7r+mecHl/+JAsoK3S6ZVjjCTAz+LTQUke+y+EVkQOjBvSbZtHPDPo3iprr7iz+izJ7OnbOf97JTMSAqMWa3wY7KeOlmRkzh+QtZ4tqjUNrOCs+8XNPIHr06FYNzTHAgzb/7LrKdezwJG7qcASozHHIlFFKJUGjMU9OTsLXdJqnIrgUe3xTNMeDQ6bHtcvTTrGHmmeGpL94guXDDt31i6aAJ7G1Mab9Hgszl2Lz+u9AC14mWSCVRuhRTLR+cZqYVhUncxGsvC+eItr4g7FWpoe/sWocIwN93Ny46qjVosw8Pd/l7XEotUgz188dn3yTEL+sWGT947pSL34rcngMpqUNK3s6LzP6XOZAXz1SIy2QfyGvU6tYZvBnJyUDBDTsZOzKnwAVS6XoYalg6sWEVxXnHJ1PJXVSFz4blfpLQWXb+55RFmfw7G0PhCb/0dnUT3VIEOP+lT9/XXpPPmYwFyXzZARje0znCpz6XsOu74MA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(46966006)(36840700001)(70206006)(336012)(70586007)(6666004)(36906005)(316002)(426003)(26005)(478600001)(2616005)(107886003)(36860700001)(82310400003)(54906003)(4326008)(8676002)(6916009)(186003)(2906002)(7636003)(1076003)(8936002)(5660300002)(356005)(47076005)(36756003)(86362001)(82740400003)(83380400001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:30.5514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 907b19e4-7dc5-4dae-ba8a-08d9195fe52f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A subsequent patch will add a new multipath hash policy where the packet
fields used for multipath hash calculation are determined by user space.
This patch adds a sysctl that allows user space to set these fields.

The packet fields are represented using a bitmask and are common between
IPv4 and IPv6 to allow user space to use the same numbering across both
protocols. For example, to hash based on standard 5-tuple:

 # sysctl -w net.ipv6.fib_multipath_hash_fields=0x0037
 net.ipv6.fib_multipath_hash_fields = 0x0037

To avoid introducing holes in 'struct netns_sysctl_ipv6', move the
'bindv6only' field after the multipath hash fields.

The kernel rejects unknown fields, for example:

 # sysctl -w net.ipv6.fib_multipath_hash_fields=0x1000
 sysctl: setting key "net.ipv6.fib_multipath_hash_fields": Invalid argument

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 27 ++++++++++++++++++++++++++
 include/net/ipv6.h                     |  8 ++++++++
 include/net/netns/ipv6.h               |  3 ++-
 net/ipv6/ip6_fib.c                     |  5 +++++
 net/ipv6/sysctl_net_ipv6.c             | 12 ++++++++++++
 5 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index afdcdc0691d6..4246cc4ae35b 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1773,6 +1773,33 @@ fib_multipath_hash_policy - INTEGER
 	- 1 - Layer 4 (standard 5-tuple)
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
+	0x0008 Flow Label
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
 anycast_src_echo_reply - BOOLEAN
 	Controls the use of anycast addresses as source addresses for ICMPv6
 	echo reply
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 448bf2b34759..f2d0ecc257bb 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -926,11 +926,19 @@ static inline int ip6_multipath_hash_policy(const struct net *net)
 {
 	return net->ipv6.sysctl.multipath_hash_policy;
 }
+static inline u32 ip6_multipath_hash_fields(const struct net *net)
+{
+	return net->ipv6.sysctl.multipath_hash_fields;
+}
 #else
 static inline int ip6_multipath_hash_policy(const struct net *net)
 {
 	return 0;
 }
+static inline u32 ip6_multipath_hash_fields(const struct net *net)
+{
+	return 0;
+}
 #endif
 
 /*
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 6153c8067009..bde0b7adb4a3 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -28,8 +28,9 @@ struct netns_sysctl_ipv6 {
 	int ip6_rt_gc_elasticity;
 	int ip6_rt_mtu_expires;
 	int ip6_rt_min_advmss;
-	u8 bindv6only;
+	u32 multipath_hash_fields;
 	u8 multipath_hash_policy;
+	u8 bindv6only;
 	u8 flowlabel_consistency;
 	u8 auto_flowlabels;
 	int icmpv6_time;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 33d2d6a4e28c..2d650dc24349 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -32,6 +32,7 @@
 #include <net/lwtunnel.h>
 #include <net/fib_notifier.h>
 
+#include <net/ip_fib.h>
 #include <net/ip6_fib.h>
 #include <net/ip6_route.h>
 
@@ -2355,6 +2356,10 @@ static int __net_init fib6_net_init(struct net *net)
 	if (err)
 		return err;
 
+	/* Default to 3-tuple */
+	net->ipv6.sysctl.multipath_hash_fields =
+		FIB_MULTIPATH_HASH_FIELD_DEFAULT_MASK;
+
 	spin_lock_init(&net->ipv6.fib6_gc_lock);
 	rwlock_init(&net->ipv6.fib6_walker_lock);
 	INIT_LIST_HEAD(&net->ipv6.fib6_walkers);
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 27102c3d6e1d..ce23c8f7ceb3 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -17,6 +17,7 @@
 #include <net/addrconf.h>
 #include <net/inet_frag.h>
 #include <net/netevent.h>
+#include <net/ip_fib.h>
 #ifdef CONFIG_NETLABEL
 #include <net/calipso.h>
 #endif
@@ -24,6 +25,8 @@
 static int two = 2;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
+static u32 rt6_multipath_hash_fields_all_mask =
+	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
 
 static int proc_rt6_multipath_hash_policy(struct ctl_table *table, int write,
 					  void *buffer, size_t *lenp, loff_t *ppos)
@@ -151,6 +154,15 @@ static struct ctl_table ipv6_table_template[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "fib_multipath_hash_fields",
+		.data		= &init_net.ipv6.sysctl.multipath_hash_fields,
+		.maxlen		= sizeof(u32),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= &rt6_multipath_hash_fields_all_mask,
+	},
 	{
 		.procname	= "seg6_flowlabel",
 		.data		= &init_net.ipv6.sysctl.seg6_flowlabel,
-- 
2.31.1

