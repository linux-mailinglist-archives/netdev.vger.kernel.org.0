Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81D84BCF0C
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243933AbiBTOGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243925AbiBTOGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:06:08 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4883586A
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jS8ROQO1Eic/9gjhSCNp5kVnWMuunAHHLQWDA8BHfLJkginFr4JKbe7fNBpzDPBlRIJIbQdP9sRsg3qc4hh6F8BwzYSA5GHSBLXcBS/p/5pt1Vyf+4rifrmFHTLm8ilFFzS0v6skvzRTP45LqF7K/H2UlUr404g1DEBxx1flv54vwjE/We1pzeYHT+5TvkBF+DCEYxNjE9qhCymiyJAOtMVPka76Od6VGalVVNcx0kpboJcQCGUKoCzm7Gjh3DzZHb0VIYWiDQu83qlL3a8t7+ZhBEiJILjirkmNWdbGKuKoi37mOLcFjP0eoChyAFUshunCBLJ4m/8RpZVa9FHlfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiOac9Ehe83Sbc6nv+25XjO2f3zNe881NKvs15N1gKw=;
 b=XRqZdBZ09xBmPnlhfAeWIOkQVsoiV6bUSR6/aGIwl3CIwgcYbT4VVqI3D1eetIapyDyXgPARlILcJBh15OOof7KPKLkPFEafswu13N2ShPgs2n8456NGf3Pj3RV6btKaFKUCqwrjxmkiMv3kiyZw/IisdIkdN9VoCRhzDXzlSz7VBA8PwW2UNyYd9Ermi2N64yU7HunGVPtL7JBGZBC7kiZMXP2XyK+eMSDhm9+iitITkSmCNi/b61K9FU1ccl4cw07yfK4DagEbKV04SIQvfScrris2fDzd7mhJa0YIKH3GhtbV8/6cuXthcilLC1kNUMhdKC9vvlm+JjXjag44fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiOac9Ehe83Sbc6nv+25XjO2f3zNe881NKvs15N1gKw=;
 b=L7Nse0ckXY7Wg1SHYBdD/PCmhQ9wKVNWq6FTvX9S6oKT1hobcgISZBrNvpUSvjso80OrZWZNboGkgHshN+UGisibkQIq/eaxA2a4dOZPcYHCGupMy5amxxLl/iKoBCJkCXoEb7jhCv9JnhFCdel1IeQ5MjoWwO2s9B4ELjgAId/Vl9JWivwgsiPK39d3zhdQooHXRtxnLj4iuk8GjMcg20e1G6nMRMuIBXOUR2qq5Nbjuws48DEqB1S6x6Fs84w3t8KuYP6f4mAvBctdl4cLqhDipVyzt5BVzzzbZ59ChNKZw/2epX1PEIu3U23sGNu89l2aqDHX4MDx5fDIip6ZMw==
Received: from BN6PR16CA0042.namprd16.prod.outlook.com (2603:10b6:405:14::28)
 by DM5PR12MB2535.namprd12.prod.outlook.com (2603:10b6:4:b5::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Sun, 20 Feb
 2022 14:05:45 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::b5) by BN6PR16CA0042.outlook.office365.com
 (2603:10b6:405:14::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.20 via Frontend Transport; Sun, 20 Feb 2022 14:05:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:40 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:39 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:37 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 07/12] vxlan_multicast: Move multicast helpers to a separate file
Date:   Sun, 20 Feb 2022 14:04:00 +0000
Message-ID: <20220220140405.1646839-8-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d586ce7-8297-42c9-c140-08d9f47a166f
X-MS-TrafficTypeDiagnostic: DM5PR12MB2535:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB25354E306CC4C83E55E3171DCB399@DM5PR12MB2535.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cR00d7lu6rds/jkKdRDn54c5mNzg3i47cqz7bXObJxgZ3wLV8WEbddqKzl9BCXmkguG7B+XvUoJz6jVj/8AxwcbBo1eNtGt0o+auZ9DX5jk7DTRzwLWOOhSNgCIvseLFFxPAS9JZUHWEJSo0C8EWQqOfQraiBFFPsUoi+SWGsTeO4j+BbDJ9TaXnSfFjVwtV+4szdV+iWzF/0S3TaqKxKP7kx2Fvppy0B52Nr9F7W0gF58nUOLUYWpFMPk6npTs30sX42mgU7e7BlTKusvmuIF+5l7PYkGhdqXoLHpKG/Mv0mHgHQZ7uwioreVmNP83RebPCB6+3/90JRzudqo7Mvt3897wo3MOEq1ZXSubQEQ2lCoSbXifvWu4DxzMwtwwlgofbQD3aLuliAkylYeYiR7RbRwyOgyHDaOV/i1ADTY/WUzXtT6YZOdWy3SPRyxoe1qkiCyybZseNcxd1VO/nQhjDUhPS5n6Rj/Y22f7vijuQeJW2UsMfBQKXloYnGxGWRyazBRxYOpjLRDKleuHUvWuix2cJ1yEovBxWBMYtr+0EDrLKlJpott6ZRCEQnC2orWi+iXfapCUsgKZ3srFpjXCG5s9wcOGpGzrhM4WTwXsLHFD1aKzMjgzouZWiOVEkykkgWYTilpcxpiSrjMCPZsF/PRRVCBFalZdAr+sifUUaq96+JTXq+ZV96jpigjBPADXLTjTDmaULi2g7HE5CPQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(54906003)(86362001)(508600001)(36756003)(110136005)(82310400004)(40460700003)(70206006)(70586007)(5660300002)(8676002)(47076005)(83380400001)(4326008)(8936002)(316002)(2906002)(336012)(36860700001)(26005)(6666004)(356005)(186003)(81166007)(2616005)(1076003)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:44.7058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d586ce7-8297-42c9-c140-08d9f47a166f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2535
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/vxlan/vxlan_multicast.c | 136 ++++++++++++++++++++++++++++
 drivers/net/vxlan/vxlan_private.h   |   7 ++
 4 files changed, 144 insertions(+), 124 deletions(-)
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
index d17d450f2058..1bbfca495b12 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1444,58 +1444,6 @@ static bool vxlan_snoop(struct net_device *dev,
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
@@ -1544,77 +1492,6 @@ static void vxlan_sock_release(struct vxlan_dev *vxlan)
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
index 000000000000..ddb241876567
--- /dev/null
+++ b/drivers/net/vxlan/vxlan_multicast.c
@@ -0,0 +1,136 @@
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
+	pr_debug("%s -> %pIS, %d\n", __func__, ip, ifindex);
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
index 6b29670254a2..ad2f561c6e94 100644
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

