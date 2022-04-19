Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1BF5071A5
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 17:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353875AbiDSP2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 11:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353858AbiDSP2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 11:28:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C87513F6C
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 08:26:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ngpjs-0001K4-PN
        for netdev@vger.kernel.org; Tue, 19 Apr 2022 17:26:00 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7926366AD8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 15:25:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0102566AAE;
        Tue, 19 Apr 2022 15:25:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8d0de916;
        Tue, 19 Apr 2022 15:25:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/17] can: rx-offload: rename can_rx_offload_queue_sorted() -> can_rx_offload_queue_timestamp()
Date:   Tue, 19 Apr 2022 17:25:38 +0200
Message-Id: <20220419152554.2925353-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419152554.2925353-1-mkl@pengutronix.de>
References: <20220419152554.2925353-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch renames the function can_rx_offload_queue_sorted() to
can_rx_offload_queue_timestamp(). This better describes what the
function does, it adds a newly RX'ed skb to the sorted queue by its
timestamp.

Link: https://lore.kernel.org/all/20220417194327.2699059-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/rx-offload.c               | 6 +++---
 drivers/net/can/flexcan/flexcan-core.c         | 4 ++--
 drivers/net/can/m_can/m_can.c                  | 2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 6 +++---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c   | 2 +-
 drivers/net/can/ti_hecc.c                      | 4 ++--
 include/linux/can/rx-offload.h                 | 4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
index 7f80d8e1e750..6d0dc18c03e7 100644
--- a/drivers/net/can/dev/rx-offload.c
+++ b/drivers/net/can/dev/rx-offload.c
@@ -221,7 +221,7 @@ int can_rx_offload_irq_offload_fifo(struct can_rx_offload *offload)
 }
 EXPORT_SYMBOL_GPL(can_rx_offload_irq_offload_fifo);
 
-int can_rx_offload_queue_sorted(struct can_rx_offload *offload,
+int can_rx_offload_queue_timestamp(struct can_rx_offload *offload,
 				struct sk_buff *skb, u32 timestamp)
 {
 	struct can_rx_offload_cb *cb;
@@ -240,7 +240,7 @@ int can_rx_offload_queue_sorted(struct can_rx_offload *offload,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(can_rx_offload_queue_sorted);
+EXPORT_SYMBOL_GPL(can_rx_offload_queue_timestamp);
 
 unsigned int can_rx_offload_get_echo_skb(struct can_rx_offload *offload,
 					 unsigned int idx, u32 timestamp,
@@ -256,7 +256,7 @@ unsigned int can_rx_offload_get_echo_skb(struct can_rx_offload *offload,
 	if (!skb)
 		return 0;
 
-	err = can_rx_offload_queue_sorted(offload, skb, timestamp);
+	err = can_rx_offload_queue_timestamp(offload, skb, timestamp);
 	if (err) {
 		stats->rx_errors++;
 		stats->tx_fifo_errors++;
diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 74d7fcbfd065..389bd9da7e9a 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -845,7 +845,7 @@ static void flexcan_irq_bus_err(struct net_device *dev, u32 reg_esr)
 	if (tx_errors)
 		dev->stats.tx_errors++;
 
-	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	err = can_rx_offload_queue_timestamp(&priv->offload, skb, timestamp);
 	if (err)
 		dev->stats.rx_fifo_errors++;
 }
@@ -892,7 +892,7 @@ static void flexcan_irq_state(struct net_device *dev, u32 reg_esr)
 	if (unlikely(new_state == CAN_STATE_BUS_OFF))
 		can_bus_off(dev);
 
-	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	err = can_rx_offload_queue_timestamp(&priv->offload, skb, timestamp);
 	if (err)
 		dev->stats.rx_fifo_errors++;
 }
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index b3b5bc1c803b..2779bba390f2 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -464,7 +464,7 @@ static void m_can_receive_skb(struct m_can_classdev *cdev,
 		struct net_device_stats *stats = &cdev->net->stats;
 		int err;
 
-		err = can_rx_offload_queue_sorted(&cdev->offload, skb,
+		err = can_rx_offload_queue_timestamp(&cdev->offload, skb,
 						  timestamp);
 		if (err)
 			stats->rx_fifo_errors++;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index f9dd8fdba12b..230ec60003fc 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -916,7 +916,7 @@ static int mcp251xfd_handle_rxovif(struct mcp251xfd_priv *priv)
 	cf->can_id |= CAN_ERR_CRTL;
 	cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 
-	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	err = can_rx_offload_queue_timestamp(&priv->offload, skb, timestamp);
 	if (err)
 		stats->rx_fifo_errors++;
 
@@ -1021,7 +1021,7 @@ static int mcp251xfd_handle_ivmif(struct mcp251xfd_priv *priv)
 		return 0;
 
 	mcp251xfd_skb_set_timestamp(priv, skb, timestamp);
-	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	err = can_rx_offload_queue_timestamp(&priv->offload, skb, timestamp);
 	if (err)
 		stats->rx_fifo_errors++;
 
@@ -1094,7 +1094,7 @@ static int mcp251xfd_handle_cerrif(struct mcp251xfd_priv *priv)
 		cf->data[7] = bec.rxerr;
 	}
 
-	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	err = can_rx_offload_queue_timestamp(&priv->offload, skb, timestamp);
 	if (err)
 		stats->rx_fifo_errors++;
 
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
index d09f7fbf2ba7..ced8d9c81f8c 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
@@ -173,7 +173,7 @@ mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
 	}
 
 	mcp251xfd_hw_rx_obj_to_skb(priv, hw_rx_obj, skb);
-	err = can_rx_offload_queue_sorted(&priv->offload, skb, hw_rx_obj->ts);
+	err = can_rx_offload_queue_timestamp(&priv->offload, skb, hw_rx_obj->ts);
 	if (err)
 		stats->rx_fifo_errors++;
 
diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index ff31b993ab17..bb3f2e3b004c 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -633,7 +633,7 @@ static int ti_hecc_error(struct net_device *ndev, int int_status,
 			cf->data[3] = CAN_ERR_PROT_LOC_ACK;
 
 		timestamp = hecc_read(priv, HECC_CANLNT);
-		err = can_rx_offload_queue_sorted(&priv->offload, skb,
+		err = can_rx_offload_queue_timestamp(&priv->offload, skb,
 						  timestamp);
 		if (err)
 			ndev->stats.rx_fifo_errors++;
@@ -668,7 +668,7 @@ static void ti_hecc_change_state(struct net_device *ndev,
 	}
 
 	timestamp = hecc_read(priv, HECC_CANLNT);
-	err = can_rx_offload_queue_sorted(&priv->offload, skb, timestamp);
+	err = can_rx_offload_queue_timestamp(&priv->offload, skb, timestamp);
 	if (err)
 		ndev->stats.rx_fifo_errors++;
 }
diff --git a/include/linux/can/rx-offload.h b/include/linux/can/rx-offload.h
index c11477620403..c205c51d79c9 100644
--- a/include/linux/can/rx-offload.h
+++ b/include/linux/can/rx-offload.h
@@ -42,8 +42,8 @@ int can_rx_offload_add_manual(struct net_device *dev,
 int can_rx_offload_irq_offload_timestamp(struct can_rx_offload *offload,
 					 u64 reg);
 int can_rx_offload_irq_offload_fifo(struct can_rx_offload *offload);
-int can_rx_offload_queue_sorted(struct can_rx_offload *offload,
-				struct sk_buff *skb, u32 timestamp);
+int can_rx_offload_queue_timestamp(struct can_rx_offload *offload,
+				   struct sk_buff *skb, u32 timestamp);
 unsigned int can_rx_offload_get_echo_skb(struct can_rx_offload *offload,
 					 unsigned int idx, u32 timestamp,
 					 unsigned int *frame_len_ptr);

base-commit: cc4bdef26ecd56de16a04bc6d99aa10ff9076498
-- 
2.35.1


