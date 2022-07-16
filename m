Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2854757722F
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 01:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiGPXI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 19:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbiGPXIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 19:08:18 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2882720195;
        Sat, 16 Jul 2022 16:08:16 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j1so7376702wrs.4;
        Sat, 16 Jul 2022 16:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HbvtEGsMnEuUqxalVZhu5nqYG6ItmLh575xNRmd1EY8=;
        b=cEphPFT8NMAhz2OTlbsbTFKS7ThG5Zx3zSRzc3b/JDptIOxxNpJH8Tezp89SGRMQVt
         9meyrRM5jS/nGsmw/1efAc7PRJjkekzvEUz5wZdfbDJyPECoN2+AEXcvHUpdViNaIFuS
         qgatX0Ak3wDZoVz12pAOMZgnNBFthZct0MRiYsQe9b6u+MkyEs7WLnUkrBugk16wWUAe
         bQnOL14h+kVZrLREBzv7CvRd68C1SFvp4mxdKKK6QygLkk2lho2p5F1aRH8C3Io+TLJv
         kD0I8aofEsNzlmbqKmd4pWf3S+Un4bo15dxDjMa4VTDluFcTYfztgKu8Yg5L4RXc1MaZ
         PqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HbvtEGsMnEuUqxalVZhu5nqYG6ItmLh575xNRmd1EY8=;
        b=NEPK/dAvjXsORyAtIltYsvEw7TQ8Yi7oKLM24OUNRDTCYSbnYUdO4a96+I6qlrIWOK
         gVOZJNVmA59KVsav5nWM/8yXhdSnpln+oCmoFVC/dQzvrmFoIuqT39rmgjtZY7u7XpF+
         sCvB0/td8xS7cedqaER40j9wujZgbj9TpozESkloU6przR6dZTwPhQqZ8BivH1ZjdXDP
         JDIZJLo+MJw4hF4WiFXHA3BdjjXLZcQlO4g3rpdUgIC3bJVFcRsmMmrmtHqUyrdL7fMZ
         v2WQJxjJ0PcHRb9S0Xll7xTfsVYPfjakmvthuZavauSnHd+EhcobvxfiFEVEKtk2yruW
         p/6g==
X-Gm-Message-State: AJIora9UejjPiNntSi/wR1x4VWh7eEVDKziKJTbOyQxfZ5iGD9v+YfRv
        dwGsn1rxVzMahiSfqYEKZ6w=
X-Google-Smtp-Source: AGRyM1vHXqLPb9/lz3m4XQ3KLxcwl5y1+db4LaiQameOv6ZFahwWeMM4pBVUL/MZglS3L4yfhZEntw==
X-Received: by 2002:a05:6000:1f96:b0:21d:8516:9ec9 with SMTP id bw22-20020a0560001f9600b0021d85169ec9mr19150822wrb.359.1658012894474;
        Sat, 16 Jul 2022 16:08:14 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id l13-20020a05600c2ccd00b003a2f2bb72d5sm15150755wmc.45.2022.07.16.16.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 16:08:14 -0700 (PDT)
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
Subject: [net-next PATCH v3 5/5] net: ethernet: stmicro: stmmac: permit MTU change with interface up
Date:   Sun, 17 Jul 2022 01:08:02 +0200
Message-Id: <20220716230802.20788-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220716230802.20788-1-ansuelsmth@gmail.com>
References: <20220716230802.20788-1-ansuelsmth@gmail.com>
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

