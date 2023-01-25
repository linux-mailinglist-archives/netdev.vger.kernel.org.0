Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8874667BB33
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbjAYTwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbjAYTwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:52:17 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E03C59B57
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:19 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id tz11so50685993ejc.0
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffISOqPrjVineBfCgtfl5Y+ak8BEEFsQWDBR3c2ME1A=;
        b=0VuzDqRw805Rh+kKcAf2Kr4irsZmGV3zH28nntM2EYVNES0HnLhs9pwkq3l1D9agU9
         QoeI1a6uzVFwLUk6GTzaweHSluK4GvqIHb+lpuxKzL4JizJUSeOx6z4J8CP4JSJaBV48
         MH7P9bTc5yJV4xFSjl4U6nG5h1GOyioXerSXqtMguE5XIx/IcEOnNYVw/RSNtBcBtybq
         iiEcmAwuPSVrU2z+nZXkxxS5ZDLKzq8xZmAqpY6WmupxemW9ySjYHFrpr7yWrFspMyjo
         9C+XHxyUXUtLrzMfn3v8fbrdHH+AipIVwsDjJIk8+QfzKKAuUQBh/nHYWu3Ss1xrP+PZ
         4FvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffISOqPrjVineBfCgtfl5Y+ak8BEEFsQWDBR3c2ME1A=;
        b=SoKf9oQH1yX+Ekf8Eqs/JywDofla5kcQ1LTheoNPMZK1C2I8tTz671QsmTsOj+mKS+
         DVqiCDLZKUhCG860vZdGxdr3vrh9R1Xbh4uAs36CwVyeWv2iZaessox+bN9q6H4LaGwZ
         SWyB6bcOu51yNYr4LycavCmUWTSoe7m8sOgMv1tGDU0r0r5rxUyPA0LBmPRcIIVnpRbP
         A4LjcpDjQvoLulsJUAg3GS22o8biTOlgiaNp3Tu2U5LIXYRgiRd+tyuwMCRzAUDIqlml
         yt31ECfvMaUcGYuGQoqSAaIOs/21ki3MKUVcmHlqouUmY3NSVL66oFggIDCDZPT7SxQu
         byJw==
X-Gm-Message-State: AFqh2kq8v5QFGAQtGoMsWrAOjJWFEerPdaZaI4gj2fW0ymeHaT2szmvD
        hfbnYSIKXGu7kePaR+E3g6Qalw==
X-Google-Smtp-Source: AMrXdXtu2JvZd+IRD6wP5yce50RiTQK+otsLhr0ySBa2s5MW6Wba/2GQqirY5yrH8jOwEgZepl37mg==
X-Received: by 2002:a17:906:2c55:b0:86b:d25:450f with SMTP id f21-20020a1709062c5500b0086b0d25450fmr35270088ejh.25.1674676279544;
        Wed, 25 Jan 2023 11:51:19 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a247:815f:ef74:e427:628a:752c])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906454f00b00872c0bccab2sm2778830ejq.35.2023.01.25.11.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:51:19 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 17/18] can: m_can: Implement BQL
Date:   Wed, 25 Jan 2023 20:50:58 +0100
Message-Id: <20230125195059.630377-18-msp@baylibre.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125195059.630377-1-msp@baylibre.com>
References: <20230125195059.630377-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement byte queue limiting in preparation for the use of xmit_more().

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 49 +++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index b24ca7a1ecfc..c6a09369d1aa 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -444,6 +444,8 @@ static void m_can_clean(struct net_device *net)
 	for (int i = 0; i != cdev->can.echo_skb_max; ++i)
 		can_free_echo_skb(cdev->net, i, NULL);
 
+	netdev_reset_queue(cdev->net);
+
 	spin_lock(&cdev->tx_handling_spinlock);
 	cdev->tx_fifo_in_flight = 0;
 	spin_unlock(&cdev->tx_handling_spinlock);
@@ -998,27 +1000,32 @@ static int m_can_poll(struct napi_struct *napi, int quota)
  * echo. timestamp is used for peripherals to ensure correct ordering
  * by rx-offload, and is ignored for non-peripherals.
  */
-static void m_can_tx_update_stats(struct m_can_classdev *cdev,
-				  unsigned int msg_mark,
-				  u32 timestamp)
+static unsigned int m_can_tx_update_stats(struct m_can_classdev *cdev,
+					  unsigned int msg_mark, u32 timestamp)
 {
 	struct net_device *dev = cdev->net;
 	struct net_device_stats *stats = &dev->stats;
+	unsigned int frame_len;
 
 	if (cdev->is_peripheral)
 		stats->tx_bytes +=
 			can_rx_offload_get_echo_skb(&cdev->offload,
 						    msg_mark,
 						    timestamp,
-						    NULL);
+						    &frame_len);
 	else
-		stats->tx_bytes += can_get_echo_skb(dev, msg_mark, NULL);
+		stats->tx_bytes += can_get_echo_skb(dev, msg_mark, &frame_len);
 
 	stats->tx_packets++;
+
+	return frame_len;
 }
 
-static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted)
+static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted,
+			    int transmitted_frame_len)
 {
+	netdev_completed_queue(cdev->net, transmitted, transmitted_frame_len);
+
 	spin_lock(&cdev->tx_handling_spinlock);
 	if (cdev->tx_fifo_in_flight >= cdev->tx_fifo_size && transmitted > 0)
 		netif_wake_queue(cdev->net);
@@ -1056,6 +1063,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
 	int err = 0;
 	unsigned int msg_mark;
 	int processed = 0;
+	int processed_frame_len = 0;
 
 	struct m_can_classdev *cdev = netdev_priv(dev);
 
@@ -1084,7 +1092,9 @@ static int m_can_echo_tx_event(struct net_device *dev)
 		fgi = (++fgi >= cdev->mcfg[MRAM_TXE].num ? 0 : fgi);
 
 		/* update stats */
-		m_can_tx_update_stats(cdev, msg_mark, timestamp);
+		processed_frame_len += m_can_tx_update_stats(cdev, msg_mark,
+							     timestamp);
+
 		++processed;
 	}
 
@@ -1092,7 +1102,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
 		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
 							  ack_fgi));
 
-	m_can_finish_tx(cdev, processed);
+	m_can_finish_tx(cdev, processed, processed_frame_len);
 
 	return err;
 }
@@ -1183,11 +1193,12 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		if (ir & IR_TC) {
 			/* Transmission Complete Interrupt*/
 			u32 timestamp = 0;
+			unsigned int frame_len;
 
 			if (cdev->is_peripheral)
 				timestamp = m_can_get_timestamp(cdev);
-			m_can_tx_update_stats(cdev, 0, timestamp);
-			m_can_finish_tx(cdev, 1);
+			frame_len = m_can_tx_update_stats(cdev, 0, timestamp);
+			m_can_finish_tx(cdev, 1, frame_len);
 		}
 	} else  {
 		if (ir & (IR_TEFN | IR_TEFW)) {
@@ -1716,6 +1727,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 	u32 cccr, fdflags;
 	int err;
 	int putidx;
+	unsigned int frame_len = can_skb_get_frame_len(skb);
 
 	/* Generate ID field for TX buffer Element */
 	/* Common to all supported M_CAN versions */
@@ -1761,7 +1773,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 		}
 		m_can_write(cdev, M_CAN_TXBTIE, 0x1);
 
-		can_put_echo_skb(skb, dev, 0, 0);
+		can_put_echo_skb(skb, dev, 0, frame_len);
 
 		m_can_write(cdev, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
@@ -1799,7 +1811,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 		/* Push loopback echo.
 		 * Will be looped back on TX interrupt based on message marker
 		 */
-		can_put_echo_skb(skb, dev, putidx, 0);
+		can_put_echo_skb(skb, dev, putidx, frame_len);
 
 		/* Enable TX FIFO element to start transfer  */
 		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
@@ -1870,14 +1882,23 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
+	netdev_tx_t ret;
+	unsigned int frame_len;
 
 	if (can_dev_dropped_skb(dev, skb))
 		return NETDEV_TX_OK;
 
+	frame_len = can_skb_get_frame_len(skb);
+
 	if (cdev->is_peripheral)
-		return m_can_start_peripheral_xmit(cdev, skb);
+		ret = m_can_start_peripheral_xmit(cdev, skb);
 	else
-		return m_can_start_fast_xmit(cdev, skb);
+		ret = m_can_start_fast_xmit(cdev, skb);
+
+	if (ret == NETDEV_TX_OK)
+		netdev_sent_queue(dev, frame_len);
+
+	return ret;
 }
 
 static int m_can_open(struct net_device *dev)
-- 
2.39.0

