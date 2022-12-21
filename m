Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460D4653356
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiLUP1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbiLUP0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:26:12 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF08124942
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:55 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id e13so22457930edj.7
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gcS8xyo2Dgj5yMo5Xr3Z635PKRFPJKOjB+bkL8yToDY=;
        b=CFhgTNctTBBcpXqMmSekbNfE4brWtUHR39nIQAD56RUSUjL+/48SuhLR8BchvSIV1s
         6ZOl2Y78SE8EpANS3lUArmq8DmQUFmd+0cPr0s2cgYpd8LIAeUSi6412yP54iShKCeae
         CX69FgzLGlI+1+fRiFJg5kPaWsAjkmS9qv0dT8z2visvyC/xYgd0je33bNpTUSNxFoz1
         zthoX2Y6BI3H7V6KJ7yq8hZ+O7/8qEomECFVJol1hJjQ6cfTzq1yiYveTb//xbwudOHk
         li1e0q3ro7m6W4OMKGpAZQRsiA3gU/dOF2AK24ZssjnQKyYycCfXO6PtlHesoPIzyuol
         xrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gcS8xyo2Dgj5yMo5Xr3Z635PKRFPJKOjB+bkL8yToDY=;
        b=2nYNmlUvfLehfuDLl4yRkzg594Eayiaz9679pFD1OyRS8ZpVuStA3PL5e5iTejUX9S
         Je4bRd061Z1jsZEBrR34D2ygjK/qkEM0DtGr4eocj3a/ECLqzKulTNwUNenkTMslffme
         qPNNevGwcbGawF4FN8Ot1QeGbXycKun16FbLcTxjsV6jiESBecupA0hC9z00Melw0YzS
         PBF58I+v4RmRylRghgNk14td+WNO8sHYp/iN3R6sQeTHP+jBmW12S/OZ586o6ME57Xk8
         8rL5VoRuxaV8q5EpZ4zhInjVu03oBsoaI4Th34vvpXdRFR4F6/u/C6t4okbAHXstR2s7
         xVaQ==
X-Gm-Message-State: AFqh2ko2J+pIgryPrj1tiRyT/SorRsAuE6wEii+c5aQ8S5dFw6Ukn71v
        eeW+aQ4GygTmnC80KDJsqwj0Sg==
X-Google-Smtp-Source: AMrXdXtpInRQRIOGOjCi+hL59qHX25HHER0PYYoG4hbkQv3VBgUACylxHzP22VPpOT5eSgfC04gg6Q==
X-Received: by 2002:a05:6402:24a0:b0:467:7c73:4805 with SMTP id q32-20020a05640224a000b004677c734805mr6673498eda.5.1671636355577;
        Wed, 21 Dec 2022 07:25:55 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:55 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 16/18] can: m_can: Use tx_fifo_in_flight for netif_queue control
Date:   Wed, 21 Dec 2022 16:25:35 +0100
Message-Id: <20221221152537.751564-17-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The network queue is currently always stopped in start_xmit and
continued in the interrupt handler. This is not possible anymore if we
want to keep multiple transmits in flight in parallel.

Use the previously introduced tx_fifo_in_flight counter to control the
network queue instead. This has the benefit of not needing to ask the
hardware about fifo status.

This patch stops the network queue in start_xmit if the number of
transmits in flight reaches the size of the fifo and wakes up the queue
from the interrupt handler once the transmits in flight drops below the
fifo size. This means any skbs over the limit will be rejected
immediately in start_xmit (it shouldn't be possible at all to reach that
state anyways).

The maximum number of transmits in flight is the size of the fifo.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 58 +++++++++++------------------------
 1 file changed, 18 insertions(+), 40 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 90c9ff474149..076fa60317c2 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -369,16 +369,6 @@ m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset, u32 *val)
 	return cdev->ops->read_fifo(cdev, addr_offset, val, 1);
 }
 
-static inline bool _m_can_tx_fifo_full(u32 txfqs)
-{
-	return !!(txfqs & TXFQS_TFQF);
-}
-
-static inline bool m_can_tx_fifo_full(struct m_can_classdev *cdev)
-{
-	return _m_can_tx_fifo_full(m_can_read(cdev, M_CAN_TXFQS));
-}
-
 static void m_can_config_endisable(struct m_can_classdev *cdev, bool enable)
 {
 	u32 cccr = m_can_read(cdev, M_CAN_CCCR);
@@ -1064,6 +1054,8 @@ static int m_can_echo_tx_event(struct net_device *dev)
 							  ack_fgi));
 
 	spin_lock(&cdev->tx_handling_spinlock);
+	if (cdev->tx_fifo_in_flight >= cdev->nr_tx_ops && processed > 0)
+		netif_wake_queue(cdev->net);
 	cdev->tx_fifo_in_flight -= processed;
 	spin_unlock(&cdev->tx_handling_spinlock);
 
@@ -1167,10 +1159,6 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			/* New TX FIFO Element arrived */
 			if (m_can_echo_tx_event(dev) != 0)
 				goto out_fail;
-
-			if (netif_queue_stopped(dev) &&
-			    !m_can_tx_fifo_full(cdev))
-				netif_wake_queue(dev);
 		}
 	}
 
@@ -1677,7 +1665,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 	struct net_device *dev = cdev->net;
 	struct id_and_dlc fifo_header;
 	u32 cccr, fdflags;
-	u32 txfqs;
 	int err;
 	int putidx;
 
@@ -1733,24 +1720,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 		char buf[TXB_ELEMENT_SIZE];
 		/* Transmit routine for version >= v3.1.x */
 
-		txfqs = m_can_read(cdev, M_CAN_TXFQS);
-
-		/* Check if FIFO full */
-		if (_m_can_tx_fifo_full(txfqs)) {
-			/* This shouldn't happen */
-			netif_stop_queue(dev);
-			netdev_warn(dev,
-				    "TX queue active although FIFO is full.");
-
-			if (cdev->is_peripheral) {
-				kfree_skb(skb);
-				dev->stats.tx_dropped++;
-				return NETDEV_TX_OK;
-			} else {
-				return NETDEV_TX_BUSY;
-			}
-		}
-
 		/* get put index for frame */
 		putidx = cdev->tx_fifo_putidx;
 
@@ -1787,11 +1756,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
 		cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
 					0 : cdev->tx_fifo_putidx);
-
-		/* stop network queue if fifo full */
-		if (m_can_tx_fifo_full(cdev) ||
-		    m_can_next_echo_skb_occupied(dev, putidx))
-			netif_stop_queue(dev);
 	}
 
 	return NETDEV_TX_OK;
@@ -1830,10 +1794,16 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
 		return NETDEV_TX_OK;
 	}
 
-	netif_stop_queue(cdev->net);
-
 	spin_lock(&cdev->tx_handling_spinlock);
 	++cdev->tx_fifo_in_flight;
+	if (cdev->tx_fifo_in_flight >= cdev->nr_tx_ops) {
+		netif_stop_queue(cdev->net);
+		if (cdev->tx_fifo_in_flight > cdev->nr_tx_ops) {
+			netdev_err(cdev->net, "hard_xmit called while TX FIFO full\n");
+			spin_unlock(&cdev->tx_handling_spinlock);
+			return NETDEV_TX_BUSY;
+		}
+	}
 	spin_unlock(&cdev->tx_handling_spinlock);
 
 	m_can_tx_queue_skb(cdev, skb);
@@ -1846,6 +1816,14 @@ static netdev_tx_t m_can_start_fast_xmit(struct m_can_classdev *cdev,
 {
 	spin_lock(&cdev->tx_handling_spinlock);
 	++cdev->tx_fifo_in_flight;
+	if (cdev->tx_fifo_in_flight >= cdev->nr_tx_ops) {
+		netif_stop_queue(cdev->net);
+		if (cdev->tx_fifo_in_flight > cdev->nr_tx_ops) {
+			netdev_err(cdev->net, "hard_xmit called while TX FIFO full\n");
+			spin_unlock(&cdev->tx_handling_spinlock);
+			return NETDEV_TX_BUSY;
+		}
+	}
 	spin_unlock(&cdev->tx_handling_spinlock);
 
 	return m_can_tx_handler(cdev, skb);
-- 
2.38.1

