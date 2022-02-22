Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC57A4BEFBB
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbiBVCxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239425AbiBVCxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:41 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1DF25C7E
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:53:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hciKK++LEHzX/4+AOJwamoBo4U2DGZ7HhwPirrxrddpGnY3tdzlh9i2HVuuDQZfFUj9W+ZC8NokqFY1VFY9fHyAvm+oLINKBA38Mi+6tBeSysD454obGfCZgSKEmtw8CUfLH9V5BtlcgXleRHYUSmKyDEHPmglWo9vkWjQWucySFA/LDdwLaDvTJ7nveO9Yx4rjjaJPO70riFB32xJ3Vfix/kzCJsOaKVuYWGO9qfpej5M08gpYXaDEWXsJmFtJoEd8Vku/PorFq77swe13XGXb7G+kLqZwnmSTsZczB9JX9NTP4ZW9Tka6fM5rrghp6wM3/Ox8qsiu5slJx81VsJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voi8YZllVhVQdQMyYfTbzhjQZmLoZ7kgC7smm3dedqI=;
 b=TWTvzs5wsbsZBT73Lt5DHQf26B/mTR/ezIog/5QyfTtIb/+5sP2cgqeQ3r554aSpA17Yg2BtgsQsnan6aeKE4ManEISWqKUqHO67Cgr6jbb0PBxcmEnUKjvUcrP9VlXIU8xJhC2XFIP65h8EhtOaoiwtudR+opX2c9QwDyShKm+ckf+ImWOmWVozoSyfBQyNJVcV4V1dQeZZwmr+wPsf4ExyR/Rqp5/O8h6ugusFk9UIxUcjdp2RUphmeMIF1KHvdbXvBB6X5dJAGwANhCvtPClUjD1bAa8rHQkxUtvFDshr0QBgAuSbdt8ZacVidfQRODr8oe+wpfx4Y+23GVDCiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voi8YZllVhVQdQMyYfTbzhjQZmLoZ7kgC7smm3dedqI=;
 b=WUDo9DCgY0/yYVLOcSUgUxEw+4lN5egTMcLu72OlUcJqN/GDdFhIrqkRFr2NZJdry4nDCE0gczui7CCuZ7Vv3SY2uOHTPNFCtNQdNQN3j0bLHmYji5Wc59mJpQdVbec6diwsTTPb9viJvFyX2elQ8RTZBTHQsn7SfM3ekceIpF9els5i6+8ZytxVfjF/z+Bs1Li6uimkUfcOgGRED4YHAAMRS6VNYes5yebFbTCq4NUQ4W+IsP44LTX52kVUScsa2sfWQ4vI+6uh1xU4gvYiwLS1R7B6tnh4eeDUxCr6wW0HN+ImTKCrZzTVqLU1klzC21da/NkmTEkULzEr50bDsw==
Received: from BN8PR15CA0025.namprd15.prod.outlook.com (2603:10b6:408:c0::38)
 by MN2PR12MB3277.namprd12.prod.outlook.com (2603:10b6:208:103::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 02:53:01 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::d3) by BN8PR15CA0025.outlook.office365.com
 (2603:10b6:408:c0::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27 via Frontend
 Transport; Tue, 22 Feb 2022 02:53:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:53:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:57 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:56 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:56 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 11/12] drivers: vxlan: vnifilter: per vni stats
Date:   Tue, 22 Feb 2022 02:52:29 +0000
Message-ID: <20220222025230.2119189-12-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b48e6467-6255-4200-2946-08d9f5ae7071
X-MS-TrafficTypeDiagnostic: MN2PR12MB3277:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3277E3F7445C0DBD9BD82774CB3B9@MN2PR12MB3277.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xwGfuyGNoiDnHIqMCl4A17SfO6n4tK6VaHKKiAy+lDFE+E6xIdfot7cL9fioX0PEUsUPYIW8iJ9p6+kR2oer6GQgb3nvmMnXdT30dbCcWdNZ91eu2emkAHsqKczBZTXhQdxeQC3LhYEvmsKZTfVpuD27gBJ+ZSmqwGavSFCLBWzHfe2nnQps2hxac3mZW/UQ9aV5/lTnFq4qutN9eXGAM6Qh6ET4gXl0JLMNX/BGUILDE+LKDBDAv6tGN8EmKchcNR/Ia9FSYWoSpJCQGrh0VzFTv+cuc2fduHcQMPTWotolPNCPsZMKKNMCYOzw7GCf7LYnNfgSxzvU8JrlItEfbp75yj+90NpqommHVBl1DLi6NwfxxrwVNsuUdztlp5Pi3tTbjxQRMWSQMrYimmqc5ltlq3TzuRHT5n19WCtz0qFMwEdEzB6XG4Lxl952J0dK+P+EqQDpL3P+rqf2HWq5R057RCtDz7DplJuSIyRz5Nfr47wAIVCKw61bGrO3i/BKklJeeul8ko2V+yCoX62wr/sM+VWkcLwRQFA7dlyZu4HsNGQs0zdtfHicVYRWIbND/LbzpmSMy0JJIAQCtyfXRwdGAdMsYuP7mfwmB+HOBH28lhAwfV8rtRInH/qjUbI1hyImkS7bFMhlFODUqsyAPUBwafRPP+SotM9+vDwAb9tSw9i0P2hJbkhrudDCo/Zat96IuUOOH0sX/HhW7Qmtw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(426003)(47076005)(336012)(83380400001)(36756003)(40460700003)(5660300002)(2906002)(8936002)(26005)(2616005)(1076003)(107886003)(186003)(36860700001)(70206006)(70586007)(81166007)(356005)(54906003)(110136005)(508600001)(316002)(6666004)(86362001)(8676002)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:53:00.7496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b48e6467-6255-4200-2946-08d9f5ae7071
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3277
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c      | 29 +++++++++--
 drivers/net/vxlan/vxlan_private.h   |  3 +-
 drivers/net/vxlan/vxlan_vnifilter.c | 80 +++++++++++++++++++++++++++++
 include/net/vxlan.h                 | 26 ++++++++++
 4 files changed, 134 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index a3c20ad18243..e0221fb8f2e5 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1746,6 +1746,7 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 	if (!vxlan_ecn_decapsulate(vs, oiph, skb)) {
 		++vxlan->dev->stats.rx_frame_errors;
 		++vxlan->dev->stats.rx_errors;
+		vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_RX_ERRORS, 0);
 		goto drop;
 	}
 
@@ -1754,10 +1755,12 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(!(vxlan->dev->flags & IFF_UP))) {
 		rcu_read_unlock();
 		atomic_long_inc(&vxlan->dev->rx_dropped);
+		vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_RX_DROPS, 0);
 		goto drop;
 	}
 
 	dev_sw_netstats_rx_add(vxlan->dev, skb->len);
+	vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_RX, skb->len);
 	gro_cells_receive(&vxlan->gro_cells, skb);
 
 	rcu_read_unlock();
@@ -1865,8 +1868,12 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		reply->ip_summed = CHECKSUM_UNNECESSARY;
 		reply->pkt_type = PACKET_HOST;
 
-		if (netif_rx_ni(reply) == NET_RX_DROP)
+		if (netif_rx_ni(reply) == NET_RX_DROP) {
 			dev->stats.rx_dropped++;
+			vxlan_vnifilter_count(vxlan, vni,
+					      VXLAN_VNI_STATS_RX_DROPS, 0);
+		}
+
 	} else if (vxlan->cfg.flags & VXLAN_F_L3MISS) {
 		union vxlan_addr ipa = {
 			.sin.sin_addr.s_addr = tip,
@@ -2020,9 +2027,11 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		if (reply == NULL)
 			goto out;
 
-		if (netif_rx_ni(reply) == NET_RX_DROP)
+		if (netif_rx_ni(reply) == NET_RX_DROP) {
 			dev->stats.rx_dropped++;
-
+			vxlan_vnifilter_count(vxlan, vni,
+					      VXLAN_VNI_STATS_RX_DROPS, 0);
+		}
 	} else if (vxlan->cfg.flags & VXLAN_F_L3MISS) {
 		union vxlan_addr ipa = {
 			.sin6.sin6_addr = msg->target,
@@ -2356,15 +2365,19 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 	tx_stats->tx_packets++;
 	tx_stats->tx_bytes += len;
 	u64_stats_update_end(&tx_stats->syncp);
+	vxlan_vnifilter_count(src_vxlan, vni, VXLAN_VNI_STATS_TX, len);
 
 	if (__netif_rx(skb) == NET_RX_SUCCESS) {
 		u64_stats_update_begin(&rx_stats->syncp);
 		rx_stats->rx_packets++;
 		rx_stats->rx_bytes += len;
 		u64_stats_update_end(&rx_stats->syncp);
+		vxlan_vnifilter_count(dst_vxlan, vni, VXLAN_VNI_STATS_RX, len);
 	} else {
 drop:
 		dev->stats.rx_dropped++;
+		vxlan_vnifilter_count(dst_vxlan, vni, VXLAN_VNI_STATS_RX_DROPS,
+				      0);
 	}
 	rcu_read_unlock();
 }
@@ -2394,6 +2407,8 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 					   vxlan->cfg.flags);
 		if (!dst_vxlan) {
 			dev->stats.tx_errors++;
+			vxlan_vnifilter_count(vxlan, vni,
+					      VXLAN_VNI_STATS_TX_ERRORS, 0);
 			kfree_skb(skb);
 
 			return -ENOENT;
@@ -2417,6 +2432,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	union vxlan_addr remote_ip, local_ip;
 	struct vxlan_metadata _md;
 	struct vxlan_metadata *md = &_md;
+	unsigned int pkt_len = skb->len;
 	__be16 src_port = 0, dst_port;
 	struct dst_entry *ndst = NULL;
 	__u8 tos, ttl;
@@ -2644,12 +2660,14 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 				     label, src_port, dst_port, !udp_sum);
 #endif
 	}
+	vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_TX, pkt_len);
 out_unlock:
 	rcu_read_unlock();
 	return;
 
 drop:
 	dev->stats.tx_dropped++;
+	vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
 	return;
 
@@ -2661,6 +2679,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		dev->stats.tx_carrier_errors++;
 	dst_release(ndst);
 	dev->stats.tx_errors++;
+	vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_TX_ERRORS, 0);
 	kfree_skb(skb);
 }
 
@@ -2693,6 +2712,8 @@ static void vxlan_xmit_nh(struct sk_buff *skb, struct net_device *dev,
 
 drop:
 	dev->stats.tx_dropped++;
+	vxlan_vnifilter_count(netdev_priv(dev), vni,
+			      VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
 }
 
@@ -2767,6 +2788,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 				vxlan_fdb_miss(vxlan, eth->h_dest);
 
 			dev->stats.tx_dropped++;
+			vxlan_vnifilter_count(vxlan, vni,
+					      VXLAN_VNI_STATS_TX_DROPS, 0);
 			kfree_skb(skb);
 			return NETDEV_TX_OK;
 		}
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index d697d6c51cb5..1a8ffddab947 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -154,6 +154,8 @@ void vxlan_vnigroup_uninit(struct vxlan_dev *vxlan);
 
 void vxlan_vnifilter_init(void);
 void vxlan_vnifilter_uninit(void);
+void vxlan_vnifilter_count(struct vxlan_dev *vxlan, __be32 vni,
+			   int type, unsigned int len);
 
 void vxlan_vs_add_vnigrp(struct vxlan_dev *vxlan,
 			 struct vxlan_sock *vs,
@@ -164,7 +166,6 @@ int vxlan_vnilist_update_group(struct vxlan_dev *vxlan,
 			       union vxlan_addr *new_remote_ip,
 			       struct netlink_ext_ack *extack);
 
-
 /* vxlan_multicast.c */
 int vxlan_multicast_join(struct vxlan_dev *vxlan);
 int vxlan_multicast_leave(struct vxlan_dev *vxlan);
diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 9647184a1d5a..30534391948b 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -97,6 +97,80 @@ void vxlan_vs_del_vnigrp(struct vxlan_dev *vxlan)
 	spin_unlock(&vn->sock_lock);
 }
 
+static void vxlan_vnifilter_stats_get(const struct vxlan_vni_node *vninode,
+				      struct vxlan_vni_stats *dest)
+{
+	int i;
+
+	memset(dest, 0, sizeof(*dest));
+	for_each_possible_cpu(i) {
+		struct vxlan_vni_stats_pcpu *pstats;
+		struct vxlan_vni_stats temp;
+		unsigned int start;
+
+		pstats = per_cpu_ptr(vninode->stats, i);
+		do {
+			start = u64_stats_fetch_begin_irq(&pstats->syncp);
+			memcpy(&temp, &pstats->stats, sizeof(temp));
+		} while (u64_stats_fetch_retry_irq(&pstats->syncp, start));
+
+		dest->rx_packets += temp.rx_packets;
+		dest->rx_bytes += temp.rx_bytes;
+		dest->rx_drops += temp.rx_drops;
+		dest->rx_errors += temp.rx_errors;
+		dest->tx_packets += temp.tx_packets;
+		dest->tx_bytes += temp.tx_bytes;
+		dest->tx_drops += temp.tx_drops;
+		dest->tx_errors += temp.tx_errors;
+	}
+}
+
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
+			   int type, unsigned int len)
+{
+	struct vxlan_vni_node *vninode;
+
+	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
+		return;
+
+	vninode = vxlan_vnifilter_lookup(vxlan, vni);
+	if (!vninode)
+		return;
+
+	vxlan_vnifilter_stats_add(vninode, type, len);
+}
+
 static u32 vnirange(struct vxlan_vni_node *vbegin,
 		    struct vxlan_vni_node *vend)
 {
@@ -539,6 +613,11 @@ static struct vxlan_vni_node *vxlan_vni_alloc(struct vxlan_dev *vxlan,
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
@@ -596,6 +675,7 @@ static void vxlan_vni_node_rcu_free(struct rcu_head *rcu)
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

