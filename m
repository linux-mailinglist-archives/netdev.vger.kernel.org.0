Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A1D5770DD
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiGPSsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiGPSsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:48:03 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCBACE24;
        Sat, 16 Jul 2022 11:48:02 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id ay11-20020a05600c1e0b00b003a3013da120so5037893wmb.5;
        Sat, 16 Jul 2022 11:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HbvtEGsMnEuUqxalVZhu5nqYG6ItmLh575xNRmd1EY8=;
        b=GPeiZoczfDK/M7OA6cgPAdDEQuy7q4oQ4/J0Jx+QD9pT2oclHHBVr8Lz1ShjwExYaF
         YWjfhslIg1G1XIe1UJLW9PzeAeBFxjz849F6WFNrnRzxOaZmOX/3xgMsO1rXu2YNpw1c
         m2oPJJPFnjC1cCZ4tJqbCAdFUgCaDippl5q5h9uKkVk/ARzxtQthiIADCrN7KwijKqVx
         ZLngAKi/21m3hyGJlfhFgRbqh55LttD+4GPrQlM/rWRo1bw9oEtGMWuxbNBB5s2fKbk3
         korWpZ54MDYm8eZHrd/jE7O/cFgfTdjczol+2/fF/p3NzpevJ/bkyVLeK3VukOqjoV8V
         X8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HbvtEGsMnEuUqxalVZhu5nqYG6ItmLh575xNRmd1EY8=;
        b=YZTcKeood24WvtNmSxWkrv8N1dYlEcnSPdCV2Sq+1Hz4PdOjArkBvO11ydWVJWz1vN
         4CJeTpV+5lkxcbNaiE7FPJ3+su42ntqWc27SvS9a+cW22L0G68Jk7jk43W8dX5Jici4L
         sYItg2cJqAiQg22ZX8ddRPgb2PM7413EAdhxGG+dLpYGDnQPr3iXX9mVwipKleojqxv1
         DpCWnNK400IisPScdCrsy6yp/Vjwzi6JnJr6V2sZGfrg+HN3ItW4vPyczU6e8UxA1v23
         9C96UX3CGZe9oHFDZN1MCVurujarT92jJT1qGgECVMQlCRZ3GA00rASxXENhqUCtF1I5
         unwg==
X-Gm-Message-State: AJIora8wltcz7NPbhyBgPLcZFCHa/X1YarxOYiE4gH0/j476uMms+vaf
        8+RI6liImnF5jy7wxrB9FaE=
X-Google-Smtp-Source: AGRyM1vp2hOuXQMemE8ele8pYLWZe5OAq75JOZbJjs6K+cujKRd6tR/8rnpOTd/sTSJ1znaSXShsVQ==
X-Received: by 2002:a05:600c:34c4:b0:3a2:e259:925b with SMTP id d4-20020a05600c34c400b003a2e259925bmr19241509wmq.99.1657997280501;
        Sat, 16 Jul 2022 11:48:00 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id u18-20020a05600c19d200b003973c54bd69sm13649961wmq.1.2022.07.16.11.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 11:48:00 -0700 (PDT)
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
Subject: [net-next PATCH v2 5/5] net: ethernet: stmicro: stmmac: permit MTU change with interface up
Date:   Sat, 16 Jul 2022 20:45:33 +0200
Message-Id: <20220716184533.2962-6-ansuelsmth@gmail.com>
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

Remove the limitation where the interface needs to be down to change
MTU by releasing and opening the stmmac driver to set the new MTU.
Also call the set_filter function to correctly init the port.
This permits to remove the EBUSY error while the ethernet port is
running permitting a correct MTU change if for example a DSA request
a MTU change for a switch CPU port.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 28 +++++++++++++++----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 53e9dbff30ae..7425941fbb40 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5551,18 +5551,15 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int txfifosz = priv->plat->tx_fifo_size;
+	struct stmmac_dma_conf *dma_conf;
 	const int mtu = new_mtu;
+	int ret;
 
 	if (txfifosz == 0)
 		txfifosz = priv->dma_cap.tx_fifo_size;
 
 	txfifosz /= priv->plat->tx_queues_to_use;
 
-	if (netif_running(dev)) {
-		netdev_err(priv->dev, "must be stopped to change its MTU\n");
-		return -EBUSY;
-	}
-
 	if (stmmac_xdp_is_enabled(priv) && new_mtu > ETH_DATA_LEN) {
 		netdev_dbg(priv->dev, "Jumbo frames not supported for XDP\n");
 		return -EINVAL;
@@ -5574,8 +5571,27 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
 		return -EINVAL;
 
-	dev->mtu = mtu;
+	if (netif_running(dev)) {
+		netdev_dbg(priv->dev, "restarting interface to change its MTU\n");
+		/* Try to allocate the new DMA conf with the new mtu */
+		dma_conf = stmmac_setup_dma_desc(priv, mtu);
+		if (IS_ERR(dma_conf)) {
+			netdev_err(priv->dev, "failed allocating new dma conf for new MTU %d\n",
+				   mtu);
+			return PTR_ERR(dma_conf);
+		}
 
+		stmmac_release(dev);
+
+		ret = __stmmac_open(dev, dma_conf);
+		kfree(dma_conf);
+		if (ret) {
+			netdev_err(priv->dev, "failed reopening the interface after MTU change\n");
+			return ret;
+		}
+	}
+
+	dev->mtu = mtu;
 	netdev_update_features(dev);
 
 	return 0;
-- 
2.36.1

