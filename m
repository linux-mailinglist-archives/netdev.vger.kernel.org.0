Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B226549D6E3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiA0Ajk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiA0Ajk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:39:40 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B713CC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:39:39 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id t14so1897477ljh.8
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F8Xah5G+DfbdEFyTYM82ikBKa0bVRidgPx7uFezw4qY=;
        b=jVTyPizGJ5ZnKV2Ay9FmF86Ut3fsCB18VbISh4AMv/zavehTzXz+sEbRDRCAWcoH5k
         /e+xuc6zYXuCX17GP+w6guDEq0n5d60KLlDYyV+wtH/eq5PvuoCiFPrIViwsqAJUIIvc
         FB8CLCBNXWdvAWFBAwgR2v9SeLTuQIj6xx5x1eH7N/vvr1v+dMA8jBdaA7arQKTgv0vr
         eGuLot9KJ7TJM0Ba42me1mQbwUEiO8pgG3CHiZ/0ZE+5q0rjkiNepTI/ECiLTrkm0lGY
         ocrlOkJ4le6T5qpRLLjNI4K16O3GlbrPeYp0T7BXmaxRYj6jC03CFjqIZN3aaoYfy0Tw
         JOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F8Xah5G+DfbdEFyTYM82ikBKa0bVRidgPx7uFezw4qY=;
        b=aI9Zo8iUYAdJozuIWhmECtUVl+sCqSmiQw3B/tDOS1SAcw8sfNRkgYerere7n1Drwh
         FZNFomplxFYrinLb1BKFnCJo07Fc+5kwl3Za14FGIv5cplSVLIvIjZ+oyXvhuY2US2TY
         DFkzQRX5dUi8qAXfoCWwhgVe2SKa2WDjn1dawb1jO4t591k1xiC6HNdeAa5eVn61uNYI
         FLc53SY493QoFdRPaUFhdb1CuJ+dVIZutQcX3rjXn+7gnh4l7/GTFIJ124NY5NwDv1rq
         7v1zcjPr+5KGY9uNlIKcuftX34V//yXLQbPIv3zPdOO6+EeKDkHhrjVNYeJ043F0VtSI
         5I1A==
X-Gm-Message-State: AOAM530UILy3JpKksHGRshGMLQqyqBQ/Mqr57+wju6UHc+R7SUsQ+VM0
        oBS4vJpNTaej8gpNIr6XV8Bs3w==
X-Google-Smtp-Source: ABdhPJzcGi98cszV+Y5HNdqKocofW2MNy3wTCNuLLHyE8r0/RZpU/6RxXblFfQ29ncoO6qmrgWerTw==
X-Received: by 2002:a2e:bc29:: with SMTP id b41mr1244018ljf.42.1643243978101;
        Wed, 26 Jan 2022 16:39:38 -0800 (PST)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id y28sm1989701lfa.226.2022.01.26.16.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:39:37 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 08/13] net: ixp4xx_eth: Drop platform data support
Date:   Thu, 27 Jan 2022 01:36:51 +0100
Message-Id: <20220127003656.330161-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127003656.330161-1-linus.walleij@linaro.org>
References: <20220127003656.330161-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Network maintainers: I'm looking for an ACK to take this
change through ARM SoC along with other changes removing
these accessor functions.
---
 drivers/net/ethernet/xscale/Kconfig      |  4 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 69 +++++++-----------------
 include/linux/platform_data/eth_ixp4xx.h | 21 --------
 3 files changed, 20 insertions(+), 74 deletions(-)
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
index df77a22d1b81..577a24b3ad70 100644
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

