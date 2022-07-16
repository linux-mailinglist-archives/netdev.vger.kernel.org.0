Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BEB5770D2
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiGPSr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiGPSr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:47:58 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A82518E1C;
        Sat, 16 Jul 2022 11:47:57 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l68so4675567wml.3;
        Sat, 16 Jul 2022 11:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dtK+f+e69ktRtm1DfmKkH7OgqSKD4ay2ViO2yXXI+mw=;
        b=CNAALrLUMPdgJjDJvbU9O6Xjyt0va8C47Zbxib8DlBgcp3965VYtwEf9mvduXwp3zj
         kmpHeyjKHcanyf8zG8zlQ29tXL/A+oSFTDadAVDqdSVlfIhcAf5KIE8lsTAx8Mj8cix4
         S9QAszuAvj0+sgMX9SBPIykHf3F9eh803hAIcbA9IsozmLPKR/K5wDuyytXxRlMLQwOM
         y6tB78mDK4PJxL4xm8dfJjaTK1AycgJNeYrJZz8GmtWEF5xysd2ALDJOZtbUXhIpFThw
         9i1QX1OPQssK+qhU8SMfGa407Ohdc1weVZmFD8hxJqPpE/EJ3DnhGzNFwfvIJoh3HKQ9
         Qjjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dtK+f+e69ktRtm1DfmKkH7OgqSKD4ay2ViO2yXXI+mw=;
        b=nwR3FsExtWYGq61sL9UoqDBNnAA14rNTZTej8xA+5WWteQduaI0RVGOz/OV5x52q8H
         i9IWBMksqQozpKUmB4U/X5sWmIrJbuSIjmrW+Uqi15JQgm224TQxrpWZDAJLXkkqdYho
         MfS11WsUGfPSB0btZmWJrtSrz/fnaecfgLzBKUDF5OTTB7A7fbKtTLH2cGfzQYzubGMw
         FCOH3+33MeO40dzXjTTSP58IlhoEvyF6B7XrPjalZcFADSdCn5tHmAzn/21x7rSDrycm
         wxkIGvjin1oiYzcqWlzoLBtf2Md+S3KSt3O3ELhEsvecT4znNQLZCQvm0Ih+isCNArhL
         M5Aw==
X-Gm-Message-State: AJIora8IKIB8DGOarnlMThH799Wb9WRkclINHNn6/f3Q5Rz/CvQul6hz
        HggZa0k829dmRyl3bWGa/BI=
X-Google-Smtp-Source: AGRyM1tAjWiNoZNjr+4kaYNNC7QQU9lHpgs9Ujpg49OtEXkSpDCHUwAacaO0RkNIrLO6L+F64EYsFQ==
X-Received: by 2002:a05:600c:2e44:b0:3a2:fcc8:b889 with SMTP id q4-20020a05600c2e4400b003a2fcc8b889mr19078807wmf.67.1657997275636;
        Sat, 16 Jul 2022 11:47:55 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id u18-20020a05600c19d200b003973c54bd69sm13649961wmq.1.2022.07.16.11.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 11:47:55 -0700 (PDT)
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
Subject: [net-next PATCH v2 1/5] net: ethernet: stmicro: stmmac: move queue reset to dedicated functions
Date:   Sat, 16 Jul 2022 20:45:29 +0200
Message-Id: <20220716184533.2962-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220716184533.2962-1-ansuelsmth@gmail.com>
References: <20220716184533.2962-1-ansuelsmth@gmail.com>
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

