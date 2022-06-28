Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCC055D108
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243090AbiF1BeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243083AbiF1BeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:34:13 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70D719284;
        Mon, 27 Jun 2022 18:34:10 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id q6so22574621eji.13;
        Mon, 27 Jun 2022 18:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aJdwa/UjHEpdFkwXFI55W6Oik+ASbLBiAgY0tsSI47A=;
        b=B14k9TY87faD+kQiZm5zKeyGeopG2HdKbUq4OFGPRE8GXuwcshIKN75+KyfpKoQGWD
         HLhgDzVsjNCz31Ei3ekyFv6/7wv61hXFN26REmXK0t7/IuO0psKf18sCNM4VFHk5KnSh
         FhEYGXnC50CTm7WGGBYB+FjwvDZ6dsvnK8xYX/C0xp7XSEHN7cHSLUq4R/m4BJsYgihT
         9Yh82AYO72vlj6+NO/zVnYwOGIL7uneeI9AMwnkG5ABEgPIzdibwRrtDVl1XprrHnSb7
         G9QgebLH0JGpBtXZBPYpZyz6tpoTU3P8NssywFYbxmZbENvwdjjbN+H1Ldck+ncZuWgi
         bV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aJdwa/UjHEpdFkwXFI55W6Oik+ASbLBiAgY0tsSI47A=;
        b=DUdM3x1EMup5aHnB0WFC6T5+pBRrgL+a6elVlI8raUMDyBqQ9y9PLJwL4PD7MS972D
         +MMay+jqaY2mb1Y0uaJJ51h/OGqkwOUFRiaZSVQ5C5M1ci/AEtZAndvKuFaaPhHSeq/b
         LWvTTbOvr1ypRr5gDHdEAFTTCRwe1TiOFKmBx6ZkWpq6RqTt7NTxjdxLY8HvjFfhnk1W
         yN3ouPNkkgOBjIkH8PzGcqg1+7JZhHJlVJo6AZWrlarNQ7LBLTVd7ykDGPefY1kk9v12
         hGdexqJ6gGJA0iWb0GGXH2WMfV2KluEJO8U7ftDpDL2qLYUwO5MM+dmR27TsZovhMjJG
         Mp3g==
X-Gm-Message-State: AJIora9v1ITs78Jmvl0WrjlaEru/yiJATvTroZUa3u8YaPmxtqmE4Fha
        hM1zb3ez1vVGLYcWDoUtUuI=
X-Google-Smtp-Source: AGRyM1vEr7xDHwUSmsa9wcD/monyaHrwDd+d7AYoHF5iRJxTdy6w2SVA2bg7eryqXfwYJrsdSmYxxA==
X-Received: by 2002:a17:907:1caa:b0:726:c4e5:2428 with SMTP id nb42-20020a1709071caa00b00726c4e52428mr3549212ejc.556.1656380048895;
        Mon, 27 Jun 2022 18:34:08 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id x13-20020a170906b08d00b00724261b592esm5693492ejy.186.2022.06.27.18.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 18:34:08 -0700 (PDT)
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
Subject: [net-next PATCH RFC 3/5] net: ethernet: stmicro: stmmac: move dma conf to dedicated struct
Date:   Tue, 28 Jun 2022 03:33:40 +0200
Message-Id: <20220628013342.13581-4-ansuelsmth@gmail.com>
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
 5 files changed, 165 insertions(+), 156 deletions(-)

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
index f4ba27c1c7e0..c211d0274bba 100644
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
@@ -1239,7 +1239,7 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 
 	/* Display RX rings */
 	for (queue = 0; queue < rx_cnt; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+		struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 
 		pr_info("\tRX Queue %u rings\n", queue);
 
@@ -1252,7 +1252,7 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 		}
 
 		/* Display RX ring */
-		stmmac_display_ring(priv, head_rx, priv->dma_rx_size, true,
+		stmmac_display_ring(priv, head_rx, priv->dma_conf.dma_rx_size, true,
 				    rx_q->dma_rx_phy, desc_size);
 	}
 }
@@ -1266,7 +1266,7 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 
 	/* Display TX rings */
 	for (queue = 0; queue < tx_cnt; queue++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 		pr_info("\tTX Queue %d rings\n", queue);
 
@@ -1281,7 +1281,7 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 			desc_size = sizeof(struct dma_desc);
 		}
 
-		stmmac_display_ring(priv, head_tx, priv->dma_tx_size, false,
+		stmmac_display_ring(priv, head_tx, priv->dma_conf.dma_tx_size, false,
 				    tx_q->dma_tx_phy, desc_size);
 	}
 }
@@ -1322,21 +1322,21 @@ static int stmmac_set_bfsize(int mtu, int bufsize)
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
@@ -1348,12 +1348,12 @@ static void stmmac_clear_rx_descriptors(struct stmmac_priv *priv, u32 queue)
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
@@ -1401,7 +1401,7 @@ static void stmmac_clear_descriptors(struct stmmac_priv *priv)
 static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 				  int i, gfp_t flags, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
@@ -1430,7 +1430,7 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 	buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;
 
 	stmmac_set_desc_addr(priv, p, buf->addr);
-	if (priv->dma_buf_sz == BUF_SIZE_16KiB)
+	if (priv->dma_conf.dma_buf_sz == BUF_SIZE_16KiB)
 		stmmac_init_desc3(priv, p);
 
 	return 0;
@@ -1444,7 +1444,7 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
  */
 static void stmmac_free_rx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 
 	if (buf->page)
@@ -1464,7 +1464,7 @@ static void stmmac_free_rx_buffer(struct stmmac_priv *priv, u32 queue, int i)
  */
 static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 	if (tx_q->tx_skbuff_dma[i].buf &&
 	    tx_q->tx_skbuff_dma[i].buf_type != STMMAC_TXBUF_T_XDP_TX) {
@@ -1509,17 +1509,17 @@ static void dma_free_rx_skbufs(struct stmmac_priv *priv, u32 queue)
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
 
@@ -1546,10 +1546,10 @@ static int stmmac_alloc_rx_buffers(struct stmmac_priv *priv, u32 queue,
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
@@ -1562,10 +1562,10 @@ static void dma_free_rx_xskbufs(struct stmmac_priv *priv, u32 queue)
 
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
@@ -1608,7 +1608,7 @@ static struct xsk_buff_pool *stmmac_get_xsk_pool(struct stmmac_priv *priv, u32 q
  */
 static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t flags)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	int ret;
 
 	netif_dbg(priv, probe, priv->dev,
@@ -1654,11 +1654,11 @@ static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t f
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
@@ -1685,7 +1685,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 
 err_init_rx_buffers:
 	while (queue >= 0) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+		struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 
 		if (rx_q->xsk_pool)
 			dma_free_rx_xskbufs(priv, queue);
@@ -1711,7 +1711,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
  */
 static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	int i;
 
 	netif_dbg(priv, probe, priv->dev,
@@ -1723,16 +1723,16 @@ static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
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
@@ -1802,12 +1802,12 @@ static int init_dma_desc_rings(struct net_device *dev, gfp_t flags)
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
@@ -1837,7 +1837,7 @@ static void stmmac_free_tx_skbufs(struct stmmac_priv *priv)
  */
 static void __free_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 
 	/* Release the DMA RX socket buffers */
 	if (rx_q->xsk_pool)
@@ -1850,11 +1850,11 @@ static void __free_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 
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
 
@@ -1883,7 +1883,7 @@ static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
  */
 static void __free_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	size_t size;
 	void *addr;
 
@@ -1901,7 +1901,7 @@ static void __free_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 		addr = tx_q->dma_tx;
 	}
 
-	size *= priv->dma_tx_size;
+	size *= priv->dma_conf.dma_tx_size;
 
 	dma_free_coherent(priv->device, size, addr, tx_q->dma_tx_phy);
 
@@ -1930,7 +1930,7 @@ static void free_dma_tx_desc_resources(struct stmmac_priv *priv)
  */
 static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	bool xdp_prog = stmmac_xdp_is_enabled(priv);
 	struct page_pool_params pp_params = { 0 };
@@ -1942,8 +1942,8 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	rx_q->priv_data = priv;
 
 	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
-	pp_params.pool_size = priv->dma_rx_size;
-	num_pages = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
+	pp_params.pool_size = priv->dma_conf.dma_rx_size;
+	num_pages = DIV_ROUND_UP(priv->dma_conf.dma_buf_sz, PAGE_SIZE);
 	pp_params.order = ilog2(num_pages);
 	pp_params.nid = dev_to_node(priv->device);
 	pp_params.dev = priv->device;
@@ -1958,7 +1958,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 		return ret;
 	}
 
-	rx_q->buf_pool = kcalloc(priv->dma_rx_size,
+	rx_q->buf_pool = kcalloc(priv->dma_conf.dma_rx_size,
 				 sizeof(*rx_q->buf_pool),
 				 GFP_KERNEL);
 	if (!rx_q->buf_pool)
@@ -1966,7 +1966,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 
 	if (priv->extend_desc) {
 		rx_q->dma_erx = dma_alloc_coherent(priv->device,
-						   priv->dma_rx_size *
+						   priv->dma_conf.dma_rx_size *
 						   sizeof(struct dma_extended_desc),
 						   &rx_q->dma_rx_phy,
 						   GFP_KERNEL);
@@ -1975,7 +1975,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv, u32 queue)
 
 	} else {
 		rx_q->dma_rx = dma_alloc_coherent(priv->device,
-						  priv->dma_rx_size *
+						  priv->dma_conf.dma_rx_size *
 						  sizeof(struct dma_desc),
 						  &rx_q->dma_rx_phy,
 						  GFP_KERNEL);
@@ -2032,20 +2032,20 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
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
@@ -2058,7 +2058,7 @@ static int __alloc_dma_tx_desc_resources(struct stmmac_priv *priv, u32 queue)
 	else
 		size = sizeof(struct dma_desc);
 
-	size *= priv->dma_tx_size;
+	size *= priv->dma_conf.dma_tx_size;
 
 	addr = dma_alloc_coherent(priv->device, size,
 				  &tx_q->dma_tx_phy, GFP_KERNEL);
@@ -2302,7 +2302,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 
 	/* configure all channels */
 	for (chan = 0; chan < rx_channels_count; chan++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[chan];
+		struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[chan];
 		u32 buf_size;
 
 		qmode = priv->plat->rx_queues_cfg[chan].mode_to_use;
@@ -2317,7 +2317,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 					      chan);
 		} else {
 			stmmac_set_dma_bfsize(priv, priv->ioaddr,
-					      priv->dma_buf_sz,
+					      priv->dma_conf.dma_buf_sz,
 					      chan);
 		}
 	}
@@ -2333,7 +2333,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 {
 	struct netdev_queue *nq = netdev_get_tx_queue(priv->dev, queue);
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct xsk_buff_pool *pool = tx_q->xsk_pool;
 	unsigned int entry = tx_q->cur_tx;
 	struct dma_desc *tx_desc = NULL;
@@ -2408,7 +2408,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 		stmmac_enable_dma_transmission(priv, priv->ioaddr);
 
-		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_tx_size);
+		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_conf.dma_tx_size);
 		entry = tx_q->cur_tx;
 	}
 
@@ -2449,7 +2449,7 @@ static void stmmac_bump_dma_threshold(struct stmmac_priv *priv, u32 chan)
  */
 static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	unsigned int bytes_compl = 0, pkts_compl = 0;
 	unsigned int entry, xmits = 0, count = 0;
 
@@ -2462,7 +2462,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 	entry = tx_q->dirty_tx;
 
 	/* Try to clean all TX complete frame in 1 shot */
-	while ((entry != tx_q->cur_tx) && count < priv->dma_tx_size) {
+	while ((entry != tx_q->cur_tx) && count < priv->dma_conf.dma_tx_size) {
 		struct xdp_frame *xdpf;
 		struct sk_buff *skb;
 		struct dma_desc *p;
@@ -2564,7 +2564,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 		stmmac_release_tx_desc(priv, p, priv->mode);
 
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 	}
 	tx_q->dirty_tx = entry;
 
@@ -2629,7 +2629,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
  */
 static void stmmac_tx_err(struct stmmac_priv *priv, u32 chan)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 
 	netif_tx_stop_queue(netdev_get_tx_queue(priv->dev, chan));
 
@@ -2696,8 +2696,8 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan, u32 dir)
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
@@ -2863,7 +2863,7 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_channels_count; chan++) {
-		rx_q = &priv->rx_queue[chan];
+		rx_q = &priv->dma_conf.rx_queue[chan];
 
 		stmmac_init_rx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 				    rx_q->dma_rx_phy, chan);
@@ -2877,7 +2877,7 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 
 	/* DMA TX Channel Configuration */
 	for (chan = 0; chan < tx_channels_count; chan++) {
-		tx_q = &priv->tx_queue[chan];
+		tx_q = &priv->dma_conf.tx_queue[chan];
 
 		stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 				    tx_q->dma_tx_phy, chan);
@@ -2892,7 +2892,7 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
 
 static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 	hrtimer_start(&tx_q->txtimer,
 		      STMMAC_COAL_TIMER(priv->tx_coal_timer[queue]),
@@ -2942,7 +2942,7 @@ static void stmmac_init_coalesce(struct stmmac_priv *priv)
 	u32 chan;
 
 	for (chan = 0; chan < tx_channel_count; chan++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 
 		priv->tx_coal_frames[chan] = STMMAC_TX_FRAMES;
 		priv->tx_coal_timer[chan] = STMMAC_COAL_TX_TIMER;
@@ -2964,12 +2964,12 @@ static void stmmac_set_rings_length(struct stmmac_priv *priv)
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
@@ -3296,7 +3296,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 	/* Enable TSO */
 	if (priv->tso) {
 		for (chan = 0; chan < tx_cnt; chan++) {
-			struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+			struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 
 			/* TSO and TBS cannot co-exist */
 			if (tx_q->tbs & STMMAC_TBS_AVAIL)
@@ -3318,7 +3318,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 
 	/* TBS */
 	for (chan = 0; chan < tx_cnt; chan++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+		struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
 		int enable = tx_q->tbs & STMMAC_TBS_AVAIL;
 
 		stmmac_enable_tbs(priv, priv->ioaddr, enable, chan);
@@ -3362,7 +3362,7 @@ static void stmmac_free_irq(struct net_device *dev,
 		for (j = irq_idx - 1; j >= 0; j--) {
 			if (priv->tx_irq[j] > 0) {
 				irq_set_affinity_hint(priv->tx_irq[j], NULL);
-				free_irq(priv->tx_irq[j], &priv->tx_queue[j]);
+				free_irq(priv->tx_irq[j], &priv->dma_conf.tx_queue[j]);
 			}
 		}
 		irq_idx = priv->plat->rx_queues_to_use;
@@ -3371,7 +3371,7 @@ static void stmmac_free_irq(struct net_device *dev,
 		for (j = irq_idx - 1; j >= 0; j--) {
 			if (priv->rx_irq[j] > 0) {
 				irq_set_affinity_hint(priv->rx_irq[j], NULL);
-				free_irq(priv->rx_irq[j], &priv->rx_queue[j]);
+				free_irq(priv->rx_irq[j], &priv->dma_conf.rx_queue[j]);
 			}
 		}
 
@@ -3506,7 +3506,7 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 		sprintf(int_name, "%s:%s-%d", dev->name, "rx", i);
 		ret = request_irq(priv->rx_irq[i],
 				  stmmac_msi_intr_rx,
-				  0, int_name, &priv->rx_queue[i]);
+				  0, int_name, &priv->dma_conf.rx_queue[i]);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: alloc rx-%d  MSI %d (error: %d)\n",
@@ -3531,7 +3531,7 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 		sprintf(int_name, "%s:%s-%d", dev->name, "tx", i);
 		ret = request_irq(priv->tx_irq[i],
 				  stmmac_msi_intr_tx,
-				  0, int_name, &priv->tx_queue[i]);
+				  0, int_name, &priv->dma_conf.tx_queue[i]);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: alloc tx-%d  MSI %d (error: %d)\n",
@@ -3660,21 +3660,21 @@ static int stmmac_open(struct net_device *dev)
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
@@ -3723,7 +3723,7 @@ static int stmmac_open(struct net_device *dev)
 	phylink_stop(priv->phylink);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	stmmac_hw_teardown(dev);
 init_error:
@@ -3759,7 +3759,7 @@ static int stmmac_release(struct net_device *dev)
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	netif_tx_disable(dev);
 
@@ -3825,7 +3825,7 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
 		return false;
 
 	stmmac_set_tx_owner(priv, p);
-	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_tx_size);
+	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_conf.dma_tx_size);
 	return true;
 }
 
@@ -3843,7 +3843,7 @@ static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
 static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
 				 int total_len, bool last_segment, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct dma_desc *desc;
 	u32 buff_size;
 	int tmp_len;
@@ -3854,7 +3854,7 @@ static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
 		dma_addr_t curr_addr;
 
 		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx,
-						priv->dma_tx_size);
+						priv->dma_conf.dma_tx_size);
 		WARN_ON(tx_q->tx_skbuff[tx_q->cur_tx]);
 
 		if (tx_q->tbs & STMMAC_TBS_AVAIL)
@@ -3882,7 +3882,7 @@ static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
 
 static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	int desc_size;
 
 	if (likely(priv->extend_desc))
@@ -3944,7 +3944,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	dma_addr_t des;
 	int i;
 
-	tx_q = &priv->tx_queue[queue];
+	tx_q = &priv->dma_conf.tx_queue[queue];
 	first_tx = tx_q->cur_tx;
 
 	/* Compute header lengths */
@@ -3984,7 +3984,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		stmmac_set_mss(priv, mss_desc, mss);
 		tx_q->mss = mss;
 		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx,
-						priv->dma_tx_size);
+						priv->dma_conf.dma_tx_size);
 		WARN_ON(tx_q->tx_skbuff[tx_q->cur_tx]);
 	}
 
@@ -4096,7 +4096,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * ndo_start_xmit will fill this descriptor the next time it's
 	 * called and stmmac_tx_clean may clean up to this descriptor.
 	 */
-	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_tx_size);
+	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, priv->dma_conf.dma_tx_size);
 
 	if (unlikely(stmmac_tx_avail(priv, queue) <= (MAX_SKB_FRAGS + 1))) {
 		netif_dbg(priv, hw, priv->dev, "%s: stop transmitted packets\n",
@@ -4184,7 +4184,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	int entry, first_tx;
 	dma_addr_t des;
 
-	tx_q = &priv->tx_queue[queue];
+	tx_q = &priv->dma_conf.tx_queue[queue];
 	first_tx = tx_q->cur_tx;
 
 	if (priv->tx_path_in_lpi_mode && priv->eee_sw_timer_en)
@@ -4247,7 +4247,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		int len = skb_frag_size(frag);
 		bool last_segment = (i == (nfrags - 1));
 
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 		WARN_ON(tx_q->tx_skbuff[entry]);
 
 		if (likely(priv->extend_desc))
@@ -4318,7 +4318,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * ndo_start_xmit will fill this descriptor the next time it's
 	 * called and stmmac_tx_clean may clean up to this descriptor.
 	 */
-	entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+	entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 	tx_q->cur_tx = entry;
 
 	if (netif_msg_pktdata(priv)) {
@@ -4433,7 +4433,7 @@ static void stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
  */
 static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	int dirty = stmmac_rx_dirty(priv, queue);
 	unsigned int entry = rx_q->dirty_rx;
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
@@ -4487,7 +4487,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		dma_wmb();
 		stmmac_set_rx_owner(priv, p, use_rx_wd);
 
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_rx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_rx_size);
 	}
 	rx_q->dirty_rx = entry;
 	rx_q->rx_tail_addr = rx_q->dma_rx_phy +
@@ -4515,12 +4515,12 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 
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
@@ -4536,7 +4536,7 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 
 	/* Not last descriptor */
 	if (status & rx_not_ls)
-		return priv->dma_buf_sz;
+		return priv->dma_conf.dma_buf_sz;
 
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
@@ -4547,7 +4547,7 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 				struct xdp_frame *xdpf, bool dma_map)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	unsigned int entry = tx_q->cur_tx;
 	struct dma_desc *tx_desc;
 	dma_addr_t dma_addr;
@@ -4610,7 +4610,7 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 
 	stmmac_enable_dma_transmission(priv, priv->ioaddr);
 
-	entry = STMMAC_GET_ENTRY(entry, priv->dma_tx_size);
+	entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_tx_size);
 	tx_q->cur_tx = entry;
 
 	return STMMAC_XDP_TX;
@@ -4784,7 +4784,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 
 static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	unsigned int entry = rx_q->dirty_rx;
 	struct dma_desc *rx_desc = NULL;
 	bool ret = true;
@@ -4827,7 +4827,7 @@ static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		dma_wmb();
 		stmmac_set_rx_owner(priv, rx_desc, use_rx_wd);
 
-		entry = STMMAC_GET_ENTRY(entry, priv->dma_rx_size);
+		entry = STMMAC_GET_ENTRY(entry, priv->dma_conf.dma_rx_size);
 	}
 
 	if (rx_desc) {
@@ -4842,7 +4842,7 @@ static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	unsigned int count = 0, error = 0, len = 0;
 	int dirty = stmmac_rx_dirty(priv, queue);
 	unsigned int next_entry = rx_q->cur_rx;
@@ -4864,7 +4864,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			desc_size = sizeof(struct dma_desc);
 		}
 
-		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true,
+		stmmac_display_ring(priv, rx_head, priv->dma_conf.dma_rx_size, true,
 				    rx_q->dma_rx_phy, desc_size);
 	}
 	while (count < limit) {
@@ -4911,7 +4911,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 
 		/* Prefetch the next RX descriptor */
 		rx_q->cur_rx = STMMAC_GET_ENTRY(rx_q->cur_rx,
-						priv->dma_rx_size);
+						priv->dma_conf.dma_rx_size);
 		next_entry = rx_q->cur_rx;
 
 		if (priv->extend_desc)
@@ -5032,7 +5032,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
  */
 static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned int count = 0, error = 0, len = 0;
 	int status = 0, coe = priv->hw->rx_csum;
@@ -5045,7 +5045,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	int buf_sz;
 
 	dma_dir = page_pool_get_dma_dir(rx_q->page_pool);
-	buf_sz = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
+	buf_sz = DIV_ROUND_UP(priv->dma_conf.dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
@@ -5059,7 +5059,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			desc_size = sizeof(struct dma_desc);
 		}
 
-		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true,
+		stmmac_display_ring(priv, rx_head, priv->dma_conf.dma_rx_size, true,
 				    rx_q->dma_rx_phy, desc_size);
 	}
 	while (count < limit) {
@@ -5103,7 +5103,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			break;
 
 		rx_q->cur_rx = STMMAC_GET_ENTRY(rx_q->cur_rx,
-						priv->dma_rx_size);
+						priv->dma_conf.dma_rx_size);
 		next_entry = rx_q->cur_rx;
 
 		if (priv->extend_desc)
@@ -5238,7 +5238,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 						buf1_len, dma_dir);
 			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 					buf->page, buf->page_offset, buf1_len,
-					priv->dma_buf_sz);
+					priv->dma_conf.dma_buf_sz);
 
 			/* Data payload appended into SKB */
 			page_pool_release_page(rx_q->page_pool, buf->page);
@@ -5250,7 +5250,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 						buf2_len, dma_dir);
 			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 					buf->sec_page, 0, buf2_len,
-					priv->dma_buf_sz);
+					priv->dma_conf.dma_buf_sz);
 
 			/* Data payload appended into SKB */
 			page_pool_release_page(rx_q->page_pool, buf->sec_page);
@@ -5692,11 +5692,13 @@ static irqreturn_t stmmac_safety_interrupt(int irq, void *dev_id)
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
@@ -5722,10 +5724,12 @@ static irqreturn_t stmmac_msi_intr_tx(int irq, void *data)
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
@@ -5756,10 +5760,10 @@ static void stmmac_poll_controller(struct net_device *dev)
 
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
@@ -5938,34 +5942,34 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
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
 
@@ -6304,7 +6308,7 @@ void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue)
 
 void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned long flags;
 	u32 buf_size;
@@ -6341,7 +6345,7 @@ void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue)
 				      rx_q->queue_index);
 	} else {
 		stmmac_set_dma_bfsize(priv, priv->ioaddr,
-				      priv->dma_buf_sz,
+				      priv->dma_conf.dma_buf_sz,
 				      rx_q->queue_index);
 	}
 
@@ -6367,7 +6371,7 @@ void stmmac_disable_tx_queue(struct stmmac_priv *priv, u32 queue)
 
 void stmmac_enable_tx_queue(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct stmmac_channel *ch = &priv->channel[queue];
 	unsigned long flags;
 	int ret;
@@ -6414,7 +6418,7 @@ void stmmac_xdp_release(struct net_device *dev)
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	/* Free the IRQ lines */
 	stmmac_free_irq(dev, REQ_IRQ_ERR_ALL, 0);
@@ -6473,7 +6477,7 @@ int stmmac_xdp_open(struct net_device *dev)
 
 	/* DMA RX Channel Configuration */
 	for (chan = 0; chan < rx_cnt; chan++) {
-		rx_q = &priv->rx_queue[chan];
+		rx_q = &priv->dma_conf.rx_queue[chan];
 
 		stmmac_init_rx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 				    rx_q->dma_rx_phy, chan);
@@ -6491,7 +6495,7 @@ int stmmac_xdp_open(struct net_device *dev)
 					      rx_q->queue_index);
 		} else {
 			stmmac_set_dma_bfsize(priv, priv->ioaddr,
-					      priv->dma_buf_sz,
+					      priv->dma_conf.dma_buf_sz,
 					      rx_q->queue_index);
 		}
 
@@ -6500,7 +6504,7 @@ int stmmac_xdp_open(struct net_device *dev)
 
 	/* DMA TX Channel Configuration */
 	for (chan = 0; chan < tx_cnt; chan++) {
-		tx_q = &priv->tx_queue[chan];
+		tx_q = &priv->dma_conf.tx_queue[chan];
 
 		stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 				    tx_q->dma_tx_phy, chan);
@@ -6533,7 +6537,7 @@ int stmmac_xdp_open(struct net_device *dev)
 
 irq_error:
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	stmmac_hw_teardown(dev);
 init_error:
@@ -6560,8 +6564,8 @@ int stmmac_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags)
 	    queue >= priv->plat->tx_queues_to_use)
 		return -EINVAL;
 
-	rx_q = &priv->rx_queue[queue];
-	tx_q = &priv->tx_queue[queue];
+	rx_q = &priv->dma_conf.rx_queue[queue];
+	tx_q = &priv->dma_conf.tx_queue[queue];
 	ch = &priv->channel[queue];
 
 	if (!rx_q->xsk_pool && !tx_q->xsk_pool)
@@ -6816,8 +6820,8 @@ int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size)
 	if (netif_running(dev))
 		stmmac_release(dev);
 
-	priv->dma_rx_size = rx_size;
-	priv->dma_tx_size = tx_size;
+	priv->dma_conf.dma_rx_size = rx_size;
+	priv->dma_conf.dma_tx_size = tx_size;
 
 	if (netif_running(dev))
 		ret = stmmac_open(dev);
@@ -7263,7 +7267,7 @@ int stmmac_suspend(struct device *dev)
 	stmmac_disable_all_queues(priv);
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	if (priv->eee_enabled) {
 		priv->tx_path_in_lpi_mode = false;
@@ -7314,7 +7318,7 @@ EXPORT_SYMBOL_GPL(stmmac_suspend);
 
 static void stmmac_reset_rx_queue(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
 
 	rx_q->cur_rx = 0;
 	rx_q->dirty_rx = 0;
@@ -7322,7 +7326,7 @@ static void stmmac_reset_rx_queue(struct stmmac_priv *priv, u32 queue)
 
 static void stmmac_reset_tx_queue(struct stmmac_priv *priv, u32 queue)
 {
-	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 
 	tx_q->cur_tx = 0;
 	tx_q->dirty_tx = 0;
-- 
2.36.1

