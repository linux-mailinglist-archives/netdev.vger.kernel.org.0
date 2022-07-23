Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390C357EFB4
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238159AbiGWOaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbiGWOaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:30:06 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FEB1CB3A;
        Sat, 23 Jul 2022 07:30:02 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id v5so4302916wmj.0;
        Sat, 23 Jul 2022 07:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GX0e7m5ZrkPjpxkJdIBL+iV+EyM6eAVNIs5WQVoDC5I=;
        b=GuUs35D+Od53ehyBq7jSWrPuxnPg2k3rYm9X0U1icEB1hrTVCqlqQBL8TjQJp8E9Fu
         UyD0jy55G4vAFxREf4ZMZVOKBCT5oCkzuLx9FMnVNRjKfN3h6OQ2eYIzl0RItI+9XMJr
         vNZ1uImREQXKLyZO9AvoWamfOWSQhYgUSQh1ZxrlAOxZLgYdU3dpew+Cbc+4tvsBPULQ
         8MtbxGJe+v2wSYdspSqQPa8PFQYd685D1/Vwj3nmTOCHo7JlCqSmJ9qL9s2NoxmC+5G0
         5Ho7csQZ/+WVE5zDHwe1NoeSCbh2Wkn43qweWXZNJgS01xQuE7cpYZ74F6srqK4GThyi
         aWFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GX0e7m5ZrkPjpxkJdIBL+iV+EyM6eAVNIs5WQVoDC5I=;
        b=IAe/TPuHUs+JGLieZHTl+1Nu2u7W1G+1JZ96e2DH5EsG1NpEiw8NH8QBGYRA7NMNvS
         LHCJS05QNGd4vATbQvcPPieTM2+82sk2+K5qqL/+ed1sYhV7aLklsEjjtMRAsVvM++Vj
         uCd93lNPuoIBCtWepSzNI5RT5PU8DANkect6aCRTYq27wGKtaQ2RhkVPnaGeDapVMj/i
         qP9TtPPAi3mZhL5Jxfmqx32JzOr1cBc881TsTFHWgHe/5qrCfvXekli6JZw7KexQnzLx
         lh4W8Cbv8oB+JKnVUaHueiL/4Ttvv1sYQ12iC15XBkgQoeNaMKdOAzWO70Ou4Z4NZRNo
         v1gQ==
X-Gm-Message-State: AJIora8gn5BsautO1vJG3+Yb05dXAZm/YEb/YDVIsBNC6rFp8FjJMvKD
        YkogtgJ98pFcNvksIldeupWZzcQYX1U=
X-Google-Smtp-Source: AGRyM1vyEESD+gOYudb18RYonLwuCA9ecgk+Boyi9uzgAedUAyeJVXmG9G/HRzwQjgJRpYQqd/XNAQ==
X-Received: by 2002:a05:600c:3ba3:b0:3a3:5dd:f10f with SMTP id n35-20020a05600c3ba300b003a305ddf10fmr3105539wms.185.1658586601145;
        Sat, 23 Jul 2022 07:30:01 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id q6-20020a1cf306000000b0039c5ab7167dsm11689717wmq.48.2022.07.23.07.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:30:00 -0700 (PDT)
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
Subject: [net-next PATCH v5 5/5] net: ethernet: stmicro: stmmac: permit MTU change with interface up
Date:   Sat, 23 Jul 2022 16:29:33 +0200
Message-Id: <20220723142933.16030-6-ansuelsmth@gmail.com>
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

Remove the limitation where the interface needs to be down to change
MTU by releasing and opening the stmmac driver to set the new MTU.
Also call the set_filter function to correctly init the port.
This permits to remove the EBUSY error while the ethernet port is
running permitting a correct MTU change if for example a DSA request
a MTU change for a switch CPU port.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 30 +++++++++++++++----
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9a927ce17941..083d08b5ab0e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5552,18 +5552,15 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
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
@@ -5575,8 +5572,29 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
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
+
+		stmmac_set_rx_mode(dev);
+	}
+
+	dev->mtu = mtu;
 	netdev_update_features(dev);
 
 	return 0;
-- 
2.36.1

