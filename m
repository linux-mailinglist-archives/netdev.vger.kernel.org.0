Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F43DE164
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfJUAKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:25 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46828 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:24 -0400
Received: by mail-lj1-f196.google.com with SMTP id d1so11305165ljl.13
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0NB+9F8QdSssG4LeN9+6VVsx224hqSgKkrEemXRqU3Q=;
        b=KqNaHzqn3Yoib521F4irfIlA+iesFszNicGLllELH2cojXjQhLZtwqwTlzYsNl7JZ4
         B65CbADm6RfCi86/pADnMIPgK3xWerKzdJCUbEttJnnCRbYiVgFNBXImLJmlV6pQW1Ht
         YPWwsmhT0O0Noakvi+XTfH/QjIHy33xgNexKvTZuRNsAnlN8ZD4Ooi9HcAXevUKWXUra
         8KXs8xD8AVOpDKE8UfWOAWWmkiNmRq/Q86qv7nbHk2/wjTqOvYKH2R0b5zo5EHPZOm2N
         M4nRK+OIw34/BwaW783eqVLtrxkTuRbWcEjUXJGUzA92v2nnW3kqcwP1Z+Tc9s7js93F
         ZSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0NB+9F8QdSssG4LeN9+6VVsx224hqSgKkrEemXRqU3Q=;
        b=jwWRn4HtHCOGtA8vQhQv7ROl3diRyDv+8FvkACmbHN61hmITyCd1/rwIZTZTRWZ7k7
         ybyrpw3OFGayDwgArPC+7bqB2+BkiccRtEgJYgXg+YamoKrxPTshLLIZpKKt2jl3mwlh
         RHhhEifA0tICAI2GC1sBr37guhMcG20kdspk9aCXZX3bQgQ0wC3szB4hNd5CCTBLg2j8
         12VXTBXWOkVWd8PEQlX5KqZF1CS4jCqWBjNB4hDXrM/EF6dhcXL3thEPBUvD9zRm2xpx
         CR5ozFEbF5Njbb5qk32IxULKQSy1Zj9DwNeyiZLs20sh28KMdtLr8OV9Fz47njHu4Sw9
         uiyw==
X-Gm-Message-State: APjAAAVGPr+WtCiaCCa9fJEOjZ99scbJRk1lsb6AYO4MndC1JRfxK2bI
        UKibjDHESspkkfgM37F0bLSrjJbKaiw=
X-Google-Smtp-Source: APXvYqyEEWgeAxifL91eABfqENqKU/nRhQl4p7y2tGBSQ6E3B/157++rPu+kC8o0AD9YUl2JWW7WqQ==
X-Received: by 2002:a05:651c:209:: with SMTP id y9mr12533276ljn.134.1571616621663;
        Sun, 20 Oct 2019 17:10:21 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:10:18 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 05/10] net: ethernet: ixp4xx: Standard module init
Date:   Mon, 21 Oct 2019 02:08:19 +0200
Message-Id: <20191021000824.531-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
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
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 82 ++++++++++++------------
 1 file changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index e811bf0d23cb..26da84402cfd 100644
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
@@ -1396,14 +1385,46 @@ static int eth_init_one(struct platform_device *pdev)
 
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
@@ -1472,7 +1493,7 @@ static int eth_init_one(struct platform_device *pdev)
 	return err;
 }
 
-static int eth_remove_one(struct platform_device *pdev)
+static int ixp4xx_eth_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct phy_device *phydev = dev->phydev;
@@ -1480,6 +1501,7 @@ static int eth_remove_one(struct platform_device *pdev)
 
 	unregister_netdev(dev);
 	phy_disconnect(phydev);
+	ixp4xx_mdio_remove();
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
 	release_resource(port->mem_res);
@@ -1489,36 +1511,12 @@ static int eth_remove_one(struct platform_device *pdev)
 
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

