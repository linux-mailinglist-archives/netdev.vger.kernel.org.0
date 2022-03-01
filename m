Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84B54C82D5
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiCAFGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbiCAFGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:16 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309B175C0F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnCl3r11iKwmFwa7QhPL9pUUOs9irl05toYLq3aMOoL+Rm6NoaqRL82A5fM8Kg8/EMqPdaVbiRr5BWhW56vBUjyujdTiKmg7349jCJ4ogyNPn7QMuDxHMqkUNR/GHlKTrqMq9DR1ooJD6GbJNqfDsp7PSZPpDMUzswHNEcpVKHEJvETPi07Tc2XswqMnSxU1U2OCiKhZCFtfOIIrByukV8uXFqTtO9RwUsmK35Kcii72nfprf8dod18zsK2eMy9VLQNeD7fp0b0TZp7BzSU0mlNmNHyEotkHWScnTRMvgb/AolytrZ5IVjl6NCheMSDaTdynfysLLImxoEmYYD0s7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bjIcQHOQY0fBsgUCiI/9DR3HcbUPdIcmsIBJxnjfOs=;
 b=Or6u3ZceOZneRyJ2gOmgJCEq9mz+Bhjm+UBwedaYaNz6uwYUxcC+bXour94ws4P3VeDQ38gcmCjtSS6qs+lxbfMzQU2LcW0gtDFaAKDXP9sK5MG2K6C9ABhZf/ho2vOZm4EmLsKgWDou0grEVoIdG0eKgVyeNlozxPp4VkcQkgdC0Ec7U7N+WNYv88N6RHsyoap6+UcMyl/CNT7E/lzLpStcZLGwfkZmXIhP51CffwT4FAfhvig/gNDbYD2bhtXwEhA2MoL2RJy/alYcaz7rX6rEf+fGnXfWsR0aViqLceBpOknOsfunvrnQjeXe+xYVoS6H3fWK7cPyBfnf0o1Djw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bjIcQHOQY0fBsgUCiI/9DR3HcbUPdIcmsIBJxnjfOs=;
 b=kNWqPNqyXopnXORMJbLjQCNg8MZrM3/Cla0W5VY74VIQUb5jLhF9jLuHBbtCwMfS+R/LaoUjK2PrQnpXgaG6C1+K79ZeNxZGl4r0eqtQf+VIeg5xRZUPuyAdGiDxXgCLZR0ZD689t+7JnvspNTUrCrOkXP8vGc0jY1czLrql6XSUuukDGh/5Oo091yR1MCBML5VrvRuYlACueskhn4KVnyczzK+pYDT/gDiBn5NEGF60X+BVxjJIh1cchoAGffkDM22jbgbt8oO7kKxEKKsoHLRc7ht+6UIuATNvwWS5vvQSbq8rYMAD44FzZtH+AXV/wnrCsMd9PWs+ZwiEIJGiug==
Received: from CO2PR04CA0132.namprd04.prod.outlook.com (2603:10b6:104:7::34)
 by BN6PR12MB1586.namprd12.prod.outlook.com (2603:10b6:405:f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 05:04:49 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::ee) by CO2PR04CA0132.outlook.office365.com
 (2603:10b6:104:7::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:46 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:45 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 08/12] vxlan_multicast: Move multicast helpers to a separate file
Date:   Tue, 1 Mar 2022 05:04:35 +0000
Message-ID: <20220301050439.31785-9-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1098750b-bce8-4fd8-095d-08d9fb41028d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1586:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB158632708AC01C390407F4F1CB029@BN6PR12MB1586.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9rXnbf2nvzlmd9u85ME8vTXlrIbncRnkTZ8rcv8GAe5DaQvfCImryexHNvsub68YP+du0e9vIj6ebcXkP3RabpSWUaxKiESqZLbg7HtFH+/ibpO2DriS9inX0KqnxIPHPYPgUmMsUrjLNb7T1FSUA1DCmDU3gUIB2Wxur1veqZ9rU3EQ1V807/VwYajn1Rd49OcLO53d8m7qyvtEzMV9wEhqXJw0iE5wIZMlNGZ1gKogcT9sP3QyznLjhINegVGC01M5iwpONq2ypiNUSEhr2AHvWR2bRfdaaacYzD98iIOk1FhPG0SRX1VOJ3w+KMx3eegWYDWsxj8865OlCXl/2NREag6S7XAU014hHmFBP+Pj3DH7Sp8wqlWHctTx3x44mO0jcX3WMbwSnsTNqg7yd7BF4e9YcPNX0+0yiuW6Zc4XNkv6wMM7dRveasHOGozAxQ9UKc5Lgk6zNCAIRieXi5plhVm/2zyBPvTE6YW9cX5Dlnl3Rki2fX/U+MjsjQq+T9jV06budCvYf7lIRgIF05lJzx8esHSy2Xp0u2jN2Vx9jnUNCbhz+PeTXg29iZU6snb/9NejREBnsnf8N6hFZZvCx6k0RmAaNPc/Vvx1VrpLrHaL4qEyWckFExzJP11TXIg4L+2Ey4uFvdL5xHql5YmyzX2lq411neAsFsWiavsn0IvQEKHIqN8U68P9Byvwy0CyzGR5oE3g792pMz6vQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(70206006)(4326008)(70586007)(36860700001)(47076005)(8676002)(82310400004)(2906002)(316002)(5660300002)(8936002)(356005)(81166007)(40460700003)(2616005)(508600001)(107886003)(86362001)(36756003)(6666004)(1076003)(110136005)(54906003)(83380400001)(26005)(336012)(426003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:48.2785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1098750b-bce8-4fd8-095d-08d9fb41028d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1586
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subsequent patches will add more helpers.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/Makefile          |   2 +-
 drivers/net/vxlan/vxlan_core.c      | 123 -------------------------
 drivers/net/vxlan/vxlan_multicast.c | 134 ++++++++++++++++++++++++++++
 drivers/net/vxlan/vxlan_private.h   |   7 ++
 4 files changed, 142 insertions(+), 124 deletions(-)
 create mode 100644 drivers/net/vxlan/vxlan_multicast.c

diff --git a/drivers/net/vxlan/Makefile b/drivers/net/vxlan/Makefile
index 567266133593..61c80e9c6c24 100644
--- a/drivers/net/vxlan/Makefile
+++ b/drivers/net/vxlan/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_VXLAN) += vxlan.o
 
-vxlan-objs := vxlan_core.o
+vxlan-objs := vxlan_core.o vxlan_multicast.o
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 8c193d47c1e4..11286e2191a1 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1445,58 +1445,6 @@ static bool vxlan_snoop(struct net_device *dev,
 	return false;
 }
 
-/* See if multicast group is already in use by other ID */
-static bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev,
-			     union vxlan_addr *rip, int rifindex)
-{
-	union vxlan_addr *ip = (rip ? : &dev->default_dst.remote_ip);
-	int ifindex = (rifindex ? : dev->default_dst.remote_ifindex);
-	struct vxlan_dev *vxlan;
-	struct vxlan_sock *sock4;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct vxlan_sock *sock6;
-#endif
-	unsigned short family = dev->default_dst.remote_ip.sa.sa_family;
-
-	sock4 = rtnl_dereference(dev->vn4_sock);
-
-	/* The vxlan_sock is only used by dev, leaving group has
-	 * no effect on other vxlan devices.
-	 */
-	if (family == AF_INET && sock4 && refcount_read(&sock4->refcnt) == 1)
-		return false;
-#if IS_ENABLED(CONFIG_IPV6)
-	sock6 = rtnl_dereference(dev->vn6_sock);
-	if (family == AF_INET6 && sock6 && refcount_read(&sock6->refcnt) == 1)
-		return false;
-#endif
-
-	list_for_each_entry(vxlan, &vn->vxlan_list, next) {
-		if (!netif_running(vxlan->dev) || vxlan == dev)
-			continue;
-
-		if (family == AF_INET &&
-		    rtnl_dereference(vxlan->vn4_sock) != sock4)
-			continue;
-#if IS_ENABLED(CONFIG_IPV6)
-		if (family == AF_INET6 &&
-		    rtnl_dereference(vxlan->vn6_sock) != sock6)
-			continue;
-#endif
-
-		if (!vxlan_addr_equal(&vxlan->default_dst.remote_ip,
-				      ip))
-			continue;
-
-		if (vxlan->default_dst.remote_ifindex != ifindex)
-			continue;
-
-		return true;
-	}
-
-	return false;
-}
-
 static bool __vxlan_sock_release_prep(struct vxlan_sock *vs)
 {
 	struct vxlan_net *vn;
@@ -1545,77 +1493,6 @@ static void vxlan_sock_release(struct vxlan_dev *vxlan)
 #endif
 }
 
-/* Update multicast group membership when first VNI on
- * multicast address is brought up
- */
-static int vxlan_igmp_join(struct vxlan_dev *vxlan, union vxlan_addr *rip,
-			   int rifindex)
-{
-	union vxlan_addr *ip = (rip ? : &vxlan->default_dst.remote_ip);
-	int ifindex = (rifindex ? : vxlan->default_dst.remote_ifindex);
-	int ret = -EINVAL;
-	struct sock *sk;
-
-	if (ip->sa.sa_family == AF_INET) {
-		struct vxlan_sock *sock4 = rtnl_dereference(vxlan->vn4_sock);
-		struct ip_mreqn mreq = {
-			.imr_multiaddr.s_addr	= ip->sin.sin_addr.s_addr,
-			.imr_ifindex		= ifindex,
-		};
-
-		sk = sock4->sock->sk;
-		lock_sock(sk);
-		ret = ip_mc_join_group(sk, &mreq);
-		release_sock(sk);
-#if IS_ENABLED(CONFIG_IPV6)
-	} else {
-		struct vxlan_sock *sock6 = rtnl_dereference(vxlan->vn6_sock);
-
-		sk = sock6->sock->sk;
-		lock_sock(sk);
-		ret = ipv6_stub->ipv6_sock_mc_join(sk, ifindex,
-						   &ip->sin6.sin6_addr);
-		release_sock(sk);
-#endif
-	}
-
-	return ret;
-}
-
-static int vxlan_igmp_leave(struct vxlan_dev *vxlan, union vxlan_addr *rip,
-			    int rifindex)
-{
-	union vxlan_addr *ip = (rip ? : &vxlan->default_dst.remote_ip);
-	int ifindex = (rifindex ? : vxlan->default_dst.remote_ifindex);
-	int ret = -EINVAL;
-	struct sock *sk;
-
-	if (ip->sa.sa_family == AF_INET) {
-		struct vxlan_sock *sock4 = rtnl_dereference(vxlan->vn4_sock);
-		struct ip_mreqn mreq = {
-			.imr_multiaddr.s_addr	= ip->sin.sin_addr.s_addr,
-			.imr_ifindex		= ifindex,
-		};
-
-		sk = sock4->sock->sk;
-		lock_sock(sk);
-		ret = ip_mc_leave_group(sk, &mreq);
-		release_sock(sk);
-#if IS_ENABLED(CONFIG_IPV6)
-	} else {
-		struct vxlan_sock *sock6 = rtnl_dereference(vxlan->vn6_sock);
-
-		sk = sock6->sock->sk;
-		lock_sock(sk);
-		ret = ipv6_stub->ipv6_sock_mc_drop(sk, ifindex,
-						   &ip->sin6.sin6_addr);
-		release_sock(sk);
-#endif
-	}
-
-	return ret;
-}
-
 static bool vxlan_remcsum(struct vxlanhdr *unparsed,
 			  struct sk_buff *skb, u32 vxflags)
 {
diff --git a/drivers/net/vxlan/vxlan_multicast.c b/drivers/net/vxlan/vxlan_multicast.c
new file mode 100644
index 000000000000..b1f5505e7370
--- /dev/null
+++ b/drivers/net/vxlan/vxlan_multicast.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *	Vxlan multicast group handling
+ *
+ */
+#include <linux/kernel.h>
+#include <net/net_namespace.h>
+#include <net/sock.h>
+#include <linux/igmp.h>
+#include <net/vxlan.h>
+
+#include "vxlan_private.h"
+
+/* Update multicast group membership when first VNI on
+ * multicast address is brought up
+ */
+int vxlan_igmp_join(struct vxlan_dev *vxlan, union vxlan_addr *rip,
+		    int rifindex)
+{
+	union vxlan_addr *ip = (rip ? : &vxlan->default_dst.remote_ip);
+	int ifindex = (rifindex ? : vxlan->default_dst.remote_ifindex);
+	int ret = -EINVAL;
+	struct sock *sk;
+
+	if (ip->sa.sa_family == AF_INET) {
+		struct vxlan_sock *sock4 = rtnl_dereference(vxlan->vn4_sock);
+		struct ip_mreqn mreq = {
+			.imr_multiaddr.s_addr	= ip->sin.sin_addr.s_addr,
+			.imr_ifindex		= ifindex,
+		};
+
+		sk = sock4->sock->sk;
+		lock_sock(sk);
+		ret = ip_mc_join_group(sk, &mreq);
+		release_sock(sk);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		struct vxlan_sock *sock6 = rtnl_dereference(vxlan->vn6_sock);
+
+		sk = sock6->sock->sk;
+		lock_sock(sk);
+		ret = ipv6_stub->ipv6_sock_mc_join(sk, ifindex,
+						   &ip->sin6.sin6_addr);
+		release_sock(sk);
+#endif
+	}
+
+	return ret;
+}
+
+int vxlan_igmp_leave(struct vxlan_dev *vxlan, union vxlan_addr *rip,
+		     int rifindex)
+{
+	union vxlan_addr *ip = (rip ? : &vxlan->default_dst.remote_ip);
+	int ifindex = (rifindex ? : vxlan->default_dst.remote_ifindex);
+	int ret = -EINVAL;
+	struct sock *sk;
+
+	if (ip->sa.sa_family == AF_INET) {
+		struct vxlan_sock *sock4 = rtnl_dereference(vxlan->vn4_sock);
+		struct ip_mreqn mreq = {
+			.imr_multiaddr.s_addr	= ip->sin.sin_addr.s_addr,
+			.imr_ifindex		= ifindex,
+		};
+
+		sk = sock4->sock->sk;
+		lock_sock(sk);
+		ret = ip_mc_leave_group(sk, &mreq);
+		release_sock(sk);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		struct vxlan_sock *sock6 = rtnl_dereference(vxlan->vn6_sock);
+
+		sk = sock6->sock->sk;
+		lock_sock(sk);
+		ret = ipv6_stub->ipv6_sock_mc_drop(sk, ifindex,
+						   &ip->sin6.sin6_addr);
+		release_sock(sk);
+#endif
+	}
+
+	return ret;
+}
+
+/* See if multicast group is already in use by other ID */
+bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev,
+		      union vxlan_addr *rip, int rifindex)
+{
+	union vxlan_addr *ip = (rip ? : &dev->default_dst.remote_ip);
+	int ifindex = (rifindex ? : dev->default_dst.remote_ifindex);
+	struct vxlan_dev *vxlan;
+	struct vxlan_sock *sock4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct vxlan_sock *sock6;
+#endif
+	unsigned short family = dev->default_dst.remote_ip.sa.sa_family;
+
+	sock4 = rtnl_dereference(dev->vn4_sock);
+
+	/* The vxlan_sock is only used by dev, leaving group has
+	 * no effect on other vxlan devices.
+	 */
+	if (family == AF_INET && sock4 && refcount_read(&sock4->refcnt) == 1)
+		return false;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	sock6 = rtnl_dereference(dev->vn6_sock);
+	if (family == AF_INET6 && sock6 && refcount_read(&sock6->refcnt) == 1)
+		return false;
+#endif
+
+	list_for_each_entry(vxlan, &vn->vxlan_list, next) {
+		if (!netif_running(vxlan->dev) || vxlan == dev)
+			continue;
+
+		if (family == AF_INET &&
+		    rtnl_dereference(vxlan->vn4_sock) != sock4)
+			continue;
+#if IS_ENABLED(CONFIG_IPV6)
+		if (family == AF_INET6 &&
+		    rtnl_dereference(vxlan->vn6_sock) != sock6)
+			continue;
+#endif
+		if (!vxlan_addr_equal(&vxlan->default_dst.remote_ip, ip))
+			continue;
+
+		if (vxlan->default_dst.remote_ifindex != ifindex)
+			continue;
+
+		return true;
+	}
+
+	return false;
+}
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index b21e1238cd5d..7a946010a204 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -112,4 +112,11 @@ int vxlan_fdb_update(struct vxlan_dev *vxlan,
 		     __u32 ifindex, __u16 ndm_flags, u32 nhid,
 		     bool swdev_notify, struct netlink_ext_ack *extack);
 
+/* vxlan_multicast.c */
+int vxlan_igmp_join(struct vxlan_dev *vxlan, union vxlan_addr *rip,
+		    int rifindex);
+int vxlan_igmp_leave(struct vxlan_dev *vxlan, union vxlan_addr *rip,
+		     int rifindex);
+bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev,
+		      union vxlan_addr *rip, int rifindex);
 #endif
-- 
2.25.1

