Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C599C138623
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732809AbgALMFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:05:11 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35818 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732774AbgALMFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 07:05:09 -0500
Received: by mail-lf1-f67.google.com with SMTP id 15so4849473lfr.2
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 04:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AJcb9EynpGQPaCRXZFp5Z/kkfxUX5I93NLEGssvipjk=;
        b=Ri+8twh6gEXFTQA++lcQ0Shd7qCIa6OSHpTK2o6oXLIy+ZY16LCP5ta/jMc1EWsz3u
         ZDnbrItolWJ9MO6S/3P2H3+8/yV6P9pzzuc9gp0pVeVZvwogEMyUwurogto3rVEpckvF
         IBQbEzC1ECd959ZdF1v5PUicHE19mjRz9e8mjpNZQm1Qk142udsn3JKe0QpPT69oVkWQ
         wta4UYftelVvRkRNjDKVCIlAjSkNv2E5dAqV8hlcI9rRz24Q0zIjlYDD70r6iU4pv/Ts
         A234be0ub9EiW52XUCI0Y042gFMc/JCxTEx1/aBwk5TG+25D9iU3V72VPC5W7dU6glr5
         Z2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AJcb9EynpGQPaCRXZFp5Z/kkfxUX5I93NLEGssvipjk=;
        b=KwC0m5UxOAL+XCWvs/LKeNMe03bW3Jd9cFE5RNEHjOY3Sl1Rh5vJC6k6dAZvWT19vh
         52zNwmsNW01VSyzGGJi4rNz3+T/jZs/PLYsOT+NREkQWL9IfVPSNvk+XVMMFgYqr/hVL
         doF1mWYop+wpI6WNkMD8rEjDS5G9DRCg6GVuxml/Nfwwy5K7ywlwlZMPpyt+1B+duBIq
         cw3tjX0kCFlDUTDV0wmme/P8cQ1fiTQHe0g8KEUZmv0xLK+BDohuh3q/QLAV1piOFhqR
         gdTsmjo5x4VIURzhQjGIathQZSfC6xyaK3MggCxycdhBEFpLqGxaTXi+fOdBl+1NkcUQ
         xvuA==
X-Gm-Message-State: APjAAAXeI8trigF8az6+KffZOCDV1gpxmtcSXzR+m+8Oz+9ECmELVUXs
        EsWILWfulTkRivadW1pSUBocNQxUvvPQFA==
X-Google-Smtp-Source: APXvYqxwghuBGR9HOgbuAl0DW06uLBS1RHnkNSpCnpc1hfxn+qyaurgdcct2iDe5q2H8+rNPsO0A1w==
X-Received: by 2002:a19:850a:: with SMTP id h10mr7123909lfd.89.1578830707298;
        Sun, 12 Jan 2020 04:05:07 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id z7sm4660347lfa.81.2020.01.12.04.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 04:05:06 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 6/9 v5] net: ethernet: ixp4xx: Use distinct local variable
Date:   Sun, 12 Jan 2020 13:04:47 +0100
Message-Id: <20200112120450.11874-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200112120450.11874-1-linus.walleij@linaro.org>
References: <20200112120450.11874-1-linus.walleij@linaro.org>
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
ChangeLog v4->v5:
- Renase onto the net-next tree
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Rebase on the other changes.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 47 +++++++++++++-----------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 799ffebba491..05ab8426bb8d 100644
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
 
-	if (!(dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct port))))
+	plat = dev_get_platdata(dev);
+
+	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
 		return -ENOMEM;
 
-	SET_NETDEV_DEV(dev, &pdev->dev);
-	port = netdev_priv(dev);
-	port->netdev = dev;
+	SET_NETDEV_DEV(ndev, dev);
+	port = netdev_priv(ndev);
+	port->netdev = ndev;
 	port->id = pdev->id;
 
 	switch (port->id) {
@@ -1432,16 +1435,16 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dev->netdev_ops = &ixp4xx_netdev_ops;
-	dev->ethtool_ops = &ixp4xx_ethtool_ops;
-	dev->tx_queue_len = 100;
+	ndev->netdev_ops = &ixp4xx_netdev_ops;
+	ndev->ethtool_ops = &ixp4xx_ethtool_ops;
+	ndev->tx_queue_len = 100;
 
-	netif_napi_add(dev, &port->napi, eth_poll, NAPI_WEIGHT);
+	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
 	if (!(port->npe = npe_request(NPE_ID(port->id))))
 		return -EIO;
 
-	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, dev->name);
+	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, ndev->name);
 	if (!port->mem_res) {
 		err = -EBUSY;
 		goto err_npe_rel;
@@ -1449,9 +1452,9 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	port->plat = plat;
 	npe_port_tab[NPE_ID(port->id)] = port;
-	memcpy(dev->dev_addr, plat->hwaddr, ETH_ALEN);
+	memcpy(ndev->dev_addr, plat->hwaddr, ETH_ALEN);
 
-	platform_set_drvdata(pdev, dev);
+	platform_set_drvdata(pdev, ndev);
 
 	__raw_writel(DEFAULT_CORE_CNTRL | CORE_RESET,
 		     &port->regs->core_control);
@@ -1461,7 +1464,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
 		mdio_bus->id, plat->phy);
-	phydev = phy_connect(dev, phy_id, &ixp4xx_adjust_link,
+	phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
 			     PHY_INTERFACE_MODE_MII);
 	if (IS_ERR(phydev)) {
 		err = PTR_ERR(phydev);
@@ -1470,10 +1473,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	phydev->irq = PHY_POLL;
 
-	if ((err = register_netdev(dev)))
+	if ((err = register_netdev(ndev)))
 		goto err_phy_dis;
 
-	printk(KERN_INFO "%s: MII PHY %i on %s\n", dev->name, plat->phy,
+	printk(KERN_INFO "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
 	       npe_name(port->npe));
 
 	return 0;
@@ -1490,11 +1493,11 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
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
-- 
2.21.0

