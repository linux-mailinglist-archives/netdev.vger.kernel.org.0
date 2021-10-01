Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CAD41F08A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354986AbhJAPIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:51 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:23063 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1354957AbhJAPIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:42 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95671599"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Oct 2021 00:06:57 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 693BA444D9BF;
        Sat,  2 Oct 2021 00:06:54 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
Date:   Fri,  1 Oct 2021 16:06:30 +0100
Message-Id: <20211001150636.7500-5-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/G2L SoC has Gigabit Ethernet IP consisting of Ethernet controller
(E-MAC), Internal TCP/IP Offload Engine (TOE) and Dedicated Direct
memory access controller (DMAC).

This patch adds compatible string for RZ/G2L and fills up the
ravb_hw_info struct. Function stubs are added which will be used by
gbeth_hw_info and will be filled incrementally.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC->v1:
 * Added compatible string for RZ/G2L.
 * Added feature bits max_rx_len, aligned_tx and tx_counters for RZ/G2L.
---
 drivers/net/ethernet/renesas/ravb.h      |  2 +
 drivers/net/ethernet/renesas/ravb_main.c | 62 ++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index c91e93e5590f..f6398fdcead2 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -956,6 +956,8 @@ enum RAVB_QUEUE {
 
 #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
 
+#define GBETH_RX_BUFF_MAX 8192
+
 struct ravb_tstamp_skb {
 	struct list_head list;
 	struct sk_buff *skb;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 8bf13586e90a..dc817b4d95a1 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -83,6 +83,11 @@ static int ravb_config(struct net_device *ndev)
 	return error;
 }
 
+static void ravb_set_rate_gbeth(struct net_device *ndev)
+{
+	/* Place holder */
+}
+
 static void ravb_set_rate(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -217,6 +222,11 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 	return free_num;
 }
 
+static void ravb_rx_ring_free_gbeth(struct net_device *ndev, int q)
+{
+	/* Place holder */
+}
+
 static void ravb_rx_ring_free(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -283,6 +293,11 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 	priv->tx_skb[q] = NULL;
 }
 
+static void ravb_rx_ring_format_gbeth(struct net_device *ndev, int q)
+{
+	/* Place holder */
+}
+
 static void ravb_rx_ring_format(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -356,6 +371,12 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 	desc->dptr = cpu_to_le32((u32)priv->tx_desc_dma[q]);
 }
 
+static void *ravb_alloc_rx_desc_gbeth(struct net_device *ndev, int q)
+{
+	/* Place holder */
+	return NULL;
+}
+
 static void *ravb_alloc_rx_desc(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -426,6 +447,11 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 	return -ENOMEM;
 }
 
+static void ravb_emac_init_gbeth(struct net_device *ndev)
+{
+	/* Place holder */
+}
+
 static void ravb_rcar_emac_init(struct net_device *ndev)
 {
 	/* Receive frame limit set register */
@@ -461,6 +487,12 @@ static void ravb_emac_init(struct net_device *ndev)
 	info->emac_init(ndev);
 }
 
+static int ravb_dmac_init_gbeth(struct net_device *ndev)
+{
+	/* Place holder */
+	return 0;
+}
+
 static int ravb_dmac_init_rcar(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -584,6 +616,14 @@ static void ravb_rx_csum(struct sk_buff *skb)
 	skb_trim(skb, skb->len - sizeof(__sum16));
 }
 
+/* Packet receive function for Gigabit Ethernet */
+static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
+{
+	/* Place holder */
+	return true;
+}
+
+/* Packet receive function for Ethernet AVB */
 static bool ravb_rcar_rx(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -1949,6 +1989,13 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
+static int ravb_set_features_gbeth(struct net_device *ndev,
+				   netdev_features_t features)
+{
+	/* Place holder */
+	return 0;
+}
+
 static int ravb_set_features_rcar(struct net_device *ndev,
 				  netdev_features_t features)
 {
@@ -2073,12 +2120,27 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.nc_queue = 1,
 };
 
+static const struct ravb_hw_info gbeth_hw_info = {
+	.rx_ring_free = ravb_rx_ring_free_gbeth,
+	.rx_ring_format = ravb_rx_ring_format_gbeth,
+	.alloc_rx_desc = ravb_alloc_rx_desc_gbeth,
+	.receive = ravb_rx_gbeth,
+	.set_rate = ravb_set_rate_gbeth,
+	.set_feature = ravb_set_features_gbeth,
+	.dmac_init = ravb_dmac_init_gbeth,
+	.emac_init = ravb_emac_init_gbeth,
+	.max_rx_len = GBETH_RX_BUFF_MAX + RAVB_ALIGN - 1,
+	.aligned_tx = 1,
+	.tx_counters = 1,
+};
+
 static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-r8a7790", .data = &ravb_gen2_hw_info },
 	{ .compatible = "renesas,etheravb-r8a7794", .data = &ravb_gen2_hw_info },
 	{ .compatible = "renesas,etheravb-rcar-gen2", .data = &ravb_gen2_hw_info },
 	{ .compatible = "renesas,etheravb-r8a7795", .data = &ravb_gen3_hw_info },
 	{ .compatible = "renesas,etheravb-rcar-gen3", .data = &ravb_gen3_hw_info },
+	{ .compatible = "renesas,rzg2l-gbeth", .data = &gbeth_hw_info },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ravb_match_table);
-- 
2.17.1

