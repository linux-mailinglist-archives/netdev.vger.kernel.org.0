Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2F57900F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbiGSBti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiGSBtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:49:35 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BF01B7A9;
        Mon, 18 Jul 2022 18:49:33 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id a18-20020a05600c349200b003a30de68697so295142wmq.0;
        Mon, 18 Jul 2022 18:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rjiJgm+ePUWk4K7ivlZ0MC/qqioPkcS003xuwMGC70A=;
        b=NtpRkIjh4Bv37C970xdAVWthPTrnmEQdyeT0ewXV1A6lqhFkPcNO+5MKYUefXEfip/
         Z4kOZTMSZth5cO6KoeWvSMI/DKggvO/X2cj6ljs8DTle6dZ6eB74+k7ucfBHtFZFQ6Nt
         AKTD3l/8jIrhDeHSscaJxc3kW1uBVNOzRm1eU2Y8+WnGbzbKmMjlip5ajtlVGr3Lr/Ft
         Yt0MGalcSuQP6bx3ZF02e2zToXzh6jfbd31tV0gk8+8skJQTq3hAT1/1sVZZ30mhrHWn
         /BEFoLD7lamYXtuLTkNF+BiDBgFxcGUGeNyLPlsavs8TDhonuuTvYty/kmhqLu6yh0u0
         PB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rjiJgm+ePUWk4K7ivlZ0MC/qqioPkcS003xuwMGC70A=;
        b=u7J6ftC/Ft8WY65YbJaqCA2Y3ey5jIiokBq2c8vkElVzbuZFNU62243oq0VuEyg1sh
         IcBUuMaTPEfayrX7l6/n/cViLK0ODozIKgp5sfDhBHaRH2AgVcbYMfO0YI7Q33JZzjTV
         G/es+JuANXFYScEUhuWubW/YRiJUdni/kSnIU0H+Lb+t1eyns2RrN8ufe9k5pHEKzaMk
         qrYIX2siW07y+ddBHOKmr79F/005e4dSO8fgxbjF/9+1gybGXtKCObiYYhi0nBrZOs9F
         RyqCDdYI1Df2oufDwu2jgyB9XGTNldQisVjtNMLeZonMfZLNgv5v75wRt51jVIKnH5mz
         o0Mw==
X-Gm-Message-State: AJIora+Fle22dyhReNp4j7d4xLVeE9KkwwoFwsCoIlFyUygUhG4W1K+q
        1PIaWJ4Ru/1TVFPGgyh6rHw=
X-Google-Smtp-Source: AGRyM1uFusY3dtICtBSOeVqJQdNbnOtjEtjon/nrmPJkBA+X+LnTpmvBYjkGQrIU6MLFLmVgr5zd+A==
X-Received: by 2002:a7b:cb03:0:b0:39e:e826:ce6d with SMTP id u3-20020a7bcb03000000b0039ee826ce6dmr34636738wmj.102.1658195372239;
        Mon, 18 Jul 2022 18:49:32 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v10-20020a05600c428a00b003a2fc754313sm16193600wmc.10.2022.07.18.18.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:49:31 -0700 (PDT)
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
Subject: [net-next PATCH v4 2/5] net: ethernet: stmicro: stmmac: first disable all queues and disconnect in release
Date:   Tue, 19 Jul 2022 03:32:16 +0200
Message-Id: <20220719013219.11843-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719013219.11843-1-ansuelsmth@gmail.com>
References: <20220719013219.11843-1-ansuelsmth@gmail.com>
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

Disable all queues and disconnect before tx_disable in stmmac_release to
prevent a corner case where packet may be still queued at the same time
tx_disable is called resulting in kernel panic if some packet still has
to be processed.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5578abb14949..96e55dadcfba 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3758,8 +3758,6 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
-	netif_tx_disable(dev);
-
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
@@ -3771,6 +3769,8 @@ static int stmmac_release(struct net_device *dev)
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
 
+	netif_tx_disable(dev);
+
 	/* Free the IRQ lines */
 	stmmac_free_irq(dev, REQ_IRQ_ERR_ALL, 0);
 
-- 
2.36.1

