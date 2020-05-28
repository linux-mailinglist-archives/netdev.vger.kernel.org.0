Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3391E60FD
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389805AbgE1Mfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389769AbgE1MfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 08:35:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496FFC08C5C8
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 05:35:15 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id n5so3007828wmd.0
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 05:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+G7RdtEM9Tjyup1qpXdvSxuTiPiV2T/6Xv3zi3kgdqw=;
        b=agYjZQeOyZ2AKf60nZ90apYgp7Yv0o1BklkIQFUjoNOenWr/OvSkdORC94vYkhfcDg
         DOgAqd08KF2s8QEItyJuayobS5m2gdfgojHTRwjSc76k3rYZRkYNCq0Nx3J3GJaWT4bK
         kdogL5Yhno/HKBQkDHpHts1NCAqaAAA4jKFfAvVRsCiNRWwlvHPJfCqZhA2Z7FKnjNuR
         0mvQ3Io3RUeLuTVB8Xr8qE0+xDqRa9fM/iBCjtm7/UZmGsaliTfUEM2/gjVayPouAnzc
         7j8kyvWhtcMo4s0q+rMEKcpzWijxVxRGraJHOVVEqcSU7eJy/B4sXAn7rzn/HPHrF/a3
         5w2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+G7RdtEM9Tjyup1qpXdvSxuTiPiV2T/6Xv3zi3kgdqw=;
        b=srb80aUplhtFEPnsr2tHD+FDJ63BpIgBPmDQ8yf3p9RURCtqjd7bJO+G0DgT7DSksa
         587wV6CWAWfQwujAfxjJS2DlnOReIuoq0A9hV+F5aqyhmTDfweX+NpU7raql6JUGur0g
         /+i25X8dn0LRDW0Qv0C6M+14wwzCJcAc4E46d0IHj5q1W5iY5M7T2YpSnq5K3XEuxNOl
         wLqD4dwgWn/VIfhzR0sX9KjyT8qiuplLr8XgVc4OE9Xoo/8KV3ADMIeV+o5iK0EkGju/
         qCgsNm2O0k1oz4+QNlzEKMi9eKygti8DYsgR45qGk8DNyXKSKH8sX88hUwyV2C3tiqRP
         mA2Q==
X-Gm-Message-State: AOAM532pcAZ/JbNBh4iR/cPF+qtL8AgxDkxXmxkU7cSejmue0eOyNTYx
        22+AJE11tA7TCHgYprdtr1RM4g==
X-Google-Smtp-Source: ABdhPJx9Jl9dNfglp38Fbyofob3ykhPOc3lBvfMMdzC7r7DXwkN65ZMkM1MkCvyFFas/ZyzprY7Siw==
X-Received: by 2002:a1c:2d14:: with SMTP id t20mr3308643wmt.28.1590669314028;
        Thu, 28 May 2020 05:35:14 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c140sm6027306wmd.18.2020.05.28.05.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 05:35:13 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 2/2] net: ethernet: mtk-star-emac: use regmap bitops
Date:   Thu, 28 May 2020 14:34:59 +0200
Message-Id: <20200528123459.21168-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200528123459.21168-1-brgl@bgdev.pl>
References: <20200528123459.21168-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Shrink the code visually by replacing regmap_update_bits() with
appropriate regmap bit operations where applicable.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 80 ++++++++-----------
 1 file changed, 35 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 8596ca0e60eb..326ac792a4a0 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -413,8 +413,8 @@ static void mtk_star_dma_unmap_tx(struct mtk_star_priv *priv,
 
 static void mtk_star_nic_disable_pd(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_MAC_CFG,
-			   MTK_STAR_BIT_MAC_CFG_NIC_PD, 0);
+	regmap_clear_bits(priv->regs, MTK_STAR_REG_MAC_CFG,
+			  MTK_STAR_BIT_MAC_CFG_NIC_PD);
 }
 
 /* Unmask the three interrupts we care about, mask all others. */
@@ -434,41 +434,38 @@ static void mtk_star_intr_disable(struct mtk_star_priv *priv)
 
 static void mtk_star_intr_enable_tx(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			   MTK_STAR_BIT_INT_STS_TNTC, 0);
+	regmap_clear_bits(priv->regs, MTK_STAR_REG_INT_MASK,
+			  MTK_STAR_BIT_INT_STS_TNTC);
 }
 
 static void mtk_star_intr_enable_rx(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			   MTK_STAR_BIT_INT_STS_FNRC, 0);
+	regmap_clear_bits(priv->regs, MTK_STAR_REG_INT_MASK,
+			  MTK_STAR_BIT_INT_STS_FNRC);
 }
 
 static void mtk_star_intr_enable_stats(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			   MTK_STAR_REG_INT_STS_MIB_CNT_TH, 0);
+	regmap_clear_bits(priv->regs, MTK_STAR_REG_INT_MASK,
+			  MTK_STAR_REG_INT_STS_MIB_CNT_TH);
 }
 
 static void mtk_star_intr_disable_tx(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			   MTK_STAR_BIT_INT_STS_TNTC,
-			   MTK_STAR_BIT_INT_STS_TNTC);
+	regmap_set_bits(priv->regs, MTK_STAR_REG_INT_MASK,
+			MTK_STAR_BIT_INT_STS_TNTC);
 }
 
 static void mtk_star_intr_disable_rx(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			   MTK_STAR_BIT_INT_STS_FNRC,
-			   MTK_STAR_BIT_INT_STS_FNRC);
+	regmap_set_bits(priv->regs, MTK_STAR_REG_INT_MASK,
+			MTK_STAR_BIT_INT_STS_FNRC);
 }
 
 static void mtk_star_intr_disable_stats(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_INT_MASK,
-			   MTK_STAR_REG_INT_STS_MIB_CNT_TH,
-			   MTK_STAR_REG_INT_STS_MIB_CNT_TH);
+	regmap_set_bits(priv->regs, MTK_STAR_REG_INT_MASK,
+			MTK_STAR_REG_INT_STS_MIB_CNT_TH);
 }
 
 static unsigned int mtk_star_intr_read(struct mtk_star_priv *priv)
@@ -524,12 +521,10 @@ static void mtk_star_dma_init(struct mtk_star_priv *priv)
 
 static void mtk_star_dma_start(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_TX_DMA_CTRL,
-			   MTK_STAR_BIT_TX_DMA_CTRL_START,
-			   MTK_STAR_BIT_TX_DMA_CTRL_START);
-	regmap_update_bits(priv->regs, MTK_STAR_REG_RX_DMA_CTRL,
-			   MTK_STAR_BIT_RX_DMA_CTRL_START,
-			   MTK_STAR_BIT_RX_DMA_CTRL_START);
+	regmap_set_bits(priv->regs, MTK_STAR_REG_TX_DMA_CTRL,
+			MTK_STAR_BIT_TX_DMA_CTRL_START);
+	regmap_set_bits(priv->regs, MTK_STAR_REG_RX_DMA_CTRL,
+			MTK_STAR_BIT_RX_DMA_CTRL_START);
 }
 
 static void mtk_star_dma_stop(struct mtk_star_priv *priv)
@@ -553,16 +548,14 @@ static void mtk_star_dma_disable(struct mtk_star_priv *priv)
 
 static void mtk_star_dma_resume_rx(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_RX_DMA_CTRL,
-			   MTK_STAR_BIT_RX_DMA_CTRL_RESUME,
-			   MTK_STAR_BIT_RX_DMA_CTRL_RESUME);
+	regmap_set_bits(priv->regs, MTK_STAR_REG_RX_DMA_CTRL,
+			MTK_STAR_BIT_RX_DMA_CTRL_RESUME);
 }
 
 static void mtk_star_dma_resume_tx(struct mtk_star_priv *priv)
 {
-	regmap_update_bits(priv->regs, MTK_STAR_REG_TX_DMA_CTRL,
-			   MTK_STAR_BIT_TX_DMA_CTRL_RESUME,
-			   MTK_STAR_BIT_TX_DMA_CTRL_RESUME);
+	regmap_set_bits(priv->regs, MTK_STAR_REG_TX_DMA_CTRL,
+			MTK_STAR_BIT_TX_DMA_CTRL_RESUME);
 }
 
 static void mtk_star_set_mac_addr(struct net_device *ndev)
@@ -845,8 +838,8 @@ static int mtk_star_hash_wait_ok(struct mtk_star_priv *priv)
 		return ret;
 
 	/* Check the BIST_OK bit. */
-	regmap_read(priv->regs, MTK_STAR_REG_HASH_CTRL, &val);
-	if (!(val & MTK_STAR_BIT_HASH_CTRL_BIST_OK))
+	if (!regmap_test_bits(priv->regs, MTK_STAR_REG_HASH_CTRL,
+			      MTK_STAR_BIT_HASH_CTRL_BIST_OK))
 		return -EIO;
 
 	return 0;
@@ -880,12 +873,10 @@ static int mtk_star_reset_hash_table(struct mtk_star_priv *priv)
 	if (ret)
 		return ret;
 
-	regmap_update_bits(priv->regs, MTK_STAR_REG_HASH_CTRL,
-			   MTK_STAR_BIT_HASH_CTRL_BIST_EN,
-			   MTK_STAR_BIT_HASH_CTRL_BIST_EN);
-	regmap_update_bits(priv->regs, MTK_STAR_REG_TEST1,
-			   MTK_STAR_BIT_TEST1_RST_HASH_MBIST,
-			   MTK_STAR_BIT_TEST1_RST_HASH_MBIST);
+	regmap_set_bits(priv->regs, MTK_STAR_REG_HASH_CTRL,
+			MTK_STAR_BIT_HASH_CTRL_BIST_EN);
+	regmap_set_bits(priv->regs, MTK_STAR_REG_TEST1,
+			MTK_STAR_BIT_TEST1_RST_HASH_MBIST);
 
 	return mtk_star_hash_wait_ok(priv);
 }
@@ -1016,13 +1007,13 @@ static int mtk_star_enable(struct net_device *ndev)
 		return ret;
 
 	/* Setup the hashing algorithm */
-	regmap_update_bits(priv->regs, MTK_STAR_REG_ARL_CFG,
-			   MTK_STAR_BIT_ARL_CFG_HASH_ALG |
-			   MTK_STAR_BIT_ARL_CFG_MISC_MODE, 0);
+	regmap_clear_bits(priv->regs, MTK_STAR_REG_ARL_CFG,
+			  MTK_STAR_BIT_ARL_CFG_HASH_ALG |
+			  MTK_STAR_BIT_ARL_CFG_MISC_MODE);
 
 	/* Don't strip VLAN tags */
-	regmap_update_bits(priv->regs, MTK_STAR_REG_MAC_CFG,
-			   MTK_STAR_BIT_MAC_CFG_VLAN_STRIP, 0);
+	regmap_clear_bits(priv->regs, MTK_STAR_REG_MAC_CFG,
+			  MTK_STAR_BIT_MAC_CFG_VLAN_STRIP);
 
 	/* Setup DMA */
 	mtk_star_dma_init(priv);
@@ -1204,9 +1195,8 @@ static void mtk_star_set_rx_mode(struct net_device *ndev)
 	int ret;
 
 	if (ndev->flags & IFF_PROMISC) {
-		regmap_update_bits(priv->regs, MTK_STAR_REG_ARL_CFG,
-				   MTK_STAR_BIT_ARL_CFG_MISC_MODE,
-				   MTK_STAR_BIT_ARL_CFG_MISC_MODE);
+		regmap_set_bits(priv->regs, MTK_STAR_REG_ARL_CFG,
+				MTK_STAR_BIT_ARL_CFG_MISC_MODE);
 	} else if (netdev_mc_count(ndev) > MTK_STAR_HASHTABLE_MC_LIMIT ||
 		   ndev->flags & IFF_ALLMULTI) {
 		for (i = 0; i < MTK_STAR_HASHTABLE_SIZE_MAX; i++) {
-- 
2.25.0

