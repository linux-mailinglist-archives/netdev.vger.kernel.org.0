Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86EC21CB93
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 23:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgGLV3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 17:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728986AbgGLV3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 17:29:23 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFE5C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 14:29:22 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id dg28so10112075edb.3
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 14:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YtkXshMRDtZnJTCSuqd0CYPZ5DgC+eJEt88Y74Xvl5I=;
        b=q0K6rSZ9qgG63RINQ8jXEXp6C/tALaqt0Esd0ZQ4BXAey/AH7qXd0aS+4eHL2+RYC6
         IxrfloXNVW+qh7cTHiukNVxEh0iNc7H6oCain70Z/QmbIRXWapZZZe4KN80w88a4UWDy
         JP1+5rokIjKPvFp7k7IwEnqp8WsCrvySrcEv4XtNyl9rY3+5nYDhjkKTCRlpQtayrZHL
         MPXFl+azxQOyQYJD8IzfRdMWaaqqV3emkiwJZk5T9DIC92eLKLaLRy0T3WMTXzmAlVeg
         rxxkc7i8tLZGhqAH1WqOq177eWXkK/OxHFsAE8pKo9pca+nES7m86Ct+cr34Xys0QvoN
         uRkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YtkXshMRDtZnJTCSuqd0CYPZ5DgC+eJEt88Y74Xvl5I=;
        b=qraQtGQvlTy1gSa01yBE1sanJ5bcg5O+9Rx0VYtXsjcw+yYVZ04BPXXoTbXKevgBN9
         tij/Wqq+wixZVBuUrtX7Fi3Qnt6LTx13gsbRAxS15NRgyMRH+sZDOyRRTK6RCHzCuVFK
         SueneCV1J3naqus9i4ONIU55cTER5erbO5hnsFCX8vZWWf/pMS5raz8G6S0NCYySSMcj
         udeuOUG2+21V4UxN4urmaTb3XB9T6YX+e/BwepFt5A1Tl73Noaz03Fh8PBQOoRlv/HQB
         T4v8lXQmLxqFpBcB8wLQMBiQLiq2H9Q6+Qe4OHmdWpbvlgo3v3wRfWTywlSUxQPlmvuN
         WBCw==
X-Gm-Message-State: AOAM532dYUSebvCd0iGBAPi+l1TtrcNeKAhJ9sIKUGBfPVy2H/21KV8v
        qumD0BWcMVION5cJFFiUoc8=
X-Google-Smtp-Source: ABdhPJxNd0tDvATB1FAe/aDDuwMiLI00lqZGj3lVQA3xMRZLZFg5lHet4/OC7qsBc80vW9BkLBVXkQ==
X-Received: by 2002:a05:6402:2064:: with SMTP id bd4mr86025595edb.180.1594589361518;
        Sun, 12 Jul 2020 14:29:21 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id u13sm9860781eds.10.2020.07.12.14.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 14:29:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        kuba@kernel.org
Subject: [PATCH net-next] net: mscc: ocelot: rethink Kconfig dependencies again
Date:   Mon, 13 Jul 2020 00:28:33 +0300
Message-Id: <20200712212833.1892437-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Having the users of MSCC_OCELOT_SWITCH_LIB depend on REGMAP_MMIO was a
bad idea, since that symbol is not user-selectable. So we should have
kept a 'select REGMAP_MMIO'.

When we do that, we run into 2 more problems:

- By depending on GENERIC_PHY, we are causing a recursive dependency.
  But it looks like GENERIC_PHY has no other dependencies, and other
  drivers select it, so we can select it too:

drivers/of/Kconfig:69:error: recursive dependency detected!
drivers/of/Kconfig:69:  symbol OF_IRQ depends on IRQ_DOMAIN
kernel/irq/Kconfig:68:  symbol IRQ_DOMAIN is selected by REGMAP
drivers/base/regmap/Kconfig:7:  symbol REGMAP default is visible depending on REGMAP_MMIO
drivers/base/regmap/Kconfig:39: symbol REGMAP_MMIO is selected by MSCC_OCELOT_SWITCH_LIB
drivers/net/ethernet/mscc/Kconfig:15:   symbol MSCC_OCELOT_SWITCH_LIB is selected by MSCC_OCELOT_SWITCH
drivers/net/ethernet/mscc/Kconfig:22:   symbol MSCC_OCELOT_SWITCH depends on GENERIC_PHY
drivers/phy/Kconfig:8:  symbol GENERIC_PHY is selected by PHY_BCM_NS_USB3
drivers/phy/broadcom/Kconfig:41:        symbol PHY_BCM_NS_USB3 depends on MDIO_BUS
drivers/net/phy/Kconfig:13:     symbol MDIO_BUS depends on MDIO_DEVICE
drivers/net/phy/Kconfig:6:      symbol MDIO_DEVICE is selected by PHYLIB
drivers/net/phy/Kconfig:254:    symbol PHYLIB is selected by ARC_EMAC_CORE
drivers/net/ethernet/arc/Kconfig:19:    symbol ARC_EMAC_CORE is selected by ARC_EMAC
drivers/net/ethernet/arc/Kconfig:25:    symbol ARC_EMAC depends on OF_IRQ

- By depending on PHYLIB, we are causing a recursive dependency. PHYLIB
  only has a single dependency, "depends on NETDEVICES", which we are
  already depending on, so we can again hack our way into conformance by
  turning the PHYLIB dependency into a select.

drivers/of/Kconfig:69:error: recursive dependency detected!
drivers/of/Kconfig:69:  symbol OF_IRQ depends on IRQ_DOMAIN
kernel/irq/Kconfig:68:  symbol IRQ_DOMAIN is selected by REGMAP
drivers/base/regmap/Kconfig:7:  symbol REGMAP default is visible depending on REGMAP_MMIO
drivers/base/regmap/Kconfig:39: symbol REGMAP_MMIO is selected by MSCC_OCELOT_SWITCH_LIB
drivers/net/ethernet/mscc/Kconfig:15:   symbol MSCC_OCELOT_SWITCH_LIB is selected by MSCC_OCELOT_SWITCH
drivers/net/ethernet/mscc/Kconfig:22:   symbol MSCC_OCELOT_SWITCH depends on PHYLIB
drivers/net/phy/Kconfig:254:    symbol PHYLIB is selected by ARC_EMAC_CORE
drivers/net/ethernet/arc/Kconfig:19:    symbol ARC_EMAC_CORE is selected by ARC_EMAC
drivers/net/ethernet/arc/Kconfig:25:    symbol ARC_EMAC depends on OF_IRQ

Fixes: f4d0323bae4e ("net: mscc: ocelot: convert MSCC_OCELOT_SWITCH into a library")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig    | 1 -
 drivers/net/ethernet/mscc/Kconfig | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 3d3c2a6fb0c0..1788297f6bc6 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -5,7 +5,6 @@ config NET_DSA_MSCC_FELIX
 	depends on NET_VENDOR_MICROSEMI
 	depends on NET_VENDOR_FREESCALE
 	depends on HAS_IOMEM
-	depends on REGMAP_MMIO
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index 3cfd1b629886..ee7bb7e24e8e 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -11,8 +11,10 @@ config NET_VENDOR_MICROSEMI
 
 if NET_VENDOR_MICROSEMI
 
-# Users should depend on NET_SWITCHDEV, HAS_IOMEM, PHYLIB and REGMAP_MMIO
+# Users should depend on NET_SWITCHDEV, HAS_IOMEM
 config MSCC_OCELOT_SWITCH_LIB
+	select REGMAP_MMIO
+	select PHYLIB
 	tristate
 	help
 	  This is a hardware support library for Ocelot network switches. It is
@@ -21,12 +23,10 @@ config MSCC_OCELOT_SWITCH_LIB
 config MSCC_OCELOT_SWITCH
 	tristate "Ocelot switch driver"
 	depends on NET_SWITCHDEV
-	depends on GENERIC_PHY
-	depends on REGMAP_MMIO
 	depends on HAS_IOMEM
-	depends on PHYLIB
 	depends on OF_NET
 	select MSCC_OCELOT_SWITCH_LIB
+	select GENERIC_PHY
 	help
 	  This driver supports the Ocelot network switch device as present on
 	  the Ocelot SoCs (VSC7514).
-- 
2.25.1

