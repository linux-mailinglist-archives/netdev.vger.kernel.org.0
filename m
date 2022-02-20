Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B736F4BCEE5
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243893AbiBTOGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbiBTOF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:05:59 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680D835855
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmVhDyUiVclabyxJtQmiTyHpONHUAlcJTuj7h6P1y6eGTkYonRkcuaHUGPOLNzLv4EzUQiniD+uIqlvZFqjiD0GDcPZNZPeJuKmK7O+K8j38W6VzPRxfnP79FSFIzxhCTbF2uJnWdyBJmrJYFYtnuWa5Obc/yaeB1t34WLpw3zPqJ20vt6e9F7oz4flQHulvwwvBtn+0zeDZUdqjjcQK9qbK8mp121A7mF+ca7hxDLXMFu2K6D8fjXpk2Mp/7JoYoEkQ00vLHO4s9fty2TdE/VzpHc7RuOKJWoy/9W5Cd4ItuaXskapJFu56EsLxJia0EbqsRpC/Kq2uhH6ArwLuHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpAzCh9lw6X7op2+BJ7sOE2eqKaVu/S59lonD8ppeDo=;
 b=fkEd8pwZn4N6pF6bLcctOi79fuNIujG1tE/B0YwrSGUC7eTImgVwY8pC62zjW82N40AvJkRDL03LYdhzOHJ0Qe8wULnv/jksPAHAeHT2fFA2Axhy4unq71n2KnJSmh8O4TkF9nyF9N77lDEm6K98x+nwTmNdhr9Hcuyv6aGwrDa7PF0TP5l32hXLj5GWYjkFkQFupP4PeeFylPj/ipHw8ANa8ADiF4w1yfxhJtP4IEfT0KTPJ7ZagRr+DRrcDbYclkq3A1b3c8froBorF3HvTnXnJB0EJ4u/mKvQanV0ayozsho9YkJzgzR0qNBgoOLbr6KI8yEeS8RJRRHiAcYSeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpAzCh9lw6X7op2+BJ7sOE2eqKaVu/S59lonD8ppeDo=;
 b=jHiEssIv9HOk0J6ZyqdGkfB0OsFTkvPHdtHnM44dPA8he24Pl2LNyPRjXMABZxpC0fE3NszNQ6NOTvlKfH65/BBq1AUi+oc2WkdnNQ3U8ShR3zFUZBOTuNHrxiucWgzPwQuQljBkjwVe/2qo6JRnsYb3KI9psvR1gWuLO4V8OeIHEpkRvc8ZT+j6OytLXQZhxtwcOJ0Bh7wK36T1rD/tpP2gAEaponTh0bFsdTlM8SjiqwV7+T3n5ZY3pdY2E+mlQ6orVOYpRWba0uugZ9/TLZZNYm90dVQWGXfg/p02hLqbEvTR/otloqYJrPhjvSd0hTrRjCleBwSlcs+THeNRMA==
Received: from BN6PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:405:4a::13) by CY4PR12MB1334.namprd12.prod.outlook.com
 (2603:10b6:903:42::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 14:05:34 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::b5) by BN6PR1101CA0003.outlook.office365.com
 (2603:10b6:405:4a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:30 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:29 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 02/12] vxlan_core: move common declarations to private header file
Date:   Sun, 20 Feb 2022 14:03:55 +0000
Message-ID: <20220220140405.1646839-3-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfb1a650-472b-4aec-f01a-08d9f47a0f54
X-MS-TrafficTypeDiagnostic: CY4PR12MB1334:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB13348379A2D0ECA5FAAE7BE8CB399@CY4PR12MB1334.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XTOdE1Y1dARlBazKX/NvGfJvqP6el9EEJIF1A1cMlh8rU1ixK7xiZVWzKIgdtAVJdIfjwTdXH24FCOPWHaWrkTmeWMGCMYzkKxMJazWcs8qiuEcAlMK/HyMloH9oiCDRTBy8Lb3I90Zn1ElntK07YY9GsK5FicJL+ELaaGM51/QyX2B/14yvEDmN1hgzVRf+cz4Qx/alUlD0+hX+kcHxa8XaSVjpYKt08v+lkpstbL2ad+TrGSHTgTVzedfzZ16fkRm4twCfsC5zjUY9veubfCFU00KDHyoiqe/NYmGzQTgwL6KQc84qXgqS0tynwa2jZTfVqcImAK0H3544/WGQPJtBySYtRb2mgCzk4HVDJmG60CDvn8TSahPnfvwVldbGnk0rFhQDV00ilg2ejVSqlORjT1gw8Tfxsc4ELu2a0OUqeVP8scTJ8HMdwSiJasVLubFyhCfo2pqe7YTfWyXln5M/kyWpXV5mdaQqIHTS+JTz3m0OBtyijNG4COJk1SVti2tChm2JYAcReF2RGUzm0PJjMgfBco4O+v+57fV1RcSAAzAdjvr9SdU3OgfCd2kXFdhrkFyWNQvcKQ5kU55EC7B0qIhGJDU3nzrT6MfVU+1975+J6nb3m7WHg9gPUg2VjG030bT7bSJRTDfdtPhXyMoH104DzNTnqeiyEdGaMp13Q4xUhClSKc19Uc4mCNMOzGxWIOZhfnN1RuzzKdwFwA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(2906002)(81166007)(356005)(86362001)(40460700003)(2616005)(47076005)(110136005)(36756003)(54906003)(186003)(1076003)(336012)(426003)(26005)(508600001)(6666004)(4326008)(8676002)(70586007)(5660300002)(8936002)(83380400001)(70206006)(316002)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:32.8329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb1a650-472b-4aec-f01a-08d9f47a0f54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1334
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/vxlan/vxlan_core.c    | 83 ++-------------------------
 drivers/net/vxlan/vxlan_private.h | 95 +++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 79 deletions(-)
 create mode 100644 drivers/net/vxlan/vxlan_private.h

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index d0dc90d3dac2..5856ef92b9c9 100644
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
 
@@ -53,41 +53,14 @@ static bool log_ecn_error = true;
 module_param(log_ecn_error, bool, 0644);
 MODULE_PARM_DESC(log_ecn_error, "Log packets received with corrupted ECN");
 
-static unsigned int vxlan_net_id;
-static struct rtnl_link_ops vxlan_link_ops;
+unsigned int vxlan_net_id;
 
-static const u8 all_zeros_mac[ETH_ALEN + 2];
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
 
@@ -98,17 +71,6 @@ static inline bool vxlan_collect_metadata(struct vxlan_sock *vs)
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
@@ -135,12 +97,6 @@ static int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
 
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
@@ -161,37 +117,6 @@ static int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
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
index 000000000000..6940d570354d
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
+static const u8 all_zeros_mac[ETH_ALEN + 2];
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

