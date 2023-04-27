Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FC86F0D6E
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 22:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343617AbjD0UqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 16:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344283AbjD0Up5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 16:45:57 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FE046A0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:45:53 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-94f3cd32799so1718203266b.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1682628352; x=1685220352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1g80Na1OEbBoslJdzzF/Prgy9dbHeWplBduFJrTGTE=;
        b=DvLGcylpQYmWAth/6x3toQJKgwI8AKXZeYaKAEYk1Qwh5YqdkwBS/r69ziz2Jz0bIk
         56inSpEO9OPobT/T6x2tgj1d6O0meEzp1hNVCQSnzkuizUqX+GtJcBj76Qh5EB3IW6/n
         oYNww7liCyUl+1YC28I882Pv7ewDVb5CnDPsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682628352; x=1685220352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v1g80Na1OEbBoslJdzzF/Prgy9dbHeWplBduFJrTGTE=;
        b=aUkqOx21KD7Sqx4gJDht/L95V5Tb0/c+G01zFcPY3W9koveRJt8VVTQ6X2bex3/sj8
         BryRmjluJRhVjW7Dwh/d9XS8PpttmXtWvbOquC4O9wsFNx7Go38BK36xLrPwQSl8cRPB
         vfHJx5MMwPhWO2vM7rswJlZozQkfzI/t+IvtEWxU7fK3Omnt/wif8YCl8u7GcxNB+f01
         NATkxiaWIaAExXhnXm+pCC/LskFdrgbShK/ro5zJPC/+sOYcVvUhUBUnV01SJsLBpsCE
         458et+935zggxVO05iMBBWCMgiHODwfcnaVUXjaC84IE4z6nUtaEStb7tJ5XtkbEh2/O
         XlFQ==
X-Gm-Message-State: AC+VfDw9QAtAjVlabfpr1ZZDjXA1cRdu1FUTLYM648fMw0sRhcMPLTDT
        NWF9353FjfaUhvVsoA6hXthDEQ==
X-Google-Smtp-Source: ACHHUZ4PGI/ct8o2uaXVoBpyRsD8PbY2Jehj2M6pOSB2wOzLfB2wdU6oi6hHy1bXWe3tEjrfYjL7dQ==
X-Received: by 2002:a17:906:4fd6:b0:958:2cb5:9ada with SMTP id i22-20020a1709064fd600b009582cb59adamr3071816ejw.39.1682628352378;
        Thu, 27 Apr 2023 13:45:52 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-5-99-194.retail.telecomitalia.it. [87.5.99.194])
        by smtp.gmail.com with ESMTPSA id s12-20020a170906bc4c00b00947ed087a2csm10171360ejv.154.2023.04.27.13.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 13:45:51 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 4/5] can: bxcan: add support for single peripheral configuration
Date:   Thu, 27 Apr 2023 22:45:39 +0200
Message-Id: <20230427204540.3126234-5-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230427204540.3126234-1-dario.binacchi@amarulasolutions.com>
References: <20230427204540.3126234-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for bxCAN controller in single peripheral configuration:
- primary bxCAN
- dedicated Memory Access Controller unit
- 512-byte SRAM memory
- 14 filter banks

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v2:
- s/fiter/filter/ in the commit message
- Replace struct bxcan_mb::primary with struct bxcan_mb::cfg.

 drivers/net/can/bxcan.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/bxcan.c b/drivers/net/can/bxcan.c
index e26ccd41e3cb..027a8a162fe4 100644
--- a/drivers/net/can/bxcan.c
+++ b/drivers/net/can/bxcan.c
@@ -118,7 +118,7 @@
 #define BXCAN_FiR1_REG(b) (0x40 + (b) * 8)
 #define BXCAN_FiR2_REG(b) (0x44 + (b) * 8)
 
-#define BXCAN_FILTER_ID(primary) (primary ? 0 : 14)
+#define BXCAN_FILTER_ID(cfg) ((cfg) == BXCAN_CFG_DUAL_SECONDARY ? 14 : 0)
 
 /* Filter primary register (FMR) bits */
 #define BXCAN_FMR_CANSB_MASK GENMASK(13, 8)
@@ -135,6 +135,12 @@ enum bxcan_lec_code {
 	BXCAN_LEC_UNUSED
 };
 
+enum bxcan_cfg {
+	BXCAN_CFG_SINGLE = 0,
+	BXCAN_CFG_DUAL_PRIMARY,
+	BXCAN_CFG_DUAL_SECONDARY
+};
+
 /* Structure of the message buffer */
 struct bxcan_mb {
 	u32 id;			/* can identifier */
@@ -167,7 +173,7 @@ struct bxcan_priv {
 	struct regmap *gcan;
 	int tx_irq;
 	int sce_irq;
-	bool primary;
+	enum bxcan_cfg cfg;
 	struct clk *clk;
 	spinlock_t rmw_lock;	/* lock for read-modify-write operations */
 	unsigned int tx_head;
@@ -202,17 +208,17 @@ static inline void bxcan_rmw(struct bxcan_priv *priv, void __iomem *addr,
 	spin_unlock_irqrestore(&priv->rmw_lock, flags);
 }
 
-static void bxcan_disable_filters(struct bxcan_priv *priv, bool primary)
+static void bxcan_disable_filters(struct bxcan_priv *priv, enum bxcan_cfg cfg)
 {
-	unsigned int fid = BXCAN_FILTER_ID(primary);
+	unsigned int fid = BXCAN_FILTER_ID(cfg);
 	u32 fmask = BIT(fid);
 
 	regmap_update_bits(priv->gcan, BXCAN_FA1R_REG, fmask, 0);
 }
 
-static void bxcan_enable_filters(struct bxcan_priv *priv, bool primary)
+static void bxcan_enable_filters(struct bxcan_priv *priv, enum bxcan_cfg cfg)
 {
-	unsigned int fid = BXCAN_FILTER_ID(primary);
+	unsigned int fid = BXCAN_FILTER_ID(cfg);
 	u32 fmask = BIT(fid);
 
 	/* Filter settings:
@@ -680,7 +686,7 @@ static int bxcan_chip_start(struct net_device *ndev)
 		  BXCAN_BTR_BRP_MASK | BXCAN_BTR_TS1_MASK | BXCAN_BTR_TS2_MASK |
 		  BXCAN_BTR_SJW_MASK, set);
 
-	bxcan_enable_filters(priv, priv->primary);
+	bxcan_enable_filters(priv, priv->cfg);
 
 	/* Clear all internal status */
 	priv->tx_head = 0;
@@ -806,7 +812,7 @@ static void bxcan_chip_stop(struct net_device *ndev)
 		  BXCAN_IER_EPVIE | BXCAN_IER_EWGIE | BXCAN_IER_FOVIE1 |
 		  BXCAN_IER_FFIE1 | BXCAN_IER_FMPIE1 | BXCAN_IER_FOVIE0 |
 		  BXCAN_IER_FFIE0 | BXCAN_IER_FMPIE0 | BXCAN_IER_TMEIE, 0);
-	bxcan_disable_filters(priv, priv->primary);
+	bxcan_disable_filters(priv, priv->cfg);
 	bxcan_enter_sleep_mode(priv);
 	priv->can.state = CAN_STATE_STOPPED;
 }
@@ -931,7 +937,7 @@ static int bxcan_probe(struct platform_device *pdev)
 	struct clk *clk = NULL;
 	void __iomem *regs;
 	struct regmap *gcan;
-	bool primary;
+	enum bxcan_cfg cfg;
 	int err, rx_irq, tx_irq, sce_irq;
 
 	regs = devm_platform_ioremap_resource(pdev, 0);
@@ -946,7 +952,13 @@ static int bxcan_probe(struct platform_device *pdev)
 		return PTR_ERR(gcan);
 	}
 
-	primary = of_property_read_bool(np, "st,can-primary");
+	if (of_property_read_bool(np, "st,can-primary"))
+		cfg = BXCAN_CFG_DUAL_PRIMARY;
+	else if (of_property_read_bool(np, "st,can-secondary"))
+		cfg = BXCAN_CFG_DUAL_SECONDARY;
+	else
+		cfg = BXCAN_CFG_SINGLE;
+
 	clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(dev, "failed to get clock\n");
@@ -992,7 +1004,7 @@ static int bxcan_probe(struct platform_device *pdev)
 	priv->clk = clk;
 	priv->tx_irq = tx_irq;
 	priv->sce_irq = sce_irq;
-	priv->primary = primary;
+	priv->cfg = cfg;
 	priv->can.clock.freq = clk_get_rate(clk);
 	spin_lock_init(&priv->rmw_lock);
 	priv->tx_head = 0;
-- 
2.32.0

