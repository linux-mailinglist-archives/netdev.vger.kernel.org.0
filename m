Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D7D55C9E0
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243085AbiF1BeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243072AbiF1BeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:34:11 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE33167FE;
        Mon, 27 Jun 2022 18:34:09 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eq6so15429242edb.6;
        Mon, 27 Jun 2022 18:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iXMh8QpPv/1aXKHGIBmnrm9Vg4DXhE4ZP8Hc+hLQFGQ=;
        b=iSLPEcMimUmFNWA7S9EVs9feLPDJLUCwZ1xnX5Dcv0912ADR3eLqtn2mTAJQRCUhph
         +46PzVI+CD25zqDIk+OFmZ+PKs91pgaN0eh6W5ATIJARMUnCBhfXq7+l+SftyJG0hyj5
         iTVsnb7boNeWXirGktLqd/702oIVnobEs+rei18XCwz8nzWh8py8kKGavZOVIsUhiehV
         eKT3X/p0F6XWJypvR1kqw5DOMdk13/EBnLmwE68eB86+7yW5obwVeRFj0JIFvAf5ElJR
         z5+AKA4watCMXSjQRHNfj9w41uQhaFqdfvRq4+YMjsPtwcus3EmHM2W/KLVYyHf0zzuP
         zBTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iXMh8QpPv/1aXKHGIBmnrm9Vg4DXhE4ZP8Hc+hLQFGQ=;
        b=0faWdTEcnENYnPNc4Ig27yhUwXtkj2AFl0gCyb8LZoxrgMMlTkd8NXy70rAkI63pFy
         cf/BmMC+GCma3XWFhxQVu+PZ54lZKnx1GHyQGRUcEGGClKcziYAWH/wCYHeGj3rA6ipA
         32Y0pgFuMlnBKHwXZDCfrE76DHr8kcGX+umQXV3uQQEPj2s0xsBorfc0GRw3A4S77l2P
         X/OTlKviqQ/akiuUDnd25RuyeYI4ZTyKpKALPwpNSnfWYd76fPxVCfzMkwEjG80WL9+j
         fh2cVIqowjzOEDOjEfhcPIZNIZsc4Qeo+A8eu3q/LKuWPoD6pSv5g13Fh014D8d4EQNI
         iFNQ==
X-Gm-Message-State: AJIora+prbT6dMlA05fNW9IpqaxlA4DxmnO5QV64PL89QQbA57fPYniI
        nYAYmZv/gwG6L+UoBnjEkNQ=
X-Google-Smtp-Source: AGRyM1vrS+YccdrvNawuCtViR0sTpIxGP/KIv7SC+cYNjQupzDKy6zZAQKeNq1r36/eUZZ2HEe+pqw==
X-Received: by 2002:a05:6402:2047:b0:435:67e0:44fe with SMTP id bc7-20020a056402204700b0043567e044femr19876442edb.360.1656380047685;
        Mon, 27 Jun 2022 18:34:07 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id x13-20020a170906b08d00b00724261b592esm5693492ejy.186.2022.06.27.18.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 18:34:07 -0700 (PDT)
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
Subject: [net-next PATCH RFC 2/5] net: ethernet: stmicro: stmmac: first disable all queues in release
Date:   Tue, 28 Jun 2022 03:33:39 +0200
Message-Id: <20220628013342.13581-3-ansuelsmth@gmail.com>
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

Disable all queues before tx_disable in stmmac_release to prevent a
corner case where packet may be still queued at the same time tx_disable
is called resulting in kernel panic if some packet still has to be
processed.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f861246de2e5..f4ba27c1c7e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3756,6 +3756,11 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	stmmac_disable_all_queues(priv);
+
+	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
+		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+
 	netif_tx_disable(dev);
 
 	if (device_may_wakeup(priv->device))
@@ -3764,11 +3769,6 @@ static int stmmac_release(struct net_device *dev)
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

