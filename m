Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26703EC36E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfKANCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:02:44 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45251 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfKANCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:02:43 -0400
Received: by mail-lf1-f66.google.com with SMTP id v8so7139886lfa.12
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M+wZ1DyL0H/QBAW183PzIquK11Y7rCDGG1Vc3IWTh2g=;
        b=xhKzWBnOHEwjI84xPPLk99ByUXWDj5j2mU8exuM2lXcgHhOENCGjmLyieEXRlmywWX
         qicMu+G9HRIVMOcUpuDf1m09lcggjkhYkXQiol0PLUMJwWtGTPRln+0wkASeerxo8TNw
         up8lR949ndoKA+NWZETvlZPHM2CrwjAGyZAncs/0rKvpbB3TSy1QD+0TbSnsksOha9hh
         Nbq6U0Kx/j7unELOqDxJGA9AUlymX/BofABI/R1drD4UEri9KwpSIsU65t4teugaUIum
         PcBS4BgDxxANrMzhuWXtEIyhG0K+bLILTC7B9QR1QO6XWm+pqJCwjUN52ASTzpsxXrDY
         XzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M+wZ1DyL0H/QBAW183PzIquK11Y7rCDGG1Vc3IWTh2g=;
        b=Tj9ishAUh6WqQTEVFcfoTfltSRNsKoD6AWnViOwgps+mwHD1D7lnPADdoLXCI/XNAC
         VgWKWmXH9UJJy9UeRaVlaiSzfk8elJPW1sR07nk11RFaiFe3K9U3pNmG2zZrv7bjUfhI
         F84ZXn1zujlnrvUSyGGHTXU2SV/zQSwKlHUCjhB49yR8WNSKbOfTFLTFE7LvxFVkSAnf
         tVw9mDsgXocZJcMXwh94zuAdTnoZq2rsaSCilG0fkBd0H66E1c9ndqG7E5/XMTTw5BZy
         jmWkwzMHQzdoR4M1NUxJq1Comr+bwXyWGPM4E0xvQr3dMYHR9fsoPz3cq2SojdjU+3Lr
         WC8g==
X-Gm-Message-State: APjAAAU+876iqvuczy/VKahphkQ5KW2zArbXWYXt9Ed7L53Ez4Bp7kho
        jnolbclBIuVLLNPUc14HuhuhGBKfnwj41w==
X-Google-Smtp-Source: APXvYqyZk6oPK/KSgYiG1/DHUJE8sJXM3An2QDOCnGsRc4+foTmu0Vv3JOo/uW9jSZqDnGGBCe9SIg==
X-Received: by 2002:a19:ac48:: with SMTP id r8mr7576880lfc.181.1572613360487;
        Fri, 01 Nov 2019 06:02:40 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id c3sm2516749lfi.32.2019.11.01.06.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:02:39 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 05/10 v2] net: ethernet: ixp4xx: Standard module init
Date:   Fri,  1 Nov 2019 14:02:19 +0100
Message-Id: <20191101130224.7964-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101130224.7964-1-linus.walleij@linaro.org>
References: <20191101130224.7964-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IXP4xx driver was initializing the MDIO bus before even
probing, in the callbacks supposed to be used for setting up
the module itself, and with the side effect of trying to
register the MDIO bus as soon as this module was loaded or
compiled into the kernel whether the device was discovered
or not.

This does not work with multiplatform environments.

To get rid of this: set up the MDIO bus from the probe()
callback and remove it in the remove() callback. Rename
the probe() and remove() calls to reflect the most common
conventions.

Since there is a bit of checking for the ethernet feature
to be present in the MDIO registering function, making the
whole module not even be registered if we can't find an
MDIO bus, we need something similar: register the MDIO
bus when the corresponding ethernet is probed, and
return -EPROBE_DEFER on the other interfaces until this
happens. If no MDIO bus is present on any of the
registered interfaces we will eventually bail out.

None of the platforms I've seen has e.g. MDIO on EthB
and only uses EthC, there is always a Ethernet hardware
on the NPE (B, C) that has the MDIO bus, we just might
have to wait for it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Change the first alloc_etherdev() to devm_alloc_etherdev()
  and drop one leg of the errorpath so we can just return
  with error code in the first part of the code.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 96 +++++++++++-------------
 1 file changed, 44 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index e811bf0d23cb..799ffebba491 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -519,25 +519,14 @@ static int ixp4xx_mdio_write(struct mii_bus *bus, int phy_id, int location,
 	return ret;
 }
 
-static int ixp4xx_mdio_register(void)
+static int ixp4xx_mdio_register(struct eth_regs __iomem *regs)
 {
 	int err;
 
 	if (!(mdio_bus = mdiobus_alloc()))
 		return -ENOMEM;
 
-	if (cpu_is_ixp43x()) {
-		/* IXP43x lacks NPE-B and uses NPE-C for MII PHY access */
-		if (!(ixp4xx_read_feature_bits() & IXP4XX_FEATURE_NPEC_ETH))
-			return -ENODEV;
-		mdio_regs = (struct eth_regs __iomem *)IXP4XX_EthC_BASE_VIRT;
-	} else {
-		/* All MII PHY accesses use NPE-B Ethernet registers */
-		if (!(ixp4xx_read_feature_bits() & IXP4XX_FEATURE_NPEB_ETH0))
-			return -ENODEV;
-		mdio_regs = (struct eth_regs __iomem *)IXP4XX_EthB_BASE_VIRT;
-	}
-
+	mdio_regs = regs;
 	__raw_writel(DEFAULT_CORE_CNTRL, &mdio_regs->core_control);
 	spin_lock_init(&mdio_lock);
 	mdio_bus->name = "IXP4xx MII Bus";
@@ -1376,7 +1365,7 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 };
 
-static int eth_init_one(struct platform_device *pdev)
+static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
 	struct port *port;
 	struct net_device *dev;
@@ -1386,7 +1375,7 @@ static int eth_init_one(struct platform_device *pdev)
 	char phy_id[MII_BUS_ID_SIZE + 3];
 	int err;
 
-	if (!(dev = alloc_etherdev(sizeof(struct port))))
+	if (!(dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct port))))
 		return -ENOMEM;
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
@@ -1396,20 +1385,51 @@ static int eth_init_one(struct platform_device *pdev)
 
 	switch (port->id) {
 	case IXP4XX_ETH_NPEA:
+		/* If the MDIO bus is not up yet, defer probe */
+		if (!mdio_bus)
+			return -EPROBE_DEFER;
 		port->regs = (struct eth_regs __iomem *)IXP4XX_EthA_BASE_VIRT;
 		regs_phys  = IXP4XX_EthA_BASE_PHYS;
 		break;
 	case IXP4XX_ETH_NPEB:
+		/*
+		 * On all except IXP43x, NPE-B is used for the MDIO bus.
+		 * If there is no NPE-B in the feature set, bail out, else
+		 * register the MDIO bus.
+		 */
+		if (!cpu_is_ixp43x()) {
+			if (!(ixp4xx_read_feature_bits() &
+			      IXP4XX_FEATURE_NPEB_ETH0))
+				return -ENODEV;
+			/* Else register the MDIO bus on NPE-B */
+			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
+				return err;
+		}
+		if (!mdio_bus)
+			return -EPROBE_DEFER;
 		port->regs = (struct eth_regs __iomem *)IXP4XX_EthB_BASE_VIRT;
 		regs_phys  = IXP4XX_EthB_BASE_PHYS;
 		break;
 	case IXP4XX_ETH_NPEC:
+		/*
+		 * IXP43x lacks NPE-B and uses NPE-C for the MDIO bus access,
+		 * of there is no NPE-C, no bus, nothing works, so bail out.
+		 */
+		if (cpu_is_ixp43x()) {
+			if (!(ixp4xx_read_feature_bits() &
+			      IXP4XX_FEATURE_NPEC_ETH))
+				return -ENODEV;
+			/* Else register the MDIO bus on NPE-C */
+			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
+				return err;
+		}
+		if (!mdio_bus)
+			return -EPROBE_DEFER;
 		port->regs = (struct eth_regs __iomem *)IXP4XX_EthC_BASE_VIRT;
 		regs_phys  = IXP4XX_EthC_BASE_PHYS;
 		break;
 	default:
-		err = -ENODEV;
-		goto err_free;
+		return -ENODEV;
 	}
 
 	dev->netdev_ops = &ixp4xx_netdev_ops;
@@ -1418,10 +1438,8 @@ static int eth_init_one(struct platform_device *pdev)
 
 	netif_napi_add(dev, &port->napi, eth_poll, NAPI_WEIGHT);
 
-	if (!(port->npe = npe_request(NPE_ID(port->id)))) {
-		err = -EIO;
-		goto err_free;
-	}
+	if (!(port->npe = npe_request(NPE_ID(port->id))))
+		return -EIO;
 
 	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, dev->name);
 	if (!port->mem_res) {
@@ -1467,12 +1485,10 @@ static int eth_init_one(struct platform_device *pdev)
 	release_resource(port->mem_res);
 err_npe_rel:
 	npe_release(port->npe);
-err_free:
-	free_netdev(dev);
 	return err;
 }
 
-static int eth_remove_one(struct platform_device *pdev)
+static int ixp4xx_eth_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct phy_device *phydev = dev->phydev;
@@ -1480,45 +1496,21 @@ static int eth_remove_one(struct platform_device *pdev)
 
 	unregister_netdev(dev);
 	phy_disconnect(phydev);
+	ixp4xx_mdio_remove();
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
 	release_resource(port->mem_res);
-	free_netdev(dev);
 	return 0;
 }
 
 static struct platform_driver ixp4xx_eth_driver = {
 	.driver.name	= DRV_NAME,
-	.probe		= eth_init_one,
-	.remove		= eth_remove_one,
+	.probe		= ixp4xx_eth_probe,
+	.remove		= ixp4xx_eth_remove,
 };
-
-static int __init eth_init_module(void)
-{
-	int err;
-
-	/*
-	 * FIXME: we bail out on device tree boot but this really needs
-	 * to be fixed in a nicer way: this registers the MDIO bus before
-	 * even matching the driver infrastructure, we should only probe
-	 * detected hardware.
-	 */
-	if (of_have_populated_dt())
-		return -ENODEV;
-	if ((err = ixp4xx_mdio_register()))
-		return err;
-	return platform_driver_register(&ixp4xx_eth_driver);
-}
-
-static void __exit eth_cleanup_module(void)
-{
-	platform_driver_unregister(&ixp4xx_eth_driver);
-	ixp4xx_mdio_remove();
-}
+module_platform_driver(ixp4xx_eth_driver);
 
 MODULE_AUTHOR("Krzysztof Halasa");
 MODULE_DESCRIPTION("Intel IXP4xx Ethernet driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:ixp4xx_eth");
-module_init(eth_init_module);
-module_exit(eth_cleanup_module);
-- 
2.21.0

