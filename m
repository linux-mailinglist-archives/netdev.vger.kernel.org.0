Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6C536A3B2
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 02:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhDYAbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 20:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhDYAbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 20:31:35 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A31C061574
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 17:30:55 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id b38so18676491ljf.5
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 17:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZkG6pGr4FYaHlJ1HtdNybKAiBJP3aFKJkNsUXoVX4As=;
        b=ta1a8+E4Z32qoQfr0+r5AHZZZSRicgaNJzJqvsx4lqaHu3KzBuxVvM0Ag7mXQ7vtPT
         JmWO3EVoaJu3ZbKLAHS7hejcILGguLNCuq2Pt/cQKib5oDUyX3yOUP6Q0ZLQcU/u8Ntw
         DlvWCUK5Cu3eIM6/RF7ZtB2/9j13PCvmXqOBMw7bQrvPK4mY+YaWNu2S7kluSvcE2R5n
         8HZOYU6oA4nfEdWyMCqJvUkxkSudYk2wNpBKHugZ+uXYo/ce6eRY4PNUX/sCQ79KfryX
         RJmaecZtb+pY9otBK0iUE83VnwbwWGOsKWz8NyuzZ+hAgHh/z5FyCr1RfJ6Kcn5Wht8y
         ukVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZkG6pGr4FYaHlJ1HtdNybKAiBJP3aFKJkNsUXoVX4As=;
        b=hWL9/Awt/buTYrr7d4r+xj9AfO7X8enParfzfTHXNF+SwIuMuHeHG4CvGOfvd0Bx/X
         XotcXWRfZ0DqqI3X1ksXB2SsC8OujVdKPo9+ysV4sII2iVRzYHwh76yevofjCM3uq8YG
         PXxgy3q3rCMpg8221xEzIEvrGKpkN3J5YeUS5h5zxgaXwYXgkkvagJrN/IuM6CjeJ75K
         7RI/8dpshbBRWvKOkMIQy8d2MoIWFtOdcnp1v7JrBAVkOvqKHeoanq0JTAdm1mHWCTNH
         NgrFU1VTUP357SavRa+Zhau75+FpDr/l3dl/wJ8T6v1YRGXHzVgLO9Ndp5ER8W4jwZ/m
         oJNQ==
X-Gm-Message-State: AOAM533s9Va+CyZJj5M4Z3wUZXL/XiyPlpoqMacygMG9EQNzml4NYfMk
        f0MArKmaGYtLwWCnSgli7D79kFIoSzuEpw==
X-Google-Smtp-Source: ABdhPJxPHvv1SGD/EEIh6dbER4+5xPX2H3iOIA41cPd03528namHqMeMTqvMWFy7aINl9ldaowwBvw==
X-Received: by 2002:a2e:9b51:: with SMTP id o17mr7397382ljj.315.1619310654084;
        Sat, 24 Apr 2021 17:30:54 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id t5sm950352lfe.211.2021.04.24.17.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 17:30:53 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>
Subject: [PATCH 3/3 net-next v4] net: ethernet: ixp4xx: Support device tree probing
Date:   Sun, 25 Apr 2021 02:30:38 +0200
Message-Id: <20210425003038.2937498-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210425003038.2937498-1-linus.walleij@linaro.org>
References: <20210425003038.2937498-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree probing to the IXP4xx ethernet
driver.

Add a platform data bool to tell us whether to
register an MDIO bus for the device or not, as well
as the corresponding NPE.

We need to drop the memory region request as part of
this since the OF core will request the memory for the
device.

Cc: Zoltan HERPAI <wigyori@uid0.hu>
Cc: Raylynn Knight <rayknight@me.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Use phandle to look up the NPE instance to use
ChangeLog v2->v3:
- Squash in the patch doing the MDIO bus transition to
  OF probing.
ChangeLog v1->v2:
- Do not rely on earlier attempt for identifying which
  ports to use: we split the support clearly in a DT way
  and a playform data way.
- Isolate the DT code better.
---
 drivers/net/ethernet/xscale/Kconfig      |   1 +
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 210 ++++++++++++++++-------
 include/linux/platform_data/eth_ixp4xx.h |   2 +
 3 files changed, 150 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/xscale/Kconfig b/drivers/net/ethernet/xscale/Kconfig
index 7b83a6e5d894..468ffe3d1707 100644
--- a/drivers/net/ethernet/xscale/Kconfig
+++ b/drivers/net/ethernet/xscale/Kconfig
@@ -22,6 +22,7 @@ config IXP4XX_ETH
 	tristate "Intel IXP4xx Ethernet support"
 	depends on ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR
 	select PHYLIB
+	select OF_MDIO if OF
 	select NET_PTP_CLASSIFY
 	help
 	  Say Y here if you want to use built-in Ethernet ports
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 4df2686ac5b8..cb89323855d8 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/net_tstamp.h>
 #include <linux/of.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_data/eth_ixp4xx.h>
 #include <linux/platform_device.h>
@@ -165,7 +166,6 @@ struct eth_regs {
 };
 
 struct port {
-	struct resource *mem_res;
 	struct eth_regs __iomem *regs;
 	struct npe *npe;
 	struct net_device *netdev;
@@ -250,6 +250,7 @@ static inline void memcpy_swab32(u32 *dest, u32 *src, int cnt)
 static DEFINE_SPINLOCK(mdio_lock);
 static struct eth_regs __iomem *mdio_regs; /* mdio command and status only */
 static struct mii_bus *mdio_bus;
+static struct device_node *mdio_bus_np;
 static int ports_open;
 static struct port *npe_port_tab[MAX_NPES];
 static struct dma_pool *dma_pool;
@@ -533,7 +534,8 @@ static int ixp4xx_mdio_register(struct eth_regs __iomem *regs)
 	mdio_bus->write = &ixp4xx_mdio_write;
 	snprintf(mdio_bus->id, MII_BUS_ID_SIZE, "ixp4xx-eth-0");
 
-	if ((err = mdiobus_register(mdio_bus)))
+	err = of_mdiobus_register(mdio_bus, mdio_bus_np);
+	if (err)
 		mdiobus_free(mdio_bus);
 	return err;
 }
@@ -1358,18 +1360,118 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 };
 
+#ifdef CONFIG_OF
+static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct of_phandle_args queue_spec;
+	struct of_phandle_args npe_spec;
+	struct device_node *mdio_np;
+	struct eth_plat_info *plat;
+	int ret;
+
+	plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
+	if (!plat)
+		return NULL;
+
+	ret = of_parse_phandle_with_fixed_args(np, "intel,npe-handle", 1, 0,
+					       &npe_spec);
+	if (ret) {
+		dev_err(dev, "no NPE engine specified\n");
+		return NULL;
+	}
+	/* NPE ID 0x00, 0x10, 0x20... */
+	plat->npe = (npe_spec.args[0] << 4);
+
+	/* Check if this device has an MDIO bus */
+	mdio_np = of_get_child_by_name(np, "mdio");
+	if (mdio_np) {
+		plat->has_mdio = true;
+		mdio_bus_np = mdio_np;
+		/* DO NOT put the mdio_np, it will be used */
+	}
+
+	/* Get the rx queue as a resource from queue manager */
+	ret = of_parse_phandle_with_fixed_args(np, "queue-rx", 1, 0,
+					       &queue_spec);
+	if (ret) {
+		dev_err(dev, "no rx queue phandle\n");
+		return NULL;
+	}
+	plat->rxq = queue_spec.args[0];
+
+	/* Get the txready queue as resource from queue manager */
+	ret = of_parse_phandle_with_fixed_args(np, "queue-txready", 1, 0,
+					       &queue_spec);
+	if (ret) {
+		dev_err(dev, "no txready queue phandle\n");
+		return NULL;
+	}
+	plat->txreadyq = queue_spec.args[0];
+
+	return plat;
+}
+#else
+static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
 	struct phy_device *phydev = NULL;
 	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct eth_plat_info *plat;
-	resource_size_t regs_phys;
 	struct net_device *ndev;
 	struct resource *res;
 	struct port *port;
 	int err;
 
-	plat = dev_get_platdata(dev);
+	if (np) {
+		plat = ixp4xx_of_get_platdata(dev);
+		if (!plat)
+			return -ENODEV;
+	} else {
+		plat = dev_get_platdata(dev);
+		if (!plat)
+			return -ENODEV;
+		plat->npe = pdev->id;
+		switch (plat->npe) {
+		case IXP4XX_ETH_NPEA:
+			/* If the MDIO bus is not up yet, defer probe */
+			break;
+		case IXP4XX_ETH_NPEB:
+			/* On all except IXP43x, NPE-B is used for the MDIO bus.
+			 * If there is no NPE-B in the feature set, bail out,
+			 * else we have the MDIO bus here.
+			 */
+			if (!cpu_is_ixp43x()) {
+				if (!(ixp4xx_read_feature_bits() &
+				      IXP4XX_FEATURE_NPEB_ETH0))
+					return -ENODEV;
+				/* Else register the MDIO bus on NPE-B */
+				plat->has_mdio = true;
+			}
+			break;
+		case IXP4XX_ETH_NPEC:
+			/* IXP43x lacks NPE-B and uses NPE-C for the MDIO bus
+			 * access, if there is no NPE-C, no bus, nothing works,
+			 * so bail out.
+			 */
+			if (cpu_is_ixp43x()) {
+				if (!(ixp4xx_read_feature_bits() &
+				      IXP4XX_FEATURE_NPEC_ETH))
+					return -ENODEV;
+				/* Else register the MDIO bus on NPE-B */
+				plat->has_mdio = true;
+			}
+			break;
+		default:
+			return -ENODEV;
+		}
+	}
 
 	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
 		return -ENOMEM;
@@ -1377,59 +1479,29 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, dev);
 	port = netdev_priv(ndev);
 	port->netdev = ndev;
-	port->id = pdev->id;
+	port->id = plat->npe;
 
 	/* Get the port resource and remap */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	regs_phys = res->start;
 	port->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(port->regs))
 		return PTR_ERR(port->regs);
 
-	switch (port->id) {
-	case IXP4XX_ETH_NPEA:
-		/* If the MDIO bus is not up yet, defer probe */
-		if (!mdio_bus)
-			return -EPROBE_DEFER;
-		break;
-	case IXP4XX_ETH_NPEB:
-		/*
-		 * On all except IXP43x, NPE-B is used for the MDIO bus.
-		 * If there is no NPE-B in the feature set, bail out, else
-		 * register the MDIO bus.
-		 */
-		if (!cpu_is_ixp43x()) {
-			if (!(ixp4xx_read_feature_bits() &
-			      IXP4XX_FEATURE_NPEB_ETH0))
-				return -ENODEV;
-			/* Else register the MDIO bus on NPE-B */
-			if ((err = ixp4xx_mdio_register(port->regs)))
-				return err;
-		}
-		if (!mdio_bus)
-			return -EPROBE_DEFER;
-		break;
-	case IXP4XX_ETH_NPEC:
-		/*
-		 * IXP43x lacks NPE-B and uses NPE-C for the MDIO bus access,
-		 * of there is no NPE-C, no bus, nothing works, so bail out.
-		 */
-		if (cpu_is_ixp43x()) {
-			if (!(ixp4xx_read_feature_bits() &
-			      IXP4XX_FEATURE_NPEC_ETH))
-				return -ENODEV;
-			/* Else register the MDIO bus on NPE-C */
-			if ((err = ixp4xx_mdio_register(port->regs)))
-				return err;
+	/* Register the MDIO bus if we have it */
+	if (plat->has_mdio) {
+		err = ixp4xx_mdio_register(port->regs);
+		if (err) {
+			dev_err(dev, "failed to register MDIO bus\n");
+			return err;
 		}
-		if (!mdio_bus)
-			return -EPROBE_DEFER;
-		break;
-	default:
-		return -ENODEV;
 	}
+	/* If the instance with the MDIO bus has not yet appeared,
+	 * defer probing until it gets probed.
+	 */
+	if (!mdio_bus)
+		return -EPROBE_DEFER;
 
 	ndev->netdev_ops = &ixp4xx_netdev_ops;
 	ndev->ethtool_ops = &ixp4xx_ethtool_ops;
@@ -1443,12 +1515,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	if (!(port->npe = npe_request(NPE_ID(port->id))))
 		return -EIO;
 
-	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, ndev->name);
-	if (!port->mem_res) {
-		err = -EBUSY;
-		goto err_npe_rel;
-	}
-
 	port->plat = plat;
 	npe_port_tab[NPE_ID(port->id)] = port;
 	memcpy(ndev->dev_addr, plat->hwaddr, ETH_ALEN);
@@ -1461,15 +1527,26 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	__raw_writel(DEFAULT_CORE_CNTRL, &port->regs->core_control);
 	udelay(50);
 
-	phydev = mdiobus_get_phy(mdio_bus, plat->phy);
-	if (IS_ERR(phydev)) {
-		err = PTR_ERR(phydev);
-		goto err_free_mem;
+	if (np) {
+		phydev = of_phy_get_and_connect(ndev, np, ixp4xx_adjust_link);
+	} else {
+		phydev = mdiobus_get_phy(mdio_bus, plat->phy);
+		if (IS_ERR(phydev)) {
+			err = PTR_ERR(phydev);
+			dev_err(dev, "could not connect phydev (%d)\n", err);
+			goto err_free_mem;
+		}
+		err = phy_connect_direct(ndev, phydev, ixp4xx_adjust_link,
+					 PHY_INTERFACE_MODE_MII);
+		if (err)
+			goto err_free_mem;
+
 	}
-	err = phy_connect_direct(ndev, phydev, ixp4xx_adjust_link,
-				 PHY_INTERFACE_MODE_MII);
-	if (err)
+	if (!phydev) {
+		err = -ENODEV;
+		dev_err(dev, "no phydev\n");
 		goto err_free_mem;
+	}
 
 	phydev->irq = PHY_POLL;
 
@@ -1485,8 +1562,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	phy_disconnect(phydev);
 err_free_mem:
 	npe_port_tab[NPE_ID(port->id)] = NULL;
-	release_resource(port->mem_res);
-err_npe_rel:
 	npe_release(port->npe);
 	return err;
 }
@@ -1502,12 +1577,21 @@ static int ixp4xx_eth_remove(struct platform_device *pdev)
 	ixp4xx_mdio_remove();
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
-	release_resource(port->mem_res);
 	return 0;
 }
 
+static const struct of_device_id ixp4xx_eth_of_match[] = {
+	{
+		.compatible = "intel,ixp4xx-ethernet",
+	},
+	{ },
+};
+
 static struct platform_driver ixp4xx_eth_driver = {
-	.driver.name	= DRV_NAME,
+	.driver = {
+		.name = DRV_NAME,
+		.of_match_table = of_match_ptr(ixp4xx_eth_of_match),
+	},
 	.probe		= ixp4xx_eth_probe,
 	.remove		= ixp4xx_eth_remove,
 };
diff --git a/include/linux/platform_data/eth_ixp4xx.h b/include/linux/platform_data/eth_ixp4xx.h
index 6f652ea0c6ae..114b0940729f 100644
--- a/include/linux/platform_data/eth_ixp4xx.h
+++ b/include/linux/platform_data/eth_ixp4xx.h
@@ -14,6 +14,8 @@ struct eth_plat_info {
 	u8 rxq;		/* configurable, currently 0 - 31 only */
 	u8 txreadyq;
 	u8 hwaddr[6];
+	u8 npe;		/* NPE instance used by this interface */
+	bool has_mdio;	/* If this instance has an MDIO bus */
 };
 
 #endif
-- 
2.29.2

