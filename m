Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3359455C115
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243079AbiF1BeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242921AbiF1BeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:34:09 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3537A17A9E;
        Mon, 27 Jun 2022 18:34:08 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id d2so10912709ejy.1;
        Mon, 27 Jun 2022 18:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yF4+Fitkqfa+QuxFTrcLIvH1UEWA7T7dfHKeApzKf9c=;
        b=oyGBmRGYd6qLeGP9HPaDKkS2Wi65q/Hpq1EIROev7SyfFaGN5bJDUnJnlhlrj46ZBy
         K/R86rtJDHdWfUk9Okn5lH6gQinSYNvWzm3JMRDGMuvcLsYhbc5frh5oWl+nNYEFW74V
         RfUr8MzqieNyYlra1s0+wa0BJ5f7pt7x2et1Kert8obv4E/evF1fd1CbuaBQivuNMZ0k
         YYBNxVV+aky5zEn4ZA6w9uVVRlHvw3cuID6NuhdKXA3fSwuvw4ggjKJ5ZqIoQkQsOZsN
         qs/UVKe36rAAnBa4zQctALQ2FIEnGwAZtHGRQ4Cf/Ujfw/+G867HI207NP2vxbK3wGkZ
         GwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yF4+Fitkqfa+QuxFTrcLIvH1UEWA7T7dfHKeApzKf9c=;
        b=dkIEiY36QTFnb7TY26bASs/g4DYa+mi3zrS3ghnnd/kKepi41Sdxp/jcUpxHPBqUs1
         Ec0j0L0zr5O/85pAnVkhz+PeuJpnCbhrVsDuPHugneeTdNCDDndCdKmyhw9NkvXEhxw8
         /tSK4f/ejdRD9iL85YUCnIle+MQ6wcJ+cmzRerJaR1AVOAO9sOoGhAPkbDddi0ProO/J
         NwKYjoVA3uUGT1kINgPwjiRQvOmmcw1pkyyCHXkRVBTBCVFAn0xnp1YZe4sqpv8ORBzc
         hAYI4DJSrKSf7/64B6fFmL9iCDPUWoD4Wr2N0yG/9ACqSGXHT0lu6rTmyE9FEfKnACmQ
         sfyg==
X-Gm-Message-State: AJIora9qHDtSBpFpuynFz8GLz7X+pFszbX4PUTDXka1kkEo4S7/CWrtF
        gGYARtT9bYXwvRYNt80rWxih0/ZyuFs=
X-Google-Smtp-Source: AGRyM1t0Q70YGNd4a3J68aU0nXmjkoBLTIx9ya4AHqRUUTAiaOQsZPZWsttSFIoTEeBTzq2duRXn5Q==
X-Received: by 2002:a17:907:969f:b0:726:94a0:26fd with SMTP id hd31-20020a170907969f00b0072694a026fdmr12096238ejc.234.1656380046538;
        Mon, 27 Jun 2022 18:34:06 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id x13-20020a170906b08d00b00724261b592esm5693492ejy.186.2022.06.27.18.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 18:34:06 -0700 (PDT)
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
Subject: [net-next PATCH RFC 1/5] net: ethernet: stmicro: stmmac: move queue reset to dedicated functions
Date:   Tue, 28 Jun 2022 03:33:38 +0200
Message-Id: <20220628013342.13581-2-ansuelsmth@gmail.com>
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

Move queue reset to dedicated functions. This aside from a simple
cleanup is also required to allocate a dma conf without resetting the tx
queue while the device is temporarily detached as now the reset is not
part of the dma init function and can be done later in the code flow.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 59 ++++++++++---------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d1a7cf4567bc..f861246de2e5 100644
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
@@ -1646,9 +1649,6 @@ static int __init_dma_rx_desc_rings(struct stmmac_priv *priv, u32 queue, gfp_t f
 			return -ENOMEM;
 	}
 
-	rx_q->cur_rx = 0;
-	rx_q->dirty_rx = 0;
-
 	/* Setup the chained descriptor addresses */
 	if (priv->mode == STMMAC_CHAIN_MODE) {
 		if (priv->extend_desc)
@@ -1751,12 +1751,6 @@ static int __init_dma_tx_desc_rings(struct stmmac_priv *priv, u32 queue)
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
 
@@ -2642,10 +2636,7 @@ static void stmmac_tx_err(struct stmmac_priv *priv, u32 chan)
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
@@ -3704,6 +3695,8 @@ static int stmmac_open(struct net_device *dev)
 		goto init_error;
 	}
 
+	stmmac_reset_queues_param(priv);
+
 	ret = stmmac_hw_setup(dev, true);
 	if (ret < 0) {
 		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
@@ -6330,6 +6323,7 @@ void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue)
 		return;
 	}
 
+	stmmac_reset_rx_queue(priv, queue);
 	stmmac_clear_rx_descriptors(priv, queue);
 
 	stmmac_init_rx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
@@ -6391,6 +6385,7 @@ void stmmac_enable_tx_queue(struct stmmac_priv *priv, u32 queue)
 		return;
 	}
 
+	stmmac_reset_tx_queue(priv, queue);
 	stmmac_clear_tx_descriptors(priv, queue);
 
 	stmmac_init_tx_chan(priv, priv->ioaddr, priv->plat->dma_cfg,
@@ -7317,6 +7312,25 @@ int stmmac_suspend(struct device *dev)
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
@@ -7327,22 +7341,11 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
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

