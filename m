Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23053A40A9
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhFKK7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:59:22 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:43781 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbhFKK62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:58:28 -0400
Received: by mail-ed1-f48.google.com with SMTP id s6so36576171edu.10;
        Fri, 11 Jun 2021 03:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YWiLBG3Lvh9inW6ZMOKYeM9OtMNgaNp+PKI7f1CZHVA=;
        b=DeStVRl3SimU3xbI02C7tHUE3WZXORGnt6MX73Lomy0EVxmPD/d+l6RWX1ApdtVRr4
         JULcJdh/dNrh1WCWLVKeq8zkUVJrMXxZmHmlRs5ETp59HQIF7uy0eHgXuNonoD0dyLNF
         UC5rRDha1Lx9tks1oaOpY02ZGReY19rUeIIGweZEEq3RdWrZ8f2hfKH/8fuJfIDT+Ln2
         IopQtZWQqEhwJhlOGrl1qvnzrBFoVFzjKVAC6vSmLWtl4WtVboRD2x3wTOkJ7AdWPGKM
         8VPWdbfSB1wCR2/Dv/eWuVGMP6Kp95DemTPKcoNjmJ/7KHHWqz6aLQc5zogmpNFFnhCE
         KwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YWiLBG3Lvh9inW6ZMOKYeM9OtMNgaNp+PKI7f1CZHVA=;
        b=RG1BaT0qadmUEkrdj7KkSXcTS4mAShGiLC2tTXvHaAlL19uE4U4re6/SUVlY78VK6h
         JQ/A+qOeEphPX1paxMd3q12pdq2um5+OiszVJKqT3Iqm5saJSrXOGz+Xrk5NxmNjMEPk
         /T29ta4j92px1uG9vo1Js16oLhQh3mxW2F+qZGBo+Syy4ulFOSGY27Sol3Kafy5+iSdi
         npA5zLnMBtN2/sWBs4aGmYZf+ObU8LT9yeaHD25NqUWz4d1sKUU0X+SdgVnJO7o97w/L
         y77D19LtESX6KJ+/Ya5MkWsxTVC2hjzzAZT6AQIcIjth5k40VKeQqXmmiemZp8t9bL5M
         a+oA==
X-Gm-Message-State: AOAM531rAQtHUHTA1L5dzYznEhoGkmHhZB28lPvZJuFl4dnnZXBINF7d
        fRdxdAO/a9Pw8YHXOhfSvBk=
X-Google-Smtp-Source: ABdhPJzDxkhjs1JV/YiAc5XilhGPAtjlZURWiwAWpuumGLhMGt9FPAMPwILNnpgqLW8YRc0BIcySIA==
X-Received: by 2002:a05:6402:1a:: with SMTP id d26mr3068419edu.105.1623408918928;
        Fri, 11 Jun 2021 03:55:18 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:55:18 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v9 12/15] net/fsl: Use [acpi|of]_mdiobus_register
Date:   Fri, 11 Jun 2021 13:53:58 +0300
Message-Id: <20210611105401.270673-13-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Depending on the device node type, call the specific OF or ACPI
mdiobus_register function.

Note: For both ACPI and DT cases, endianness of MDIO controllers
need to be specified using the "little-endian" property.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9: none
Changes in v8:
- Directly call the OF or ACPI variants of registering the MDIO bus.
  This is needed because the fwnode_mdio.c module should only implement
  features which can be achieved without going back to the OF/ACPI
  variants. Without this restrictions we directly end up in a dependency
  cycle: of_mdio -> fwnode_mdio -> of_mdio.
- Changed the commit title since the fwnode_mdiobus_register() is no
  longer available

Changes in v7:
- Include fwnode_mdio.h
- Alphabetically sort header inclusions

Changes in v6: None
Changes in v5: None
Changes in v4:
- Cleanup xgmac_mdio_probe()

Changes in v3:
- Avoid unnecessary line removal
- Remove unused inclusion of acpi.h

Changes in v2: None



 drivers/net/ethernet/freescale/xgmac_mdio.c | 30 ++++++++++++++-------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index bfa2826c5545..0b68852379da 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -2,6 +2,7 @@
  * QorIQ 10G MDIO Controller
  *
  * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2021 NXP
  *
  * Authors: Andy Fleming <afleming@freescale.com>
  *          Timur Tabi <timur@freescale.com>
@@ -11,15 +12,17 @@
  * kind, whether express or implied.
  */
 
-#include <linux/kernel.h>
-#include <linux/slab.h>
+#include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/phy.h>
+#include <linux/kernel.h>
 #include <linux/mdio.h>
+#include <linux/module.h>
 #include <linux/of_address.h>
-#include <linux/of_platform.h>
 #include <linux/of_mdio.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/slab.h>
 
 /* Number of microseconds to wait for a register to respond */
 #define TIMEOUT	1000
@@ -243,10 +246,10 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
-	struct mii_bus *bus;
-	struct resource *res;
+	struct fwnode_handle *fwnode;
 	struct mdio_fsl_priv *priv;
+	struct resource *res;
+	struct mii_bus *bus;
 	int ret;
 
 	/* In DPAA-1, MDIO is one of the many FMan sub-devices. The FMan
@@ -279,13 +282,22 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	/* For both ACPI and DT cases, endianness of MDIO controller
+	 * needs to be specified using "little-endian" property.
+	 */
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
 
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-	ret = of_mdiobus_register(bus, np);
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
-- 
2.31.1

