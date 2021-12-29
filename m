Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534C64817C6
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 00:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhL2Xjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 18:39:55 -0500
Received: from mx3.wp.pl ([212.77.101.10]:12671 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhL2Xjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 18:39:55 -0500
Received: (wp-smtpd smtp.wp.pl 30252 invoked from network); 30 Dec 2021 00:39:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1640821193; bh=3TKmTssEFcXQLi2NfFNyqUS1vQ8T+LNOuugB7ZaG+lQ=;
          h=From:To:Subject;
          b=e9qXKEysuJkX4xccV5tai0nBcSb+/zf8ia9NMueklQheKKrh2GPs7iDmseBRhJIBb
           SDlA7SjDGy6oqkGZOnh/Go2AzCKvFVZmcZsKg7Kw6pMoae985abuU8XmX+jG5QNO2y
           ahWOxyoEQpq7ozINRsVFL82Tjspaj8pBMo9iSHB0=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <davem@davemloft.net>; 30 Dec 2021 00:39:53 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     davem@davemloft.net, kuba@kernel.org, olek2@wp.pl, jgg@ziepe.ca,
        rdunlap@infradead.org, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: lantiq_etop: make alignment match open parenthesis
Date:   Thu, 30 Dec 2021 00:39:52 +0100
Message-Id: <20211229233952.5306-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 527b53d1255902ae8a56fe2c810ebea6
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [AUPU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch.pl complains as the following:

Alignment should match open parenthesis

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c | 34 +++++++++++++++---------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 072391c494ce..f0fbce3eb45b 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -111,9 +111,9 @@ ltq_etop_alloc_skb(struct ltq_etop_chan *ch)
 	ch->skb[ch->dma.desc] = netdev_alloc_skb(ch->netdev, MAX_DMA_DATA_LEN);
 	if (!ch->skb[ch->dma.desc])
 		return -ENOMEM;
-	ch->dma.desc_base[ch->dma.desc].addr = dma_map_single(&priv->pdev->dev,
-		ch->skb[ch->dma.desc]->data, MAX_DMA_DATA_LEN,
-		DMA_FROM_DEVICE);
+	ch->dma.desc_base[ch->dma.desc].addr =
+		dma_map_single(&priv->pdev->dev, ch->skb[ch->dma.desc]->data,
+			       MAX_DMA_DATA_LEN, DMA_FROM_DEVICE);
 	ch->dma.desc_base[ch->dma.desc].addr =
 		CPHYSADDR(ch->skb[ch->dma.desc]->data);
 	ch->dma.desc_base[ch->dma.desc].ctl =
@@ -135,7 +135,7 @@ ltq_etop_hw_receive(struct ltq_etop_chan *ch)
 	spin_lock_irqsave(&priv->lock, flags);
 	if (ltq_etop_alloc_skb(ch)) {
 		netdev_err(ch->netdev,
-			"failed to allocate new rx buffer, stopping DMA\n");
+			   "failed to allocate new rx buffer, stopping DMA\n");
 		ltq_dma_close(&ch->dma);
 	}
 	ch->dma.desc++;
@@ -185,7 +185,7 @@ ltq_etop_poll_tx(struct napi_struct *napi, int budget)
 		dev_kfree_skb_any(ch->skb[ch->tx_free]);
 		ch->skb[ch->tx_free] = NULL;
 		memset(&ch->dma.desc_base[ch->tx_free], 0,
-			sizeof(struct ltq_dma_desc));
+		       sizeof(struct ltq_dma_desc));
 		ch->tx_free++;
 		ch->tx_free %= LTQ_DESC_NUM;
 	}
@@ -246,18 +246,18 @@ ltq_etop_hw_init(struct net_device *dev)
 
 	switch (priv->pldata->mii_mode) {
 	case PHY_INTERFACE_MODE_RMII:
-		ltq_etop_w32_mask(ETOP_MII_MASK,
-			ETOP_MII_REVERSE, LTQ_ETOP_CFG);
+		ltq_etop_w32_mask(ETOP_MII_MASK, ETOP_MII_REVERSE,
+				  LTQ_ETOP_CFG);
 		break;
 
 	case PHY_INTERFACE_MODE_MII:
-		ltq_etop_w32_mask(ETOP_MII_MASK,
-			ETOP_MII_NORMAL, LTQ_ETOP_CFG);
+		ltq_etop_w32_mask(ETOP_MII_MASK, ETOP_MII_NORMAL,
+				  LTQ_ETOP_CFG);
 		break;
 
 	default:
 		netdev_err(dev, "unknown mii mode %d\n",
-			priv->pldata->mii_mode);
+			   priv->pldata->mii_mode);
 		return -ENOTSUPP;
 	}
 
@@ -399,7 +399,7 @@ ltq_etop_mdio_init(struct net_device *dev)
 	priv->mii_bus->write = ltq_etop_mdio_wr;
 	priv->mii_bus->name = "ltq_mii";
 	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
-		priv->pdev->name, priv->pdev->id);
+		 priv->pdev->name, priv->pdev->id);
 	if (mdiobus_register(priv->mii_bus)) {
 		err = -ENXIO;
 		goto err_out_free_mdiobus;
@@ -539,7 +539,7 @@ ltq_etop_set_mac_address(struct net_device *dev, void *p)
 		spin_lock_irqsave(&priv->lock, flags);
 		ltq_etop_w32(*((u32 *)dev->dev_addr), LTQ_ETOP_MAC_DA0);
 		ltq_etop_w32(*((u16 *)&dev->dev_addr[4]) << 16,
-			LTQ_ETOP_MAC_DA1);
+			     LTQ_ETOP_MAC_DA1);
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 	return ret;
@@ -652,15 +652,15 @@ ltq_etop_probe(struct platform_device *pdev)
 	}
 
 	res = devm_request_mem_region(&pdev->dev, res->start,
-		resource_size(res), dev_name(&pdev->dev));
+				      resource_size(res), dev_name(&pdev->dev));
 	if (!res) {
 		dev_err(&pdev->dev, "failed to request etop resource\n");
 		err = -EBUSY;
 		goto err_out;
 	}
 
-	ltq_etop_membase = devm_ioremap(&pdev->dev,
-		res->start, resource_size(res));
+	ltq_etop_membase = devm_ioremap(&pdev->dev, res->start,
+					resource_size(res));
 	if (!ltq_etop_membase) {
 		dev_err(&pdev->dev, "failed to remap etop engine %d\n",
 			pdev->id);
@@ -699,10 +699,10 @@ ltq_etop_probe(struct platform_device *pdev)
 	for (i = 0; i < MAX_DMA_CHAN; i++) {
 		if (IS_TX(i))
 			netif_napi_add(dev, &priv->ch[i].napi,
-				ltq_etop_poll_tx, 8);
+				       ltq_etop_poll_tx, 8);
 		else if (IS_RX(i))
 			netif_napi_add(dev, &priv->ch[i].napi,
-				ltq_etop_poll_rx, 32);
+				       ltq_etop_poll_rx, 32);
 		priv->ch[i].netdev = dev;
 	}
 
-- 
2.30.2

