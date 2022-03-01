Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB3E4C82C9
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiCAFGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiCAFGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:14 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55E27561F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1wlmNNc2en9+W+UqiIjL7CF8FmOMuvSJ/haAl0FEMkDbNkGmU+9dmTKEjYh5UOXPJC4NnR2U6CIHd2rRKJGQprK5jrC6iZQ4YoL8VIH3J0OWlZ5e5Kky2MhoAh1Wa+l719/iethCmaBg1C0kDKh9664DvCZJb4a+Nfk89XVNrnGJgeijWchGWGIIaUWytNeO5eiSZg8BiShtJeUuvrh4K7T1DQzrxDZbBgdEzXWsGmrd8NDccO85rv4IO6wVppaNJdOKpApXsWdVV0q5jj8ZyToU8KFyKIR5lFzIR0aTiNKX3Jkp1c0ZJ7oG7tIZlqezwT3pYHx6rdPa0Zl3QiqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OM8Zw+OoMBm6zn+0K/PlZhecX0m45Ma0z4EEk8ZXMDw=;
 b=T1+1LnGHLSt/7wJLmEeJ2Rw3rz9HnlMKnJFJXGaSSpI3eMcS9mSxgUWqbsvSB0Sue2BsuUVMG6z9Q+KNSbU/O+hASoPxneichE0oCXXd3+cNeKqWTzMiNl2tYcm68nQjA/56U8+kJ57Rbvtpv/hp+4D6Cb8T085l1XoDeeLQOXvbbzhiOqjJKqN4+X+2/hBUdfAbvXAktnGuCE0P2D0JJztDLrvdUxYe8HP9KHakXPgXIXe+Y8dyIEih76Froebu5sOcitAp6Wwi19VAnXvBuyxAm9F8qn2spyx7/ch0u4J970ZsVAIubm2j1bz8pe6buIMIO/CwizSAYM7ayBliXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OM8Zw+OoMBm6zn+0K/PlZhecX0m45Ma0z4EEk8ZXMDw=;
 b=QRlcThoHVhgQF4XpNn2/Mbi2LnbKHnIYe5ICY/tgJTRZLOiKEy4MIKwtFhXrW/+XkxhX+fOfclttH/0R46Q9xNNcXXoEb0WWEOYI6GSmtV+imQnKwdqI5B3dR3Xesss0KdXHZQ+wEXIVEd+MfLluhL3wa2qj7e4XVAsaXejSq/MiCaRn1Ixtc+1x/zREBBuXfzhMpjMNPrTBIU+ALz1U9MemykSQhXHPgS08KYP0ebpNio0sRfn98IOgH3LH4zyTvLNgrzUKYYX5ynSio6iWCcjcJ4M44zRNxlX3CVg/dkNF5h8rU7J1zwYsEaxbrGLJfPM5tCXY0qyrBgl2i70mNA==
Received: from BN6PR16CA0025.namprd16.prod.outlook.com (2603:10b6:405:14::11)
 by MWHPR12MB1133.namprd12.prod.outlook.com (2603:10b6:300:d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 05:04:44 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::a2) by BN6PR16CA0025.outlook.office365.com
 (2603:10b6:405:14::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:42 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:41 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 03/12] vxlan_core: move common declarations to private header file
Date:   Tue, 1 Mar 2022 05:04:30 +0000
Message-ID: <20220301050439.31785-4-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28aa96df-e483-4640-2f73-08d9fb410016
X-MS-TrafficTypeDiagnostic: MWHPR12MB1133:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1133F73C1E6341265F4C674FCB029@MWHPR12MB1133.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fIPOkEE2m4vWjGHLCRHLHcTa/vbNhNVBU8PW2/zmYkcCY+H9UN97wOJlerCutJn0KWKdzZezZzEtbC6o71LJG1GtkJJAv8dlDla8e75+x1/bkm6v81KoddyvLlJ1boSF4T0RFgNKGOXH+KTN4d+URYdZ12iVczOBEn2Xi+wPGEM3zXyl6yE2yJwM5QU5z3CVQBSddDZ4hTEB4KD6Rx2jwSpVHSfAalZBDBn/5QmF2heVEqu9X8DHOPuZMBFnQdtYhv13Y+Ievecm+R5SQIBR/jBwJhnsnFwzCmYbr6bwmup+fZ7ZQbw+JZldYGxF+Tsdn4XDMDoqElM2t6vdche6g+1sk94HhBO5TUOEDyTi08pY8Z/HfWrSkHHFV1qv4/dnfA1ViUJW1L9GgcrcGAR4c3hAdkfitBFmT8S5CPpNSc/7jQSU8ZyPVnFukfx1d9l8lZ9yLXpWVHhiiX7eqbk4/vL6HMetouay9Sp12Sf38Vf1v2jNHqTV4VZv5ZgpU9LRiww8iGRZsBxo7o0qO3qbTB0z03ZSzBv8p+YxEnWzOqQrcFujWXCDNupSkndge1hoFzL7GhIokvjMkDO+EroiWUtNbjLVP2vyMCe6IVI5PIEW3h4X5FoukDov+iUwzY4PPneICBEQP7WQbIGldhqh3vRJAYso/zeNxVTlu0BY3kzK2SQfX70XGLBjmhYIs9yLOVjJe2haRXYnMqOEZiR4Kw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(6666004)(508600001)(36860700001)(70586007)(82310400004)(70206006)(8676002)(4326008)(86362001)(110136005)(316002)(54906003)(356005)(81166007)(83380400001)(107886003)(47076005)(1076003)(2616005)(426003)(40460700003)(186003)(26005)(336012)(36756003)(2906002)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:44.0660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28aa96df-e483-4640-2f73-08d9fb410016
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1133
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves common structures and global declarations
to a shared private headerfile vxlan_private.h. Subsequent
patches use this header file as a common header file for
additional shared declarations.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c    | 84 ++-------------------------
 drivers/net/vxlan/vxlan_private.h | 95 +++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+), 79 deletions(-)
 create mode 100644 drivers/net/vxlan/vxlan_private.h

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index a852582e6615..f4ef7d5e2376 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -34,10 +34,10 @@
 #include <net/ip6_checksum.h>
 #endif
 
+#include "vxlan_private.h"
+
 #define VXLAN_VERSION	"0.1"
 
-#define PORT_HASH_BITS	8
-#define PORT_HASH_SIZE  (1<<PORT_HASH_BITS)
 #define FDB_AGE_DEFAULT 300 /* 5 min */
 #define FDB_AGE_INTERVAL (10 * HZ)	/* rescan interval */
 
@@ -53,41 +53,15 @@ static bool log_ecn_error = true;
 module_param(log_ecn_error, bool, 0644);
 MODULE_PARM_DESC(log_ecn_error, "Log packets received with corrupted ECN");
 
-static unsigned int vxlan_net_id;
-static struct rtnl_link_ops vxlan_link_ops;
+unsigned int vxlan_net_id;
 
-static const u8 all_zeros_mac[ETH_ALEN + 2];
+const u8 all_zeros_mac[ETH_ALEN + 2];
+static struct rtnl_link_ops vxlan_link_ops;
 
 static int vxlan_sock_add(struct vxlan_dev *vxlan);
 
 static void vxlan_vs_del_dev(struct vxlan_dev *vxlan);
 
-/* per-network namespace private data for this module */
-struct vxlan_net {
-	struct list_head  vxlan_list;
-	struct hlist_head sock_list[PORT_HASH_SIZE];
-	spinlock_t	  sock_lock;
-	struct notifier_block nexthop_notifier_block;
-};
-
-/* Forwarding table entry */
-struct vxlan_fdb {
-	struct hlist_node hlist;	/* linked list of entries */
-	struct rcu_head	  rcu;
-	unsigned long	  updated;	/* jiffies */
-	unsigned long	  used;
-	struct list_head  remotes;
-	u8		  eth_addr[ETH_ALEN];
-	u16		  state;	/* see ndm_state */
-	__be32		  vni;
-	u16		  flags;	/* see ndm_flags and below */
-	struct list_head  nh_list;
-	struct nexthop __rcu *nh;
-	struct vxlan_dev  __rcu *vdev;
-};
-
-#define NTF_VXLAN_ADDED_BY_USER 0x100
-
 /* salt for hash table */
 static u32 vxlan_salt __read_mostly;
 
@@ -98,17 +72,6 @@ static inline bool vxlan_collect_metadata(struct vxlan_sock *vs)
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static inline
-bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
-{
-	if (a->sa.sa_family != b->sa.sa_family)
-		return false;
-	if (a->sa.sa_family == AF_INET6)
-		return ipv6_addr_equal(&a->sin6.sin6_addr, &b->sin6.sin6_addr);
-	else
-		return a->sin.sin_addr.s_addr == b->sin.sin_addr.s_addr;
-}
-
 static int vxlan_nla_get_addr(union vxlan_addr *ip, struct nlattr *nla)
 {
 	if (nla_len(nla) >= sizeof(struct in6_addr)) {
@@ -135,12 +98,6 @@ static int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
 
 #else /* !CONFIG_IPV6 */
 
-static inline
-bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
-{
-	return a->sin.sin_addr.s_addr == b->sin.sin_addr.s_addr;
-}
-
 static int vxlan_nla_get_addr(union vxlan_addr *ip, struct nlattr *nla)
 {
 	if (nla_len(nla) >= sizeof(struct in6_addr)) {
@@ -161,37 +118,6 @@ static int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
 }
 #endif
 
-/* Virtual Network hash table head */
-static inline struct hlist_head *vni_head(struct vxlan_sock *vs, __be32 vni)
-{
-	return &vs->vni_list[hash_32((__force u32)vni, VNI_HASH_BITS)];
-}
-
-/* Socket hash table head */
-static inline struct hlist_head *vs_head(struct net *net, __be16 port)
-{
-	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
-
-	return &vn->sock_list[hash_32(ntohs(port), PORT_HASH_BITS)];
-}
-
-/* First remote destination for a forwarding entry.
- * Guaranteed to be non-NULL because remotes are never deleted.
- */
-static inline struct vxlan_rdst *first_remote_rcu(struct vxlan_fdb *fdb)
-{
-	if (rcu_access_pointer(fdb->nh))
-		return NULL;
-	return list_entry_rcu(fdb->remotes.next, struct vxlan_rdst, list);
-}
-
-static inline struct vxlan_rdst *first_remote_rtnl(struct vxlan_fdb *fdb)
-{
-	if (rcu_access_pointer(fdb->nh))
-		return NULL;
-	return list_first_entry(&fdb->remotes, struct vxlan_rdst, list);
-}
-
 /* Find VXLAN socket based on network namespace, address family, UDP port,
  * enabled unshareable flags and socket device binding (see l3mdev with
  * non-default VRF).
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
new file mode 100644
index 000000000000..03fa955cf79f
--- /dev/null
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *	Vxlan private header file
+ *
+ */
+
+#ifndef _VXLAN_PRIVATE_H
+#define _VXLAN_PRIVATE_H
+
+extern unsigned int vxlan_net_id;
+extern const u8 all_zeros_mac[ETH_ALEN + 2];
+
+#define PORT_HASH_BITS	8
+#define PORT_HASH_SIZE  (1 << PORT_HASH_BITS)
+
+/* per-network namespace private data for this module */
+struct vxlan_net {
+	struct list_head  vxlan_list;
+	struct hlist_head sock_list[PORT_HASH_SIZE];
+	spinlock_t	  sock_lock;
+	struct notifier_block nexthop_notifier_block;
+};
+
+/* Forwarding table entry */
+struct vxlan_fdb {
+	struct hlist_node hlist;	/* linked list of entries */
+	struct rcu_head	  rcu;
+	unsigned long	  updated;	/* jiffies */
+	unsigned long	  used;
+	struct list_head  remotes;
+	u8		  eth_addr[ETH_ALEN];
+	u16		  state;	/* see ndm_state */
+	__be32		  vni;
+	u16		  flags;	/* see ndm_flags and below */
+	struct list_head  nh_list;
+	struct nexthop __rcu *nh;
+	struct vxlan_dev  __rcu *vdev;
+};
+
+#define NTF_VXLAN_ADDED_BY_USER 0x100
+
+/* Virtual Network hash table head */
+static inline struct hlist_head *vni_head(struct vxlan_sock *vs, __be32 vni)
+{
+	return &vs->vni_list[hash_32((__force u32)vni, VNI_HASH_BITS)];
+}
+
+/* Socket hash table head */
+static inline struct hlist_head *vs_head(struct net *net, __be16 port)
+{
+	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
+
+	return &vn->sock_list[hash_32(ntohs(port), PORT_HASH_BITS)];
+}
+
+/* First remote destination for a forwarding entry.
+ * Guaranteed to be non-NULL because remotes are never deleted.
+ */
+static inline struct vxlan_rdst *first_remote_rcu(struct vxlan_fdb *fdb)
+{
+	if (rcu_access_pointer(fdb->nh))
+		return NULL;
+	return list_entry_rcu(fdb->remotes.next, struct vxlan_rdst, list);
+}
+
+static inline struct vxlan_rdst *first_remote_rtnl(struct vxlan_fdb *fdb)
+{
+	if (rcu_access_pointer(fdb->nh))
+		return NULL;
+	return list_first_entry(&fdb->remotes, struct vxlan_rdst, list);
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static inline
+bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
+{
+	if (a->sa.sa_family != b->sa.sa_family)
+		return false;
+	if (a->sa.sa_family == AF_INET6)
+		return ipv6_addr_equal(&a->sin6.sin6_addr, &b->sin6.sin6_addr);
+	else
+		return a->sin.sin_addr.s_addr == b->sin.sin_addr.s_addr;
+}
+
+#else /* !CONFIG_IPV6 */
+
+static inline
+bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
+{
+	return a->sin.sin_addr.s_addr == b->sin.sin_addr.s_addr;
+}
+
+#endif
+
+#endif
-- 
2.25.1

