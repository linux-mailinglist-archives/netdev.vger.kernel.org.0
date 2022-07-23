Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CEC57EFB2
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiGWOaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbiGWO3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:29:55 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF9B1BEBF;
        Sat, 23 Jul 2022 07:29:52 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v67-20020a1cac46000000b003a1888b9d36so6766757wme.0;
        Sat, 23 Jul 2022 07:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rjiJgm+ePUWk4K7ivlZ0MC/qqioPkcS003xuwMGC70A=;
        b=ixXDJxh8BydzdrlUp+5pUGg9ENcZKGe2KUprYBMZl2POERKwenf+RWBmrRBU+7gIcN
         WLWnVORyug8+zftCXTTwjU3z1OijT1bJouuZZdo5g7Fb0hODAOPGAGpTxMaDBaWsxVJ9
         16SW4wUw0BASYukDBptpq07R+d/cHE1fTmUQAvANxHcpukXeTR70lz6lszlDXXtO9Iin
         woCuS7iso2EZKipkiL+zFeYXghQKpbDUGN7/bazdWzTs/f3xUL2eVmfC+MhZQf3B2bC5
         XEU6Ofz4Rublo81gGXPxVRKSeWRMrdPO29YVc7RKI3JucyaKK3NWdj7RwR6J03iX3+ZV
         EKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rjiJgm+ePUWk4K7ivlZ0MC/qqioPkcS003xuwMGC70A=;
        b=hd4duwQfvM3l3h0c0XPvcdxFHbw1ome3rCD2qAxJ2QfQOmT8tQKzXI8dIEoQMtsGb5
         qy7gNtEto6v1TehkWlQc0GTEN3flvy3N51OIt9V6WMgkS3VX378+GX7ItIaZDL204VeC
         Ph9nPbnGasvTUVT0bPzX9wT+Y5RTnO58v1eUuq81j9Kru4BKWDrZ11rFnCXT0QmAJCuh
         hY2zSSXhrXWidymlldkeKpIbwzl9eX695ZhxMFF+p8hn4gBG3llL/T+m/lUdzokIiSCP
         O6vUXKPO+SdiDottzYj+G9v8eVV05Sj+6k7VyYQkzJJAjPGK2xQPmlyh4XWT6usixYeO
         9MiQ==
X-Gm-Message-State: AJIora/MkW7z2dhsBH9CEHF6Fr8S3NgbXGe/5aPpt8HrNKGy+oHFfxhK
        QWNj/PHNGzQo29RGxDSPtXA=
X-Google-Smtp-Source: AGRyM1vVaFgb3GqjCNsvMbzlaBRd98PPg1L/7OqXzOm1rUViGRihb4msdECZSlhE1Jheg38qChktQg==
X-Received: by 2002:a05:600c:4f49:b0:3a3:2717:27fc with SMTP id m9-20020a05600c4f4900b003a3271727fcmr15822873wmq.36.1658586590737;
        Sat, 23 Jul 2022 07:29:50 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id q6-20020a1cf306000000b0039c5ab7167dsm11689717wmq.48.2022.07.23.07.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:29:50 -0700 (PDT)
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
Subject: [net-next PATCH v5 2/5] net: ethernet: stmicro: stmmac: first disable all queues and disconnect in release
Date:   Sat, 23 Jul 2022 16:29:30 +0200
Message-Id: <20220723142933.16030-3-ansuelsmth@gmail.com>
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

