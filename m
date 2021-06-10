Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C5E3A310F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhFJQoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:44:18 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:41505 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhFJQnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:43:45 -0400
Received: by mail-ej1-f52.google.com with SMTP id ho18so191134ejc.8;
        Thu, 10 Jun 2021 09:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjkqTURZcurLq7jUGUIyX7EynFbeWen/UMWsVgV3fKg=;
        b=cTpMc8jCE9xA8gcBZpV/laGcmSvfQK3/zLSvJRRa/LuR7xxJE4gn15+M/0/IFgg4AI
         fz9Hex/ZLp8rbn92FXt2tapsLYWXHsUl4+YjhJTOsBYlnqSQZdR4N4bJy3ad7JZo1sfO
         p0jpAg49x53M7TMyO6fE4DPL3r8iEbCkDbvZdoz2sj7ExMINwDyHcnqfMNfnNfhFgkAI
         5NCXAFP/QA3+Hdx/VEmbB/MtxWuTewaxzpbSWUH2JkvNnsmnQhQ3irzYmhyyKa86mPTZ
         XChXStoNtCnPimL9DRzsZ08c/JmstHLShtpu+ITwhbHy9wIGqxKsIRv7QpCLxIAQ+mIU
         cROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjkqTURZcurLq7jUGUIyX7EynFbeWen/UMWsVgV3fKg=;
        b=Vlup4JTxbwUHdyyxlAca6Yew9tTfUOiT36J7HV4tYM4CPu6bkUdL5RTXr8IOkLQSF9
         I12n+dWA1KcCscR2JbIaZ9a8f61Xqz9UW3Au91nEfy5Q1IroTYgRmIRWTsf/eDm7baZ5
         nP0RXxEgtI7WEfs61KjESK3hHQ3o13aYcs6QbBVWlw2OcXRFUhy1dVu0TUeAItssQbNU
         TvV63VWScjXWVggEn5fZk6mzcQLnV393sR1dO3u9EfUVFjEm9TMxm8zi4zaSJ9RWRfJR
         leD5ayK5uAIvqekT1lF5Ln4ytv7UDW0evawovlNaUoHK1j4aCidlcXSAcWgizZIfkKHl
         xzLg==
X-Gm-Message-State: AOAM532xD8kp0ORr3oXuxS72MnsRq25g1CS1IbQQlZ3aFRI0phZLRnuP
        DNKgnB3egt+LFJWpp/Resmo=
X-Google-Smtp-Source: ABdhPJyDIC3eLsbUKMaH2OPVPIW4L3pqRfdNlX77J3xTS/RFImBYy9jKRfsXYFs6JHtEUFOToqBLlQ==
X-Received: by 2002:a17:906:82c3:: with SMTP id a3mr477659ejy.230.1623343240314;
        Thu, 10 Jun 2021 09:40:40 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:40 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Grant Likely <grant.likely@arm.com>,
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
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v8 12/15] net/fsl: Use [acpi|of]_mdiobus_register
Date:   Thu, 10 Jun 2021 19:39:14 +0300
Message-Id: <20210610163917.4138412-13-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Depending on the device node type, call the specific OF or ACPI
mdiobus_register function.

Note: For both ACPI and DT cases, endianness of MDIO controller
need to be specified using "little-endian" property.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

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

