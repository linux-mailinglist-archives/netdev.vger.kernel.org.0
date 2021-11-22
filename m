Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1433C4597CC
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 23:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhKVWoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 17:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbhKVWoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 17:44:04 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A05C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 14:40:57 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id k37so86138185lfv.3
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 14:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P2oxO0zi+8eRVJdVd6FSGArtC/dQsZjmeHnuIHtWGQM=;
        b=J1oc3ylgjT//6dRTVgZKdvl0PINbVw3hkFPij0C3bPZLoIOUyQrjRxTqdlN+QOOlg0
         wsQN5WBrRnOBqlEsdOcCO6tZQ9L/mq2m9/prta2QyBebaK7pCedlLAaTWEDpVgFu3kub
         xyMUGT490IYBK5HXyx5uotzU23JUBkHAwyb3+OGwPaZ/T23ejokM1TLaGmUEwGVgjemq
         qKhSHQcuWcbobxX6sIcOUSzjwT3rOb7I6dos9FI4BylraVG0JUdIliYYAiMy3BQmcKzB
         CSVsM061gZLRg0CiRJlN99Beamg1h6Qoum4yjbRD7uPEx2ZG2dWgQhonRBcmdrE/egSS
         OYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P2oxO0zi+8eRVJdVd6FSGArtC/dQsZjmeHnuIHtWGQM=;
        b=Ojx3/oQKTLFtCF7wWfb1gAI/fl4veU2UJech742g0nz5wVxWvOFAYi8muXIdiu8b4b
         fS3ohaQPMPZclVzRPnNdXY4WrQGheSyv2sJExZ/nPBJzpxK2yMtCtxgkIKJgubF9r72Q
         XIpgF9pqo2oRW4tF8JZKsIrTAJL0yx6rl1lqAazLozDpXoYqInkhRSyPhP5950TNWyZw
         8PBLd37ccUs+GeKpEc6MD5COu4hkjSFralT5erKHFJuVSSGSC3Cc65YGbNj3Y3gBV5O9
         PjwYklFrbt8z14dYwYewVcz3NhR6WKmAft9nKN3aKc0419c7HkUnOhkcuOr95kneg5+N
         Fgmw==
X-Gm-Message-State: AOAM533fneW7r2pYnF3RZzeTZbMQf5G3CRCyUAAok50SqgC9MRgAuh2y
        v0x9UJ2Dlu1So6EBVm8f52SKoqCM+CTQyw==
X-Google-Smtp-Source: ABdhPJyXOhZm/8r63StSVTZTsRskUhu0ycah02fLb9lY+Uau+ejqWEyHFrebk/hoWt54Hj0pgWYZ8A==
X-Received: by 2002:ac2:51b8:: with SMTP id f24mr465182lfk.83.1637620854203;
        Mon, 22 Nov 2021 14:40:54 -0800 (PST)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id n7sm1091689lft.309.2021.11.22.14.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:40:53 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 2/2 v3] net: ixp4xx_hss: Convert to use DT probing
Date:   Mon, 22 Nov 2021 23:35:30 +0100
Message-Id: <20211122223530.3346264-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122223530.3346264-1-linus.walleij@linaro.org>
References: <20211122223530.3346264-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IXP4xx is being migrated to device tree only. Convert this
driver to use device tree probing.

Pull in all the boardfile code from the one boardfile and
make it local, pull all the boardfile parameters from the
device tree instead of the board file.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog ->v3:
- New patch sent along with the device tree bindings
  to actually convert the driver over to using DT probing.
---
 drivers/net/wan/ixp4xx_hss.c | 260 +++++++++++++++++++++++++----------
 1 file changed, 185 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index 88a36a069311..d02d8a2eb99d 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -17,13 +17,19 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
-#include <linux/platform_data/wan_ixp4xx_hss.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of.h>
 #include <linux/soc/ixp4xx/npe.h>
 #include <linux/soc/ixp4xx/qmgr.h>
 #include <linux/soc/ixp4xx/cpu.h>
 
+/* This is what all IXP4xx platforms we know uses, if more frequencies
+ * are needed, we need to migrate to the clock framework.
+ */
+#define IXP4XX_TIMER_FREQ	66666000
+
 #define DEBUG_DESC		0
 #define DEBUG_RX		0
 #define DEBUG_TX		0
@@ -50,7 +56,6 @@
 #define NAPI_WEIGHT		16
 
 /* Queue IDs */
-#define HSS0_CHL_RXTRIG_QUEUE	12	/* orig size = 32 dwords */
 #define HSS0_PKT_RX_QUEUE	13	/* orig size = 32 dwords */
 #define HSS0_PKT_TX0_QUEUE	14	/* orig size = 16 dwords */
 #define HSS0_PKT_TX1_QUEUE	15
@@ -62,7 +67,6 @@
 #define HSS0_PKT_RXFREE3_QUEUE	21
 #define HSS0_PKT_TXDONE_QUEUE	22	/* orig size = 64 dwords */
 
-#define HSS1_CHL_RXTRIG_QUEUE	10
 #define HSS1_PKT_RX_QUEUE	0
 #define HSS1_PKT_TX0_QUEUE	5
 #define HSS1_PKT_TX1_QUEUE	6
@@ -252,9 +256,19 @@ typedef void buffer_t;
 struct port {
 	struct device *dev;
 	struct npe *npe;
+	unsigned int txreadyq;
+	unsigned int rxtrigq;
+	unsigned int rxfreeq;
+	unsigned int rxq;
+	unsigned int txq;
+	unsigned int txdoneq;
+	struct gpio_desc *cts;
+	struct gpio_desc *rts;
+	struct gpio_desc *dcd;
+	struct gpio_desc *dtr;
+	struct gpio_desc *clk_internal;
 	struct net_device *netdev;
 	struct napi_struct napi;
-	struct hss_plat_info *plat;
 	buffer_t *rx_buff_tab[RX_DESCS], *tx_buff_tab[TX_DESCS];
 	struct desc *desc_tab;	/* coherent */
 	dma_addr_t desc_tab_phys;
@@ -322,14 +336,6 @@ static int ports_open;
 static struct dma_pool *dma_pool;
 static DEFINE_SPINLOCK(npe_lock);
 
-static const struct {
-	int tx, txdone, rx, rxfree;
-} queue_ids[2] = {{HSS0_PKT_TX0_QUEUE, HSS0_PKT_TXDONE_QUEUE, HSS0_PKT_RX_QUEUE,
-		  HSS0_PKT_RXFREE0_QUEUE},
-		 {HSS1_PKT_TX0_QUEUE, HSS1_PKT_TXDONE_QUEUE, HSS1_PKT_RX_QUEUE,
-		  HSS1_PKT_RXFREE0_QUEUE},
-};
-
 /*****************************************************************************
  * utility functions
  ****************************************************************************/
@@ -645,7 +651,7 @@ static void hss_hdlc_rx_irq(void *pdev)
 #if DEBUG_RX
 	printk(KERN_DEBUG "%s: hss_hdlc_rx_irq\n", dev->name);
 #endif
-	qmgr_disable_irq(queue_ids[port->id].rx);
+	qmgr_disable_irq(port->rxq);
 	napi_schedule(&port->napi);
 }
 
@@ -653,8 +659,8 @@ static int hss_hdlc_poll(struct napi_struct *napi, int budget)
 {
 	struct port *port = container_of(napi, struct port, napi);
 	struct net_device *dev = port->netdev;
-	unsigned int rxq = queue_ids[port->id].rx;
-	unsigned int rxfreeq = queue_ids[port->id].rxfree;
+	unsigned int rxq = port->rxq;
+	unsigned int rxfreeq = port->rxfreeq;
 	int received = 0;
 
 #if DEBUG_RX
@@ -795,7 +801,7 @@ static void hss_hdlc_txdone_irq(void *pdev)
 #if DEBUG_TX
 	printk(KERN_DEBUG DRV_NAME ": hss_hdlc_txdone_irq\n");
 #endif
-	while ((n_desc = queue_get_desc(queue_ids[port->id].txdone,
+	while ((n_desc = queue_get_desc(port->txdoneq,
 					port, 1)) >= 0) {
 		struct desc *desc;
 		int start;
@@ -813,8 +819,8 @@ static void hss_hdlc_txdone_irq(void *pdev)
 		free_buffer_irq(port->tx_buff_tab[n_desc]);
 		port->tx_buff_tab[n_desc] = NULL;
 
-		start = qmgr_stat_below_low_watermark(port->plat->txreadyq);
-		queue_put_desc(port->plat->txreadyq,
+		start = qmgr_stat_below_low_watermark(port->txreadyq);
+		queue_put_desc(port->txreadyq,
 			       tx_desc_phys(port, n_desc), desc);
 		if (start) { /* TX-ready queue was empty */
 #if DEBUG_TX
@@ -829,7 +835,7 @@ static void hss_hdlc_txdone_irq(void *pdev)
 static int hss_hdlc_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct port *port = dev_to_port(dev);
-	unsigned int txreadyq = port->plat->txreadyq;
+	unsigned int txreadyq = port->txreadyq;
 	int len, offset, bytes, n;
 	void *mem;
 	u32 phys;
@@ -889,7 +895,7 @@ static int hss_hdlc_xmit(struct sk_buff *skb, struct net_device *dev)
 	desc->buf_len = desc->pkt_len = len;
 
 	wmb();
-	queue_put_desc(queue_ids[port->id].tx, tx_desc_phys(port, n), desc);
+	queue_put_desc(port->txq, tx_desc_phys(port, n), desc);
 
 	if (qmgr_stat_below_low_watermark(txreadyq)) { /* empty */
 #if DEBUG_TX
@@ -916,40 +922,40 @@ static int request_hdlc_queues(struct port *port)
 {
 	int err;
 
-	err = qmgr_request_queue(queue_ids[port->id].rxfree, RX_DESCS, 0, 0,
+	err = qmgr_request_queue(port->rxfreeq, RX_DESCS, 0, 0,
 				 "%s:RX-free", port->netdev->name);
 	if (err)
 		return err;
 
-	err = qmgr_request_queue(queue_ids[port->id].rx, RX_DESCS, 0, 0,
+	err = qmgr_request_queue(port->rxq, RX_DESCS, 0, 0,
 				 "%s:RX", port->netdev->name);
 	if (err)
 		goto rel_rxfree;
 
-	err = qmgr_request_queue(queue_ids[port->id].tx, TX_DESCS, 0, 0,
+	err = qmgr_request_queue(port->txq, TX_DESCS, 0, 0,
 				 "%s:TX", port->netdev->name);
 	if (err)
 		goto rel_rx;
 
-	err = qmgr_request_queue(port->plat->txreadyq, TX_DESCS, 0, 0,
+	err = qmgr_request_queue(port->txreadyq, TX_DESCS, 0, 0,
 				 "%s:TX-ready", port->netdev->name);
 	if (err)
 		goto rel_tx;
 
-	err = qmgr_request_queue(queue_ids[port->id].txdone, TX_DESCS, 0, 0,
+	err = qmgr_request_queue(port->txdoneq, TX_DESCS, 0, 0,
 				 "%s:TX-done", port->netdev->name);
 	if (err)
 		goto rel_txready;
 	return 0;
 
 rel_txready:
-	qmgr_release_queue(port->plat->txreadyq);
+	qmgr_release_queue(port->txreadyq);
 rel_tx:
-	qmgr_release_queue(queue_ids[port->id].tx);
+	qmgr_release_queue(port->txq);
 rel_rx:
-	qmgr_release_queue(queue_ids[port->id].rx);
+	qmgr_release_queue(port->rxq);
 rel_rxfree:
-	qmgr_release_queue(queue_ids[port->id].rxfree);
+	qmgr_release_queue(port->rxfreeq);
 	printk(KERN_DEBUG "%s: unable to request hardware queues\n",
 	       port->netdev->name);
 	return err;
@@ -957,11 +963,11 @@ static int request_hdlc_queues(struct port *port)
 
 static void release_hdlc_queues(struct port *port)
 {
-	qmgr_release_queue(queue_ids[port->id].rxfree);
-	qmgr_release_queue(queue_ids[port->id].rx);
-	qmgr_release_queue(queue_ids[port->id].txdone);
-	qmgr_release_queue(queue_ids[port->id].tx);
-	qmgr_release_queue(port->plat->txreadyq);
+	qmgr_release_queue(port->rxfreeq);
+	qmgr_release_queue(port->rxq);
+	qmgr_release_queue(port->txdoneq);
+	qmgr_release_queue(port->txq);
+	qmgr_release_queue(port->txreadyq);
 }
 
 static int init_hdlc_queues(struct port *port)
@@ -1046,11 +1052,24 @@ static void destroy_hdlc_queues(struct port *port)
 	}
 }
 
+static irqreturn_t hss_hdlc_dcd_irq(int irq, void *data)
+{
+	struct net_device *dev = data;
+	struct port *port = dev_to_port(dev);
+	int val;
+
+	val = gpiod_get_value(port->dcd);
+	hss_hdlc_set_carrier(dev, val);
+
+	return IRQ_HANDLED;
+}
+
 static int hss_hdlc_open(struct net_device *dev)
 {
 	struct port *port = dev_to_port(dev);
 	unsigned long flags;
 	int i, err = 0;
+	int val;
 
 	err = hdlc_open(dev);
 	if (err)
@@ -1069,32 +1088,44 @@ static int hss_hdlc_open(struct net_device *dev)
 		goto err_destroy_queues;
 
 	spin_lock_irqsave(&npe_lock, flags);
-	if (port->plat->open) {
-		err = port->plat->open(port->id, dev, hss_hdlc_set_carrier);
-		if (err)
-			goto err_unlock;
+
+	/* Set the carrier, the GPIO is flagged active low so this will return
+	 * 1 if DCD is asserted.
+	 */
+	val = gpiod_get_value(port->dcd);
+	hss_hdlc_set_carrier(dev, val);
+
+	/* Set up an IRQ for DCD */
+	err = request_irq(gpiod_to_irq(port->dcd), hss_hdlc_dcd_irq, 0, "IXP4xx HSS", dev);
+	if (err) {
+		dev_err(&dev->dev, "ixp4xx_hss: failed to request DCD IRQ (%i)\n", err);
+		goto err_unlock;
 	}
 
+	/* GPIOs are flagged active low so this asserts DTR and RTS */
+	gpiod_set_value(port->dtr, 1);
+	gpiod_set_value(port->rts, 1);
+
 	spin_unlock_irqrestore(&npe_lock, flags);
 
 	/* Populate queues with buffers, no failure after this point */
 	for (i = 0; i < TX_DESCS; i++)
-		queue_put_desc(port->plat->txreadyq,
+		queue_put_desc(port->txreadyq,
 			       tx_desc_phys(port, i), tx_desc_ptr(port, i));
 
 	for (i = 0; i < RX_DESCS; i++)
-		queue_put_desc(queue_ids[port->id].rxfree,
+		queue_put_desc(port->rxfreeq,
 			       rx_desc_phys(port, i), rx_desc_ptr(port, i));
 
 	napi_enable(&port->napi);
 	netif_start_queue(dev);
 
-	qmgr_set_irq(queue_ids[port->id].rx, QUEUE_IRQ_SRC_NOT_EMPTY,
+	qmgr_set_irq(port->rxq, QUEUE_IRQ_SRC_NOT_EMPTY,
 		     hss_hdlc_rx_irq, dev);
 
-	qmgr_set_irq(queue_ids[port->id].txdone, QUEUE_IRQ_SRC_NOT_EMPTY,
+	qmgr_set_irq(port->txdoneq, QUEUE_IRQ_SRC_NOT_EMPTY,
 		     hss_hdlc_txdone_irq, dev);
-	qmgr_enable_irq(queue_ids[port->id].txdone);
+	qmgr_enable_irq(port->txdoneq);
 
 	ports_open++;
 
@@ -1125,15 +1156,15 @@ static int hss_hdlc_close(struct net_device *dev)
 
 	spin_lock_irqsave(&npe_lock, flags);
 	ports_open--;
-	qmgr_disable_irq(queue_ids[port->id].rx);
+	qmgr_disable_irq(port->rxq);
 	netif_stop_queue(dev);
 	napi_disable(&port->napi);
 
 	hss_stop_hdlc(port);
 
-	while (queue_get_desc(queue_ids[port->id].rxfree, port, 0) >= 0)
+	while (queue_get_desc(port->rxfreeq, port, 0) >= 0)
 		buffs--;
-	while (queue_get_desc(queue_ids[port->id].rx, port, 0) >= 0)
+	while (queue_get_desc(port->rxq, port, 0) >= 0)
 		buffs--;
 
 	if (buffs)
@@ -1141,12 +1172,12 @@ static int hss_hdlc_close(struct net_device *dev)
 			    buffs);
 
 	buffs = TX_DESCS;
-	while (queue_get_desc(queue_ids[port->id].tx, port, 1) >= 0)
+	while (queue_get_desc(port->txq, port, 1) >= 0)
 		buffs--; /* cancel TX */
 
 	i = 0;
 	do {
-		while (queue_get_desc(port->plat->txreadyq, port, 1) >= 0)
+		while (queue_get_desc(port->txreadyq, port, 1) >= 0)
 			buffs--;
 		if (!buffs)
 			break;
@@ -1159,10 +1190,12 @@ static int hss_hdlc_close(struct net_device *dev)
 	if (!buffs)
 		printk(KERN_DEBUG "Draining TX queues took %i cycles\n", i);
 #endif
-	qmgr_disable_irq(queue_ids[port->id].txdone);
+	qmgr_disable_irq(port->txdoneq);
 
-	if (port->plat->close)
-		port->plat->close(port->id, dev);
+	free_irq(gpiod_to_irq(port->dcd), dev);
+	/* GPIOs are flagged active low so this de-asserts DTR and RTS */
+	gpiod_set_value(port->dtr, 0);
+	gpiod_set_value(port->rts, 0);
 	spin_unlock_irqrestore(&npe_lock, flags);
 
 	destroy_hdlc_queues(port);
@@ -1254,6 +1287,21 @@ static void find_best_clock(u32 timer_freq, u32 rate, u32 *best, u32 *reg)
 	}
 }
 
+static int hss_hdlc_set_clock(struct port *port, unsigned int clock_type)
+{
+	switch (clock_type) {
+	case CLOCK_DEFAULT:
+	case CLOCK_EXT:
+		gpiod_set_value(port->clk_internal, 0);
+		return CLOCK_EXT;
+	case CLOCK_INT:
+		gpiod_set_value(port->clk_internal, 1);
+		return CLOCK_INT;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int hss_hdlc_ioctl(struct net_device *dev, struct if_settings *ifs)
 {
 	const size_t size = sizeof(sync_serial_settings);
@@ -1286,8 +1334,7 @@ static int hss_hdlc_ioctl(struct net_device *dev, struct if_settings *ifs)
 			return -EFAULT;
 
 		clk = new_line.clock_type;
-		if (port->plat->set_clock)
-			clk = port->plat->set_clock(port->id, clk);
+		hss_hdlc_set_clock(port, clk);
 
 		if (clk != CLOCK_EXT && clk != CLOCK_INT)
 			return -EINVAL;	/* No such clock setting */
@@ -1297,7 +1344,7 @@ static int hss_hdlc_ioctl(struct net_device *dev, struct if_settings *ifs)
 
 		port->clock_type = clk; /* Update settings */
 		if (clk == CLOCK_INT) {
-			find_best_clock(port->plat->timer_freq,
+			find_best_clock(IXP4XX_TIMER_FREQ,
 					new_line.clock_rate,
 					&port->clock_rate, &port->clock_reg);
 		} else {
@@ -1335,63 +1382,126 @@ static const struct net_device_ops hss_hdlc_ops = {
 	.ndo_siocwandev = hss_hdlc_ioctl,
 };
 
-static int hss_init_one(struct platform_device *pdev)
+static int ixp4xx_hss_probe(struct platform_device *pdev)
 {
+	struct of_phandle_args queue_spec;
+	struct of_phandle_args npe_spec;
+	struct device *dev = &pdev->dev;
+	struct net_device *ndev;
+	struct device_node *np;
 	struct port *port;
-	struct net_device *dev;
 	hdlc_device *hdlc;
 	int err;
 
-	port = kzalloc(sizeof(*port), GFP_KERNEL);
+	np = dev->of_node;
+
+	port = devm_kzalloc(dev, sizeof(*port), GFP_KERNEL);
 	if (!port)
 		return -ENOMEM;
 
-	port->npe = npe_request(0);
+	err = of_parse_phandle_with_fixed_args(np, "intel,npe-handle", 1, 0,
+					       &npe_spec);
+	if (err)
+		return dev_err_probe(dev, err, "no NPE engine specified\n");
+	/* NPE ID 0x00, 0x10, 0x20... */
+	port->npe = npe_request(npe_spec.args[0] << 4);
 	if (!port->npe) {
-		err = -ENODEV;
-		goto err_free;
+		dev_err(dev, "unable to obtain NPE instance\n");
+		return -ENODEV;
 	}
 
-	dev = alloc_hdlcdev(port);
+	/* Get the TX ready queue as resource from queue manager */
+	err = of_parse_phandle_with_fixed_args(np, "intek,queue-chl-txready", 1, 0,
+					       &queue_spec);
+	if (err)
+		return dev_err_probe(dev, err, "no txready queue phandle\n");
+	port->txreadyq = queue_spec.args[0];
+	/* Get the RX trig queue as resource from queue manager */
+	err = of_parse_phandle_with_fixed_args(np, "intek,queue-chl-rxtrig", 1, 0,
+					       &queue_spec);
+	if (err)
+		return dev_err_probe(dev, err, "no rxtrig queue phandle\n");
+	port->rxtrigq = queue_spec.args[0];
+	/* Get the RX queue as resource from queue manager */
+	err = of_parse_phandle_with_fixed_args(np, "intek,queue-pkt-rx", 1, 0,
+					       &queue_spec);
+	if (err)
+		return dev_err_probe(dev, err, "no RX queue phandle\n");
+	port->rxq = queue_spec.args[0];
+	/* Get the TX queue as resource from queue manager */
+	err = of_parse_phandle_with_fixed_args(np, "intek,queue-pkt-tx", 1, 0,
+					       &queue_spec);
+	if (err)
+		return dev_err_probe(dev, err, "no RX queue phandle\n");
+	port->txq = queue_spec.args[0];
+	/* Get the RX free queue as resource from queue manager */
+	err = of_parse_phandle_with_fixed_args(np, "intek,queue-pkt-rxfree", 1, 0,
+					       &queue_spec);
+	if (err)
+		return dev_err_probe(dev, err, "no RX free queue phandle\n");
+	port->rxfreeq = queue_spec.args[0];
+	/* Get the TX done queue as resource from queue manager */
+	err = of_parse_phandle_with_fixed_args(np, "intek,queue-pkt-txdone", 1, 0,
+					       &queue_spec);
+	if (err)
+		return dev_err_probe(dev, err, "no TX done queue phandle\n");
+	port->txdoneq = queue_spec.args[0];
+
+	/* Obtain all the line control GPIOs */
+	port->cts = devm_gpiod_get(dev, "cts", GPIOD_OUT_LOW);
+	if (IS_ERR(port->cts))
+		return dev_err_probe(dev, PTR_ERR(port->cts), "unable to get CTS GPIO\n");
+	port->rts = devm_gpiod_get(dev, "rts", GPIOD_OUT_LOW);
+	if (IS_ERR(port->rts))
+		return dev_err_probe(dev, PTR_ERR(port->rts), "unable to get RTS GPIO\n");
+	port->dcd = devm_gpiod_get(dev, "dcd", GPIOD_IN);
+	if (IS_ERR(port->dcd))
+		return dev_err_probe(dev, PTR_ERR(port->dcd), "unable to get DCD GPIO\n");
+	port->dtr = devm_gpiod_get(dev, "dtr", GPIOD_OUT_LOW);
+	if (IS_ERR(port->dtr))
+		return dev_err_probe(dev, PTR_ERR(port->dtr), "unable to get DTR GPIO\n");
+	port->clk_internal = devm_gpiod_get(dev, "clk-internal", GPIOD_OUT_LOW);
+	if (IS_ERR(port->clk_internal))
+		return dev_err_probe(dev, PTR_ERR(port->clk_internal),
+				     "unable to get CLK internal GPIO\n");
+
+	ndev = alloc_hdlcdev(port);
 	port->netdev = alloc_hdlcdev(port);
 	if (!port->netdev) {
 		err = -ENOMEM;
 		goto err_plat;
 	}
 
-	SET_NETDEV_DEV(dev, &pdev->dev);
-	hdlc = dev_to_hdlc(dev);
+	SET_NETDEV_DEV(ndev, &pdev->dev);
+	hdlc = dev_to_hdlc(ndev);
 	hdlc->attach = hss_hdlc_attach;
 	hdlc->xmit = hss_hdlc_xmit;
-	dev->netdev_ops = &hss_hdlc_ops;
-	dev->tx_queue_len = 100;
+	ndev->netdev_ops = &hss_hdlc_ops;
+	ndev->tx_queue_len = 100;
 	port->clock_type = CLOCK_EXT;
 	port->clock_rate = 0;
 	port->clock_reg = CLK42X_SPEED_2048KHZ;
 	port->id = pdev->id;
 	port->dev = &pdev->dev;
-	port->plat = pdev->dev.platform_data;
-	netif_napi_add(dev, &port->napi, hss_hdlc_poll, NAPI_WEIGHT);
+	netif_napi_add(ndev, &port->napi, hss_hdlc_poll, NAPI_WEIGHT);
 
-	err = register_hdlc_device(dev);
+	err = register_hdlc_device(ndev);
 	if (err)
 		goto err_free_netdev;
 
 	platform_set_drvdata(pdev, port);
 
-	netdev_info(dev, "initialized\n");
+	netdev_info(ndev, "initialized\n");
 	return 0;
 
 err_free_netdev:
-	free_netdev(dev);
+	free_netdev(ndev);
 err_plat:
 	npe_release(port->npe);
-err_free:
-	kfree(port);
 	return err;
 }
 
-static int hss_remove_one(struct platform_device *pdev)
+static int ixp4xx_hss_remove(struct platform_device *pdev)
 {
 	struct port *port = platform_get_drvdata(pdev);
 
@@ -1404,8 +1514,8 @@ static int hss_remove_one(struct platform_device *pdev)
 
 static struct platform_driver ixp4xx_hss_driver = {
 	.driver.name	= DRV_NAME,
-	.probe		= hss_init_one,
-	.remove		= hss_remove_one,
+	.probe		= ixp4xx_hss_probe,
+	.remove		= ixp4xx_hss_remove,
 };
 
 static int __init hss_init_module(void)
-- 
2.31.1

