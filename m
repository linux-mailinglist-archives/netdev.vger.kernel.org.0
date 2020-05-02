Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037951C245D
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 11:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgEBJ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 05:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgEBJ3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 05:29:14 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AD1C061A0C;
        Sat,  2 May 2020 02:29:12 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b24so5648775lfp.7;
        Sat, 02 May 2020 02:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=aPHQopP3uegPMTxg+Aep4CZznGAz3JZTwpCPsbRISYs=;
        b=gM6Q6PvUrEvO82aPMtbJuHrfNzsTg09BxUWKI/JiPu6G0zBVAHvTJTSz0whunNhKQ8
         abcPxt6jNnlhY9197MMff0ZDDyDdadnQpmWWw6tGgbaGzy8H2sCJ1rCGPmlBUawpDyTz
         LRfBAwkUPlC+izp1B64NlrkZkPvD6ztv+X1XMMisFeqHdFA7xOWYNQu6hdVdd9M8gKcj
         9lYolSnjXITaC8c7hdlD8s+5hPw/5YLK6UuAnC8HbTovyBLje5+F9GztKjH9kKM80HAE
         bMmkYARu5/f2n9ZqFmBl02PSmyoeYdA/buCKfh8gerYKRrfHzhmkwos4ebyP2Zypb0Kh
         +jPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=aPHQopP3uegPMTxg+Aep4CZznGAz3JZTwpCPsbRISYs=;
        b=Tw1c9prbCTHEWiW7/PJhrZ8Ai83Gy7wJLleddgrf2J597WFyRSlbMKXVgW5bh947WW
         gRhtEpilAZO56LPevw2iN7CWeAn7Oc4BtcKERL1USB0PLf0H2Fp+K1uYxvsstISDh3aG
         RQTrNMJwDPrTcP4u76jFQ3Tf5E8zDmdRQFj1FT6Y5pLMUiP2fCHT+BJKYM8m0uMgIYyD
         uzkJSzTdMMJiReWQfwMBat745dd/AO6Q6iY+R7cAMdiJ7kVZrBbup3+EKDTwJOEmdkKd
         4EmpgkYJ4vP2aXJQ0Vb9cpBhZ0tZgr/LxIoPVCYw1qMZWVbwTPKyV6DmlxHPkffX+Fcb
         e5nA==
X-Gm-Message-State: AGi0Pub8FOmaXf7sKIaJGkWlkqH42+Y07z41+BMMG1vT87WHPkj4xJ5Y
        ZWSouSU7TZBzRij5vmMKWutHmr9kZLbrDw==
X-Google-Smtp-Source: APiQypL+rhFpvo0J8V5u9+Cqdvz0B4kvC0FdO359+CLV3LOLLGTbItJ1GIKLE2DurgiTERn0y3ng6g==
X-Received: by 2002:ac2:5482:: with SMTP id t2mr4204303lfk.202.1588411750792;
        Sat, 02 May 2020 02:29:10 -0700 (PDT)
Received: from maxim-hplinux ([89.179.187.17])
        by smtp.gmail.com with ESMTPSA id f26sm3988555lfc.84.2020.05.02.02.29.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 May 2020 02:29:10 -0700 (PDT)
Date:   Sat, 2 May 2020 12:29:08 +0300
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     mmrmaximuzz@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] stmmac: fix pointer check after utilization in
 stmmac_interrupt
Message-ID: <20200502092906.GA9883@maxim-hplinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The paranoidal pointer check in IRQ handler looks very strange - it
really protects us only against bogus drivers which request IRQ line
with null pointer dev_id. However, the code fragment is incorrect
because the dev pointer is used before the actual check. That leads
to undefined behavior thus compilers are free to remove the pointer
check at all.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 565da6498c84..ca08699f5565 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4070,24 +4070,28 @@ static int stmmac_set_features(struct net_device *netdev,
  */
 static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 {
-	struct net_device *dev = (struct net_device *)dev_id;
-	struct stmmac_priv *priv = netdev_priv(dev);
-	u32 rx_cnt = priv->plat->rx_queues_to_use;
-	u32 tx_cnt = priv->plat->tx_queues_to_use;
+	u32 rx_cnt;
+	u32 tx_cnt;
 	u32 queues_count;
 	u32 queue;
 	bool xmac;
+	struct stmmac_priv *priv;
+	struct net_device *dev = (struct net_device *)dev_id;
 
+	if (unlikely(!dev)) {
+		netdev_err(NULL, "%s: invalid dev pointer\n", __func__);
+		return IRQ_NONE;
+	}
+
+	priv = netdev_priv(dev);
+	rx_cnt = priv->plat->rx_queues_to_use;
+	tx_cnt = priv->plat->tx_queues_to_use;
 	xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
 	queues_count = (rx_cnt > tx_cnt) ? rx_cnt : tx_cnt;
 
 	if (priv->irq_wake)
 		pm_wakeup_event(priv->device, 0);
 
-	if (unlikely(!dev)) {
-		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
-		return IRQ_NONE;
-	}
 
 	/* Check if adapter is up */
 	if (test_bit(STMMAC_DOWN, &priv->state))

base-commit: 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c
-- 
2.17.1

