Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEBF579010
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiGSBti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbiGSBti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:49:38 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D3439BA6;
        Mon, 18 Jul 2022 18:49:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r14so19557578wrg.1;
        Mon, 18 Jul 2022 18:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LlfQtelztTsNiTqcVZLiFHCSHDMpr2L71yJcP2UP5Tc=;
        b=ix6JP89EESpFq6vPoyv42Rmw9s1JazmPo2Qt0NnDqNPha4M0FF3HuJ37klC7aI6SLh
         mX/tXnXMA44du9BgEn20TGrV69Re3MCo5lc05ok4xi8mFQPPnpsSbsWF3/aQzkHzBiya
         yw+NdH5j9rB9ph/HTzcuBs3+1qoFGhh4NQQT0mdOmTFSJ0ZvAKcxWoaOsdSCXFvjSV5w
         X/4FUy5YOSiMtP8EDtavKmvLCwhVxX1MZwleusEjpHjn5qTM6gVzBCLrftuWZt2bUL93
         uxih86BRt9YPQ1KPGkO/Dt+OVZ9+wJ17irhzXjCfQ/qbOgtZr1lPV1Qh6jqcy2RrhBNY
         adtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LlfQtelztTsNiTqcVZLiFHCSHDMpr2L71yJcP2UP5Tc=;
        b=cVPIktuD39XJTFADus8PsprNX6NGqYRJ7Y2hzsFbomgVFJEQhi7vJzhgfjQa7/WrYS
         oD1ktAugd1DlPeTa1zSRZTWd2zIUX+dIEDHrYQypdtiCWPSvmQcO9hcYSjzqMl2pppvP
         LPLRfsUXOvenS/E08L7l88DFePxN5v1BeL19+biMbVds5Ra7TO3Uf8vG7XMCWK55Pa9q
         aLBhbViPw9av4guaRn9ykIMSsmO/4G3CluZ1XnSBKDReh40iY+F4Ngjz5gs52iaxYrA7
         E7ElS+Ct2UBS24RWuZfkYizPcO1j85SWs787AQbaLUmNXvTaTF0sQRhWOnqWhNMWXh7k
         12ng==
X-Gm-Message-State: AJIora+ER3vK9+7pZf/mU7Gmc+tfFlmD+wbr78obU9s0huaI8qiHMs8a
        JtobOMk6H9Uj+ijTn5y5PRs=
X-Google-Smtp-Source: AGRyM1sotsOcKG/9pLDZZ7aw8EvbuQ4EGef5Wv/ScQtYnvD7MPxwSRbvCBr70W1/CiFdJdc05vp9sQ==
X-Received: by 2002:a5d:4a8f:0:b0:21e:28a8:f44d with SMTP id o15-20020a5d4a8f000000b0021e28a8f44dmr3046841wrq.663.1658195375865;
        Mon, 18 Jul 2022 18:49:35 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v10-20020a05600c428a00b003a2fc754313sm16193600wmc.10.2022.07.18.18.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:49:35 -0700 (PDT)
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
Subject: [net-next PATCH v4 5/5] net: ethernet: stmicro: stmmac: permit MTU change with interface up
Date:   Tue, 19 Jul 2022 03:32:19 +0200
Message-Id: <20220719013219.11843-6-ansuelsmth@gmail.com>
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
index a3bb132db3a5..1eda1e1038b4 100644
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
@@ -5574,8 +5571,29 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
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

