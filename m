Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE834BEFB6
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbiBVCx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239391AbiBVCxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:22 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9176725C7F
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:52:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/hpRYgLXWufA5Dve4fbpvPM5j67ScDYkH88OOdodsvc+5uCl/rgtuvD5IqD1QF+uAH/iJPRx7RJBk33nm2j1cs9aBNPI4nc0Ha2gelf2Mp9MgdAv0BtXkMJ4ltdW7G5ECtdBBddPrkEK5XsNhr1Iy/cWeZPwVBsvBPEIzBRWi4yZHg7VRrfD1sY/AKSWIaE1oskfjeYYH3vqlxSivqLClKDGvB3MXAGelWZQ0Zr1krxblQmN+PccpBj/XqjIfXehuxvTXobMGpqnL8uMZ5MZErbvUvOovgAIdX/m2r9sHIeklG2+V3zGa15emJEWXXrOsjtT/grJNzWPxz/ReeTZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bjIcQHOQY0fBsgUCiI/9DR3HcbUPdIcmsIBJxnjfOs=;
 b=PdyYaYKNFQjj7y10acmm43Gq9C8ggIDK+HPXkft5F1NjbkXCqo2BEWC1q6IttQN0nI7wjaHwRVn7UeHQsVmoahfFXr1gj73LoGo9G/n70p5h9pTemxQCiT+in3JFA7PPccY3gkuoTPgM8wcy06CoQOMAJdnyvamQXaoVDugpCbnQwwAMsDhCQ3TtyMaGhQFwMU3HJHra4kP+AYq+5L6NaYURZotKyTPUfQ0JlFdFkfnivJ2AXnG5DSb5RAnVNyQyFncDHtT85/4niX2VS66vKHpmRR17dDg2A0nIftKkK1Hg+d2X+85KCNBQlNCbKDdyJzFxAjzLjNLnPSCOcp2zoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bjIcQHOQY0fBsgUCiI/9DR3HcbUPdIcmsIBJxnjfOs=;
 b=Ez71fqtyNTfrB+aKDaPIkVV5kC/SFCJI+3A0DXexq1sgw/sdo5hLbjWk2pEvXuR7+2oQvlbzT1qRuzViLZQ1BbS0A3LPXx/R3pduP/6aIBceg78ZegnRoD5tzcQUQRvovZMSdQ/KLNpVuRuSrNhMt+sXYgbwZ74lhkrKafKflmy+45VTfLPahoeK3+6IuDN3xU3GZ5j6i6IwTg5stCxE33Pf50mkF41bahtzdg54V9V/HXg3OKWQxFh/Kf0xtgU6CTzDsILH3nWYcyT3FwnYUNlYb96Fb6dt6ZODKx5y5ECTOsiyldALBxgJ+obR6Rf1HKdq7ds6D0XhNKWW2ir96A==
Received: from DS7PR05CA0072.namprd05.prod.outlook.com (2603:10b6:8:57::7) by
 DM6PR12MB4465.namprd12.prod.outlook.com (2603:10b6:5:28f::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.14; Tue, 22 Feb 2022 02:52:55 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::33) by DS7PR05CA0072.outlook.office365.com
 (2603:10b6:8:57::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.7 via Frontend
 Transport; Tue, 22 Feb 2022 02:52:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:53 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:53 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 08/12] vxlan_multicast: Move multicast helpers to a separate file
Date:   Tue, 22 Feb 2022 02:52:26 +0000
Message-ID: <20220222025230.2119189-9-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a03152a0-1c4b-430b-a92a-08d9f5ae6d3f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4465:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB446584D023DB824F6FBA74E7CB3B9@DM6PR12MB4465.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+ZOhzT4PZPW/g3PO/BnqHEDdvh6iHqohU4umFN664IZ61dJ9Jck6O7vnNG4cuM4/IChXsV0zcrqhdXcfakmKyOdSsxUF6kwdnoYaJKxNKBwdQFrVx4XEUVz0rv9AxgoqwL1VWFS2t53D0zl9H0FYLSyY9OXbb+0MlC9f6PEzIBa81AMlst+D6gjBqa7kd2MvhhmOmHEnqKAjTE51P2eT3kIX3dHkjp2HhEKJ2umqlCnutoV31yx6+UGh/z98Z7IKdepTvIPcgF8XJrnQFKyjZ4FHDKiF/f5k9E01i5gN14xz940WF/dYsBNycOpqx2UbMxLO0GJx23vqF1v8QIROQ8W8k0YiDv9ZHZTrQDQr7y7X1Wo1HpYHRz9O3orLtBwZdavWyfl4IrzRZCcHGiKuyUPFsdrYzvOsuVzJZ0BItB3PwgcCUQ8k3S/XdlNes3SlW+OLlyqvm3ZRC9d/0cUeAougkWJnlE7EcAHUFuNiPgL48d/f8wYcbfGSzFEwTtiTlOhVm6CNEXYWJNDH+OVzldw0MHAKWAYxkei4L9kHUHQEyQmB0eQxmsFP4mfcV3prjdipZ3p4M7ZauSAPrMmFFe2jDg06QSaiJMqCPUge4ugJrfzkR45DuR/CtNrlnPB3ZdnwqievJr76ftLprhqkKLzYAqDdN/K7p/PRoTuNBYTEYJ/axmaUzQWZnqyraQQZ7sqQ6K8vUJES4pvts+zJQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(316002)(82310400004)(508600001)(47076005)(86362001)(4326008)(36860700001)(70586007)(110136005)(8676002)(70206006)(6666004)(54906003)(40460700003)(336012)(26005)(186003)(2616005)(2906002)(83380400001)(426003)(1076003)(356005)(8936002)(36756003)(5660300002)(81166007)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:55.4232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a03152a0-1c4b-430b-a92a-08d9f5ae6d3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4465
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

