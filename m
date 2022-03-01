Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36894C82CC
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiCAFG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiCAFGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:16 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11BB723D5
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KT4jrYnI0MYBkqyOSyNFtkw9G1YesfMIM+ONS+gfrQ2/+eJs+L6U+hakwpAMykULt6N5J9aYslLYhkvI+ISDz7IOiwRmnVeEjyFikjoeIF/rwsoAUm9aAkpDHrQbvGwwMB/Jhop+VbSyca8IMZxQvcilxSg+K9pRj/f3BW3ShDNZE/x9wLqkAeaZ+oyCrnKVmXgz7C1Yx5zaWekKvVwJxr2iLdmCGR+dQOCrvilZeKp4pqMEbvixoWHn4PPUjNIvIjJitvw4Jx3Vvd0InQIVpg07qPdM5ce0sjwNr3NGAQAC2FWvRjjHWJ0byfstzjqSV/Qn8XQhHdjmLk0sPwFDNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bxqxd8CCcFmysYj1tydYUts5ZaNrPXRnL+Wv/60cNtI=;
 b=G310+iKfQaZ7oDWzzc7nLAS2VP5exnra7YNal2/7mSnfHB7pkdHEKw1hWcTWOWSdKTZOWRRySUXjkBebdpQ2Jng2hXK9jTdBTWRZWq6ZMStvkDEZ3kwJ/TJyw2S0kHUHV/Ukz0hFda7T3MfaqlGrQ6vtpUyIMRT6Soqkp03O9MlPO4zCDoJq+exkJpntVMKkIymPAis4CFdF2hnZU4FY8fAKK5N7XWcxS5OTlBxO8g+oWtOlQO4ulAwM4IPsD5/FdkxKvlSZCgF9oAAmqEJPwdZuMdNUyjvEjJk/LvhSCwr+BcNE+Iz/lFsXMDsV6Sh2izExoB5s9Z/KugZphCNvnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bxqxd8CCcFmysYj1tydYUts5ZaNrPXRnL+Wv/60cNtI=;
 b=OQviCuhSBZ0SlGLNLDzIYUB5iXXisKHAP2fFSpV9QSPazbb6EVY3+2tFgjxZjMVvqo1sRDpzOM5LeASlcSSrrY+Cq8r2F755qd1rChqulM6WIRvPlbiGN8JrMXBsue+9yihBk0IQMwV760TygGTIFsJd/CGw0qsbrbRGfcQczZ6pa/a7yKPB278bzmGHkCBmEcEPyGw90+Ycm1DngsM8pKMd4Zs4ff65eUy/WP5XUaesQe2IDngE8Zxx04qvjTTjIu+6OEgCm2MoEczVi6cP2fa+zwGEUiqZ2nbUkX5GXEdH+0lkLCbDRpG/KuPHVlZ3atFVhGFM/a9D3ZZCh6rl9w==
Received: from CO1PR15CA0102.namprd15.prod.outlook.com (2603:10b6:101:21::22)
 by DM4PR12MB6009.namprd12.prod.outlook.com (2603:10b6:8:69::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Tue, 1 Mar
 2022 05:04:49 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::68) by CO1PR15CA0102.outlook.office365.com
 (2603:10b6:101:21::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:47 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:46 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 09/12] vxlan: vni filtering support on collect metadata device
Date:   Tue, 1 Mar 2022 05:04:36 +0000
Message-ID: <20220301050439.31785-10-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9d8f127-f73e-4e4d-f6ea-08d9fb4102cf
X-MS-TrafficTypeDiagnostic: DM4PR12MB6009:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB6009327DB6B04F1C02FF7244CB029@DM4PR12MB6009.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZX3te5EuKrz9QTrcKKL38ojA4IRac3+//ECZv1AO7SG04RUNVoc63lc//HzC+ffG4KQKxMFvaVdQz9fZu4MvWPOACfZW/hCZRzFqMXDUUkECDAYyIuJQUxFSLG7iow0pgJDCQNkFfzweGY6p3Od7qWtorletwb2LBkticY7rZ4HN8AFI5ed5hI/P+36GCUEfUG/8tJ11/SzWm6SKAhH/l3TIO3S0JVQ/CVVYt8XNJAMrGWs976VUzjZZPEpZksS1FRtgNOgpORC8lptAr70IBDpkdQ7j/g2kAB5oufacDX6j7rp/0v1nR7HvAxobL96aRxIQEdHDmst/KYkIoE1I/ipYv+MG/vvQDa5KSbNCY1KwcKdD08Ov8QS97rzbFBg75rEPL2k5vrBF/vzkim8xto0RjVALPM5tEwKQmZwVLfCKYWNrr8tGxfSZPv6CvXWzavbmPdKOLJ8H1jER4Qo8jXNzO9txsBTmSpJw0vR7V+Fq3EVuQjMJ9OxcATkm+T5fcaW9cwkfc2jnj38HmG+b2diMpEl9X5rZ17u/y1t5A7+QyoI115g6TBiUoEqCIOk9NNC7T8sQxR6dGrQqvdEnen9yW5gH2aAvJuZHqTdjN0mzVqFlFOCzy19dT67SoZxezD14U/+yhwpcZ3Ho0osW0QV1HKtFeCAIjH6A8+KLRlXAsaF8++DBrYGLgP199eKMXmgP7Azx4r+GsxKIUcRo3A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(26005)(426003)(186003)(36860700001)(336012)(82310400004)(4326008)(5660300002)(81166007)(1076003)(2906002)(8676002)(86362001)(70206006)(70586007)(107886003)(40460700003)(356005)(110136005)(2616005)(6666004)(316002)(54906003)(36756003)(47076005)(8936002)(30864003)(83380400001)(508600001)(36900700001)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:48.6859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d8f127-f73e-4e4d-f6ea-08d9fb4102cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6009
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds vnifiltering support to collect metadata device.

Motivation:
You can only use a single vxlan collect metadata device for a given
vxlan udp port in the system today. The vxlan collect metadata device
terminates all received vxlan packets. As shown in the below diagram,
there are use-cases where you need to support multiple such vxlan devices in
independent bridge domains. Each vxlan device must terminate the vni's
it is configured for.
Example usecase: In a service provider network a service provider
typically supports multiple bridge domains with overlapping vlans.
One bridge domain per customer. Vlans in each bridge domain are
mapped to globally unique vxlan ranges assigned to each customer.

vnifiltering support in collect metadata devices terminates only configured
vnis. This is similar to vlan filtering in bridge driver. The vni filtering
capability is provided by a new flag on collect metadata device.

In the below pic:
	- customer1 is mapped to br1 bridge domain
	- customer2 is mapped to br2 bridge domain
	- customer1 vlan 10-11 is mapped to vni 1001-1002
	- customer2 vlan 10-11 is mapped to vni 2001-2002
	- br1 and br2 are vlan filtering bridges
	- vxlan1 and vxlan2 are collect metadata devices with
	  vnifiltering enabled

┌──────────────────────────────────────────────────────────────────┐
│  switch                                                          │
│                                                                  │
│         ┌───────────┐                 ┌───────────┐              │
│         │           │                 │           │              │
│         │   br1     │                 │   br2     │              │
│         └┬─────────┬┘                 └──┬───────┬┘              │
│     vlans│         │               vlans │       │               │
│     10,11│         │                10,11│       │               │
│          │     vlanvnimap:               │    vlanvnimap:        │
│          │       10-1001,11-1002         │      10-2001,11-2002  │
│          │         │                     │       │               │
│   ┌──────┴┐     ┌──┴─────────┐       ┌───┴────┐  │               │
│   │ swp1  │     │vxlan1      │       │ swp2   │ ┌┴─────────────┐ │
│   │       │     │  vnifilter:│       │        │ │vxlan2        │ │
│   └───┬───┘     │   1001,1002│       └───┬────┘ │ vnifilter:   │ │
│       │         └────────────┘           │      │  2001,2002   │ │
│       │                                  │      └──────────────┘ │
│       │                                  │                       │
└───────┼──────────────────────────────────┼───────────────────────┘
        │                                  │
        │                                  │
  ┌─────┴───────┐                          │
  │  customer1  │                    ┌─────┴──────┐
  │ host/VM     │                    │customer2   │
  └─────────────┘                    │ host/VM    │
                                     └────────────┘

With this implementation, vxlan dst metadata device can
be associated with range of vnis.
struct vxlan_vni_node is introduced to represent
a configured vni. We start with vni and its
associated remote_ip in this structure. This
structure can be extended to bring in other
per vni attributes if there are usecases for it.
A vni inherits an attribute from the base vxlan device
if there is no per vni attributes defined.

struct vxlan_dev gets a new rhashtable for
vnis called vxlan_vni_group. vxlan_vnifilter.c
implements the necessary netlink api, notifications
and helper functions to process and manage lifecycle
of vxlan_vni_node.

This patch also adds new helper functions in vxlan_multicast.c
to handle per vni remote_ip multicast groups which are part
of vxlan_vni_group.

Fix build problems:
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/Makefile          |   2 +-
 drivers/net/vxlan/vxlan_core.c      |  96 +++-
 drivers/net/vxlan/vxlan_multicast.c | 150 ++++-
 drivers/net/vxlan/vxlan_private.h   |  41 +-
 drivers/net/vxlan/vxlan_vnifilter.c | 862 ++++++++++++++++++++++++++++
 include/net/vxlan.h                 |  28 +-
 6 files changed, 1147 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/vxlan/vxlan_vnifilter.c

diff --git a/drivers/net/vxlan/Makefile b/drivers/net/vxlan/Makefile
index 61c80e9c6c24..d4c255499b72 100644
--- a/drivers/net/vxlan/Makefile
+++ b/drivers/net/vxlan/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_VXLAN) += vxlan.o
 
-vxlan-objs := vxlan_core.o vxlan_multicast.o
+vxlan-objs := vxlan_core.o vxlan_multicast.o vxlan_vnifilter.o
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 11286e2191a1..a3c20ad18243 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -145,12 +145,19 @@ static struct vxlan_dev *vxlan_vs_find_vni(struct vxlan_sock *vs, int ifindex,
 	struct vxlan_dev_node *node;
 
 	/* For flow based devices, map all packets to VNI 0 */
-	if (vs->flags & VXLAN_F_COLLECT_METADATA)
+	if (vs->flags & VXLAN_F_COLLECT_METADATA &&
+	    !(vs->flags & VXLAN_F_VNIFILTER))
 		vni = 0;
 
 	hlist_for_each_entry_rcu(node, vni_head(vs, vni), hlist) {
-		if (node->vxlan->default_dst.remote_vni != vni)
+		if (!node->vxlan)
 			continue;
+		if (node->vxlan->cfg.flags & VXLAN_F_VNIFILTER) {
+			if (!vxlan_vnifilter_lookup(node->vxlan, vni))
+				continue;
+		} else if (node->vxlan->default_dst.remote_vni != vni) {
+			continue;
+		}
 
 		if (IS_ENABLED(CONFIG_IPV6)) {
 			const struct vxlan_config *cfg = &node->vxlan->cfg;
@@ -1478,7 +1485,10 @@ static void vxlan_sock_release(struct vxlan_dev *vxlan)
 	RCU_INIT_POINTER(vxlan->vn4_sock, NULL);
 	synchronize_net();
 
-	vxlan_vs_del_dev(vxlan);
+	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
+		vxlan_vs_del_vnigrp(vxlan);
+	else
+		vxlan_vs_del_dev(vxlan);
 
 	if (__vxlan_sock_release_prep(sock4)) {
 		udp_tunnel_sock_release(sock4->sock);
@@ -2857,6 +2867,9 @@ static int vxlan_init(struct net_device *dev)
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	int err;
 
+	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
+		vxlan_vnigroup_init(vxlan);
+
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!dev->tstats)
 		return -ENOMEM;
@@ -2886,6 +2899,9 @@ static void vxlan_uninit(struct net_device *dev)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 
+	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
+		vxlan_vnigroup_uninit(vxlan);
+
 	gro_cells_destroy(&vxlan->gro_cells);
 
 	vxlan_fdb_delete_default(vxlan, vxlan->cfg.vni);
@@ -2903,15 +2919,10 @@ static int vxlan_open(struct net_device *dev)
 	if (ret < 0)
 		return ret;
 
-	if (vxlan_addr_multicast(&vxlan->default_dst.remote_ip)) {
-		ret = vxlan_igmp_join(vxlan, &vxlan->default_dst.remote_ip,
-				      vxlan->default_dst.remote_ifindex);
-		if (ret == -EADDRINUSE)
-			ret = 0;
-		if (ret) {
-			vxlan_sock_release(vxlan);
-			return ret;
-		}
+	ret = vxlan_multicast_join(vxlan);
+	if (ret) {
+		vxlan_sock_release(vxlan);
+		return ret;
 	}
 
 	if (vxlan->cfg.age_interval)
@@ -2948,13 +2959,9 @@ static void vxlan_flush(struct vxlan_dev *vxlan, bool do_all)
 static int vxlan_stop(struct net_device *dev)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
-	struct vxlan_net *vn = net_generic(vxlan->net, vxlan_net_id);
 	int ret = 0;
 
-	if (vxlan_addr_multicast(&vxlan->default_dst.remote_ip) &&
-	    !vxlan_group_used(vn, vxlan, NULL, 0))
-		ret = vxlan_igmp_leave(vxlan, &vxlan->default_dst.remote_ip,
-				       vxlan->default_dst.remote_ifindex);
+	vxlan_multicast_leave(vxlan);
 
 	del_timer_sync(&vxlan->age_timer);
 
@@ -3184,6 +3191,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
 	[IFLA_VXLAN_REMCSUM_NOPARTIAL]	= { .type = NLA_FLAG },
 	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
 	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
+	[IFLA_VXLAN_VNIFILTER]	= { .type = NLA_U8 },
 };
 
 static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -3369,6 +3377,7 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, bool ipv6,
 static int __vxlan_sock_add(struct vxlan_dev *vxlan, bool ipv6)
 {
 	struct vxlan_net *vn = net_generic(vxlan->net, vxlan_net_id);
+	bool metadata = vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA;
 	struct vxlan_sock *vs = NULL;
 	struct vxlan_dev_node *node;
 	int l3mdev_index = 0;
@@ -3404,7 +3413,12 @@ static int __vxlan_sock_add(struct vxlan_dev *vxlan, bool ipv6)
 		rcu_assign_pointer(vxlan->vn4_sock, vs);
 		node = &vxlan->hlist4;
 	}
-	vxlan_vs_add_dev(vs, vxlan, node);
+
+	if (metadata && (vxlan->cfg.flags & VXLAN_F_VNIFILTER))
+		vxlan_vs_add_vnigrp(vxlan, vs, ipv6);
+	else
+		vxlan_vs_add_dev(vs, vxlan, node);
+
 	return 0;
 }
 
@@ -3431,8 +3445,8 @@ static int vxlan_sock_add(struct vxlan_dev *vxlan)
 	return ret;
 }
 
-static int vxlan_vni_in_use(struct net *src_net, struct vxlan_dev *vxlan,
-			    struct vxlan_config *conf, __be32 vni)
+int vxlan_vni_in_use(struct net *src_net, struct vxlan_dev *vxlan,
+		     struct vxlan_config *conf, __be32 vni)
 {
 	struct vxlan_net *vn = net_generic(src_net, vxlan_net_id);
 	struct vxlan_dev *tmp;
@@ -3440,8 +3454,12 @@ static int vxlan_vni_in_use(struct net *src_net, struct vxlan_dev *vxlan,
 	list_for_each_entry(tmp, &vn->vxlan_list, next) {
 		if (tmp == vxlan)
 			continue;
-		if (tmp->cfg.vni != vni)
+		if (tmp->cfg.flags & VXLAN_F_VNIFILTER) {
+			if (!vxlan_vnifilter_lookup(tmp, vni))
+				continue;
+		} else if (tmp->cfg.vni != vni) {
 			continue;
+		}
 		if (tmp->cfg.dst_port != conf->dst_port)
 			continue;
 		if ((tmp->cfg.flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)) !=
@@ -4051,6 +4069,21 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 	if (data[IFLA_VXLAN_DF])
 		conf->df = nla_get_u8(data[IFLA_VXLAN_DF]);
 
+	if (data[IFLA_VXLAN_VNIFILTER]) {
+		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_VNIFILTER,
+				    VXLAN_F_VNIFILTER, changelink, false,
+				    extack);
+		if (err)
+			return err;
+
+		if ((conf->flags & VXLAN_F_VNIFILTER) &&
+		    !(conf->flags & VXLAN_F_COLLECT_METADATA)) {
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_VXLAN_VNIFILTER],
+					    "vxlan vnifilter only valid in collect metadata mode");
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -4126,6 +4159,19 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 					   dst->remote_ifindex,
 					   true);
 		spin_unlock_bh(&vxlan->hash_lock[hash_index]);
+
+		/* If vni filtering device, also update fdb entries of
+		 * all vnis that were using default remote ip
+		 */
+		if (vxlan->cfg.flags & VXLAN_F_VNIFILTER) {
+			err = vxlan_vnilist_update_group(vxlan, &dst->remote_ip,
+							 &conf.remote_ip, extack);
+			if (err) {
+				netdev_adjacent_change_abort(dst->remote_dev,
+							     lowerdev, dev);
+				return err;
+			}
+		}
 	}
 
 	if (conf.age_interval != vxlan->cfg.age_interval)
@@ -4271,6 +4317,11 @@ static int vxlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put_flag(skb, IFLA_VXLAN_REMCSUM_NOPARTIAL))
 		goto nla_put_failure;
 
+	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER &&
+	    nla_put_u8(skb, IFLA_VXLAN_VNIFILTER,
+		       !!(vxlan->cfg.flags & VXLAN_F_VNIFILTER)))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
@@ -4630,6 +4681,8 @@ static int __init vxlan_init_module(void)
 	if (rc)
 		goto out4;
 
+	vxlan_vnifilter_init();
+
 	return 0;
 out4:
 	unregister_switchdev_notifier(&vxlan_switchdev_notifier_block);
@@ -4644,6 +4697,7 @@ late_initcall(vxlan_init_module);
 
 static void __exit vxlan_cleanup_module(void)
 {
+	vxlan_vnifilter_uninit();
 	rtnl_link_unregister(&vxlan_link_ops);
 	unregister_switchdev_notifier(&vxlan_switchdev_notifier_block);
 	unregister_netdevice_notifier(&vxlan_notifier_block);
diff --git a/drivers/net/vxlan/vxlan_multicast.c b/drivers/net/vxlan/vxlan_multicast.c
index b1f5505e7370..a7f2d67dc61b 100644
--- a/drivers/net/vxlan/vxlan_multicast.c
+++ b/drivers/net/vxlan/vxlan_multicast.c
@@ -82,9 +82,48 @@ int vxlan_igmp_leave(struct vxlan_dev *vxlan, union vxlan_addr *rip,
 	return ret;
 }
 
+static bool vxlan_group_used_match(union vxlan_addr *ip, int ifindex,
+				   union vxlan_addr *rip, int rifindex)
+{
+	if (!vxlan_addr_multicast(rip))
+		return false;
+
+	if (!vxlan_addr_equal(rip, ip))
+		return false;
+
+	if (rifindex != ifindex)
+		return false;
+
+	return true;
+}
+
+static bool vxlan_group_used_by_vnifilter(struct vxlan_dev *vxlan,
+					  union vxlan_addr *ip, int ifindex)
+{
+	struct vxlan_vni_group *vg = rtnl_dereference(vxlan->vnigrp);
+	struct vxlan_vni_node *v, *tmp;
+
+	if (vxlan_group_used_match(ip, ifindex,
+				   &vxlan->default_dst.remote_ip,
+				   vxlan->default_dst.remote_ifindex))
+		return true;
+
+	list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
+		if (!vxlan_addr_multicast(&v->remote_ip))
+			continue;
+
+		if (vxlan_group_used_match(ip, ifindex,
+					   &v->remote_ip,
+					   vxlan->default_dst.remote_ifindex))
+			return true;
+	}
+
+	return false;
+}
+
 /* See if multicast group is already in use by other ID */
 bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev,
-		      union vxlan_addr *rip, int rifindex)
+		      __be32 vni, union vxlan_addr *rip, int rifindex)
 {
 	union vxlan_addr *ip = (rip ? : &dev->default_dst.remote_ip);
 	int ifindex = (rifindex ? : dev->default_dst.remote_ifindex);
@@ -121,14 +160,113 @@ bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev,
 		    rtnl_dereference(vxlan->vn6_sock) != sock6)
 			continue;
 #endif
-		if (!vxlan_addr_equal(&vxlan->default_dst.remote_ip, ip))
-			continue;
-
-		if (vxlan->default_dst.remote_ifindex != ifindex)
-			continue;
+		if (vxlan->cfg.flags & VXLAN_F_VNIFILTER) {
+			if (!vxlan_group_used_by_vnifilter(vxlan, ip, ifindex))
+				continue;
+		} else {
+			if (!vxlan_group_used_match(ip, ifindex,
+						    &vxlan->default_dst.remote_ip,
+						    vxlan->default_dst.remote_ifindex))
+				continue;
+		}
 
 		return true;
 	}
 
 	return false;
 }
+
+static int vxlan_multicast_join_vnigrp(struct vxlan_dev *vxlan)
+{
+	struct vxlan_vni_group *vg = rtnl_dereference(vxlan->vnigrp);
+	struct vxlan_vni_node *v, *tmp, *vgood = NULL;
+	int ret = 0;
+
+	list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
+		if (!vxlan_addr_multicast(&v->remote_ip))
+			continue;
+		/* skip if address is same as default address */
+		if (vxlan_addr_equal(&v->remote_ip,
+				     &vxlan->default_dst.remote_ip))
+			continue;
+		ret = vxlan_igmp_join(vxlan, &v->remote_ip, 0);
+		if (ret == -EADDRINUSE)
+			ret = 0;
+		if (ret)
+			goto out;
+		vgood = v;
+	}
+out:
+	if (ret) {
+		list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
+			if (!vxlan_addr_multicast(&v->remote_ip))
+				continue;
+			if (vxlan_addr_equal(&v->remote_ip,
+					     &vxlan->default_dst.remote_ip))
+				continue;
+			vxlan_igmp_leave(vxlan, &v->remote_ip, 0);
+			if (v == vgood)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static int vxlan_multicast_leave_vnigrp(struct vxlan_dev *vxlan)
+{
+	struct vxlan_net *vn = net_generic(vxlan->net, vxlan_net_id);
+	struct vxlan_vni_group *vg = rtnl_dereference(vxlan->vnigrp);
+	struct vxlan_vni_node *v, *tmp;
+	int last_err = 0, ret;
+
+	list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
+		if (vxlan_addr_multicast(&v->remote_ip) &&
+		    !vxlan_group_used(vn, vxlan, v->vni, &v->remote_ip,
+				      0)) {
+			ret = vxlan_igmp_leave(vxlan, &v->remote_ip, 0);
+			if (ret)
+				last_err = ret;
+		}
+	}
+
+	return last_err;
+}
+
+int vxlan_multicast_join(struct vxlan_dev *vxlan)
+{
+	int ret = 0;
+
+	if (vxlan_addr_multicast(&vxlan->default_dst.remote_ip)) {
+		ret = vxlan_igmp_join(vxlan, &vxlan->default_dst.remote_ip,
+				      vxlan->default_dst.remote_ifindex);
+		if (ret == -EADDRINUSE)
+			ret = 0;
+		if (ret)
+			return ret;
+	}
+
+	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
+		return vxlan_multicast_join_vnigrp(vxlan);
+
+	return 0;
+}
+
+int vxlan_multicast_leave(struct vxlan_dev *vxlan)
+{
+	struct vxlan_net *vn = net_generic(vxlan->net, vxlan_net_id);
+	int ret = 0;
+
+	if (vxlan_addr_multicast(&vxlan->default_dst.remote_ip) &&
+	    !vxlan_group_used(vn, vxlan, 0, NULL, 0)) {
+		ret = vxlan_igmp_leave(vxlan, &vxlan->default_dst.remote_ip,
+				       vxlan->default_dst.remote_ifindex);
+		if (ret)
+			return ret;
+	}
+
+	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
+		return vxlan_multicast_leave_vnigrp(vxlan);
+
+	return 0;
+}
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 7a946010a204..472d2f0b5b90 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -7,8 +7,11 @@
 #ifndef _VXLAN_PRIVATE_H
 #define _VXLAN_PRIVATE_H
 
+#include <linux/rhashtable.h>
+
 extern unsigned int vxlan_net_id;
 extern const u8 all_zeros_mac[ETH_ALEN + 2];
+extern const struct rhashtable_params vxlan_vni_rht_params;
 
 #define PORT_HASH_BITS	8
 #define PORT_HASH_SIZE  (1 << PORT_HASH_BITS)
@@ -92,6 +95,19 @@ bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
 
 #endif
 
+static inline struct vxlan_vni_node *
+vxlan_vnifilter_lookup(struct vxlan_dev *vxlan, __be32 vni)
+{
+	struct vxlan_vni_group *vg;
+
+	vg = rcu_dereference_rtnl(vxlan->vnigrp);
+	if (!vg)
+		return NULL;
+
+	return rhashtable_lookup_fast(&vg->vni_hash, &vni,
+				      vxlan_vni_rht_params);
+}
+
 /* vxlan_core.c */
 int vxlan_fdb_create(struct vxlan_dev *vxlan,
 		     const u8 *mac, union vxlan_addr *ip,
@@ -111,12 +127,33 @@ int vxlan_fdb_update(struct vxlan_dev *vxlan,
 		     __be16 port, __be32 src_vni, __be32 vni,
 		     __u32 ifindex, __u16 ndm_flags, u32 nhid,
 		     bool swdev_notify, struct netlink_ext_ack *extack);
+int vxlan_vni_in_use(struct net *src_net, struct vxlan_dev *vxlan,
+		     struct vxlan_config *conf, __be32 vni);
+
+/* vxlan_vnifilter.c */
+int vxlan_vnigroup_init(struct vxlan_dev *vxlan);
+void vxlan_vnigroup_uninit(struct vxlan_dev *vxlan);
+
+void vxlan_vnifilter_init(void);
+void vxlan_vnifilter_uninit(void);
+
+void vxlan_vs_add_vnigrp(struct vxlan_dev *vxlan,
+			 struct vxlan_sock *vs,
+			 bool ipv6);
+void vxlan_vs_del_vnigrp(struct vxlan_dev *vxlan);
+int vxlan_vnilist_update_group(struct vxlan_dev *vxlan,
+			       union vxlan_addr *old_remote_ip,
+			       union vxlan_addr *new_remote_ip,
+			       struct netlink_ext_ack *extack);
+
 
 /* vxlan_multicast.c */
+int vxlan_multicast_join(struct vxlan_dev *vxlan);
+int vxlan_multicast_leave(struct vxlan_dev *vxlan);
+bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev,
+		      __be32 vni, union vxlan_addr *rip, int rifindex);
 int vxlan_igmp_join(struct vxlan_dev *vxlan, union vxlan_addr *rip,
 		    int rifindex);
 int vxlan_igmp_leave(struct vxlan_dev *vxlan, union vxlan_addr *rip,
 		     int rifindex);
-bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev,
-		      union vxlan_addr *rip, int rifindex);
 #endif
diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
new file mode 100644
index 000000000000..43a2d612e73a
--- /dev/null
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -0,0 +1,862 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *	Vxlan vni filter for collect metadata mode
+ *
+ *	Authors: Roopa Prabhu <roopa@nvidia.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/etherdevice.h>
+#include <linux/rhashtable.h>
+#include <net/rtnetlink.h>
+#include <net/net_namespace.h>
+#include <net/sock.h>
+#include <net/vxlan.h>
+
+#include "vxlan_private.h"
+
+static inline int vxlan_vni_cmp(struct rhashtable_compare_arg *arg,
+				const void *ptr)
+{
+	const struct vxlan_vni_node *vnode = ptr;
+	__be32 vni = *(__be32 *)arg->key;
+
+	return vnode->vni != vni;
+}
+
+const struct rhashtable_params vxlan_vni_rht_params = {
+	.head_offset = offsetof(struct vxlan_vni_node, vnode),
+	.key_offset = offsetof(struct vxlan_vni_node, vni),
+	.key_len = sizeof(__be32),
+	.nelem_hint = 3,
+	.max_size = VXLAN_N_VID,
+	.obj_cmpfn = vxlan_vni_cmp,
+	.automatic_shrinking = true,
+};
+
+static void vxlan_vs_add_del_vninode(struct vxlan_dev *vxlan,
+				     struct vxlan_vni_node *v,
+				     bool del)
+{
+	struct vxlan_net *vn = net_generic(vxlan->net, vxlan_net_id);
+	struct vxlan_dev_node *node;
+	struct vxlan_sock *vs;
+
+	spin_lock(&vn->sock_lock);
+	if (del) {
+		if (!hlist_unhashed(&v->hlist4.hlist))
+			hlist_del_init_rcu(&v->hlist4.hlist);
+#if IS_ENABLED(CONFIG_IPV6)
+		if (!hlist_unhashed(&v->hlist6.hlist))
+			hlist_del_init_rcu(&v->hlist6.hlist);
+#endif
+		goto out;
+	}
+
+#if IS_ENABLED(CONFIG_IPV6)
+	vs = rtnl_dereference(vxlan->vn6_sock);
+	if (vs && v) {
+		node = &v->hlist6;
+		hlist_add_head_rcu(&node->hlist, vni_head(vs, v->vni));
+	}
+#endif
+	vs = rtnl_dereference(vxlan->vn4_sock);
+	if (vs && v) {
+		node = &v->hlist4;
+		hlist_add_head_rcu(&node->hlist, vni_head(vs, v->vni));
+	}
+out:
+	spin_unlock(&vn->sock_lock);
+}
+
+void vxlan_vs_add_vnigrp(struct vxlan_dev *vxlan,
+			 struct vxlan_sock *vs,
+			 bool ipv6)
+{
+	struct vxlan_net *vn = net_generic(vxlan->net, vxlan_net_id);
+	struct vxlan_vni_group *vg = rtnl_dereference(vxlan->vnigrp);
+	struct vxlan_vni_node *v, *tmp;
+	struct vxlan_dev_node *node;
+
+	if (!vg)
+		return;
+
+	spin_lock(&vn->sock_lock);
+	list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
+#if IS_ENABLED(CONFIG_IPV6)
+		if (ipv6)
+			node = &v->hlist6;
+		else
+#endif
+			node = &v->hlist4;
+		node->vxlan = vxlan;
+		hlist_add_head_rcu(&node->hlist, vni_head(vs, v->vni));
+	}
+	spin_unlock(&vn->sock_lock);
+}
+
+void vxlan_vs_del_vnigrp(struct vxlan_dev *vxlan)
+{
+	struct vxlan_vni_group *vg = rtnl_dereference(vxlan->vnigrp);
+	struct vxlan_net *vn = net_generic(vxlan->net, vxlan_net_id);
+	struct vxlan_vni_node *v, *tmp;
+
+	if (!vg)
+		return;
+
+	spin_lock(&vn->sock_lock);
+	list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
+		hlist_del_init_rcu(&v->hlist4.hlist);
+#if IS_ENABLED(CONFIG_IPV6)
+		hlist_del_init_rcu(&v->hlist6.hlist);
+#endif
+	}
+	spin_unlock(&vn->sock_lock);
+}
+
+static u32 vnirange(struct vxlan_vni_node *vbegin,
+		    struct vxlan_vni_node *vend)
+{
+	return (be32_to_cpu(vend->vni) - be32_to_cpu(vbegin->vni));
+}
+
+static size_t vxlan_vnifilter_entry_nlmsg_size(void)
+{
+	return NLMSG_ALIGN(sizeof(struct tunnel_msg))
+		+ nla_total_size(0) /* VXLAN_VNIFILTER_ENTRY */
+		+ nla_total_size(sizeof(u32)) /* VXLAN_VNIFILTER_ENTRY_START */
+		+ nla_total_size(sizeof(u32)) /* VXLAN_VNIFILTER_ENTRY_END */
+		+ nla_total_size(sizeof(struct in6_addr));/* VXLAN_VNIFILTER_ENTRY_GROUP{6} */
+}
+
+static bool vxlan_fill_vni_filter_entry(struct sk_buff *skb,
+					struct vxlan_vni_node *vbegin,
+					struct vxlan_vni_node *vend)
+{
+	struct nlattr *ventry;
+	u32 vs = be32_to_cpu(vbegin->vni);
+	u32 ve = 0;
+
+	if (vbegin != vend)
+		ve = be32_to_cpu(vend->vni);
+
+	ventry = nla_nest_start(skb, VXLAN_VNIFILTER_ENTRY);
+	if (!ventry)
+		return false;
+
+	if (nla_put_u32(skb, VXLAN_VNIFILTER_ENTRY_START, vs))
+		goto out_err;
+
+	if (ve && nla_put_u32(skb, VXLAN_VNIFILTER_ENTRY_END, ve))
+		goto out_err;
+
+	if (!vxlan_addr_any(&vbegin->remote_ip)) {
+		if (vbegin->remote_ip.sa.sa_family == AF_INET) {
+			if (nla_put_in_addr(skb, VXLAN_VNIFILTER_ENTRY_GROUP,
+					    vbegin->remote_ip.sin.sin_addr.s_addr))
+				goto out_err;
+#if IS_ENABLED(CONFIG_IPV6)
+		} else {
+			if (nla_put_in6_addr(skb, VXLAN_VNIFILTER_ENTRY_GROUP6,
+					     &vbegin->remote_ip.sin6.sin6_addr))
+				goto out_err;
+#endif
+		}
+	}
+
+	nla_nest_end(skb, ventry);
+
+	return true;
+
+out_err:
+	nla_nest_cancel(skb, ventry);
+
+	return false;
+}
+
+static void vxlan_vnifilter_notify(const struct vxlan_dev *vxlan,
+				   struct vxlan_vni_node *vninode, int cmd)
+{
+	struct tunnel_msg *tmsg;
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct net *net = dev_net(vxlan->dev);
+	int err = -ENOBUFS;
+
+	skb = nlmsg_new(vxlan_vnifilter_entry_nlmsg_size(), GFP_KERNEL);
+	if (!skb)
+		goto out_err;
+
+	err = -EMSGSIZE;
+	nlh = nlmsg_put(skb, 0, 0, cmd, sizeof(*tmsg), 0);
+	if (!nlh)
+		goto out_err;
+	tmsg = nlmsg_data(nlh);
+	memset(tmsg, 0, sizeof(*tmsg));
+	tmsg->family = AF_BRIDGE;
+	tmsg->ifindex = vxlan->dev->ifindex;
+
+	if (!vxlan_fill_vni_filter_entry(skb, vninode, vninode))
+		goto out_err;
+
+	nlmsg_end(skb, nlh);
+	rtnl_notify(skb, net, 0, RTNLGRP_TUNNEL, NULL, GFP_KERNEL);
+
+	return;
+
+out_err:
+	rtnl_set_sk_err(net, RTNLGRP_TUNNEL, err);
+
+	kfree_skb(skb);
+}
+
+static int vxlan_vnifilter_dump_dev(const struct net_device *dev,
+				    struct sk_buff *skb,
+				    struct netlink_callback *cb)
+{
+	struct vxlan_vni_node *tmp, *v, *vbegin = NULL, *vend = NULL;
+	struct vxlan_dev *vxlan = netdev_priv(dev);
+	struct tunnel_msg *new_tmsg;
+	int idx = 0, s_idx = cb->args[1];
+	struct vxlan_vni_group *vg;
+	struct nlmsghdr *nlh;
+	int err = 0;
+
+	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
+		return -EINVAL;
+
+	/* RCU needed because of the vni locking rules (rcu || rtnl) */
+	vg = rcu_dereference(vxlan->vnigrp);
+	if (!vg || !vg->num_vnis)
+		return 0;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			RTM_NEWTUNNEL, sizeof(*new_tmsg), NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+	new_tmsg = nlmsg_data(nlh);
+	memset(new_tmsg, 0, sizeof(*new_tmsg));
+	new_tmsg->family = PF_BRIDGE;
+	new_tmsg->ifindex = dev->ifindex;
+
+	list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
+		if (idx < s_idx) {
+			idx++;
+			continue;
+		}
+		if (!vbegin) {
+			vbegin = v;
+			vend = v;
+			continue;
+		}
+		if (vnirange(vend, v) == 1 &&
+		    vxlan_addr_equal(&v->remote_ip, &vend->remote_ip)) {
+			goto update_end;
+		} else {
+			if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend)) {
+				err = -EMSGSIZE;
+				break;
+			}
+			idx += vnirange(vbegin, vend) + 1;
+			vbegin = v;
+		}
+update_end:
+		vend = v;
+	}
+
+	if (!err && vbegin) {
+		if (!vxlan_fill_vni_filter_entry(skb, vbegin, vend))
+			err = -EMSGSIZE;
+	}
+
+	cb->args[1] = err ? idx : 0;
+
+	nlmsg_end(skb, nlh);
+
+	return err;
+}
+
+static int vxlan_vnifilter_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	int idx = 0, err = 0, s_idx = cb->args[0];
+	struct net *net = sock_net(skb->sk);
+	struct tunnel_msg *tmsg;
+	struct net_device *dev;
+
+	tmsg = nlmsg_data(cb->nlh);
+
+	rcu_read_lock();
+	if (tmsg->ifindex) {
+		dev = dev_get_by_index_rcu(net, tmsg->ifindex);
+		if (!dev) {
+			err = -ENODEV;
+			goto out_err;
+		}
+		err = vxlan_vnifilter_dump_dev(dev, skb, cb);
+		/* if the dump completed without an error we return 0 here */
+		if (err != -EMSGSIZE)
+			goto out_err;
+	} else {
+		for_each_netdev_rcu(net, dev) {
+			if (!netif_is_vxlan(dev))
+				continue;
+			if (idx < s_idx)
+				goto skip;
+			err = vxlan_vnifilter_dump_dev(dev, skb, cb);
+			if (err == -EMSGSIZE)
+				break;
+skip:
+			idx++;
+		}
+	}
+	cb->args[0] = idx;
+	rcu_read_unlock();
+
+	return skb->len;
+
+out_err:
+	rcu_read_unlock();
+
+	return err;
+}
+
+static const struct nla_policy vni_filter_entry_policy[VXLAN_VNIFILTER_ENTRY_MAX + 1] = {
+	[VXLAN_VNIFILTER_ENTRY_START] = { .type = NLA_U32 },
+	[VXLAN_VNIFILTER_ENTRY_END] = { .type = NLA_U32 },
+	[VXLAN_VNIFILTER_ENTRY_GROUP]	= { .type = NLA_BINARY,
+					    .len = sizeof_field(struct iphdr, daddr) },
+	[VXLAN_VNIFILTER_ENTRY_GROUP6]	= { .type = NLA_BINARY,
+					    .len = sizeof(struct in6_addr) },
+};
+
+static const struct nla_policy vni_filter_policy[VXLAN_VNIFILTER_MAX + 1] = {
+	[VXLAN_VNIFILTER_ENTRY] = { .type = NLA_NESTED },
+};
+
+static int vxlan_update_default_fdb_entry(struct vxlan_dev *vxlan, __be32 vni,
+					  union vxlan_addr *old_remote_ip,
+					  union vxlan_addr *remote_ip,
+					  struct netlink_ext_ack *extack)
+{
+	struct vxlan_rdst *dst = &vxlan->default_dst;
+	u32 hash_index;
+	int err = 0;
+
+	hash_index = fdb_head_index(vxlan, all_zeros_mac, vni);
+	spin_lock_bh(&vxlan->hash_lock[hash_index]);
+	if (remote_ip && !vxlan_addr_any(remote_ip)) {
+		err = vxlan_fdb_update(vxlan, all_zeros_mac,
+				       remote_ip,
+				       NUD_REACHABLE | NUD_PERMANENT,
+				       NLM_F_APPEND | NLM_F_CREATE,
+				       vxlan->cfg.dst_port,
+				       vni,
+				       vni,
+				       dst->remote_ifindex,
+				       NTF_SELF, 0, true, extack);
+		if (err) {
+			spin_unlock_bh(&vxlan->hash_lock[hash_index]);
+			return err;
+		}
+	}
+
+	if (old_remote_ip && !vxlan_addr_any(old_remote_ip)) {
+		__vxlan_fdb_delete(vxlan, all_zeros_mac,
+				   *old_remote_ip,
+				   vxlan->cfg.dst_port,
+				   vni, vni,
+				   dst->remote_ifindex,
+				   true);
+	}
+	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
+
+	return err;
+}
+
+static int vxlan_vni_update_group(struct vxlan_dev *vxlan,
+				  struct vxlan_vni_node *vninode,
+				  union vxlan_addr *group,
+				  bool create, bool *changed,
+				  struct netlink_ext_ack *extack)
+{
+	struct vxlan_net *vn = net_generic(vxlan->net, vxlan_net_id);
+	struct vxlan_rdst *dst = &vxlan->default_dst;
+	union vxlan_addr *newrip = NULL, *oldrip = NULL;
+	union vxlan_addr old_remote_ip;
+	int ret = 0;
+
+	memcpy(&old_remote_ip, &vninode->remote_ip, sizeof(old_remote_ip));
+
+	/* if per vni remote ip is not present use vxlan dev
+	 * default dst remote ip for fdb entry
+	 */
+	if (group && !vxlan_addr_any(group)) {
+		newrip = group;
+	} else {
+		if (!vxlan_addr_any(&dst->remote_ip))
+			newrip = &dst->remote_ip;
+	}
+
+	/* if old rip exists, and no newrip,
+	 * explicitly delete old rip
+	 */
+	if (!newrip && !vxlan_addr_any(&old_remote_ip))
+		oldrip = &old_remote_ip;
+
+	if (!newrip && !oldrip)
+		return 0;
+
+	if (!create && oldrip && newrip && vxlan_addr_equal(oldrip, newrip))
+		return 0;
+
+	ret = vxlan_update_default_fdb_entry(vxlan, vninode->vni,
+					     oldrip, newrip,
+					     extack);
+	if (ret)
+		goto out;
+
+	if (group)
+		memcpy(&vninode->remote_ip, group, sizeof(vninode->remote_ip));
+
+	if (vxlan->dev->flags & IFF_UP) {
+		if (vxlan_addr_multicast(&old_remote_ip) &&
+		    !vxlan_group_used(vn, vxlan, vninode->vni,
+				      &old_remote_ip,
+				      vxlan->default_dst.remote_ifindex)) {
+			ret = vxlan_igmp_leave(vxlan, &old_remote_ip,
+					       0);
+			if (ret)
+				goto out;
+		}
+
+		if (vxlan_addr_multicast(&vninode->remote_ip)) {
+			ret = vxlan_igmp_join(vxlan, &vninode->remote_ip, 0);
+			if (ret == -EADDRINUSE)
+				ret = 0;
+			if (ret)
+				goto out;
+		}
+	}
+
+	*changed = true;
+
+	return 0;
+out:
+	return ret;
+}
+
+int vxlan_vnilist_update_group(struct vxlan_dev *vxlan,
+			       union vxlan_addr *old_remote_ip,
+			       union vxlan_addr *new_remote_ip,
+			       struct netlink_ext_ack *extack)
+{
+	struct list_head *headp, *hpos;
+	struct vxlan_vni_group *vg;
+	struct vxlan_vni_node *vent;
+	int ret;
+
+	vg = rtnl_dereference(vxlan->vnigrp);
+
+	headp = &vg->vni_list;
+	list_for_each_prev(hpos, headp) {
+		vent = list_entry(hpos, struct vxlan_vni_node, vlist);
+		if (vxlan_addr_any(&vent->remote_ip)) {
+			ret = vxlan_update_default_fdb_entry(vxlan, vent->vni,
+							     old_remote_ip,
+							     new_remote_ip,
+							     extack);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void vxlan_vni_delete_group(struct vxlan_dev *vxlan,
+				   struct vxlan_vni_node *vninode)
+{
+	struct vxlan_net *vn = net_generic(vxlan->net, vxlan_net_id);
+	struct vxlan_rdst *dst = &vxlan->default_dst;
+
+	/* if per vni remote_ip not present, delete the
+	 * default dst remote_ip previously added for this vni
+	 */
+	if (!vxlan_addr_any(&vninode->remote_ip) ||
+	    !vxlan_addr_any(&dst->remote_ip))
+		__vxlan_fdb_delete(vxlan, all_zeros_mac,
+				   (vxlan_addr_any(&vninode->remote_ip) ?
+				   dst->remote_ip : vninode->remote_ip),
+				   vxlan->cfg.dst_port,
+				   vninode->vni, vninode->vni,
+				   dst->remote_ifindex,
+				   true);
+
+	if (vxlan->dev->flags & IFF_UP) {
+		if (vxlan_addr_multicast(&vninode->remote_ip) &&
+		    !vxlan_group_used(vn, vxlan, vninode->vni,
+				      &vninode->remote_ip,
+				      dst->remote_ifindex)) {
+			vxlan_igmp_leave(vxlan, &vninode->remote_ip, 0);
+		}
+	}
+}
+
+static int vxlan_vni_update(struct vxlan_dev *vxlan,
+			    struct vxlan_vni_group *vg,
+			    __be32 vni, union vxlan_addr *group,
+			    bool *changed,
+			    struct netlink_ext_ack *extack)
+{
+	struct vxlan_vni_node *vninode;
+	int ret;
+
+	vninode = rhashtable_lookup_fast(&vg->vni_hash, &vni,
+					 vxlan_vni_rht_params);
+	if (!vninode)
+		return 0;
+
+	ret = vxlan_vni_update_group(vxlan, vninode, group, false, changed,
+				     extack);
+	if (ret)
+		return ret;
+
+	if (changed)
+		vxlan_vnifilter_notify(vxlan, vninode, RTM_NEWTUNNEL);
+
+	return 0;
+}
+
+static void __vxlan_vni_add_list(struct vxlan_vni_group *vg,
+				 struct vxlan_vni_node *v)
+{
+	struct list_head *headp, *hpos;
+	struct vxlan_vni_node *vent;
+
+	headp = &vg->vni_list;
+	list_for_each_prev(hpos, headp) {
+		vent = list_entry(hpos, struct vxlan_vni_node, vlist);
+		if (be32_to_cpu(v->vni) < be32_to_cpu(vent->vni))
+			continue;
+		else
+			break;
+	}
+	list_add_rcu(&v->vlist, hpos);
+	vg->num_vnis++;
+}
+
+static void __vxlan_vni_del_list(struct vxlan_vni_group *vg,
+				 struct vxlan_vni_node *v)
+{
+	list_del_rcu(&v->vlist);
+	vg->num_vnis--;
+}
+
+static struct vxlan_vni_node *vxlan_vni_alloc(struct vxlan_dev *vxlan,
+					      __be32 vni)
+{
+	struct vxlan_vni_node *vninode;
+
+	vninode = kzalloc(sizeof(*vninode), GFP_ATOMIC);
+	if (!vninode)
+		return NULL;
+	vninode->vni = vni;
+	vninode->hlist4.vxlan = vxlan;
+#if IS_ENABLED(CONFIG_IPV6)
+	vninode->hlist6.vxlan = vxlan;
+#endif
+
+	return vninode;
+}
+
+static int vxlan_vni_add(struct vxlan_dev *vxlan,
+			 struct vxlan_vni_group *vg,
+			 u32 vni, union vxlan_addr *group,
+			 struct netlink_ext_ack *extack)
+{
+	struct vxlan_vni_node *vninode;
+	__be32 v = cpu_to_be32(vni);
+	bool changed = false;
+	int err = 0;
+
+	if (vxlan_vnifilter_lookup(vxlan, v))
+		return vxlan_vni_update(vxlan, vg, v, group, &changed, extack);
+
+	err = vxlan_vni_in_use(vxlan->net, vxlan, &vxlan->cfg, v);
+	if (err) {
+		NL_SET_ERR_MSG(extack, "VNI in use");
+		return err;
+	}
+
+	vninode = vxlan_vni_alloc(vxlan, v);
+	if (!vninode)
+		return -ENOMEM;
+
+	err = rhashtable_lookup_insert_fast(&vg->vni_hash,
+					    &vninode->vnode,
+					    vxlan_vni_rht_params);
+	if (err) {
+		kfree(vninode);
+		return err;
+	}
+
+	__vxlan_vni_add_list(vg, vninode);
+
+	if (vxlan->dev->flags & IFF_UP)
+		vxlan_vs_add_del_vninode(vxlan, vninode, false);
+
+	err = vxlan_vni_update_group(vxlan, vninode, group, true, &changed,
+				     extack);
+
+	if (changed)
+		vxlan_vnifilter_notify(vxlan, vninode, RTM_NEWTUNNEL);
+
+	return err;
+}
+
+static void vxlan_vni_node_rcu_free(struct rcu_head *rcu)
+{
+	struct vxlan_vni_node *v;
+
+	v = container_of(rcu, struct vxlan_vni_node, rcu);
+	kfree(v);
+}
+
+static int vxlan_vni_del(struct vxlan_dev *vxlan,
+			 struct vxlan_vni_group *vg,
+			 u32 vni, struct netlink_ext_ack *extack)
+{
+	struct vxlan_vni_node *vninode;
+	__be32 v = cpu_to_be32(vni);
+	int err = 0;
+
+	vg = rtnl_dereference(vxlan->vnigrp);
+
+	vninode = rhashtable_lookup_fast(&vg->vni_hash, &v,
+					 vxlan_vni_rht_params);
+	if (!vninode) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	vxlan_vni_delete_group(vxlan, vninode);
+
+	err = rhashtable_remove_fast(&vg->vni_hash,
+				     &vninode->vnode,
+				     vxlan_vni_rht_params);
+	if (err)
+		goto out;
+
+	__vxlan_vni_del_list(vg, vninode);
+
+	vxlan_vnifilter_notify(vxlan, vninode, RTM_DELTUNNEL);
+
+	if (vxlan->dev->flags & IFF_UP)
+		vxlan_vs_add_del_vninode(vxlan, vninode, true);
+
+	call_rcu(&vninode->rcu, vxlan_vni_node_rcu_free);
+
+	return 0;
+out:
+	return err;
+}
+
+static int vxlan_vni_add_del(struct vxlan_dev *vxlan, __u32 start_vni,
+			     __u32 end_vni, union vxlan_addr *group,
+			     int cmd, struct netlink_ext_ack *extack)
+{
+	struct vxlan_vni_group *vg;
+	int v, err = 0;
+
+	vg = rtnl_dereference(vxlan->vnigrp);
+
+	for (v = start_vni; v <= end_vni; v++) {
+		switch (cmd) {
+		case RTM_NEWTUNNEL:
+			err = vxlan_vni_add(vxlan, vg, v, group, extack);
+			break;
+		case RTM_DELTUNNEL:
+			err = vxlan_vni_del(vxlan, vg, v, extack);
+			break;
+		default:
+			err = -EOPNOTSUPP;
+			break;
+		}
+		if (err)
+			goto out;
+	}
+
+	return 0;
+out:
+	return err;
+}
+
+static int vxlan_process_vni_filter(struct vxlan_dev *vxlan,
+				    struct nlattr *nlvnifilter,
+				    int cmd, struct netlink_ext_ack *extack)
+{
+	struct nlattr *vattrs[VXLAN_VNIFILTER_ENTRY_MAX + 1];
+	u32 vni_start = 0, vni_end = 0;
+	union vxlan_addr group;
+	int err;
+
+	err = nla_parse_nested(vattrs,
+			       VXLAN_VNIFILTER_ENTRY_MAX,
+			       nlvnifilter, vni_filter_entry_policy,
+			       extack);
+	if (err)
+		return err;
+
+	if (vattrs[VXLAN_VNIFILTER_ENTRY_START]) {
+		vni_start = nla_get_u32(vattrs[VXLAN_VNIFILTER_ENTRY_START]);
+		vni_end = vni_start;
+	}
+
+	if (vattrs[VXLAN_VNIFILTER_ENTRY_END])
+		vni_end = nla_get_u32(vattrs[VXLAN_VNIFILTER_ENTRY_END]);
+
+	if (!vni_start && !vni_end) {
+		NL_SET_ERR_MSG_ATTR(extack, nlvnifilter,
+				    "vni start nor end found in vni entry");
+		return -EINVAL;
+	}
+
+	if (vattrs[VXLAN_VNIFILTER_ENTRY_GROUP]) {
+		group.sin.sin_addr.s_addr =
+			nla_get_in_addr(vattrs[VXLAN_VNIFILTER_ENTRY_GROUP]);
+		group.sa.sa_family = AF_INET;
+	} else if (vattrs[VXLAN_VNIFILTER_ENTRY_GROUP6]) {
+		group.sin6.sin6_addr =
+			nla_get_in6_addr(vattrs[VXLAN_VNIFILTER_ENTRY_GROUP6]);
+		group.sa.sa_family = AF_INET6;
+	} else {
+		memset(&group, 0, sizeof(group));
+	}
+
+	if (vxlan_addr_multicast(&group) && !vxlan->default_dst.remote_ifindex) {
+		NL_SET_ERR_MSG(extack,
+			       "Local interface required for multicast remote group");
+
+		return -EINVAL;
+	}
+
+	err = vxlan_vni_add_del(vxlan, vni_start, vni_end, &group, cmd,
+				extack);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void vxlan_vnigroup_uninit(struct vxlan_dev *vxlan)
+{
+	struct vxlan_vni_node *v, *tmp;
+	struct vxlan_vni_group *vg;
+
+	vg = rtnl_dereference(vxlan->vnigrp);
+	list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
+		rhashtable_remove_fast(&vg->vni_hash, &v->vnode,
+				       vxlan_vni_rht_params);
+		hlist_del_init_rcu(&v->hlist4.hlist);
+#if IS_ENABLED(CONFIG_IPV6)
+		hlist_del_init_rcu(&v->hlist6.hlist);
+#endif
+		__vxlan_vni_del_list(vg, v);
+		vxlan_vnifilter_notify(vxlan, v, RTM_DELTUNNEL);
+		call_rcu(&v->rcu, vxlan_vni_node_rcu_free);
+	}
+	rhashtable_destroy(&vg->vni_hash);
+	kfree(vg);
+}
+
+int vxlan_vnigroup_init(struct vxlan_dev *vxlan)
+{
+	struct vxlan_vni_group *vg;
+	int ret;
+
+	vg = kzalloc(sizeof(*vg), GFP_KERNEL);
+	if (!vg)
+		return -ENOMEM;
+	ret = rhashtable_init(&vg->vni_hash, &vxlan_vni_rht_params);
+	if (ret) {
+		kfree(vg);
+		return ret;
+	}
+	INIT_LIST_HEAD(&vg->vni_list);
+	rcu_assign_pointer(vxlan->vnigrp, vg);
+
+	return 0;
+}
+
+static int vxlan_vnifilter_process(struct sk_buff *skb, struct nlmsghdr *nlh,
+				   struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct tunnel_msg *tmsg;
+	struct vxlan_dev *vxlan;
+	struct net_device *dev;
+	struct nlattr *attr;
+	int err, vnis = 0;
+	int rem;
+
+	/* this should validate the header and check for remaining bytes */
+	err = nlmsg_parse(nlh, sizeof(*tmsg), NULL, VXLAN_VNIFILTER_MAX,
+			  vni_filter_policy, extack);
+	if (err < 0)
+		return err;
+
+	tmsg = nlmsg_data(nlh);
+	dev = __dev_get_by_index(net, tmsg->ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	if (!netif_is_vxlan(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "The device is not a vxlan device");
+		return -EINVAL;
+	}
+
+	vxlan = netdev_priv(dev);
+
+	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
+		return -EOPNOTSUPP;
+
+	nlmsg_for_each_attr(attr, nlh, sizeof(*tmsg), rem) {
+		switch (nla_type(attr)) {
+		case VXLAN_VNIFILTER_ENTRY:
+			err = vxlan_process_vni_filter(vxlan, attr,
+						       nlh->nlmsg_type, extack);
+			break;
+		default:
+			continue;
+		}
+		vnis++;
+		if (err)
+			break;
+	}
+
+	if (!vnis) {
+		NL_SET_ERR_MSG_MOD(extack, "No vnis found to process");
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+void vxlan_vnifilter_init(void)
+{
+	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETTUNNEL, NULL,
+			     vxlan_vnifilter_dump, 0);
+	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_NEWTUNNEL,
+			     vxlan_vnifilter_process, NULL, 0);
+	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_DELTUNNEL,
+			     vxlan_vnifilter_process, NULL, 0);
+}
+
+void vxlan_vnifilter_uninit(void)
+{
+	rtnl_unregister(PF_BRIDGE, RTM_GETTUNNEL);
+	rtnl_unregister(PF_BRIDGE, RTM_NEWTUNNEL);
+	rtnl_unregister(PF_BRIDGE, RTM_DELTUNNEL);
+}
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 5a934bebe630..8eb961bb9589 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -232,6 +232,25 @@ struct vxlan_dev_node {
 	struct vxlan_dev *vxlan;
 };
 
+struct vxlan_vni_node {
+	struct rhash_head vnode;
+	struct vxlan_dev_node hlist4; /* vni hash table for IPv4 socket */
+#if IS_ENABLED(CONFIG_IPV6)
+	struct vxlan_dev_node hlist6; /* vni hash table for IPv6 socket */
+#endif
+	struct list_head vlist;
+	__be32 vni;
+	union vxlan_addr remote_ip; /* default remote ip for this vni */
+
+	struct rcu_head rcu;
+};
+
+struct vxlan_vni_group {
+	struct rhashtable	vni_hash;
+	struct list_head	vni_list;
+	u32			num_vnis;
+};
+
 /* Pseudo network device */
 struct vxlan_dev {
 	struct vxlan_dev_node hlist4;	/* vni hash table for IPv4 socket */
@@ -254,6 +273,8 @@ struct vxlan_dev {
 
 	struct vxlan_config	cfg;
 
+	struct vxlan_vni_group  __rcu *vnigrp;
+
 	struct hlist_head fdb_head[FDB_HASH_SIZE];
 };
 
@@ -274,6 +295,7 @@ struct vxlan_dev {
 #define VXLAN_F_GPE			0x4000
 #define VXLAN_F_IPV6_LINKLOCAL		0x8000
 #define VXLAN_F_TTL_INHERIT		0x10000
+#define VXLAN_F_VNIFILTER               0x20000
 
 /* Flags that are used in the receive path. These flags must match in
  * order for a socket to be shareable
@@ -283,7 +305,8 @@ struct vxlan_dev {
 					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
 					 VXLAN_F_REMCSUM_RX |		\
 					 VXLAN_F_REMCSUM_NOPARTIAL |	\
-					 VXLAN_F_COLLECT_METADATA)
+					 VXLAN_F_COLLECT_METADATA |	\
+					 VXLAN_F_VNIFILTER)
 
 /* Flags that can be set together with VXLAN_F_GPE. */
 #define VXLAN_F_ALLOWED_GPE		(VXLAN_F_GPE |			\
@@ -292,7 +315,8 @@ struct vxlan_dev {
 					 VXLAN_F_UDP_ZERO_CSUM_TX |	\
 					 VXLAN_F_UDP_ZERO_CSUM6_TX |	\
 					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
-					 VXLAN_F_COLLECT_METADATA)
+					 VXLAN_F_COLLECT_METADATA  |	\
+					 VXLAN_F_VNIFILTER)
 
 struct net_device *vxlan_dev_create(struct net *net, const char *name,
 				    u8 name_assign_type, struct vxlan_config *conf);
-- 
2.25.1

