Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E738A2F5BE3
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbhANH6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727679AbhANH61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:58:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1190C061387
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:56:39 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kzxUk-0007TZ-Fo
        for netdev@vger.kernel.org; Thu, 14 Jan 2021 08:56:38 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id AB2E65C3680
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 07:56:32 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1FACF5C3624;
        Thu, 14 Jan 2021 07:56:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5a1ac748;
        Thu, 14 Jan 2021 07:56:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [net-next 14/17] can: dev: can_get_echo_skb(): extend to return can frame length
Date:   Thu, 14 Jan 2021 08:56:14 +0100
Message-Id: <20210114075617.1402597-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114075617.1402597-1-mkl@pengutronix.de>
References: <20210114075617.1402597-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to implement byte queue limits (bql) in CAN drivers, the length of the
CAN frame needs to be passed into the networking stack after queueing and after
transmission completion.

To avoid to calculate this length twice, extend can_get_echo_skb() to return
that value. Convert all users of this function, too.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210111141930.693847-14-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c                        | 2 +-
 drivers/net/can/c_can/c_can.c                     | 2 +-
 drivers/net/can/cc770/cc770.c                     | 2 +-
 drivers/net/can/dev/skb.c                         | 5 +++--
 drivers/net/can/grcan.c                           | 2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c             | 2 +-
 drivers/net/can/kvaser_pciefd.c                   | 4 ++--
 drivers/net/can/m_can/m_can.c                     | 4 ++--
 drivers/net/can/mscan/mscan.c                     | 2 +-
 drivers/net/can/pch_can.c                         | 2 +-
 drivers/net/can/peak_canfd/peak_canfd.c           | 2 +-
 drivers/net/can/rcar/rcar_can.c                   | 2 +-
 drivers/net/can/rcar/rcar_canfd.c                 | 2 +-
 drivers/net/can/sja1000/sja1000.c                 | 2 +-
 drivers/net/can/softing/softing_main.c            | 2 +-
 drivers/net/can/spi/hi311x.c                      | 2 +-
 drivers/net/can/spi/mcp251x.c                     | 2 +-
 drivers/net/can/sun4i_can.c                       | 2 +-
 drivers/net/can/usb/ems_usb.c                     | 2 +-
 drivers/net/can/usb/esd_usb2.c                    | 2 +-
 drivers/net/can/usb/gs_usb.c                      | 2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 2 +-
 drivers/net/can/usb/mcba_usb.c                    | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c      | 2 +-
 drivers/net/can/usb/ucan.c                        | 2 +-
 drivers/net/can/usb/usb_8dev.c                    | 2 +-
 drivers/net/can/xilinx_can.c                      | 2 +-
 include/linux/can/skb.h                           | 3 ++-
 29 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 90b223a80ed4..9ad9b39f480e 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -856,7 +856,7 @@ static void at91_irq_tx(struct net_device *dev, u32 reg_sr)
 		if (likely(reg_msr & AT91_MSR_MRDY &&
 			   ~reg_msr & AT91_MSR_MABT)) {
 			/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
-			can_get_echo_skb(dev, mb - get_mb_tx_first(priv));
+			can_get_echo_skb(dev, mb - get_mb_tx_first(priv), NULL);
 			dev->stats.tx_packets++;
 			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 13638954a25c..ef474bae47a1 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -733,7 +733,7 @@ static void c_can_do_tx(struct net_device *dev)
 		pend &= ~(1 << idx);
 		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
 		c_can_inval_tx_object(dev, IF_RX, obj);
-		can_get_echo_skb(dev, idx);
+		can_get_echo_skb(dev, idx, NULL);
 		bytes += priv->dlc[idx];
 		pkts++;
 	}
diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index e53ca338368a..f8a130f594e2 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -703,7 +703,7 @@ static void cc770_tx_interrupt(struct net_device *dev, unsigned int o)
 	stats->tx_packets++;
 
 	can_put_echo_skb(priv->tx_skb, dev, 0, 0);
-	can_get_echo_skb(dev, 0);
+	can_get_echo_skb(dev, 0, NULL);
 	priv->tx_skb = NULL;
 
 	netif_wake_queue(dev);
diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index c184b4dce19e..53683d4312f1 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -121,12 +121,13 @@ __can_get_echo_skb(struct net_device *dev, unsigned int idx, u8 *len_ptr,
  * is handled in the device driver. The driver must protect
  * access to priv->echo_skb, if necessary.
  */
-unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx)
+unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx,
+			      unsigned int *frame_len_ptr)
 {
 	struct sk_buff *skb;
 	u8 len;
 
-	skb = __can_get_echo_skb(dev, idx, &len, NULL);
+	skb = __can_get_echo_skb(dev, idx, &len, frame_len_ptr);
 	if (!skb)
 		return 0;
 
diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 8086cdc10000..4a8453290530 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -517,7 +517,7 @@ static int catch_up_echo_skb(struct net_device *dev, int budget, bool echo)
 			stats->tx_packets++;
 			stats->tx_bytes += priv->txdlc[i];
 			priv->txdlc[i] = 0;
-			can_get_echo_skb(dev, i);
+			can_get_echo_skb(dev, i, NULL);
 		} else {
 			/* For cleanup of untransmitted messages */
 			can_free_echo_skb(dev, i);
diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 56ac9e1dace7..5bb957a26bc6 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -629,7 +629,7 @@ static irqreturn_t ifi_canfd_isr(int irq, void *dev_id)
 
 	/* TX IRQ */
 	if (isr & IFI_CANFD_INTERRUPT_TXFIFO_REMOVE) {
-		stats->tx_bytes += can_get_echo_skb(ndev, 0);
+		stats->tx_bytes += can_get_echo_skb(ndev, 0, NULL);
 		stats->tx_packets++;
 		can_led_event(ndev, CAN_LED_EVENT_TX);
 	}
diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 0cf82f0646a3..37e05010ca91 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1467,7 +1467,7 @@ static int kvaser_pciefd_handle_eack_packet(struct kvaser_pciefd *pcie,
 				  can->reg_base + KVASER_PCIEFD_KCAN_CTRL_REG);
 	} else {
 		int echo_idx = p->header[0] & KVASER_PCIEFD_PACKET_SEQ_MSK;
-		int dlc = can_get_echo_skb(can->can.dev, echo_idx);
+		int dlc = can_get_echo_skb(can->can.dev, echo_idx, NULL);
 		struct net_device_stats *stats = &can->can.dev->stats;
 
 		stats->tx_bytes += dlc;
@@ -1533,7 +1533,7 @@ static int kvaser_pciefd_handle_ack_packet(struct kvaser_pciefd *pcie,
 		netdev_dbg(can->can.dev, "Packet was flushed\n");
 	} else {
 		int echo_idx = p->header[0] & KVASER_PCIEFD_PACKET_SEQ_MSK;
-		int dlc = can_get_echo_skb(can->can.dev, echo_idx);
+		int dlc = can_get_echo_skb(can->can.dev, echo_idx, NULL);
 		u8 count = ioread32(can->reg_base +
 				    KVASER_PCIEFD_KCAN_TX_NPACKETS_REG) & 0xff;
 
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index fff7432103cb..3752520a7d4b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -930,7 +930,7 @@ static void m_can_echo_tx_event(struct net_device *dev)
 						(fgi << TXEFA_EFAI_SHIFT)));
 
 		/* update stats */
-		stats->tx_bytes += can_get_echo_skb(dev, msg_mark);
+		stats->tx_bytes += can_get_echo_skb(dev, msg_mark, NULL);
 		stats->tx_packets++;
 	}
 }
@@ -972,7 +972,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	if (cdev->version == 30) {
 		if (ir & IR_TC) {
 			/* Transmission Complete Interrupt*/
-			stats->tx_bytes += can_get_echo_skb(dev, 0);
+			stats->tx_bytes += can_get_echo_skb(dev, 0, NULL);
 			stats->tx_packets++;
 			can_led_event(dev, CAN_LED_EVENT_TX);
 			netif_wake_queue(dev);
diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
index a28fdaa411c6..fa32e418eb29 100644
--- a/drivers/net/can/mscan/mscan.c
+++ b/drivers/net/can/mscan/mscan.c
@@ -448,7 +448,7 @@ static irqreturn_t mscan_isr(int irq, void *dev_id)
 			out_8(&regs->cantbsel, mask);
 			stats->tx_bytes += in_8(&regs->tx.dlr);
 			stats->tx_packets++;
-			can_get_echo_skb(dev, entry->id);
+			can_get_echo_skb(dev, entry->id, NULL);
 			priv->tx_active &= ~mask;
 			list_del(pos);
 		}
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index a4c35b48d8e9..92a54a5fd4c5 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -711,7 +711,7 @@ static void pch_can_tx_complete(struct net_device *ndev, u32 int_stat)
 	struct net_device_stats *stats = &(priv->ndev->stats);
 	u32 dlc;
 
-	can_get_echo_skb(ndev, int_stat - PCH_RX_OBJ_END - 1);
+	can_get_echo_skb(ndev, int_stat - PCH_RX_OBJ_END - 1, NULL);
 	iowrite32(PCH_CMASK_RX_TX_GET | PCH_CMASK_CLRINTPND,
 		  &priv->regs->ifregs[1].cmask);
 	pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, int_stat);
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index 179a8e10fbb8..00847cbaf7b6 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -266,7 +266,7 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
 		unsigned long flags;
 
 		spin_lock_irqsave(&priv->echo_lock, flags);
-		can_get_echo_skb(priv->ndev, msg->client);
+		can_get_echo_skb(priv->ndev, msg->client, NULL);
 
 		/* count bytes of the echo instead of skb */
 		stats->tx_bytes += cf_len;
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 0b7e488bc4fe..4870c4ea190a 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -386,7 +386,7 @@ static void rcar_can_tx_done(struct net_device *ndev)
 		stats->tx_bytes += priv->tx_dlc[priv->tx_tail %
 						RCAR_CAN_FIFO_DEPTH];
 		priv->tx_dlc[priv->tx_tail % RCAR_CAN_FIFO_DEPTH] = 0;
-		can_get_echo_skb(ndev, priv->tx_tail % RCAR_CAN_FIFO_DEPTH);
+		can_get_echo_skb(ndev, priv->tx_tail % RCAR_CAN_FIFO_DEPTH, NULL);
 		priv->tx_tail++;
 		netif_wake_queue(ndev);
 	}
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 38376f29bc56..d8d233e62990 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1044,7 +1044,7 @@ static void rcar_canfd_tx_done(struct net_device *ndev)
 		stats->tx_packets++;
 		stats->tx_bytes += priv->tx_len[sent];
 		priv->tx_len[sent] = 0;
-		can_get_echo_skb(ndev, sent);
+		can_get_echo_skb(ndev, sent, NULL);
 
 		spin_lock_irqsave(&priv->tx_lock, flags);
 		priv->tx_tail++;
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index e98482c7bf33..9e86488ba55f 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -531,7 +531,7 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 				stats->tx_bytes +=
 					priv->read_reg(priv, SJA1000_FI) & 0xf;
 				stats->tx_packets++;
-				can_get_echo_skb(dev, 0);
+				can_get_echo_skb(dev, 0, NULL);
 			}
 			netif_wake_queue(dev);
 			can_led_event(dev, CAN_LED_EVENT_TX);
diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index a5314448c5ae..c44f3411e561 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -284,7 +284,7 @@ static int softing_handle_1(struct softing *card)
 			skb = priv->can.echo_skb[priv->tx.echo_get];
 			if (skb)
 				skb->tstamp = ktime;
-			can_get_echo_skb(netdev, priv->tx.echo_get);
+			can_get_echo_skb(netdev, priv->tx.echo_get, NULL);
 			++priv->tx.echo_get;
 			if (priv->tx.echo_get >= TX_ECHO_SKB_MAX)
 				priv->tx.echo_get = 0;
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 8c83a9e5a9e4..c3e020c90111 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -725,7 +725,7 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 			net->stats.tx_bytes += priv->tx_len - 1;
 			can_led_event(net, CAN_LED_EVENT_TX);
 			if (priv->tx_len) {
-				can_get_echo_skb(net, 0);
+				can_get_echo_skb(net, 0, NULL);
 				priv->tx_len = 0;
 			}
 			netif_wake_queue(net);
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 40866754aafc..f69fb4238a65 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1171,7 +1171,7 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 			net->stats.tx_bytes += priv->tx_len - 1;
 			can_led_event(net, CAN_LED_EVENT_TX);
 			if (priv->tx_len) {
-				can_get_echo_skb(net, 0);
+				can_get_echo_skb(net, 0, NULL);
 				priv->tx_len = 0;
 			}
 			netif_wake_queue(net);
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index b75175d59104..54aa7c25c4de 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -655,7 +655,7 @@ static irqreturn_t sun4i_can_interrupt(int irq, void *dev_id)
 			    readl(priv->base +
 				  SUN4I_REG_RBUF_RBACK_START_ADDR) & 0xf;
 			stats->tx_packets++;
-			can_get_echo_skb(dev, 0);
+			can_get_echo_skb(dev, 0, NULL);
 			netif_wake_queue(dev);
 			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 5e5330060464..18f40eb20360 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -518,7 +518,7 @@ static void ems_usb_write_bulk_callback(struct urb *urb)
 	netdev->stats.tx_packets++;
 	netdev->stats.tx_bytes += context->dlc;
 
-	can_get_echo_skb(netdev, context->echo_index);
+	can_get_echo_skb(netdev, context->echo_index, NULL);
 
 	/* Release context */
 	context->echo_index = MAX_TX_URBS;
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 68d8a85f00c4..562acbf454fd 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -357,7 +357,7 @@ static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
 	if (!msg->msg.txdone.status) {
 		stats->tx_packets++;
 		stats->tx_bytes += context->len;
-		can_get_echo_skb(netdev, context->echo_index);
+		can_get_echo_skb(netdev, context->echo_index, NULL);
 	} else {
 		stats->tx_errors++;
 		can_free_echo_skb(netdev, context->echo_index);
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 5ce9ba5d29d6..a00dc1904415 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -370,7 +370,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			goto resubmit_urb;
 		}
 
-		can_get_echo_skb(netdev, hf->echo_id);
+		can_get_echo_skb(netdev, hf->echo_id, NULL);
 
 		gs_free_tx_context(txc);
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 480bd2ecb296..dcee8dc828ec 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1151,7 +1151,7 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
 
 	spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);
 
-	can_get_echo_skb(priv->netdev, context->echo_index);
+	can_get_echo_skb(priv->netdev, context->echo_index, NULL);
 	context->echo_index = dev->max_tx_urbs;
 	--priv->active_tx_contexts;
 	netif_wake_queue(priv->netdev);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 98c016ef0607..59ba7c7beec0 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -594,7 +594,7 @@ static void kvaser_usb_leaf_tx_acknowledge(const struct kvaser_usb *dev,
 
 	spin_lock_irqsave(&priv->tx_contexts_lock, flags);
 
-	can_get_echo_skb(priv->netdev, context->echo_index);
+	can_get_echo_skb(priv->netdev, context->echo_index, NULL);
 	context->echo_index = dev->max_tx_urbs;
 	--priv->active_tx_contexts;
 	netif_wake_queue(priv->netdev);
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 5347c89992ce..4232a7126c1b 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -237,7 +237,7 @@ static void mcba_usb_write_bulk_callback(struct urb *urb)
 		netdev->stats.tx_bytes += ctx->dlc;
 
 		can_led_event(netdev, CAN_LED_EVENT_TX);
-		can_get_echo_skb(netdev, ctx->ndx);
+		can_get_echo_skb(netdev, ctx->ndx, NULL);
 	}
 
 	if (urb->status)
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 95672750419a..573b11559d73 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -309,7 +309,7 @@ static void peak_usb_write_bulk_callback(struct urb *urb)
 	}
 
 	/* should always release echo skb and corresponding context */
-	can_get_echo_skb(netdev, context->echo_index);
+	can_get_echo_skb(netdev, context->echo_index, NULL);
 	context->echo_index = PCAN_USB_MAX_TX_URBS;
 
 	/* do wakeup tx queue in case of success only */
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 5add27614e2b..fa403c080871 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -672,7 +672,7 @@ static void ucan_tx_complete_msg(struct ucan_priv *up,
 			/* update statistics */
 			up->netdev->stats.tx_packets++;
 			up->netdev->stats.tx_bytes += dlc;
-			can_get_echo_skb(up->netdev, echo_index);
+			can_get_echo_skb(up->netdev, echo_index, NULL);
 		} else {
 			up->netdev->stats.tx_dropped++;
 			can_free_echo_skb(up->netdev, echo_index);
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 2e824d9d8167..e8c42430a4fc 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -585,7 +585,7 @@ static void usb_8dev_write_bulk_callback(struct urb *urb)
 	netdev->stats.tx_packets++;
 	netdev->stats.tx_bytes += context->dlc;
 
-	can_get_echo_skb(netdev, context->echo_index);
+	can_get_echo_skb(netdev, context->echo_index, NULL);
 
 	can_led_event(netdev, CAN_LED_EVENT_TX);
 
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 8d5132a3f2c9..37fa19c62d73 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1292,7 +1292,7 @@ static void xcan_tx_interrupt(struct net_device *ndev, u32 isr)
 
 	while (frames_sent--) {
 		stats->tx_bytes += can_get_echo_skb(ndev, priv->tx_tail %
-						    priv->tx_max);
+						    priv->tx_max, NULL);
 		priv->tx_tail++;
 		stats->tx_packets++;
 	}
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index eaac4a637ae0..685f34cfba20 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -21,7 +21,8 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 		     unsigned int idx, unsigned int frame_len);
 struct sk_buff *__can_get_echo_skb(struct net_device *dev, unsigned int idx,
 				   u8 *len_ptr, unsigned int *frame_len_ptr);
-unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx);
+unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx,
+			      unsigned int *frame_len_ptr);
 void can_free_echo_skb(struct net_device *dev, unsigned int idx);
 struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf);
 struct sk_buff *alloc_canfd_skb(struct net_device *dev,
-- 
2.29.2


