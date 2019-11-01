Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503E3EC36F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfKANCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:02:47 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40564 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfKANCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:02:45 -0400
Received: by mail-lj1-f193.google.com with SMTP id q2so3623194ljg.7
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLmKxYWPrGxN637WEJSw5Q6s5tphPYjobAlnKmtB1EE=;
        b=AJ2gW2DLuEWNtFFrZBqEV4EOsZi1lHJD4/920NS3IboOCROY5dZvhCFXxBgwx0/5XK
         kKZmfFtDqeyxY5zZhxAS1a4dv7ZqBPnaIsXolXu5ohOrtzRpyQs6Va0ig9H5742m03my
         V1s+4D+xLoEtXIZqjzJc0jCt9qiQIZx7ovaUNHdnMufqqUkWZcdx1rjzKJx0xtvZx9po
         iQO3vPrRjHe0bi0dXuAuxanm/96gBetg1bE4T2I9bHilWY9vQJ4ss2ShNEdlez3mw8lS
         OaR9KJfRV6AlrfImAd3sHBqhj6dpJRd/eUUtu8YAzXf55oSsRF30G1an/m77FJDLIR1n
         zWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JLmKxYWPrGxN637WEJSw5Q6s5tphPYjobAlnKmtB1EE=;
        b=H4kEwiQ35z27if5fS+6exwWUIAxZQCAh2eTj7oqh9u7jrkPmfi+G41C2DV7pKF7QPa
         uEjWNy4HbcxZ9ci/XWCm/ri9tU/bJpHJjaggutQgHg2pPJCFejDnXiFWHSmxSQELAzbA
         R1CDFDQ2jl3koWdmm8yJ3gvCkeiC7khb36cFdE6aIiKrSXbXm7VOqW1PJsrtVvulq47Y
         mefCMdSWUAxlZG+trBJyC1UVCzdP86AvzTQbl9KVYf+v3FupLg0saxU0a7PUkllgxlV5
         e45QqaIYKPX/rROZWTwdArKrdbEwOpUeZPLZKWUXGquq+7O0Y48nt9ScNy4gswvIbhtH
         iteA==
X-Gm-Message-State: APjAAAVQfZkj84QSAOQaxwFxIqbJMSvgDryoMehsLPBCqqearDqWySuB
        u/5NKbK8DyxZeUjmVOR04CmWptCi+cCeEQ==
X-Google-Smtp-Source: APXvYqxIBv3yNJQwIfSTM20qT6MMLmdsVnywYA2F763OOvO0GX9bXldSGbV3l/88Tix/xw5S5dXLiw==
X-Received: by 2002:a2e:3505:: with SMTP id z5mr7608237ljz.126.1572613362420;
        Fri, 01 Nov 2019 06:02:42 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id c3sm2516749lfi.32.2019.11.01.06.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:02:41 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 06/10 v2] net: ethernet: ixp4xx: Use distinct local variable
Date:   Fri,  1 Nov 2019 14:02:20 +0100
Message-Id: <20191101130224.7964-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101130224.7964-1-linus.walleij@linaro.org>
References: <20191101130224.7964-1-linus.walleij@linaro.org>
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

