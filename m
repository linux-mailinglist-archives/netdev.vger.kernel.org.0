Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05488364DDC
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhDSWwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhDSWwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 18:52:22 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8ACC06138C
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 15:51:51 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id r128so31525303lff.4
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 15:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1z4m04rYNKkzp/v7KiFWbrpwzCK1WACIqa+LnQcZqhU=;
        b=RkUjedUhCUu9EuKONFzXrYyO8xUaxkmEleMwQYVwmd6cA6nGCnKCcxP1d+RVEYTcYF
         kafgg8/9zDA/qGnnS/5CllcnJjcOVfWPKo57KDA+Ucqj2wpm57rDXTssjsra8sjB6+SO
         RyjqMreRbMNAb4ujWfh/us9gs1DbOn6xWC2Z+vvlX+6KelTZcTAut4N8MFmkd8A/Tfkp
         i8T/Uk88FmC66oXqtyWh84RLMaK0Wpb8C0VPdTFwBmn1zJTavOYShWFjwZu+d3z1/pur
         asQ/z1Rj+Quz1ALu/j/gsSApx8Cwi/bkW/L5HUL0YWkAPnVO49751+UmbG0X+uHSQsnl
         7s5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1z4m04rYNKkzp/v7KiFWbrpwzCK1WACIqa+LnQcZqhU=;
        b=H5eVl+1cBDO5eyK0IOBfg9R+85eqLh6qIcpHijbJ4KVbGOgu0L8ZDZnu04TCdQd0d2
         XNddn1Wqn2wHRVQpwNern8JldU0CR5467v3ivxVr8TSnosRXlnJ+VX7avVUClHYmpv4Y
         7o17PKugG86uFL9B7/YnfjJnExUEDijFNt/6vatNehuVnvbSjlXUKACAo/Eb4pSPWSam
         dc6DI65e2c5f+/reFNu4+p9OxjyAhZk14q2YqVnMbvzMML/tprP0/Nq9lwgj8cBDIQlz
         J1c4KlBjloT6Qi5csj7fMvlAUIR0NCih0Yrj4EJFYR5srP47s9SUFZnZurLB6OkZy/gr
         v9VA==
X-Gm-Message-State: AOAM530jAFFuN/7w7DmciG4ynx0+2EPaXHV2wcCwdksq2WW/uD2RA1Ze
        iLBsdQ/vD3KbKma80g4qJVBESKB9aip48A==
X-Google-Smtp-Source: ABdhPJz/hGgERpxT4Ncsv2cGEV5tGzl2gzsibALnsadiGlN3LraqOl6AgcjBsQrA/P9dIXpU4eu4Eg==
X-Received: by 2002:a05:6512:a86:: with SMTP id m6mr14199168lfu.314.1618872709628;
        Mon, 19 Apr 2021 15:51:49 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p5sm1950179lfg.183.2021.04.19.15.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 15:51:49 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>
Subject: [PATCH 3/3] net: ethernet: ixp4xx: Use OF MDIO bus registration
Date:   Tue, 20 Apr 2021 00:51:33 +0200
Message-Id: <20210419225133.2005360-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210419225133.2005360-1-linus.walleij@linaro.org>
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This augments the IXP4xx to use the OF MDIO bus code when
registering the MDIO bus and when looking up the PHY
for the ethernet network device.

Cc: Zoltan HERPAI <wigyori@uid0.hu>
Cc: Raylynn Knight <rayknight@me.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- New patch making use of more OF infrastructure.
---
 drivers/net/ethernet/xscale/Kconfig      |  1 +
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 34 +++++++++---------------
 2 files changed, 14 insertions(+), 21 deletions(-)

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
index 758f820068b5..1e1779b53f22 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
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
@@ -1364,7 +1366,6 @@ static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
 	struct device_node *np = dev->of_node;
 	struct of_phandle_args queue_spec;
 	struct eth_plat_info *plat;
-	struct device_node *phy_np;
 	struct device_node *mdio_np;
 	u32 val;
 	int ret;
@@ -1381,25 +1382,12 @@ static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
 	/* NPE ID 0x00, 0x10, 0x20... */
 	plat->npe = (val << 4);
 
-	phy_np = of_parse_phandle(np, "phy-handle", 0);
-	if (phy_np) {
-		ret = of_property_read_u32(phy_np, "reg", &val);
-		if (ret) {
-			dev_err(dev, "cannot find phy reg\n");
-			return NULL;
-		}
-		of_node_put(phy_np);
-	} else {
-		dev_err(dev, "cannot find phy instance\n");
-		val = 0;
-	}
-	plat->phy = val;
-
 	/* Check if this device has an MDIO bus */
 	mdio_np = of_get_child_by_name(np, "mdio");
 	if (mdio_np) {
 		plat->has_mdio = true;
-		of_node_put(mdio_np);
+		mdio_bus_np = mdio_np;
+		/* DO NOT put the mdio_np, it will be used */
 	}
 
 	/* Get the rx queue as a resource from queue manager */
@@ -1539,10 +1527,14 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	__raw_writel(DEFAULT_CORE_CNTRL, &port->regs->core_control);
 	udelay(50);
 
-	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
-		 mdio_bus->id, plat->phy);
-	phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
-			     PHY_INTERFACE_MODE_MII);
+	if (np) {
+		phydev = of_phy_get_and_connect(ndev, np, ixp4xx_adjust_link);
+	} else {
+		snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
+			 mdio_bus->id, plat->phy);
+		phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
+				     PHY_INTERFACE_MODE_MII);
+	}
 	if (!phydev) {
 		err = -ENODEV;
 		dev_err(dev, "no phydev\n");
-- 
2.29.2

