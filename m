Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A59E5770D7
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbiGPSsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiGPSr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:47:59 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645BF186FF;
        Sat, 16 Jul 2022 11:47:58 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q9so11135064wrd.8;
        Sat, 16 Jul 2022 11:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AcH9xqJ0k/4jByViDRihM1a2jjuLTRujm9Mqh/y4WfU=;
        b=qbVbSB2V7fahimrZ1Z8x+RhdfTcaVEKX5BHhKsTvlNKRUOEHV4OCPssP+OlTpg+Sea
         CoVGyybzYZAh0tct0k7DokF4BZ1kSE0O00QD6BYRZKEW8r20URe3htj/9nsucq9YEZBG
         VIsnf4QqrPFdoUhthRPrVs/kUOqNtQEpUTPamB6PWy0rswI4gkt0DHEmStjBoY5ZZCzd
         5CqgVa3dU/o+mBgns7OIzIYwTgRZCAuYEwJjzYEBVWUVg3EcWGF+2sspbKZ5CHZXvE/D
         64R7n1g9siKfEXImj1MF14CwmJ37bk5Ic0OXztZNU580BPBC/XSXu49UL8Tnu8SkOSnr
         Rklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AcH9xqJ0k/4jByViDRihM1a2jjuLTRujm9Mqh/y4WfU=;
        b=JV1R8QGgeONoesRYip7TKj6RELCJEr84dzd7pZr7EiINYDln5hnDaurzroFNxpE80K
         M4z2vGkEjxuGArmDqFucSum2NiXiU8i4BXMIhQwPqUjJ0013Azyi6t9KH3qx8lGW2ism
         t+IzwL9T9mpdqsxJs9Yaw3mwi7WlfveKOJYkGS8rAYxXotcNhBTSuMtY3+VXF3+ezcVT
         isa4kY7EZr+Tf8l1aMqKxNagz1WHT0cxak6tk2pVxzejx2zHpogbbwOaOxrSz6H2OyHJ
         36/ekFhZjouprGiDBETM+/p6calNGndbsTYAN2YglbEoFMReUwSdG8qVkPjgUv8rSsAV
         Hydg==
X-Gm-Message-State: AJIora8y6zd82XCAx5YLX24DAAkkmY6YowbOoOO9XR84wAPFJzPb6igp
        72qX44Q7hT+dgrzEMVoZsIM=
X-Google-Smtp-Source: AGRyM1tIw848TqIGMUpVV7CE6ipw6t3CMPmAb9mlv9DdQVSmKhlbaBnhY6KRtegb3K/BH3ykAUB50g==
X-Received: by 2002:adf:f345:0:b0:21d:6927:ec8f with SMTP id e5-20020adff345000000b0021d6927ec8fmr17286090wrp.490.1657997276776;
        Sat, 16 Jul 2022 11:47:56 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id u18-20020a05600c19d200b003973c54bd69sm13649961wmq.1.2022.07.16.11.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 11:47:56 -0700 (PDT)
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
Subject: [net-next PATCH v2 2/5] net: ethernet: stmicro: stmmac: first disable all queues in release
Date:   Sat, 16 Jul 2022 20:45:30 +0200
Message-Id: <20220716184533.2962-3-ansuelsmth@gmail.com>
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

Disable all queues before tx_disable in stmmac_release to prevent a
corner case where packet may be still queued at the same time tx_disable
is called resulting in kernel panic if some packet still has to be
processed.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5578abb14949..1854dcdd6095 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3758,6 +3758,11 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	stmmac_disable_all_queues(priv);
+
+	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
+		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+
 	netif_tx_disable(dev);
 
 	if (device_may_wakeup(priv->device))
@@ -3766,11 +3771,6 @@ static int stmmac_release(struct net_device *dev)
 	phylink_stop(priv->phylink);
 	phylink_disconnect_phy(priv->phylink);
 
-	stmmac_disable_all_queues(priv);
-
-	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
-
 	/* Free the IRQ lines */
 	stmmac_free_irq(dev, REQ_IRQ_ERR_ALL, 0);
 
-- 
2.36.1

