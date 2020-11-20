Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D7E2BAB5C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgKTNeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgKTNd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:26 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5145BC0617A7
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XT-0006Fn-6d; Fri, 20 Nov 2020 14:33:23 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 05/25] can: replace can_dlc as variable/element for payload length
Date:   Fri, 20 Nov 2020 14:32:58 +0100
Message-Id: <20201120133318.3428231-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

The naming of can_dlc as element of struct can_frame and also as variable
name is misleading as it claims to be a 'data length CODE' but in reality
it always was a plain data length.

With the indroduction of a new 'len' element in struct can_frame we can now
remove can_dlc as name and make clear which of the former uses was a plain
length (-> 'len') or a data length code (-> 'dlc') value.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201120100444.3199-1-socketcan@hartkopp.net
[mkl: gs_usb: keep struct gs_host_frame::can_dlc as is]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c                    | 14 ++++----
 drivers/net/can/c_can/c_can.c                 | 20 ++++++------
 drivers/net/can/cc770/cc770.c                 | 14 ++++----
 drivers/net/can/dev.c                         | 10 +++---
 drivers/net/can/grcan.c                       | 10 +++---
 drivers/net/can/ifi_canfd/ifi_canfd.c         |  4 +--
 drivers/net/can/janz-ican3.c                  | 20 ++++++------
 drivers/net/can/kvaser_pciefd.c               |  4 +--
 drivers/net/can/m_can/m_can.c                 |  4 +--
 drivers/net/can/mscan/mscan.c                 | 20 ++++++------
 drivers/net/can/pch_can.c                     | 12 +++----
 drivers/net/can/peak_canfd/peak_canfd.c       | 12 +++----
 drivers/net/can/rcar/rcar_can.c               | 14 ++++----
 drivers/net/can/rcar/rcar_canfd.c             |  4 +--
 drivers/net/can/rx-offload.c                  |  2 +-
 drivers/net/can/sja1000/sja1000.c             | 10 +++---
 drivers/net/can/slcan.c                       | 32 +++++++++----------
 drivers/net/can/softing/softing_fw.c          |  2 +-
 drivers/net/can/softing/softing_main.c        | 14 ++++----
 drivers/net/can/spi/hi311x.c                  | 20 ++++++------
 drivers/net/can/spi/mcp251x.c                 | 18 +++++------
 drivers/net/can/sun4i_can.c                   | 10 +++---
 drivers/net/can/ti_hecc.c                     |  8 ++---
 drivers/net/can/usb/ems_usb.c                 | 16 +++++-----
 drivers/net/can/usb/esd_usb2.c                | 16 +++++-----
 drivers/net/can/usb/gs_usb.c                  |  8 ++---
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  |  2 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 16 +++++-----
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 22 ++++++-------
 drivers/net/can/usb/mcba_usb.c                | 10 +++---
 drivers/net/can/usb/peak_usb/pcan_usb.c       | 14 ++++----
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c    | 10 +++---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c   | 14 ++++----
 drivers/net/can/usb/ucan.c                    | 14 ++++----
 drivers/net/can/usb/usb_8dev.c                | 14 ++++----
 drivers/net/can/xilinx_can.c                  | 10 +++---
 include/linux/can/dev.h                       |  4 +--
 net/can/af_can.c                              |  2 +-
 net/can/gw.c                                  |  2 +-
 net/can/j1939/main.c                          |  4 +--
 40 files changed, 228 insertions(+), 228 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index db06254f8eb7..5284f0ab3b06 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -468,7 +468,7 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 	reg_mid = at91_can_id_to_reg_mid(cf->can_id);
 	reg_mcr = ((cf->can_id & CAN_RTR_FLAG) ? AT91_MCR_MRTR : 0) |
-		(cf->can_dlc << 16) | AT91_MCR_MTCR;
+		(cf->len << 16) | AT91_MCR_MTCR;
 
 	/* disable MB while writing ID (see datasheet) */
 	set_mb_mode(priv, mb, AT91_MB_MODE_DISABLED);
@@ -481,7 +481,7 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* This triggers transmission */
 	at91_write(priv, AT91_MCR(mb), reg_mcr);
 
-	stats->tx_bytes += cf->can_dlc;
+	stats->tx_bytes += cf->len;
 
 	/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
 	can_put_echo_skb(skb, dev, mb - get_mb_tx_first(priv));
@@ -554,7 +554,7 @@ static void at91_rx_overflow_err(struct net_device *dev)
 	cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 }
 
@@ -580,7 +580,7 @@ static void at91_read_mb(struct net_device *dev, unsigned int mb,
 		cf->can_id = (reg_mid >> 18) & CAN_SFF_MASK;
 
 	reg_msr = at91_read(priv, AT91_MSR(mb));
-	cf->can_dlc = can_cc_dlc2len((reg_msr >> 16) & 0xf);
+	cf->len = can_cc_dlc2len((reg_msr >> 16) & 0xf);
 
 	if (reg_msr & AT91_MSR_MRTR)
 		cf->can_id |= CAN_RTR_FLAG;
@@ -619,7 +619,7 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
 	at91_read_mb(dev, mb, cf);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
@@ -780,7 +780,7 @@ static int at91_poll_err(struct net_device *dev, int quota, u32 reg_sr)
 	at91_poll_err_frame(dev, cf, reg_sr);
 
 	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += cf->can_dlc;
+	dev->stats.rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
@@ -1047,7 +1047,7 @@ static void at91_irq_err(struct net_device *dev)
 	at91_irq_err_state(dev, cf, new_state);
 
 	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += cf->can_dlc;
+	dev->stats.rx_bytes += cf->len;
 	netif_rx(skb);
 
 	priv->can.state = new_state;
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 56cc705959ea..0420f09f2b70 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -306,7 +306,7 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
 				  struct can_frame *frame, int idx)
 {
 	struct c_can_priv *priv = netdev_priv(dev);
-	u16 ctrl = IF_MCONT_TX | frame->can_dlc;
+	u16 ctrl = IF_MCONT_TX | frame->len;
 	bool rtr = frame->can_id & CAN_RTR_FLAG;
 	u32 arb = IF_ARB_MSGVAL;
 	int i;
@@ -339,7 +339,7 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
 	if (priv->type == BOSCH_D_CAN) {
 		u32 data = 0, dreg = C_CAN_IFACE(DATA1_REG, iface);
 
-		for (i = 0; i < frame->can_dlc; i += 4, dreg += 2) {
+		for (i = 0; i < frame->len; i += 4, dreg += 2) {
 			data = (u32)frame->data[i];
 			data |= (u32)frame->data[i + 1] << 8;
 			data |= (u32)frame->data[i + 2] << 16;
@@ -347,7 +347,7 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
 			priv->write_reg32(priv, dreg, data);
 		}
 	} else {
-		for (i = 0; i < frame->can_dlc; i += 2) {
+		for (i = 0; i < frame->len; i += 2) {
 			priv->write_reg(priv,
 					C_CAN_IFACE(DATA1_REG, iface) + i / 2,
 					frame->data[i] |
@@ -397,7 +397,7 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 		return -ENOMEM;
 	}
 
-	frame->can_dlc = can_cc_dlc2len(ctrl & 0x0F);
+	frame->len = can_cc_dlc2len(ctrl & 0x0F);
 
 	arb = priv->read_reg32(priv, C_CAN_IFACE(ARB1_REG, iface));
 
@@ -412,7 +412,7 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 		int i, dreg = C_CAN_IFACE(DATA1_REG, iface);
 
 		if (priv->type == BOSCH_D_CAN) {
-			for (i = 0; i < frame->can_dlc; i += 4, dreg += 2) {
+			for (i = 0; i < frame->len; i += 4, dreg += 2) {
 				data = priv->read_reg32(priv, dreg);
 				frame->data[i] = data;
 				frame->data[i + 1] = data >> 8;
@@ -420,7 +420,7 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 				frame->data[i + 3] = data >> 24;
 			}
 		} else {
-			for (i = 0; i < frame->can_dlc; i += 2, dreg++) {
+			for (i = 0; i < frame->len; i += 2, dreg++) {
 				data = priv->read_reg(priv, dreg);
 				frame->data[i] = data;
 				frame->data[i + 1] = data >> 8;
@@ -429,7 +429,7 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += frame->can_dlc;
+	stats->rx_bytes += frame->len;
 
 	netif_receive_skb(skb);
 	return 0;
@@ -475,7 +475,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	 * transmit as we might race against do_tx().
 	 */
 	c_can_setup_tx_object(dev, IF_TX, frame, idx);
-	priv->dlc[idx] = frame->can_dlc;
+	priv->dlc[idx] = frame->len;
 	can_put_echo_skb(skb, dev, idx);
 
 	/* Update the active bits */
@@ -977,7 +977,7 @@ static int c_can_handle_state_change(struct net_device *dev,
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
@@ -1047,7 +1047,7 @@ static int c_can_handle_bus_err(struct net_device *dev,
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 	return 1;
 }
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index 3fd2a276dd93..8d9f332c35e0 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -390,7 +390,7 @@ static void cc770_tx(struct net_device *dev, int mo)
 	u32 id;
 	int i;
 
-	dlc = cf->can_dlc;
+	dlc = cf->len;
 	id = cf->can_id;
 	rtr = cf->can_id & CAN_RTR_FLAG ? 0 : MSGCFG_DIR;
 
@@ -470,7 +470,7 @@ static void cc770_rx(struct net_device *dev, unsigned int mo, u8 ctrl1)
 		cf->can_id = CAN_RTR_FLAG;
 		if (config & MSGCFG_XTD)
 			cf->can_id |= CAN_EFF_FLAG;
-		cf->can_dlc = 0;
+		cf->len = 0;
 	} else {
 		if (config & MSGCFG_XTD) {
 			id = cc770_read_reg(priv, msgobj[mo].id[3]);
@@ -486,13 +486,13 @@ static void cc770_rx(struct net_device *dev, unsigned int mo, u8 ctrl1)
 		}
 
 		cf->can_id = id;
-		cf->can_dlc = can_cc_dlc2len((config & 0xf0) >> 4);
-		for (i = 0; i < cf->can_dlc; i++)
+		cf->len = can_cc_dlc2len((config & 0xf0) >> 4);
+		for (i = 0; i < cf->len; i++)
 			cf->data[i] = cc770_read_reg(priv, msgobj[mo].data[i]);
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -572,7 +572,7 @@ static int cc770_err(struct net_device *dev, u8 status)
 
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	return 0;
@@ -699,7 +699,7 @@ static void cc770_tx_interrupt(struct net_device *dev, unsigned int o)
 	}
 
 	cf = (struct can_frame *)priv->tx_skb->data;
-	stats->tx_bytes += cf->can_dlc;
+	stats->tx_bytes += cf->len;
 	stats->tx_packets++;
 
 	can_put_echo_skb(priv->tx_skb, dev, 0);
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 81e39d7507d8..806e8b646b12 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -30,10 +30,10 @@ MODULE_AUTHOR("Wolfgang Grandegger <wg@grandegger.com>");
 static const u8 dlc2len[] = {0, 1, 2, 3, 4, 5, 6, 7,
 			     8, 12, 16, 20, 24, 32, 48, 64};
 
-/* get data length from can_dlc with sanitized can_dlc */
-u8 can_dlc2len(u8 can_dlc)
+/* get data length from raw data length code (DLC) */
+u8 can_dlc2len(u8 dlc)
 {
-	return dlc2len[can_dlc & 0x0F];
+	return dlc2len[dlc & 0x0F];
 }
 EXPORT_SYMBOL_GPL(can_dlc2len);
 
@@ -595,7 +595,7 @@ static void can_restart(struct net_device *dev)
 	netif_rx_ni(skb);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 
 restart:
 	netdev_dbg(dev, "restarted\n");
@@ -737,7 +737,7 @@ struct sk_buff *alloc_can_err_skb(struct net_device *dev, struct can_frame **cf)
 		return NULL;
 
 	(*cf)->can_id = CAN_ERR_FLAG;
-	(*cf)->can_dlc = CAN_ERR_DLC;
+	(*cf)->len = CAN_ERR_DLC;
 
 	return skb;
 }
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index c71c9b8683d5..f5d94a692576 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1201,12 +1201,12 @@ static int grcan_receive(struct net_device *dev, int budget)
 			cf->can_id = ((slot[0] & GRCAN_MSG_BID)
 				      >> GRCAN_MSG_BID_BIT);
 		}
-		cf->can_dlc = can_cc_dlc2len((slot[1] & GRCAN_MSG_DLC)
+		cf->len = can_cc_dlc2len((slot[1] & GRCAN_MSG_DLC)
 					  >> GRCAN_MSG_DLC_BIT);
 		if (rtr) {
 			cf->can_id |= CAN_RTR_FLAG;
 		} else {
-			for (i = 0; i < cf->can_dlc; i++) {
+			for (i = 0; i < cf->len; i++) {
 				j = GRCAN_MSG_DATA_SLOT_INDEX(i);
 				shift = GRCAN_MSG_DATA_SHIFT(i);
 				cf->data[i] = (u8)(slot[j] >> shift);
@@ -1215,7 +1215,7 @@ static int grcan_receive(struct net_device *dev, int budget)
 
 		/* Update statistics and read pointer */
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_receive_skb(skb);
 
 		rd = grcan_ring_add(rd, GRCAN_MSG_SIZE, dma->rx.size);
@@ -1399,7 +1399,7 @@ static netdev_tx_t grcan_start_xmit(struct sk_buff *skb,
 	eff = cf->can_id & CAN_EFF_FLAG;
 	rtr = cf->can_id & CAN_RTR_FLAG;
 	id = cf->can_id & (eff ? CAN_EFF_MASK : CAN_SFF_MASK);
-	dlc = cf->can_dlc;
+	dlc = cf->len;
 	if (eff)
 		tmp = (id << GRCAN_MSG_EID_BIT) & GRCAN_MSG_EID;
 	else
@@ -1447,7 +1447,7 @@ static netdev_tx_t grcan_start_xmit(struct sk_buff *skb,
 	 * can_put_echo_skb would be an error unless other measures are
 	 * taken.
 	 */
-	priv->txdlc[slotindex] = cf->can_dlc; /* Store dlc for statistics */
+	priv->txdlc[slotindex] = cf->len; /* Store dlc for statistics */
 	can_put_echo_skb(skb, dev, slotindex);
 
 	/* Make sure everything is written before allowing hardware to
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index cc790354a8ee..3df55b0e4ef3 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -431,7 +431,7 @@ static int ifi_canfd_handle_lec_err(struct net_device *ndev)
 	writel(IFI_CANFD_ERROR_CTR_ER_ENABLE, priv->base + IFI_CANFD_ERROR_CTR);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
@@ -523,7 +523,7 @@ static int ifi_canfd_handle_state_change(struct net_device *ndev,
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 6a21af05ba27..2a6c918186c0 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -916,10 +916,10 @@ static void ican3_to_can_frame(struct ican3_dev *mod,
 
 		cf->can_id |= desc->data[0] << 3;
 		cf->can_id |= (desc->data[1] & 0xe0) >> 5;
-		cf->can_dlc = can_cc_dlc2len(desc->data[1] & ICAN3_CAN_DLC_MASK);
-		memcpy(cf->data, &desc->data[2], cf->can_dlc);
+		cf->len = can_cc_dlc2len(desc->data[1] & ICAN3_CAN_DLC_MASK);
+		memcpy(cf->data, &desc->data[2], cf->len);
 	} else {
-		cf->can_dlc = can_cc_dlc2len(desc->data[0] & ICAN3_CAN_DLC_MASK);
+		cf->len = can_cc_dlc2len(desc->data[0] & ICAN3_CAN_DLC_MASK);
 		if (desc->data[0] & ICAN3_EFF_RTR)
 			cf->can_id |= CAN_RTR_FLAG;
 
@@ -934,7 +934,7 @@ static void ican3_to_can_frame(struct ican3_dev *mod,
 			cf->can_id |= desc->data[3] >> 5;  /* 2-0   */
 		}
 
-		memcpy(cf->data, &desc->data[6], cf->can_dlc);
+		memcpy(cf->data, &desc->data[6], cf->len);
 	}
 }
 
@@ -947,7 +947,7 @@ static void can_frame_to_ican3(struct ican3_dev *mod,
 
 	/* we always use the extended format, with the ECHO flag set */
 	desc->command = ICAN3_CAN_TYPE_EFF;
-	desc->data[0] |= cf->can_dlc;
+	desc->data[0] |= cf->len;
 	desc->data[1] |= ICAN3_ECHO;
 
 	/* support single transmission (no retries) mode */
@@ -970,7 +970,7 @@ static void can_frame_to_ican3(struct ican3_dev *mod,
 	}
 
 	/* copy the data bits into the descriptor */
-	memcpy(&desc->data[6], cf->data, cf->can_dlc);
+	memcpy(&desc->data[6], cf->data, cf->len);
 }
 
 /*
@@ -1294,7 +1294,7 @@ static unsigned int ican3_get_echo_skb(struct ican3_dev *mod)
 	}
 
 	cf = (struct can_frame *)skb->data;
-	dlc = cf->can_dlc;
+	dlc = cf->len;
 
 	/* check flag whether this packet has to be looped back */
 	if (skb->pkt_type != PACKET_LOOPBACK) {
@@ -1332,10 +1332,10 @@ static bool ican3_echo_skb_matches(struct ican3_dev *mod, struct sk_buff *skb)
 	if (cf->can_id != echo_cf->can_id)
 		return false;
 
-	if (cf->can_dlc != echo_cf->can_dlc)
+	if (cf->len != echo_cf->len)
 		return false;
 
-	return memcmp(cf->data, echo_cf->data, cf->can_dlc) == 0;
+	return memcmp(cf->data, echo_cf->data, cf->len) == 0;
 }
 
 /*
@@ -1421,7 +1421,7 @@ static int ican3_recv_skb(struct ican3_dev *mod)
 
 	/* update statistics, receive the skb */
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 err_noalloc:
diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 72acd1ba162d..de268a344fcf 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1299,7 +1299,7 @@ static int kvaser_pciefd_rx_error_frame(struct kvaser_pciefd_can *can,
 	cf->data[7] = bec.rxerr;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 
 	netif_rx(skb);
 	return 0;
@@ -1498,7 +1498,7 @@ static void kvaser_pciefd_handle_nack_packet(struct kvaser_pciefd_can *can,
 
 	if (skb) {
 		cf->can_id |= CAN_ERR_BUSERROR;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		stats->rx_packets++;
 		netif_rx(skb);
 	} else {
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2e46a5916656..b7df90ceee4b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -596,7 +596,7 @@ static int m_can_handle_lec_err(struct net_device *dev,
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
@@ -723,7 +723,7 @@ static int m_can_handle_state_change(struct net_device *dev,
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 95bf7338b358..5ed00a1558e1 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -250,16 +250,16 @@ static netdev_tx_t mscan_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		void __iomem *data = &regs->tx.dsr1_0;
 		u16 *payload = (u16 *)frame->data;
 
-		for (i = 0; i < frame->can_dlc / 2; i++) {
+		for (i = 0; i < frame->len / 2; i++) {
 			out_be16(data, *payload++);
 			data += 2 + _MSCAN_RESERVED_DSR_SIZE;
 		}
 		/* write remaining byte if necessary */
-		if (frame->can_dlc & 1)
-			out_8(data, frame->data[frame->can_dlc - 1]);
+		if (frame->len & 1)
+			out_8(data, frame->data[frame->len - 1]);
 	}
 
-	out_8(&regs->tx.dlr, frame->can_dlc);
+	out_8(&regs->tx.dlr, frame->len);
 	out_8(&regs->tx.tbpr, priv->cur_pri);
 
 	/* Start transmission. */
@@ -312,19 +312,19 @@ static void mscan_get_rx_frame(struct net_device *dev, struct can_frame *frame)
 	if (can_id & 1)
 		frame->can_id |= CAN_RTR_FLAG;
 
-	frame->can_dlc = can_cc_dlc2len(in_8(&regs->rx.dlr) & 0xf);
+	frame->len = can_cc_dlc2len(in_8(&regs->rx.dlr) & 0xf);
 
 	if (!(frame->can_id & CAN_RTR_FLAG)) {
 		void __iomem *data = &regs->rx.dsr1_0;
 		u16 *payload = (u16 *)frame->data;
 
-		for (i = 0; i < frame->can_dlc / 2; i++) {
+		for (i = 0; i < frame->len / 2; i++) {
 			*payload++ = in_be16(data);
 			data += 2 + _MSCAN_RESERVED_DSR_SIZE;
 		}
 		/* read remaining byte if necessary */
-		if (frame->can_dlc & 1)
-			frame->data[frame->can_dlc - 1] = in_8(data);
+		if (frame->len & 1)
+			frame->data[frame->len - 1] = in_8(data);
 	}
 
 	out_8(&regs->canrflg, MSCAN_RXF);
@@ -372,7 +372,7 @@ static void mscan_get_err_frame(struct net_device *dev, struct can_frame *frame,
 		}
 	}
 	priv->shadow_statflg = canrflg & MSCAN_STAT_MSK;
-	frame->can_dlc = CAN_ERR_DLC;
+	frame->len = CAN_ERR_DLC;
 	out_8(&regs->canrflg, MSCAN_ERR_IF);
 }
 
@@ -407,7 +407,7 @@ static int mscan_rx_poll(struct napi_struct *napi, int quota)
 			mscan_get_err_frame(dev, frame, canrflg);
 
 		stats->rx_packets++;
-		stats->rx_bytes += frame->can_dlc;
+		stats->rx_bytes += frame->len;
 		work_done++;
 		netif_receive_skb(skb);
 	}
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 9509bac8352d..4f9e7ec192aa 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -563,7 +563,7 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 	netif_receive_skb(skb);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 }
 
 static irqreturn_t pch_can_interrupt(int irq, void *dev_id)
@@ -683,10 +683,10 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 		if (id2 & PCH_ID2_DIR)
 			cf->can_id |= CAN_RTR_FLAG;
 
-		cf->can_dlc = can_cc_dlc2len((ioread32(&priv->regs->
+		cf->len = can_cc_dlc2len((ioread32(&priv->regs->
 						    ifregs[0].mcont)) & 0xF);
 
-		for (i = 0; i < cf->can_dlc; i += 2) {
+		for (i = 0; i < cf->len; i += 2) {
 			data_reg = ioread16(&priv->regs->ifregs[0].data[i / 2]);
 			cf->data[i] = data_reg;
 			cf->data[i + 1] = data_reg >> 8;
@@ -696,7 +696,7 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 		rcv_pkts++;
 		stats->rx_packets++;
 		quota--;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 
 		pch_fifo_thresh(priv, obj_num);
 		obj_num++;
@@ -919,7 +919,7 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 	iowrite32(id2, &priv->regs->ifregs[1].id2);
 
 	/* Copy data to register */
-	for (i = 0; i < cf->can_dlc; i += 2) {
+	for (i = 0; i < cf->len; i += 2) {
 		iowrite16(cf->data[i] | (cf->data[i + 1] << 8),
 			  &priv->regs->ifregs[1].data[i / 2]);
 	}
@@ -927,7 +927,7 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 	can_put_echo_skb(skb, ndev, tx_obj_no - PCH_RX_OBJ_END - 1);
 
 	/* Set the size of the data. Update if2_mcont */
-	iowrite32(cf->can_dlc | PCH_IF_MCONT_NEWDAT | PCH_IF_MCONT_TXRQXT |
+	iowrite32(cf->len | PCH_IF_MCONT_NEWDAT | PCH_IF_MCONT_TXRQXT |
 		  PCH_IF_MCONT_TXIE, &priv->regs->ifregs[1].mcont);
 
 	pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, tx_obj_no);
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index c6077e07214e..fff3a35276aa 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -410,7 +410,7 @@ static int pucan_handle_status(struct peak_canfd_priv *priv,
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	pucan_netif_rx(skb, msg->ts_low, msg->ts_high);
 
 	return 0;
@@ -438,7 +438,7 @@ static int pucan_handle_cache_critical(struct peak_canfd_priv *priv)
 	cf->data[6] = priv->bec.txerr;
 	cf->data[7] = priv->bec.rxerr;
 
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	stats->rx_packets++;
 	netif_rx(skb);
 
@@ -652,7 +652,7 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 	unsigned long flags;
 	bool should_stop_tx_queue;
 	int room_left;
-	u8 can_dlc;
+	u8 len;
 
 	if (can_dropped_invalid_skb(ndev, skb))
 		return NETDEV_TX_OK;
@@ -682,7 +682,7 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 
 	if (can_is_canfd_skb(skb)) {
 		/* CAN FD frame format */
-		can_dlc = can_len2dlc(cf->len);
+		len = can_len2dlc(cf->len);
 
 		msg_flags |= PUCAN_MSG_EXT_DATA_LEN;
 
@@ -693,7 +693,7 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 			msg_flags |= PUCAN_MSG_ERROR_STATE_IND;
 	} else {
 		/* CAN 2.0 frame format */
-		can_dlc = cf->len;
+		len = cf->len;
 
 		if (cf->can_id & CAN_RTR_FLAG)
 			msg_flags |= PUCAN_MSG_RTR;
@@ -707,7 +707,7 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 		msg_flags |= PUCAN_MSG_SELF_RECEIVE;
 
 	msg->flags = cpu_to_le16(msg_flags);
-	msg->channel_dlc = PUCAN_MSG_CHANNEL_DLC(priv->index, can_dlc);
+	msg->channel_dlc = PUCAN_MSG_CHANNEL_DLC(priv->index, len);
 	memcpy(msg->d, cf->data, cf->len);
 
 	/* struct msg client field is used as an index in the echo skbs ring */
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 711ef4996b48..c803327f8f79 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -364,7 +364,7 @@ static void rcar_can_error(struct net_device *ndev)
 
 	if (skb) {
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	}
 }
@@ -607,16 +607,16 @@ static netdev_tx_t rcar_can_start_xmit(struct sk_buff *skb,
 	if (cf->can_id & CAN_RTR_FLAG) { /* Remote transmission request */
 		data |= RCAR_CAN_RTR;
 	} else {
-		for (i = 0; i < cf->can_dlc; i++)
+		for (i = 0; i < cf->len; i++)
 			writeb(cf->data[i],
 			       &priv->regs->mb[RCAR_CAN_TX_FIFO_MBX].data[i]);
 	}
 
 	writel(data, &priv->regs->mb[RCAR_CAN_TX_FIFO_MBX].id);
 
-	writeb(cf->can_dlc, &priv->regs->mb[RCAR_CAN_TX_FIFO_MBX].dlc);
+	writeb(cf->len, &priv->regs->mb[RCAR_CAN_TX_FIFO_MBX].dlc);
 
-	priv->tx_dlc[priv->tx_head % RCAR_CAN_FIFO_DEPTH] = cf->can_dlc;
+	priv->tx_dlc[priv->tx_head % RCAR_CAN_FIFO_DEPTH] = cf->len;
 	can_put_echo_skb(skb, ndev, priv->tx_head % RCAR_CAN_FIFO_DEPTH);
 	priv->tx_head++;
 	/* Start Tx: write 0xff to the TFPCR register to increment
@@ -659,18 +659,18 @@ static void rcar_can_rx_pkt(struct rcar_can_priv *priv)
 		cf->can_id = (data >> RCAR_CAN_SID_SHIFT) & CAN_SFF_MASK;
 
 	dlc = readb(&priv->regs->mb[RCAR_CAN_RX_FIFO_MBX].dlc);
-	cf->can_dlc = can_cc_dlc2len(dlc);
+	cf->len = can_cc_dlc2len(dlc);
 	if (data & RCAR_CAN_RTR) {
 		cf->can_id |= CAN_RTR_FLAG;
 	} else {
-		for (dlc = 0; dlc < cf->can_dlc; dlc++)
+		for (dlc = 0; dlc < cf->len; dlc++)
 			cf->data[dlc] =
 			readb(&priv->regs->mb[RCAR_CAN_RX_FIFO_MBX].data[dlc]);
 	}
 
 	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
 
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	stats->rx_packets++;
 	netif_receive_skb(skb);
 }
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 899a3218ce5e..86c6cbdb7e53 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1025,7 +1025,7 @@ static void rcar_canfd_error(struct net_device *ndev, u32 cerfl,
 	rcar_canfd_write(priv->base, RCANFD_CERFL(ch),
 			 RCANFD_CERFL_ERR(~cerfl));
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -1134,7 +1134,7 @@ static void rcar_canfd_state_change(struct net_device *ndev,
 
 		can_change_state(ndev, cf, tx_state, rx_state);
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	}
 }
diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 6e95193b215b..450c5cfcb3fc 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -55,7 +55,7 @@ static int can_rx_offload_napi_poll(struct napi_struct *napi, int quota)
 
 		work_done++;
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_receive_skb(skb);
 	}
 
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 1f188f2d126e..d55394aa0b95 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -295,7 +295,7 @@ static netdev_tx_t sja1000_start_xmit(struct sk_buff *skb,
 
 	netif_stop_queue(dev);
 
-	fi = dlc = cf->can_dlc;
+	fi = dlc = cf->len;
 	id = cf->can_id;
 
 	if (id & CAN_RTR_FLAG)
@@ -367,11 +367,11 @@ static void sja1000_rx(struct net_device *dev)
 		    | (priv->read_reg(priv, SJA1000_ID2) >> 5);
 	}
 
-	cf->can_dlc = can_cc_dlc2len(fi & 0x0F);
+	cf->len = can_cc_dlc2len(fi & 0x0F);
 	if (fi & SJA1000_FI_RTR) {
 		id |= CAN_RTR_FLAG;
 	} else {
-		for (i = 0; i < cf->can_dlc; i++)
+		for (i = 0; i < cf->len; i++)
 			cf->data[i] = priv->read_reg(priv, dreg++);
 	}
 
@@ -381,7 +381,7 @@ static void sja1000_rx(struct net_device *dev)
 	sja1000_write_cmdreg(priv, CMD_RRB);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
@@ -490,7 +490,7 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	return 0;
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index b4a39f0449ba..a1bd1be09548 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -106,8 +106,8 @@ static struct net_device **slcan_devs;
 
 /*
  * A CAN frame has a can_id (11 bit standard frame format OR 29 bit extended
- * frame format) a data length code (can_dlc) which can be from 0 to 8
- * and up to <can_dlc> data bytes as payload.
+ * frame format) a data length code (len) which can be from 0 to 8
+ * and up to <len> data bytes as payload.
  * Additionally a CAN frame may become a remote transmission frame if the
  * RTR-bit is set. This causes another ECU to send a CAN frame with the
  * given can_id.
@@ -128,10 +128,10 @@ static struct net_device **slcan_devs;
  *
  * Examples:
  *
- * t1230 : can_id 0x123, can_dlc 0, no data
- * t4563112233 : can_id 0x456, can_dlc 3, data 0x11 0x22 0x33
- * T12ABCDEF2AA55 : extended can_id 0x12ABCDEF, can_dlc 2, data 0xAA 0x55
- * r1230 : can_id 0x123, can_dlc 0, no data, remote transmission request
+ * t1230 : can_id 0x123, len 0, no data
+ * t4563112233 : can_id 0x456, len 3, data 0x11 0x22 0x33
+ * T12ABCDEF2AA55 : extended can_id 0x12ABCDEF, len 2, data 0xAA 0x55
+ * r1230 : can_id 0x123, len 0, no data, remote transmission request
  *
  */
 
@@ -156,7 +156,7 @@ static void slc_bump(struct slcan *sl)
 		fallthrough;
 	case 't':
 		/* store dlc ASCII value and terminate SFF CAN ID string */
-		cf.can_dlc = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
+		cf.len = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
 		sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
 		cmd += SLC_CMD_LEN + SLC_SFF_ID_LEN + 1;
@@ -167,7 +167,7 @@ static void slc_bump(struct slcan *sl)
 	case 'T':
 		cf.can_id |= CAN_EFF_FLAG;
 		/* store dlc ASCII value and terminate EFF CAN ID string */
-		cf.can_dlc = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
+		cf.len = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
 		sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
 		cmd += SLC_CMD_LEN + SLC_EFF_ID_LEN + 1;
@@ -181,15 +181,15 @@ static void slc_bump(struct slcan *sl)
 
 	cf.can_id |= tmpid;
 
-	/* get can_dlc from sanitized ASCII value */
-	if (cf.can_dlc >= '0' && cf.can_dlc < '9')
-		cf.can_dlc -= '0';
+	/* get len from sanitized ASCII value */
+	if (cf.len >= '0' && cf.len < '9')
+		cf.len -= '0';
 	else
 		return;
 
 	/* RTR frames may have a dlc > 0 but they never have any data bytes */
 	if (!(cf.can_id & CAN_RTR_FLAG)) {
-		for (i = 0; i < cf.can_dlc; i++) {
+		for (i = 0; i < cf.len; i++) {
 			tmp = hex_to_bin(*cmd++);
 			if (tmp < 0)
 				return;
@@ -218,7 +218,7 @@ static void slc_bump(struct slcan *sl)
 	skb_put_data(skb, &cf, sizeof(struct can_frame));
 
 	sl->dev->stats.rx_packets++;
-	sl->dev->stats.rx_bytes += cf.can_dlc;
+	sl->dev->stats.rx_bytes += cf.len;
 	netif_rx_ni(skb);
 }
 
@@ -282,11 +282,11 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 
 	pos += (cf->can_id & CAN_EFF_FLAG) ? SLC_EFF_ID_LEN : SLC_SFF_ID_LEN;
 
-	*pos++ = cf->can_dlc + '0';
+	*pos++ = cf->len + '0';
 
 	/* RTR frames may have a dlc > 0 but they never have any data bytes */
 	if (!(cf->can_id & CAN_RTR_FLAG)) {
-		for (i = 0; i < cf->can_dlc; i++)
+		for (i = 0; i < cf->len; i++)
 			pos = hex_byte_pack_upper(pos, cf->data[i]);
 	}
 
@@ -304,7 +304,7 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 	actual = sl->tty->ops->write(sl->tty, sl->xbuff, pos - sl->xbuff);
 	sl->xleft = (pos - sl->xbuff) - actual;
 	sl->xhead = sl->xbuff + actual;
-	sl->dev->stats.tx_bytes += cf->can_dlc;
+	sl->dev->stats.tx_bytes += cf->len;
 }
 
 /* Write out any remaining transmit buffer. Scheduled when tty is writable */
diff --git a/drivers/net/can/softing/softing_fw.c b/drivers/net/can/softing/softing_fw.c
index ccd649a8e37b..7e1536877993 100644
--- a/drivers/net/can/softing/softing_fw.c
+++ b/drivers/net/can/softing/softing_fw.c
@@ -624,7 +624,7 @@ int softing_startstop(struct net_device *dev, int up)
 	 */
 	memset(&msg, 0, sizeof(msg));
 	msg.can_id = CAN_ERR_FLAG | CAN_ERR_RESTARTED;
-	msg.can_dlc = CAN_ERR_DLC;
+	msg.len = CAN_ERR_DLC;
 	for (j = 0; j < ARRAY_SIZE(card->net); ++j) {
 		if (!(bus_bitmask_start & (1 << j)))
 			continue;
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index 39e8275ee7ba..03a68bb486fd 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -84,7 +84,7 @@ static netdev_tx_t softing_netdev_start_xmit(struct sk_buff *skb,
 	if (priv->index)
 		*ptr |= CMD_BUS2;
 	++ptr;
-	*ptr++ = cf->can_dlc;
+	*ptr++ = cf->len;
 	*ptr++ = (cf->can_id >> 0);
 	*ptr++ = (cf->can_id >> 8);
 	if (cf->can_id & CAN_EFF_FLAG) {
@@ -95,7 +95,7 @@ static netdev_tx_t softing_netdev_start_xmit(struct sk_buff *skb,
 		ptr += 1;
 	}
 	if (!(cf->can_id & CAN_RTR_FLAG))
-		memcpy(ptr, &cf->data[0], cf->can_dlc);
+		memcpy(ptr, &cf->data[0], cf->len);
 	memcpy_toio(&card->dpram[DPRAM_TX + DPRAM_TX_SIZE * fifo_wr],
 			buf, DPRAM_TX_SIZE);
 	if (++fifo_wr >= DPRAM_TX_CNT)
@@ -167,7 +167,7 @@ static int softing_handle_1(struct softing *card)
 		iowrite8(0, &card->dpram[DPRAM_RX_LOST]);
 		/* prepare msg */
 		msg.can_id = CAN_ERR_FLAG | CAN_ERR_CRTL;
-		msg.can_dlc = CAN_ERR_DLC;
+		msg.len = CAN_ERR_DLC;
 		msg.data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 		/*
 		 * service to all buses, we don't know which it was applicable
@@ -218,7 +218,7 @@ static int softing_handle_1(struct softing *card)
 		state = *ptr++;
 
 		msg.can_id = CAN_ERR_FLAG;
-		msg.can_dlc = CAN_ERR_DLC;
+		msg.len = CAN_ERR_DLC;
 
 		if (state & SF_MASK_BUSOFF) {
 			can_state = CAN_STATE_BUS_OFF;
@@ -261,7 +261,7 @@ static int softing_handle_1(struct softing *card)
 	} else {
 		if (cmd & CMD_RTR)
 			msg.can_id |= CAN_RTR_FLAG;
-		msg.can_dlc = can_cc_dlc2len(*ptr++);
+		msg.len = can_cc_dlc2len(*ptr++);
 		if (cmd & CMD_XTD) {
 			msg.can_id |= CAN_EFF_FLAG;
 			msg.can_id |= le32_to_cpup((void *)ptr);
@@ -294,7 +294,7 @@ static int softing_handle_1(struct softing *card)
 				--card->tx.pending;
 			++netdev->stats.tx_packets;
 			if (!(msg.can_id & CAN_RTR_FLAG))
-				netdev->stats.tx_bytes += msg.can_dlc;
+				netdev->stats.tx_bytes += msg.len;
 		} else {
 			int ret;
 
@@ -302,7 +302,7 @@ static int softing_handle_1(struct softing *card)
 			if (ret == NET_RX_SUCCESS) {
 				++netdev->stats.rx_packets;
 				if (!(msg.can_id & CAN_RTR_FLAG))
-					netdev->stats.rx_bytes += msg.can_dlc;
+					netdev->stats.rx_bytes += msg.len;
 			} else {
 				++netdev->stats.rx_dropped;
 			}
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 728f34b696a7..f9455de94786 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -277,13 +277,13 @@ static void hi3110_hw_tx(struct spi_device *spi, struct can_frame *frame)
 			((frame->can_id & CAN_EFF_MASK) << 1) |
 			((frame->can_id & CAN_RTR_FLAG) ? 1 : 0);
 
-		buf[HI3110_FIFO_EXT_DLC_OFF] = frame->can_dlc;
+		buf[HI3110_FIFO_EXT_DLC_OFF] = frame->len;
 
 		memcpy(buf + HI3110_FIFO_EXT_DATA_OFF,
-		       frame->data, frame->can_dlc);
+		       frame->data, frame->len);
 
 		hi3110_hw_tx_frame(spi, buf, HI3110_TX_EXT_BUF_LEN -
-				   (HI3110_CAN_MAX_DATA_LEN - frame->can_dlc));
+				   (HI3110_CAN_MAX_DATA_LEN - frame->len));
 	} else {
 		/* Standard frame */
 		buf[HI3110_FIFO_ID_OFF] =   (frame->can_id & CAN_SFF_MASK) >> 3;
@@ -291,13 +291,13 @@ static void hi3110_hw_tx(struct spi_device *spi, struct can_frame *frame)
 			((frame->can_id & CAN_SFF_MASK) << 5) |
 			((frame->can_id & CAN_RTR_FLAG) ? (1 << 4) : 0);
 
-		buf[HI3110_FIFO_STD_DLC_OFF] = frame->can_dlc;
+		buf[HI3110_FIFO_STD_DLC_OFF] = frame->len;
 
 		memcpy(buf + HI3110_FIFO_STD_DATA_OFF,
-		       frame->data, frame->can_dlc);
+		       frame->data, frame->len);
 
 		hi3110_hw_tx_frame(spi, buf, HI3110_TX_STD_BUF_LEN -
-				   (HI3110_CAN_MAX_DATA_LEN - frame->can_dlc));
+				   (HI3110_CAN_MAX_DATA_LEN - frame->len));
 	}
 }
 
@@ -341,16 +341,16 @@ static void hi3110_hw_rx(struct spi_device *spi)
 	}
 
 	/* Data length */
-	frame->can_dlc = can_cc_dlc2len(buf[HI3110_FIFO_WOTIME_DLC_OFF] & 0x0F);
+	frame->len = can_cc_dlc2len(buf[HI3110_FIFO_WOTIME_DLC_OFF] & 0x0F);
 
 	if (buf[HI3110_FIFO_WOTIME_ID_OFF + 3] & HI3110_FIFO_WOTIME_ID_RTR)
 		frame->can_id |= CAN_RTR_FLAG;
 	else
 		memcpy(frame->data, buf + HI3110_FIFO_WOTIME_DAT_OFF,
-		       frame->can_dlc);
+		       frame->len);
 
 	priv->net->stats.rx_packets++;
-	priv->net->stats.rx_bytes += frame->can_dlc;
+	priv->net->stats.rx_bytes += frame->len;
 
 	can_led_event(priv->net, CAN_LED_EVENT_RX);
 
@@ -585,7 +585,7 @@ static void hi3110_tx_work_handler(struct work_struct *ws)
 		} else {
 			frame = (struct can_frame *)priv->tx_skb->data;
 			hi3110_hw_tx(spi, frame);
-			priv->tx_len = 1 + frame->can_dlc;
+			priv->tx_len = 1 + frame->len;
 			can_put_echo_skb(priv->tx_skb, net, 0);
 			priv->tx_skb = NULL;
 		}
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 6ddebb1c4a24..25859d16d06f 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -644,9 +644,9 @@ static void mcp251x_hw_tx(struct spi_device *spi, struct can_frame *frame,
 		((eid >> SIDL_EID_SHIFT) & SIDL_EID_MASK);
 	buf[TXBEID8_OFF] = GET_BYTE(eid, 1);
 	buf[TXBEID0_OFF] = GET_BYTE(eid, 0);
-	buf[TXBDLC_OFF] = (rtr << DLC_RTR_SHIFT) | frame->can_dlc;
-	memcpy(buf + TXBDAT_OFF, frame->data, frame->can_dlc);
-	mcp251x_hw_tx_frame(spi, buf, frame->can_dlc, tx_buf_idx);
+	buf[TXBDLC_OFF] = (rtr << DLC_RTR_SHIFT) | frame->len;
+	memcpy(buf + TXBDAT_OFF, frame->data, frame->len);
+	mcp251x_hw_tx_frame(spi, buf, frame->len, tx_buf_idx);
 
 	/* use INSTRUCTION_RTS, to avoid "repeated frame problem" */
 	priv->spi_tx_buf[0] = INSTRUCTION_RTS(1 << tx_buf_idx);
@@ -720,11 +720,11 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
 			frame->can_id |= CAN_RTR_FLAG;
 	}
 	/* Data length */
-	frame->can_dlc = can_cc_dlc2len(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
-	memcpy(frame->data, buf + RXBDAT_OFF, frame->can_dlc);
+	frame->len = can_cc_dlc2len(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
+	memcpy(frame->data, buf + RXBDAT_OFF, frame->len);
 
 	priv->net->stats.rx_packets++;
-	priv->net->stats.rx_bytes += frame->can_dlc;
+	priv->net->stats.rx_bytes += frame->len;
 
 	can_led_event(priv->net, CAN_LED_EVENT_RX);
 
@@ -998,10 +998,10 @@ static void mcp251x_tx_work_handler(struct work_struct *ws)
 		} else {
 			frame = (struct can_frame *)priv->tx_skb->data;
 
-			if (frame->can_dlc > CAN_FRAME_MAX_DATA_LEN)
-				frame->can_dlc = CAN_FRAME_MAX_DATA_LEN;
+			if (frame->len > CAN_FRAME_MAX_DATA_LEN)
+				frame->len = CAN_FRAME_MAX_DATA_LEN;
 			mcp251x_hw_tx(spi, frame, 0);
-			priv->tx_len = 1 + frame->can_dlc;
+			priv->tx_len = 1 + frame->len;
 			can_put_echo_skb(priv->tx_skb, net, 0);
 			priv->tx_skb = NULL;
 		}
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 0e2569779895..098cc9670f0f 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -424,7 +424,7 @@ static netdev_tx_t sun4ican_start_xmit(struct sk_buff *skb, struct net_device *d
 	netif_stop_queue(dev);
 
 	id = cf->can_id;
-	dlc = cf->can_dlc;
+	dlc = cf->len;
 	msg_flag_n = dlc;
 
 	if (id & CAN_RTR_FLAG)
@@ -475,7 +475,7 @@ static void sun4i_can_rx(struct net_device *dev)
 		return;
 
 	fi = readl(priv->base + SUN4I_REG_BUF0_ADDR);
-	cf->can_dlc = can_cc_dlc2len(fi & 0x0F);
+	cf->len = can_cc_dlc2len(fi & 0x0F);
 	if (fi & SUN4I_MSG_EFF_FLAG) {
 		dreg = SUN4I_REG_BUF5_ADDR;
 		id = (readl(priv->base + SUN4I_REG_BUF1_ADDR) << 21) |
@@ -493,7 +493,7 @@ static void sun4i_can_rx(struct net_device *dev)
 	if (fi & SUN4I_MSG_RTR_FLAG)
 		id |= CAN_RTR_FLAG;
 	else
-		for (i = 0; i < cf->can_dlc; i++)
+		for (i = 0; i < cf->len; i++)
 			cf->data[i] = readl(priv->base + dreg + i * 4);
 
 	cf->can_id = id;
@@ -501,7 +501,7 @@ static void sun4i_can_rx(struct net_device *dev)
 	sun4i_can_write_cmdreg(priv, SUN4I_CMD_RELEASE_RBUF);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
@@ -625,7 +625,7 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 
 	if (likely(skb)) {
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	} else {
 		return -ENOMEM;
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 0b1fd34f4c83..a6850ff0b55b 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -496,7 +496,7 @@ static netdev_tx_t ti_hecc_xmit(struct sk_buff *skb, struct net_device *ndev)
 	spin_unlock_irqrestore(&priv->mbx_lock, flags);
 
 	/* Prepare mailbox for transmission */
-	data = cf->can_dlc | (get_tx_head_prio(priv) << 8);
+	data = cf->len | (get_tx_head_prio(priv) << 8);
 	if (cf->can_id & CAN_RTR_FLAG) /* Remote transmission request */
 		data |= HECC_CANMCF_RTR;
 	hecc_write_mbx(priv, mbxno, HECC_CANMCF, data);
@@ -508,7 +508,7 @@ static netdev_tx_t ti_hecc_xmit(struct sk_buff *skb, struct net_device *ndev)
 	hecc_write_mbx(priv, mbxno, HECC_CANMID, data);
 	hecc_write_mbx(priv, mbxno, HECC_CANMDL,
 		       be32_to_cpu(*(__be32 *)(cf->data)));
-	if (cf->can_dlc > 4)
+	if (cf->len > 4)
 		hecc_write_mbx(priv, mbxno, HECC_CANMDH,
 			       be32_to_cpu(*(__be32 *)(cf->data + 4)));
 	else
@@ -566,11 +566,11 @@ static struct sk_buff *ti_hecc_mailbox_read(struct can_rx_offload *offload,
 	data = hecc_read_mbx(priv, mbxno, HECC_CANMCF);
 	if (data & HECC_CANMCF_RTR)
 		cf->can_id |= CAN_RTR_FLAG;
-	cf->can_dlc = can_cc_dlc2len(data & 0xF);
+	cf->len = can_cc_dlc2len(data & 0xF);
 
 	data = hecc_read_mbx(priv, mbxno, HECC_CANMDL);
 	*(__be32 *)(cf->data) = cpu_to_be32(data);
-	if (cf->can_dlc > 4) {
+	if (cf->len > 4) {
 		data = hecc_read_mbx(priv, mbxno, HECC_CANMDH);
 		*(__be32 *)(cf->data + 4) = cpu_to_be32(data);
 	}
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 288781934149..25eee4466364 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -306,7 +306,7 @@ static void ems_usb_rx_can_msg(struct ems_usb *dev, struct ems_cpc_msg *msg)
 		return;
 
 	cf->can_id = le32_to_cpu(msg->msg.can_msg.id);
-	cf->can_dlc = can_cc_dlc2len(msg->msg.can_msg.length & 0xF);
+	cf->len = can_cc_dlc2len(msg->msg.can_msg.length & 0xF);
 
 	if (msg->type == CPC_MSG_TYPE_EXT_CAN_FRAME ||
 	    msg->type == CPC_MSG_TYPE_EXT_RTR_FRAME)
@@ -316,12 +316,12 @@ static void ems_usb_rx_can_msg(struct ems_usb *dev, struct ems_cpc_msg *msg)
 	    msg->type == CPC_MSG_TYPE_EXT_RTR_FRAME) {
 		cf->can_id |= CAN_RTR_FLAG;
 	} else {
-		for (i = 0; i < cf->can_dlc; i++)
+		for (i = 0; i < cf->len; i++)
 			cf->data[i] = msg->msg.can_msg.msg[i];
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -396,7 +396,7 @@ static void ems_usb_rx_err(struct ems_usb *dev, struct ems_cpc_msg *msg)
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -755,7 +755,7 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 	msg = (struct ems_cpc_msg *)&buf[CPC_HEADER_SIZE];
 
 	msg->msg.can_msg.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
-	msg->msg.can_msg.length = cf->can_dlc;
+	msg->msg.can_msg.length = cf->len;
 
 	if (cf->can_id & CAN_RTR_FLAG) {
 		msg->type = cf->can_id & CAN_EFF_FLAG ?
@@ -766,10 +766,10 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 		msg->type = cf->can_id & CAN_EFF_FLAG ?
 			CPC_CMD_TYPE_EXT_CAN_FRAME : CPC_CMD_TYPE_CAN_FRAME;
 
-		for (i = 0; i < cf->can_dlc; i++)
+		for (i = 0; i < cf->len; i++)
 			msg->msg.can_msg.msg[i] = cf->data[i];
 
-		msg->length = CPC_CAN_MSG_MIN_SIZE + cf->can_dlc;
+		msg->length = CPC_CAN_MSG_MIN_SIZE + cf->len;
 	}
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
@@ -794,7 +794,7 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 
 	context->dev = dev;
 	context->echo_index = i;
-	context->dlc = cf->can_dlc;
+	context->dlc = cf->len;
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
 			  size, ems_usb_write_bulk_callback, context);
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 72999de550d1..3643a8ee03cf 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -292,7 +292,7 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 		priv->bec.rxerr = rxerr;
 
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	}
 }
@@ -321,7 +321,7 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 		}
 
 		cf->can_id = id & ESD_IDMASK;
-		cf->can_dlc = can_cc_dlc2len(msg->msg.rx.dlc & ~ESD_RTR);
+		cf->len = can_cc_dlc2len(msg->msg.rx.dlc & ~ESD_RTR);
 
 		if (id & ESD_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
@@ -329,12 +329,12 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 		if (msg->msg.rx.dlc & ESD_RTR) {
 			cf->can_id |= CAN_RTR_FLAG;
 		} else {
-			for (i = 0; i < cf->can_dlc; i++)
+			for (i = 0; i < cf->len; i++)
 				cf->data[i] = msg->msg.rx.data[i];
 		}
 
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	}
 
@@ -737,7 +737,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 	msg->msg.hdr.len = 3; /* minimal length */
 	msg->msg.hdr.cmd = CMD_CAN_TX;
 	msg->msg.tx.net = priv->index;
-	msg->msg.tx.dlc = cf->can_dlc;
+	msg->msg.tx.dlc = cf->len;
 	msg->msg.tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
 
 	if (cf->can_id & CAN_RTR_FLAG)
@@ -746,10 +746,10 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 	if (cf->can_id & CAN_EFF_FLAG)
 		msg->msg.tx.id |= cpu_to_le32(ESD_EXTID);
 
-	for (i = 0; i < cf->can_dlc; i++)
+	for (i = 0; i < cf->len; i++)
 		msg->msg.tx.data[i] = cf->data[i];
 
-	msg->msg.hdr.len += (cf->can_dlc + 3) >> 2;
+	msg->msg.hdr.len += (cf->len + 3) >> 2;
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
 		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
@@ -769,7 +769,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 
 	context->priv = priv;
 	context->echo_index = i;
-	context->dlc = cf->can_dlc;
+	context->dlc = cf->len;
 
 	/* hnd must not be 0 - MSB is stripped in txdone handling */
 	msg->msg.tx.hnd = 0x80000000 | i; /* returned in TX done message */
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index b1729b208788..d6a68b7046eb 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -331,7 +331,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 
 		cf->can_id = hf->can_id;
 
-		cf->can_dlc = can_cc_dlc2len(hf->can_dlc);
+		cf->len = can_cc_dlc2len(hf->can_dlc);
 		memcpy(cf->data, hf->data, 8);
 
 		/* ERROR frames tell us information about the controller */
@@ -378,7 +378,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			goto resubmit_urb;
 
 		cf->can_id |= CAN_ERR_CRTL;
-		cf->can_dlc = CAN_ERR_DLC;
+		cf->len = CAN_ERR_DLC;
 		cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 		stats->rx_over_errors++;
 		stats->rx_errors++;
@@ -504,8 +504,8 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	cf = (struct can_frame *)skb->data;
 
 	hf->can_id = cf->can_id;
-	hf->can_dlc = cf->can_dlc;
-	memcpy(hf->data, cf->data, cf->can_dlc);
+	hf->can_dlc = cf->len;
+	memcpy(hf->data, cf->data, cf->len);
 
 	usb_fill_bulk_urb(urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 0f1d3e807d63..d6e18bcb1a7f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -258,7 +258,7 @@ int kvaser_usb_can_rx_over_error(struct net_device *netdev)
 	cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	return 0;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 843e2e1392e8..c6d5f3f656c3 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -895,7 +895,7 @@ static void kvaser_usb_hydra_update_state(struct kvaser_usb_net_priv *priv,
 
 	stats = &netdev->stats;
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -1049,7 +1049,7 @@ kvaser_usb_hydra_error_frame(struct kvaser_usb_net_priv *priv,
 	cf->data[7] = bec.rxerr;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	priv->bec.txerr = bec.txerr;
@@ -1084,7 +1084,7 @@ static void kvaser_usb_hydra_one_shot_fail(struct kvaser_usb_net_priv *priv,
 
 	stats->tx_errors++;
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -1180,15 +1180,15 @@ static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_OVERRUN)
 		kvaser_usb_can_rx_over_error(priv->netdev);
 
-	cf->can_dlc = can_cc_dlc2len(cmd->rx_can.dlc);
+	cf->len = can_cc_dlc2len(cmd->rx_can.dlc);
 
 	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME)
 		cf->can_id |= CAN_RTR_FLAG;
 	else
-		memcpy(cf->data, cmd->rx_can.data, cf->can_dlc);
+		memcpy(cf->data, cmd->rx_can.data, cf->len);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -1434,7 +1434,7 @@ kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
 	u32 flags;
 	u32 id;
 
-	*frame_len = cf->can_dlc;
+	*frame_len = cf->len;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
 	if (!cmd)
@@ -1455,7 +1455,7 @@ kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
 		id = cf->can_id & CAN_SFF_MASK;
 	}
 
-	cmd->tx_can.dlc = cf->can_dlc;
+	cmd->tx_can.dlc = cf->len;
 
 	flags = (cf->can_id & CAN_EFF_FLAG ?
 		 KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID : 0);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 916ab994cce4..98c016ef0607 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -350,7 +350,7 @@ kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 	u8 *cmd_tx_can_flags = NULL;		/* GCC */
 	struct can_frame *cf = (struct can_frame *)skb->data;
 
-	*frame_len = cf->can_dlc;
+	*frame_len = cf->len;
 
 	cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (cmd) {
@@ -383,8 +383,8 @@ kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 			cmd->u.tx_can.data[1] = cf->can_id & 0x3f;
 		}
 
-		cmd->u.tx_can.data[5] = cf->can_dlc;
-		memcpy(&cmd->u.tx_can.data[6], cf->data, cf->can_dlc);
+		cmd->u.tx_can.data[5] = cf->len;
+		memcpy(&cmd->u.tx_can.data[6], cf->data, cf->len);
 
 		if (cf->can_id & CAN_RTR_FLAG)
 			*cmd_tx_can_flags |= MSG_FLAG_REMOTE_FRAME;
@@ -576,7 +576,7 @@ static void kvaser_usb_leaf_tx_acknowledge(const struct kvaser_usb *dev,
 			cf->can_id |= CAN_ERR_RESTARTED;
 
 			stats->rx_packets++;
-			stats->rx_bytes += cf->can_dlc;
+			stats->rx_bytes += cf->len;
 			netif_rx(skb);
 		} else {
 			netdev_err(priv->netdev,
@@ -694,7 +694,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 {
 	struct can_frame *cf;
 	struct can_frame tmp_cf = { .can_id = CAN_ERR_FLAG,
-				    .can_dlc = CAN_ERR_DLC };
+				    .len = CAN_ERR_DLC };
 	struct sk_buff *skb;
 	struct net_device_stats *stats;
 	struct kvaser_usb_net_priv *priv;
@@ -778,7 +778,7 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 	cf->data[7] = es->rxerr;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -978,13 +978,13 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 		else
 			cf->can_id &= CAN_SFF_MASK;
 
-		cf->can_dlc = can_cc_dlc2len(cmd->u.leaf.log_message.dlc);
+		cf->len = can_cc_dlc2len(cmd->u.leaf.log_message.dlc);
 
 		if (cmd->u.leaf.log_message.flags & MSG_FLAG_REMOTE_FRAME)
 			cf->can_id |= CAN_RTR_FLAG;
 		else
 			memcpy(cf->data, &cmd->u.leaf.log_message.data,
-			       cf->can_dlc);
+			       cf->len);
 	} else {
 		cf->can_id = ((rx_data[0] & 0x1f) << 6) | (rx_data[1] & 0x3f);
 
@@ -996,16 +996,16 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 			cf->can_id |= CAN_EFF_FLAG;
 		}
 
-		cf->can_dlc = can_cc_dlc2len(rx_data[5]);
+		cf->len = can_cc_dlc2len(rx_data[5]);
 
 		if (cmd->u.rx_can_header.flag & MSG_FLAG_REMOTE_FRAME)
 			cf->can_id |= CAN_RTR_FLAG;
 		else
-			memcpy(cf->data, &rx_data[6], cf->can_dlc);
+			memcpy(cf->data, &rx_data[6], cf->len);
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 295886c6b565..df54eb7d4b36 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -184,7 +184,7 @@ static inline struct mcba_usb_ctx *mcba_usb_get_free_ctx(struct mcba_priv *priv,
 
 			if (cf) {
 				ctx->can = true;
-				ctx->dlc = cf->can_dlc;
+				ctx->dlc = cf->len;
 			} else {
 				ctx->can = false;
 				ctx->dlc = 0;
@@ -348,7 +348,7 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 		usb_msg.eid = 0;
 	}
 
-	usb_msg.dlc = cf->can_dlc;
+	usb_msg.dlc = cf->len;
 
 	memcpy(usb_msg.data, cf->data, usb_msg.dlc);
 
@@ -451,12 +451,12 @@ static void mcba_usb_process_can(struct mcba_priv *priv,
 	if (msg->dlc & MCBA_DLC_RTR_MASK)
 		cf->can_id |= CAN_RTR_FLAG;
 
-	cf->can_dlc = can_cc_dlc2len(msg->dlc & MCBA_DLC_MASK);
+	cf->len = can_cc_dlc2len(msg->dlc & MCBA_DLC_MASK);
 
-	memcpy(cf->data, msg->data, cf->can_dlc);
+	memcpy(cf->data, msg->data, cf->len);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 
 	can_led_event(priv->netdev, CAN_LED_EVENT_RX);
 	netif_rx(skb);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index f7fc82203489..ec34f87cc02c 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -596,7 +596,7 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_context *mc, u8 n,
 	}
 
 	mc->netdev->stats.rx_packets++;
-	mc->netdev->stats.rx_bytes += cf->can_dlc;
+	mc->netdev->stats.rx_bytes += cf->len;
 	netif_rx(skb);
 
 	return 0;
@@ -734,7 +734,7 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		cf->can_id = le16_to_cpu(tmp16) >> 5;
 	}
 
-	cf->can_dlc = can_cc_dlc2len(rec_len);
+	cf->len = can_cc_dlc2len(rec_len);
 
 	/* Only first packet timestamp is a word */
 	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
@@ -751,7 +751,7 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		if ((mc->ptr + rec_len) > mc->end)
 			goto decode_failed;
 
-		memcpy(cf->data, mc->ptr, cf->can_dlc);
+		memcpy(cf->data, mc->ptr, cf->len);
 		mc->ptr += rec_len;
 	}
 
@@ -761,7 +761,7 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 
 	/* update statistics */
 	mc->netdev->stats.rx_packets++;
-	mc->netdev->stats.rx_bytes += cf->can_dlc;
+	mc->netdev->stats.rx_bytes += cf->len;
 	/* push the skb */
 	netif_rx(skb);
 
@@ -838,7 +838,7 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 	pc = obuf + PCAN_USB_MSG_HEADER_LEN;
 
 	/* status/len byte */
-	*pc = cf->can_dlc;
+	*pc = cf->len;
 	if (cf->can_id & CAN_RTR_FLAG)
 		*pc |= PCAN_USB_STATUSLEN_RTR;
 
@@ -858,8 +858,8 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 
 	/* can data */
 	if (!(cf->can_id & CAN_RTR_FLAG)) {
-		memcpy(pc, cf->data, cf->can_dlc);
-		pc += cf->can_dlc;
+		memcpy(pc, cf->data, cf->len);
+		pc += cf->len;
 	}
 
 	obuf[(*size)-1] = (u8)(stats->tx_packets & 0xff);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 1233ef20646a..922280692a8f 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -581,7 +581,7 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(sm->ts_low));
 
 	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += cf->can_dlc;
+	netdev->stats.rx_bytes += cf->len;
 
 	return 0;
 }
@@ -737,7 +737,7 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 	struct pucan_tx_msg *tx_msg = (struct pucan_tx_msg *)obuf;
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	u16 tx_msg_size, tx_msg_flags;
-	u8 can_dlc;
+	u8 len;
 
 	if (cfd->len > CANFD_MAX_DLEN)
 		return -EINVAL;
@@ -756,7 +756,7 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 
 	if (can_is_canfd_skb(skb)) {
 		/* considering a CANFD frame */
-		can_dlc = can_len2dlc(cfd->len);
+		len = can_len2dlc(cfd->len);
 
 		tx_msg_flags |= PUCAN_MSG_EXT_DATA_LEN;
 
@@ -767,14 +767,14 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 			tx_msg_flags |= PUCAN_MSG_ERROR_STATE_IND;
 	} else {
 		/* CAND 2.0 frames */
-		can_dlc = cfd->len;
+		len = cfd->len;
 
 		if (cfd->can_id & CAN_RTR_FLAG)
 			tx_msg_flags |= PUCAN_MSG_RTR;
 	}
 
 	tx_msg->flags = cpu_to_le16(tx_msg_flags);
-	tx_msg->channel_dlc = PUCAN_MSG_CHANNEL_DLC(dev->ctrl_idx, can_dlc);
+	tx_msg->channel_dlc = PUCAN_MSG_CHANNEL_DLC(dev->ctrl_idx, len);
 	memcpy(tx_msg->d, cfd->data, cfd->len);
 
 	/* add null size message to tag the end (messages are 32-bits aligned)
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index c7564773fb2b..275087c39602 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -532,7 +532,7 @@ static int pcan_usb_pro_handle_canmsg(struct pcan_usb_pro_interface *usb_if,
 		return -ENOMEM;
 
 	can_frame->can_id = le32_to_cpu(rx->id);
-	can_frame->can_dlc = rx->len & 0x0f;
+	can_frame->len = rx->len & 0x0f;
 
 	if (rx->flags & PCAN_USBPRO_EXT)
 		can_frame->can_id |= CAN_EFF_FLAG;
@@ -540,14 +540,14 @@ static int pcan_usb_pro_handle_canmsg(struct pcan_usb_pro_interface *usb_if,
 	if (rx->flags & PCAN_USBPRO_RTR)
 		can_frame->can_id |= CAN_RTR_FLAG;
 	else
-		memcpy(can_frame->data, rx->data, can_frame->can_dlc);
+		memcpy(can_frame->data, rx->data, can_frame->len);
 
 	hwts = skb_hwtstamps(skb);
 	peak_usb_get_ts_time(&usb_if->time_ref, le32_to_cpu(rx->ts32),
 			     &hwts->hwtstamp);
 
 	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += can_frame->can_dlc;
+	netdev->stats.rx_bytes += can_frame->len;
 	netif_rx(skb);
 
 	return 0;
@@ -662,7 +662,7 @@ static int pcan_usb_pro_handle_error(struct pcan_usb_pro_interface *usb_if,
 	hwts = skb_hwtstamps(skb);
 	peak_usb_get_ts_time(&usb_if->time_ref, le32_to_cpu(er->ts32), &hwts->hwtstamp);
 	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += can_frame->can_dlc;
+	netdev->stats.rx_bytes += can_frame->len;
 	netif_rx(skb);
 
 	return 0;
@@ -767,14 +767,14 @@ static int pcan_usb_pro_encode_msg(struct peak_usb_device *dev,
 
 	pcan_msg_init_empty(&usb_msg, obuf, *size);
 
-	if ((cf->can_id & CAN_RTR_FLAG) || (cf->can_dlc == 0))
+	if ((cf->can_id & CAN_RTR_FLAG) || (cf->len == 0))
 		data_type = PCAN_USBPRO_TXMSG0;
-	else if (cf->can_dlc <= 4)
+	else if (cf->len <= 4)
 		data_type = PCAN_USBPRO_TXMSG4;
 	else
 		data_type = PCAN_USBPRO_TXMSG8;
 
-	len = (dev->ctrl_idx << 4) | (cf->can_dlc & 0x0f);
+	len = (dev->ctrl_idx << 4) | (cf->len & 0x0f);
 
 	flags = 0;
 	if (cf->can_id & CAN_EFF_FLAG)
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 072058c6f6e8..7d92da8954fe 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -614,15 +614,15 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
 	cf->can_id = canid;
 
 	/* compute DLC taking RTR_FLAG into account */
-	cf->can_dlc = ucan_can_cc_dlc2len(&m->msg.can_msg, len);
+	cf->len = ucan_can_cc_dlc2len(&m->msg.can_msg, len);
 
 	/* copy the payload of non RTR frames */
 	if (!(cf->can_id & CAN_RTR_FLAG) || (cf->can_id & CAN_ERR_FLAG))
-		memcpy(cf->data, m->msg.can_msg.data, cf->can_dlc);
+		memcpy(cf->data, m->msg.can_msg.data, cf->len);
 
 	/* don't count error frames as real packets */
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 
 	/* pass it to Linux */
 	netif_rx(skb);
@@ -1078,15 +1078,15 @@ static struct urb *ucan_prepare_tx_urb(struct ucan_priv *up,
 		mlen = UCAN_OUT_HDR_SIZE +
 			offsetof(struct ucan_can_msg, dlc) +
 			sizeof(m->msg.can_msg.dlc);
-		m->msg.can_msg.dlc = cf->can_dlc;
+		m->msg.can_msg.dlc = cf->len;
 	} else {
 		mlen = UCAN_OUT_HDR_SIZE +
-			sizeof(m->msg.can_msg.id) + cf->can_dlc;
-		memcpy(m->msg.can_msg.data, cf->data, cf->can_dlc);
+			sizeof(m->msg.can_msg.id) + cf->len;
+		memcpy(m->msg.can_msg.data, cf->data, cf->len);
 	}
 	m->len = cpu_to_le16(mlen);
 
-	context->dlc = cf->can_dlc;
+	context->dlc = cf->len;
 
 	m->subtype = echo_index;
 
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 216c58f8df6e..6517aaeb4bc0 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -449,7 +449,7 @@ static void usb_8dev_rx_err_msg(struct usb_8dev_priv *priv,
 	priv->bec.rxerr = rxerr;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -470,7 +470,7 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 			return;
 
 		cf->can_id = be32_to_cpu(msg->id);
-		cf->can_dlc = can_cc_dlc2len(msg->dlc & 0xF);
+		cf->len = can_cc_dlc2len(msg->dlc & 0xF);
 
 		if (msg->flags & USB_8DEV_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
@@ -478,10 +478,10 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 		if (msg->flags & USB_8DEV_RTR)
 			cf->can_id |= CAN_RTR_FLAG;
 		else
-			memcpy(cf->data, msg->data, cf->can_dlc);
+			memcpy(cf->data, msg->data, cf->len);
 
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 
 		can_led_event(priv->netdev, CAN_LED_EVENT_RX);
@@ -637,8 +637,8 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 		msg->flags |= USB_8DEV_EXTID;
 
 	msg->id = cpu_to_be32(cf->can_id & CAN_ERR_MASK);
-	msg->dlc = cf->can_dlc;
-	memcpy(msg->data, cf->data, cf->can_dlc);
+	msg->dlc = cf->len;
+	memcpy(msg->data, cf->data, cf->len);
 	msg->end = USB_8DEV_DATA_END;
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
@@ -656,7 +656,7 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 
 	context->priv = priv;
 	context->echo_index = i;
-	context->dlc = cf->can_dlc;
+	context->dlc = cf->len;
 
 	usb_fill_bulk_urb(urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, USB_8DEV_ENDP_DATA_TX),
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 73e8b1df1071..88831ce0f2f8 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -759,7 +759,7 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 				   XCAN_DLCR_DLC_SHIFT;
 
 	/* Change Xilinx CAN data length format to socketCAN data format */
-	cf->can_dlc = can_cc_dlc2len(dlc);
+	cf->len = can_cc_dlc2len(dlc);
 
 	/* Change Xilinx CAN ID format to socketCAN ID format */
 	if (id_xcan & XCAN_IDR_IDE_MASK) {
@@ -784,13 +784,13 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 
 	if (!(cf->can_id & CAN_RTR_FLAG)) {
 		/* Change Xilinx CAN data format to socketCAN data format */
-		if (cf->can_dlc > 0)
+		if (cf->len > 0)
 			*(__be32 *)(cf->data) = cpu_to_be32(data[0]);
-		if (cf->can_dlc > 4)
+		if (cf->len > 4)
 			*(__be32 *)(cf->data + 4) = cpu_to_be32(data[1]);
 	}
 
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	stats->rx_packets++;
 	netif_receive_skb(skb);
 
@@ -970,7 +970,7 @@ static void xcan_update_error_state_after_rxtx(struct net_device *ndev)
 			struct net_device_stats *stats = &ndev->stats;
 
 			stats->rx_packets++;
-			stats->rx_bytes += cf->can_dlc;
+			stats->rx_bytes += cf->len;
 			netif_rx(skb);
 		}
 	}
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 802606e36b58..77da061c21c9 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -185,8 +185,8 @@ static inline void can_set_static_ctrlmode(struct net_device *dev,
 		dev->mtu = CANFD_MTU;
 }
 
-/* get data length from can_dlc with sanitized can_dlc */
-u8 can_dlc2len(u8 can_dlc);
+/* get data length from raw data length code (DLC) */
+u8 can_dlc2len(u8 dlc);
 
 /* map the sanitized data length to an appropriate data length code */
 u8 can_len2dlc(u8 len);
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 5d124c155904..963bd7145517 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -888,7 +888,7 @@ static __init int can_init(void)
 	int err;
 
 	/* check for correct padding to be able to use the structs similarly */
-	BUILD_BUG_ON(offsetof(struct can_frame, can_dlc) !=
+	BUILD_BUG_ON(offsetof(struct can_frame, len) !=
 		     offsetof(struct canfd_frame, len) ||
 		     offsetof(struct can_frame, data) !=
 		     offsetof(struct canfd_frame, data));
diff --git a/net/can/gw.c b/net/can/gw.c
index 6b790b6ff8d2..de5e8859ec9b 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -207,7 +207,7 @@ static void canframecpy(struct canfd_frame *dst, struct can_frame *src)
 	 */
 
 	dst->can_id = src->can_id;
-	dst->len = src->can_dlc;
+	dst->len = src->len;
 	*(u64 *)dst->data = *(u64 *)src->data;
 }
 
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 137054bff9ec..bb914d8b4216 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -62,7 +62,7 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
 	skb_pull(skb, J1939_CAN_HDR);
 
 	/* fix length, set to dlc, with 8 maximum */
-	skb_trim(skb, min_t(uint8_t, cf->can_dlc, 8));
+	skb_trim(skb, min_t(uint8_t, cf->len, 8));
 
 	/* set addr */
 	skcb = j1939_skb_to_cb(skb);
@@ -335,7 +335,7 @@ int j1939_send_one(struct j1939_priv *priv, struct sk_buff *skb)
 		canid |= skcb->addr.da << 8;
 
 	cf->can_id = canid;
-	cf->can_dlc = dlc;
+	cf->len = dlc;
 
 	return can_send(skb, 1);
 
-- 
2.29.2

