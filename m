Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88EA4BEFBE
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbiBVCxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbiBVCxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:18 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D8B25C72
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:52:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgOF4muMHGu+1XacxgPvmUSIu7BrW9zcXo+0pD95fzl4dcH4lfl02PouZnuRhK2uW1HgXNYkSxYUf4mV3zo0dGWvJp8e3BcD+/7qqlnpDRoIqe0PmrwabFkNUP7tZE/xUnpTZKajH+1Ix4MyboMbBJKrcuLK1YfUPausHk9R/CaGoL5MkJpWJ+UmSCEsdl4yv73MsNgq2ShkE0S8z+8OTIv8rUd0Fboms6kSI7L4od5KrHfNF3f18L7dIEY6FngBjNqTz45wEEpziIG10CJO9/vU6mzQ18t8Jd67pB2swtOg13ZepEV9rsgO94bk2kXkxKOxu59dYEnpuGE73qIRKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OM8Zw+OoMBm6zn+0K/PlZhecX0m45Ma0z4EEk8ZXMDw=;
 b=A2ZpONXo85gWeAI4NvH0XFCrwNP7shecBdbdWoKC+vzIPtKINwJZ80g+Hc4Ei0/T2CiarbjUDB0AO1W3r1IwaAW37hnCscrwvdEgNXAOlWIge5TlA166HSFUOrVdC95mo+q8wuq8QB98KDq/u9ZOxp1eB1/K2D0UjFdCb/gL4hBftCxrtNPCdv2GSzhipg/gqEnwLSH9SJYDAo6UUB421nczRTa8dKiODynXDP4h79wr5GttNuW8nJUJihJLapInyebluMssWfqFQyK/206+MHkVjUPNBnNGcgAXGn5SybyiEaxdzWYekeDpWxYBmMXYFsuLuYPHOePnvUv3B/OOKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OM8Zw+OoMBm6zn+0K/PlZhecX0m45Ma0z4EEk8ZXMDw=;
 b=NccuoTabOB6Nre5h2rTsY+qIpt0r6QYMsuwvYYywBT3+eHMHjlKstNmtac71vZDPb6uqd/uvc+P740kUkuvC2H1yPny9EY/3w9CHPdUB0UCqo4ktziez9APA/rn79bRKIAjFTSRExfQec0FEsIf2A0l1azg+ujIsBST1GyRyCrKexiLHeJG00xmBqR81nMog2adevh7JZa+Q/LUCVCxMXhZwopywCjIL3nwi2CJOCfQTnCIA6Re2HKfgRvs72kVbtvVlVfflxverBpmUPE+Ob0gk3Ny0Ic/dSgSWEbKWcwJf2IOuExaAL2IMMtG0xQmbCH1J9wEATBiCFG2Hf3bpIg==
Received: from BN6PR11CA0060.namprd11.prod.outlook.com (2603:10b6:404:f7::22)
 by BN8PR12MB2948.namprd12.prod.outlook.com (2603:10b6:408:6d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 02:52:52 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f7:cafe::bb) by BN6PR11CA0060.outlook.office365.com
 (2603:10b6:404:f7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24 via Frontend
 Transport; Tue, 22 Feb 2022 02:52:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:50 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:49 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 03/12] vxlan_core: move common declarations to private header file
Date:   Tue, 22 Feb 2022 02:52:21 +0000
Message-ID: <20220222025230.2119189-4-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9200e2b7-84ec-4578-7b98-08d9f5ae6b33
X-MS-TrafficTypeDiagnostic: BN8PR12MB2948:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB294832C789FF3F29DA9B5196CB3B9@BN8PR12MB2948.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rV6Xq4N2ZhlTGcS44XUd8bzFG8cYbzsA1abD7/qRWBmnfklu9qUhI8P1YSFMtcrwmSt19/Ax7cai6bWvdH0aorm0Bv/zCHRMswO3MlDQRbzc7w1haDDpkzprsBYEqe6gFs6D48dA38VPdifvZ2EXAwE50ImBXf+MJ0xbo4syvLCw1OC0FLm41IbsfBhDnDIyS8O67X7Xq2XLK0k08+O+tC0guIEUttwmSSHjGTjF2UOJD3RemJrbOAHrUvUMaoA8E2XSVNST4flf7B3vNLUOPdS4R6usmbfT1rODdgw4LAY9AJSLo/V48+Q0aoJ45xzzJ1Yxp3sRPO1UU8KaNUr3XUe4LVIqxaApbgciIm2obNhwgvDKJhOnQPTEweSX+tybBfLI5MsmmDWW+HoCw7Q3ETW97+HkhtI2JTJYxwCmhzhpcs741sZmvrVz5QnCuWS+om3oOTBTVT/I13H1bBeAeZ16OTFIz/2GyL+q9NLTU6VHv6npUIMvfB3A59I3GohcCpIRsCxZZfuYJZQnf6/RD8GvIkOT4VBHq7hxZ9WnRxDRBv10aFbmx+7aze0N2qG6mGAFHsdP+M3ANvaUMlTHURA4ZA1qePzOvxHiZzOnd6yS1BqUj2YBSFwdWCzrkFO324xXi5T1Myf7hAAXhAIB6zP+/ppijhAHd7kKb+Kzd3g5Ut15oHNLmge+R/BblqaXOa2DyfgRje8HbyH2YiBv4w==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(2616005)(426003)(1076003)(36860700001)(336012)(316002)(107886003)(86362001)(54906003)(26005)(40460700003)(83380400001)(36756003)(186003)(110136005)(47076005)(8676002)(70206006)(8936002)(82310400004)(70586007)(2906002)(508600001)(4326008)(6666004)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:51.9567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9200e2b7-84ec-4578-7b98-08d9f5ae6b33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2948
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

