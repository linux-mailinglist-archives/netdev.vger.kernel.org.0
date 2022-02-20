Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE60A4BCEF1
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243925AbiBTOGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243938AbiBTOGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:06:19 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DB435DC1
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbRldkVmk5jX7XmxozyvAJ+1coc1HZ9tRanpBFxaL9qbdjbC8Q/Qk94DSPn6pRUW1gnb6MG2SKiCVtIiKcxnaMxPR/NcRtSRHUPI8TiI+p4xLKnOkwfPUuS6IfL8MQwqJy+ml2uQt1G2USwedElstjkY8k5wuZsaS5i9X4i9qsmJbDSm2sgJtkKYxQZikbyj9TAjRfgH7HBZzfTnlRLTVAHWOS600uOBVFT6BggjnMdU2nxT2ZgMX6T/QWJ7UCtsDSpU8Fs1fpAg0eAqrSWIPSUzsUslLeXtxxssgDkPsZVdPAREzuc6dctTefb0RskJNWSgv2GRJ/zpNKfX/5m9cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56E+2/LiqExuZG4YUMEIemf+sTcj0jgSN7q0iZTy9pI=;
 b=BZGYgTxqwxDz9H3yGMNk3dWF5TVjyzSHGieoAk4FBeNXS7461QxfV6Vs3rPHzEIJAGhM8513jgsckCxBgO0+id0O8ShUOClxPjzo65M/gScKUQmcHMH7w8TYoQrKupeyFNlJ4lO53mF9TAAjHhBQuCxFhHG/2EUTyUv0CzTtQLlbdb/7szeA7VAE8Y1BDMJWNni0pJhQDQY3KkD/sTqAFiR1RE9bPBR88UANcw6VHFTMf5txK9YaFvdxmokV4iJYNs51bV8CneQobgEbMWgV/owMkubnZsk/zVX+Cq2tsOfSWbki0mscoQ1Yd1ydhxSqNYr8pQSmAMw8F1rM1Pa5RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56E+2/LiqExuZG4YUMEIemf+sTcj0jgSN7q0iZTy9pI=;
 b=S6L3pbGeb8pJNE5NcFwMPqbgGqnqqNSn26oq7Yi/8ED7xwSzjRHPs2k0m4op22xtc51N2gD2giA82fMGAWcmC4NS78lXwwn4XYSggzaHY/LvVgrry2fQKC7fc7Ib817IOcq0Fg+kBHIuhRN8C5eJ1gHM2Chlv3R4zsMsI2h8g92yx/ZEY2p19bk1+TXs3uopj9w1KQr12/nqCIHUI4M+ZaOwLxmOBG2PDJ70+voMTRFG6JQwYaUpw1gxcsa82ocBnSyCJjJuz1hzxvGhLJnkYeuWp4Jc/sVwcTj6NXLP+15P9qyGI0ayC+iDKOSyh238af/GS8bDe9zI6WnP0qPtHw==
Received: from BN9PR03CA0749.namprd03.prod.outlook.com (2603:10b6:408:110::34)
 by DM6PR12MB3228.namprd12.prod.outlook.com (2603:10b6:5:18c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 14:05:49 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::a9) by BN9PR03CA0749.outlook.office365.com
 (2603:10b6:408:110::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:46 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:45 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 11/12] drivers: vxlan: vnifilter: per vni stats
Date:   Sun, 20 Feb 2022 14:04:04 +0000
Message-ID: <20220220140405.1646839-12-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09757155-6bd4-48c8-2c75-08d9f47a18d4
X-MS-TrafficTypeDiagnostic: DM6PR12MB3228:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB322822AE3B028AE8F381DF88CB399@DM6PR12MB3228.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Rij8rUEWYsdRr1qb47wDeGec912ac5xX6PS2ufSXx6Z7KfCJIG84CIN39SU6nfFZDTLITOw2px7bYg8WDY+zfAqiUev+uvleyT1AYCbhZFKTD3WdPtIsNGVzA1LYh41WBd8CM5ErNPHGzOcmV4EpKxT6nu6W8NW9z8rAMPAdmfCI19zDesKyNaqHi7/tTlIyDmO1ejtz8dN+b7dbYotx2bySUcB0Gt/OZwQCxAd/G0DEtFmCFMRtHGLJsfZWPhqSCdq8wDDvVYtkMyQKszj3HkrP8Q4MPjPKpJMt8x9Oh4B+wrBULF3NiBZtxJ0xU92kAkdVA8zJ6FCKbvz8QEk86B5Thfq97VrgCx3xEoazT5mcynWzKGP6go+jCv2xahTZt21owV/7+WV1UmnfVnBl7anr7a8oZBPPclCtB4/pCVkn4l9Jf5ymyyrM/9/PVwRe/1DyUATJzML0vtpqQFVKlT4LrTFcbrGKwIZb2Cg9KpXMqgFNglLLURwmenVqcZjEE5m4/Q6QRQNm4x6azJ5ojtFWu7xskU1G5ZOmM9IreNgv1a0ZIc5dJc3GERGDVxLtrkv1lwpUmlGfyHZ5DFyqPmytnl7XlF5I5l6qTktabVEesFsxGPzRW87RanU6DXvh9Lx5TXWU4MiUbY6Ug/fr2+KyqoXfqmueBJDHqxrNg6/Ax+lrD9V/tfO0c7Pf6cKwH4KKjqIHzn61XD7tzoWFw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70586007)(82310400004)(40460700003)(356005)(81166007)(86362001)(70206006)(8936002)(8676002)(508600001)(4326008)(26005)(36756003)(110136005)(54906003)(6666004)(36860700001)(47076005)(336012)(2616005)(186003)(426003)(5660300002)(1076003)(83380400001)(2906002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:48.7037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09757155-6bd4-48c8-2c75-08d9f47a18d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3228
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index e88217b52bb9..ab2fb2789674 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1745,6 +1745,7 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 	if (!vxlan_ecn_decapsulate(vs, oiph, skb)) {
 		++vxlan->dev->stats.rx_frame_errors;
 		++vxlan->dev->stats.rx_errors;
+		vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_RX_ERRORS, 0);
 		goto drop;
 	}
 
@@ -1753,10 +1754,12 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
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
@@ -1864,8 +1867,12 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
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
@@ -2019,9 +2026,11 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
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
@@ -2355,15 +2364,19 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
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
@@ -2393,6 +2406,8 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 					   vxlan->cfg.flags);
 		if (!dst_vxlan) {
 			dev->stats.tx_errors++;
+			vxlan_vnifilter_count(vxlan, vni,
+					      VXLAN_VNI_STATS_TX_ERRORS, 0);
 			kfree_skb(skb);
 
 			return -ENOENT;
@@ -2416,6 +2431,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	union vxlan_addr remote_ip, local_ip;
 	struct vxlan_metadata _md;
 	struct vxlan_metadata *md = &_md;
+	unsigned int pkt_len = skb->len;
 	__be16 src_port = 0, dst_port;
 	struct dst_entry *ndst = NULL;
 	__be32 vni, label;
@@ -2636,12 +2652,14 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
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
 
@@ -2653,6 +2671,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		dev->stats.tx_carrier_errors++;
 	dst_release(ndst);
 	dev->stats.tx_errors++;
+	vxlan_vnifilter_count(vxlan, vni, VXLAN_VNI_STATS_TX_ERRORS, 0);
 	kfree_skb(skb);
 }
 
@@ -2685,6 +2704,8 @@ static void vxlan_xmit_nh(struct sk_buff *skb, struct net_device *dev,
 
 drop:
 	dev->stats.tx_dropped++;
+	vxlan_vnifilter_count(netdev_priv(dev), vni,
+			      VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
 }
 
@@ -2759,6 +2780,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 				vxlan_fdb_miss(vxlan, eth->h_dest);
 
 			dev->stats.tx_dropped++;
+			vxlan_vnifilter_count(vxlan, vni,
+					      VXLAN_VNI_STATS_TX_DROPS, 0);
 			kfree_skb(skb);
 			return NETDEV_TX_OK;
 		}
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 73fe1c16060e..08d64f7a0f15 100644
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
index 95a76ddfca75..935f3007f348 100644
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
@@ -541,6 +615,11 @@ static struct vxlan_vni_node *vxlan_vni_alloc(struct vxlan_dev *vxlan,
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
 	vninode->hlist6.vxlan = vxlan;
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

