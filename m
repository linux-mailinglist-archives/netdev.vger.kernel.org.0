Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A700957EFBC
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbiGWO35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235728AbiGWO3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:29:50 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213F819C19;
        Sat, 23 Jul 2022 07:29:49 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h8so10032153wrw.1;
        Sat, 23 Jul 2022 07:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dtK+f+e69ktRtm1DfmKkH7OgqSKD4ay2ViO2yXXI+mw=;
        b=BRKTixbhnurH9pcfogJZP+9+9XbOYRMbxDufycEZFZc8tpLD+IfE7sDdgURmuvojSb
         mx6bjoYVKP5r8Y/ktV+gn4iSMhObNTo6afdTGZNOQgaKQi4DaXEonBi/YQf6qTyeHyCS
         c4gm8WFbaUMcHH5XF5X1rjnhpMynADfN1xdfxtCuBqLbyXEmojT7QQt6xz9i1dENaeut
         wqtCHIW/32q30tWK2DyAYSr+1VDV25kwnGHSmIdEwcpXHqMo1l5BEtpOJjrU/Qv9XTgY
         T42zHG0pqL6dT/GJa012PbeuB/yx+X685jDREvV2rslvY3b4bjKX9MnKiWcBwmzzHveU
         BUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dtK+f+e69ktRtm1DfmKkH7OgqSKD4ay2ViO2yXXI+mw=;
        b=ki4miqpKuOapnrdpjqUnAEq6+KU0jkVBGHdw/jw4iS+vDvLS5D6iNM7Ol0AjCe6Ueq
         WH6EsqlU20PbW/88lMLLuH/z/cUbhLizr8MnD7RUmSm2j1PdXtuCzYStq8TqsRsLPDQm
         y8g8h05sYMwBsXXAp1lqNH2hcoP1/W0+pr/bWukkNEEspu2avJe8scK6i7jP12Qnlcro
         69INZvmcDLaR9FFvHDZqA+Mo1zyIsEY+CE66PwKfPiVYs127Z0YI4YRmeUofctMQxFWF
         n6aW7TZSMHxQATRp7nNy3szvvGGt/l/HoWSCzG0y4aTUtD4Jel9hunvbRVp6U2XacNBk
         /Klg==
X-Gm-Message-State: AJIora8zT08CeWFEGSRCpxdSXdPBly7vCKDTtJeOvfUXR30mVG9PF/DG
        TUcpVUygEyxZ/Ly1ondvXRE=
X-Google-Smtp-Source: AGRyM1vLn8trzceLunwqhaXT5AIv6dL8/i2Cw1MFuKkaH+23TDjqBDi7C+PEM5t9iwwpDbzI1v8hQQ==
X-Received: by 2002:a05:6000:186:b0:21e:5874:2bfb with SMTP id p6-20020a056000018600b0021e58742bfbmr3016866wrx.510.1658586587614;
        Sat, 23 Jul 2022 07:29:47 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id q6-20020a1cf306000000b0039c5ab7167dsm11689717wmq.48.2022.07.23.07.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:29:47 -0700 (PDT)
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
Subject: [net-next PATCH v5 1/5] net: ethernet: stmicro: stmmac: move queue reset to dedicated functions
Date:   Sat, 23 Jul 2022 16:29:29 +0200
Message-Id: <20220723142933.16030-2-ansuelsmth@gmail.com>
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

Move queue reset to dedicated functions. This aside from a simple
cleanup is also required to allocate a dma conf without resetting the tx
queue while the device is temporarily detached as now the reset is not
part of the dma init function and can be done later in the code flow.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 59 ++++++++++---------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6f14b00c0b14..5578abb14949 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -130,6 +130,9 @@ static irqreturn_t stmmac_mac_interrupt(int irq, void *dev_id);
 static irqreturn_t stmmac_safety_interrupt(int irq, void *dev_id);
 static irqreturn_t stmmac_msi_intr_tx(int irq, void *data);
 static irqreturn_t stmmac_msi_intr_rx(int irq, void *data);
+static void stmmac_reset_rx_queue(struct stmmac_priv *priv, u32 queue);
+static void stmmac_reset_tx_queue(struct stmmac_priv *priv, u32 queue);
+static void stmmac_reset_queues_param(struct stmmac_priv *priv);
 static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue);
 static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue);
 static void stmmac_set_dma_operation_mode(struct stmmac_priv *priv, u32 txmode,
@@ -1648,9 +1651,6 @@ static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t f
 			return -ENOMEM;
 	}
 
-	rx_q->cur_rx = 0;
-	rx_q->dirty_rx = 0;
-
 	/* Setup the chained descriptor addresses */
 	if (priv->mode == STMMAC_CHAIN_MODE) {
 		if (priv->extend_desc)
@@ -1753,12 +1753,6 @@ static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
 		tx_q->tx_skbuff[i] = NULL;
 	}
 
-	tx_q->dirty_tx = 0;
-	tx_q->cur_tx = 0;
-	tx_q->mss = 0;
-
-	netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
-
 	return 0;
 }
 
@@ -2644,10 +2638,7 @@ static void stmmac_tx_err(struct stmmac_priv *priv, u32 chan)
 	stmmac_stop_tx_dma(priv, chan);
 	dma_free_tx_skbufs(priv, chan);
 	stmmac_clear_tx_descriptors(priv, chan);
-	tx_q->dirty_tx = 0;
-	tx_q->cur_tx = 0;
-	tx_q->mss = 0;
-	netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, chan));
+	stmmac_reset_tx_queue(priv, chan);
 	stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
 			    tx_q->dma_tx_phy, chan);
 	stmmac_start_tx_dma(priv, chan);
@@ -3706,6 +3697,8 @@ static int stmmac_open(struct net_device *dev)
 		goto init_error;
 	}
 
+	stmmac_reset_queues_param(priv);
+
 	ret = stmmac_hw_setup(dev, true);
 	if (ret < 0) {
 		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
@@ -6332,6 +6325,7 @@ void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue)
 		return;
 	}
 
+	stmmac_reset_rx_queue(priv, queue);
 	stmmac_clear_rx_descriptors(priv, queue);
 
 	stmmac_init_rx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
@@ -6393,6 +6387,7 @@ void stmmac_enable_tx_queue(struct stmmac_priv *priv, u32 queue)
 		return;
 	}
 
+	stmmac_reset_tx_queue(priv, queue);
 	stmmac_clear_tx_descriptors(priv, queue);
 
 	stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
@@ -7319,6 +7314,25 @@ int stmmac_suspend(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(stmmac_suspend);
 
+static void stmmac_reset_rx_queue(struct stmmac_priv *priv, u32 queue)
+{
+	struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+
+	rx_q->cur_rx = 0;
+	rx_q->dirty_rx = 0;
+}
+
+static void stmmac_reset_tx_queue(struct stmmac_priv *priv, u32 queue)
+{
+	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+
+	tx_q->cur_tx = 0;
+	tx_q->dirty_tx = 0;
+	tx_q->mss = 0;
+
+	netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
+}
+
 /**
  * stmmac_reset_queues_param - reset queue parameters
  * @priv: device pointer
@@ -7329,22 +7343,11 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
 	u32 queue;
 
-	for (queue = 0; queue < rx_cnt; queue++) {
-		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-
-		rx_q->cur_rx = 0;
-		rx_q->dirty_rx = 0;
-	}
-
-	for (queue = 0; queue < tx_cnt; queue++) {
-		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
+	for (queue = 0; queue < rx_cnt; queue++)
+		stmmac_reset_rx_queue(priv, queue);
 
-		tx_q->cur_tx = 0;
-		tx_q->dirty_tx = 0;
-		tx_q->mss = 0;
-
-		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
-	}
+	for (queue = 0; queue < tx_cnt; queue++)
+		stmmac_reset_tx_queue(priv, queue);
 }
 
 /**
-- 
2.36.1

