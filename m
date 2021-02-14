Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1752231B093
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 14:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhBNNki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 08:40:38 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55008 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229773AbhBNNka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 08:40:30 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11EDYeL6024343;
        Sun, 14 Feb 2021 05:39:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=wmIAkCfWU5I1w99boTR4oYhebhTF043MysGSEEFkp/w=;
 b=Uye4sECO6hQijO1fUsDoVNL1DEgO1eBvXsgVLzh7ws4YwZKwuDVctDVoyrGgG4RuUqKp
 u0hiyqiOYdCZ2CGxF1/ufrWztpHlxAfw72IQJpfBK1rnu8e5EGk2avtKadbumQRo8ARI
 8jycFxLR74TD0Y496UfSwLYS9VXP6dMbc2a/g9r4oMzoyDeyUTSl5gW7N3fRKvQD4x+3
 McMAbnawABY6xVkzffyxdtK7bVmoZ6Zcv3RrVvHQwXi8FXEJ/qyeIRbCaYpml0wA0BBd
 bZvpIbVxHtqugHOXjN99NArJ7GcwETlGWXSFETpewbjbN2H7GiRrdAcYUKv89iro7RFr aw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vhyxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 14 Feb 2021 05:39:42 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 05:39:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 14 Feb 2021 05:39:41 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 562053F703F;
        Sun, 14 Feb 2021 05:39:38 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [net-next 2/4] net: mvpp2: improve Packet Processor version check
Date:   Sun, 14 Feb 2021 15:38:35 +0200
Message-ID: <1613309917-17569-3-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1613309917-17569-1-git-send-email-stefanc@marvell.com>
References: <1613309917-17569-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-14_03:2021-02-12,2021-02-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Use >= MVPP22 instead of != MVPP21.
Non functional change.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 36 ++++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9127dc2..4e1a24c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -329,7 +329,7 @@ static int mvpp2_get_nrxqs(struct mvpp2 *priv)
 {
 	unsigned int nrxqs;
 
-	if (priv->hw_version != MVPP21 && queue_mode == MVPP2_QDIST_SINGLE_MODE)
+	if (priv->hw_version >= MVPP22 && queue_mode == MVPP2_QDIST_SINGLE_MODE)
 		return 1;
 
 	/* According to the PPv2.2 datasheet and our experiments on
@@ -469,7 +469,7 @@ static void mvpp2_bm_bufs_get_addrs(struct device *dev, struct mvpp2 *priv,
 				      MVPP2_BM_PHY_ALLOC_REG(bm_pool->id));
 	*phys_addr = mvpp2_thread_read(priv, thread, MVPP2_BM_VIRT_ALLOC_REG);
 
-	if (priv->hw_version != MVPP21) {
+	if (priv->hw_version >= MVPP22) {
 		u32 val;
 		u32 dma_addr_highbits, phys_addr_highbits;
 
@@ -963,7 +963,7 @@ static inline void mvpp2_bm_pool_put(struct mvpp2_port *port, int pool,
 	if (test_bit(thread, &port->priv->lock_map))
 		spin_lock_irqsave(&port->bm_lock[thread], flags);
 
-	if (port->priv->hw_version != MVPP21) {
+	if (port->priv->hw_version >= MVPP22) {
 		u32 val = 0;
 
 		if (sizeof(dma_addr_t) == 8)
@@ -1462,7 +1462,7 @@ static bool mvpp2_port_supports_xlg(struct mvpp2_port *port)
 
 static bool mvpp2_port_supports_rgmii(struct mvpp2_port *port)
 {
-	return !(port->priv->hw_version != MVPP21 && port->gop_id == 0);
+	return !(port->priv->hw_version >= MVPP22 && port->gop_id == 0);
 }
 
 /* Port configuration routines */
@@ -2125,7 +2125,7 @@ static void mvpp2_mac_reset_assert(struct mvpp2_port *port)
 	      MVPP2_GMAC_PORT_RESET_MASK;
 	writel(val, port->base + MVPP2_GMAC_CTRL_2_REG);
 
-	if (port->priv->hw_version != MVPP21 && port->gop_id == 0) {
+	if (port->priv->hw_version >= MVPP22 && port->gop_id == 0) {
 		val = readl(port->base + MVPP22_XLG_CTRL0_REG) &
 		      ~MVPP22_XLG_CTRL0_MAC_RESET_DIS;
 		writel(val, port->base + MVPP22_XLG_CTRL0_REG);
@@ -4016,7 +4016,7 @@ static void mvpp2_txdesc_clear_ptp(struct mvpp2_port *port,
 				   struct mvpp2_tx_desc *desc)
 {
 	/* We only need to clear the low bits */
-	if (port->priv->hw_version != MVPP21)
+	if (port->priv->hw_version >= MVPP22)
 		desc->pp22.ptp_descriptor &=
 			cpu_to_le32(~MVPP22_PTP_DESC_MASK_LOW);
 }
@@ -4528,7 +4528,7 @@ static void mvpp2_start_dev(struct mvpp2_port *port)
 	/* Enable interrupts on all threads */
 	mvpp2_interrupts_enable(port);
 
-	if (port->priv->hw_version != MVPP21)
+	if (port->priv->hw_version >= MVPP22)
 		mvpp22_mode_reconfigure(port);
 
 	if (port->phylink) {
@@ -4746,7 +4746,7 @@ static int mvpp2_open(struct net_device *dev)
 		valid = true;
 	}
 
-	if (priv->hw_version != MVPP21 && port->port_irq) {
+	if (priv->hw_version >= MVPP22 && port->port_irq) {
 		err = request_irq(port->port_irq, mvpp2_port_isr, 0,
 				  dev->name, port);
 		if (err) {
@@ -6399,7 +6399,7 @@ static int mvpp2__mac_prepare(struct phylink_config *config, unsigned int mode,
 			     MVPP2_GMAC_PORT_RESET_MASK,
 			     MVPP2_GMAC_PORT_RESET_MASK);
 
-		if (port->priv->hw_version != MVPP21) {
+		if (port->priv->hw_version >= MVPP22) {
 			mvpp22_gop_mask_irq(port);
 
 			phy_power_off(port->comphy);
@@ -6453,7 +6453,7 @@ static int mvpp2_mac_finish(struct phylink_config *config, unsigned int mode,
 {
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 
-	if (port->priv->hw_version != MVPP21 &&
+	if (port->priv->hw_version >= MVPP22 &&
 	    port->phy_interface != interface) {
 		port->phy_interface = interface;
 
@@ -7200,7 +7200,7 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	if (dram_target_info)
 		mvpp2_conf_mbus_windows(dram_target_info, priv);
 
-	if (priv->hw_version != MVPP21)
+	if (priv->hw_version >= MVPP22)
 		mvpp2_axi_init(priv);
 
 	/* Disable HW PHY polling */
@@ -7350,7 +7350,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 			priv->global_tx_fc = true;
 	}
 
-	if (priv->hw_version != MVPP21 && dev_of_node(&pdev->dev)) {
+	if (priv->hw_version >= MVPP22 && dev_of_node(&pdev->dev)) {
 		priv->sysctrl_base =
 			syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
 							"marvell,system-controller");
@@ -7363,7 +7363,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 			priv->sysctrl_base = NULL;
 	}
 
-	if (priv->hw_version != MVPP21 &&
+	if (priv->hw_version >= MVPP22 &&
 	    mvpp2_get_nrxqs(priv) * 2 <= MVPP2_BM_MAX_POOLS)
 		priv->percpu_pools = 1;
 
@@ -7408,7 +7408,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 		if (err < 0)
 			goto err_pp_clk;
 
-		if (priv->hw_version != MVPP21) {
+		if (priv->hw_version >= MVPP22) {
 			priv->mg_clk = devm_clk_get(&pdev->dev, "mg_clk");
 			if (IS_ERR(priv->mg_clk)) {
 				err = PTR_ERR(priv->mg_clk);
@@ -7449,7 +7449,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (priv->hw_version != MVPP21) {
+	if (priv->hw_version >= MVPP22) {
 		err = dma_set_mask(&pdev->dev, MVPP2_DESC_DMA_MASK);
 		if (err)
 			goto err_axi_clk;
@@ -7514,7 +7514,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 		goto err_port_probe;
 	}
 
-	if (priv->global_tx_fc && priv->hw_version != MVPP21) {
+	if (priv->global_tx_fc && priv->hw_version >= MVPP22) {
 		err = mvpp2_enable_global_fc(priv);
 		if (err)
 			dev_warn(&pdev->dev, "Minimum of CM3 firmware 18.09 and chip revision B0 required for flow control\n");
@@ -7536,10 +7536,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 	clk_disable_unprepare(priv->axi_clk);
 
 err_mg_core_clk:
-	if (priv->hw_version != MVPP21)
+	if (priv->hw_version >= MVPP22)
 		clk_disable_unprepare(priv->mg_core_clk);
 err_mg_clk:
-	if (priv->hw_version != MVPP21)
+	if (priv->hw_version >= MVPP22)
 		clk_disable_unprepare(priv->mg_clk);
 err_gop_clk:
 	clk_disable_unprepare(priv->gop_clk);
-- 
1.9.1

