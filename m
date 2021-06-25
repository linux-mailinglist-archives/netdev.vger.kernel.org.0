Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9923B41D7
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 12:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhFYKl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 06:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhFYKlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 06:41:55 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98141C061760
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 03:39:34 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a15so7718027lfr.6
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 03:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1JLbEN1TKhcX6p1OYtPD1Zi9vVkvH8zkhA8ECcL2ejY=;
        b=DKf/xYNZ2nh5nqt4QzVC4uXOqBWlKYDEY+ltNsaqEpEP9l+kOCUkfSH0HyZmse3q92
         aCzhzis54jooC+1QzM/ooR50X75/DtXvTjeD8fw+71ZdHxenG/L3pcFhl8AMO8I1Xm8i
         xZwOIZUji5yGV/S5hDkdpEn5SPoawuM2wxwlb16+xVuSjP2psVZXgYSbYyxxV/6dkOtB
         vnGZVHQa94IH6xOIXchx3vah6k+W3jpLT6JobcZ1fOcDgyMcf97vJbMYhQhK4TakF1Ag
         Tfp24EtceRbh+NEytKcZpYO9oJopRdzlIEtH07Z0L92lwlMvflXWp+kpyfWvxdkNE4sv
         nZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1JLbEN1TKhcX6p1OYtPD1Zi9vVkvH8zkhA8ECcL2ejY=;
        b=FTReHNAoaqbYE0eTMWMVaIA70UL8M+bRlwp/M4whsGDhbjHe+K9Ybv6LHP1X/T9wDb
         9yMzNHCdn7W6PJKI+CLAwjKU1/5oA4NlcE7ura2p307YHJ2tMeBpJeg1E0QUp/OSF70K
         p4zB+/mhYrqp2xNg48b8iy+unr/Esn0MG3/jt85ptGGz4Dq1vZm+K/TfH7kOUUag1qB/
         nQ83osRAEBXkv02HIPhMEh79vvHfbD+lyAiwENidj401k6Eo5kcmw7dpgKYhpNFU0grO
         sSHAMRUzeiUbAtVyBmuKIdUYIw583guxgz9v3oZ00uoMEvECIJ79Y4a4xVl6TgotoJyC
         VOzg==
X-Gm-Message-State: AOAM533ZjFwAgBHtdQFfXyktvMpO4cG7PKcGzF0/rtfYFSv/MYL7m7Fb
        IIqGvcMDz0cUqt+VRznoxSblYg==
X-Google-Smtp-Source: ABdhPJyiBoBGGeHRTJdLmgIaGdr9qWi+4S5VWMPTU24b2f9ktoe2IGiWy+Ip1Pxk0RreYXfSJoSC2w==
X-Received: by 2002:a05:6512:15a2:: with SMTP id bp34mr7257061lfb.40.1624617572852;
        Fri, 25 Jun 2021 03:39:32 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id f17sm479884lfl.161.2021.06.25.03.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 03:39:32 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jon@solid-run.com,
        tn@semihalf.com, jaz@semihalf.com, hkallweit1@gmail.com,
        andrew@lunn.ch, nathan@kernel.org, sfr@canb.auug.org.au,
        Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH] net: mdiobus: withdraw fwnode_mdbiobus_register
Date:   Fri, 25 Jun 2021 12:38:53 +0200
Message-Id: <20210625103853.459277-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The newly implemented fwnode_mdbiobus_register turned out to be
problematic - in case the fwnode_/of_/acpi_mdio are built as
modules, a dependency cycle can be observed during the depmod phase of
modules_install, eg.:

depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
depmod: ERROR: Found 2 modules in dependency cycles!

OR:

depmod: ERROR: Cycle detected: acpi_mdio -> fwnode_mdio -> acpi_mdio
depmod: ERROR: Found 2 modules in dependency cycles!

A possible solution could be to rework fwnode_mdiobus_register,
so that to merge the contents of acpi_mdiobus_register and
of_mdiobus_register. However feasible, such change would
be very intrusive and affect huge amount of the of_mdiobus_register
users.

Since there are currently 2 users of ACPI and MDIO
(xgmac_mdio and mvmdio), withdraw the fwnode_mdbiobus_register
and roll back to a simple 'if' condition in affected drivers.

Fixes: 62a6ef6a996f ("net: mdiobus: Introduce fwnode_mdbiobus_register()")
Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/freescale/Kconfig      |  4 +++-
 drivers/net/ethernet/freescale/xgmac_mdio.c | 11 +++++++++--
 drivers/net/ethernet/marvell/mvmdio.c       | 10 ++++++++--
 drivers/net/mdio/fwnode_mdio.c              | 22 ---------------------
 include/linux/fwnode_mdio.h                 | 12 -----------
 5 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 92a390576b88..2d1abdd58fab 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -67,7 +67,9 @@ config FSL_PQ_MDIO
 
 config FSL_XGMAC_MDIO
 	tristate "Freescale XGMAC MDIO"
-	depends on FWNODE_MDIO
+	select PHYLIB
+	depends on OF
+	select OF_MDIO
 	help
 	  This driver supports the MDIO bus on the Fman 10G Ethernet MACs, and
 	  on the FMan mEMAC (which supports both Clauses 22 and 45)
diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 2d99edc8a647..0b68852379da 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/acpi.h>
-#include <linux/fwnode_mdio.h>
+#include <linux/acpi_mdio.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mdio.h>
@@ -246,6 +246,7 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
+	struct fwnode_handle *fwnode;
 	struct mdio_fsl_priv *priv;
 	struct resource *res;
 	struct mii_bus *bus;
@@ -290,7 +291,13 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
+	fwnode = pdev->dev.fwnode;
+	if (is_of_node(fwnode))
+		ret = of_mdiobus_register(bus, to_of_node(fwnode));
+	else if (is_acpi_node(fwnode))
+		ret = acpi_mdiobus_register(bus, fwnode);
+	else
+		ret = -EINVAL;
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 7537ee3f6622..62a97c46fba0 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -18,9 +18,9 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
-#include <linux/fwnode_mdio.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -371,7 +371,13 @@ static int orion_mdio_probe(struct platform_device *pdev)
 		goto out_mdio;
 	}
 
-	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
+	/* For the platforms not supporting DT/ACPI fall-back
+	 * to mdiobus_register via of_mdiobus_register.
+	 */
+	if (is_acpi_node(pdev->dev.fwnode))
+		ret = acpi_mdiobus_register(bus, pdev->dev.fwnode);
+	else
+		ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
 		goto out_mdio;
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index ae0bf71a9932..1becb1a731f6 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -7,10 +7,8 @@
  */
 
 #include <linux/acpi.h>
-#include <linux/acpi_mdio.h>
 #include <linux/fwnode_mdio.h>
 #include <linux/of.h>
-#include <linux/of_mdio.h>
 #include <linux/phy.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
@@ -144,23 +142,3 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	return 0;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
-
-/**
- * fwnode_mdiobus_register - bring up all the PHYs on a given MDIO bus and
- *	attach them to it.
- * @bus: Target MDIO bus.
- * @fwnode: Pointer to fwnode of the MDIO controller.
- *
- * Return values are determined accordingly to acpi_/of_ mdiobus_register()
- * operation.
- */
-int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode)
-{
-	if (is_acpi_node(fwnode))
-		return acpi_mdiobus_register(bus, fwnode);
-	else if (is_of_node(fwnode))
-		return of_mdiobus_register(bus, to_of_node(fwnode));
-	else
-		return -EINVAL;
-}
-EXPORT_SYMBOL(fwnode_mdiobus_register);
diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index f62817c23137..faf603c48c86 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -16,7 +16,6 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr);
 
-int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode);
 #else /* CONFIG_FWNODE_MDIO */
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
@@ -31,17 +30,6 @@ static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 {
 	return -EINVAL;
 }
-
-static inline int fwnode_mdiobus_register(struct mii_bus *bus,
-					  struct fwnode_handle *fwnode)
-{
-	/*
-	 * Fall back to mdiobus_register() function to register a bus.
-	 * This way, we don't have to keep compat bits around in drivers.
-	 */
-
-	return mdiobus_register(bus);
-}
 #endif
 
 #endif /* __LINUX_FWNODE_MDIO_H */
-- 
2.29.0

