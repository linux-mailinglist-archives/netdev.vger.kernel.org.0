Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088564C82CA
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiCAFG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiCAFGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:16 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D337307C
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHoPlMzZNY3w0OWEkJxyWAJcndAcRQPPNK1eBCJ+vQoabmKPIQuaEwiAHby+yyRCNt+Pwu61eWo/0bBfLzWTiwMtnIZ6DFh6sPmX67juRPaduUotrG5VXmlfZLaekTXoe08ibS+EflInk0XRu/0HRlFKaMQ9PxDLWI8pqqey0r3xe7d6Nezvw8dZ9+o7iLyJ5Yfp+pVCey06YBKlSuKyoNCJ/US5HUnihBY+hqN86rHgT5xE1rFh4BxwFKTEv+koQFOAwJeG0dPUkQarKUuLIYbW1aLX8/kiN03K740iTu5g9wcvn70kpRmu8I7GScAMS7Vi3X84l+4Jq6TxHBYhag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+iOZYSdG5+mNS6vL2P1/3oZE/e8c09VL6jfhWwbZgXM=;
 b=TU3vZLTb6+p4YlvFeF6vhawIYrvVIS1xIWJrsf8NqeSfS0dR1Q/mrAUl8i+H6tXUfQg1OoUfEm2FEhcCg+L8JfFBIWDYx8okmkE1ZsGjkTdrbd6dPTR0z5fpkc8Is/AceYih14fn9czgbOeyUAu7fjJ3EWDDe0glbRNVvUCsevapoLe0mrMezrXbCXq3d4FNDtHytxiu0XstV94OQTenk9syyrIAGw8DBCYQ8FhkFpaLYqu0Yj8WCfQTHX+OJv2rQENDIgUnshtxAcQIBpQSR3loLW45ACUkXCExUgYHsKWf0unLrse99Mwx9dqOV//vSi+HQIXywtmeSRoG+Bjzvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iOZYSdG5+mNS6vL2P1/3oZE/e8c09VL6jfhWwbZgXM=;
 b=TOFucRdC0I6Oj7cuJjwS7QwjMxiZfSej4pvdAXxnila1+P+1IIWguNLMeK9atIntKcWP8z0w7lZvLpePuOhiF8ISnFvhjJ27rJdfrJlobBb/K8tJWzY7ErK/1LLn+Qzitrr5W/3E94DweiU8700zypqhfuci8wb+96Lu+2X+aONt7jQDMC5dnaWIuWZbPkkZE1BLYxoO+yp+g4ppjYxaxswksvar32/FBthkoOqMFsU4WK3Up3hcYvFrplKjHq66sF6NU0S79DBzhJlkc1GXjR/Pb4JZbmKQxH/DmrtktpVrI9nblAeUwPBysnGkLxOBfcaqhAMhS4csEroO13LsUg==
Received: from DM5PR07CA0085.namprd07.prod.outlook.com (2603:10b6:4:ae::14) by
 LV2PR12MB5773.namprd12.prod.outlook.com (2603:10b6:408:17b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Tue, 1 Mar
 2022 05:04:51 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::da) by DM5PR07CA0085.outlook.office365.com
 (2603:10b6:4:ae::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:48 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:48 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 11/12] drivers: vxlan: vnifilter: per vni stats
Date:   Tue, 1 Mar 2022 05:04:38 +0000
Message-ID: <20220301050439.31785-12-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 813026dc-d78e-4e8f-d484-08d9fb410407
X-MS-TrafficTypeDiagnostic: LV2PR12MB5773:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5773F2558318902F24E017B4CB029@LV2PR12MB5773.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXsae0hGs2prrTcFbJb1+fH05MalNmiqZ2nu98nZayCzpaesPQ7HviOgbZYd5zxfr1ogHWUhSBXCb0B6oDceKKBdgAUREaPJQ02hJWGGB7Nd0iDBjQE4er+fi24+8g+duaef0DsH/zf96b3S+wTCDe2/w08+5rYnqSxK+aBJ8fwo6gQpGB/h4du/gepuyY6snTG0oETiXJojENogwJM0kIo0Cv8YJPb+g/bdDaBiESHMJrQ9Ts5oqwnAozgKshmp3WohlCpsWS2uGVfvsWU5aRgoDX1ZkeF2w+Zx2VwUJwAnePY+Ml3FUtmJmS5qUGvLsTyLoyxzblAXSAZ++2HYijXBa7gRA311Y79SHfz0qeXDpPjMY6/JZfyRXu97xyP36kiIDibio9KnJtY6yJ20zxl6zg+vi+dpYIXlgi59v05RcvDDWOEnlOnrQp7+Y/abs5M55yN7NFGSmQZ/5/KrVSX8JkuizbK7l1PK8A9IsuE/j2yLiJ4DmZM5Ds8UF3d1U00plvGiIpD8VmlxHvyu+WxBMUbW0Z23hTNI259kCRBxjMGxdscK6cU+CoDbi7u1HjgbHzEpls4ZV3mTK4Tu2insn/PrIFCM8kv3j+EjewQjHxUziD56gql52lQuu/4K1JMcYtjO2KsZMd1Q7NPA57F1VhvQ38Kq2d8irpj1GSx7ZmkyQUrqMDxr1XuK1zcFtKEzgsojxfzNh9Yslxgh6Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(508600001)(6666004)(30864003)(36756003)(8936002)(47076005)(40460700003)(70586007)(70206006)(8676002)(186003)(4326008)(2616005)(336012)(426003)(26005)(86362001)(81166007)(356005)(5660300002)(82310400004)(83380400001)(107886003)(54906003)(2906002)(110136005)(316002)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:50.7297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 813026dc-d78e-4e8f-d484-08d9fb410407
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5773
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add per-vni statistics for vni filter mode. Counting Rx/Tx
bytes/packets/drops/errors at the appropriate places.

This patch changes vxlan_vs_find_vni to also return the
vxlan_vni_node in cases where the vni belongs to a vni
filtering vxlan device

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c      | 51 +++++++++++++++++++++-----
 drivers/net/vxlan/vxlan_private.h   |  3 ++
 drivers/net/vxlan/vxlan_vnifilter.c | 57 +++++++++++++++++++++++++++++
 include/net/vxlan.h                 | 26 +++++++++++++
 4 files changed, 128 insertions(+), 9 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index a3c20ad18243..4ab09dd5a32a 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -139,9 +139,11 @@ static struct vxlan_sock *vxlan_find_sock(struct net *net, sa_family_t family,
 	return NULL;
 }
 
-static struct vxlan_dev *vxlan_vs_find_vni(struct vxlan_sock *vs, int ifindex,
-					   __be32 vni)
+static struct vxlan_dev *vxlan_vs_find_vni(struct vxlan_sock *vs,
+					   int ifindex, __be32 vni,
+					   struct vxlan_vni_node **vninode)
 {
+	struct vxlan_vni_node *vnode;
 	struct vxlan_dev_node *node;
 
 	/* For flow based devices, map all packets to VNI 0 */
@@ -152,8 +154,10 @@ static struct vxlan_dev *vxlan_vs_find_vni(struct vxlan_sock *vs, int ifindex,
 	hlist_for_each_entry_rcu(node, vni_head(vs, vni), hlist) {
 		if (!node->vxlan)
 			continue;
+		vnode = NULL;
 		if (node->vxlan->cfg.flags & VXLAN_F_VNIFILTER) {
-			if (!vxlan_vnifilter_lookup(node->vxlan, vni))
+			vnode = vxlan_vnifilter_lookup(node->vxlan, vni);
+			if (!vnode)
 				continue;
 		} else if (node->vxlan->default_dst.remote_vni != vni) {
 			continue;
@@ -167,6 +171,8 @@ static struct vxlan_dev *vxlan_vs_find_vni(struct vxlan_sock *vs, int ifindex,
 				continue;
 		}
 
+		if (vninode)
+			*vninode = vnode;
 		return node->vxlan;
 	}
 
@@ -184,7 +190,7 @@ static struct vxlan_dev *vxlan_find_vni(struct net *net, int ifindex,
 	if (!vs)
 		return NULL;
 
-	return vxlan_vs_find_vni(vs, ifindex, vni);
+	return vxlan_vs_find_vni(vs, ifindex, vni, NULL);
 }
 
 /* Fill in neighbour message in skbuff. */
@@ -1644,6 +1650,7 @@ static bool vxlan_ecn_decapsulate(struct vxlan_sock *vs, void *oiph,
 /* Callback from net/ipv4/udp.c to receive packets */
 static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 {
+	struct vxlan_vni_node *vninode = NULL;
 	struct vxlan_dev *vxlan;
 	struct vxlan_sock *vs;
 	struct vxlanhdr unparsed;
@@ -1676,7 +1683,7 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 
 	vni = vxlan_vni(vxlan_hdr(skb)->vx_vni);
 
-	vxlan = vxlan_vs_find_vni(vs, skb->dev->ifindex, vni);
+	vxlan = vxlan_vs_find_vni(vs, skb->dev->ifindex, vni, &vninode);
 	if (!vxlan)
 		goto drop;
 
@@ -1746,6 +1753,8 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 	if (!vxlan_ecn_decapsulate(vs, oiph, skb)) {
 		++vxlan->dev->stats.rx_frame_errors;
 		++vxlan->dev->stats.rx_errors;
+		vxlan_vnifilter_count(vxlan, vni, vninode,
+				      VXLAN_VNI_STATS_RX_ERRORS, 0);
 		goto drop;
 	}
 
@@ -1754,10 +1763,13 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(!(vxlan->dev->flags & IFF_UP))) {
 		rcu_read_unlock();
 		atomic_long_inc(&vxlan->dev->rx_dropped);
+		vxlan_vnifilter_count(vxlan, vni, vninode,
+				      VXLAN_VNI_STATS_RX_DROPS, 0);
 		goto drop;
 	}
 
 	dev_sw_netstats_rx_add(vxlan->dev, skb->len);
+	vxlan_vnifilter_count(vxlan, vni, vninode, VXLAN_VNI_STATS_RX, skb->len);
 	gro_cells_receive(&vxlan->gro_cells, skb);
 
 	rcu_read_unlock();
@@ -1791,7 +1803,7 @@ static int vxlan_err_lookup(struct sock *sk, struct sk_buff *skb)
 		return -ENOENT;
 
 	vni = vxlan_vni(hdr->vx_vni);
-	vxlan = vxlan_vs_find_vni(vs, skb->dev->ifindex, vni);
+	vxlan = vxlan_vs_find_vni(vs, skb->dev->ifindex, vni, NULL);
 	if (!vxlan)
 		return -ENOENT;
 
@@ -1865,8 +1877,12 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		reply->ip_summed = CHECKSUM_UNNECESSARY;
 		reply->pkt_type = PACKET_HOST;
 
-		if (netif_rx_ni(reply) == NET_RX_DROP)
+		if (netif_rx_ni(reply) == NET_RX_DROP) {
 			dev->stats.rx_dropped++;
+			vxlan_vnifilter_count(vxlan, vni, NULL,
+					      VXLAN_VNI_STATS_RX_DROPS, 0);
+		}
+
 	} else if (vxlan->cfg.flags & VXLAN_F_L3MISS) {
 		union vxlan_addr ipa = {
 			.sin.sin_addr.s_addr = tip,
@@ -2020,9 +2036,11 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		if (reply == NULL)
 			goto out;
 
-		if (netif_rx_ni(reply) == NET_RX_DROP)
+		if (netif_rx_ni(reply) == NET_RX_DROP) {
 			dev->stats.rx_dropped++;
-
+			vxlan_vnifilter_count(vxlan, vni, NULL,
+					      VXLAN_VNI_STATS_RX_DROPS, 0);
+		}
 	} else if (vxlan->cfg.flags & VXLAN_F_L3MISS) {
 		union vxlan_addr ipa = {
 			.sin6.sin6_addr = msg->target,
@@ -2356,15 +2374,20 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 	tx_stats->tx_packets++;
 	tx_stats->tx_bytes += len;
 	u64_stats_update_end(&tx_stats->syncp);
+	vxlan_vnifilter_count(src_vxlan, vni, NULL, VXLAN_VNI_STATS_TX, len);
 
 	if (__netif_rx(skb) == NET_RX_SUCCESS) {
 		u64_stats_update_begin(&rx_stats->syncp);
 		rx_stats->rx_packets++;
 		rx_stats->rx_bytes += len;
 		u64_stats_update_end(&rx_stats->syncp);
+		vxlan_vnifilter_count(dst_vxlan, vni, NULL, VXLAN_VNI_STATS_RX,
+				      len);
 	} else {
 drop:
 		dev->stats.rx_dropped++;
+		vxlan_vnifilter_count(dst_vxlan, vni, NULL,
+				      VXLAN_VNI_STATS_RX_DROPS, 0);
 	}
 	rcu_read_unlock();
 }
@@ -2394,6 +2417,8 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 					   vxlan->cfg.flags);
 		if (!dst_vxlan) {
 			dev->stats.tx_errors++;
+			vxlan_vnifilter_count(vxlan, vni, NULL,
+					      VXLAN_VNI_STATS_TX_ERRORS, 0);
 			kfree_skb(skb);
 
 			return -ENOENT;
@@ -2417,6 +2442,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	union vxlan_addr remote_ip, local_ip;
 	struct vxlan_metadata _md;
 	struct vxlan_metadata *md = &_md;
+	unsigned int pkt_len = skb->len;
 	__be16 src_port = 0, dst_port;
 	struct dst_entry *ndst = NULL;
 	__u8 tos, ttl;
@@ -2644,12 +2670,14 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 				     label, src_port, dst_port, !udp_sum);
 #endif
 	}
+	vxlan_vnifilter_count(vxlan, vni, NULL, VXLAN_VNI_STATS_TX, pkt_len);
 out_unlock:
 	rcu_read_unlock();
 	return;
 
 drop:
 	dev->stats.tx_dropped++;
+	vxlan_vnifilter_count(vxlan, vni, NULL, VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
 	return;
 
@@ -2661,6 +2689,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		dev->stats.tx_carrier_errors++;
 	dst_release(ndst);
 	dev->stats.tx_errors++;
+	vxlan_vnifilter_count(vxlan, vni, NULL, VXLAN_VNI_STATS_TX_ERRORS, 0);
 	kfree_skb(skb);
 }
 
@@ -2693,6 +2722,8 @@ static void vxlan_xmit_nh(struct sk_buff *skb, struct net_device *dev,
 
 drop:
 	dev->stats.tx_dropped++;
+	vxlan_vnifilter_count(netdev_priv(dev), vni, NULL,
+			      VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
 }
 
@@ -2767,6 +2798,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 				vxlan_fdb_miss(vxlan, eth->h_dest);
 
 			dev->stats.tx_dropped++;
+			vxlan_vnifilter_count(vxlan, vni, NULL,
+					      VXLAN_VNI_STATS_TX_DROPS, 0);
 			kfree_skb(skb);
 			return NETDEV_TX_OK;
 		}
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 472d2f0b5b90..599c3b4fdd5e 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -136,6 +136,9 @@ void vxlan_vnigroup_uninit(struct vxlan_dev *vxlan);
 
 void vxlan_vnifilter_init(void);
 void vxlan_vnifilter_uninit(void);
+void vxlan_vnifilter_count(struct vxlan_dev *vxlan, __be32 vni,
+			   struct vxlan_vni_node *vninode,
+			   int type, unsigned int len);
 
 void vxlan_vs_add_vnigrp(struct vxlan_dev *vxlan,
 			 struct vxlan_sock *vs,
diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 43a2d612e73a..2d23312f4f62 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -116,6 +116,57 @@ void vxlan_vs_del_vnigrp(struct vxlan_dev *vxlan)
 	spin_unlock(&vn->sock_lock);
 }
 
+static void vxlan_vnifilter_stats_add(struct vxlan_vni_node *vninode,
+				      int type, unsigned int len)
+{
+	struct vxlan_vni_stats_pcpu *pstats = this_cpu_ptr(vninode->stats);
+
+	u64_stats_update_begin(&pstats->syncp);
+	switch (type) {
+	case VXLAN_VNI_STATS_RX:
+		pstats->stats.rx_bytes += len;
+		pstats->stats.rx_packets++;
+		break;
+	case VXLAN_VNI_STATS_RX_DROPS:
+		pstats->stats.rx_drops++;
+		break;
+	case VXLAN_VNI_STATS_RX_ERRORS:
+		pstats->stats.rx_errors++;
+		break;
+	case VXLAN_VNI_STATS_TX:
+		pstats->stats.tx_bytes += len;
+		pstats->stats.tx_packets++;
+		break;
+	case VXLAN_VNI_STATS_TX_DROPS:
+		pstats->stats.tx_drops++;
+		break;
+	case VXLAN_VNI_STATS_TX_ERRORS:
+		pstats->stats.tx_errors++;
+		break;
+	}
+	u64_stats_update_end(&pstats->syncp);
+}
+
+void vxlan_vnifilter_count(struct vxlan_dev *vxlan, __be32 vni,
+			   struct vxlan_vni_node *vninode,
+			   int type, unsigned int len)
+{
+	struct vxlan_vni_node *vnode;
+
+	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
+		return;
+
+	if (vninode) {
+		vnode = vninode;
+	} else {
+		vnode = vxlan_vnifilter_lookup(vxlan, vni);
+		if (!vnode)
+			return;
+	}
+
+	vxlan_vnifilter_stats_add(vnode, type, len);
+}
+
 static u32 vnirange(struct vxlan_vni_node *vbegin,
 		    struct vxlan_vni_node *vend)
 {
@@ -562,6 +613,11 @@ static struct vxlan_vni_node *vxlan_vni_alloc(struct vxlan_dev *vxlan,
 	vninode = kzalloc(sizeof(*vninode), GFP_ATOMIC);
 	if (!vninode)
 		return NULL;
+	vninode->stats = netdev_alloc_pcpu_stats(struct vxlan_vni_stats_pcpu);
+	if (!vninode->stats) {
+		kfree(vninode);
+		return NULL;
+	}
 	vninode->vni = vni;
 	vninode->hlist4.vxlan = vxlan;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -621,6 +677,7 @@ static void vxlan_vni_node_rcu_free(struct rcu_head *rcu)
 	struct vxlan_vni_node *v;
 
 	v = container_of(rcu, struct vxlan_vni_node, rcu);
+	free_percpu(v->stats);
 	kfree(v);
 }
 
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 8eb961bb9589..bca5b01af247 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -227,6 +227,31 @@ struct vxlan_config {
 	enum ifla_vxlan_df	df;
 };
 
+enum {
+	VXLAN_VNI_STATS_RX,
+	VXLAN_VNI_STATS_RX_DROPS,
+	VXLAN_VNI_STATS_RX_ERRORS,
+	VXLAN_VNI_STATS_TX,
+	VXLAN_VNI_STATS_TX_DROPS,
+	VXLAN_VNI_STATS_TX_ERRORS,
+};
+
+struct vxlan_vni_stats {
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 rx_drops;
+	u64 rx_errors;
+	u64 tx_packets;
+	u64 tx_bytes;
+	u64 tx_drops;
+	u64 tx_errors;
+};
+
+struct vxlan_vni_stats_pcpu {
+	struct vxlan_vni_stats stats;
+	struct u64_stats_sync syncp;
+};
+
 struct vxlan_dev_node {
 	struct hlist_node hlist;
 	struct vxlan_dev *vxlan;
@@ -241,6 +266,7 @@ struct vxlan_vni_node {
 	struct list_head vlist;
 	__be32 vni;
 	union vxlan_addr remote_ip; /* default remote ip for this vni */
+	struct vxlan_vni_stats_pcpu __percpu *stats;
 
 	struct rcu_head rcu;
 };
-- 
2.25.1

