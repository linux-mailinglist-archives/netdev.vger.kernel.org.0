Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05B5DE165
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfJUAKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:30 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34573 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:29 -0400
Received: by mail-lf1-f67.google.com with SMTP id f5so850459lfp.1
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37DVlI7CMW6o++Ct+3WzRl3YFsvzn5oKwtoZ1rtvgU0=;
        b=Mpu1XSuaKgG9v5Z1dHNnDg8YsH3kOi6WahFWov+vQM6VE37kqPnBOThHvnlTXK13B6
         q2GaZAcb+7bQDu32nPuopkGD514yfxxusbY8D+pPXmmD3ECdTiU8OGPLYMHVx73/j7+A
         jvVqmwsl4gepDkvAxY0f3BHBWEJ6zAb5K0DFrxfZ33OH7OKEieJcP8lJkA0ERJY0q7lD
         s75gNZx06VdIEQID0lVYhxkCRs3TFdH0+ZXwxMgaiv9oUkkOCdBrJDjtWCtA4OMyuSlc
         GzeLRemVnAtxSh7pUr1o+u2UqxCQ5h+a47EGeATkVxZLkA5VbkkrxZ+D+IZ7+y3O03eB
         kcXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37DVlI7CMW6o++Ct+3WzRl3YFsvzn5oKwtoZ1rtvgU0=;
        b=r3nsppCamO8V5zo8Jwr9nTMk2Ll5qJ4WFNB1kKrBfUFWHcnK1quQamqOv0QLqdJ6ud
         u43eQm/XiTnUY8vnDV1JBBnk6UnvPMVUG/t4QAzwSy1eotiUM4S5wj2e2cRYPBPBt82E
         1sDs7v7Z0UjCDBqsbLckqeoyK2oKS+s+UnOdEv6C7HuWVLtaFm3tVRb77SUaih3fktVQ
         vPjk2khX77qVrlermySkG0AzlYlz6xld3GIFcvkSx0L7fD5qBtBJLbbgx7K2I8qRefUk
         p77C/7U0IHTIlN3FXMgD/HYWmegTpwB+0rEQW0QRZUpfOE3+pipQaXxHoHTRPRBOrM9V
         AQRg==
X-Gm-Message-State: APjAAAXFwAWXkPXON3WSzXseerXlxyUazQX1Bawp/2/XSTLB6Bwrjzi/
        VDsoMceTaLvaoPURxQx5DmedZByms0A=
X-Google-Smtp-Source: APXvYqzgiGtkpOICia2WYoy/8487eGUkMauD9Qcp+WXp6ySUxjjfxm2SLqv887OK++zAjBRCY75F7Q==
X-Received: by 2002:a19:f013:: with SMTP id p19mr12301116lfc.98.1571616626295;
        Sun, 20 Oct 2019 17:10:26 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:10:23 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/10] net: ethernet: ixp4xx: Use distinct local variable
Date:   Mon, 21 Oct 2019 02:08:20 +0200
Message-Id: <20191021000824.531-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "ndev" for the struct net_device and "dev" for the
struct device in probe() and remove(). Add the local
"dev" pointer for later use in refactoring.

Take this opportunity to fix inverse christmas tree
coding style.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 51 +++++++++++++-----------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 26da84402cfd..fbe328693de5 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1367,20 +1367,23 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 
 static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
-	struct port *port;
-	struct net_device *dev;
-	struct eth_plat_info *plat = dev_get_platdata(&pdev->dev);
+	char phy_id[MII_BUS_ID_SIZE + 3];
 	struct phy_device *phydev = NULL;
+	struct device *dev = &pdev->dev;
+	struct eth_plat_info *plat;
+	struct net_device *ndev;
+	struct port *port;
 	u32 regs_phys;
-	char phy_id[MII_BUS_ID_SIZE + 3];
 	int err;
 
-	if (!(dev = alloc_etherdev(sizeof(struct port))))
+	plat = dev_get_platdata(dev);
+
+	if (!(ndev = alloc_etherdev(sizeof(struct port))))
 		return -ENOMEM;
 
-	SET_NETDEV_DEV(dev, &pdev->dev);
-	port = netdev_priv(dev);
-	port->netdev = dev;
+	SET_NETDEV_DEV(ndev, dev);
+	port = netdev_priv(ndev);
+	port->netdev = ndev;
 	port->id = pdev->id;
 
 	switch (port->id) {
@@ -1433,18 +1436,18 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
-	dev->netdev_ops = &ixp4xx_netdev_ops;
-	dev->ethtool_ops = &ixp4xx_ethtool_ops;
-	dev->tx_queue_len = 100;
+	ndev->netdev_ops = &ixp4xx_netdev_ops;
+	ndev->ethtool_ops = &ixp4xx_ethtool_ops;
+	ndev->tx_queue_len = 100;
 
-	netif_napi_add(dev, &port->napi, eth_poll, NAPI_WEIGHT);
+	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
 	if (!(port->npe = npe_request(NPE_ID(port->id)))) {
 		err = -EIO;
 		goto err_free;
 	}
 
-	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, dev->name);
+	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, ndev->name);
 	if (!port->mem_res) {
 		err = -EBUSY;
 		goto err_npe_rel;
@@ -1452,9 +1455,9 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	port->plat = plat;
 	npe_port_tab[NPE_ID(port->id)] = port;
-	memcpy(dev->dev_addr, plat->hwaddr, ETH_ALEN);
+	memcpy(ndev->dev_addr, plat->hwaddr, ETH_ALEN);
 
-	platform_set_drvdata(pdev, dev);
+	platform_set_drvdata(pdev, ndev);
 
 	__raw_writel(DEFAULT_CORE_CNTRL | CORE_RESET,
 		     &port->regs->core_control);
@@ -1464,7 +1467,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
 		mdio_bus->id, plat->phy);
-	phydev = phy_connect(dev, phy_id, &ixp4xx_adjust_link,
+	phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
 			     PHY_INTERFACE_MODE_MII);
 	if (IS_ERR(phydev)) {
 		err = PTR_ERR(phydev);
@@ -1473,10 +1476,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	phydev->irq = PHY_POLL;
 
-	if ((err = register_netdev(dev)))
+	if ((err = register_netdev(ndev)))
 		goto err_phy_dis;
 
-	printk(KERN_INFO "%s: MII PHY %i on %s\n", dev->name, plat->phy,
+	printk(KERN_INFO "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
 	       npe_name(port->npe));
 
 	return 0;
@@ -1489,23 +1492,23 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 err_npe_rel:
 	npe_release(port->npe);
 err_free:
-	free_netdev(dev);
+	free_netdev(ndev);
 	return err;
 }
 
 static int ixp4xx_eth_remove(struct platform_device *pdev)
 {
-	struct net_device *dev = platform_get_drvdata(pdev);
-	struct phy_device *phydev = dev->phydev;
-	struct port *port = netdev_priv(dev);
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct phy_device *phydev = ndev->phydev;
+	struct port *port = netdev_priv(ndev);
 
-	unregister_netdev(dev);
+	unregister_netdev(ndev);
 	phy_disconnect(phydev);
 	ixp4xx_mdio_remove();
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
 	release_resource(port->mem_res);
-	free_netdev(dev);
+	free_netdev(ndev);
 	return 0;
 }
 
-- 
2.21.0

