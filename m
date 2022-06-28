Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CCB55DEC9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242921AbiF1BeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243084AbiF1BeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:34:15 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7B2167FE;
        Mon, 27 Jun 2022 18:34:13 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u15so22627043ejc.10;
        Mon, 27 Jun 2022 18:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VFjFynZy6Y6LV26469hAz6HcHpk+ATW9nFKisizAaS0=;
        b=HxBQCz+7pRrd8vYnRhzxjsYUhYVbh2740UtczLVj5Qadg66MxqD6v7B1UGENMsXSIh
         NZ95KoNdnEnToocmddB8hVQm3umvd7EQ4umzgQcF+7ZKMGvwj21qIm4vl50UEADmBO8W
         z/n9v0ZYxB6fIIjOLkTK7wQB9KorIFItL/CT/BUqj8or+kBD0Nu6JTxuVmz9x5N9Wrd3
         Xvxps116OsXXejOkFAw3yct++Gvjy8/h29Uqxo0JpQx+hftir5R5vHETuPWv2Xepgycf
         2xEUyuNHXxB0rkSuRMiahmG8E7kIlZRTSqiNp3yYJc/aCPu7xpb21I6Fji6+dgEIKsTG
         NsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VFjFynZy6Y6LV26469hAz6HcHpk+ATW9nFKisizAaS0=;
        b=5957CKDIrDK6S8hTTLXiShFC/CPZ8WHNtSQe2qCwe1rGqoidceaqx55vieB6HAj6Ny
         xaDb2fUfzCnjFSdysgQIfFrYhdRCoYU4rofPePmSG6PgmsAD4UXyoNILaIOWNZyKQ2J3
         vRIuspMKEarqyut7jUSGeewC9fGIQow0zIhYx4+rtrnCjN2acfWW2M3yZKwzgcGWusTe
         fca30qjhMyedIpk9S2lvoiaU517gstpcOuHRjkn8GPWbGbzSoebgV7FCy2sIwkTwTbHl
         Qe4piQfgtHKkcPBNaVM87hTE7FEu5VqlznTeIKS6k+9KraxaFzIWLkcGuE/nzNPeL75x
         W1gg==
X-Gm-Message-State: AJIora8acucbtTtUsGRyraGa3mF9s6XlXfyUIYOOuBaizDLhQVWuklaX
        C9jBbRd6IJz4og4bsHiWx9y/Dpoi8uI=
X-Google-Smtp-Source: AGRyM1uPYb3BGEYytx9I9d6gFT5JgkCfrvivXpMHCUnwEbmD4KdUhvJMfNpU409V+fTN58hTaPKq2A==
X-Received: by 2002:a17:907:7251:b0:723:dc32:aefb with SMTP id ds17-20020a170907725100b00723dc32aefbmr15069172ejc.91.1656380051539;
        Mon, 27 Jun 2022 18:34:11 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id x13-20020a170906b08d00b00724261b592esm5693492ejy.186.2022.06.27.18.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 18:34:11 -0700 (PDT)
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
Subject: [net-next PATCH RFC 5/5] net: ethernet: stmicro: stmmac: permit MTU change with interface up
Date:   Tue, 28 Jun 2022 03:33:42 +0200
Message-Id: <20220628013342.13581-6-ansuelsmth@gmail.com>
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
index 330aac10a6e7..2e08be895cde 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5549,18 +5549,15 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
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
@@ -5572,8 +5569,27 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
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

