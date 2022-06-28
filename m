Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F1455DBD5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243101AbiF1Be2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243082AbiF1BeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:34:16 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65D117A9E;
        Mon, 27 Jun 2022 18:34:11 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id c13so15432687eds.10;
        Mon, 27 Jun 2022 18:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xYY35n8nUk+Y7mWK36XJugw/PKkh3pxzjpPi6keFzO4=;
        b=FuO4H1WbZkjqb2hsvCvsyOqf/pewagNgUeEKbkxATiasS2lVsM0A6LrIW6CyLurGfC
         4fPf/SEdqcge8FXqio7wTZ8psBkgsmXTEmiL6f1M2oXzTTe7BFn1c8GxVwWhxD28edzI
         C65AbD8AR975rcq2ll58wxqLWj1mVgFRkNm+J/9KMZEKw4Ap/Hr5QY2qHDDvFZmqhChv
         d0G3kiwPYoKCzeE+WnnpbGnTMZ6x8gbwIjbOPb76r0wqGX2yoE3/T5GBpF7P7PHPe/Cu
         tAtQaPNcwxcZZx9DUwa6tgtgIZqTnpZySEyEuHOS3e5Ot4aZ1ipofpVzE7+i1mMI1Ah/
         rurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xYY35n8nUk+Y7mWK36XJugw/PKkh3pxzjpPi6keFzO4=;
        b=PuXdVBrTaCbF9dkP/pmUG0ygJHIo1tQUZv//xUIMsSLZiwK47iaZfkVgRuhpEjjHMp
         CgLcdQBjIBRLRy38LAuO0Uz1tizE1AZvRoXHCgPnUPtbpMrMH4pcrJlIyyRUYIABX8+F
         3fnIfbdC7zXoZ0ND7jkUSFtujYjS6ODA1JngAmP3k4GTEhsqav+wJzTlDJZBLKQaxmEQ
         e2+clH7UyRupgoSprKg9IPI0JtkyoF1nQdaRxxc2UoZ8JEhoaVOFDYhJXrR6u1At0aIP
         yE2u1WhEV7Cw59Is3fMp0ouzsEX1nhOSWtnKzaL0jsL8lAfF2Y5PCK0WG42ZrthUlCIv
         e9vw==
X-Gm-Message-State: AJIora+qCQTTg3EGwYNQhArIezSnuWjlaijl7quzZ4H/V77h5l4D4IyD
        IEKHqkY+GQL4jSop/Xrrc60=
X-Google-Smtp-Source: AGRyM1tlWyVMUjAN52UFSGMTTFjvk/9Nanv3++j8FzBJW6NH3iQL38/jX2l6KSiLB8k+MYd8KhXe1w==
X-Received: by 2002:a05:6402:3591:b0:436:c109:1fa7 with SMTP id y17-20020a056402359100b00436c1091fa7mr19881097edc.208.1656380050210;
        Mon, 27 Jun 2022 18:34:10 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id x13-20020a170906b08d00b00724261b592esm5693492ejy.186.2022.06.27.18.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 18:34:09 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC 4/5] net: ethernet: stmicro: stmmac: generate stmmac dma conf before open
Date:   Tue, 28 Jun 2022 03:33:41 +0200
Message-Id: <20220628013342.13581-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628013342.13581-1-ansuelsmth@gmail.com>
References: <20220628013342.13581-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rework the driver to generate the stmmac dma_conf before stmmac_open.
This permits a function to first check if it's possible to allocate a
new dma_config and then pass it directly to __stmmac_open and "open" the
interface with the new configuration.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 459 +++++++++++-------
 1 file changed, 287 insertions(+), 172 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c211d0274bba..330aac10a6e7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1230,7 +1230,8 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	return 0;
 }
 
-static void stmmac_display_rx_rings(struct stmmac_priv *priv)
+static void stmmac_display_rx_rings(struct stmmac_priv *priv,
+				    struct stmmac_dma_conf *dma_conf)
 {
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
 	unsigned int desc_size;
@@ -1239,7 +1240,7 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 
 	/* Display RX rings */
 	for (queue = 0; queue < rx_cnt; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+		struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 
 		pr_info("\tRX Queue %u rings\n", queue);
 
@@ -1252,12 +1253,13 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 		}
 
 		/* Display RX ring */
-		stmmac_display_ring(priv, head_rx, priv->dma_conf.dma_rx_size, true,
+		stmmac_display_ring(priv, head_rx, dma_conf->dma_rx_size, true,
 				    rx_q->dma_rx_phy, desc_size);
 	}
 }
 
-static void stmmac_display_tx_rings(struct stmmac_priv *priv)
+static void stmmac_display_tx_rings(struct stmmac_priv *priv,
+				    struct stmmac_dma_conf *dma_conf)
 {
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
 	unsigned int desc_size;
@@ -1266,7 +1268,7 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 
 	/* Display TX rings */
 	for (queue = 0; queue < tx_cnt; queue++) {
-		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
+		struct stmmac_tx_queue *tx_q = &dma_conf->tx_queue[queue];
 
 		pr_info("\tTX Queue %d rings\n", queue);
 
@@ -1281,18 +1283,19 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 			desc_size = sizeof(struct dma_desc);
 		}
 
-		stmmac_display_ring(priv, head_tx, priv->dma_conf.dma_tx_size, false,
+		stmmac_display_ring(priv, head_tx, dma_conf->dma_tx_size, false,
 				    tx_q->dma_tx_phy, desc_size);
 	}
 }
 
-static void stmmac_display_rings(struct stmmac_priv *priv)
+static void stmmac_display_rings(struct stmmac_priv *priv,
+				 struct stmmac_dma_conf *dma_conf)
 {
 	/* Display RX ring */
-	stmmac_display_rx_rings(priv);
+	stmmac_display_rx_rings(priv, dma_conf);
 
 	/* Display TX ring */
-	stmmac_display_tx_rings(priv);
+	stmmac_display_tx_rings(priv, dma_conf);
 }
 
 static int stmmac_set_bfsize(int mtu, int bufsize)
@@ -1316,44 +1319,50 @@ static int stmmac_set_bfsize(int mtu, int bufsize)
 /**
  * stmmac_clear_rx_descriptors - clear RX descriptors
  * @priv: driver private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: RX queue index
  * Description: this function is called to clear the RX descriptors
  * in case of both basic and extended descriptors are used.
  */
-static void stmmac_clear_rx_descriptors(struct stmmac_priv *priv, u32 queue)
+static void stmmac_clear_rx_descriptors(struct stmmac_priv *priv,
+					struct stmmac_dma_conf *dma_conf,
+					u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 	int i;
 
 	/* Clear the RX descriptors */
-	for (i = 0; i < priv->dma_conf.dma_rx_size; i++)
+	for (i = 0; i < dma_conf->dma_rx_size; i++)
 		if (priv->extend_desc)
 			stmmac_init_rx_desc(priv, &rx_q->dma_erx[i].basic,
 					priv->use_riwt, priv->mode,
-					(i == priv->dma_conf.dma_rx_size - 1),
-					priv->dma_conf.dma_buf_sz);
+					(i == dma_conf->dma_rx_size - 1),
+					dma_conf->dma_buf_sz);
 		else
 			stmmac_init_rx_desc(priv, &rx_q->dma_rx[i],
 					priv->use_riwt, priv->mode,
-					(i == priv->dma_conf.dma_rx_size - 1),
-					priv->dma_conf.dma_buf_sz);
+					(i == dma_conf->dma_rx_size - 1),
+					dma_conf->dma_buf_sz);
 }
 
 /**
  * stmmac_clear_tx_descriptors - clear tx descriptors
  * @priv: driver private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: TX queue index.
  * Description: this function is called to clear the TX descriptors
  * in case of both basic and extended descriptors are used.
  */
-static void stmmac_clear_tx_descriptors(struct stmmac_priv *priv, u32 queue)
+static void stmmac_clear_tx_descriptors(struct stmmac_priv *priv,
+					struct stmmac_dma_conf *dma_conf,
+					u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &dma_conf->tx_queue[queue];
 	int i;
 
 	/* Clear the TX descriptors */
-	for (i = 0; i < priv->dma_conf.dma_tx_size; i++) {
-		int last = (i == (priv->dma_conf.dma_tx_size - 1));
+	for (i = 0; i < dma_conf->dma_tx_size; i++) {
+		int last = (i == (dma_conf->dma_tx_size - 1));
 		struct dma_desc *p;
 
 		if (priv->extend_desc)
@@ -1370,10 +1379,12 @@ static void stmmac_clear_tx_descriptors(struct stmmac_priv *priv, u32 queue)
 /**
  * stmmac_clear_descriptors - clear descriptors
  * @priv: driver private structure
+ * @dma_conf:  structure to take the dma data
  * Description: this function is called to clear the TX and RX descriptors
  * in case of both basic and extended descriptors are used.
  */
-static void stmmac_clear_descriptors(struct stmmac_priv *priv)
+static void stmmac_clear_descriptors(struct stmmac_priv *priv,
+				     struct stmmac_dma_conf *dma_conf)
 {
 	u32 rx_queue_cnt = priv->plat->rx_queues_to_use;
 	u32 tx_queue_cnt = priv->plat->tx_queues_to_use;
@@ -1381,16 +1392,17 @@ static void stmmac_clear_descriptors(struct stmmac_priv *priv)
 
 	/* Clear the RX descriptors */
 	for (queue = 0; queue < rx_queue_cnt; queue++)
-		stmmac_clear_rx_descriptors(priv, queue);
+		stmmac_clear_rx_descriptors(priv, dma_conf, queue);
 
 	/* Clear the TX descriptors */
 	for (queue = 0; queue < tx_queue_cnt; queue++)
-		stmmac_clear_tx_descriptors(priv, queue);
+		stmmac_clear_tx_descriptors(priv, dma_conf, queue);
 }
 
 /**
  * stmmac_init_rx_buffers - init the RX descriptor buffer.
  * @priv: driver private structure
+ * @dma_conf:  structure to take the dma data
  * @p: descriptor pointer
  * @i: descriptor index
  * @flags: gfp flag
@@ -1398,10 +1410,12 @@ static void stmmac_clear_descriptors(struct stmmac_priv *priv)
  * Description: this function is called to allocate a receive buffer, perform
  * the DMA mapping and init the descriptor.
  */
-static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
+static int stmmac_init_rx_buffers(struct stmmac_priv *priv,
+				  struct stmmac_dma_conf *dma_conf,
+				  struct dma_desc *p,
 				  int i, gfp_t flags, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
@@ -1430,7 +1444,7 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 	buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;
 
 	stmmac_set_desc_addr(priv, p, buf->addr);
-	if (priv->dma_conf.dma_buf_sz == BUF_SIZE_16KiB)
+	if (dma_conf->dma_buf_sz == BUF_SIZE_16KiB)
 		stmmac_init_desc3(priv, p);
 
 	return 0;
@@ -1439,12 +1453,13 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 /**
  * stmmac_free_rx_buffer - free RX dma buffers
  * @priv: private structure
- * @queue: RX queue index
+ * @rx_q: RX queue
  * @i: buffer index.
  */
-static void stmmac_free_rx_buffer(struct stmmac_priv *priv, u32 queue, int i)
+static void stmmac_free_rx_buffer(struct stmmac_priv *priv,
+				  struct stmmac_rx_queue *rx_q,
+				  int i)
 {
-	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 
 	if (buf->page)
@@ -1459,12 +1474,15 @@ static void stmmac_free_rx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 /**
  * stmmac_free_tx_buffer - free RX dma buffers
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: RX queue index
  * @i: buffer index.
  */
-static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
+static void stmmac_free_tx_buffer(struct stmmac_priv *priv,
+				  struct stmmac_dma_conf *dma_conf,
+				  u32 queue, int i)
 {
-	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &dma_conf->tx_queue[queue];
 
 	if (tx_q->tx_skbuff_dma[i].buf &&
 	    tx_q->tx_skbuff_dma[i].buf_type != STMMAC_TXBUF_T_XDP_TX) {
@@ -1503,23 +1521,28 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 /**
  * dma_free_rx_skbufs - free RX dma buffers
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: RX queue index
  */
-static void dma_free_rx_skbufs(struct stmmac_priv *priv, u32 queue)
+static void dma_free_rx_skbufs(struct stmmac_priv *priv,
+			       struct stmmac_dma_conf *dma_conf,
+			       u32 queue)
 {
+	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 	int i;
 
-	for (i = 0; i < priv->dma_conf.dma_rx_size; i++)
-		stmmac_free_rx_buffer(priv, queue, i);
+	for (i = 0; i < dma_conf->dma_rx_size; i++)
+		stmmac_free_rx_buffer(priv, rx_q, i);
 }
 
-static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
-				   gfp_t flags)
+static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv,
+				   struct stmmac_dma_conf *dma_conf,
+				   u32 queue, gfp_t flags)
 {
-	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 	int i;
 
-	for (i = 0; i < priv->dma_conf.dma_rx_size; i++) {
+	for (i = 0; i < dma_conf->dma_rx_size; i++) {
 		struct dma_desc *p;
 		int ret;
 
@@ -1528,7 +1551,7 @@ static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
 		else
 			p = rx_q->dma_rx + i;
 
-		ret = stmmac_init_rx_buffers(priv, p, i, flags,
+		ret = stmmac_init_rx_buffers(priv, dma_conf, p, i, flags,
 					     queue);
 		if (ret)
 			return ret;
@@ -1542,14 +1565,17 @@ static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
 /**
  * dma_free_rx_xskbufs - free RX dma buffers from XSK pool
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: RX queue index
  */
-static void dma_free_rx_xskbufs(struct stmmac_priv *priv, u32 queue)
+static void dma_free_rx_xskbufs(struct stmmac_priv *priv,
+				struct stmmac_dma_conf *dma_conf,
+				u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 	int i;
 
-	for (i = 0; i < priv->dma_conf.dma_rx_size; i++) {
+	for (i = 0; i < dma_conf->dma_rx_size; i++) {
 		struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 
 		if (!buf->xdp)
@@ -1560,12 +1586,14 @@ static void dma_free_rx_xskbufs(struct stmmac_priv *priv, u32 queue)
 	}
 }
 
-static int stmmac_alloc_rx_buffers_zc(struct stmmac_priv *priv, u32 queue)
+static int stmmac_alloc_rx_buffers_zc(struct stmmac_priv *priv,
+				      struct stmmac_dma_conf *dma_conf,
+				      u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 	int i;
 
-	for (i = 0; i < priv->dma_conf.dma_rx_size; i++) {
+	for (i = 0; i < dma_conf->dma_rx_size; i++) {
 		struct stmmac_rx_buffer *buf;
 		dma_addr_t dma_addr;
 		struct dma_desc *p;
@@ -1600,22 +1628,25 @@ static struct xsk_buff_pool *stmmac_get_xsk_pool(struct stmmac_priv *priv, u32 q
 /**
  * __init_dma_rx_desc_rings - init the RX descriptor ring (per queue)
  * @priv: driver private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: RX queue index
  * @flags: gfp flag.
  * Description: this function initializes the DMA RX descriptors
  * and allocates the socket buffers. It supports the chained and ring
  * modes.
  */
-static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t flags)
+static int __init_dma_rx_desc_rings(struct stmmac_priv *priv,
+				    struct stmmac_dma_conf *dma_conf,
+				    u32 queue, gfp_t flags)
 {
-	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 	int ret;
 
 	netif_dbg(priv, probe, priv->dev,
 		  "(%s) dma_rx_phy=0x%08x\n", __func__,
 		  (u32)rx_q->dma_rx_phy);
 
-	stmmac_clear_rx_descriptors(priv, queue);
+	stmmac_clear_rx_descriptors(priv, dma_conf, queue);
 
 	xdp_rxq_info_unreg_mem_model(&rx_q->xdp_rxq);
 
@@ -1642,9 +1673,9 @@ static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t f
 		/* RX XDP ZC buffer pool may not be populated, e.g.
 		 * xdpsock TX-only.
 		 */
-		stmmac_alloc_rx_buffers_zc(priv, queue);
+		stmmac_alloc_rx_buffers_zc(priv, dma_conf, queue);
 	} else {
-		ret = stmmac_alloc_rx_buffers(priv, queue, flags);
+		ret = stmmac_alloc_rx_buffers(priv, dma_conf, queue, flags);
 		if (ret < 0)
 			return -ENOMEM;
 	}
@@ -1654,17 +1685,19 @@ static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t f
 		if (priv->extend_desc)
 			stmmac_mode_init(priv, rx_q->dma_erx,
 					 rx_q->dma_rx_phy,
-					 priv->dma_conf.dma_rx_size, 1);
+					 dma_conf->dma_rx_size, 1);
 		else
 			stmmac_mode_init(priv, rx_q->dma_rx,
 					 rx_q->dma_rx_phy,
-					 priv->dma_conf.dma_rx_size, 0);
+					 dma_conf->dma_rx_size, 0);
 	}
 
 	return 0;
 }
 
-static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
+static int init_dma_rx_desc_rings(struct net_device *dev,
+				  struct stmmac_dma_conf *dma_conf,
+				  gfp_t flags)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_count = priv->plat->rx_queues_to_use;
@@ -1676,7 +1709,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 		  "SKB addresses:\nskb\t\tskb data\tdma data\n");
 
 	for (queue = 0; queue < rx_count; queue++) {
-		ret = __init_dma_rx_desc_rings(priv, queue, flags);
+		ret = __init_dma_rx_desc_rings(priv, dma_conf, queue, flags);
 		if (ret)
 			goto err_init_rx_buffers;
 	}
@@ -1685,12 +1718,12 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 
 err_init_rx_buffers:
 	while (queue >= 0) {
-		struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+		struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 
 		if (rx_q->xsk_pool)
-			dma_free_rx_xskbufs(priv, queue);
+			dma_free_rx_xskbufs(priv, dma_conf, queue);
 		else
-			dma_free_rx_skbufs(priv, queue);
+			dma_free_rx_skbufs(priv, dma_conf, queue);
 
 		rx_q->buf_alloc_num = 0;
 		rx_q->xsk_pool = NULL;
@@ -1709,9 +1742,11 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
  * and allocates the socket buffers. It supports the chained and ring
  * modes.
  */
-static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
+static int __init_dma_tx_desc_rings(struct stmmac_priv *priv,
+				    struct stmmac_dma_conf *dma_conf,
+				    u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &dma_conf->tx_queue[queue];
 	int i;
 
 	netif_dbg(priv, probe, priv->dev,
@@ -1723,16 +1758,16 @@ static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
 		if (priv->extend_desc)
 			stmmac_mode_init(priv, tx_q->dma_etx,
 					 tx_q->dma_tx_phy,
-					 priv->dma_conf.dma_tx_size, 1);
+					 dma_conf->dma_tx_size, 1);
 		else if (!(tx_q->tbs & STMMAC_TBS_AVAIL))
 			stmmac_mode_init(priv, tx_q->dma_tx,
 					 tx_q->dma_tx_phy,
-					 priv->dma_conf.dma_tx_size, 0);
+					 dma_conf->dma_tx_size, 0);
 	}
 
 	tx_q->xsk_pool = stmmac_get_xsk_pool(priv, queue);
 
-	for (i = 0; i < priv->dma_conf.dma_tx_size; i++) {
+	for (i = 0; i < dma_conf->dma_tx_size; i++) {
 		struct dma_desc *p;
 
 		if (priv->extend_desc)
@@ -1754,7 +1789,8 @@ static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
 	return 0;
 }
 
-static int init_dma_tx_desc_rings(struct net_device *dev)
+static int init_dma_tx_desc_rings(struct net_device *dev,
+				  struct stmmac_dma_conf *dma_conf)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 tx_queue_cnt;
@@ -1763,7 +1799,7 @@ static int init_dma_tx_desc_rings(struct net_device *dev)
 	tx_queue_cnt = priv->plat->tx_queues_to_use;
 
 	for (queue = 0; queue < tx_queue_cnt; queue++)
-		__init_dma_tx_desc_rings(priv, queue);
+		__init_dma_tx_desc_rings(priv, dma_conf, queue);
 
 	return 0;
 }
@@ -1771,26 +1807,29 @@ static int init_dma_tx_desc_rings(struct net_device *dev)
 /**
  * init_dma_desc_rings - init the RX/TX descriptor rings
  * @dev: net device structure
+ * @dma_conf:  structure to take the dma data
  * @flags: gfp flag.
  * Description: this function initializes the DMA RX/TX descriptors
  * and allocates the socket buffers. It supports the chained and ring
  * modes.
  */
-static int init_dma_desc_rings(struct net_device *dev, gfp_t flags)
+static int init_dma_desc_rings(struct net_device *dev,
+			       struct stmmac_dma_conf *dma_conf,
+			       gfp_t flags)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
 
-	ret = init_dma_rx_desc_rings(dev, flags);
+	ret = init_dma_rx_desc_rings(dev, dma_conf, flags);
 	if (ret)
 		return ret;
 
-	ret = init_dma_tx_desc_rings(dev);
+	ret = init_dma_tx_desc_rings(dev, dma_conf);
 
-	stmmac_clear_descriptors(priv);
+	stmmac_clear_descriptors(priv, dma_conf);
 
 	if (netif_msg_hw(priv))
-		stmmac_display_rings(priv);
+		stmmac_display_rings(priv, dma_conf);
 
 	return ret;
 }
@@ -1798,17 +1837,20 @@ static int init_dma_desc_rings(struct net_device *dev, gfp_t flags)
 /**
  * dma_free_tx_skbufs - free TX dma buffers
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: TX queue index
  */
-static void dma_free_tx_skbufs(struct stmmac_priv *priv, u32 queue)
+static void dma_free_tx_skbufs(struct stmmac_priv *priv,
+			       struct stmmac_dma_conf *dma_conf,
+			       u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &dma_conf->tx_queue[queue];
 	int i;
 
 	tx_q->xsk_frames_done = 0;
 
-	for (i = 0; i < priv->dma_conf.dma_tx_size; i++)
-		stmmac_free_tx_buffer(priv, queue, i);
+	for (i = 0; i < dma_conf->dma_tx_size; i++)
+		stmmac_free_tx_buffer(priv, dma_conf, queue, i);
 
 	if (tx_q->xsk_pool && tx_q->xsk_frames_done) {
 		xsk_tx_completed(tx_q->xsk_pool, tx_q->xsk_frames_done);
@@ -1827,34 +1869,37 @@ static void stmmac_free_tx_skbufs(struct stmmac_priv *priv)
 	u32 queue;
 
 	for (queue = 0; queue < tx_queue_cnt; queue++)
-		dma_free_tx_skbufs(priv, queue);
+		dma_free_tx_skbufs(priv, &priv->dma_conf, queue);
 }
 
 /**
  * __free_dma_rx_desc_resources - free RX dma desc resources (per queue)
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: RX queue index
  */
-static void __free_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
+static void __free_dma_rx_desc_resources(struct stmmac_priv *priv,
+					 struct stmmac_dma_conf *dma_conf,
+					 u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 
 	/* Release the DMA RX socket buffers */
 	if (rx_q->xsk_pool)
-		dma_free_rx_xskbufs(priv, queue);
+		dma_free_rx_xskbufs(priv, dma_conf, queue);
 	else
-		dma_free_rx_skbufs(priv, queue);
+		dma_free_rx_skbufs(priv, dma_conf, queue);
 
 	rx_q->buf_alloc_num = 0;
 	rx_q->xsk_pool = NULL;
 
 	/* Free DMA regions of consistent memory previously allocated */
 	if (!priv->extend_desc)
-		dma_free_coherent(priv->device, priv->dma_conf.dma_rx_size *
+		dma_free_coherent(priv->device, dma_conf->dma_rx_size *
 				  sizeof(struct dma_desc),
 				  rx_q->dma_rx, rx_q->dma_rx_phy);
 	else
-		dma_free_coherent(priv->device, priv->dma_conf.dma_rx_size *
+		dma_free_coherent(priv->device, dma_conf->dma_rx_size *
 				  sizeof(struct dma_extended_desc),
 				  rx_q->dma_erx, rx_q->dma_rx_phy);
 
@@ -1866,29 +1911,33 @@ static void __free_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 		page_pool_destroy(rx_q->page_pool);
 }
 
-static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
+static void free_dma_rx_desc_resources(struct stmmac_priv *priv,
+				       struct stmmac_dma_conf *dma_conf)
 {
 	u32 rx_count = priv->plat->rx_queues_to_use;
 	u32 queue;
 
 	/* Free RX queue resources */
 	for (queue = 0; queue < rx_count; queue++)
-		__free_dma_rx_desc_resources(priv, queue);
+		__free_dma_rx_desc_resources(priv, dma_conf, queue);
 }
 
 /**
  * __free_dma_tx_desc_resources - free TX dma desc resources (per queue)
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: TX queue index
  */
-static void __free_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
+static void __free_dma_tx_desc_resources(struct stmmac_priv *priv,
+					 struct stmmac_dma_conf *dma_conf,
+					 u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &dma_conf->tx_queue[queue];
 	size_t size;
 	void *addr;
 
 	/* Release the DMA TX socket buffers */
-	dma_free_tx_skbufs(priv, queue);
+	dma_free_tx_skbufs(priv, dma_conf, queue);
 
 	if (priv->extend_desc) {
 		size = sizeof(struct dma_extended_desc);
@@ -1901,7 +1950,7 @@ static void __free_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 		addr = tx_q->dma_tx;
 	}
 
-	size *= priv->dma_conf.dma_tx_size;
+	size *= dma_conf->dma_tx_size;
 
 	dma_free_coherent(priv->device, size, addr, tx_q->dma_tx_phy);
 
@@ -1909,28 +1958,32 @@ static void __free_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	kfree(tx_q->tx_skbuff);
 }
 
-static void free_dma_tx_desc_resources(struct stmmac_priv *priv)
+static void free_dma_tx_desc_resources(struct stmmac_priv *priv,
+				       struct stmmac_dma_conf *dma_conf)
 {
 	u32 tx_count = priv->plat->tx_queues_to_use;
 	u32 queue;
 
 	/* Free TX queue resources */
 	for (queue = 0; queue < tx_count; queue++)
-		__free_dma_tx_desc_resources(priv, queue);
+		__free_dma_tx_desc_resources(priv, dma_conf, queue);
 }
 
 /**
  * __alloc_dma_rx_desc_resources - alloc RX resources (per queue).
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: RX queue index
  * Description: according to which descriptor can be used (extend or basic)
  * this function allocates the resources for TX and RX paths. In case of
  * reception, for example, it pre-allocated the RX socket buffer in order to
  * allow zero-copy mechanism.
  */
-static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
+static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv,
+					 struct stmmac_dma_conf *dma_conf,
+					 u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	bool xdp_prog = stmmac_xdp_is_enabled(priv);
 	struct page_pool_params pp_params = { 0 };
@@ -1942,8 +1995,8 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	rx_q->priv_data = priv;
 
 	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
-	pp_params.pool_size = priv->dma_conf.dma_rx_size;
-	num_pages = DIV_ROUND_UP(priv->dma_conf.dma_buf_sz, PAGE_SIZE);
+	pp_params.pool_size = dma_conf->dma_rx_size;
+	num_pages = DIV_ROUND_UP(dma_conf->dma_buf_sz, PAGE_SIZE);
 	pp_params.order = ilog2(num_pages);
 	pp_params.nid = dev_to_node(priv->device);
 	pp_params.dev = priv->device;
@@ -1958,7 +2011,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 		return ret;
 	}
 
-	rx_q->buf_pool = kcalloc(priv->dma_conf.dma_rx_size,
+	rx_q->buf_pool = kcalloc(dma_conf->dma_rx_size,
 				 sizeof(*rx_q->buf_pool),
 				 GFP_KERNEL);
 	if (!rx_q->buf_pool)
@@ -1966,7 +2019,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 
 	if (priv->extend_desc) {
 		rx_q->dma_erx = dma_alloc_coherent(priv->device,
-						   priv->dma_conf.dma_rx_size *
+						   dma_conf->dma_rx_size *
 						   sizeof(struct dma_extended_desc),
 						   &rx_q->dma_rx_phy,
 						   GFP_KERNEL);
@@ -1975,7 +2028,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 
 	} else {
 		rx_q->dma_rx = dma_alloc_coherent(priv->device,
-						  priv->dma_conf.dma_rx_size *
+						  dma_conf->dma_rx_size *
 						  sizeof(struct dma_desc),
 						  &rx_q->dma_rx_phy,
 						  GFP_KERNEL);
@@ -2000,7 +2053,8 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	return 0;
 }
 
-static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
+static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv,
+				       struct stmmac_dma_conf *dma_conf)
 {
 	u32 rx_count = priv->plat->rx_queues_to_use;
 	u32 queue;
@@ -2008,7 +2062,7 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 
 	/* RX queues buffers and DMA */
 	for (queue = 0; queue < rx_count; queue++) {
-		ret = __alloc_dma_rx_desc_resources(priv, queue);
+		ret = __alloc_dma_rx_desc_resources(priv, dma_conf, queue);
 		if (ret)
 			goto err_dma;
 	}
@@ -2016,7 +2070,7 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 	return 0;
 
 err_dma:
-	free_dma_rx_desc_resources(priv);
+	free_dma_rx_desc_resources(priv, dma_conf);
 
 	return ret;
 }
@@ -2024,28 +2078,31 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 /**
  * __alloc_dma_tx_desc_resources - alloc TX resources (per queue).
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  * @queue: TX queue index
  * Description: according to which descriptor can be used (extend or basic)
  * this function allocates the resources for TX and RX paths. In case of
  * reception, for example, it pre-allocated the RX socket buffer in order to
  * allow zero-copy mechanism.
  */
-static int __alloc_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
+static int __alloc_dma_tx_desc_resources(struct stmmac_priv *priv,
+					 struct stmmac_dma_conf *dma_conf,
+					 u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &dma_conf->tx_queue[queue];
 	size_t size;
 	void *addr;
 
 	tx_q->queue_index = queue;
 	tx_q->priv_data = priv;
 
-	tx_q->tx_skbuff_dma = kcalloc(priv->dma_conf.dma_tx_size,
+	tx_q->tx_skbuff_dma = kcalloc(dma_conf->dma_tx_size,
 				      sizeof(*tx_q->tx_skbuff_dma),
 				      GFP_KERNEL);
 	if (!tx_q->tx_skbuff_dma)
 		return -ENOMEM;
 
-	tx_q->tx_skbuff = kcalloc(priv->dma_conf.dma_tx_size,
+	tx_q->tx_skbuff = kcalloc(dma_conf->dma_tx_size,
 				  sizeof(struct sk_buff *),
 				  GFP_KERNEL);
 	if (!tx_q->tx_skbuff)
@@ -2058,7 +2115,7 @@ static int __alloc_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	else
 		size = sizeof(struct dma_desc);
 
-	size *= priv->dma_conf.dma_tx_size;
+	size *= dma_conf->dma_tx_size;
 
 	addr = dma_alloc_coherent(priv->device, size,
 				  &tx_q->dma_tx_phy, GFP_KERNEL);
@@ -2075,7 +2132,8 @@ static int __alloc_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	return 0;
 }
 
-static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv)
+static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv,
+				       struct stmmac_dma_conf *dma_conf)
 {
 	u32 tx_count = priv->plat->tx_queues_to_use;
 	u32 queue;
@@ -2083,7 +2141,7 @@ static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv)
 
 	/* TX queues buffers and DMA */
 	for (queue = 0; queue < tx_count; queue++) {
-		ret = __alloc_dma_tx_desc_resources(priv, queue);
+		ret = __alloc_dma_tx_desc_resources(priv, dma_conf, queue);
 		if (ret)
 			goto err_dma;
 	}
@@ -2091,27 +2149,29 @@ static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv)
 	return 0;
 
 err_dma:
-	free_dma_tx_desc_resources(priv);
+	free_dma_tx_desc_resources(priv, dma_conf);
 	return ret;
 }
 
 /**
  * alloc_dma_desc_resources - alloc TX/RX resources.
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  * Description: according to which descriptor can be used (extend or basic)
  * this function allocates the resources for TX and RX paths. In case of
  * reception, for example, it pre-allocated the RX socket buffer in order to
  * allow zero-copy mechanism.
  */
-static int alloc_dma_desc_resources(struct stmmac_priv *priv)
+static int alloc_dma_desc_resources(struct stmmac_priv *priv,
+				    struct stmmac_dma_conf *dma_conf)
 {
 	/* RX Allocation */
-	int ret = alloc_dma_rx_desc_resources(priv);
+	int ret = alloc_dma_rx_desc_resources(priv, dma_conf);
 
 	if (ret)
 		return ret;
 
-	ret = alloc_dma_tx_desc_resources(priv);
+	ret = alloc_dma_tx_desc_resources(priv, dma_conf);
 
 	return ret;
 }
@@ -2119,16 +2179,18 @@ static int alloc_dma_desc_resources(struct stmmac_priv *priv)
 /**
  * free_dma_desc_resources - free dma desc resources
  * @priv: private structure
+ * @dma_conf:  structure to take the dma data
  */
-static void free_dma_desc_resources(struct stmmac_priv *priv)
+static void free_dma_desc_resources(struct stmmac_priv *priv,
+				    struct stmmac_dma_conf *dma_conf)
 {
 	/* Release the DMA TX socket buffers */
-	free_dma_tx_desc_resources(priv);
+	free_dma_tx_desc_resources(priv, dma_conf);
 
 	/* Release the DMA RX socket buffers later
 	 * to ensure all pending XDP_TX buffers are returned.
 	 */
-	free_dma_rx_desc_resources(priv);
+	free_dma_rx_desc_resources(priv, dma_conf);
 }
 
 /**
@@ -2634,8 +2696,8 @@ static void stmmac_tx_err(struct stmmac_priv *priv, u32 chan)
 	netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, chan));
 
 	stmmac_stop_tx_dma(priv, chan);
-	dma_free_tx_skbufs(priv, chan);
-	stmmac_clear_tx_descriptors(priv, chan);
+	dma_free_tx_skbufs(priv, &priv->dma_conf, chan);
+	stmmac_clear_tx_descriptors(priv, &priv->dma_conf, chan);
 	stmmac_reset_tx_queue(priv, chan);
 	stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 			    tx_q->dma_tx_phy, chan);
@@ -3618,19 +3680,93 @@ static int stmmac_request_irq(struct net_device *dev)
 }
 
 /**
- *  stmmac_open - open entry point of the driver
+ *  stmmac_setup_dma_desc - Generate a dma_conf and allocate DMA queue
+ *  @priv: driver private structure
+ *  @mtu: MTU to setup the dma queue and buf with
+ *  Description: Allocate and generate a dma_conf based on the provided MTU.
+ *  Allocate the Tx/Rx DMA queue and init them.
+ *  Return value:
+ *  the dma_conf allocated struct on success and an appropriate ERR_PTR on failure.
+ */
+static struct stmmac_dma_conf *
+stmmac_setup_dma_desc(struct stmmac_priv *priv, unsigned int mtu)
+{
+	struct stmmac_dma_conf *dma_conf;
+	int chan, bfsize, ret;
+
+	dma_conf = kzalloc(sizeof(*dma_conf), GFP_KERNEL);
+	if (!dma_conf) {
+		netdev_err(priv->dev, "%s: DMA conf allocation failed\n",
+			   __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	bfsize = stmmac_set_16kib_bfsize(priv, mtu);
+	if (bfsize < 0)
+		bfsize = 0;
+
+	if (bfsize < BUF_SIZE_16KiB)
+		bfsize = stmmac_set_bfsize(mtu, 0);
+
+	dma_conf->dma_buf_sz = bfsize;
+	/* Chose the tx/rx size from the already defined one in the
+	 * priv struct. (if defined)
+	 */
+	dma_conf->dma_tx_size = priv->dma_conf.dma_tx_size;
+	dma_conf->dma_rx_size = priv->dma_conf.dma_rx_size;
+
+	if (!dma_conf->dma_tx_size)
+		dma_conf->dma_tx_size = DMA_DEFAULT_TX_SIZE;
+	if (!dma_conf->dma_rx_size)
+		dma_conf->dma_rx_size = DMA_DEFAULT_RX_SIZE;
+
+	/* Earlier check for TBS */
+	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++) {
+		struct stmmac_tx_queue *tx_q = &dma_conf->tx_queue[chan];
+		int tbs_en = priv->plat->tx_queues_cfg[chan].tbs_en;
+
+		/* Setup per-TXQ tbs flag before TX descriptor alloc */
+		tx_q->tbs |= tbs_en ? STMMAC_TBS_AVAIL : 0;
+	}
+
+	ret = alloc_dma_desc_resources(priv, dma_conf);
+	if (ret < 0) {
+		netdev_err(priv->dev, "%s: DMA descriptors allocation failed\n",
+			   __func__);
+		goto alloc_error;
+	}
+
+	ret = init_dma_desc_rings(priv->dev, dma_conf, GFP_KERNEL);
+	if (ret < 0) {
+		netdev_err(priv->dev, "%s: DMA descriptors initialization failed\n",
+			   __func__);
+		goto init_error;
+	}
+
+	return dma_conf;
+
+init_error:
+	free_dma_desc_resources(priv, dma_conf);
+alloc_error:
+	kfree(dma_conf);
+	return ERR_PTR(ret);
+}
+
+/**
+ *  __stmmac_open - open entry point of the driver
  *  @dev : pointer to the device structure.
+ *  @dma_conf :  structure to take the dma data
  *  Description:
  *  This function is the open entry point of the driver.
  *  Return value:
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-static int stmmac_open(struct net_device *dev)
+static int __stmmac_open(struct net_device *dev,
+			 struct stmmac_dma_conf *dma_conf)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int mode = priv->plat->phy_interface;
-	int bfsize = 0;
 	u32 chan;
 	int ret;
 
@@ -3655,45 +3791,10 @@ static int stmmac_open(struct net_device *dev)
 	memset(&priv->xstats, 0, sizeof(struct stmmac_extra_stats));
 	priv->xstats.threshold = tc;
 
-	bfsize = stmmac_set_16kib_bfsize(priv, dev->mtu);
-	if (bfsize < 0)
-		bfsize = 0;
-
-	if (bfsize < BUF_SIZE_16KiB)
-		bfsize = stmmac_set_bfsize(dev->mtu, priv->dma_conf.dma_buf_sz);
-
-	priv->dma_conf.dma_buf_sz = bfsize;
-	buf_sz = bfsize;
-
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
-	if (!priv->dma_conf.dma_tx_size)
-		priv->dma_conf.dma_tx_size = DMA_DEFAULT_TX_SIZE;
-	if (!priv->dma_conf.dma_rx_size)
-		priv->dma_conf.dma_rx_size = DMA_DEFAULT_RX_SIZE;
-
-	/* Earlier check for TBS */
-	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++) {
-		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
-		int tbs_en = priv->plat->tx_queues_cfg[chan].tbs_en;
-
-		/* Setup per-TXQ tbs flag before TX descriptor alloc */
-		tx_q->tbs |= tbs_en ? STMMAC_TBS_AVAIL : 0;
-	}
-
-	ret = alloc_dma_desc_resources(priv);
-	if (ret < 0) {
-		netdev_err(priv->dev, "%s: DMA descriptors allocation failed\n",
-			   __func__);
-		goto dma_desc_error;
-	}
-
-	ret = init_dma_desc_rings(dev, GFP_KERNEL);
-	if (ret < 0) {
-		netdev_err(priv->dev, "%s: DMA descriptors initialization failed\n",
-			   __func__);
-		goto init_error;
-	}
+	buf_sz = dma_conf->dma_buf_sz;
+	memcpy(&priv->dma_conf, dma_conf, sizeof(*dma_conf));
 
 	stmmac_reset_queues_param(priv);
 
@@ -3727,14 +3828,28 @@ static int stmmac_open(struct net_device *dev)
 
 	stmmac_hw_teardown(dev);
 init_error:
-	free_dma_desc_resources(priv);
-dma_desc_error:
+	free_dma_desc_resources(priv, &priv->dma_conf);
 	phylink_disconnect_phy(priv->phylink);
 init_phy_error:
 	pm_runtime_put(priv->device);
 	return ret;
 }
 
+static int stmmac_open(struct net_device *dev)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	struct stmmac_dma_conf *dma_conf;
+	int ret;
+
+	dma_conf = stmmac_setup_dma_desc(priv, dev->mtu);
+	if (IS_ERR(dma_conf))
+		return PTR_ERR(dma_conf);
+
+	ret = __stmmac_open(dev, dma_conf);
+	kfree(dma_conf);
+	return ret;
+}
+
 static void stmmac_fpe_stop_wq(struct stmmac_priv *priv)
 {
 	set_bit(__FPE_REMOVING, &priv->fpe_task_state);
@@ -3781,7 +3896,7 @@ static int stmmac_release(struct net_device *dev)
 	stmmac_stop_all_dma(priv);
 
 	/* Release and free the Rx/Tx resources */
-	free_dma_desc_resources(priv);
+	free_dma_desc_resources(priv, &priv->dma_conf);
 
 	/* Disable the MAC Rx/Tx */
 	stmmac_mac_set(priv, priv->ioaddr, false);
@@ -6303,7 +6418,7 @@ void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue)
 	spin_unlock_irqrestore(&ch->lock, flags);
 
 	stmmac_stop_rx_dma(priv, queue);
-	__free_dma_rx_desc_resources(priv, queue);
+	__free_dma_rx_desc_resources(priv, &priv->dma_conf, queue);
 }
 
 void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue)
@@ -6314,21 +6429,21 @@ void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue)
 	u32 buf_size;
 	int ret;
 
-	ret = __alloc_dma_rx_desc_resources(priv, queue);
+	ret = __alloc_dma_rx_desc_resources(priv, &priv->dma_conf, queue);
 	if (ret) {
 		netdev_err(priv->dev, "Failed to alloc RX desc.\n");
 		return;
 	}
 
-	ret = __init_dma_rx_desc_rings(priv, queue, GFP_KERNEL);
+	ret = __init_dma_rx_desc_rings(priv, &priv->dma_conf, queue, GFP_KERNEL);
 	if (ret) {
-		__free_dma_rx_desc_resources(priv, queue);
+		__free_dma_rx_desc_resources(priv, &priv->dma_conf, queue);
 		netdev_err(priv->dev, "Failed to init RX desc.\n");
 		return;
 	}
 
 	stmmac_reset_rx_queue(priv, queue);
-	stmmac_clear_rx_descriptors(priv, queue);
+	stmmac_clear_rx_descriptors(priv, &priv->dma_conf, queue);
 
 	stmmac_init_rx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 			    rx_q->dma_rx_phy, rx_q->queue_index);
@@ -6366,7 +6481,7 @@ void stmmac_disable_tx_queue(struct stmmac_priv *priv, u32 queue)
 	spin_unlock_irqrestore(&ch->lock, flags);
 
 	stmmac_stop_tx_dma(priv, queue);
-	__free_dma_tx_desc_resources(priv, queue);
+	__free_dma_tx_desc_resources(priv, &priv->dma_conf, queue);
 }
 
 void stmmac_enable_tx_queue(struct stmmac_priv *priv, u32 queue)
@@ -6376,21 +6491,21 @@ void stmmac_enable_tx_queue(struct stmmac_priv *priv, u32 queue)
 	unsigned long flags;
 	int ret;
 
-	ret = __alloc_dma_tx_desc_resources(priv, queue);
+	ret = __alloc_dma_tx_desc_resources(priv, &priv->dma_conf, queue);
 	if (ret) {
 		netdev_err(priv->dev, "Failed to alloc TX desc.\n");
 		return;
 	}
 
-	ret = __init_dma_tx_desc_rings(priv, queue);
+	ret = __init_dma_tx_desc_rings(priv,  &priv->dma_conf, queue);
 	if (ret) {
-		__free_dma_tx_desc_resources(priv, queue);
+		__free_dma_tx_desc_resources(priv, &priv->dma_conf, queue);
 		netdev_err(priv->dev, "Failed to init TX desc.\n");
 		return;
 	}
 
 	stmmac_reset_tx_queue(priv, queue);
-	stmmac_clear_tx_descriptors(priv, queue);
+	stmmac_clear_tx_descriptors(priv, &priv->dma_conf, queue);
 
 	stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 			    tx_q->dma_tx_phy, tx_q->queue_index);
@@ -6427,7 +6542,7 @@ void stmmac_xdp_release(struct net_device *dev)
 	stmmac_stop_all_dma(priv);
 
 	/* Release and free the Rx/Tx resources */
-	free_dma_desc_resources(priv);
+	free_dma_desc_resources(priv, &priv->dma_conf);
 
 	/* Disable the MAC Rx/Tx */
 	stmmac_mac_set(priv, priv->ioaddr, false);
@@ -6452,14 +6567,14 @@ int stmmac_xdp_open(struct net_device *dev)
 	u32 chan;
 	int ret;
 
-	ret = alloc_dma_desc_resources(priv);
+	ret = alloc_dma_desc_resources(priv, &priv->dma_conf);
 	if (ret < 0) {
 		netdev_err(dev, "%s: DMA descriptors allocation failed\n",
 			   __func__);
 		goto dma_desc_error;
 	}
 
-	ret = init_dma_desc_rings(dev, GFP_KERNEL);
+	ret = init_dma_desc_rings(dev, &priv->dma_conf, GFP_KERNEL);
 	if (ret < 0) {
 		netdev_err(dev, "%s: DMA descriptors initialization failed\n",
 			   __func__);
@@ -6541,7 +6656,7 @@ int stmmac_xdp_open(struct net_device *dev)
 
 	stmmac_hw_teardown(dev);
 init_error:
-	free_dma_desc_resources(priv);
+	free_dma_desc_resources(priv, &priv->dma_conf);
 dma_desc_error:
 	return ret;
 }
@@ -7409,7 +7524,7 @@ int stmmac_resume(struct device *dev)
 	stmmac_reset_queues_param(priv);
 
 	stmmac_free_tx_skbufs(priv);
-	stmmac_clear_descriptors(priv);
+	stmmac_clear_descriptors(priv, &priv->dma_conf);
 
 	stmmac_hw_setup(ndev, false);
 	stmmac_init_coalesce(priv);
-- 
2.36.1

