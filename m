Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976E45F5429
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 14:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJEMFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 08:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiJEMFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 08:05:12 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0722870C
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 05:05:11 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id bg9-20020a05600c3c8900b003bf249616b0so711763wmb.3
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 05:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Azv6wQXNpWBikFZ7YedVEP87aeuLGrZzJ94JVNBlROE=;
        b=f90XW/FBL9NtLBkODgOXxXHX4h9e4N/xXi1axs9BvYKOZhD/z6FKv0bAAl6gnA/jW5
         v5iQoxypoqOwNC9M6UIvrxKOhLOdYI/a51iuFvK6Z0F0ilyTtjlHduHjFhnV5fKz03gk
         d1TPTZfc56xoioo1jRYZN1Acd3/toSPreMfURAzVaqk/GroerPdop4zSDPVdbfploZFw
         hT2MZktT7EWYkjpqaZhaJqZ46Zy49aDPctTyK2CAwUeLvn10aaoOYYws2ZIMWQA/mbev
         4nROOv0yUvjPe90el/OfGjniLFG9PZdMf8Cl62cqUNFNZG/zLXC8xmMxG/twuZ7t2wXk
         MHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Azv6wQXNpWBikFZ7YedVEP87aeuLGrZzJ94JVNBlROE=;
        b=tBrqVAZz2ID07xUlM3ytrl93tTQ9QUYrL5hh7X/+AffmK2rH/+qpVEDpCLtTy6wPgk
         yYoh0SiwAOjIvplcaWcIimWsZqhzRZEBWq5GToeXMuEyk0tqasRqYFnnF4xvtnhvR3gR
         UKu9zyqMZO2WERd+zBKhBoBznFvrMh+KKhTZ14bSPQApiG6TK+TBc1WL+A1KhMDN8KpZ
         oy6IAJ6+0NqHeEPcxvzn0N5OV7/4iUIxJd8XJGowrJuJ4HA6FA2voPy9+m7rxJjDFu1d
         EYsLrjh97nr8ov2kV4F03AqwDUh/2Q3h6kK/GNq0IQZnUUOXXsn+Wz9pexk7lZ4TteO6
         fzcg==
X-Gm-Message-State: ACrzQf1Kaj6RJHlqm2lqzuJmAntjIA2VKKQkC9EwQq/PMISi4qwvGxYr
        CdGr0/g2E48jF8fhhd4Te0c/Ug==
X-Google-Smtp-Source: AMsMyM4s7dO6DMyD3zAQ4zh4Dxzr3zHUcwFyK/2oKhuJWIrnJOJH/wvIkKi/wYe4u1xxGdDO0fhyBg==
X-Received: by 2002:a7b:c4c2:0:b0:3b4:fdc4:6df9 with SMTP id g2-20020a7bc4c2000000b003b4fdc46df9mr3012311wmk.123.1664971509676;
        Wed, 05 Oct 2022 05:05:09 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v16-20020a5d6790000000b0022e3e7813f0sm7799583wru.107.2022.10.05.05.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 05:05:09 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, edumazet@google.com, khalasa@piap.pl,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 3/4] net: ethernet: xscale: remove assignment in if condition
Date:   Wed,  5 Oct 2022 12:05:00 +0000
Message-Id: <20221005120501.3527435-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221005120501.3527435-1-clabbe@baylibre.com>
References: <20221005120501.3527435-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpatch error about "do not use assignment in if condition";

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 36 ++++++++++++++++--------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index b4539dd2cfe4..11e5c00f638d 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -540,7 +540,8 @@ static int ixp4xx_mdio_register(struct eth_regs __iomem *regs)
 {
 	int err;
 
-	if (!(mdio_bus = mdiobus_alloc()))
+	mdio_bus = mdiobus_alloc();
+	if (!mdio_bus)
 		return -ENOMEM;
 
 	mdio_regs = regs;
@@ -631,7 +632,8 @@ static inline int queue_get_desc(unsigned int queue, struct port *port,
 	u32 phys, tab_phys, n_desc;
 	struct desc *tab;
 
-	if (!(phys = qmgr_get_entry(queue)))
+	phys = qmgr_get_entry(queue);
+	if (!phys)
 		return -1;
 
 	phys &= ~0x1F; /* mask out non-address bits */
@@ -698,7 +700,8 @@ static int eth_poll(struct napi_struct *napi, int budget)
 		u32 phys;
 #endif
 
-		if ((n = queue_get_desc(rxq, port, 0)) < 0) {
+		n = queue_get_desc(rxq, port, 0);
+		if (n < 0) {
 #if DEBUG_RX
 			netdev_dbg(dev, "%s napi_complete\n", __func__);
 #endif
@@ -722,7 +725,8 @@ static int eth_poll(struct napi_struct *napi, int budget)
 		desc = rx_desc_ptr(port, n);
 
 #ifdef __ARMEB__
-		if ((skb = netdev_alloc_skb(dev, RX_BUFF_SIZE))) {
+		skb = netdev_alloc_skb(dev, RX_BUFF_SIZE);
+		if (skb) {
 			phys = dma_map_single(&dev->dev, skb->data,
 					      RX_BUFF_SIZE, DMA_FROM_DEVICE);
 			if (dma_mapping_error(&dev->dev, phys)) {
@@ -860,7 +864,8 @@ static netdev_tx_t eth_xmit(struct sk_buff *skb, struct net_device *dev)
 #else
 	offset = (uintptr_t)skb->data & 3; /* keep 32-bit alignment */
 	bytes = ALIGN(offset + len, 4);
-	if (!(mem = kmalloc(bytes, GFP_ATOMIC))) {
+	mem = kmalloc(bytes, GFP_ATOMIC); {
+	if (!mem) {
 		dev_kfree_skb(skb);
 		dev->stats.tx_dropped++;
 		return NETDEV_TX_OK;
@@ -1113,11 +1118,13 @@ static int init_queues(struct port *port)
 		buffer_t *buff; /* skb or kmalloc()ated memory */
 		void *data;
 #ifdef __ARMEB__
-		if (!(buff = netdev_alloc_skb(port->netdev, RX_BUFF_SIZE)))
+		buff = netdev_alloc_skb(port->netdev, RX_BUFF_SIZE);
+		if (!buff)
 			return -ENOMEM;
 		data = buff->data;
 #else
-		if (!(buff = kmalloc(RX_BUFF_SIZE, GFP_KERNEL)))
+		buff = kmalloc(RX_BUFF_SIZE, GFP_KERNEL);
+		if (!buff)
 			return -ENOMEM;
 		data = buff;
 #endif
@@ -1220,10 +1227,12 @@ static int eth_open(struct net_device *dev)
 	if (npe_send_recv_message(port->npe, &msg, "ETH_SET_FIREWALL_MODE"))
 		return -EIO;
 
-	if ((err = request_queues(port)) != 0)
+	err = request_queues(port);
+	if (err != 0)
 		return err;
 
-	if ((err = init_queues(port)) != 0) {
+	err = init_queues(port);
+	if (err != 0) {
 		destroy_queues(port);
 		release_queues(port);
 		return err;
@@ -1442,7 +1451,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	if (!plat)
 		return -ENODEV;
 
-	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
+	ndev = devm_alloc_etherdev(dev, sizeof(struct port));
+	if (!ndev)
 		return -ENOMEM;
 
 	SET_NETDEV_DEV(ndev, dev);
@@ -1479,7 +1489,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	netif_napi_add_weight(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
-	if (!(port->npe = npe_request(NPE_ID(port->id))))
+	port->npe = npe_request(NPE_ID(port->id));
+	if (!port->npe)
 		return -EIO;
 
 	port->plat = plat;
@@ -1506,7 +1517,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	phydev->irq = PHY_POLL;
 
-	if ((err = register_netdev(ndev)))
+	err = register_netdev(ndev);
+	if (err)
 		goto err_phy_dis;
 
 	netdev_info(ndev, "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
-- 
2.35.1

