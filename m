Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6218818DC0
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfEIQLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:11:42 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:55478 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfEIQLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:11:15 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x49GB3Gu031160;
        Thu, 9 May 2019 11:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1557418263;
        bh=WXApDcqqGjHFo5JxUObDw6oR8tDsdnWz9m9uyD5LX8o=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=fIHsw42fk3zUokSmqIaGpfv+fr87YayL7rsoRU4C4fZRxq7BuITmDoRDOoswXx5mi
         LlvDpWvQiItMFxRWuG0fwG6NbuS4NKrlY7o024rzJWRVA6WO6jEnz3nsRx04LZkToM
         5Go2T+NkMNUI6huyxry7I+uaDRBDHFScyF5entFo=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x49GB3oo015074
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 May 2019 11:11:03 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 9 May
 2019 11:11:02 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 9 May 2019 11:11:02 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x49GB26e129461;
        Thu, 9 May 2019 11:11:02 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v12 2/5] can: m_can: Rename m_can_priv to m_can_classdev
Date:   Thu, 9 May 2019 11:11:06 -0500
Message-ID: <20190509161109.10499-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.21.0.5.gaeb582a983
In-Reply-To: <20190509161109.10499-1-dmurphy@ti.com>
References: <20190509161109.10499-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the common m_can_priv class structure to
m_can_classdev as this is more descriptive.

Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---

v12 - Rebased on top of changes made in (can: m_can: Create a m_can platform framework) -
https://lore.kernel.org/patchwork/patch/1052303/

v11 - No changes - https://lore.kernel.org/patchwork/patch/1051181/
v10 - No changes - https://lore.kernel.org/patchwork/patch/1050489/
v9 - Made additional changes on new code to make priv->cdev other wise no changes
https://lore.kernel.org/patchwork/patch/1050121/
v8 - Made additional changes on new code to make priv->cdev, and updated the
header file class_dev variable to be consistent. - https://lore.kernel.org/patchwork/patch/1047979/
v7 - Fixed remaining checkpatch issues, renamed priv to cdev - https://lore.kernel.org/patchwork/patch/1047219/
v6 - No changes only rebase changes possibly can squash into the first patch - 
https://lore.kernel.org/patchwork/patch/1042444/

 drivers/net/can/m_can/m_can.c          | 532 +++++++++++++------------
 drivers/net/can/m_can/m_can.h          |  28 +-
 drivers/net/can/m_can/m_can_platform.c |  16 +-
 3 files changed, 290 insertions(+), 286 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 5f88ff605341..923c53204d7d 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -320,57 +320,57 @@ enum m_can_reg {
 #define TX_EVENT_MM_SHIFT	TX_BUF_MM_SHIFT
 #define TX_EVENT_MM_MASK	(0xff << TX_EVENT_MM_SHIFT)
 
-static inline u32 m_can_read(struct m_can_priv *priv, enum m_can_reg reg)
+static inline u32 m_can_read(struct m_can_classdev *cdev, enum m_can_reg reg)
 {
-	return priv->ops->read_reg(priv, reg);
+	return cdev->ops->read_reg(cdev, reg);
 }
 
-static inline void m_can_write(struct m_can_priv *priv, enum m_can_reg reg,
+static inline void m_can_write(struct m_can_classdev *cdev, enum m_can_reg reg,
 			       u32 val)
 {
-	priv->ops->write_reg(priv, reg, val);
+	cdev->ops->write_reg(cdev, reg, val);
 }
 
-static u32 m_can_fifo_read(struct m_can_priv *priv,
+static u32 m_can_fifo_read(struct m_can_classdev *cdev,
 			   u32 fgi, unsigned int offset)
 {
-	u32 addr_offset = priv->mcfg[MRAM_RXF0].off + fgi * RXF0_ELEMENT_SIZE +
+	u32 addr_offset = cdev->mcfg[MRAM_RXF0].off + fgi * RXF0_ELEMENT_SIZE +
 			  offset;
 
-	return priv->ops->read_fifo(priv, addr_offset);
+	return cdev->ops->read_fifo(cdev, addr_offset);
 }
 
-static void m_can_fifo_write(struct m_can_priv *priv,
+static void m_can_fifo_write(struct m_can_classdev *cdev,
 			    u32 fpi, unsigned int offset, u32 val)
 {
-	u32 addr_offset = priv->mcfg[MRAM_TXB].off + fpi * TXB_ELEMENT_SIZE +
+	u32 addr_offset = cdev->mcfg[MRAM_TXB].off + fpi * TXB_ELEMENT_SIZE +
 			  offset;
 
-	priv->ops->write_fifo(priv, addr_offset, val);
+	cdev->ops->write_fifo(cdev, addr_offset, val);
 }
 
-static inline void m_can_fifo_write_no_off(struct m_can_priv *priv,
+static inline void m_can_fifo_write_no_off(struct m_can_classdev *cdev,
 				   u32 fpi, u32 val)
 {
-	priv->ops->write_fifo(priv, fpi, val);
+	cdev->ops->write_fifo(cdev, fpi, val);
 }
 
-static u32 m_can_txe_fifo_read(struct m_can_priv *priv, u32 fgi, u32 offset)
+static u32 m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset)
 {
-	u32 addr_offset = priv->mcfg[MRAM_TXE].off + fgi * TXE_ELEMENT_SIZE +
+	u32 addr_offset = cdev->mcfg[MRAM_TXE].off + fgi * TXE_ELEMENT_SIZE +
 			  offset;
 
-	return priv->ops->read_fifo(priv, addr_offset);
+	return cdev->ops->read_fifo(cdev, addr_offset);
 }
 
-static inline bool m_can_tx_fifo_full(struct m_can_priv *priv)
+static inline bool m_can_tx_fifo_full(struct m_can_classdev *cdev)
 {
-		return !!(m_can_read(priv, M_CAN_TXFQS) & TXFQS_TFQF);
+		return !!(m_can_read(cdev, M_CAN_TXFQS) & TXFQS_TFQF);
 }
 
-void m_can_config_endisable(struct m_can_priv *priv, bool enable)
+void m_can_config_endisable(struct m_can_classdev *cdev, bool enable)
 {
-	u32 cccr = m_can_read(priv, M_CAN_CCCR);
+	u32 cccr = m_can_read(cdev, M_CAN_CCCR);
 	u32 timeout = 10;
 	u32 val = 0;
 
@@ -384,21 +384,21 @@ void m_can_config_endisable(struct m_can_priv *priv, bool enable)
 			cccr &= ~CCCR_CSR;
 
 		/* enable m_can configuration */
-		m_can_write(priv, M_CAN_CCCR, cccr | CCCR_INIT);
+		m_can_write(cdev, M_CAN_CCCR, cccr | CCCR_INIT);
 		udelay(5);
 		/* CCCR.CCE can only be set/reset while CCCR.INIT = '1' */
-		m_can_write(priv, M_CAN_CCCR, cccr | CCCR_INIT | CCCR_CCE);
+		m_can_write(cdev, M_CAN_CCCR, cccr | CCCR_INIT | CCCR_CCE);
 	} else {
-		m_can_write(priv, M_CAN_CCCR, cccr & ~(CCCR_INIT | CCCR_CCE));
+		m_can_write(cdev, M_CAN_CCCR, cccr & ~(CCCR_INIT | CCCR_CCE));
 	}
 
 	/* there's a delay for module initialization */
 	if (enable)
 		val = CCCR_INIT | CCCR_CCE;
 
-	while ((m_can_read(priv, M_CAN_CCCR) & (CCCR_INIT | CCCR_CCE)) != val) {
+	while ((m_can_read(cdev, M_CAN_CCCR) & (CCCR_INIT | CCCR_CCE)) != val) {
 		if (timeout == 0) {
-			netdev_warn(priv->net, "Failed to init module\n");
+			netdev_warn(cdev->net, "Failed to init module\n");
 			return;
 		}
 		timeout--;
@@ -406,38 +406,38 @@ void m_can_config_endisable(struct m_can_priv *priv, bool enable)
 	}
 }
 
-static inline void m_can_enable_all_interrupts(struct m_can_priv *priv)
+static inline void m_can_enable_all_interrupts(struct m_can_classdev *cdev)
 {
 	/* Only interrupt line 0 is used in this driver */
-	m_can_write(priv, M_CAN_ILE, ILE_EINT0);
+	m_can_write(cdev, M_CAN_ILE, ILE_EINT0);
 }
 
-static inline void m_can_disable_all_interrupts(struct m_can_priv *priv)
+static inline void m_can_disable_all_interrupts(struct m_can_classdev *cdev)
 {
-	m_can_write(priv, M_CAN_ILE, 0x0);
+	m_can_write(cdev, M_CAN_ILE, 0x0);
 }
 
 static void m_can_clean(struct net_device *net)
 {
-	struct m_can_priv *priv = netdev_priv(net);
+	struct m_can_classdev *cdev = netdev_priv(net);
 
-	if (priv->tx_skb) {
+	if (cdev->tx_skb) {
 		int putidx = 0;
 
 		net->stats.tx_errors++;
-		if (priv->version > 30)
-			putidx = ((m_can_read(priv, M_CAN_TXFQS) &
+		if (cdev->version > 30)
+			putidx = ((m_can_read(cdev, M_CAN_TXFQS) &
 				   TXFQS_TFQPI_MASK) >> TXFQS_TFQPI_SHIFT);
 
-		can_free_echo_skb(priv->net, putidx);
-		priv->tx_skb = NULL;
+		can_free_echo_skb(cdev->net, putidx);
+		cdev->tx_skb = NULL;
 	}
 }
 
 static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 {
 	struct net_device_stats *stats = &dev->stats;
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	struct canfd_frame *cf;
 	struct sk_buff *skb;
 	u32 id, fgi, dlc;
@@ -445,7 +445,7 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 
 	/* calculate the fifo get index for where to read data */
 	fgi = (rxfs & RXFS_FGI_MASK) >> RXFS_FGI_SHIFT;
-	dlc = m_can_fifo_read(priv, fgi, M_CAN_FIFO_DLC);
+	dlc = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_DLC);
 	if (dlc & RX_BUF_FDF)
 		skb = alloc_canfd_skb(dev, &cf);
 	else
@@ -460,7 +460,7 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 	else
 		cf->len = get_can_dlc((dlc >> 16) & 0x0F);
 
-	id = m_can_fifo_read(priv, fgi, M_CAN_FIFO_ID);
+	id = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID);
 	if (id & RX_BUF_XTD)
 		cf->can_id = (id & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
@@ -479,12 +479,12 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 
 		for (i = 0; i < cf->len; i += 4)
 			*(u32 *)(cf->data + i) =
-				m_can_fifo_read(priv, fgi,
+				m_can_fifo_read(cdev, fgi,
 						M_CAN_FIFO_DATA(i / 4));
 	}
 
 	/* acknowledge rx fifo 0 */
-	m_can_write(priv, M_CAN_RXF0A, fgi);
+	m_can_write(cdev, M_CAN_RXF0A, fgi);
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->len;
@@ -494,11 +494,11 @@ static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 
 static int m_can_do_rx_poll(struct net_device *dev, int quota)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 pkts = 0;
 	u32 rxfs;
 
-	rxfs = m_can_read(priv, M_CAN_RXF0S);
+	rxfs = m_can_read(cdev, M_CAN_RXF0S);
 	if (!(rxfs & RXFS_FFL_MASK)) {
 		netdev_dbg(dev, "no messages in fifo0\n");
 		return 0;
@@ -512,7 +512,7 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 
 		quota--;
 		pkts++;
-		rxfs = m_can_read(priv, M_CAN_RXF0S);
+		rxfs = m_can_read(cdev, M_CAN_RXF0S);
 	}
 
 	if (pkts)
@@ -547,12 +547,12 @@ static int m_can_handle_lost_msg(struct net_device *dev)
 static int m_can_handle_lec_err(struct net_device *dev,
 				enum m_can_lec_type lec_type)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	struct net_device_stats *stats = &dev->stats;
 	struct can_frame *cf;
 	struct sk_buff *skb;
 
-	priv->can.can_stats.bus_error++;
+	cdev->can.can_stats.bus_error++;
 	stats->rx_errors++;
 
 	/* propagate the error condition to the CAN stack */
@@ -604,51 +604,51 @@ static int m_can_handle_lec_err(struct net_device *dev,
 static int __m_can_get_berr_counter(const struct net_device *dev,
 				    struct can_berr_counter *bec)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	unsigned int ecr;
 
-	ecr = m_can_read(priv, M_CAN_ECR);
+	ecr = m_can_read(cdev, M_CAN_ECR);
 	bec->rxerr = (ecr & ECR_REC_MASK) >> ECR_REC_SHIFT;
 	bec->txerr = (ecr & ECR_TEC_MASK) >> ECR_TEC_SHIFT;
 
 	return 0;
 }
 
-static int m_can_clk_start(struct m_can_priv *priv)
+static int m_can_clk_start(struct m_can_classdev *cdev)
 {
 	int err;
 
-	if (priv->pm_clock_support == 0)
+	if (cdev->pm_clock_support == 0)
 		return 0;
 
-	err = pm_runtime_get_sync(priv->dev);
+	err = pm_runtime_get_sync(cdev->dev);
 	if (err < 0) {
-		pm_runtime_put_noidle(priv->dev);
+		pm_runtime_put_noidle(cdev->dev);
 		return err;
 	}
 
 	return 0;
 }
 
-static void m_can_clk_stop(struct m_can_priv *priv)
+static void m_can_clk_stop(struct m_can_classdev *cdev)
 {
-	if (priv->pm_clock_support)
-		pm_runtime_put_sync(priv->dev);
+	if (cdev->pm_clock_support)
+		pm_runtime_put_sync(cdev->dev);
 }
 
 static int m_can_get_berr_counter(const struct net_device *dev,
 				  struct can_berr_counter *bec)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	int err;
 
-	err = m_can_clk_start(priv);
+	err = m_can_clk_start(cdev);
 	if (err)
 		return err;
 
 	__m_can_get_berr_counter(dev, bec);
 
-	m_can_clk_stop(priv);
+	m_can_clk_stop(cdev);
 
 	return 0;
 }
@@ -656,7 +656,7 @@ static int m_can_get_berr_counter(const struct net_device *dev,
 static int m_can_handle_state_change(struct net_device *dev,
 				     enum can_state new_state)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	struct net_device_stats *stats = &dev->stats;
 	struct can_frame *cf;
 	struct sk_buff *skb;
@@ -666,19 +666,19 @@ static int m_can_handle_state_change(struct net_device *dev,
 	switch (new_state) {
 	case CAN_STATE_ERROR_ACTIVE:
 		/* error warning state */
-		priv->can.can_stats.error_warning++;
-		priv->can.state = CAN_STATE_ERROR_WARNING;
+		cdev->can.can_stats.error_warning++;
+		cdev->can.state = CAN_STATE_ERROR_WARNING;
 		break;
 	case CAN_STATE_ERROR_PASSIVE:
 		/* error passive state */
-		priv->can.can_stats.error_passive++;
-		priv->can.state = CAN_STATE_ERROR_PASSIVE;
+		cdev->can.can_stats.error_passive++;
+		cdev->can.state = CAN_STATE_ERROR_PASSIVE;
 		break;
 	case CAN_STATE_BUS_OFF:
 		/* bus-off state */
-		priv->can.state = CAN_STATE_BUS_OFF;
-		m_can_disable_all_interrupts(priv);
-		priv->can.can_stats.bus_off++;
+		cdev->can.state = CAN_STATE_BUS_OFF;
+		m_can_disable_all_interrupts(cdev);
+		cdev->can.can_stats.bus_off++;
 		can_bus_off(dev);
 		break;
 	default:
@@ -705,7 +705,7 @@ static int m_can_handle_state_change(struct net_device *dev,
 	case CAN_STATE_ERROR_PASSIVE:
 		/* error passive state */
 		cf->can_id |= CAN_ERR_CRTL;
-		ecr = m_can_read(priv, M_CAN_ECR);
+		ecr = m_can_read(cdev, M_CAN_ECR);
 		if (ecr & ECR_RP)
 			cf->data[1] |= CAN_ERR_CRTL_RX_PASSIVE;
 		if (bec.txerr > 127)
@@ -730,25 +730,25 @@ static int m_can_handle_state_change(struct net_device *dev,
 
 static int m_can_handle_state_errors(struct net_device *dev, u32 psr)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done = 0;
 
 	if ((psr & PSR_EW) &&
-	    (priv->can.state != CAN_STATE_ERROR_WARNING)) {
+	    (cdev->can.state != CAN_STATE_ERROR_WARNING)) {
 		netdev_dbg(dev, "entered error warning state\n");
 		work_done += m_can_handle_state_change(dev,
 						       CAN_STATE_ERROR_WARNING);
 	}
 
 	if ((psr & PSR_EP) &&
-	    (priv->can.state != CAN_STATE_ERROR_PASSIVE)) {
+	    (cdev->can.state != CAN_STATE_ERROR_PASSIVE)) {
 		netdev_dbg(dev, "entered error passive state\n");
 		work_done += m_can_handle_state_change(dev,
 						       CAN_STATE_ERROR_PASSIVE);
 	}
 
 	if ((psr & PSR_BO) &&
-	    (priv->can.state != CAN_STATE_BUS_OFF)) {
+	    (cdev->can.state != CAN_STATE_BUS_OFF)) {
 		netdev_dbg(dev, "entered error bus off state\n");
 		work_done += m_can_handle_state_change(dev,
 						       CAN_STATE_BUS_OFF);
@@ -783,14 +783,14 @@ static inline bool is_lec_err(u32 psr)
 static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 				   u32 psr)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done = 0;
 
 	if (irqstatus & IR_RF0L)
 		work_done += m_can_handle_lost_msg(dev);
 
 	/* handle lec errors on the bus */
-	if ((priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
+	if ((cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
 	    is_lec_err(psr))
 		work_done += m_can_handle_lec_err(dev, psr & LEC_UNUSED);
 
@@ -802,15 +802,15 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 
 static int m_can_rx_handler(struct net_device *dev, int quota)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done = 0;
 	u32 irqstatus, psr;
 
-	irqstatus = priv->irqstatus | m_can_read(priv, M_CAN_IR);
+	irqstatus = cdev->irqstatus | m_can_read(cdev, M_CAN_IR);
 	if (!irqstatus)
 		goto end;
 
-	psr = m_can_read(priv, M_CAN_PSR);
+	psr = m_can_read(cdev, M_CAN_PSR);
 	if (irqstatus & IR_ERR_STATE)
 		work_done += m_can_handle_state_errors(dev, psr);
 
@@ -825,11 +825,11 @@ static int m_can_rx_handler(struct net_device *dev, int quota)
 
 static int m_can_rx_peripheral(struct net_device *dev)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 
 	m_can_rx_handler(dev, 1);
 
-	m_can_enable_all_interrupts(priv);
+	m_can_enable_all_interrupts(cdev);
 
 	return 0;
 }
@@ -837,13 +837,13 @@ static int m_can_rx_peripheral(struct net_device *dev)
 static int m_can_poll(struct napi_struct *napi, int quota)
 {
 	struct net_device *dev = napi->dev;
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done;
 
 	work_done = m_can_rx_handler(dev, quota);
 	if (work_done < quota) {
 		napi_complete_done(napi, work_done);
-		m_can_enable_all_interrupts(priv);
+		m_can_enable_all_interrupts(cdev);
 	}
 
 	return work_done;
@@ -857,11 +857,11 @@ static void m_can_echo_tx_event(struct net_device *dev)
 	int i = 0;
 	unsigned int msg_mark;
 
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	struct net_device_stats *stats = &dev->stats;
 
 	/* read tx event fifo status */
-	m_can_txefs = m_can_read(priv, M_CAN_TXEFS);
+	m_can_txefs = m_can_read(cdev, M_CAN_TXEFS);
 
 	/* Get Tx Event fifo element count */
 	txe_count = (m_can_txefs & TXEFS_EFFL_MASK)
@@ -870,15 +870,15 @@ static void m_can_echo_tx_event(struct net_device *dev)
 	/* Get and process all sent elements */
 	for (i = 0; i < txe_count; i++) {
 		/* retrieve get index */
-		fgi = (m_can_read(priv, M_CAN_TXEFS) & TXEFS_EFGI_MASK)
+		fgi = (m_can_read(cdev, M_CAN_TXEFS) & TXEFS_EFGI_MASK)
 			>> TXEFS_EFGI_SHIFT;
 
 		/* get message marker */
-		msg_mark = (m_can_txe_fifo_read(priv, fgi, 4) &
+		msg_mark = (m_can_txe_fifo_read(cdev, fgi, 4) &
 			    TX_EVENT_MM_MASK) >> TX_EVENT_MM_SHIFT;
 
 		/* ack txe element */
-		m_can_write(priv, M_CAN_TXEFA, (TXEFA_EFAI_MASK &
+		m_can_write(cdev, M_CAN_TXEFA, (TXEFA_EFAI_MASK &
 						(fgi << TXEFA_EFAI_SHIFT)));
 
 		/* update stats */
@@ -890,20 +890,20 @@ static void m_can_echo_tx_event(struct net_device *dev)
 static irqreturn_t m_can_isr(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	struct net_device_stats *stats = &dev->stats;
 	u32 ir;
 
-	ir = m_can_read(priv, M_CAN_IR);
+	ir = m_can_read(cdev, M_CAN_IR);
 	if (!ir)
 		return IRQ_NONE;
 
 	/* ACK all irqs */
 	if (ir & IR_ALL_INT)
-		m_can_write(priv, M_CAN_IR, ir);
+		m_can_write(cdev, M_CAN_IR, ir);
 
-	if (priv->ops->clear_interrupts)
-		priv->ops->clear_interrupts(priv);
+	if (cdev->ops->clear_interrupts)
+		cdev->ops->clear_interrupts(cdev);
 
 	/* schedule NAPI in case of
 	 * - rx IRQ
@@ -911,15 +911,15 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	 * - bus error IRQ and bus error reporting
 	 */
 	if ((ir & IR_RF0N) || (ir & IR_ERR_ALL_30X)) {
-		priv->irqstatus = ir;
-		m_can_disable_all_interrupts(priv);
-		if (!priv->is_peripheral)
-			napi_schedule(&priv->napi);
+		cdev->irqstatus = ir;
+		m_can_disable_all_interrupts(cdev);
+		if (!cdev->is_peripheral)
+			napi_schedule(&cdev->napi);
 		else
 			m_can_rx_peripheral(dev);
 	}
 
-	if (priv->version == 30) {
+	if (cdev->version == 30) {
 		if (ir & IR_TC) {
 			/* Transmission Complete Interrupt*/
 			stats->tx_bytes += can_get_echo_skb(dev, 0);
@@ -933,7 +933,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			m_can_echo_tx_event(dev);
 			can_led_event(dev, CAN_LED_EVENT_TX);
 			if (netif_queue_stopped(dev) &&
-			    !m_can_tx_fifo_full(priv))
+			    !m_can_tx_fifo_full(cdev))
 				netif_wake_queue(dev);
 		}
 	}
@@ -991,9 +991,9 @@ static const struct can_bittiming_const m_can_data_bittiming_const_31X = {
 
 static int m_can_set_bittiming(struct net_device *dev)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
-	const struct can_bittiming *bt = &priv->can.bittiming;
-	const struct can_bittiming *dbt = &priv->can.data_bittiming;
+	struct m_can_classdev *cdev = netdev_priv(dev);
+	const struct can_bittiming *bt = &cdev->can.bittiming;
+	const struct can_bittiming *dbt = &cdev->can.data_bittiming;
 	u16 brp, sjw, tseg1, tseg2;
 	u32 reg_btp;
 
@@ -1003,9 +1003,9 @@ static int m_can_set_bittiming(struct net_device *dev)
 	tseg2 = bt->phase_seg2 - 1;
 	reg_btp = (brp << NBTP_NBRP_SHIFT) | (sjw << NBTP_NSJW_SHIFT) |
 		(tseg1 << NBTP_NTSEG1_SHIFT) | (tseg2 << NBTP_NTSEG2_SHIFT);
-	m_can_write(priv, M_CAN_NBTP, reg_btp);
+	m_can_write(cdev, M_CAN_NBTP, reg_btp);
 
-	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
+	if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
 		reg_btp = 0;
 		brp = dbt->brp - 1;
 		sjw = dbt->sjw - 1;
@@ -1027,7 +1027,7 @@ static int m_can_set_bittiming(struct net_device *dev)
 			/* Equation based on Bosch's M_CAN User Manual's
 			 * Transmitter Delay Compensation Section
 			 */
-			tdco = (priv->can.clock.freq / 1000) *
+			tdco = (cdev->can.clock.freq / 1000) *
 			       ssp / dbt->bitrate;
 
 			/* Max valid TDCO value is 127 */
@@ -1038,7 +1038,7 @@ static int m_can_set_bittiming(struct net_device *dev)
 			}
 
 			reg_btp |= DBTP_TDC;
-			m_can_write(priv, M_CAN_TDCR,
+			m_can_write(cdev, M_CAN_TDCR,
 				    tdco << TDCR_TDCO_SHIFT);
 		}
 
@@ -1047,7 +1047,7 @@ static int m_can_set_bittiming(struct net_device *dev)
 			   (tseg1 << DBTP_DTSEG1_SHIFT) |
 			   (tseg2 << DBTP_DTSEG2_SHIFT);
 
-		m_can_write(priv, M_CAN_DBTP, reg_btp);
+		m_can_write(cdev, M_CAN_DBTP, reg_btp);
 	}
 
 	return 0;
@@ -1064,63 +1064,63 @@ static int m_can_set_bittiming(struct net_device *dev)
  */
 static void m_can_chip_config(struct net_device *dev)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 cccr, test;
 
-	m_can_config_endisable(priv, true);
+	m_can_config_endisable(cdev, true);
 
 	/* RX Buffer/FIFO Element Size 64 bytes data field */
-	m_can_write(priv, M_CAN_RXESC, M_CAN_RXESC_64BYTES);
+	m_can_write(cdev, M_CAN_RXESC, M_CAN_RXESC_64BYTES);
 
 	/* Accept Non-matching Frames Into FIFO 0 */
-	m_can_write(priv, M_CAN_GFC, 0x0);
+	m_can_write(cdev, M_CAN_GFC, 0x0);
 
-	if (priv->version == 30) {
+	if (cdev->version == 30) {
 		/* only support one Tx Buffer currently */
-		m_can_write(priv, M_CAN_TXBC, (1 << TXBC_NDTB_SHIFT) |
-				priv->mcfg[MRAM_TXB].off);
+		m_can_write(cdev, M_CAN_TXBC, (1 << TXBC_NDTB_SHIFT) |
+				cdev->mcfg[MRAM_TXB].off);
 	} else {
 		/* TX FIFO is used for newer IP Core versions */
-		m_can_write(priv, M_CAN_TXBC,
-			    (priv->mcfg[MRAM_TXB].num << TXBC_TFQS_SHIFT) |
-			    (priv->mcfg[MRAM_TXB].off));
+		m_can_write(cdev, M_CAN_TXBC,
+			    (cdev->mcfg[MRAM_TXB].num << TXBC_TFQS_SHIFT) |
+			    (cdev->mcfg[MRAM_TXB].off));
 	}
 
 	/* support 64 bytes payload */
-	m_can_write(priv, M_CAN_TXESC, TXESC_TBDS_64BYTES);
+	m_can_write(cdev, M_CAN_TXESC, TXESC_TBDS_64BYTES);
 
 	/* TX Event FIFO */
-	if (priv->version == 30) {
-		m_can_write(priv, M_CAN_TXEFC, (1 << TXEFC_EFS_SHIFT) |
-				priv->mcfg[MRAM_TXE].off);
+	if (cdev->version == 30) {
+		m_can_write(cdev, M_CAN_TXEFC, (1 << TXEFC_EFS_SHIFT) |
+				cdev->mcfg[MRAM_TXE].off);
 	} else {
 		/* Full TX Event FIFO is used */
-		m_can_write(priv, M_CAN_TXEFC,
-			    ((priv->mcfg[MRAM_TXE].num << TXEFC_EFS_SHIFT)
+		m_can_write(cdev, M_CAN_TXEFC,
+			    ((cdev->mcfg[MRAM_TXE].num << TXEFC_EFS_SHIFT)
 			     & TXEFC_EFS_MASK) |
-			    priv->mcfg[MRAM_TXE].off);
+			    cdev->mcfg[MRAM_TXE].off);
 	}
 
 	/* rx fifo configuration, blocking mode, fifo size 1 */
-	m_can_write(priv, M_CAN_RXF0C,
-		    (priv->mcfg[MRAM_RXF0].num << RXFC_FS_SHIFT) |
-		     priv->mcfg[MRAM_RXF0].off);
+	m_can_write(cdev, M_CAN_RXF0C,
+		    (cdev->mcfg[MRAM_RXF0].num << RXFC_FS_SHIFT) |
+		     cdev->mcfg[MRAM_RXF0].off);
 
-	m_can_write(priv, M_CAN_RXF1C,
-		    (priv->mcfg[MRAM_RXF1].num << RXFC_FS_SHIFT) |
-		     priv->mcfg[MRAM_RXF1].off);
+	m_can_write(cdev, M_CAN_RXF1C,
+		    (cdev->mcfg[MRAM_RXF1].num << RXFC_FS_SHIFT) |
+		     cdev->mcfg[MRAM_RXF1].off);
 
-	cccr = m_can_read(priv, M_CAN_CCCR);
-	test = m_can_read(priv, M_CAN_TEST);
+	cccr = m_can_read(cdev, M_CAN_CCCR);
+	test = m_can_read(cdev, M_CAN_TEST);
 	test &= ~TEST_LBCK;
-	if (priv->version == 30) {
+	if (cdev->version == 30) {
 	/* Version 3.0.x */
 
 		cccr &= ~(CCCR_TEST | CCCR_MON |
 			(CCCR_CMR_MASK << CCCR_CMR_SHIFT) |
 			(CCCR_CME_MASK << CCCR_CME_SHIFT));
 
-		if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD)
 			cccr |= CCCR_CME_CANFD_BRS << CCCR_CME_SHIFT;
 
 	} else {
@@ -1129,61 +1129,61 @@ static void m_can_chip_config(struct net_device *dev)
 			  CCCR_NISO);
 
 		/* Only 3.2.x has NISO Bit implemented */
-		if (priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
+		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
 			cccr |= CCCR_NISO;
 
-		if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD)
 			cccr |= (CCCR_BRSE | CCCR_FDOE);
 	}
 
 	/* Loopback Mode */
-	if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK) {
+	if (cdev->can.ctrlmode & CAN_CTRLMODE_LOOPBACK) {
 		cccr |= CCCR_TEST | CCCR_MON;
 		test |= TEST_LBCK;
 	}
 
 	/* Enable Monitoring (all versions) */
-	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
+	if (cdev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		cccr |= CCCR_MON;
 
 	/* Write config */
-	m_can_write(priv, M_CAN_CCCR, cccr);
-	m_can_write(priv, M_CAN_TEST, test);
+	m_can_write(cdev, M_CAN_CCCR, cccr);
+	m_can_write(cdev, M_CAN_TEST, test);
 
 	/* Enable interrupts */
-	m_can_write(priv, M_CAN_IR, IR_ALL_INT);
-	if (!(priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
-		if (priv->version == 30)
-			m_can_write(priv, M_CAN_IE, IR_ALL_INT &
+	m_can_write(cdev, M_CAN_IR, IR_ALL_INT);
+	if (!(cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
+		if (cdev->version == 30)
+			m_can_write(cdev, M_CAN_IE, IR_ALL_INT &
 				    ~(IR_ERR_LEC_30X));
 		else
-			m_can_write(priv, M_CAN_IE, IR_ALL_INT &
+			m_can_write(cdev, M_CAN_IE, IR_ALL_INT &
 				    ~(IR_ERR_LEC_31X));
 	else
-		m_can_write(priv, M_CAN_IE, IR_ALL_INT);
+		m_can_write(cdev, M_CAN_IE, IR_ALL_INT);
 
 	/* route all interrupts to INT0 */
-	m_can_write(priv, M_CAN_ILS, ILS_ALL_INT0);
+	m_can_write(cdev, M_CAN_ILS, ILS_ALL_INT0);
 
 	/* set bittiming params */
 	m_can_set_bittiming(dev);
 
-	m_can_config_endisable(priv, false);
+	m_can_config_endisable(cdev, false);
 
-	if (priv->ops->init)
-		priv->ops->init(priv);
+	if (cdev->ops->init)
+		cdev->ops->init(cdev);
 }
 
 static void m_can_start(struct net_device *dev)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 
 	/* basic m_can configuration */
 	m_can_chip_config(dev);
 
-	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
-	m_can_enable_all_interrupts(priv);
+	m_can_enable_all_interrupts(cdev);
 }
 
 static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
@@ -1206,7 +1206,7 @@ static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
  * else it returns the release and step coded as:
  * return value = 10 * <release> + 1 * <step>
  */
-static int m_can_check_core_release(struct m_can_priv *priv)
+static int m_can_check_core_release(struct m_can_classdev *cdev)
 {
 	u32 crel_reg;
 	u8 rel;
@@ -1216,7 +1216,7 @@ static int m_can_check_core_release(struct m_can_priv *priv)
 	/* Read Core Release Version and split into version number
 	 * Example: Version 3.2.1 => rel = 3; step = 2; substep = 1;
 	 */
-	crel_reg = m_can_read(priv, M_CAN_CREL);
+	crel_reg = m_can_read(cdev, M_CAN_CREL);
 	rel = (u8)((crel_reg & CREL_REL_MASK) >> CREL_REL_SHIFT);
 	step = (u8)((crel_reg & CREL_STEP_MASK) >> CREL_STEP_SHIFT);
 
@@ -1234,19 +1234,19 @@ static int m_can_check_core_release(struct m_can_priv *priv)
 /* Selectable Non ISO support only in version 3.2.x
  * This function checks if the bit is writable.
  */
-static bool m_can_niso_supported(struct m_can_priv *priv)
+static bool m_can_niso_supported(struct m_can_classdev *cdev)
 {
 	u32 cccr_reg, cccr_poll = 0;
 	int niso_timeout = -ETIMEDOUT;
 	int i;
 
-	m_can_config_endisable(priv, true);
-	cccr_reg = m_can_read(priv, M_CAN_CCCR);
+	m_can_config_endisable(cdev, true);
+	cccr_reg = m_can_read(cdev, M_CAN_CCCR);
 	cccr_reg |= CCCR_NISO;
-	m_can_write(priv, M_CAN_CCCR, cccr_reg);
+	m_can_write(cdev, M_CAN_CCCR, cccr_reg);
 
 	for (i = 0; i <= 10; i++) {
-		cccr_poll = m_can_read(priv, M_CAN_CCCR);
+		cccr_poll = m_can_read(cdev, M_CAN_CCCR);
 		if (cccr_poll == cccr_reg) {
 			niso_timeout = 0;
 			break;
@@ -1257,15 +1257,15 @@ static bool m_can_niso_supported(struct m_can_priv *priv)
 
 	/* Clear NISO */
 	cccr_reg &= ~(CCCR_NISO);
-	m_can_write(priv, M_CAN_CCCR, cccr_reg);
+	m_can_write(cdev, M_CAN_CCCR, cccr_reg);
 
-	m_can_config_endisable(priv, false);
+	m_can_config_endisable(cdev, false);
 
 	/* return false if time out (-ETIMEDOUT), else return true */
 	return !niso_timeout;
 }
 
-static int m_can_dev_setup(struct m_can_priv *m_can_dev)
+static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 {
 	struct net_device *dev = m_can_dev->net;
 	int m_can_version;
@@ -1342,30 +1342,32 @@ static int m_can_dev_setup(struct m_can_priv *m_can_dev)
 
 static void m_can_stop(struct net_device *dev)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 
 	/* disable all interrupts */
-	m_can_disable_all_interrupts(priv);
+	m_can_disable_all_interrupts(cdev);
 
 	/* set the state as STOPPED */
-	priv->can.state = CAN_STATE_STOPPED;
+	cdev->can.state = CAN_STATE_STOPPED;
 }
 
 static int m_can_close(struct net_device *dev)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 
 	netif_stop_queue(dev);
-	if (!priv->is_peripheral)
-		napi_disable(&priv->napi);
+
+	if (!cdev->is_peripheral)
+		napi_disable(&cdev->napi);
+
 	m_can_stop(dev);
-	m_can_clk_stop(priv);
+	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
 
-	if (priv->is_peripheral) {
-		priv->tx_skb = NULL;
-		destroy_workqueue(priv->tx_wq);
-		priv->tx_wq = NULL;
+	if (cdev->is_peripheral) {
+		cdev->tx_skb = NULL;
+		destroy_workqueue(cdev->tx_wq);
+		cdev->tx_wq = NULL;
 	}
 
 	close_candev(dev);
@@ -1376,23 +1378,23 @@ static int m_can_close(struct net_device *dev)
 
 static int m_can_next_echo_skb_occupied(struct net_device *dev, int putidx)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	/*get wrap around for loopback skb index */
-	unsigned int wrap = priv->can.echo_skb_max;
+	unsigned int wrap = cdev->can.echo_skb_max;
 	int next_idx;
 
 	/* calculate next index */
 	next_idx = (++putidx >= wrap ? 0 : putidx);
 
 	/* check if occupied */
-	return !!priv->can.echo_skb[next_idx];
+	return !!cdev->can.echo_skb[next_idx];
 }
 
-static netdev_tx_t m_can_tx_handler(struct m_can_priv *priv)
+static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 {
-	struct canfd_frame *cf = (struct canfd_frame *)priv->tx_skb->data;
-	struct net_device *dev = priv->net;
-	struct sk_buff *skb = priv->tx_skb;
+	struct canfd_frame *cf = (struct canfd_frame *)cdev->tx_skb->data;
+	struct net_device *dev = cdev->net;
+	struct sk_buff *skb = cdev->tx_skb;
 	u32 id, cccr, fdflags;
 	int i;
 	int putidx;
@@ -1409,23 +1411,23 @@ static netdev_tx_t m_can_tx_handler(struct m_can_priv *priv)
 	if (cf->can_id & CAN_RTR_FLAG)
 		id |= TX_BUF_RTR;
 
-	if (priv->version == 30) {
+	if (cdev->version == 30) {
 		netif_stop_queue(dev);
 
 		/* message ram configuration */
-		m_can_fifo_write(priv, 0, M_CAN_FIFO_ID, id);
-		m_can_fifo_write(priv, 0, M_CAN_FIFO_DLC,
+		m_can_fifo_write(cdev, 0, M_CAN_FIFO_ID, id);
+		m_can_fifo_write(cdev, 0, M_CAN_FIFO_DLC,
 				 can_len2dlc(cf->len) << 16);
 
 		for (i = 0; i < cf->len; i += 4)
-			m_can_fifo_write(priv, 0,
+			m_can_fifo_write(cdev, 0,
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
 		can_put_echo_skb(skb, dev, 0);
 
-		if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
-			cccr = m_can_read(priv, M_CAN_CCCR);
+		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
+			cccr = m_can_read(cdev, M_CAN_CCCR);
 			cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
 			if (can_is_canfd_skb(skb)) {
 				if (cf->flags & CANFD_BRS)
@@ -1437,21 +1439,22 @@ static netdev_tx_t m_can_tx_handler(struct m_can_priv *priv)
 			} else {
 				cccr |= CCCR_CMR_CAN << CCCR_CMR_SHIFT;
 			}
-			m_can_write(priv, M_CAN_CCCR, cccr);
+			m_can_write(cdev, M_CAN_CCCR, cccr);
 		}
-		m_can_write(priv, M_CAN_TXBTIE, 0x1);
-		m_can_write(priv, M_CAN_TXBAR, 0x1);
+		m_can_write(cdev, M_CAN_TXBTIE, 0x1);
+		m_can_write(cdev, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {
 		/* Transmit routine for version >= v3.1.x */
 
 		/* Check if FIFO full */
-		if (m_can_tx_fifo_full(priv)) {
+		if (m_can_tx_fifo_full(cdev)) {
 			/* This shouldn't happen */
 			netif_stop_queue(dev);
 			netdev_warn(dev,
 				    "TX queue active although FIFO is full.");
-			if (priv->is_peripheral) {
+
+			if (cdev->is_peripheral) {
 				kfree_skb(skb);
 				dev->stats.tx_dropped++;
 				return NETDEV_TX_OK;
@@ -1461,10 +1464,10 @@ static netdev_tx_t m_can_tx_handler(struct m_can_priv *priv)
 		}
 
 		/* get put index for frame */
-		putidx = ((m_can_read(priv, M_CAN_TXFQS) & TXFQS_TFQPI_MASK)
+		putidx = ((m_can_read(cdev, M_CAN_TXFQS) & TXFQS_TFQPI_MASK)
 				  >> TXFQS_TFQPI_SHIFT);
 		/* Write ID Field to FIFO Element */
-		m_can_fifo_write(priv, putidx, M_CAN_FIFO_ID, id);
+		m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, id);
 
 		/* get CAN FD configuration of frame */
 		fdflags = 0;
@@ -1479,14 +1482,14 @@ static netdev_tx_t m_can_tx_handler(struct m_can_priv *priv)
 		 * it is used in TX interrupt for
 		 * sending the correct echo frame
 		 */
-		m_can_fifo_write(priv, putidx, M_CAN_FIFO_DLC,
+		m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DLC,
 				 ((putidx << TX_BUF_MM_SHIFT) &
 				  TX_BUF_MM_MASK) |
 				 (can_len2dlc(cf->len) << 16) |
 				 fdflags | TX_BUF_EFC);
 
 		for (i = 0; i < cf->len; i += 4)
-			m_can_fifo_write(priv, putidx, M_CAN_FIFO_DATA(i / 4),
+			m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
 		/* Push loopback echo.
@@ -1495,10 +1498,10 @@ static netdev_tx_t m_can_tx_handler(struct m_can_priv *priv)
 		can_put_echo_skb(skb, dev, putidx);
 
 		/* Enable TX FIFO element to start transfer  */
-		m_can_write(priv, M_CAN_TXBAR, (1 << putidx));
+		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
 
 		/* stop network queue if fifo full */
-		if (m_can_tx_fifo_full(priv) ||
+		if (m_can_tx_fifo_full(cdev) ||
 		    m_can_next_echo_skb_occupied(dev, putidx))
 			netif_stop_queue(dev);
 	}
@@ -1508,27 +1511,28 @@ static netdev_tx_t m_can_tx_handler(struct m_can_priv *priv)
 
 static void m_can_tx_work_queue(struct work_struct *ws)
 {
-	struct m_can_priv *priv = container_of(ws, struct m_can_priv,
+	struct m_can_classdev *cdev = container_of(ws, struct m_can_classdev,
 						tx_work);
-	m_can_tx_handler(priv);
-	priv->tx_skb = NULL;
+
+	m_can_tx_handler(cdev);
+	cdev->tx_skb = NULL;
 }
 
 static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
 
-	if (priv->is_peripheral) {
-		if (priv->tx_skb) {
+	if (cdev->is_peripheral) {
+		if (cdev->tx_skb) {
 			netdev_err(dev, "hard_xmit called while tx busy\n");
 			return NETDEV_TX_BUSY;
 		}
 
-		if (priv->can.state == CAN_STATE_BUS_OFF) {
+		if (cdev->can.state == CAN_STATE_BUS_OFF) {
 			m_can_clean(dev);
 		} else {
 			/* Need to stop the queue to avoid numerous requests
@@ -1536,13 +1540,13 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 			 * a queueing mechanism that will queue the skbs and
 			 * process them in order.
 			 */
-			priv->tx_skb = skb;
-			netif_stop_queue(priv->net);
-			queue_work(priv->tx_wq, &priv->tx_work);
+			cdev->tx_skb = skb;
+			netif_stop_queue(cdev->net);
+			queue_work(cdev->tx_wq, &cdev->tx_work);
 		}
 	} else {
-		priv->tx_skb = skb;
-		return m_can_tx_handler(priv);
+		cdev->tx_skb = skb;
+		return m_can_tx_handler(cdev);
 	}
 
 	return NETDEV_TX_OK;
@@ -1550,10 +1554,10 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 
 static int m_can_open(struct net_device *dev)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
+	struct m_can_classdev *cdev = netdev_priv(dev);
 	int err;
 
-	err = m_can_clk_start(priv);
+	err = m_can_clk_start(cdev);
 	if (err)
 		return err;
 
@@ -1565,16 +1569,16 @@ static int m_can_open(struct net_device *dev)
 	}
 
 	/* register interrupt handler */
-	if (priv->is_peripheral) {
-		priv->tx_skb = NULL;
-		priv->tx_wq = alloc_workqueue("mcan_wq",
+	if (cdev->is_peripheral) {
+		cdev->tx_skb = NULL;
+		cdev->tx_wq = alloc_workqueue("mcan_wq",
 					      WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
-		if (!priv->tx_wq) {
+		if (!cdev->tx_wq) {
 			err = -ENOMEM;
 			goto out_wq_fail;
 		}
 
-		INIT_WORK(&priv->tx_work, m_can_tx_work_queue);
+		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
 
 		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
 					   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
@@ -1594,20 +1598,20 @@ static int m_can_open(struct net_device *dev)
 
 	can_led_event(dev, CAN_LED_EVENT_OPEN);
 
-	if (!priv->is_peripheral)
-		napi_enable(&priv->napi);
+	if (!cdev->is_peripheral)
+		napi_enable(&cdev->napi);
 
 	netif_start_queue(dev);
 
 	return 0;
 
 exit_irq_fail:
-	if (priv->is_peripheral)
-		destroy_workqueue(priv->tx_wq);
+	if (cdev->is_peripheral)
+		destroy_workqueue(cdev->tx_wq);
 out_wq_fail:
 	close_candev(dev);
 exit_disable_clks:
-	m_can_clk_stop(priv);
+	m_can_clk_stop(cdev);
 	return err;
 }
 
@@ -1626,61 +1630,61 @@ static int register_m_can_dev(struct net_device *dev)
 	return register_candev(dev);
 }
 
-static void m_can_of_parse_mram(struct m_can_priv *priv,
+static void m_can_of_parse_mram(struct m_can_classdev *cdev,
 				const u32 *mram_config_vals)
 {
-	priv->mcfg[MRAM_SIDF].off = mram_config_vals[0];
-	priv->mcfg[MRAM_SIDF].num = mram_config_vals[1];
-	priv->mcfg[MRAM_XIDF].off = priv->mcfg[MRAM_SIDF].off +
-			priv->mcfg[MRAM_SIDF].num * SIDF_ELEMENT_SIZE;
-	priv->mcfg[MRAM_XIDF].num = mram_config_vals[2];
-	priv->mcfg[MRAM_RXF0].off = priv->mcfg[MRAM_XIDF].off +
-			priv->mcfg[MRAM_XIDF].num * XIDF_ELEMENT_SIZE;
-	priv->mcfg[MRAM_RXF0].num = mram_config_vals[3] &
+	cdev->mcfg[MRAM_SIDF].off = mram_config_vals[0];
+	cdev->mcfg[MRAM_SIDF].num = mram_config_vals[1];
+	cdev->mcfg[MRAM_XIDF].off = cdev->mcfg[MRAM_SIDF].off +
+			cdev->mcfg[MRAM_SIDF].num * SIDF_ELEMENT_SIZE;
+	cdev->mcfg[MRAM_XIDF].num = mram_config_vals[2];
+	cdev->mcfg[MRAM_RXF0].off = cdev->mcfg[MRAM_XIDF].off +
+			cdev->mcfg[MRAM_XIDF].num * XIDF_ELEMENT_SIZE;
+	cdev->mcfg[MRAM_RXF0].num = mram_config_vals[3] &
 			(RXFC_FS_MASK >> RXFC_FS_SHIFT);
-	priv->mcfg[MRAM_RXF1].off = priv->mcfg[MRAM_RXF0].off +
-			priv->mcfg[MRAM_RXF0].num * RXF0_ELEMENT_SIZE;
-	priv->mcfg[MRAM_RXF1].num = mram_config_vals[4] &
+	cdev->mcfg[MRAM_RXF1].off = cdev->mcfg[MRAM_RXF0].off +
+			cdev->mcfg[MRAM_RXF0].num * RXF0_ELEMENT_SIZE;
+	cdev->mcfg[MRAM_RXF1].num = mram_config_vals[4] &
 			(RXFC_FS_MASK >> RXFC_FS_SHIFT);
-	priv->mcfg[MRAM_RXB].off = priv->mcfg[MRAM_RXF1].off +
-			priv->mcfg[MRAM_RXF1].num * RXF1_ELEMENT_SIZE;
-	priv->mcfg[MRAM_RXB].num = mram_config_vals[5];
-	priv->mcfg[MRAM_TXE].off = priv->mcfg[MRAM_RXB].off +
-			priv->mcfg[MRAM_RXB].num * RXB_ELEMENT_SIZE;
-	priv->mcfg[MRAM_TXE].num = mram_config_vals[6];
-	priv->mcfg[MRAM_TXB].off = priv->mcfg[MRAM_TXE].off +
-			priv->mcfg[MRAM_TXE].num * TXE_ELEMENT_SIZE;
-	priv->mcfg[MRAM_TXB].num = mram_config_vals[7] &
+	cdev->mcfg[MRAM_RXB].off = cdev->mcfg[MRAM_RXF1].off +
+			cdev->mcfg[MRAM_RXF1].num * RXF1_ELEMENT_SIZE;
+	cdev->mcfg[MRAM_RXB].num = mram_config_vals[5];
+	cdev->mcfg[MRAM_TXE].off = cdev->mcfg[MRAM_RXB].off +
+			cdev->mcfg[MRAM_RXB].num * RXB_ELEMENT_SIZE;
+	cdev->mcfg[MRAM_TXE].num = mram_config_vals[6];
+	cdev->mcfg[MRAM_TXB].off = cdev->mcfg[MRAM_TXE].off +
+			cdev->mcfg[MRAM_TXE].num * TXE_ELEMENT_SIZE;
+	cdev->mcfg[MRAM_TXB].num = mram_config_vals[7] &
 			(TXBC_NDTB_MASK >> TXBC_NDTB_SHIFT);
 
-	dev_dbg(priv->dev,
+	dev_dbg(cdev->dev,
 		"sidf 0x%x %d xidf 0x%x %d rxf0 0x%x %d rxf1 0x%x %d rxb 0x%x %d txe 0x%x %d txb 0x%x %d\n",
-		priv->mcfg[MRAM_SIDF].off, priv->mcfg[MRAM_SIDF].num,
-		priv->mcfg[MRAM_XIDF].off, priv->mcfg[MRAM_XIDF].num,
-		priv->mcfg[MRAM_RXF0].off, priv->mcfg[MRAM_RXF0].num,
-		priv->mcfg[MRAM_RXF1].off, priv->mcfg[MRAM_RXF1].num,
-		priv->mcfg[MRAM_RXB].off, priv->mcfg[MRAM_RXB].num,
-		priv->mcfg[MRAM_TXE].off, priv->mcfg[MRAM_TXE].num,
-		priv->mcfg[MRAM_TXB].off, priv->mcfg[MRAM_TXB].num);
+		cdev->mcfg[MRAM_SIDF].off, cdev->mcfg[MRAM_SIDF].num,
+		cdev->mcfg[MRAM_XIDF].off, cdev->mcfg[MRAM_XIDF].num,
+		cdev->mcfg[MRAM_RXF0].off, cdev->mcfg[MRAM_RXF0].num,
+		cdev->mcfg[MRAM_RXF1].off, cdev->mcfg[MRAM_RXF1].num,
+		cdev->mcfg[MRAM_RXB].off, cdev->mcfg[MRAM_RXB].num,
+		cdev->mcfg[MRAM_TXE].off, cdev->mcfg[MRAM_TXE].num,
+		cdev->mcfg[MRAM_TXB].off, cdev->mcfg[MRAM_TXB].num);
 }
 
-void m_can_init_ram(struct m_can_priv *priv)
+void m_can_init_ram(struct m_can_classdev *cdev)
 {
 	int end, i, start;
 
 	/* initialize the entire Message RAM in use to avoid possible
 	 * ECC/parity checksum errors when reading an uninitialized buffer
 	 */
-	start = priv->mcfg[MRAM_SIDF].off;
-	end = priv->mcfg[MRAM_TXB].off +
-		priv->mcfg[MRAM_TXB].num * TXB_ELEMENT_SIZE;
+	start = cdev->mcfg[MRAM_SIDF].off;
+	end = cdev->mcfg[MRAM_TXB].off +
+		cdev->mcfg[MRAM_TXB].num * TXB_ELEMENT_SIZE;
 
 	for (i = start; i < end; i += 4)
-		m_can_fifo_write_no_off(priv, i, 0x0);
+		m_can_fifo_write_no_off(cdev, i, 0x0);
 }
 EXPORT_SYMBOL_GPL(m_can_init_ram);
 
-int m_can_class_get_clocks(struct m_can_priv *m_can_dev)
+int m_can_class_get_clocks(struct m_can_classdev *m_can_dev)
 {
 	int ret = 0;
 
@@ -1696,9 +1700,9 @@ int m_can_class_get_clocks(struct m_can_priv *m_can_dev)
 }
 EXPORT_SYMBOL_GPL(m_can_class_get_clocks);
 
-struct m_can_priv *m_can_class_allocate_dev(struct device *dev)
+struct m_can_classdev *m_can_class_allocate_dev(struct device *dev)
 {
-	struct m_can_priv *class_dev = NULL;
+	struct m_can_classdev *class_dev = NULL;
 	u32 mram_config_vals[MRAM_CFG_LEN];
 	struct net_device *net_dev;
 	u32 tx_fifo_size;
@@ -1727,7 +1731,7 @@ struct m_can_priv *m_can_class_allocate_dev(struct device *dev)
 
 	class_dev = netdev_priv(net_dev);
 	if (!class_dev) {
-		dev_err(dev, "Failed to init netdev private");
+		dev_err(dev, "Failed to init netdev cdevate");
 		goto out;
 	}
 
@@ -1741,7 +1745,7 @@ struct m_can_priv *m_can_class_allocate_dev(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(m_can_class_allocate_dev);
 
-int m_can_class_register(struct m_can_priv *m_can_dev)
+int m_can_class_register(struct m_can_classdev *m_can_dev)
 {
 	int ret;
 
@@ -1789,18 +1793,18 @@ EXPORT_SYMBOL_GPL(m_can_class_register);
 int m_can_class_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *priv = netdev_priv(ndev);
+	struct m_can_classdev *cdev = netdev_priv(ndev);
 
 	if (netif_running(ndev)) {
 		netif_stop_queue(ndev);
 		netif_device_detach(ndev);
 		m_can_stop(ndev);
-		m_can_clk_stop(priv);
+		m_can_clk_stop(cdev);
 	}
 
 	pinctrl_pm_select_sleep_state(dev);
 
-	priv->can.state = CAN_STATE_SLEEPING;
+	cdev->can.state = CAN_STATE_SLEEPING;
 
 	return 0;
 }
@@ -1809,20 +1813,20 @@ EXPORT_SYMBOL_GPL(m_can_class_suspend);
 int m_can_class_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *priv = netdev_priv(ndev);
+	struct m_can_classdev *cdev = netdev_priv(ndev);
 
 	pinctrl_pm_select_default_state(dev);
 
-	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	if (netif_running(ndev)) {
 		int ret;
 
-		ret = m_can_clk_start(priv);
+		ret = m_can_clk_start(cdev);
 		if (ret)
 			return ret;
 
-		m_can_init_ram(priv);
+		m_can_init_ram(cdev);
 		m_can_start(ndev);
 		netif_device_attach(ndev);
 		netif_start_queue(ndev);
@@ -1832,7 +1836,7 @@ int m_can_class_resume(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(m_can_class_resume);
 
-void m_can_class_unregister(struct m_can_priv *m_can_dev)
+void m_can_class_unregister(struct m_can_classdev *m_can_dev)
 {
 	unregister_candev(m_can_dev->net);
 
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 5671f5423887..49f42b50627a 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -57,19 +57,19 @@ struct mram_cfg {
 	u8  num;
 };
 
-struct m_can_priv;
+struct m_can_classdev;
 struct m_can_ops {
 	/* Device specific call backs */
-	int (*clear_interrupts)(struct m_can_priv *m_can_class);
-	u32 (*read_reg)(struct m_can_priv *m_can_class, int reg);
-	int (*write_reg)(struct m_can_priv *m_can_class, int reg, int val);
-	u32 (*read_fifo)(struct m_can_priv *m_can_class, int addr_offset);
-	int (*write_fifo)(struct m_can_priv *m_can_class, int addr_offset,
+	int (*clear_interrupts)(struct m_can_classdev *cdev);
+	u32 (*read_reg)(struct m_can_classdev *cdev, int reg);
+	int (*write_reg)(struct m_can_classdev *cdev, int reg, int val);
+	u32 (*read_fifo)(struct m_can_classdev *cdev, int addr_offset);
+	int (*write_fifo)(struct m_can_classdev *cdev, int addr_offset,
 			  int val);
-	int (*init)(struct m_can_priv *m_can_class);
+	int (*init)(struct m_can_classdev *cdev);
 };
 
-struct m_can_priv {
+struct m_can_classdev {
 	struct can_priv can;
 	struct napi_struct napi;
 	struct net_device *net;
@@ -98,12 +98,12 @@ struct m_can_priv {
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
 
-struct m_can_priv *m_can_class_allocate_dev(struct device *dev);
-int m_can_class_register(struct m_can_priv *m_can_dev);
-void m_can_class_unregister(struct m_can_priv *m_can_dev);
-int m_can_class_get_clocks(struct m_can_priv *m_can_dev);
-void m_can_init_ram(struct m_can_priv *priv);
-void m_can_config_endisable(struct m_can_priv *priv, bool enable);
+struct m_can_classdev *m_can_class_allocate_dev(struct device *dev);
+int m_can_class_register(struct m_can_classdev *cdev);
+void m_can_class_unregister(struct m_can_classdev *cdev);
+int m_can_class_get_clocks(struct m_can_classdev *cdev);
+void m_can_init_ram(struct m_can_classdev *priv);
+void m_can_config_endisable(struct m_can_classdev *priv, bool enable);
 
 int m_can_class_suspend(struct device *dev);
 int m_can_class_resume(struct device *dev);
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 026053f62f77..c2989e0431f2 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -14,7 +14,7 @@ struct m_can_plat_priv {
 	void __iomem *mram_base;
 };
 
-static u32 iomap_read_reg(struct m_can_priv *cdev, int reg)
+static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
 {
 	struct m_can_plat_priv *priv =
 			(struct m_can_plat_priv *)cdev->device_data;
@@ -22,7 +22,7 @@ static u32 iomap_read_reg(struct m_can_priv *cdev, int reg)
 	return readl(priv->base + reg);
 }
 
-static u32 iomap_read_fifo(struct m_can_priv *cdev, int offset)
+static u32 iomap_read_fifo(struct m_can_classdev *cdev, int offset)
 {
 	struct m_can_plat_priv *priv =
 			(struct m_can_plat_priv *)cdev->device_data;
@@ -30,7 +30,7 @@ static u32 iomap_read_fifo(struct m_can_priv *cdev, int offset)
 	return readl(priv->mram_base + offset);
 }
 
-static int iomap_write_reg(struct m_can_priv *cdev, int reg, int val)
+static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
 {
 	struct m_can_plat_priv *priv =
 			(struct m_can_plat_priv *)cdev->device_data;
@@ -40,7 +40,7 @@ static int iomap_write_reg(struct m_can_priv *cdev, int reg, int val)
 	return 0;
 }
 
-static int iomap_write_fifo(struct m_can_priv *cdev, int offset, int val)
+static int iomap_write_fifo(struct m_can_classdev *cdev, int offset, int val)
 {
 	struct m_can_plat_priv *priv =
 			(struct m_can_plat_priv *)cdev->device_data;
@@ -59,7 +59,7 @@ static struct m_can_ops m_can_plat_ops = {
 
 static int m_can_plat_probe(struct platform_device *pdev)
 {
-	struct m_can_priv *mcan_class;
+	struct m_can_classdev *mcan_class;
 	struct m_can_plat_priv *priv;
 	struct resource *res;
 	void __iomem *addr;
@@ -131,7 +131,7 @@ static __maybe_unused int m_can_resume(struct device *dev)
 static int m_can_plat_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
-	struct m_can_priv *mcan_class = netdev_priv(dev);
+	struct m_can_classdev *mcan_class = netdev_priv(dev);
 
 	m_can_class_unregister(mcan_class);
 
@@ -143,7 +143,7 @@ static int m_can_plat_remove(struct platform_device *pdev)
 static int __maybe_unused m_can_runtime_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *mcan_class = netdev_priv(ndev);
+	struct m_can_classdev *mcan_class = netdev_priv(ndev);
 
 	m_can_class_suspend(dev);
 
@@ -156,7 +156,7 @@ static int __maybe_unused m_can_runtime_suspend(struct device *dev)
 static int __maybe_unused m_can_runtime_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *mcan_class = netdev_priv(ndev);
+	struct m_can_classdev *mcan_class = netdev_priv(ndev);
 	int err;
 
 	err = clk_prepare_enable(mcan_class->hclk);
-- 
2.21.0.5.gaeb582a983

