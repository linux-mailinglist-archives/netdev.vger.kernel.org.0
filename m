Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78B220E236
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731437AbgF2VDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731144AbgF2TMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE41C00E3E3
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:26 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so13283897wrw.1
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eVmQOBvXDEaCTQLZaTTLEM9yQEsfq0hXc2Ftz5NNRNk=;
        b=OjFhA1dnSrFI1gIICDBzM2SLLegg0XEeK2w3+ih4lI+BQ9GqcJIYdUku4UBlwpSaRZ
         oWeFaIwiKUGZrfqHnMCp9dhJCf92zn+eTig0GGSBlC3KsWknJDmoO6tgZILVJZUcl+yC
         QmWi46Gfv5bIDFKLrFhkdsZRMQrJ6P6qJpFqKDDhSzEAk71TG51e5m7PqmRxSF0IaqCc
         lK9LD+XqZqQRHrKSXKSdHC/hs9aTw8jxruL4o0utD0y5ZWsfoLkJ7uHtuUFgXQu8el/Z
         IZFO4cHhlix+pszDjPZAgsLlvEXWJMjb1djS9n8VbDBxifgDwWlHj5nio1tnagKzkQpq
         nW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eVmQOBvXDEaCTQLZaTTLEM9yQEsfq0hXc2Ftz5NNRNk=;
        b=LLHLEM+3D/alfFt7J5Q/tvXacqvLxZpRQnK6n2wnI6r6g7OOzlT1IZdoF6Y0/+PwhS
         +BlkjiU2uHV2dbV0KMCDQOnQqYeW317rScR83mJKOAOEFPM6YpVeZLo7wuxmFhclEpIc
         DvTtIRpA90AmQfcSwywbDFjGhcQOGqNPVeZcUL02lT7b8PD+dQZONklEFz3xXQleMugI
         GcfHcpHHeZ0cWMUa+/+/kOjc5zOekCDlLVa+1vlEmPdJuxQ7LHN2ol8ICmuoy70I+GWP
         iEtkIf3TPxXQLczctQZL7qzGhoLUklFwSIMwgaUxGJ11HI2zW3nkOXsAh5PHgLUjYLQ5
         F/xg==
X-Gm-Message-State: AOAM532s52JsZW4Mssy4LoUUzNNeLiVzxBAWrq/FG2q1QXZbfuajSzVJ
        J6cm/hxSi/DFnrrIchelYjKmPQ==
X-Google-Smtp-Source: ABdhPJygWkINqtaUiia5EDfNIDWDJjLM7/a2wl0W+j+uTircW3QIDYx940S5jXAlZA8pQbi4TXQ8rw==
X-Received: by 2002:adf:84e2:: with SMTP id 89mr17420797wrg.139.1593432265315;
        Mon, 29 Jun 2020 05:04:25 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id d81sm25274347wmc.0.2020.06.29.05.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 05:04:24 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 09/10] of: mdio: provide devm_of_mdiobus_register()
Date:   Mon, 29 Jun 2020 14:03:45 +0200
Message-Id: <20200629120346.4382-10-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200629120346.4382-1-brgl@bgdev.pl>
References: <20200629120346.4382-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Implement a managed variant of of_mdiobus_register(). We need to make
mdio_devres into its own module because otherwise we'd hit circular
sumbol dependencies between phylib and of_mdio.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../driver-api/driver-model/devres.rst        |  1 +
 drivers/net/phy/Makefile                      |  4 +-
 drivers/net/phy/mdio_devres.c                 | 37 +++++++++++++++++++
 include/linux/of_mdio.h                       |  3 ++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index e0333d66a7f4..eaaaafc21134 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -343,6 +343,7 @@ MDIO
   devm_mdiobus_alloc()
   devm_mdiobus_alloc_size()
   devm_mdiobus_register()
+  devm_of_mdiobus_register()
 
 MEM
   devm_free_pages()
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 896afdcac437..c9a9adf194d5 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -3,7 +3,8 @@
 
 libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o \
 				   linkmode.o
-mdio-bus-y			+= mdio_bus.o mdio_device.o mdio_devres.o
+mdio-bus-y			+= mdio_bus.o mdio_device.o
+mdio-devres-y			+= mdio_devres.o
 
 ifdef CONFIG_MDIO_DEVICE
 obj-y				+= mdio-boardinfo.o
@@ -17,6 +18,7 @@ libphy-y			+= $(mdio-bus-y)
 else
 obj-$(CONFIG_MDIO_DEVICE)	+= mdio-bus.o
 endif
+obj-$(CONFIG_MDIO_DEVICE)	+= mdio-devres.o
 libphy-$(CONFIG_SWPHY)		+= swphy.o
 libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
 
diff --git a/drivers/net/phy/mdio_devres.c b/drivers/net/phy/mdio_devres.c
index 0b9bd9a61378..b560e99695df 100644
--- a/drivers/net/phy/mdio_devres.c
+++ b/drivers/net/phy/mdio_devres.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
 #include <linux/device.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/stddef.h>
 
@@ -94,3 +95,39 @@ int __devm_mdiobus_register(struct device *dev, struct mii_bus *bus,
 	return 0;
 }
 EXPORT_SYMBOL(__devm_mdiobus_register);
+
+#if IS_ENABLED(CONFIG_OF_MDIO)
+/**
+ * devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
+ * @dev:	Device to register mii_bus for
+ * @mdio:	MII bus structure to register
+ * @np:		Device node to parse
+ */
+int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			     struct device_node *np)
+{
+	struct mdiobus_devres *dr;
+	int ret;
+
+	if (WARN_ON(!devres_find(dev, devm_mdiobus_free,
+				 mdiobus_devres_match, mdio)))
+		return -EINVAL;
+
+	dr = devres_alloc(devm_mdiobus_unregister, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	ret = of_mdiobus_register(mdio, np);
+	if (ret) {
+		devres_free(dr);
+		return ret;
+	}
+
+	dr->mii = mdio;
+	devres_add(dev, dr);
+	return 0;
+}
+EXPORT_SYMBOL(devm_of_mdiobus_register);
+#endif /* CONFIG_OF_MDIO */
+
+MODULE_LICENSE("GPL");
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index ba8e157f24ad..1efb88d9f892 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -8,12 +8,15 @@
 #ifndef __LINUX_OF_MDIO_H
 #define __LINUX_OF_MDIO_H
 
+#include <linux/device.h>
 #include <linux/phy.h>
 #include <linux/of.h>
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 bool of_mdiobus_child_is_phy(struct device_node *child);
 int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
+int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			     struct device_node *np);
 struct phy_device *of_phy_find_device(struct device_node *phy_np);
 struct phy_device *
 of_phy_connect(struct net_device *dev, struct device_node *phy_np,
-- 
2.26.1

