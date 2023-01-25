Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65E467BB31
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbjAYTwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235965AbjAYTwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:52:16 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FE15CFD8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:19 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id rl14so47282196ejb.2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2Jin9e2wGMdlJd7lrmLtm7VXCmjAGgCkfI7OuGO0k8=;
        b=Kgfdprj+f/gxPYmLAXckB3jmwQRo6mqGmAUulpumtp3Pe2PU9Lsc+iIlUWKFPehJnO
         B8hf+amxB5jUm6sN6Hlvpajunea8k5dxSQEIpDsXW0dSrxeKoTIFv05VyIZUXKqz2OXK
         Ie55v+mPXla4xFuHupg9rJHCpzL0S/JAC1wZu4qvG/TKPuJ2YVm+Fd25YaedR1DOTpRI
         9KCfAHJUvTA6KDXs+xKtXgT25j+OBq0tWKEPZGXiHjE4K5lZgGsSzn3P1zqthZrN3gvg
         E7959MrU9KQTX+hAiGAU+yEtc4C1GhnVpU0BpUqC/QwFbXjYJK7wXwGfrXFkOJjvR0xB
         RItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/2Jin9e2wGMdlJd7lrmLtm7VXCmjAGgCkfI7OuGO0k8=;
        b=6ADrkZaLG5U+Uhtsmii7VqJQSt7nzCGiizWVFdKOFuUPUEzCTk4Q5glwNHR0oLkCGo
         OIdgrhBKnS7L+saKkkT4++cZtFHKLQc8ET4Tvw0tFj65DuwVYGtCR/TgLWxpw9Db0wuD
         RqMwmdNDHVKwxBw7VElpRLiQtztUaAQTcx6O2NPamPh5Kv2LaoaZuuF1aZx1z0fJOcrq
         a+zpFvxv74lSOOisvH+Ll18ZvnHkWRFlSVy1VClZGN0c5zmoNlmq5XJ8wlzmHyhqWyJV
         dn9ee6WjW8/UOcA3+YLetUc8Q9/1qiC/18qgdLnvE2fbduC+cJT2RqQYHhwHjOcCwtSt
         LgUQ==
X-Gm-Message-State: AFqh2kpisQX84o36mQkObJcMWRH/HG4JGaOwL8TiVpEoe+OVFWQ7X0D7
        0k2Xu3kxVSQt43IJy9rE5XSVhg==
X-Google-Smtp-Source: AMrXdXt1wxm/SKnu1DNWGu8DPIqkhoTLrKlaNUXvUYe/T2ZedOlYO4001/bjHGJ2zFWVOJ3Y61rFZw==
X-Received: by 2002:a17:906:80d:b0:870:d15a:c2e0 with SMTP id e13-20020a170906080d00b00870d15ac2e0mr35237171ejd.51.1674676278696;
        Wed, 25 Jan 2023 11:51:18 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a247:815f:ef74:e427:628a:752c])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906454f00b00872c0bccab2sm2778830ejq.35.2023.01.25.11.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:51:18 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 16/18] can: m_can: Use tx_fifo_in_flight for netif_queue control
Date:   Wed, 25 Jan 2023 20:50:57 +0100
Message-Id: <20230125195059.630377-17-msp@baylibre.com>
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
 drivers/net/can/m_can/m_can.c | 72 +++++++++++++----------------------
 1 file changed, 27 insertions(+), 45 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f46d411bc796..b24ca7a1ecfc 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -370,16 +370,6 @@ m_can_txe_fifo_read(struct m_can_classdev *cdev, u32 fgi, u32 offset, u32 *val)
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
@@ -1030,15 +1020,30 @@ static void m_can_tx_update_stats(struct m_can_classdev *cdev,
 static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted)
 {
 	spin_lock(&cdev->tx_handling_spinlock);
+	if (cdev->tx_fifo_in_flight >= cdev->tx_fifo_size && transmitted > 0)
+		netif_wake_queue(cdev->net);
 	cdev->tx_fifo_in_flight -= transmitted;
 	spin_unlock(&cdev->tx_handling_spinlock);
 }
 
-static void m_can_start_tx(struct m_can_classdev *cdev)
+static netdev_tx_t m_can_start_tx(struct m_can_classdev *cdev)
 {
+	int tx_fifo_in_flight;
+
 	spin_lock(&cdev->tx_handling_spinlock);
-	++cdev->tx_fifo_in_flight;
+	tx_fifo_in_flight = cdev->tx_fifo_in_flight + 1;
+	if (tx_fifo_in_flight >= cdev->tx_fifo_size) {
+		netif_stop_queue(cdev->net);
+		if (tx_fifo_in_flight > cdev->tx_fifo_size) {
+			netdev_err(cdev->net, "hard_xmit called while TX FIFO full\n");
+			spin_unlock(&cdev->tx_handling_spinlock);
+			return NETDEV_TX_BUSY;
+		}
+	}
+	cdev->tx_fifo_in_flight = tx_fifo_in_flight;
 	spin_unlock(&cdev->tx_handling_spinlock);
+
+	return NETDEV_TX_OK;
 }
 
 static int m_can_echo_tx_event(struct net_device *dev)
@@ -1182,7 +1187,6 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			if (cdev->is_peripheral)
 				timestamp = m_can_get_timestamp(cdev);
 			m_can_tx_update_stats(cdev, 0, timestamp);
-			netif_wake_queue(dev);
 			m_can_finish_tx(cdev, 1);
 		}
 	} else  {
@@ -1190,10 +1194,6 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			/* New TX FIFO Element arrived */
 			if (m_can_echo_tx_event(dev) != 0)
 				goto out_fail;
-
-			if (netif_queue_stopped(dev) &&
-			    !m_can_tx_fifo_full(cdev))
-				netif_wake_queue(dev);
 		}
 	}
 
@@ -1714,7 +1714,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
 	struct net_device *dev = cdev->net;
 	struct id_and_dlc fifo_header;
 	u32 cccr, fdflags;
-	u32 txfqs;
 	int err;
 	int putidx;
 
@@ -1770,24 +1769,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
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
 
@@ -1824,11 +1805,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev,
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
@@ -1862,14 +1838,16 @@ static void m_can_tx_queue_skb(struct m_can_classdev *cdev, struct sk_buff *skb)
 static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
 					       struct sk_buff *skb)
 {
+	netdev_tx_t err;
+
 	if (cdev->can.state == CAN_STATE_BUS_OFF) {
 		m_can_clean(cdev->net);
 		return NETDEV_TX_OK;
 	}
 
-	netif_stop_queue(cdev->net);
-
-	m_can_start_tx(cdev);
+	err = m_can_start_tx(cdev);
+	if (err != NETDEV_TX_OK)
+		return err;
 
 	m_can_tx_queue_skb(cdev, skb);
 
@@ -1879,7 +1857,11 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
 static netdev_tx_t m_can_start_fast_xmit(struct m_can_classdev *cdev,
 					 struct sk_buff *skb)
 {
-	m_can_start_tx(cdev);
+	netdev_tx_t err;
+
+	err = m_can_start_tx(cdev);
+	if (err != NETDEV_TX_OK)
+		return err;
 
 	return m_can_tx_handler(cdev, skb);
 }
-- 
2.39.0

