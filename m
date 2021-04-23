Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36FD368EC8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 10:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbhDWIWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 04:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241227AbhDWIWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 04:22:53 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D381CC06138B
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 01:22:16 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id r128so49285662lff.4
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 01:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LHgZn13T4WqG7rs7W06UxxOanrJigkcZfmxtcvn1Adg=;
        b=W9J8LHfrJnRvyY2aAI+Tkut7R8ShmQQq/tNXh/IJ5wBYJJhZPW0axeRzzj6SxVfH/v
         hMIc8Rv3w0I1kUWhJqXLryA2glRDxsVTWqM1jo4CcwUAL71ZI1RkLyJT4Hr6ZCtIAx/2
         lLjCGal16dGJtzWkhixohpB1CJ72F058nzCd8EfSFPDO7PkkQ+UgGgqeYHnQ8a/CpdD2
         sgTZUbGD10YzyZzl8n/r0Jzz5nsJIOPoUsEfXOr3+shajb//lQZo5ZcGecwYyXs57FgC
         XNW9U1yrSgOMN4+Kg2GjVS6SOMNo4L9VVguCi1Jcu3JzWlmDL3tQ/vwFIZibqJz0IqU4
         azaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LHgZn13T4WqG7rs7W06UxxOanrJigkcZfmxtcvn1Adg=;
        b=IoqbzLLY9c4G9Zjxm8rO0IkWYknKh94PznZeShaCxX+6IJXlLSbuZdqA9Vpvm7Vt4m
         0nAdCsn+SD3Pv88A7hI45urQZX8+XB3qwne+JSsZY8VgdgC38VaoBpRrhXTX8tOBsJgy
         kp1J+ikfJoX86/c2nbivGZh6aNcskrBlx1D8VP4TkQvqUBKLKKZj6niQ5B1mXqMVUtnW
         KHhXnR4zX1OlPytdABjaCcTFIaUvVCAWFvOx1z4Gd9+U3SkeBj/cVovmO4Y2MyLO42W3
         8mG5mR++6+ErL2xM6Nsr8A2CFZxyMiaDGmAx3pbYZm8Ljafis80VzoAQwaldnrngCdPU
         LCDA==
X-Gm-Message-State: AOAM532uqt2FgARXvoEGMfxjRZE0n/8PJYqAo6pHW6kvhi3YKVEK07pf
        CDl4SZD7rspGf/S1G/vqr9JoGsgXA8n/uQ==
X-Google-Smtp-Source: ABdhPJxJkta97amdBYk9Jgn9nOB//piXsZWIMfadODXVVN7kwptEj8EPqocw6DOraTX5UYVkhPqAjg==
X-Received: by 2002:ac2:5dd8:: with SMTP id x24mr1955363lfq.160.1619166135063;
        Fri, 23 Apr 2021 01:22:15 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x74sm484475lff.145.2021.04.23.01.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 01:22:14 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>
Subject: [PATCH 3/3 net-next v3] net: ethernet: ixp4xx: Support device tree probing
Date:   Fri, 23 Apr 2021 10:22:08 +0200
Message-Id: <20210423082208.2244803-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423082208.2244803-1-linus.walleij@linaro.org>
References: <20210423082208.2244803-1-linus.walleij@linaro.org>
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
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 209 ++++++++++++++++-------
 include/linux/platform_data/eth_ixp4xx.h |   2 +
 3 files changed, 149 insertions(+), 63 deletions(-)

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
index 4df2686ac5b8..ac8049b62337 100644
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
@@ -1358,18 +1360,117 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 };
 
+#ifdef CONFIG_OF
+static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct of_phandle_args queue_spec;
+	struct eth_plat_info *plat;
+	struct device_node *mdio_np;
+	u32 val;
+	int ret;
+
+	plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
+	if (!plat)
+		return NULL;
+
+	ret = of_property_read_u32(np, "intel,npe", &val);
+	if (ret) {
+		dev_err(dev, "no NPE engine specified\n");
+		return NULL;
+	}
+	/* NPE ID 0x00, 0x10, 0x20... */
+	plat->npe = (val << 4);
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
@@ -1377,59 +1478,29 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
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
@@ -1443,12 +1514,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
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
@@ -1461,15 +1526,26 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
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
 
@@ -1485,8 +1561,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	phy_disconnect(phydev);
 err_free_mem:
 	npe_port_tab[NPE_ID(port->id)] = NULL;
-	release_resource(port->mem_res);
-err_npe_rel:
 	npe_release(port->npe);
 	return err;
 }
@@ -1502,12 +1576,21 @@ static int ixp4xx_eth_remove(struct platform_device *pdev)
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

