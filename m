Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2FA57EFB1
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbiGWOaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbiGWOaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:30:02 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9D81A063;
        Sat, 23 Jul 2022 07:29:56 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id n12so10011880wrc.8;
        Sat, 23 Jul 2022 07:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uUKbuZfmlvDhe/kIfDNrq8YP/dD8cuc75407ZRuXpG4=;
        b=R9Nt5gr7d2cJjDh9wgbPDPnBx3dve3w/2ccz8HfQtopEhFf4S6tvEIs4vtjcYkE+pn
         ZLywqh3C/AmuuYhV78bCttlN2oYtjtvdTdt6XDs5Ix/363rDMKytCGmuImLta1o6hNG4
         /ERhe2Af3B8GMLq0VGbDQvh0bt+4l8PgB54N2vCSOWbaFM0XdfLgTjgtCTw54q94ibFQ
         B/A3g3u8qTOrKNrhoajLo3T50GM/dvmVmbcTgHRHIsuh41Kxlh3RWcbqKr6tq5XdE2mA
         np30zk8987EEnHXIN+q8GwDsQ0nWxjAQjFGcc5aXqpYGkWkehnq9ZLvncA9kxdfgBbrX
         1mdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uUKbuZfmlvDhe/kIfDNrq8YP/dD8cuc75407ZRuXpG4=;
        b=ugizA5Jf31LLLB23JB/ttlbNBDfqXoXIJ0i8Pt2tYI+l70y8q+8irObOVpWff7uUAw
         S5BJncKaIF8f6Z7NqovtTf3qnM2TrPmTENh18g94wBWN79XpzYlByu8syk5AKk7K02UO
         H4SV/Wo1+RRF82W8hFEhvdHlFTrSvJ5It1nLEifNnH0ayL7NZV4wusrJGpAiB4LeEoQS
         iihGUoGILHFxBjQauYMisr5FEmcChkzVSx36E+8+YfL1W2zTJ9CQV4KQTIoHr83ucIRB
         G16PGbqkqB3hzhhAVsPEQONqMnq3aA4X2jSjHWpYsVjxegifO9xPXeXPcCzcgmNpoHk1
         a+Wg==
X-Gm-Message-State: AJIora+xtqr37kBnYeRrGeSjSZAxpmETP1ipJLb82q1X5yjhNO5P6vsb
        86u9TTzWbhFuAJvdBviVMrQ=
X-Google-Smtp-Source: AGRyM1uguSquzYI1DOiq5G/Htu3ZUmgYldlD+imD8Won6YjMMH4UJI8mPn5lNxRhgJkRGpERu0i3Ig==
X-Received: by 2002:a5d:498f:0:b0:21e:4074:8c49 with SMTP id r15-20020a5d498f000000b0021e40748c49mr3013474wrq.70.1658586594524;
        Sat, 23 Jul 2022 07:29:54 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id q6-20020a1cf306000000b0039c5ab7167dsm11689717wmq.48.2022.07.23.07.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:29:54 -0700 (PDT)
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
Subject: [net-next PATCH v5 3/5] net: ethernet: stmicro: stmmac: move dma conf to dedicated struct
Date:   Sat, 23 Jul 2022 16:29:31 +0200
Message-Id: <20220723142933.16030-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220723142933.16030-1-ansuelsmth@gmail.com>
References: <20220723142933.16030-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move dma buf conf to dedicated struct. This in preparation for code
rework that will permit to allocate separate dma_conf without affecting
the priv struct.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/chain_mode.c  |   6 +-
 .../net/ethernet/stmicro/stmmac/ring_mode.c   |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  21 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 286 +++++++++---------
 .../stmicro/stmmac/stmmac_selftests.c         |   8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |   6 +-
 7 files changed, 172 insertions(+), 163 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
index d2cdc02d9f94..2e8744ac6b91 100644
--- a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
@@ -46,7 +46,7 @@ static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
 
 	while (len != 0) {
 		tx_q->tx_skbuff[entry] = NULL;
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 		desc = tx_q->dma_tx + entry;
 
 		if (len > bmax) {
@@ -137,7 +137,7 @@ static void refill_desc3(void *priv_ptr, struct dma_desc *p)
 		 */
 		p->des3 = cpu_to_le32((unsigned int)(rx_q->dma_rx_phy +
 				      (((rx_q->dirty_rx) + 1) %
-				       priv->dma_rx_size) *
+				       priv->dma_conf.dma_rx_size) *
 				      sizeof(struct dma_desc)));
 }
 
@@ -155,7 +155,7 @@ static void clean_desc3(void *priv_ptr, struct dma_desc *p)
 		 */
 		p->des3 = cpu_to_le32((unsigned int)((tx_q->dma_tx_phy +
 				      ((tx_q->dirty_tx + 1) %
-				       priv->dma_tx_size))
+				       priv->dma_conf.dma_tx_size))
 				      * sizeof(struct dma_desc)));
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
index 8ad900949dc8..2b5b17d8b8a0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
@@ -51,7 +51,7 @@ static int jumbo_frm(void *p, struct sk_buff *skb, int csum)
 		stmmac_prepare_tx_desc(priv, desc, 1, bmax, csum,
 				STMMAC_RING_MODE, 0, false, skb->len);
 		tx_q->tx_skbuff[entry] = NULL;
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 
 		if (priv->extend_desc)
 			desc = (struct dma_desc *)(tx_q->dma_etx + entry);
@@ -107,7 +107,7 @@ static void refill_desc3(void *priv_ptr, struct dma_desc *p)
 	struct stmmac_priv *priv = rx_q->priv_data;
 
 	/* Fill DES3 in case of RING mode */
-	if (priv->dma_buf_sz == BUF_SIZE_16KiB)
+	if (priv->dma_conf.dma_buf_sz == BUF_SIZE_16KiB)
 		p->des3 = cpu_to_le32(le32_to_cpu(p->des2) + BUF_SIZE_8KiB);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 57970ae2178d..8ef44c9d84f4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -188,6 +188,18 @@ struct stmmac_rfs_entry {
 	int tc;
 };
 
+struct stmmac_dma_conf {
+	unsigned int dma_buf_sz;
+
+	/* RX Queue */
+	struct stmmac_rx_queue rx_queue[MTL_MAX_RX_QUEUES];
+	unsigned int dma_rx_size;
+
+	/* TX Queue */
+	struct stmmac_tx_queue tx_queue[MTL_MAX_TX_QUEUES];
+	unsigned int dma_tx_size;
+};
+
 struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
 	u32 tx_coal_frames[MTL_MAX_TX_QUEUES];
@@ -201,7 +213,6 @@ struct stmmac_priv {
 	int sph_cap;
 	u32 sarc_type;
 
-	unsigned int dma_buf_sz;
 	unsigned int rx_copybreak;
 	u32 rx_riwt[MTL_MAX_TX_QUEUES];
 	int hwts_rx_en;
@@ -213,13 +224,7 @@ struct stmmac_priv {
 	int (*hwif_quirks)(struct stmmac_priv *priv);
 	struct mutex lock;
 
-	/* RX Queue */
-	struct stmmac_rx_queue rx_queue[MTL_MAX_RX_QUEUES];
-	unsigned int dma_rx_size;
-
-	/* TX Queue */
-	struct stmmac_tx_queue tx_queue[MTL_MAX_TX_QUEUES];
-	unsigned int dma_tx_size;
+	struct stmmac_dma_conf dma_conf;
 
 	/* Generic channel for NAPI */
 	struct stmmac_channel channel[STMMAC_CH_MAX];
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index abfb3cd5958d..fdf5575aedb8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -485,8 +485,8 @@ static void stmmac_get_ringparam(struct net_device *netdev,
 
 	ring->rx_max_pending = DMA_MAX_RX_SIZE;
 	ring->tx_max_pending = DMA_MAX_TX_SIZE;
-	ring->rx_pending = priv->dma_rx_size;
-	ring->tx_pending = priv->dma_tx_size;
+	ring->rx_pending = priv->dma_conf.dma_rx_size;
+	ring->tx_pending = priv->dma_conf.dma_tx_size;
 }
 
 static int stmmac_set_ringparam(struct net_device *netdev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 96e55dadcfba..4d1a445baa07 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -74,8 +74,8 @@ static int phyaddr = -1;
 module_param(phyaddr, int, 0444);
 MODULE_PARM_DESC(phyaddr, "Physical device address");
 
-#define STMMAC_TX_THRESH(x)	((x)->dma_tx_size / 4)
-#define STMMAC_RX_THRESH(x)	((x)->dma_rx_size / 4)
+#define STMMAC_TX_THRESH(x)	((x)->dma_conf.dma_tx_size / 4)
+#define STMMAC_RX_THRESH(x)	((x)->dma_conf.dma_rx_size / 4)
 
 /* Limit to make sure XDP TX and slow path can coexist */
 #define STMMAC_XSK_TX_BUDGET_MAX	256
@@ -234,7 +234,7 @@ static void stmmac_disable_all_queues(struct stmmac_priv *priv)
 
 	/* synchronize_rcu() needed for pending XDP buffers to drain */
 	for (queue = 0; queue < rx_queues_cnt; queue++) {
-		rx_q = &priv->rx_queue[queue];
+		rx_q = &priv->dma_conf.rx_queue[queue];
 		if (rx_q->xsk_pool) {
 			synchronize_rcu();
 			break;
@@ -360,13 +360,13 @@ static void print_pkt(unsigned char *buf, int len)
 
 static inline u32 stmmac_tx_avail(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	u32 avail;
 
 	if (tx_q->dirty_tx > tx_q->cur_tx)
 		avail = tx_q->dirty_tx - tx_q->cur_tx - 1;
 	else
-		avail = priv->dma_tx_size - tx_q->cur_tx + tx_q->dirty_tx - 1;
+		avail = priv->dma_conf.dma_tx_size - tx_q->cur_tx + tx_q->dirty_tx - 1;
 
 	return avail;
 }
@@ -378,13 +378,13 @@ static inline u32 stmmac_tx_avail(struct stmmac_priv *priv, u32 queue)
  */
 static inline u32 stmmac_rx_dirty(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	u32 dirty;
 
 	if (rx_q->dirty_rx <= rx_q->cur_rx)
 		dirty = rx_q->cur_rx - rx_q->dirty_rx;
 	else
-		dirty = priv->dma_rx_size - rx_q->dirty_rx + rx_q->cur_rx;
+		dirty = priv->dma_conf.dma_rx_size - rx_q->dirty_rx + rx_q->cur_rx;
 
 	return dirty;
 }
@@ -412,7 +412,7 @@ static int stmmac_enable_eee_mode(struct stmmac_priv *priv)
 
 	/* check if all TX queues have the work finished */
 	for (queue = 0; queue < tx_cnt; queue++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 		if (tx_q->dirty_tx != tx_q->cur_tx)
 			return -EBUSY; /* still unfinished work */
@@ -1241,7 +1241,7 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 
 	/* Display RX rings */
 	for (queue = 0; queue < rx_cnt; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+		struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 
 		pr_info("\tRX Queue %u rings\n", queue);
 
@@ -1254,7 +1254,7 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 		}
 
 		/* Display RX ring */
-		stmmac_display_ring(priv, head_rx, priv->dma_rx_size, true,
+		stmmac_display_ring(priv, head_rx, priv->dma_conf.dma_rx_size, true,
 				    rx_q->dma_rx_phy, desc_size);
 	}
 }
@@ -1268,7 +1268,7 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 
 	/* Display TX rings */
 	for (queue = 0; queue < tx_cnt; queue++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 		pr_info("\tTX Queue %d rings\n", queue);
 
@@ -1283,7 +1283,7 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 			desc_size = sizeof(struct dma_desc);
 		}
 
-		stmmac_display_ring(priv, head_tx, priv->dma_tx_size, false,
+		stmmac_display_ring(priv, head_tx, priv->dma_conf.dma_tx_size, false,
 				    tx_q->dma_tx_phy, desc_size);
 	}
 }
@@ -1324,21 +1324,21 @@ static int stmmac_set_bfsize(int mtu, int bufsize)
  */
 static void stmmac_clear_rx_descriptors(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	int i;
 
 	/* Clear the RX descriptors */
-	for (i = 0; i < priv->dma_rx_size; i++)
+	for (i = 0; i < priv->dma_conf.dma_rx_size; i++)
 		if (priv->extend_desc)
 			stmmac_init_rx_desc(priv, &rx_q->dma_erx[i].basic,
 					priv->use_riwt, priv->mode,
-					(i == priv->dma_rx_size - 1),
-					priv->dma_buf_sz);
+					(i == priv->dma_conf.dma_rx_size - 1),
+					priv->dma_conf.dma_buf_sz);
 		else
 			stmmac_init_rx_desc(priv, &rx_q->dma_rx[i],
 					priv->use_riwt, priv->mode,
-					(i == priv->dma_rx_size - 1),
-					priv->dma_buf_sz);
+					(i == priv->dma_conf.dma_rx_size - 1),
+					priv->dma_conf.dma_buf_sz);
 }
 
 /**
@@ -1350,12 +1350,12 @@ static void stmmac_clear_rx_descriptors(struct stmmac_priv *priv, u32 queue)
  */
 static void stmmac_clear_tx_descriptors(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	int i;
 
 	/* Clear the TX descriptors */
-	for (i = 0; i < priv->dma_tx_size; i++) {
-		int last = (i == (priv->dma_tx_size - 1));
+	for (i = 0; i < priv->dma_conf.dma_tx_size; i++) {
+		int last = (i == (priv->dma_conf.dma_tx_size - 1));
 		struct dma_desc *p;
 
 		if (priv->extend_desc)
@@ -1403,7 +1403,7 @@ static void stmmac_clear_descriptors(struct stmmac_priv *priv)
 static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 				  int i, gfp_t flags, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
@@ -1432,7 +1432,7 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 	buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;
 
 	stmmac_set_desc_addr(priv, p, buf->addr);
-	if (priv->dma_buf_sz == BUF_SIZE_16KiB)
+	if (priv->dma_conf.dma_buf_sz == BUF_SIZE_16KiB)
 		stmmac_init_desc3(priv, p);
 
 	return 0;
@@ -1446,7 +1446,7 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
  */
 static void stmmac_free_rx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 
 	if (buf->page)
@@ -1466,7 +1466,7 @@ static void stmmac_free_rx_buffer(struct stmmac_priv *priv, u32 queue, int i)
  */
 static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 	if (tx_q->tx_skbuff_dma[i].buf &&
 	    tx_q->tx_skbuff_dma[i].buf_type != STMMAC_TXBUF_T_XDP_TX) {
@@ -1511,17 +1511,17 @@ static void dma_free_rx_skbufs(struct stmmac_priv *priv, u32 queue)
 {
 	int i;
 
-	for (i = 0; i < priv->dma_rx_size; i++)
+	for (i = 0; i < priv->dma_conf.dma_rx_size; i++)
 		stmmac_free_rx_buffer(priv, queue, i);
 }
 
 static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
 				   gfp_t flags)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	int i;
 
-	for (i = 0; i < priv->dma_rx_size; i++) {
+	for (i = 0; i < priv->dma_conf.dma_rx_size; i++) {
 		struct dma_desc *p;
 		int ret;
 
@@ -1548,10 +1548,10 @@ static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
  */
 static void dma_free_rx_xskbufs(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	int i;
 
-	for (i = 0; i < priv->dma_rx_size; i++) {
+	for (i = 0; i < priv->dma_conf.dma_rx_size; i++) {
 		struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 
 		if (!buf->xdp)
@@ -1564,10 +1564,10 @@ static void dma_free_rx_xskbufs(struct stmmac_priv *priv, u32 queue)
 
 static int stmmac_alloc_rx_buffers_zc(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	int i;
 
-	for (i = 0; i < priv->dma_rx_size; i++) {
+	for (i = 0; i < priv->dma_conf.dma_rx_size; i++) {
 		struct stmmac_rx_buffer *buf;
 		dma_addr_t dma_addr;
 		struct dma_desc *p;
@@ -1610,7 +1610,7 @@ static struct xsk_buff_pool *stmmac_get_xsk_pool(struct stmmac_priv *priv, u32 q
  */
 static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t flags)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	int ret;
 
 	netif_dbg(priv, probe, priv->dev,
@@ -1656,11 +1656,11 @@ static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t f
 		if (priv->extend_desc)
 			stmmac_mode_init(priv, rx_q->dma_erx,
 					 rx_q->dma_rx_phy,
-					 priv->dma_rx_size, 1);
+					 priv->dma_conf.dma_rx_size, 1);
 		else
 			stmmac_mode_init(priv, rx_q->dma_rx,
 					 rx_q->dma_rx_phy,
-					 priv->dma_rx_size, 0);
+					 priv->dma_conf.dma_rx_size, 0);
 	}
 
 	return 0;
@@ -1687,7 +1687,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 
 err_init_rx_buffers:
 	while (queue >= 0) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+		struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 
 		if (rx_q->xsk_pool)
 			dma_free_rx_xskbufs(priv, queue);
@@ -1713,7 +1713,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
  */
 static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	int i;
 
 	netif_dbg(priv, probe, priv->dev,
@@ -1725,16 +1725,16 @@ static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
 		if (priv->extend_desc)
 			stmmac_mode_init(priv, tx_q->dma_etx,
 					 tx_q->dma_tx_phy,
-					 priv->dma_tx_size, 1);
+					 priv->dma_conf.dma_tx_size, 1);
 		else if (!(tx_q->tbs & STMMAC_TBS_AVAIL))
 			stmmac_mode_init(priv, tx_q->dma_tx,
 					 tx_q->dma_tx_phy,
-					 priv->dma_tx_size, 0);
+					 priv->dma_conf.dma_tx_size, 0);
 	}
 
 	tx_q->xsk_pool = stmmac_get_xsk_pool(priv, queue);
 
-	for (i = 0; i < priv->dma_tx_size; i++) {
+	for (i = 0; i < priv->dma_conf.dma_tx_size; i++) {
 		struct dma_desc *p;
 
 		if (priv->extend_desc)
@@ -1804,12 +1804,12 @@ static int init_dma_desc_rings(struct net_device *dev, gfp_t flags)
  */
 static void dma_free_tx_skbufs(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	int i;
 
 	tx_q->xsk_frames_done = 0;
 
-	for (i = 0; i < priv->dma_tx_size; i++)
+	for (i = 0; i < priv->dma_conf.dma_tx_size; i++)
 		stmmac_free_tx_buffer(priv, queue, i);
 
 	if (tx_q->xsk_pool && tx_q->xsk_frames_done) {
@@ -1839,7 +1839,7 @@ static void stmmac_free_tx_skbufs(struct stmmac_priv *priv)
  */
 static void __free_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 
 	/* Release the DMA RX socket buffers */
 	if (rx_q->xsk_pool)
@@ -1852,11 +1852,11 @@ static void __free_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 
 	/* Free DMA regions of consistent memory previously allocated */
 	if (!priv->extend_desc)
-		dma_free_coherent(priv->device, priv->dma_rx_size *
+		dma_free_coherent(priv->device, priv->dma_conf.dma_rx_size *
 				  sizeof(struct dma_desc),
 				  rx_q->dma_rx, rx_q->dma_rx_phy);
 	else
-		dma_free_coherent(priv->device, priv->dma_rx_size *
+		dma_free_coherent(priv->device, priv->dma_conf.dma_rx_size *
 				  sizeof(struct dma_extended_desc),
 				  rx_q->dma_erx, rx_q->dma_rx_phy);
 
@@ -1885,7 +1885,7 @@ static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
  */
 static void __free_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	size_t size;
 	void *addr;
 
@@ -1903,7 +1903,7 @@ static void __free_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 		addr = tx_q->dma_tx;
 	}
 
-	size *= priv->dma_tx_size;
+	size *= priv->dma_conf.dma_tx_size;
 
 	dma_free_coherent(priv->device, size, addr, tx_q->dma_tx_phy);
 
@@ -1932,7 +1932,7 @@ static void free_dma_tx_desc_resources(struct stmmac_priv *priv)
  */
 static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	bool xdp_prog = stmmac_xdp_is_enabled(priv);
 	struct page_pool_params pp_params = { 0 };
@@ -1944,8 +1944,8 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	rx_q->priv_data = priv;
 
 	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
-	pp_params.pool_size = priv->dma_rx_size;
-	num_pages = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+	pp_params.pool_size = priv->dma_conf.dma_rx_size;
+	num_pages = DIV_ROUND_UP(priv->dma_conf.dma_buf_sz, PAGE_SIZE);
 	pp_params.order = ilog2(num_pages);
 	pp_params.nid = dev_to_node(priv->device);
 	pp_params.dev = priv->device;
@@ -1960,7 +1960,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 		return ret;
 	}
 
-	rx_q->buf_pool = kcalloc(priv->dma_rx_size,
+	rx_q->buf_pool = kcalloc(priv->dma_conf.dma_rx_size,
 				 sizeof(*rx_q->buf_pool),
 				 GFP_KERNEL);
 	if (!rx_q->buf_pool)
@@ -1968,7 +1968,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 
 	if (priv->extend_desc) {
 		rx_q->dma_erx = dma_alloc_coherent(priv->device,
-						   priv->dma_rx_size *
+						   priv->dma_conf.dma_rx_size *
 						   sizeof(struct dma_extended_desc),
 						   &rx_q->dma_rx_phy,
 						   GFP_KERNEL);
@@ -1977,7 +1977,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 
 	} else {
 		rx_q->dma_rx = dma_alloc_coherent(priv->device,
-						  priv->dma_rx_size *
+						  priv->dma_conf.dma_rx_size *
 						  sizeof(struct dma_desc),
 						  &rx_q->dma_rx_phy,
 						  GFP_KERNEL);
@@ -2034,20 +2034,20 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
  */
 static int __alloc_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	size_t size;
 	void *addr;
 
 	tx_q->queue_index = queue;
 	tx_q->priv_data = priv;
 
-	tx_q->tx_skbuff_dma = kcalloc(priv->dma_tx_size,
+	tx_q->tx_skbuff_dma = kcalloc(priv->dma_conf.dma_tx_size,
 				      sizeof(*tx_q->tx_skbuff_dma),
 				      GFP_KERNEL);
 	if (!tx_q->tx_skbuff_dma)
 		return -ENOMEM;
 
-	tx_q->tx_skbuff = kcalloc(priv->dma_tx_size,
+	tx_q->tx_skbuff = kcalloc(priv->dma_conf.dma_tx_size,
 				  sizeof(struct sk_buff *),
 				  GFP_KERNEL);
 	if (!tx_q->tx_skbuff)
@@ -2060,7 +2060,7 @@ static int __alloc_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	else
 		size = sizeof(struct dma_desc);
 
-	size *= priv->dma_tx_size;
+	size *= priv->dma_conf.dma_tx_size;
 
 	addr = dma_alloc_coherent(priv->device, size,
 				  &tx_q->dma_tx_phy, GFP_KERNEL);
@@ -2304,7 +2304,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 
 	/* configure all channels */
 	for (chan = 0; chan < rx_channels_count; chan++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[chan];
+		struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[chan];
 		u32 buf_size;
 
 		qmode = priv->plat->rx_queues_cfg[chan].mode_to_use;
@@ -2319,7 +2319,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 					      chan);
 		} else {
 			stmmac_set_dma_bfsize(priv, priv->ioaddr,
-					      priv->dma_buf_sz,
+					      priv->dma_conf.dma_buf_sz,
 					      chan);
 		}
 	}
@@ -2335,7 +2335,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 {
 	struct netdev_queue *nq = netdev_get_tx_queue(priv->dev, queue);
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct xsk_buff_pool *pool = tx_q->xsk_pool;
 	unsigned int entry = tx_q->cur_tx;
 	struct dma_desc *tx_desc = NULL;
@@ -2410,7 +2410,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 		stmmac_enable_dma_transmission(priv, priv->ioaddr);
 
-		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_tx_size);
+		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_conf.dma_tx_size);
 		entry = tx_q->cur_tx;
 	}
 
@@ -2451,7 +2451,7 @@ static void stmmac_bump_dma_threshold(struct stmmac_priv *priv, u32 chan)
  */
 static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	unsigned int bytes_compl = 0, pkts_compl = 0;
 	unsigned int entry, xmits = 0, count = 0;
 
@@ -2464,7 +2464,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 	entry = tx_q->dirty_tx;
 
 	/* Try to clean all TX complete frame in 1 shot */
-	while ((entry != tx_q->cur_tx) && count < priv->dma_tx_size) {
+	while ((entry != tx_q->cur_tx) && count < priv->dma_conf.dma_tx_size) {
 		struct xdp_frame *xdpf;
 		struct sk_buff *skb;
 		struct dma_desc *p;
@@ -2566,7 +2566,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 		stmmac_release_tx_desc(priv, p, priv->mode);
 
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 	}
 	tx_q->dirty_tx = entry;
 
@@ -2631,7 +2631,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
  */
 static void stmmac_tx_err(struct stmmac_priv *priv, u32 chan)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 
 	netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, chan));
 
@@ -2698,8 +2698,8 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan, u32 dir)
 {
 	int status = stmmac_dma_interrupt_status(priv, priv->ioaddr,
 						 &priv->xstats, chan, dir);
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[chan];
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[chan];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 	struct stmmac_channel *ch = &priv->channel[chan];
 	struct napi_struct *rx_napi;
 	struct napi_struct *tx_napi;
@@ -2865,7 +2865,7 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
-		rx_q = &priv->rx_queue[chan];
+		rx_q = &priv->dma_conf.rx_queue[chan];
 
 		stmmac_init_rx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 				    rx_q->dma_rx_phy, chan);
@@ -2879,7 +2879,7 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 
 	/* DMA TX Channel Configuration */
 	for (chan = 0; chan < tx_channels_count; chan++) {
-		tx_q = &priv->tx_queue[chan];
+		tx_q = &priv->dma_conf.tx_queue[chan];
 
 		stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 				    tx_q->dma_tx_phy, chan);
@@ -2894,7 +2894,7 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 
 static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 	hrtimer_start(&tx_q->txtimer,
 		      STMMAC_COAL_TIMER(priv->tx_coal_timer[queue]),
@@ -2944,7 +2944,7 @@ static void stmmac_init_coalesce(struct stmmac_priv *priv)
 	u32 chan;
 
 	for (chan = 0; chan < tx_channel_count; chan++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 
 		priv->tx_coal_frames[chan] = STMMAC_TX_FRAMES;
 		priv->tx_coal_timer[chan] = STMMAC_COAL_TX_TIMER;
@@ -2966,12 +2966,12 @@ static void stmmac_set_rings_length(struct stmmac_priv *priv)
 	/* set TX ring length */
 	for (chan = 0; chan < tx_channels_count; chan++)
 		stmmac_set_tx_ring_len(priv, priv->ioaddr,
-				       (priv->dma_tx_size - 1), chan);
+				       (priv->dma_conf.dma_tx_size - 1), chan);
 
 	/* set RX ring length */
 	for (chan = 0; chan < rx_channels_count; chan++)
 		stmmac_set_rx_ring_len(priv, priv->ioaddr,
-				       (priv->dma_rx_size - 1), chan);
+				       (priv->dma_conf.dma_rx_size - 1), chan);
 }
 
 /**
@@ -3298,7 +3298,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 	/* Enable TSO */
 	if (priv->tso) {
 		for (chan = 0; chan < tx_cnt; chan++) {
-			struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+			struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 
 			/* TSO and TBS cannot co-exist */
 			if (tx_q->tbs & STMMAC_TBS_AVAIL)
@@ -3320,7 +3320,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 
 	/* TBS */
 	for (chan = 0; chan < tx_cnt; chan++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 		int enable = tx_q->tbs & STMMAC_TBS_AVAIL;
 
 		stmmac_enable_tbs(priv, priv->ioaddr, enable, chan);
@@ -3364,7 +3364,7 @@ static void stmmac_free_irq(struct net_device *dev,
 		for (j = irq_idx - 1; j >= 0; j--) {
 			if (priv->tx_irq[j] > 0) {
 				irq_set_affinity_hint(priv->tx_irq[j], NULL);
-				free_irq(priv->tx_irq[j], &priv->tx_queue[j]);
+				free_irq(priv->tx_irq[j], &priv->dma_conf.tx_queue[j]);
 			}
 		}
 		irq_idx = priv->plat->rx_queues_to_use;
@@ -3373,7 +3373,7 @@ static void stmmac_free_irq(struct net_device *dev,
 		for (j = irq_idx - 1; j >= 0; j--) {
 			if (priv->rx_irq[j] > 0) {
 				irq_set_affinity_hint(priv->rx_irq[j], NULL);
-				free_irq(priv->rx_irq[j], &priv->rx_queue[j]);
+				free_irq(priv->rx_irq[j], &priv->dma_conf.rx_queue[j]);
 			}
 		}
 
@@ -3508,7 +3508,7 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 		sprintf(int_name, "%s:%s-%d", dev->name, "rx", i);
 		ret = request_irq(priv->rx_irq[i],
 				  stmmac_msi_intr_rx,
-				  0, int_name, &priv->rx_queue[i]);
+				  0, int_name, &priv->dma_conf.rx_queue[i]);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: alloc rx-%d  MSI %d (error: %d)\n",
@@ -3533,7 +3533,7 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 		sprintf(int_name, "%s:%s-%d", dev->name, "tx", i);
 		ret = request_irq(priv->tx_irq[i],
 				  stmmac_msi_intr_tx,
-				  0, int_name, &priv->tx_queue[i]);
+				  0, int_name, &priv->dma_conf.tx_queue[i]);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: alloc tx-%d  MSI %d (error: %d)\n",
@@ -3662,21 +3662,21 @@ static int stmmac_open(struct net_device *dev)
 		bfsize = 0;
 
 	if (bfsize < BUF_SIZE_16KiB)
-		bfsize = stmmac_set_bfsize(dev->mtu, priv->dma_buf_sz);
+		bfsize = stmmac_set_bfsize(dev->mtu, priv->dma_conf.dma_buf_sz);
 
-	priv->dma_buf_sz = bfsize;
+	priv->dma_conf.dma_buf_sz = bfsize;
 	buf_sz = bfsize;
 
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
-	if (!priv->dma_tx_size)
-		priv->dma_tx_size = DMA_DEFAULT_TX_SIZE;
-	if (!priv->dma_rx_size)
-		priv->dma_rx_size = DMA_DEFAULT_RX_SIZE;
+	if (!priv->dma_conf.dma_tx_size)
+		priv->dma_conf.dma_tx_size = DMA_DEFAULT_TX_SIZE;
+	if (!priv->dma_conf.dma_rx_size)
+		priv->dma_conf.dma_rx_size = DMA_DEFAULT_RX_SIZE;
 
 	/* Earlier check for TBS */
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 		int tbs_en = priv->plat->tx_queues_cfg[chan].tbs_en;
 
 		/* Setup per-TXQ tbs flag before TX descriptor alloc */
@@ -3725,7 +3725,7 @@ static int stmmac_open(struct net_device *dev)
 	phylink_stop(priv->phylink);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	stmmac_hw_teardown(dev);
 init_error:
@@ -3767,7 +3767,7 @@ static int stmmac_release(struct net_device *dev)
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	netif_tx_disable(dev);
 
@@ -3827,7 +3827,7 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
 		return false;
 
 	stmmac_set_tx_owner(priv, p);
-	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_tx_size);
+	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_conf.dma_tx_size);
 	return true;
 }
 
@@ -3845,7 +3845,7 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
 static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
 				 int total_len, bool last_segment, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct dma_desc *desc;
 	u32 buff_size;
 	int tmp_len;
@@ -3856,7 +3856,7 @@ static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
 		dma_addr_t curr_addr;
 
 		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx,
-						priv->dma_tx_size);
+						priv->dma_conf.dma_tx_size);
 		WARN_ON(tx_q->tx_skbuff[tx_q->cur_tx]);
 
 		if (tx_q->tbs & STMMAC_TBS_AVAIL)
@@ -3884,7 +3884,7 @@ static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
 
 static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	int desc_size;
 
 	if (likely(priv->extend_desc))
@@ -3946,7 +3946,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	dma_addr_t des;
 	int i;
 
-	tx_q = &priv->tx_queue[queue];
+	tx_q = &priv->dma_conf.tx_queue[queue];
 	first_tx = tx_q->cur_tx;
 
 	/* Compute header lengths */
@@ -3986,7 +3986,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		stmmac_set_mss(priv, mss_desc, mss);
 		tx_q->mss = mss;
 		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx,
-						priv->dma_tx_size);
+						priv->dma_conf.dma_tx_size);
 		WARN_ON(tx_q->tx_skbuff[tx_q->cur_tx]);
 	}
 
@@ -4098,7 +4098,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * ndo_start_xmit will fill this descriptor the next time it's
 	 * called and stmmac_tx_clean may clean up to this descriptor.
 	 */
-	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_tx_size);
+	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_conf.dma_tx_size);
 
 	if (unlikely(stmmac_tx_avail(priv, queue) <= (MAX_SKB_FRAGS + 1))) {
 		netif_dbg(priv, hw, priv->dev, "%s: stop transmitted packets\n",
@@ -4186,7 +4186,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	int entry, first_tx;
 	dma_addr_t des;
 
-	tx_q = &priv->tx_queue[queue];
+	tx_q = &priv->dma_conf.tx_queue[queue];
 	first_tx = tx_q->cur_tx;
 
 	if (priv->tx_path_in_lpi_mode && priv->eee_sw_timer_en)
@@ -4249,7 +4249,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		int len = skb_frag_size(frag);
 		bool last_segment = (i == (nfrags - 1));
 
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 		WARN_ON(tx_q->tx_skbuff[entry]);
 
 		if (likely(priv->extend_desc))
@@ -4320,7 +4320,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * ndo_start_xmit will fill this descriptor the next time it's
 	 * called and stmmac_tx_clean may clean up to this descriptor.
 	 */
-	entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+	entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 	tx_q->cur_tx = entry;
 
 	if (netif_msg_pktdata(priv)) {
@@ -4435,7 +4435,7 @@ static void stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
  */
 static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	int dirty = stmmac_rx_dirty(priv, queue);
 	unsigned int entry = rx_q->dirty_rx;
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
@@ -4489,7 +4489,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		dma_wmb();
 		stmmac_set_rx_owner(priv, p, use_rx_wd);
 
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_rx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_rx_size);
 	}
 	rx_q->dirty_rx = entry;
 	rx_q->rx_tail_addr = rx_q->dma_rx_phy +
@@ -4517,12 +4517,12 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 
 	/* First descriptor, not last descriptor and not split header */
 	if (status & rx_not_ls)
-		return priv->dma_buf_sz;
+		return priv->dma_conf.dma_buf_sz;
 
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
 	/* First descriptor and last descriptor and not split header */
-	return min_t(unsigned int, priv->dma_buf_sz, plen);
+	return min_t(unsigned int, priv->dma_conf.dma_buf_sz, plen);
 }
 
 static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
@@ -4538,7 +4538,7 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 
 	/* Not last descriptor */
 	if (status & rx_not_ls)
-		return priv->dma_buf_sz;
+		return priv->dma_conf.dma_buf_sz;
 
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
@@ -4549,7 +4549,7 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 				struct xdp_frame *xdpf, bool dma_map)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	unsigned int entry = tx_q->cur_tx;
 	struct dma_desc *tx_desc;
 	dma_addr_t dma_addr;
@@ -4612,7 +4612,7 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 
 	stmmac_enable_dma_transmission(priv, priv->ioaddr);
 
-	entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+	entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 	tx_q->cur_tx = entry;
 
 	return STMMAC_XDP_TX;
@@ -4786,7 +4786,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 
 static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	unsigned int entry = rx_q->dirty_rx;
 	struct dma_desc *rx_desc = NULL;
 	bool ret = true;
@@ -4829,7 +4829,7 @@ static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		dma_wmb();
 		stmmac_set_rx_owner(priv, rx_desc, use_rx_wd);
 
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_rx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_rx_size);
 	}
 
 	if (rx_desc) {
@@ -4844,7 +4844,7 @@ static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	unsigned int count = 0, error = 0, len = 0;
 	int dirty = stmmac_rx_dirty(priv, queue);
 	unsigned int next_entry = rx_q->cur_rx;
@@ -4866,7 +4866,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			desc_size = sizeof(struct dma_desc);
 		}
 
-		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true,
+		stmmac_display_ring(priv, rx_head, priv->dma_conf.dma_rx_size, true,
 				    rx_q->dma_rx_phy, desc_size);
 	}
 	while (count < limit) {
@@ -4913,7 +4913,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 
 		/* Prefetch the next RX descriptor */
 		rx_q->cur_rx = STMMAC_GET_ENTRY(rx_q->cur_rx,
-						priv->dma_rx_size);
+						priv->dma_conf.dma_rx_size);
 		next_entry = rx_q->cur_rx;
 
 		if (priv->extend_desc)
@@ -5034,7 +5034,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
  */
 static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned int count = 0, error = 0, len = 0;
 	int status = 0, coe = priv->hw->rx_csum;
@@ -5047,7 +5047,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	int buf_sz;
 
 	dma_dir = page_pool_get_dma_dir(rx_q->page_pool);
-	buf_sz = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
+	buf_sz = DIV_ROUND_UP(priv->dma_conf.dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
@@ -5061,7 +5061,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			desc_size = sizeof(struct dma_desc);
 		}
 
-		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true,
+		stmmac_display_ring(priv, rx_head, priv->dma_conf.dma_rx_size, true,
 				    rx_q->dma_rx_phy, desc_size);
 	}
 	while (count < limit) {
@@ -5105,7 +5105,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			break;
 
 		rx_q->cur_rx = STMMAC_GET_ENTRY(rx_q->cur_rx,
-						priv->dma_rx_size);
+						priv->dma_conf.dma_rx_size);
 		next_entry = rx_q->cur_rx;
 
 		if (priv->extend_desc)
@@ -5240,7 +5240,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 						buf1_len, dma_dir);
 			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 					buf->page, buf->page_offset, buf1_len,
-					priv->dma_buf_sz);
+					priv->dma_conf.dma_buf_sz);
 
 			/* Data payload appended into SKB */
 			page_pool_release_page(rx_q->page_pool, buf->page);
@@ -5252,7 +5252,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 						buf2_len, dma_dir);
 			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 					buf->sec_page, 0, buf2_len,
-					priv->dma_buf_sz);
+					priv->dma_conf.dma_buf_sz);
 
 			/* Data payload appended into SKB */
 			page_pool_release_page(rx_q->page_pool, buf->sec_page);
@@ -5694,11 +5694,13 @@ static irqreturn_t stmmac_safety_interrupt(int irq, void *dev_id)
 static irqreturn_t stmmac_msi_intr_tx(int irq, void *data)
 {
 	struct stmmac_tx_queue *tx_q = (struct stmmac_tx_queue *)data;
+	struct stmmac_dma_conf *dma_conf;
 	int chan = tx_q->queue_index;
 	struct stmmac_priv *priv;
 	int status;
 
-	priv = container_of(tx_q, struct stmmac_priv, tx_queue[chan]);
+	dma_conf = container_of(tx_q, struct stmmac_dma_conf, tx_queue[chan]);
+	priv = container_of(dma_conf, struct stmmac_priv, dma_conf);
 
 	if (unlikely(!data)) {
 		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
@@ -5724,10 +5726,12 @@ static irqreturn_t stmmac_msi_intr_tx(int irq, void *data)
 static irqreturn_t stmmac_msi_intr_rx(int irq, void *data)
 {
 	struct stmmac_rx_queue *rx_q = (struct stmmac_rx_queue *)data;
+	struct stmmac_dma_conf *dma_conf;
 	int chan = rx_q->queue_index;
 	struct stmmac_priv *priv;
 
-	priv = container_of(rx_q, struct stmmac_priv, rx_queue[chan]);
+	dma_conf = container_of(rx_q, struct stmmac_dma_conf, rx_queue[chan]);
+	priv = container_of(dma_conf, struct stmmac_priv, dma_conf);
 
 	if (unlikely(!data)) {
 		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
@@ -5758,10 +5762,10 @@ static void stmmac_poll_controller(struct net_device *dev)
 
 	if (priv->plat->multi_msi_en) {
 		for (i = 0; i < priv->plat->rx_queues_to_use; i++)
-			stmmac_msi_intr_rx(0, &priv->rx_queue[i]);
+			stmmac_msi_intr_rx(0, &priv->dma_conf.rx_queue[i]);
 
 		for (i = 0; i < priv->plat->tx_queues_to_use; i++)
-			stmmac_msi_intr_tx(0, &priv->tx_queue[i]);
+			stmmac_msi_intr_tx(0, &priv->dma_conf.tx_queue[i]);
 	} else {
 		disable_irq(dev->irq);
 		stmmac_interrupt(dev->irq, dev);
@@ -5940,34 +5944,34 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
 		return 0;
 
 	for (queue = 0; queue < rx_count; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+		struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 
 		seq_printf(seq, "RX Queue %d:\n", queue);
 
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_erx,
-					   priv->dma_rx_size, 1, seq, rx_q->dma_rx_phy);
+					   priv->dma_conf.dma_rx_size, 1, seq, rx_q->dma_rx_phy);
 		} else {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_rx,
-					   priv->dma_rx_size, 0, seq, rx_q->dma_rx_phy);
+					   priv->dma_conf.dma_rx_size, 0, seq, rx_q->dma_rx_phy);
 		}
 	}
 
 	for (queue = 0; queue < tx_count; queue++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 		seq_printf(seq, "TX Queue %d:\n", queue);
 
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_etx,
-					   priv->dma_tx_size, 1, seq, tx_q->dma_tx_phy);
+					   priv->dma_conf.dma_tx_size, 1, seq, tx_q->dma_tx_phy);
 		} else if (!(tx_q->tbs & STMMAC_TBS_AVAIL)) {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_tx,
-					   priv->dma_tx_size, 0, seq, tx_q->dma_tx_phy);
+					   priv->dma_conf.dma_tx_size, 0, seq, tx_q->dma_tx_phy);
 		}
 	}
 
@@ -6306,7 +6310,7 @@ void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue)
 
 void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned long flags;
 	u32 buf_size;
@@ -6343,7 +6347,7 @@ void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue)
 				      rx_q->queue_index);
 	} else {
 		stmmac_set_dma_bfsize(priv, priv->ioaddr,
-				      priv->dma_buf_sz,
+				      priv->dma_conf.dma_buf_sz,
 				      rx_q->queue_index);
 	}
 
@@ -6369,7 +6373,7 @@ void stmmac_disable_tx_queue(struct stmmac_priv *priv, u32 queue)
 
 void stmmac_enable_tx_queue(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned long flags;
 	int ret;
@@ -6416,7 +6420,7 @@ void stmmac_xdp_release(struct net_device *dev)
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	/* Free the IRQ lines */
 	stmmac_free_irq(dev, REQ_IRQ_ERR_ALL, 0);
@@ -6475,7 +6479,7 @@ int stmmac_xdp_open(struct net_device *dev)
 
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_cnt; chan++) {
-		rx_q = &priv->rx_queue[chan];
+		rx_q = &priv->dma_conf.rx_queue[chan];
 
 		stmmac_init_rx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 				    rx_q->dma_rx_phy, chan);
@@ -6493,7 +6497,7 @@ int stmmac_xdp_open(struct net_device *dev)
 					      rx_q->queue_index);
 		} else {
 			stmmac_set_dma_bfsize(priv, priv->ioaddr,
-					      priv->dma_buf_sz,
+					      priv->dma_conf.dma_buf_sz,
 					      rx_q->queue_index);
 		}
 
@@ -6502,7 +6506,7 @@ int stmmac_xdp_open(struct net_device *dev)
 
 	/* DMA TX Channel Configuration */
 	for (chan = 0; chan < tx_cnt; chan++) {
-		tx_q = &priv->tx_queue[chan];
+		tx_q = &priv->dma_conf.tx_queue[chan];
 
 		stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 				    tx_q->dma_tx_phy, chan);
@@ -6535,7 +6539,7 @@ int stmmac_xdp_open(struct net_device *dev)
 
 irq_error:
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	stmmac_hw_teardown(dev);
 init_error:
@@ -6562,8 +6566,8 @@ int stmmac_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags)
 	    queue >= priv->plat->tx_queues_to_use)
 		return -EINVAL;
 
-	rx_q = &priv->rx_queue[queue];
-	tx_q = &priv->tx_queue[queue];
+	rx_q = &priv->dma_conf.rx_queue[queue];
+	tx_q = &priv->dma_conf.tx_queue[queue];
 	ch = &priv->channel[queue];
 
 	if (!rx_q->xsk_pool && !tx_q->xsk_pool)
@@ -6818,8 +6822,8 @@ int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size)
 	if (netif_running(dev))
 		stmmac_release(dev);
 
-	priv->dma_rx_size = rx_size;
-	priv->dma_tx_size = tx_size;
+	priv->dma_conf.dma_rx_size = rx_size;
+	priv->dma_conf.dma_tx_size = tx_size;
 
 	if (netif_running(dev))
 		ret = stmmac_open(dev);
@@ -7265,7 +7269,7 @@ int stmmac_suspend(struct device *dev)
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	if (priv->eee_enabled) {
 		priv->tx_path_in_lpi_mode = false;
@@ -7316,7 +7320,7 @@ EXPORT_SYMBOL_GPL(stmmac_suspend);
 
 static void stmmac_reset_rx_queue(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 
 	rx_q->cur_rx = 0;
 	rx_q->dirty_rx = 0;
@@ -7324,7 +7328,7 @@ static void stmmac_reset_rx_queue(struct stmmac_priv *priv, u32 queue)
 
 static void stmmac_reset_tx_queue(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 	tx_q->cur_tx = 0;
 	tx_q->dirty_tx = 0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 2fc51dc5eb0b..49af7e78b7f5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -795,8 +795,8 @@ static int stmmac_test_flowctrl(struct stmmac_priv *priv)
 		struct stmmac_channel *ch = &priv->channel[i];
 		u32 tail;
 
-		tail = priv->rx_queue[i].dma_rx_phy +
-			(priv->dma_rx_size * sizeof(struct dma_desc));
+		tail = priv->dma_conf.rx_queue[i].dma_rx_phy +
+			(priv->dma_conf.dma_rx_size * sizeof(struct dma_desc));
 
 		stmmac_set_rx_tail_ptr(priv, priv->ioaddr, tail, i);
 		stmmac_start_rx(priv, priv->ioaddr, i);
@@ -1680,7 +1680,7 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
 static int __stmmac_test_jumbo(struct stmmac_priv *priv, u16 queue)
 {
 	struct stmmac_packet_attrs attr = { };
-	int size = priv->dma_buf_sz;
+	int size = priv->dma_conf.dma_buf_sz;
 
 	attr.dst = priv->dev->dev_addr;
 	attr.max_size = size - ETH_FCS_LEN;
@@ -1763,7 +1763,7 @@ static int stmmac_test_tbs(struct stmmac_priv *priv)
 
 	/* Find first TBS enabled Queue, if any */
 	for (i = 0; i < priv->plat->tx_queues_to_use; i++)
-		if (priv->tx_queue[i].tbs & STMMAC_TBS_AVAIL)
+		if (priv->dma_conf.tx_queue[i].tbs & STMMAC_TBS_AVAIL)
 			break;
 
 	if (i >= priv->plat->tx_queues_to_use)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index d61766eeac6d..773e415cc2de 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1091,13 +1091,13 @@ static int tc_setup_etf(struct stmmac_priv *priv,
 		return -EOPNOTSUPP;
 	if (qopt->queue >= priv->plat->tx_queues_to_use)
 		return -EINVAL;
-	if (!(priv->tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
+	if (!(priv->dma_conf.tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
 		return -EINVAL;
 
 	if (qopt->enable)
-		priv->tx_queue[qopt->queue].tbs |= STMMAC_TBS_EN;
+		priv->dma_conf.tx_queue[qopt->queue].tbs |= STMMAC_TBS_EN;
 	else
-		priv->tx_queue[qopt->queue].tbs &= ~STMMAC_TBS_EN;
+		priv->dma_conf.tx_queue[qopt->queue].tbs &= ~STMMAC_TBS_EN;
 
 	netdev_info(priv->dev, "%s ETF for Queue %d\n",
 		    qopt->enable ? "enabled" : "disabled", qopt->queue);
-- 
2.36.1

