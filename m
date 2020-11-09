Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804472AC005
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgKIPhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:37:45 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:36309 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731314AbgKIPhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:37:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604936241;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=EkNKXZdCL8KK1xWoczcIILGeC3lzAUpD2xgDrjicOPM=;
        b=ESlStMwBgdifRUTEEfg3KaNVACNDN2GZgG65hl90CddqH2AJHK8gahJXFazwWCcTJF
        FKHlRWF3YNFAoUUEhI+NkfqGPruRpYMgIG9PJRi1kFL4DDB5hJgNzlLBgXfuQrohSvsn
        dGq/GpPC7HReoG/oxeKeP2yPStQyhAe1a+sGt7sDI1VLUDQnLw0uH913LA78nU/BkjUq
        Ag5ayzMpB/csuMjyr36IQxaxmwjadfNAsBKJx1iT7COcUAaBo18HNjsO7whwXD/n7IkJ
        Luvoh0ObbAAB3UL92viSjVcNWUQ0qKlSkp+DlX/Bc0SkgkEv/7wdN6WOktVtJoOeA5L7
        thXg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0lu8GW272ZqqIaA=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwA9FbD85a
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 9 Nov 2020 16:37:13 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org, mkl@pengutronix.de,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v5 4/8] can: replace can_dlc as variable/element for payload length
Date:   Mon,  9 Nov 2020 16:36:53 +0100
Message-Id: <20201109153657.17897-5-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201109153657.17897-1-socketcan@hartkopp.net>
References: <20201109153657.17897-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The naming of can_dlc as element of struct can_frame and also as variable
name is misleading as it claims to be a 'data length CODE' but in reality
it always was a plain data length.

With the indroduction of a new 'len' element in struct can_frame we can now
remove can_dlc as name and make clear which of the former uses was a plain
length (-> 'len') or a data length code (-> 'dlc') value.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
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
 drivers/net/can/usb/gs_usb.c                  | 14 ++++----
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
 40 files changed, 231 insertions(+), 231 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index db06254f8eb7..5284f0ab3b06 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -466,11 +466,11 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		netdev_err(dev, "BUG! TX buffer full when queue awake!\n");
 		return NETDEV_TX_BUSY;
 	}
 	reg_mid = at91_can_id_to_reg_mid(cf->can_id);
 	reg_mcr = ((cf->can_id & CAN_RTR_FLAG) ? AT91_MCR_MRTR : 0) |
-		(cf->can_dlc << 16) | AT91_MCR_MTCR;
+		(cf->len << 16) | AT91_MCR_MTCR;
 
 	/* disable MB while writing ID (see datasheet) */
 	set_mb_mode(priv, mb, AT91_MB_MODE_DISABLED);
 	at91_write(priv, AT91_MID(mb), reg_mid);
 	set_mb_mode_prio(priv, mb, AT91_MB_MODE_TX, prio);
@@ -479,11 +479,11 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	at91_write(priv, AT91_MDH(mb), *(u32 *)(cf->data + 4));
 
 	/* This triggers transmission */
 	at91_write(priv, AT91_MCR(mb), reg_mcr);
 
-	stats->tx_bytes += cf->can_dlc;
+	stats->tx_bytes += cf->len;
 
 	/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
 	can_put_echo_skb(skb, dev, mb - get_mb_tx_first(priv));
 
 	/*
@@ -552,11 +552,11 @@ static void at91_rx_overflow_err(struct net_device *dev)
 
 	cf->can_id |= CAN_ERR_CRTL;
 	cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 }
 
 /**
  * at91_read_mb - read CAN msg from mailbox (lowlevel impl)
@@ -578,11 +578,11 @@ static void at91_read_mb(struct net_device *dev, unsigned int mb,
 		cf->can_id = ((reg_mid >> 0) & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
 		cf->can_id = (reg_mid >> 18) & CAN_SFF_MASK;
 
 	reg_msr = at91_read(priv, AT91_MSR(mb));
-	cf->can_dlc = can_cc_dlc2len((reg_msr >> 16) & 0xf);
+	cf->len = can_cc_dlc2len((reg_msr >> 16) & 0xf);
 
 	if (reg_msr & AT91_MSR_MRTR)
 		cf->can_id |= CAN_RTR_FLAG;
 	else {
 		*(u32 *)(cf->data + 0) = at91_read(priv, AT91_MDL(mb));
@@ -617,11 +617,11 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
 	}
 
 	at91_read_mb(dev, mb, cf);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
@@ -778,11 +778,11 @@ static int at91_poll_err(struct net_device *dev, int quota, u32 reg_sr)
 		return 0;
 
 	at91_poll_err_frame(dev, cf, reg_sr);
 
 	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += cf->can_dlc;
+	dev->stats.rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
 }
 
@@ -1045,11 +1045,11 @@ static void at91_irq_err(struct net_device *dev)
 		return;
 
 	at91_irq_err_state(dev, cf, new_state);
 
 	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += cf->can_dlc;
+	dev->stats.rx_bytes += cf->len;
 	netif_rx(skb);
 
 	priv->can.state = new_state;
 }
 
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 56cc705959ea..0420f09f2b70 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -304,11 +304,11 @@ static void c_can_inval_msg_object(struct net_device *dev, int iface, int obj)
 
 static void c_can_setup_tx_object(struct net_device *dev, int iface,
 				  struct can_frame *frame, int idx)
 {
 	struct c_can_priv *priv = netdev_priv(dev);
-	u16 ctrl = IF_MCONT_TX | frame->can_dlc;
+	u16 ctrl = IF_MCONT_TX | frame->len;
 	bool rtr = frame->can_id & CAN_RTR_FLAG;
 	u32 arb = IF_ARB_MSGVAL;
 	int i;
 
 	if (frame->can_id & CAN_EFF_FLAG) {
@@ -337,19 +337,19 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
 	priv->write_reg(priv, C_CAN_IFACE(MSGCTRL_REG, iface), ctrl);
 
 	if (priv->type == BOSCH_D_CAN) {
 		u32 data = 0, dreg = C_CAN_IFACE(DATA1_REG, iface);
 
-		for (i = 0; i < frame->can_dlc; i += 4, dreg += 2) {
+		for (i = 0; i < frame->len; i += 4, dreg += 2) {
 			data = (u32)frame->data[i];
 			data |= (u32)frame->data[i + 1] << 8;
 			data |= (u32)frame->data[i + 2] << 16;
 			data |= (u32)frame->data[i + 3] << 24;
 			priv->write_reg32(priv, dreg, data);
 		}
 	} else {
-		for (i = 0; i < frame->can_dlc; i += 2) {
+		for (i = 0; i < frame->len; i += 2) {
 			priv->write_reg(priv,
 					C_CAN_IFACE(DATA1_REG, iface) + i / 2,
 					frame->data[i] |
 					(frame->data[i + 1] << 8));
 		}
@@ -395,11 +395,11 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 	if (!skb) {
 		stats->rx_dropped++;
 		return -ENOMEM;
 	}
 
-	frame->can_dlc = can_cc_dlc2len(ctrl & 0x0F);
+	frame->len = can_cc_dlc2len(ctrl & 0x0F);
 
 	arb = priv->read_reg32(priv, C_CAN_IFACE(ARB1_REG, iface));
 
 	if (arb & IF_ARB_MSGXTD)
 		frame->can_id = (arb & CAN_EFF_MASK) | CAN_EFF_FLAG;
@@ -410,28 +410,28 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
 		frame->can_id |= CAN_RTR_FLAG;
 	} else {
 		int i, dreg = C_CAN_IFACE(DATA1_REG, iface);
 
 		if (priv->type == BOSCH_D_CAN) {
-			for (i = 0; i < frame->can_dlc; i += 4, dreg += 2) {
+			for (i = 0; i < frame->len; i += 4, dreg += 2) {
 				data = priv->read_reg32(priv, dreg);
 				frame->data[i] = data;
 				frame->data[i + 1] = data >> 8;
 				frame->data[i + 2] = data >> 16;
 				frame->data[i + 3] = data >> 24;
 			}
 		} else {
-			for (i = 0; i < frame->can_dlc; i += 2, dreg++) {
+			for (i = 0; i < frame->len; i += 2, dreg++) {
 				data = priv->read_reg(priv, dreg);
 				frame->data[i] = data;
 				frame->data[i + 1] = data >> 8;
 			}
 		}
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += frame->can_dlc;
+	stats->rx_bytes += frame->len;
 
 	netif_receive_skb(skb);
 	return 0;
 }
 
@@ -473,11 +473,11 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	 * Store the message in the interface so we can call
 	 * can_put_echo_skb(). We must do this before we enable
 	 * transmit as we might race against do_tx().
 	 */
 	c_can_setup_tx_object(dev, IF_TX, frame, idx);
-	priv->dlc[idx] = frame->can_dlc;
+	priv->dlc[idx] = frame->len;
 	can_put_echo_skb(skb, dev, idx);
 
 	/* Update the active bits */
 	atomic_add((1 << idx), &priv->tx_active);
 	/* Start transmission */
@@ -975,11 +975,11 @@ static int c_can_handle_state_change(struct net_device *dev,
 	default:
 		break;
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
 }
 
@@ -1045,11 +1045,11 @@ static int c_can_handle_bus_err(struct net_device *dev,
 	default:
 		break;
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 	return 1;
 }
 
 static int c_can_poll(struct napi_struct *napi, int quota)
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index 3fd2a276dd93..8d9f332c35e0 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -388,11 +388,11 @@ static void cc770_tx(struct net_device *dev, int mo)
 	struct can_frame *cf = (struct can_frame *)priv->tx_skb->data;
 	u8 dlc, rtr;
 	u32 id;
 	int i;
 
-	dlc = cf->can_dlc;
+	dlc = cf->len;
 	id = cf->can_id;
 	rtr = cf->can_id & CAN_RTR_FLAG ? 0 : MSGCFG_DIR;
 
 	cc770_write_reg(priv, msgobj[mo].ctrl0,
 			MSGVAL_RES | TXIE_RES | RXIE_RES | INTPND_RES);
@@ -468,11 +468,11 @@ static void cc770_rx(struct net_device *dev, unsigned int mo, u8 ctrl1)
 		 * frame. Therefore we set it to 0.
 		 */
 		cf->can_id = CAN_RTR_FLAG;
 		if (config & MSGCFG_XTD)
 			cf->can_id |= CAN_EFF_FLAG;
-		cf->can_dlc = 0;
+		cf->len = 0;
 	} else {
 		if (config & MSGCFG_XTD) {
 			id = cc770_read_reg(priv, msgobj[mo].id[3]);
 			id |= cc770_read_reg(priv, msgobj[mo].id[2]) << 8;
 			id |= cc770_read_reg(priv, msgobj[mo].id[1]) << 16;
@@ -484,17 +484,17 @@ static void cc770_rx(struct net_device *dev, unsigned int mo, u8 ctrl1)
 			id |= cc770_read_reg(priv, msgobj[mo].id[0]) << 8;
 			id >>= 5;
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
 
 static int cc770_err(struct net_device *dev, u8 status)
 {
@@ -570,11 +570,11 @@ static int cc770_err(struct net_device *dev, u8 status)
 		}
 	}
 
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	return 0;
 }
 
@@ -697,11 +697,11 @@ static void cc770_tx_interrupt(struct net_device *dev, unsigned int o)
 		cc770_tx(dev, mo);
 		return;
 	}
 
 	cf = (struct can_frame *)priv->tx_skb->data;
-	stats->tx_bytes += cf->can_dlc;
+	stats->tx_bytes += cf->len;
 	stats->tx_packets++;
 
 	can_put_echo_skb(priv->tx_skb, dev, 0);
 	can_get_echo_skb(dev, 0);
 	priv->tx_skb = NULL;
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 6dee4f8f2024..566501a02b91 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -28,14 +28,14 @@ MODULE_AUTHOR("Wolfgang Grandegger <wg@grandegger.com>");
 /* CAN DLC to real data length conversion helpers */
 
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
 
 static const u8 len2dlc[] = {0, 1, 2, 3, 4, 5, 6, 7, 8,		/* 0 - 8 */
 			     9, 9, 9, 9,			/* 9 - 12 */
@@ -593,11 +593,11 @@ static void can_restart(struct net_device *dev)
 	cf->can_id |= CAN_ERR_RESTARTED;
 
 	netif_rx(skb);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 
 restart:
 	netdev_dbg(dev, "restarted\n");
 	priv->can_stats.restarts++;
 
@@ -735,11 +735,11 @@ struct sk_buff *alloc_can_err_skb(struct net_device *dev, struct can_frame **cf)
 	skb = alloc_can_skb(dev, cf);
 	if (unlikely(!skb))
 		return NULL;
 
 	(*cf)->can_id = CAN_ERR_FLAG;
-	(*cf)->can_dlc = CAN_ERR_DLC;
+	(*cf)->len = CAN_ERR_DLC;
 
 	return skb;
 }
 EXPORT_SYMBOL_GPL(alloc_can_err_skb);
 
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index c71c9b8683d5..f5d94a692576 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1199,25 +1199,25 @@ static int grcan_receive(struct net_device *dev, int budget)
 			cf->can_id |= CAN_EFF_FLAG;
 		} else {
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
 			}
 		}
 
 		/* Update statistics and read pointer */
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_receive_skb(skb);
 
 		rd = grcan_ring_add(rd, GRCAN_MSG_SIZE, dma->rx.size);
 	}
 
@@ -1397,11 +1397,11 @@ static netdev_tx_t grcan_start_xmit(struct sk_buff *skb,
 
 	/* Convert and write CAN message to DMA buffer */
 	eff = cf->can_id & CAN_EFF_FLAG;
 	rtr = cf->can_id & CAN_RTR_FLAG;
 	id = cf->can_id & (eff ? CAN_EFF_MASK : CAN_SFF_MASK);
-	dlc = cf->can_dlc;
+	dlc = cf->len;
 	if (eff)
 		tmp = (id << GRCAN_MSG_EID_BIT) & GRCAN_MSG_EID;
 	else
 		tmp = (id << GRCAN_MSG_BID_BIT) & GRCAN_MSG_BID;
 	slot[0] = (eff ? GRCAN_MSG_IDE : 0) | (rtr ? GRCAN_MSG_RTR : 0) | tmp;
@@ -1445,11 +1445,11 @@ static netdev_tx_t grcan_start_xmit(struct sk_buff *skb,
 	 * as ownership of the skb is passed on by calling can_put_echo_skb.
 	 * Returning NETDEV_TX_BUSY or accessing skb or cf after a call to
 	 * can_put_echo_skb would be an error unless other measures are
 	 * taken.
 	 */
-	priv->txdlc[slotindex] = cf->can_dlc; /* Store dlc for statistics */
+	priv->txdlc[slotindex] = cf->len; /* Store dlc for statistics */
 	can_put_echo_skb(skb, dev, slotindex);
 
 	/* Make sure everything is written before allowing hardware to
 	 * read from the memory
 	 */
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index cc790354a8ee..3df55b0e4ef3 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -429,11 +429,11 @@ static int ifi_canfd_handle_lec_err(struct net_device *ndev)
 	writel(IFI_CANFD_INTERRUPT_ERROR_COUNTER,
 	       priv->base + IFI_CANFD_INTERRUPT);
 	writel(IFI_CANFD_ERROR_CTR_ER_ENABLE, priv->base + IFI_CANFD_ERROR_CTR);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
 }
 
@@ -521,11 +521,11 @@ static int ifi_canfd_handle_state_change(struct net_device *ndev,
 	default:
 		break;
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
 }
 
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 6a21af05ba27..2a6c918186c0 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -914,14 +914,14 @@ static void ican3_to_can_frame(struct ican3_dev *mod,
 		if (desc->data[1] & ICAN3_SFF_RTR)
 			cf->can_id |= CAN_RTR_FLAG;
 
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
 
 		if (desc->data[0] & ICAN3_EFF) {
 			cf->can_id |= CAN_EFF_FLAG;
@@ -932,11 +932,11 @@ static void ican3_to_can_frame(struct ican3_dev *mod,
 		} else {
 			cf->can_id |= desc->data[2] << 3;  /* 10-3  */
 			cf->can_id |= desc->data[3] >> 5;  /* 2-0   */
 		}
 
-		memcpy(cf->data, &desc->data[6], cf->can_dlc);
+		memcpy(cf->data, &desc->data[6], cf->len);
 	}
 }
 
 static void can_frame_to_ican3(struct ican3_dev *mod,
 			       struct can_frame *cf,
@@ -945,11 +945,11 @@ static void can_frame_to_ican3(struct ican3_dev *mod,
 	/* clear out any stale data in the descriptor */
 	memset(desc->data, 0, sizeof(desc->data));
 
 	/* we always use the extended format, with the ECHO flag set */
 	desc->command = ICAN3_CAN_TYPE_EFF;
-	desc->data[0] |= cf->can_dlc;
+	desc->data[0] |= cf->len;
 	desc->data[1] |= ICAN3_ECHO;
 
 	/* support single transmission (no retries) mode */
 	if (mod->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
 		desc->data[1] |= ICAN3_SNGL;
@@ -968,11 +968,11 @@ static void can_frame_to_ican3(struct ican3_dev *mod,
 		desc->data[2] = (cf->can_id & 0x7F8) >> 3; /* bits 10-3 */
 		desc->data[3] = (cf->can_id & 0x007) << 5; /* bits 2-0  */
 	}
 
 	/* copy the data bits into the descriptor */
-	memcpy(&desc->data[6], cf->data, cf->can_dlc);
+	memcpy(&desc->data[6], cf->data, cf->len);
 }
 
 /*
  * Interrupt Handling
  */
@@ -1292,11 +1292,11 @@ static unsigned int ican3_get_echo_skb(struct ican3_dev *mod)
 		netdev_err(mod->ndev, "BUG: echo skb not occupied\n");
 		return 0;
 	}
 
 	cf = (struct can_frame *)skb->data;
-	dlc = cf->can_dlc;
+	dlc = cf->len;
 
 	/* check flag whether this packet has to be looped back */
 	if (skb->pkt_type != PACKET_LOOPBACK) {
 		kfree_skb(skb);
 		return dlc;
@@ -1330,14 +1330,14 @@ static bool ican3_echo_skb_matches(struct ican3_dev *mod, struct sk_buff *skb)
 
 	echo_cf = (struct can_frame *)echo_skb->data;
 	if (cf->can_id != echo_cf->can_id)
 		return false;
 
-	if (cf->can_dlc != echo_cf->can_dlc)
+	if (cf->len != echo_cf->len)
 		return false;
 
-	return memcmp(cf->data, echo_cf->data, cf->can_dlc) == 0;
+	return memcmp(cf->data, echo_cf->data, cf->len) == 0;
 }
 
 /*
  * Check that there is room in the TX ring to transmit another skb
  *
@@ -1419,11 +1419,11 @@ static int ican3_recv_skb(struct ican3_dev *mod)
 		goto err_noalloc;
 	}
 
 	/* update statistics, receive the skb */
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 err_noalloc:
 	/* toggle the valid bit and return the descriptor to the ring */
 	desc.control ^= DESC_VALID;
diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 6f766918211a..8b5f75209b09 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1297,11 +1297,11 @@ static int kvaser_pciefd_rx_error_frame(struct kvaser_pciefd_can *can,
 
 	cf->data[6] = bec.txerr;
 	cf->data[7] = bec.rxerr;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 
 	netif_rx(skb);
 	return 0;
 }
 
@@ -1496,11 +1496,11 @@ static void kvaser_pciefd_handle_nack_packet(struct kvaser_pciefd_can *can,
 		cf->can_id |= CAN_ERR_ACK;
 	}
 
 	if (skb) {
 		cf->can_id |= CAN_ERR_BUSERROR;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		stats->rx_packets++;
 		netif_rx(skb);
 	} else {
 		stats->rx_dropped++;
 		netdev_warn(can->can.dev, "No memory left for err_skb\n");
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index ca040de8f909..e753c5f636bb 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -594,11 +594,11 @@ static int m_can_handle_lec_err(struct net_device *dev,
 	default:
 		break;
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
 }
 
@@ -721,11 +721,11 @@ static int m_can_handle_state_change(struct net_device *dev,
 	default:
 		break;
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_receive_skb(skb);
 
 	return 1;
 }
 
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index 95bf7338b358..5ed00a1558e1 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -248,20 +248,20 @@ static netdev_tx_t mscan_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (!rtr) {
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
 	out_8(&regs->cantflg, 1 << buf_id);
 
@@ -310,23 +310,23 @@ static void mscan_get_rx_frame(struct net_device *dev, struct can_frame *frame)
 
 	frame->can_id |= can_id >> 1;
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
 }
 
@@ -370,11 +370,11 @@ static void mscan_get_err_frame(struct net_device *dev, struct can_frame *frame,
 			}
 			can_bus_off(dev);
 		}
 	}
 	priv->shadow_statflg = canrflg & MSCAN_STAT_MSK;
-	frame->can_dlc = CAN_ERR_DLC;
+	frame->len = CAN_ERR_DLC;
 	out_8(&regs->canrflg, MSCAN_ERR_IF);
 }
 
 static int mscan_rx_poll(struct napi_struct *napi, int quota)
 {
@@ -405,11 +405,11 @@ static int mscan_rx_poll(struct napi_struct *napi, int quota)
 			mscan_get_rx_frame(dev, frame);
 		else if (canrflg & MSCAN_ERR_IF)
 			mscan_get_err_frame(dev, frame, canrflg);
 
 		stats->rx_packets++;
-		stats->rx_bytes += frame->can_dlc;
+		stats->rx_bytes += frame->len;
 		work_done++;
 		netif_receive_skb(skb);
 	}
 
 	if (work_done < quota) {
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 9509bac8352d..4f9e7ec192aa 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -561,11 +561,11 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 
 	priv->can.state = state;
 	netif_receive_skb(skb);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 }
 
 static irqreturn_t pch_can_interrupt(int irq, void *dev_id)
 {
 	struct net_device *ndev = (struct net_device *)dev_id;
@@ -681,24 +681,24 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 		}
 
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
 		}
 
 		netif_receive_skb(skb);
 		rcv_pkts++;
 		stats->rx_packets++;
 		quota--;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 
 		pch_fifo_thresh(priv, obj_num);
 		obj_num++;
 	} while (quota > 0);
 
@@ -917,19 +917,19 @@ static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
 		id2 |= PCH_ID2_DIR;
 
 	iowrite32(id2, &priv->regs->ifregs[1].id2);
 
 	/* Copy data to register */
-	for (i = 0; i < cf->can_dlc; i += 2) {
+	for (i = 0; i < cf->len; i += 2) {
 		iowrite16(cf->data[i] | (cf->data[i + 1] << 8),
 			  &priv->regs->ifregs[1].data[i / 2]);
 	}
 
 	can_put_echo_skb(skb, ndev, tx_obj_no - PCH_RX_OBJ_END - 1);
 
 	/* Set the size of the data. Update if2_mcont */
-	iowrite32(cf->can_dlc | PCH_IF_MCONT_NEWDAT | PCH_IF_MCONT_TXRQXT |
+	iowrite32(cf->len | PCH_IF_MCONT_NEWDAT | PCH_IF_MCONT_TXRQXT |
 		  PCH_IF_MCONT_TXIE, &priv->regs->ifregs[1].mcont);
 
 	pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, tx_obj_no);
 
 	return NETDEV_TX_OK;
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index c6077e07214e..fff3a35276aa 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -408,11 +408,11 @@ static int pucan_handle_status(struct peak_canfd_priv *priv,
 		stats->rx_dropped++;
 		return -ENOMEM;
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	pucan_netif_rx(skb, msg->ts_low, msg->ts_high);
 
 	return 0;
 }
 
@@ -436,11 +436,11 @@ static int pucan_handle_cache_critical(struct peak_canfd_priv *priv)
 	cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 
 	cf->data[6] = priv->bec.txerr;
 	cf->data[7] = priv->bec.rxerr;
 
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	stats->rx_packets++;
 	netif_rx(skb);
 
 	return 0;
 }
@@ -650,11 +650,11 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 	struct pucan_tx_msg *msg;
 	u16 msg_size, msg_flags;
 	unsigned long flags;
 	bool should_stop_tx_queue;
 	int room_left;
-	u8 can_dlc;
+	u8 len;
 
 	if (can_dropped_invalid_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
 	msg_size = ALIGN(sizeof(*msg) + cf->len, 4);
@@ -680,22 +680,22 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 		msg->can_id = cpu_to_le32(cf->can_id & CAN_SFF_MASK);
 	}
 
 	if (can_is_canfd_skb(skb)) {
 		/* CAN FD frame format */
-		can_dlc = can_len2dlc(cf->len);
+		len = can_len2dlc(cf->len);
 
 		msg_flags |= PUCAN_MSG_EXT_DATA_LEN;
 
 		if (cf->flags & CANFD_BRS)
 			msg_flags |= PUCAN_MSG_BITRATE_SWITCH;
 
 		if (cf->flags & CANFD_ESI)
 			msg_flags |= PUCAN_MSG_ERROR_STATE_IND;
 	} else {
 		/* CAN 2.0 frame format */
-		can_dlc = cf->len;
+		len = cf->len;
 
 		if (cf->can_id & CAN_RTR_FLAG)
 			msg_flags |= PUCAN_MSG_RTR;
 	}
 
@@ -705,11 +705,11 @@ static netdev_tx_t peak_canfd_start_xmit(struct sk_buff *skb,
 	/* set driver specific bit to differentiate with application loopback */
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
 		msg_flags |= PUCAN_MSG_SELF_RECEIVE;
 
 	msg->flags = cpu_to_le16(msg_flags);
-	msg->channel_dlc = PUCAN_MSG_CHANNEL_DLC(priv->index, can_dlc);
+	msg->channel_dlc = PUCAN_MSG_CHANNEL_DLC(priv->index, len);
 	memcpy(msg->d, cf->data, cf->len);
 
 	/* struct msg client field is used as an index in the echo skbs ring */
 	msg->client = priv->echo_idx;
 
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 711ef4996b48..c803327f8f79 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -362,11 +362,11 @@ static void rcar_can_error(struct net_device *ndev)
 		}
 	}
 
 	if (skb) {
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	}
 }
 
 static void rcar_can_tx_done(struct net_device *ndev)
@@ -605,20 +605,20 @@ static netdev_tx_t rcar_can_start_xmit(struct sk_buff *skb,
 		data = (cf->can_id & CAN_SFF_MASK) << RCAR_CAN_SID_SHIFT;
 
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
 	 * the CPU-side pointer for the transmit FIFO to the next
 	 * mailbox location
@@ -657,22 +657,22 @@ static void rcar_can_rx_pkt(struct rcar_can_priv *priv)
 		cf->can_id = (data & CAN_EFF_MASK) | CAN_EFF_FLAG;
 	else
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
 
 static int rcar_can_rx_poll(struct napi_struct *napi, int quota)
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 899a3218ce5e..86c6cbdb7e53 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1023,11 +1023,11 @@ static void rcar_canfd_error(struct net_device *ndev, u32 cerfl,
 
 	/* Clear channel error interrupts that are handled */
 	rcar_canfd_write(priv->base, RCANFD_CERFL(ch),
 			 RCANFD_CERFL_ERR(~cerfl));
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
 static void rcar_canfd_tx_done(struct net_device *ndev)
 {
@@ -1132,11 +1132,11 @@ static void rcar_canfd_state_change(struct net_device *ndev,
 		tx_state = txerr >= rxerr ? state : 0;
 		rx_state = txerr <= rxerr ? state : 0;
 
 		can_change_state(ndev, cf, tx_state, rx_state);
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	}
 }
 
 static irqreturn_t rcar_canfd_channel_interrupt(int irq, void *dev_id)
diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 6e95193b215b..450c5cfcb3fc 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -53,11 +53,11 @@ static int can_rx_offload_napi_poll(struct napi_struct *napi, int quota)
 	       (skb = skb_dequeue(&offload->skb_queue))) {
 		struct can_frame *cf = (struct can_frame *)skb->data;
 
 		work_done++;
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_receive_skb(skb);
 	}
 
 	if (work_done < quota) {
 		napi_complete_done(napi, work_done);
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 1f188f2d126e..d55394aa0b95 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -293,11 +293,11 @@ static netdev_tx_t sja1000_start_xmit(struct sk_buff *skb,
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
 
-	fi = dlc = cf->can_dlc;
+	fi = dlc = cf->len;
 	id = cf->can_id;
 
 	if (id & CAN_RTR_FLAG)
 		fi |= SJA1000_FI_RTR;
 
@@ -365,25 +365,25 @@ static void sja1000_rx(struct net_device *dev)
 		dreg = SJA1000_SFF_BUF;
 		id = (priv->read_reg(priv, SJA1000_ID1) << 3)
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
 
 	cf->can_id = id;
 
 	/* release receive buffer */
 	sja1000_write_cmdreg(priv, CMD_RRB);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
@@ -488,11 +488,11 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 		if(state == CAN_STATE_BUS_OFF)
 			can_bus_off(dev);
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	return 0;
 }
 
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index b4a39f0449ba..a1bd1be09548 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -104,12 +104,12 @@ static struct net_device **slcan_devs;
   *			SLCAN ENCAPSULATION FORMAT			 *
   ************************************************************************/
 
 /*
  * A CAN frame has a can_id (11 bit standard frame format OR 29 bit extended
- * frame format) a data length code (can_dlc) which can be from 0 to 8
- * and up to <can_dlc> data bytes as payload.
+ * frame format) a data length code (len) which can be from 0 to 8
+ * and up to <len> data bytes as payload.
  * Additionally a CAN frame may become a remote transmission frame if the
  * RTR-bit is set. This causes another ECU to send a CAN frame with the
  * given can_id.
  *
  * The SLCAN ASCII representation of these different frame types is:
@@ -126,14 +126,14 @@ static struct net_device **slcan_devs;
  * The <dlc> is a one byte ASCII number ('0' - '8')
  * The <data> section has at much ASCII Hex bytes as defined by the <dlc>
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
 
  /************************************************************************
   *			STANDARD SLCAN DECAPSULATION			 *
@@ -154,22 +154,22 @@ static void slc_bump(struct slcan *sl)
 	case 'r':
 		cf.can_id = CAN_RTR_FLAG;
 		fallthrough;
 	case 't':
 		/* store dlc ASCII value and terminate SFF CAN ID string */
-		cf.can_dlc = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
+		cf.len = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
 		sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
 		cmd += SLC_CMD_LEN + SLC_SFF_ID_LEN + 1;
 		break;
 	case 'R':
 		cf.can_id = CAN_RTR_FLAG;
 		fallthrough;
 	case 'T':
 		cf.can_id |= CAN_EFF_FLAG;
 		/* store dlc ASCII value and terminate EFF CAN ID string */
-		cf.can_dlc = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
+		cf.len = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
 		sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
 		cmd += SLC_CMD_LEN + SLC_EFF_ID_LEN + 1;
 		break;
 	default:
@@ -179,19 +179,19 @@ static void slc_bump(struct slcan *sl)
 	if (kstrtou32(sl->rbuff + SLC_CMD_LEN, 16, &tmpid))
 		return;
 
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
 			cf.data[i] = (tmp << 4);
 			tmp = hex_to_bin(*cmd++);
@@ -216,11 +216,11 @@ static void slc_bump(struct slcan *sl)
 	can_skb_prv(skb)->skbcnt = 0;
 
 	skb_put_data(skb, &cf, sizeof(struct can_frame));
 
 	sl->dev->stats.rx_packets++;
-	sl->dev->stats.rx_bytes += cf.can_dlc;
+	sl->dev->stats.rx_bytes += cf.len;
 	netif_rx_ni(skb);
 }
 
 /* parse tty input stream */
 static void slcan_unesc(struct slcan *sl, unsigned char s)
@@ -280,15 +280,15 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 		id >>= 4;
 	}
 
 	pos += (cf->can_id & CAN_EFF_FLAG) ? SLC_EFF_ID_LEN : SLC_SFF_ID_LEN;
 
-	*pos++ = cf->can_dlc + '0';
+	*pos++ = cf->len + '0';
 
 	/* RTR frames may have a dlc > 0 but they never have any data bytes */
 	if (!(cf->can_id & CAN_RTR_FLAG)) {
-		for (i = 0; i < cf->can_dlc; i++)
+		for (i = 0; i < cf->len; i++)
 			pos = hex_byte_pack_upper(pos, cf->data[i]);
 	}
 
 	*pos++ = '\r';
 
@@ -302,11 +302,11 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 	 */
 	set_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 	actual = sl->tty->ops->write(sl->tty, sl->xbuff, pos - sl->xbuff);
 	sl->xleft = (pos - sl->xbuff) - actual;
 	sl->xhead = sl->xbuff + actual;
-	sl->dev->stats.tx_bytes += cf->can_dlc;
+	sl->dev->stats.tx_bytes += cf->len;
 }
 
 /* Write out any remaining transmit buffer. Scheduled when tty is writable */
 static void slcan_transmit(struct work_struct *work)
 {
diff --git a/drivers/net/can/softing/softing_fw.c b/drivers/net/can/softing/softing_fw.c
index ccd649a8e37b..7e1536877993 100644
--- a/drivers/net/can/softing/softing_fw.c
+++ b/drivers/net/can/softing/softing_fw.c
@@ -622,11 +622,11 @@ int softing_startstop(struct net_device *dev, int up)
 	 * from here, no errors should occur, or the failed: part
 	 * must be reviewed
 	 */
 	memset(&msg, 0, sizeof(msg));
 	msg.can_id = CAN_ERR_FLAG | CAN_ERR_RESTARTED;
-	msg.can_dlc = CAN_ERR_DLC;
+	msg.len = CAN_ERR_DLC;
 	for (j = 0; j < ARRAY_SIZE(card->net); ++j) {
 		if (!(bus_bitmask_start & (1 << j)))
 			continue;
 		netdev = card->net[j];
 		if (!netdev)
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index 39e8275ee7ba..03a68bb486fd 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -82,22 +82,22 @@ static netdev_tx_t softing_netdev_start_xmit(struct sk_buff *skb,
 	if (cf->can_id & CAN_EFF_FLAG)
 		*ptr |= CMD_XTD;
 	if (priv->index)
 		*ptr |= CMD_BUS2;
 	++ptr;
-	*ptr++ = cf->can_dlc;
+	*ptr++ = cf->len;
 	*ptr++ = (cf->can_id >> 0);
 	*ptr++ = (cf->can_id >> 8);
 	if (cf->can_id & CAN_EFF_FLAG) {
 		*ptr++ = (cf->can_id >> 16);
 		*ptr++ = (cf->can_id >> 24);
 	} else {
 		/* increment 1, not 2 as you might think */
 		ptr += 1;
 	}
 	if (!(cf->can_id & CAN_RTR_FLAG))
-		memcpy(ptr, &cf->data[0], cf->can_dlc);
+		memcpy(ptr, &cf->data[0], cf->len);
 	memcpy_toio(&card->dpram[DPRAM_TX + DPRAM_TX_SIZE * fifo_wr],
 			buf, DPRAM_TX_SIZE);
 	if (++fifo_wr >= DPRAM_TX_CNT)
 		fifo_wr = 0;
 	iowrite8(fifo_wr, &card->dpram[DPRAM_TX_WR]);
@@ -165,11 +165,11 @@ static int softing_handle_1(struct softing *card)
 		int j;
 		/* reset condition */
 		iowrite8(0, &card->dpram[DPRAM_RX_LOST]);
 		/* prepare msg */
 		msg.can_id = CAN_ERR_FLAG | CAN_ERR_CRTL;
-		msg.can_dlc = CAN_ERR_DLC;
+		msg.len = CAN_ERR_DLC;
 		msg.data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 		/*
 		 * service to all buses, we don't know which it was applicable
 		 * but only service buses that are online
 		 */
@@ -216,11 +216,11 @@ static int softing_handle_1(struct softing *card)
 		uint8_t can_state, state;
 
 		state = *ptr++;
 
 		msg.can_id = CAN_ERR_FLAG;
-		msg.can_dlc = CAN_ERR_DLC;
+		msg.len = CAN_ERR_DLC;
 
 		if (state & SF_MASK_BUSOFF) {
 			can_state = CAN_STATE_BUS_OFF;
 			msg.can_id |= CAN_ERR_BUSOFF;
 			state = STATE_BUSOFF;
@@ -259,11 +259,11 @@ static int softing_handle_1(struct softing *card)
 		}
 
 	} else {
 		if (cmd & CMD_RTR)
 			msg.can_id |= CAN_RTR_FLAG;
-		msg.can_dlc = can_cc_dlc2len(*ptr++);
+		msg.len = can_cc_dlc2len(*ptr++);
 		if (cmd & CMD_XTD) {
 			msg.can_id |= CAN_EFF_FLAG;
 			msg.can_id |= le32_to_cpup((void *)ptr);
 			ptr += 4;
 		} else {
@@ -292,19 +292,19 @@ static int softing_handle_1(struct softing *card)
 				--priv->tx.pending;
 			if (card->tx.pending)
 				--card->tx.pending;
 			++netdev->stats.tx_packets;
 			if (!(msg.can_id & CAN_RTR_FLAG))
-				netdev->stats.tx_bytes += msg.can_dlc;
+				netdev->stats.tx_bytes += msg.len;
 		} else {
 			int ret;
 
 			ret = softing_netdev_rx(netdev, &msg, ktime);
 			if (ret == NET_RX_SUCCESS) {
 				++netdev->stats.rx_packets;
 				if (!(msg.can_id & CAN_RTR_FLAG))
-					netdev->stats.rx_bytes += msg.can_dlc;
+					netdev->stats.rx_bytes += msg.len;
 			} else {
 				++netdev->stats.rx_dropped;
 			}
 		}
 	}
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 728f34b696a7..f9455de94786 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -275,31 +275,31 @@ static void hi3110_hw_tx(struct spi_device *spi, struct can_frame *frame)
 			(frame->can_id & CAN_EFF_MASK) >> 7;
 		buf[HI3110_FIFO_ID_OFF + 3] =
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
 		buf[HI3110_FIFO_ID_OFF + 1] =
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
 
 static void hi3110_hw_rx_frame(struct spi_device *spi, u8 *buf)
 {
@@ -339,20 +339,20 @@ static void hi3110_hw_rx(struct spi_device *spi)
 			(buf[HI3110_FIFO_WOTIME_ID_OFF] << 3) |
 			((buf[HI3110_FIFO_WOTIME_ID_OFF + 1] & 0xE0) >> 5);
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
 
 	netif_rx_ni(skb);
 }
@@ -583,11 +583,11 @@ static void hi3110_tx_work_handler(struct work_struct *ws)
 		if (priv->can.state == CAN_STATE_BUS_OFF) {
 			hi3110_clean(net);
 		} else {
 			frame = (struct can_frame *)priv->tx_skb->data;
 			hi3110_hw_tx(spi, frame);
-			priv->tx_len = 1 + frame->can_dlc;
+			priv->tx_len = 1 + frame->len;
 			can_put_echo_skb(priv->tx_skb, net, 0);
 			priv->tx_skb = NULL;
 		}
 	}
 	mutex_unlock(&priv->hi3110_lock);
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 6ddebb1c4a24..25859d16d06f 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -642,13 +642,13 @@ static void mcp251x_hw_tx(struct spi_device *spi, struct can_frame *frame,
 	buf[TXBSIDL_OFF] = ((sid & SIDL_SID_MASK) << SIDL_SID_SHIFT) |
 		(exide << SIDL_EXIDE_SHIFT) |
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
 	mcp251x_spi_trans(priv->spi, 1);
 }
@@ -718,15 +718,15 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
 			(buf[RXBSIDL_OFF] >> RXBSIDL_SHIFT);
 		if (buf[RXBSIDL_OFF] & RXBSIDL_SRR)
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
 
 	netif_rx_ni(skb);
 }
@@ -996,14 +996,14 @@ static void mcp251x_tx_work_handler(struct work_struct *ws)
 		if (priv->can.state == CAN_STATE_BUS_OFF) {
 			mcp251x_clean(net);
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
 	}
 	mutex_unlock(&priv->mcp_lock);
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 0e2569779895..098cc9670f0f 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -422,11 +422,11 @@ static netdev_tx_t sun4ican_start_xmit(struct sk_buff *skb, struct net_device *d
 		return NETDEV_TX_OK;
 
 	netif_stop_queue(dev);
 
 	id = cf->can_id;
-	dlc = cf->can_dlc;
+	dlc = cf->len;
 	msg_flag_n = dlc;
 
 	if (id & CAN_RTR_FLAG)
 		msg_flag_n |= SUN4I_MSG_RTR_FLAG;
 
@@ -473,11 +473,11 @@ static void sun4i_can_rx(struct net_device *dev)
 	skb = alloc_can_skb(dev, &cf);
 	if (!skb)
 		return;
 
 	fi = readl(priv->base + SUN4I_REG_BUF0_ADDR);
-	cf->can_dlc = can_cc_dlc2len(fi & 0x0F);
+	cf->len = can_cc_dlc2len(fi & 0x0F);
 	if (fi & SUN4I_MSG_EFF_FLAG) {
 		dreg = SUN4I_REG_BUF5_ADDR;
 		id = (readl(priv->base + SUN4I_REG_BUF1_ADDR) << 21) |
 		     (readl(priv->base + SUN4I_REG_BUF2_ADDR) << 13) |
 		     (readl(priv->base + SUN4I_REG_BUF3_ADDR) << 5)  |
@@ -491,19 +491,19 @@ static void sun4i_can_rx(struct net_device *dev)
 
 	/* remote frame ? */
 	if (fi & SUN4I_MSG_RTR_FLAG)
 		id |= CAN_RTR_FLAG;
 	else
-		for (i = 0; i < cf->can_dlc; i++)
+		for (i = 0; i < cf->len; i++)
 			cf->data[i] = readl(priv->base + dreg + i * 4);
 
 	cf->can_id = id;
 
 	sun4i_can_write_cmdreg(priv, SUN4I_CMD_RELEASE_RBUF);
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
@@ -623,11 +623,11 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 			can_bus_off(dev);
 	}
 
 	if (likely(skb)) {
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	} else {
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 060ce0b16cdc..16cf5ded781f 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -494,11 +494,11 @@ static netdev_tx_t ti_hecc_xmit(struct sk_buff *skb, struct net_device *ndev)
 		return NETDEV_TX_BUSY;
 	}
 	spin_unlock_irqrestore(&priv->mbx_lock, flags);
 
 	/* Prepare mailbox for transmission */
-	data = cf->can_dlc | (get_tx_head_prio(priv) << 8);
+	data = cf->len | (get_tx_head_prio(priv) << 8);
 	if (cf->can_id & CAN_RTR_FLAG) /* Remote transmission request */
 		data |= HECC_CANMCF_RTR;
 	hecc_write_mbx(priv, mbxno, HECC_CANMCF, data);
 
 	if (cf->can_id & CAN_EFF_FLAG) /* Extended frame format */
@@ -506,11 +506,11 @@ static netdev_tx_t ti_hecc_xmit(struct sk_buff *skb, struct net_device *ndev)
 	else /* Standard frame format */
 		data = (cf->can_id & CAN_SFF_MASK) << 18;
 	hecc_write_mbx(priv, mbxno, HECC_CANMID, data);
 	hecc_write_mbx(priv, mbxno, HECC_CANMDL,
 		       be32_to_cpu(*(__be32 *)(cf->data)));
-	if (cf->can_dlc > 4)
+	if (cf->len > 4)
 		hecc_write_mbx(priv, mbxno, HECC_CANMDH,
 			       be32_to_cpu(*(__be32 *)(cf->data + 4)));
 	else
 		*(u32 *)(cf->data + 4) = 0;
 	can_put_echo_skb(skb, ndev, mbxno);
@@ -564,15 +564,15 @@ static struct sk_buff *ti_hecc_mailbox_read(struct can_rx_offload *offload,
 		cf->can_id = (data >> 18) & CAN_SFF_MASK;
 
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
 
 	*timestamp = hecc_read_stamp(priv, mbxno);
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 288781934149..25eee4466364 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -304,26 +304,26 @@ static void ems_usb_rx_can_msg(struct ems_usb *dev, struct ems_cpc_msg *msg)
 	skb = alloc_can_skb(dev->netdev, &cf);
 	if (skb == NULL)
 		return;
 
 	cf->can_id = le32_to_cpu(msg->msg.can_msg.id);
-	cf->can_dlc = can_cc_dlc2len(msg->msg.can_msg.length & 0xF);
+	cf->len = can_cc_dlc2len(msg->msg.can_msg.length & 0xF);
 
 	if (msg->type == CPC_MSG_TYPE_EXT_CAN_FRAME ||
 	    msg->type == CPC_MSG_TYPE_EXT_RTR_FRAME)
 		cf->can_id |= CAN_EFF_FLAG;
 
 	if (msg->type == CPC_MSG_TYPE_RTR_FRAME ||
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
 
 static void ems_usb_rx_err(struct ems_usb *dev, struct ems_cpc_msg *msg)
 {
@@ -394,11 +394,11 @@ static void ems_usb_rx_err(struct ems_usb *dev, struct ems_cpc_msg *msg)
 		stats->rx_over_errors++;
 		stats->rx_errors++;
 	}
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
 /*
  * callback for bulk IN urb
@@ -753,25 +753,25 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 	}
 
 	msg = (struct ems_cpc_msg *)&buf[CPC_HEADER_SIZE];
 
 	msg->msg.can_msg.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
-	msg->msg.can_msg.length = cf->can_dlc;
+	msg->msg.can_msg.length = cf->len;
 
 	if (cf->can_id & CAN_RTR_FLAG) {
 		msg->type = cf->can_id & CAN_EFF_FLAG ?
 			CPC_CMD_TYPE_EXT_RTR_FRAME : CPC_CMD_TYPE_RTR_FRAME;
 
 		msg->length = CPC_CAN_MSG_MIN_SIZE;
 	} else {
 		msg->type = cf->can_id & CAN_EFF_FLAG ?
 			CPC_CMD_TYPE_EXT_CAN_FRAME : CPC_CMD_TYPE_CAN_FRAME;
 
-		for (i = 0; i < cf->can_dlc; i++)
+		for (i = 0; i < cf->len; i++)
 			msg->msg.can_msg.msg[i] = cf->data[i];
 
-		msg->length = CPC_CAN_MSG_MIN_SIZE + cf->can_dlc;
+		msg->length = CPC_CAN_MSG_MIN_SIZE + cf->len;
 	}
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
 		if (dev->tx_contexts[i].echo_index == MAX_TX_URBS) {
 			context = &dev->tx_contexts[i];
@@ -792,11 +792,11 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 		return NETDEV_TX_BUSY;
 	}
 
 	context->dev = dev;
 	context->echo_index = i;
-	context->dlc = cf->can_dlc;
+	context->dlc = cf->len;
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
 			  size, ems_usb_write_bulk_callback, context);
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &dev->tx_submitted);
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 72999de550d1..3643a8ee03cf 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -290,11 +290,11 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 
 		priv->bec.txerr = txerr;
 		priv->bec.rxerr = rxerr;
 
 		stats->rx_packets++;
-		stats->rx_bytes += cf->can_dlc;
+		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	}
 }
 
 static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
@@ -319,24 +319,24 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 			stats->rx_dropped++;
 			return;
 		}
 
 		cf->can_id = id & ESD_IDMASK;
-		cf->can_dlc = can_cc_dlc2len(msg->msg.rx.dlc & ~ESD_RTR);
+		cf->len = can_cc_dlc2len(msg->msg.rx.dlc & ~ESD_RTR);
 
 		if (id & ESD_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
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
 
 	return;
 }
@@ -735,23 +735,23 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 	msg = (struct esd_usb2_msg *)buf;
 
 	msg->msg.hdr.len = 3; /* minimal length */
 	msg->msg.hdr.cmd = CMD_CAN_TX;
 	msg->msg.tx.net = priv->index;
-	msg->msg.tx.dlc = cf->can_dlc;
+	msg->msg.tx.dlc = cf->len;
 	msg->msg.tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
 
 	if (cf->can_id & CAN_RTR_FLAG)
 		msg->msg.tx.dlc |= ESD_RTR;
 
 	if (cf->can_id & CAN_EFF_FLAG)
 		msg->msg.tx.id |= cpu_to_le32(ESD_EXTID);
 
-	for (i = 0; i < cf->can_dlc; i++)
+	for (i = 0; i < cf->len; i++)
 		msg->msg.tx.data[i] = cf->data[i];
 
-	msg->msg.hdr.len += (cf->can_dlc + 3) >> 2;
+	msg->msg.hdr.len += (cf->len + 3) >> 2;
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
 		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
 			context = &priv->tx_contexts[i];
 			break;
@@ -767,11 +767,11 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 		goto releasebuf;
 	}
 
 	context->priv = priv;
 	context->echo_index = i;
-	context->dlc = cf->can_dlc;
+	context->dlc = cf->len;
 
 	/* hnd must not be 0 - MSB is stripped in txdone handling */
 	msg->msg.tx.hnd = 0x80000000 | i; /* returned in TX done message */
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index b1729b208788..940589667a7f 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -133,11 +133,11 @@ struct gs_device_bt_const {
 
 struct gs_host_frame {
 	u32 echo_id;
 	u32 can_id;
 
-	u8 can_dlc;
+	u8 len;
 	u8 channel;
 	u8 flags;
 	u8 reserved;
 
 	u8 data[8];
@@ -329,19 +329,19 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		if (!skb)
 			return;
 
 		cf->can_id = hf->can_id;
 
-		cf->can_dlc = can_cc_dlc2len(hf->can_dlc);
+		cf->len = can_cc_dlc2len(hf->len);
 		memcpy(cf->data, hf->data, 8);
 
 		/* ERROR frames tell us information about the controller */
 		if (hf->can_id & CAN_ERR_FLAG)
 			gs_update_state(dev, cf);
 
 		netdev->stats.rx_packets++;
-		netdev->stats.rx_bytes += hf->can_dlc;
+		netdev->stats.rx_bytes += hf->len;
 
 		netif_rx(skb);
 	} else { /* echo_id == hf->echo_id */
 		if (hf->echo_id >= GS_MAX_TX_URBS) {
 			netdev_err(netdev,
@@ -349,11 +349,11 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 				   hf->echo_id);
 			goto resubmit_urb;
 		}
 
 		netdev->stats.tx_packets++;
-		netdev->stats.tx_bytes += hf->can_dlc;
+		netdev->stats.tx_bytes += hf->len;
 
 		txc = gs_get_tx_context(dev, hf->echo_id);
 
 		/* bad devices send bad echo_ids. */
 		if (!txc) {
@@ -376,11 +376,11 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		skb = alloc_can_err_skb(netdev, &cf);
 		if (!skb)
 			goto resubmit_urb;
 
 		cf->can_id |= CAN_ERR_CRTL;
-		cf->can_dlc = CAN_ERR_DLC;
+		cf->len = CAN_ERR_DLC;
 		cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 		stats->rx_over_errors++;
 		stats->rx_errors++;
 		netif_rx(skb);
 	}
@@ -502,12 +502,12 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	hf->channel = dev->channel;
 
 	cf = (struct can_frame *)skb->data;
 
 	hf->can_id = cf->can_id;
-	hf->can_dlc = cf->can_dlc;
-	memcpy(hf->data, cf->data, cf->can_dlc);
+	hf->len = cf->len;
+	memcpy(hf->data, cf->data, cf->len);
 
 	usb_fill_bulk_urb(urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
 			  hf,
 			  sizeof(*hf),
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 0f1d3e807d63..d6e18bcb1a7f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -256,11 +256,11 @@ int kvaser_usb_can_rx_over_error(struct net_device *netdev)
 
 	cf->can_id |= CAN_ERR_CRTL;
 	cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	return 0;
 }
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 906a3a340131..fea87398e5b7 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -893,11 +893,11 @@ static void kvaser_usb_hydra_update_state(struct kvaser_usb_net_priv *priv,
 	cf->data[6] = bec->txerr;
 	cf->data[7] = bec->rxerr;
 
 	stats = &netdev->stats;
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
 static void kvaser_usb_hydra_state_event(const struct kvaser_usb *dev,
 					 const struct kvaser_cmd *cmd)
@@ -1047,11 +1047,11 @@ kvaser_usb_hydra_error_frame(struct kvaser_usb_net_priv *priv,
 	cf->can_id |= CAN_ERR_BUSERROR;
 	cf->data[6] = bec.txerr;
 	cf->data[7] = bec.rxerr;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 
 	priv->bec.txerr = bec.txerr;
 	priv->bec.rxerr = bec.rxerr;
 }
@@ -1082,11 +1082,11 @@ static void kvaser_usb_hydra_one_shot_fail(struct kvaser_usb_net_priv *priv,
 		priv->can.can_stats.arbitration_lost++;
 	}
 
 	stats->tx_errors++;
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
 static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 					    const struct kvaser_cmd *cmd)
@@ -1178,19 +1178,19 @@ static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
 	}
 
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
 
 static void kvaser_usb_hydra_rx_msg_ext(const struct kvaser_usb *dev,
 					const struct kvaser_cmd_ext *cmd)
@@ -1432,11 +1432,11 @@ kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
 	struct kvaser_cmd *cmd;
 	struct can_frame *cf = (struct can_frame *)skb->data;
 	u32 flags;
 	u32 id;
 
-	*frame_len = cf->can_dlc;
+	*frame_len = cf->len;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
 	if (!cmd)
 		return NULL;
 
@@ -1453,11 +1453,11 @@ kvaser_usb_hydra_frame_to_cmd_std(const struct kvaser_usb_net_priv *priv,
 		id |= KVASER_USB_HYDRA_EXTENDED_FRAME_ID;
 	} else {
 		id = cf->can_id & CAN_SFF_MASK;
 	}
 
-	cmd->tx_can.dlc = cf->can_dlc;
+	cmd->tx_can.dlc = cf->len;
 
 	flags = (cf->can_id & CAN_EFF_FLAG ?
 		 KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID : 0);
 
 	if (cf->can_id & CAN_RTR_FLAG)
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 916ab994cce4..98c016ef0607 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -348,11 +348,11 @@ kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd *cmd;
 	u8 *cmd_tx_can_flags = NULL;		/* GCC */
 	struct can_frame *cf = (struct can_frame *)skb->data;
 
-	*frame_len = cf->can_dlc;
+	*frame_len = cf->len;
 
 	cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
 	if (cmd) {
 		cmd->u.tx_can.tid = transid & 0xff;
 		cmd->len = *cmd_len = CMD_HEADER_LEN +
@@ -381,12 +381,12 @@ kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 			cmd->id = CMD_TX_STD_MESSAGE;
 			cmd->u.tx_can.data[0] = (cf->can_id >> 6) & 0x1f;
 			cmd->u.tx_can.data[1] = cf->can_id & 0x3f;
 		}
 
-		cmd->u.tx_can.data[5] = cf->can_dlc;
-		memcpy(&cmd->u.tx_can.data[6], cf->data, cf->can_dlc);
+		cmd->u.tx_can.data[5] = cf->len;
+		memcpy(&cmd->u.tx_can.data[6], cf->data, cf->len);
 
 		if (cf->can_id & CAN_RTR_FLAG)
 			*cmd_tx_can_flags |= MSG_FLAG_REMOTE_FRAME;
 	}
 	return cmd;
@@ -574,11 +574,11 @@ static void kvaser_usb_leaf_tx_acknowledge(const struct kvaser_usb *dev,
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb) {
 			cf->can_id |= CAN_ERR_RESTARTED;
 
 			stats->rx_packets++;
-			stats->rx_bytes += cf->can_dlc;
+			stats->rx_bytes += cf->len;
 			netif_rx(skb);
 		} else {
 			netdev_err(priv->netdev,
 				   "No memory left for err_skb\n");
 		}
@@ -692,11 +692,11 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 				     const struct kvaser_usb_err_summary *es)
 {
 	struct can_frame *cf;
 	struct can_frame tmp_cf = { .can_id = CAN_ERR_FLAG,
-				    .can_dlc = CAN_ERR_DLC };
+				    .len = CAN_ERR_DLC };
 	struct sk_buff *skb;
 	struct net_device_stats *stats;
 	struct kvaser_usb_net_priv *priv;
 	enum can_state old_state, new_state;
 
@@ -776,11 +776,11 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 
 	cf->data[6] = es->txerr;
 	cf->data[7] = es->rxerr;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
 /* For USBCAN, report error to userspace if the channels's errors counter
  * has changed, or we're the only channel seeing a bus error state.
@@ -976,17 +976,17 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 		if (cf->can_id & KVASER_EXTENDED_FRAME)
 			cf->can_id &= CAN_EFF_MASK | CAN_EFF_FLAG;
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
 
 		if (cmd->id == CMD_RX_EXT_MESSAGE) {
 			cf->can_id <<= 18;
@@ -994,20 +994,20 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 				      ((rx_data[3] & 0xff) << 6) |
 				      (rx_data[4] & 0x3f);
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
 
 static void kvaser_usb_leaf_start_chip_reply(const struct kvaser_usb *dev,
 					     const struct kvaser_cmd *cmd)
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 0e6d180597f3..2f2bd18d5a10 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -182,11 +182,11 @@ static inline struct mcba_usb_ctx *mcba_usb_get_free_ctx(struct mcba_priv *priv,
 			ctx = &priv->tx_context[i];
 			ctx->ndx = i;
 
 			if (cf) {
 				ctx->can = true;
-				ctx->dlc = cf->can_dlc;
+				ctx->dlc = cf->len;
 			} else {
 				ctx->can = false;
 				ctx->dlc = 0;
 			}
 
@@ -348,11 +348,11 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 		put_unaligned_be16((cf->can_id & CAN_SFF_MASK) << 5,
 				   &usb_msg.sid);
 		usb_msg.eid = 0;
 	}
 
-	usb_msg.dlc = cf->can_dlc;
+	usb_msg.dlc = cf->len;
 
 	memcpy(usb_msg.data, cf->data, usb_msg.dlc);
 
 	if (cf->can_id & CAN_RTR_FLAG)
 		usb_msg.dlc |= MCBA_DLC_RTR_MASK;
@@ -449,16 +449,16 @@ static void mcba_usb_process_can(struct mcba_priv *priv,
 	}
 
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
 }
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index f7fc82203489..ec34f87cc02c 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -594,11 +594,11 @@ static int pcan_usb_decode_error(struct pcan_usb_msg_context *mc, u8 n,
 		peak_usb_get_ts_time(&mc->pdev->time_ref, mc->ts16,
 				     &hwts->hwtstamp);
 	}
 
 	mc->netdev->stats.rx_packets++;
-	mc->netdev->stats.rx_bytes += cf->can_dlc;
+	mc->netdev->stats.rx_bytes += cf->len;
 	netif_rx(skb);
 
 	return 0;
 }
 
@@ -732,11 +732,11 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		mc->ptr += 2;
 
 		cf->can_id = le16_to_cpu(tmp16) >> 5;
 	}
 
-	cf->can_dlc = can_cc_dlc2len(rec_len);
+	cf->len = can_cc_dlc2len(rec_len);
 
 	/* Only first packet timestamp is a word */
 	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
 		goto decode_failed;
 
@@ -749,21 +749,21 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		cf->can_id |= CAN_RTR_FLAG;
 	} else {
 		if ((mc->ptr + rec_len) > mc->end)
 			goto decode_failed;
 
-		memcpy(cf->data, mc->ptr, cf->can_dlc);
+		memcpy(cf->data, mc->ptr, cf->len);
 		mc->ptr += rec_len;
 	}
 
 	/* convert timestamp into kernel time */
 	hwts = skb_hwtstamps(skb);
 	peak_usb_get_ts_time(&mc->pdev->time_ref, mc->ts16, &hwts->hwtstamp);
 
 	/* update statistics */
 	mc->netdev->stats.rx_packets++;
-	mc->netdev->stats.rx_bytes += cf->can_dlc;
+	mc->netdev->stats.rx_bytes += cf->len;
 	/* push the skb */
 	netif_rx(skb);
 
 	return 0;
 
@@ -836,11 +836,11 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 	obuf[1] = 1;
 
 	pc = obuf + PCAN_USB_MSG_HEADER_LEN;
 
 	/* status/len byte */
-	*pc = cf->can_dlc;
+	*pc = cf->len;
 	if (cf->can_id & CAN_RTR_FLAG)
 		*pc |= PCAN_USB_STATUSLEN_RTR;
 
 	/* can id */
 	if (cf->can_id & CAN_EFF_FLAG) {
@@ -856,12 +856,12 @@ static int pcan_usb_encode_msg(struct peak_usb_device *dev, struct sk_buff *skb,
 		pc += 2;
 	}
 
 	/* can data */
 	if (!(cf->can_id & CAN_RTR_FLAG)) {
-		memcpy(pc, cf->data, cf->can_dlc);
-		pc += cf->can_dlc;
+		memcpy(pc, cf->data, cf->len);
+		pc += cf->len;
 	}
 
 	obuf[(*size)-1] = (u8)(stats->tx_packets & 0xff);
 
 	return 0;
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 1233ef20646a..922280692a8f 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -579,11 +579,11 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 		return -ENOMEM;
 
 	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(sm->ts_low));
 
 	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += cf->can_dlc;
+	netdev->stats.rx_bytes += cf->len;
 
 	return 0;
 }
 
 /* handle uCAN error message */
@@ -735,11 +735,11 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 				  struct sk_buff *skb, u8 *obuf, size_t *size)
 {
 	struct pucan_tx_msg *tx_msg = (struct pucan_tx_msg *)obuf;
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	u16 tx_msg_size, tx_msg_flags;
-	u8 can_dlc;
+	u8 len;
 
 	if (cfd->len > CANFD_MAX_DLEN)
 		return -EINVAL;
 
 	tx_msg_size = ALIGN(sizeof(struct pucan_tx_msg) + cfd->len, 4);
@@ -754,29 +754,29 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 		tx_msg->can_id = cpu_to_le32(cfd->can_id & CAN_SFF_MASK);
 	}
 
 	if (can_is_canfd_skb(skb)) {
 		/* considering a CANFD frame */
-		can_dlc = can_len2dlc(cfd->len);
+		len = can_len2dlc(cfd->len);
 
 		tx_msg_flags |= PUCAN_MSG_EXT_DATA_LEN;
 
 		if (cfd->flags & CANFD_BRS)
 			tx_msg_flags |= PUCAN_MSG_BITRATE_SWITCH;
 
 		if (cfd->flags & CANFD_ESI)
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
 	 */
 	tx_msg = (struct pucan_tx_msg *)(obuf + tx_msg_size);
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index c7564773fb2b..275087c39602 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -530,26 +530,26 @@ static int pcan_usb_pro_handle_canmsg(struct pcan_usb_pro_interface *usb_if,
 	skb = alloc_can_skb(netdev, &can_frame);
 	if (!skb)
 		return -ENOMEM;
 
 	can_frame->can_id = le32_to_cpu(rx->id);
-	can_frame->can_dlc = rx->len & 0x0f;
+	can_frame->len = rx->len & 0x0f;
 
 	if (rx->flags & PCAN_USBPRO_EXT)
 		can_frame->can_id |= CAN_EFF_FLAG;
 
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
 }
 
@@ -660,11 +660,11 @@ static int pcan_usb_pro_handle_error(struct pcan_usb_pro_interface *usb_if,
 	dev->can.state = new_state;
 
 	hwts = skb_hwtstamps(skb);
 	peak_usb_get_ts_time(&usb_if->time_ref, le32_to_cpu(er->ts32), &hwts->hwtstamp);
 	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += can_frame->can_dlc;
+	netdev->stats.rx_bytes += can_frame->len;
 	netif_rx(skb);
 
 	return 0;
 }
 
@@ -765,18 +765,18 @@ static int pcan_usb_pro_encode_msg(struct peak_usb_device *dev,
 	u8 data_type, len, flags;
 	struct pcan_usb_pro_msg usb_msg;
 
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
 		flags |= 0x02;
 	if (cf->can_id & CAN_RTR_FLAG)
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 072058c6f6e8..7d92da8954fe 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -612,19 +612,19 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
 
 	/* fill the can frame */
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
 }
 
@@ -1076,19 +1076,19 @@ static struct urb *ucan_prepare_tx_urb(struct ucan_priv *up,
 
 	if (cf->can_id & CAN_RTR_FLAG) {
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
 
 	/* build the urb */
 	usb_fill_bulk_urb(urb, up->udev,
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 216c58f8df6e..6517aaeb4bc0 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -447,11 +447,11 @@ static void usb_8dev_rx_err_msg(struct usb_8dev_priv *priv,
 
 	priv->bec.txerr = txerr;
 	priv->bec.rxerr = rxerr;
 
 	stats->rx_packets++;
-	stats->rx_bytes += cf->can_dlc;
+	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
 /* Read data and status frames */
 static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
@@ -468,22 +468,22 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 		skb = alloc_can_skb(priv->netdev, &cf);
 		if (!skb)
 			return;
 
 		cf->can_id = be32_to_cpu(msg->id);
-		cf->can_dlc = can_cc_dlc2len(msg->dlc & 0xF);
+		cf->len = can_cc_dlc2len(msg->dlc & 0xF);
 
 		if (msg->flags & USB_8DEV_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
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
 	} else {
 		netdev_warn(priv->netdev, "frame type %d unknown",
@@ -635,12 +635,12 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 
 	if (cf->can_id & CAN_EFF_FLAG)
 		msg->flags |= USB_8DEV_EXTID;
 
 	msg->id = cpu_to_be32(cf->can_id & CAN_ERR_MASK);
-	msg->dlc = cf->can_dlc;
-	memcpy(msg->data, cf->data, cf->can_dlc);
+	msg->dlc = cf->len;
+	memcpy(msg->data, cf->data, cf->len);
 	msg->end = USB_8DEV_DATA_END;
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
 		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
 			context = &priv->tx_contexts[i];
@@ -654,11 +654,11 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 	if (!context)
 		goto nofreecontext;
 
 	context->priv = priv;
 	context->echo_index = i;
-	context->dlc = cf->can_dlc;
+	context->dlc = cf->len;
 
 	usb_fill_bulk_urb(urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, USB_8DEV_ENDP_DATA_TX),
 			  buf, size, usb_8dev_write_bulk_callback, context);
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 73e8b1df1071..88831ce0f2f8 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -757,11 +757,11 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 	id_xcan = priv->read_reg(priv, XCAN_FRAME_ID_OFFSET(frame_base));
 	dlc = priv->read_reg(priv, XCAN_FRAME_DLC_OFFSET(frame_base)) >>
 				   XCAN_DLCR_DLC_SHIFT;
 
 	/* Change Xilinx CAN data length format to socketCAN data format */
-	cf->can_dlc = can_cc_dlc2len(dlc);
+	cf->len = can_cc_dlc2len(dlc);
 
 	/* Change Xilinx CAN ID format to socketCAN ID format */
 	if (id_xcan & XCAN_IDR_IDE_MASK) {
 		/* The received frame is an Extended format frame */
 		cf->can_id = (id_xcan & XCAN_IDR_ID1_MASK) >> 3;
@@ -782,17 +782,17 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 	data[0] = priv->read_reg(priv, XCAN_FRAME_DW1_OFFSET(frame_base));
 	data[1] = priv->read_reg(priv, XCAN_FRAME_DW2_OFFSET(frame_base));
 
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
 
 	return 1;
 }
@@ -968,11 +968,11 @@ static void xcan_update_error_state_after_rxtx(struct net_device *ndev)
 
 		if (skb) {
 			struct net_device_stats *stats = &ndev->stats;
 
 			stats->rx_packets++;
-			stats->rx_bytes += cf->can_dlc;
+			stats->rx_bytes += cf->len;
 			netif_rx(skb);
 		}
 	}
 }
 
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 802606e36b58..77da061c21c9 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -183,12 +183,12 @@ static inline void can_set_static_ctrlmode(struct net_device *dev,
 	/* override MTU which was set by default in can_setup()? */
 	if (static_mode & CAN_CTRLMODE_FD)
 		dev->mtu = CANFD_MTU;
 }
 
-/* get data length from can_dlc with sanitized can_dlc */
-u8 can_dlc2len(u8 can_dlc);
+/* get data length from raw data length code (DLC) */
+u8 can_dlc2len(u8 dlc);
 
 /* map the sanitized data length to an appropriate data length code */
 u8 can_len2dlc(u8 len);
 
 struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 6373ab9c5507..fd558e4df8bb 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -868,11 +868,11 @@ static struct pernet_operations can_pernet_ops __read_mostly = {
 static __init int can_init(void)
 {
 	int err;
 
 	/* check for correct padding to be able to use the structs similarly */
-	BUILD_BUG_ON(offsetof(struct can_frame, can_dlc) !=
+	BUILD_BUG_ON(offsetof(struct can_frame, len) !=
 		     offsetof(struct canfd_frame, len) ||
 		     offsetof(struct can_frame, data) !=
 		     offsetof(struct canfd_frame, data));
 
 	pr_info("can: controller area network core\n");
diff --git a/net/can/gw.c b/net/can/gw.c
index 6b790b6ff8d2..de5e8859ec9b 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -205,11 +205,11 @@ static void canframecpy(struct canfd_frame *dst, struct can_frame *src)
 	 * data are copied in the 3 bytes hole of the struct. This is needed
 	 * to make easy compares of the data in the struct cf_mod.
 	 */
 
 	dst->can_id = src->can_id;
-	dst->len = src->can_dlc;
+	dst->len = src->len;
 	*(u64 *)dst->data = *(u64 *)src->data;
 }
 
 static void canfdframecpy(struct canfd_frame *dst, struct canfd_frame *src)
 {
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 137054bff9ec..bb914d8b4216 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -60,11 +60,11 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
 	 */
 	cf = (void *)skb->data;
 	skb_pull(skb, J1939_CAN_HDR);
 
 	/* fix length, set to dlc, with 8 maximum */
-	skb_trim(skb, min_t(uint8_t, cf->can_dlc, 8));
+	skb_trim(skb, min_t(uint8_t, cf->len, 8));
 
 	/* set addr */
 	skcb = j1939_skb_to_cb(skb);
 	memset(skcb, 0, sizeof(*skcb));
 
@@ -333,11 +333,11 @@ int j1939_send_one(struct j1939_priv *priv, struct sk_buff *skb)
 		skcb->addr.sa;
 	if (j1939_pgn_is_pdu1(skcb->addr.pgn))
 		canid |= skcb->addr.da << 8;
 
 	cf->can_id = canid;
-	cf->can_dlc = dlc;
+	cf->len = dlc;
 
 	return can_send(skb, 1);
 
  failed:
 	kfree_skb(skb);
-- 
2.28.0

