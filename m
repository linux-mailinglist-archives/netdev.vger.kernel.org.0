Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C637454BE62
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 01:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbiFNXfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 19:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357286AbiFNXf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 19:35:29 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696D14D26B;
        Tue, 14 Jun 2022 16:35:28 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v19so13762376edd.4;
        Tue, 14 Jun 2022 16:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RwCVoV8orfnRgwChCK+rAQA3GeHEe/lWNU6fYCZRqrw=;
        b=HyiUT/C87YjhHKbLwF0EpWK4PnzBxNE7YV3xYCMN6FXpXh0QlIyDfuJgfsugtwpqlX
         tQDc8/Zn/FB68kwisUD4c0VvIiYwGfK9OOgwXguq7LGkq9hFmDC/Zkth0yxXjj2arsgw
         4Eki4svotj9voOUf7t4ZSB0B9XGnLFeSe9Tr9cUOVkTxJxRyvNuBDOdFeZKXqs+MPusV
         QPF8ZUHjUAfQ7acYBcdGg8axP2nZ7grUER14ruqPHai/wJ2pHsxEs1G0PgizLHEVpeMe
         YswVuykcSw75MCZc2s5J5IKPQN+zg5NCbeIv63s/RQlhh/JJp9TzgVgtDYZ8fkAjzC3g
         0K5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RwCVoV8orfnRgwChCK+rAQA3GeHEe/lWNU6fYCZRqrw=;
        b=ntelZJOlhm39AJtOJ3MUOBL+Z2iiUb1guquYG/yVWLkT4aGqy6Uf35Vim0/0yYV6Ag
         Wc5hFAeSPoegjQRAa+eRygIPqRBcUP6LWKVoAzTk8L/XFgqrSHB7oQ7/Y+EZS7ZfUZZM
         K6aq2ZMOcayNdXACseLWuHR1Rk9tE7TrFefFKH88JSKzhP0SdREhNGKVwrSxuAsQceNR
         KYT2IcdwiIYMjiszbZnQ10XtCrX5b+hYB0bpUQFwofNDn6d6y3JnV6BburqgZJEYZguc
         mfnOeohSpvLtk7KxwmbkexfNGLcbm/nX9wSTt07I13zKMe8lhM6/VHIRZ8eBjq+WiqiI
         JEWQ==
X-Gm-Message-State: AOAM530fw1p9LoUEEmFp4441q0MKKV228dxQCVNzp6VDzeBjYA+nz2v7
        5KFkkc/8tljQjsMrO7bG4HA=
X-Google-Smtp-Source: AGRyM1s7yi8SKYgGonC6z+fB20MLO4Xt5CUZ8FDxi2I5kdemGH1a5Zybz5MQqTbnia8UfoicrJMPTA==
X-Received: by 2002:aa7:ce84:0:b0:42d:ce51:8c6e with SMTP id y4-20020aa7ce84000000b0042dce518c6emr9386188edv.10.1655249726709;
        Tue, 14 Jun 2022 16:35:26 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id l23-20020a17090612d700b006f3ef214daesm5572956ejb.20.2022.06.14.16.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 16:35:25 -0700 (PDT)
From:   Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
Subject: [net-next PATCH] net: ethernet: stmicro: stmmac: permit MTU change with interface up
Date:   Wed, 15 Jun 2022 00:41:41 +0200
Message-Id: <20220614224141.23576-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
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

Remove the limitation where the interface needs to be down to change
MTU by releasing and opening the stmmac driver to set the new MTU.
Also call the set_filter function to correctly init the port.
This permits to remove the EBUSY error while the ethernet port is
running permitting a correct MTU change if for example a DSA request
a MTU change for a switch CPU port.

Signed-off-by: Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d1a7cf4567bc..a968a13b3183 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5448,11 +5448,6 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 
 	txfifosz /= priv->plat->tx_queues_to_use;
 
-	if (netif_running(dev)) {
-		netdev_err(priv->dev, "must be stopped to change its MTU\n");
-		return -EBUSY;
-	}
-
 	if (stmmac_xdp_is_enabled(priv) && new_mtu > ETH_DATA_LEN) {
 		netdev_dbg(priv->dev, "Jumbo frames not supported for XDP\n");
 		return -EINVAL;
@@ -5466,6 +5461,14 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 
 	dev->mtu = mtu;
 
+	if (netif_running(dev)) {
+		netdev_dbg(priv->dev, "restarting interface to change its MTU\n");
+		stmmac_release(dev);
+
+		stmmac_open(dev);
+		stmmac_set_filter(priv, priv->hw, dev);
+	}
+
 	netdev_update_features(dev);
 
 	return 0;
-- 
2.36.1

