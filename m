Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE781F698D
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 16:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgFKOBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 10:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbgFKOBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 10:01:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46C6C03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 07:01:51 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l26so5078341wme.3
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 07:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkNnx+PJ4tEldkFE6NmGlbgnjVg2aGw3VhchR9OtaZw=;
        b=n5+Ok7nJ1Ld/w/7Po5tTgIg8khBvF2s7B4dF3iaf+dDI8f0kQUt9RRFUQ3/rjW4pjE
         D+g/9FREe+gmve3Mr2TykH97UBYHXWt5bL4O9GWAOueL27DPI2HXycc/Ts3nJXIslckn
         oraBFf1U8oWqH0DIRzC9ugtDfmz1gHnKmMQkeJEopugoikKPyF85BMOGj/MQJTnhqde3
         saUGkkSTzvlD5YpPjlJVwZPBoo7ZcqFNzl5nhj8/SOy8KRvTag6vgU6+OPIoR29JORt8
         s99sJ4V0DjoVCQrxu6oTqwXKIWCHaCo95r23NHAKCfxrO3svZkwOvW6RHh6g4yZLwRLT
         fQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkNnx+PJ4tEldkFE6NmGlbgnjVg2aGw3VhchR9OtaZw=;
        b=MOXKMCYg65L5XcpxniycVMJ/64pMQj43tMiRPinOXfOgG/jmG7ZNJ9rr7WsVyF3m7A
         12ngNbispeFusSkh5g2EaO0SZgkn1+VpqWnuqQ/BRPvrR+UdVMyvPZv07Uq5P6XKwQ/b
         DHj1bafFtxCOWTTJPvxjEjDgxoDIwXbj9gxSjcO3vj75n8kGk8ls+1jct4fYBTG30ru+
         3jHF+JFEV8x+c+SYV005lT/3Lm8M5uHdoxBNlChXAJSSyKUu2+mGep29+9b/JXVlM0F4
         x63p/8tc9QEiFOrYGFSeeUY+VpN/DQkkg8SzPWS68XwN+m+pRrT1xxKZT2C2kV9rR6yC
         BB3w==
X-Gm-Message-State: AOAM530iGGuaNIDKLXZmab2zI6S4V9MTxywfsij72CnfzWGLD2DQNcGD
        e2VrdHT8I6PC9wDsRF8HVoi2kQ==
X-Google-Smtp-Source: ABdhPJzJTiQTtzCLL7YjE7Ki6AamPyJbUN9TYcNqL++1AxXSzCWNvaw1iqZfoStaFChZgwa3LhbhNw==
X-Received: by 2002:a1c:c908:: with SMTP id f8mr8469246wmb.150.1591884110019;
        Thu, 11 Jun 2020 07:01:50 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id y5sm5360300wrs.63.2020.06.11.07.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 07:01:49 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH] net: ethernet: mtk-star-emac: simplify interrupt handling
Date:   Thu, 11 Jun 2020 16:01:39 +0200
Message-Id: <20200611140139.17702-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

During development we tried to make the interrupt handling as fine-grained
as possible with TX and RX interrupts being disabled/enabled independently
and the counter registers reset from workqueue context.

Unfortunately after thorough testing of current mainline, we noticed the
driver has become unstable under heavy load. While this is hard to
reproduce, it's quite consistent in the driver's current form.

This patch proposes to go back to the previous approach of doing all
processing in napi context with all interrupts masked in order to make the
driver usable in mainline linux. This doesn't impact the performance on
pumpkin boards at all and it's in line with what many ethernet drivers do
in mainline linux anyway.

At the same time we're adding a FIXME comment about the need to improve
the interrupt handling.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 118 +++++-------------
 1 file changed, 29 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index f1ace4fec19f..3e765bdcf9e1 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -24,7 +24,6 @@
 #include <linux/regmap.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
-#include <linux/workqueue.h>
 
 #define MTK_STAR_DRVNAME			"mtk_star_emac"
 
@@ -262,7 +261,6 @@ struct mtk_star_priv {
 	spinlock_t lock;
 
 	struct rtnl_link_stats64 stats;
-	struct work_struct stats_work;
 };
 
 static struct device *mtk_star_get_dev(struct mtk_star_priv *priv)
@@ -432,42 +430,6 @@ static void mtk_star_intr_disable(struct mtk_star_priv *priv)
 	regmap_write(priv->regs, MTK_STAR_REG_INT_MASK, ~0);
 }
 
-static void mtk_star_intr_enable_tx(struct mtk_star_priv *priv)
-{
-	regmap_clear_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			  MTK_STAR_BIT_INT_STS_TNTC);
-}
-
-static void mtk_star_intr_enable_rx(struct mtk_star_priv *priv)
-{
-	regmap_clear_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			  MTK_STAR_BIT_INT_STS_FNRC);
-}
-
-static void mtk_star_intr_enable_stats(struct mtk_star_priv *priv)
-{
-	regmap_clear_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			  MTK_STAR_REG_INT_STS_MIB_CNT_TH);
-}
-
-static void mtk_star_intr_disable_tx(struct mtk_star_priv *priv)
-{
-	regmap_set_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			MTK_STAR_BIT_INT_STS_TNTC);
-}
-
-static void mtk_star_intr_disable_rx(struct mtk_star_priv *priv)
-{
-	regmap_set_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			MTK_STAR_BIT_INT_STS_FNRC);
-}
-
-static void mtk_star_intr_disable_stats(struct mtk_star_priv *priv)
-{
-	regmap_set_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			MTK_STAR_REG_INT_STS_MIB_CNT_TH);
-}
-
 static unsigned int mtk_star_intr_read(struct mtk_star_priv *priv)
 {
 	unsigned int val;
@@ -663,20 +625,6 @@ static void mtk_star_update_stats(struct mtk_star_priv *priv)
 	stats->rx_errors += stats->rx_fifo_errors;
 }
 
-/* This runs in process context and parallel TX and RX paths executing in
- * napi context may result in losing some stats data but this should happen
- * seldom enough to be acceptable.
- */
-static void mtk_star_update_stats_work(struct work_struct *work)
-{
-	struct mtk_star_priv *priv = container_of(work, struct mtk_star_priv,
-						 stats_work);
-
-	mtk_star_update_stats(priv);
-	mtk_star_reset_counters(priv);
-	mtk_star_intr_enable_stats(priv);
-}
-
 static struct sk_buff *mtk_star_alloc_skb(struct net_device *ndev)
 {
 	uintptr_t tail, offset;
@@ -767,42 +715,25 @@ static void mtk_star_free_tx_skbs(struct mtk_star_priv *priv)
 	mtk_star_ring_free_skbs(priv, ring, mtk_star_dma_unmap_tx);
 }
 
-/* All processing for TX and RX happens in the napi poll callback. */
+/* All processing for TX and RX happens in the napi poll callback.
+ *
+ * FIXME: The interrupt handling should be more fine-grained with each
+ * interrupt enabled/disabled independently when needed. Unfortunatly this
+ * turned out to impact the driver's stability and until we have something
+ * working properly, we're disabling all interrupts during TX & RX processing
+ * or when resetting the counter registers.
+ */
 static irqreturn_t mtk_star_handle_irq(int irq, void *data)
 {
 	struct mtk_star_priv *priv;
 	struct net_device *ndev;
-	bool need_napi = false;
-	unsigned int status;
 
 	ndev = data;
 	priv = netdev_priv(ndev);
 
 	if (netif_running(ndev)) {
-		status = mtk_star_intr_read(priv);
-
-		if (status & MTK_STAR_BIT_INT_STS_TNTC) {
-			mtk_star_intr_disable_tx(priv);
-			need_napi = true;
-		}
-
-		if (status & MTK_STAR_BIT_INT_STS_FNRC) {
-			mtk_star_intr_disable_rx(priv);
-			need_napi = true;
-		}
-
-		if (need_napi)
-			napi_schedule(&priv->napi);
-
-		/* One of the counters reached 0x8000000 - update stats and
-		 * reset all counters.
-		 */
-		if (unlikely(status & MTK_STAR_REG_INT_STS_MIB_CNT_TH)) {
-			mtk_star_intr_disable_stats(priv);
-			schedule_work(&priv->stats_work);
-		}
-
-		mtk_star_intr_ack_all(priv);
+		mtk_star_intr_disable(priv);
+		napi_schedule(&priv->napi);
 	}
 
 	return IRQ_HANDLED;
@@ -1169,8 +1100,6 @@ static void mtk_star_tx_complete_all(struct mtk_star_priv *priv)
 	if (wake && netif_queue_stopped(ndev))
 		netif_wake_queue(ndev);
 
-	mtk_star_intr_enable_tx(priv);
-
 	spin_unlock(&priv->lock);
 }
 
@@ -1332,20 +1261,32 @@ static int mtk_star_process_rx(struct mtk_star_priv *priv, int budget)
 static int mtk_star_poll(struct napi_struct *napi, int budget)
 {
 	struct mtk_star_priv *priv;
+	unsigned int status;
 	int received = 0;
 
 	priv = container_of(napi, struct mtk_star_priv, napi);
 
-	/* Clean-up all TX descriptors. */
-	mtk_star_tx_complete_all(priv);
-	/* Receive up to $budget packets. */
-	received = mtk_star_process_rx(priv, budget);
+	status = mtk_star_intr_read(priv);
+	mtk_star_intr_ack_all(priv);
 
-	if (received < budget) {
-		napi_complete_done(napi, received);
-		mtk_star_intr_enable_rx(priv);
+	if (status & MTK_STAR_BIT_INT_STS_TNTC)
+		/* Clean-up all TX descriptors. */
+		mtk_star_tx_complete_all(priv);
+
+	if (status & MTK_STAR_BIT_INT_STS_FNRC)
+		/* Receive up to $budget packets. */
+		received = mtk_star_process_rx(priv, budget);
+
+	if (unlikely(status & MTK_STAR_REG_INT_STS_MIB_CNT_TH)) {
+		mtk_star_update_stats(priv);
+		mtk_star_reset_counters(priv);
 	}
 
+	if (received < budget)
+		napi_complete_done(napi, received);
+
+	mtk_star_intr_enable(priv);
+
 	return received;
 }
 
@@ -1532,7 +1473,6 @@ static int mtk_star_probe(struct platform_device *pdev)
 	ndev->max_mtu = MTK_STAR_MAX_FRAME_SIZE;
 
 	spin_lock_init(&priv->lock);
-	INIT_WORK(&priv->stats_work, mtk_star_update_stats_work);
 
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
-- 
2.26.1

