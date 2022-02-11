Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D314B30AE
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354154AbiBKWf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:35:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354171AbiBKWfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:35:02 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0900D79
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 14:34:55 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id e17so14370863ljk.5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 14:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YrNf5wawikdGcg0e0o/7nYXOhFnrAgJBeA33K99ddJI=;
        b=tR0sRVpfQfVtzrydfCESZVk9Q8eLJD6cwbh3uVEKyZCSHthUgpteVKjzYppMeerEeP
         pwRWQXqUaRoguzVaPKqFShX3igbNbq8Kly6N80wsqF6CjyEhE/V4F8G2PSByjNggSsg+
         1r3J86DCsyv3l8TjJ2/AhPMXpJI/oY0fjIZu8OWuS0WsA8oZ92hYImo0oW0Mf96l0yjv
         3EAhouAnFHQLAbVOi2eX8dUrrCZ7U11VBXhyZTZxOOb/nyD157LQf4VyIt5cBEJaXAAg
         S1oNF7rPOiwDRetEaisJr+Q6zn1MER5BIBbQj75jAyNs/Eck7sfEru+tFKtX9ehgUmo6
         H4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YrNf5wawikdGcg0e0o/7nYXOhFnrAgJBeA33K99ddJI=;
        b=WATtXtERNk1gH9dOB1a0aR8PS5AAoPpD0DKWRerx12HQnnxwfdmefzEUJ0N+s5kAB+
         jeJk6mOVeGEYi7uVexcEc9ix3qA1F3Nv4LDjbd9Su977HLNwC7IJvoNlTR4cmZhJBpvt
         FqrUMK7ASZF0eMLp367YBilesj/rhxvqwge8Uw6Yx8sN86KX/78cWVMhXRlaFOV+f4P0
         ZTaq/7CUnit4j7HtHaBXTBkq2FbOjkbmRji57cHAlQIk7dad68YXX33aMgHE1EKo362p
         v3b+PEBZiJzJrMdu41rdlgwyW4VKYflCIZnFkKf4xDmVKqI9uJVfS8onyLwexvdIoRLx
         IwHQ==
X-Gm-Message-State: AOAM5310946rGhShEgb4Dq3w4JL2nAJimsHpkgQ1E8W7k251TqEWWt6D
        o/1eQKBrGpTz+NFvQl9FRqAe75ld2RUaYwC5
X-Google-Smtp-Source: ABdhPJx1Tx41vuZ6opyJFxbMC0I1R8zJPlFhzGeJLWa+F7P7YKUEc8N+EnzvVk2KxQM7vZF05V4gbQ==
X-Received: by 2002:a2e:94c5:: with SMTP id r5mr2226837ljh.17.1644618894350;
        Fri, 11 Feb 2022 14:34:54 -0800 (PST)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x2sm3296300lji.27.2022.02.11.14.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:53 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 08/13 v2] net: ixp4xx_eth: Drop platform data support
Date:   Fri, 11 Feb 2022 23:32:33 +0100
Message-Id: <20220211223238.648934-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211223238.648934-1-linus.walleij@linaro.org>
References: <20220211223238.648934-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All IXP4xx platforms are converted to device tree, the platform
data path is no longer used. Drop the code and custom include,
confine the driver in its own file.

Depend on OF and remove ifdefs around this, as we are all probing
from OF now.

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Delete a small chunk of code I missed

Network maintainers: I'm looking for an ACK to take this
change through ARM SoC along with other changes removing
these accessor functions.
---
 drivers/net/ethernet/xscale/Kconfig      |  4 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 85 ++++++------------------
 include/linux/platform_data/eth_ixp4xx.h | 21 ------
 3 files changed, 21 insertions(+), 89 deletions(-)
 delete mode 100644 include/linux/platform_data/eth_ixp4xx.h

diff --git a/drivers/net/ethernet/xscale/Kconfig b/drivers/net/ethernet/xscale/Kconfig
index 0e878fa6e322..b33f64c54b0e 100644
--- a/drivers/net/ethernet/xscale/Kconfig
+++ b/drivers/net/ethernet/xscale/Kconfig
@@ -20,9 +20,9 @@ if NET_VENDOR_XSCALE
 
 config IXP4XX_ETH
 	tristate "Intel IXP4xx Ethernet support"
-	depends on ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR
+	depends on ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR && OF
 	select PHYLIB
-	select OF_MDIO if OF
+	select OF_MDIO
 	select NET_PTP_CLASSIFY
 	help
 	  Say Y here if you want to use built-in Ethernet ports
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index df77a22d1b81..d947955621ee 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -30,7 +30,6 @@
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
-#include <linux/platform_data/eth_ixp4xx.h>
 #include <linux/platform_device.h>
 #include <linux/ptp_classify.h>
 #include <linux/slab.h>
@@ -38,6 +37,11 @@
 #include <linux/soc/ixp4xx/npe.h>
 #include <linux/soc/ixp4xx/qmgr.h>
 #include <linux/soc/ixp4xx/cpu.h>
+#include <linux/types.h>
+
+#define IXP4XX_ETH_NPEA		0x00
+#define IXP4XX_ETH_NPEB		0x10
+#define IXP4XX_ETH_NPEC		0x20
 
 #include "ixp46x_ts.h"
 
@@ -147,6 +151,16 @@ typedef void buffer_t;
 #define free_buffer_irq kfree
 #endif
 
+/* Information about built-in Ethernet MAC interfaces */
+struct eth_plat_info {
+	u8 phy;		/* MII PHY ID, 0 - 31 */
+	u8 rxq;		/* configurable, currently 0 - 31 only */
+	u8 txreadyq;
+	u8 hwaddr[6];
+	u8 npe;		/* NPE instance used by this interface */
+	bool has_mdio;	/* If this instance has an MDIO bus */
+};
+
 struct eth_regs {
 	u32 tx_control[2], __res1[2];		/* 000 */
 	u32 rx_control[2], __res2[2];		/* 010 */
@@ -1366,7 +1380,6 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 };
 
-#ifdef CONFIG_OF
 static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
@@ -1417,12 +1430,6 @@ static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
 
 	return plat;
 }
-#else
-static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
-{
-	return NULL;
-}
-#endif
 
 static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
@@ -1434,49 +1441,9 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	struct port *port;
 	int err;
 
-	if (np) {
-		plat = ixp4xx_of_get_platdata(dev);
-		if (!plat)
-			return -ENODEV;
-	} else {
-		plat = dev_get_platdata(dev);
-		if (!plat)
-			return -ENODEV;
-		plat->npe = pdev->id;
-		switch (plat->npe) {
-		case IXP4XX_ETH_NPEA:
-			/* If the MDIO bus is not up yet, defer probe */
-			break;
-		case IXP4XX_ETH_NPEB:
-			/* On all except IXP43x, NPE-B is used for the MDIO bus.
-			 * If there is no NPE-B in the feature set, bail out,
-			 * else we have the MDIO bus here.
-			 */
-			if (!cpu_is_ixp43x()) {
-				if (!(ixp4xx_read_feature_bits() &
-				      IXP4XX_FEATURE_NPEB_ETH0))
-					return -ENODEV;
-				/* Else register the MDIO bus on NPE-B */
-				plat->has_mdio = true;
-			}
-			break;
-		case IXP4XX_ETH_NPEC:
-			/* IXP43x lacks NPE-B and uses NPE-C for the MDIO bus
-			 * access, if there is no NPE-C, no bus, nothing works,
-			 * so bail out.
-			 */
-			if (cpu_is_ixp43x()) {
-				if (!(ixp4xx_read_feature_bits() &
-				      IXP4XX_FEATURE_NPEC_ETH))
-					return -ENODEV;
-				/* Else register the MDIO bus on NPE-B */
-				plat->has_mdio = true;
-			}
-			break;
-		default:
-			return -ENODEV;
-		}
-	}
+	plat = ixp4xx_of_get_platdata(dev);
+	if (!plat)
+		return -ENODEV;
 
 	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
 		return -ENOMEM;
@@ -1530,21 +1497,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	__raw_writel(DEFAULT_CORE_CNTRL, &port->regs->core_control);
 	udelay(50);
 
-	if (np) {
-		phydev = of_phy_get_and_connect(ndev, np, ixp4xx_adjust_link);
-	} else {
-		phydev = mdiobus_get_phy(mdio_bus, plat->phy);
-		if (!phydev) {
-			err = -ENODEV;
-			dev_err(dev, "could not connect phydev (%d)\n", err);
-			goto err_free_mem;
-		}
-		err = phy_connect_direct(ndev, phydev, ixp4xx_adjust_link,
-					 PHY_INTERFACE_MODE_MII);
-		if (err)
-			goto err_free_mem;
-
-	}
+	phydev = of_phy_get_and_connect(ndev, np, ixp4xx_adjust_link);
 	if (!phydev) {
 		err = -ENODEV;
 		dev_err(dev, "no phydev\n");
diff --git a/include/linux/platform_data/eth_ixp4xx.h b/include/linux/platform_data/eth_ixp4xx.h
deleted file mode 100644
index 114b0940729f..000000000000
--- a/include/linux/platform_data/eth_ixp4xx.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __PLATFORM_DATA_ETH_IXP4XX
-#define __PLATFORM_DATA_ETH_IXP4XX
-
-#include <linux/types.h>
-
-#define IXP4XX_ETH_NPEA		0x00
-#define IXP4XX_ETH_NPEB		0x10
-#define IXP4XX_ETH_NPEC		0x20
-
-/* Information about built-in Ethernet MAC interfaces */
-struct eth_plat_info {
-	u8 phy;		/* MII PHY ID, 0 - 31 */
-	u8 rxq;		/* configurable, currently 0 - 31 only */
-	u8 txreadyq;
-	u8 hwaddr[6];
-	u8 npe;		/* NPE instance used by this interface */
-	bool has_mdio;	/* If this instance has an MDIO bus */
-};
-
-#endif
-- 
2.34.1

