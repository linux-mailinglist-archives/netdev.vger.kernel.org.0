Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A732203443
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgFVKBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgFVKBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:01:20 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDE8C061796
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:20 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id j18so716580wmi.3
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TTj07T08NNZro/U2yWPFP3Dw02nhL5hB1K0t6Vwkyzw=;
        b=umsqc560VgWzO4IFGB8xbm9+eHaBnWiZ8GN88xIPqibz5h05dlWPTFWVVY+f69KlG0
         a4y7K5KJh92xDh9QC/FmqY1WMCLtVijDEi7mmlatAu20aNEY/OkwQAydZfniEo6v19ly
         5UpNecI0rhyx7ljbmoN4ErSxXuJgzG2Pvn5qCM8hJ/gz7PmN8uAxqCEn0FKto6Yw3BQJ
         MwlWbDZgiEh6Bxwf6FJ+KhsXROfVkjFYGLxKZrFtIx6c3oqVOLqL2qrekxNXHOXLjNu7
         HsquwI/7md6BwXsqjVvJhh/XfV1XR78LuXr1JLkx4Xai6QrZExGPdzterXgVwn8Nlu2K
         +Dwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TTj07T08NNZro/U2yWPFP3Dw02nhL5hB1K0t6Vwkyzw=;
        b=ek/RyRDKTPqz3N6MvPt1NA1GZoSPqJVGATU3hoIwR+oklSWozyFZ+MIXRZDlb8irQn
         9h6sRT+qJsCqJjXw7C3RLs6Xe9xaFnk56lM1f1p7I+zQxDrDhKxg3OLaKTT48Tlr54Rs
         BR8B+zoE6LKECjcZD9C++YwJTYEOusdF9BOo8cHFgz1nCga3P0fc0dmBc9YiqYJJBFqH
         U/dMDacs/otVSfnbFjKOIyD/FVUJyKQX8Wo7QvGGQHqGYCzCvdROfS/F5YGLqAfeKBDn
         C7ievyUmBG1tpXpC/mT/1aw9u/MOf9tlqqTGxzz/Ox9t/FmqLDIcI66cVd8hT9rsAJfP
         5w5w==
X-Gm-Message-State: AOAM530z0M+n/pwmmZ6TXwxk2pVgbBWkMqHZ7zJAnYLR1vtfn5VAP7oq
        GTxpOyvouFqvrwdzG900QFEAGA==
X-Google-Smtp-Source: ABdhPJwbtQnwhgQy4/PGrqFbGi4Rm4Vlma7uhso1tRe0BeUVnkpoIf981M/hc/QiwEw6xXi5+FRkFQ==
X-Received: by 2002:a05:600c:2dc1:: with SMTP id e1mr5038382wmh.108.1592820078894;
        Mon, 22 Jun 2020 03:01:18 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id x205sm16822187wmx.21.2020.06.22.03.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:01:18 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 08/11] net: phy: don't abuse devres in devm_mdiobus_register()
Date:   Mon, 22 Jun 2020 12:00:53 +0200
Message-Id: <20200622100056.10151-9-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622100056.10151-1-brgl@bgdev.pl>
References: <20200622100056.10151-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

We currently have two managed helpers for mdiobus - devm_mdiobus_alloc()
and devm_mdiobus_register(). The idea behind devres is that the release
callback releases whatever resource the devm function allocates. In the
mdiobus case however there's no devres associated with the device by
devm_mdiobus_register(). Instead the release callback for
devm_mdiobus_alloc(): _devm_mdiobus_free() unregisters the device if
it is marked as managed.

This all seems wrong. The managed structure shouldn't need to know or
care about whether it's managed or not - and this is the case now for
struct mii_bus. The devres wrapper should be opaque to the managed
resource.

This changeset makes devm_mdiobus_alloc() and devm_mdiobus_register()
conform to common devres standards: devm_mdiobus_alloc() allocates a
devres structure and registers a callback that will call mdiobus_free().
__devm_mdiobus_register() allocated another devres and registers a
callback that will unregister the bus. Similarily to how we modified
devm_register_netdev() - we're not checking whether struct mii_bus is
managed - it could have been allocated as part of a bigger structure.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../driver-api/driver-model/devres.rst        |  1 -
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/phy/mdio_bus.c                    | 73 -------------------
 drivers/net/phy/mdio_devres.c                 | 70 ++++++++++++++++--
 include/linux/phy.h                           | 10 +--
 5 files changed, 69 insertions(+), 87 deletions(-)

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index 5463fc8a60c1..e0333d66a7f4 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -342,7 +342,6 @@ LED
 MDIO
   devm_mdiobus_alloc()
   devm_mdiobus_alloc_size()
-  devm_mdiobus_free()
   devm_mdiobus_register()
 
 MEM
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dad84ecf5a77..34d5797695ba 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5100,7 +5100,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->read = r8169_mdio_read_reg;
 	new_bus->write = r8169_mdio_write_reg;
 
-	ret = devm_mdiobus_register(new_bus);
+	ret = devm_mdiobus_register(&pdev->dev, new_bus);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6ceee82b2839..42192991f55d 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -165,79 +165,6 @@ struct mii_bus *mdiobus_alloc_size(size_t size)
 }
 EXPORT_SYMBOL(mdiobus_alloc_size);
 
-static void _devm_mdiobus_free(struct device *dev, void *res)
-{
-	struct mii_bus *bus = *(struct mii_bus **)res;
-
-	if (bus->is_managed_registered && bus->state == MDIOBUS_REGISTERED)
-		mdiobus_unregister(bus);
-
-	mdiobus_free(bus);
-}
-
-static int devm_mdiobus_match(struct device *dev, void *res, void *data)
-{
-	struct mii_bus **r = res;
-
-	if (WARN_ON(!r || !*r))
-		return 0;
-
-	return *r == data;
-}
-
-/**
- * devm_mdiobus_alloc_size - Resource-managed mdiobus_alloc_size()
- * @dev:		Device to allocate mii_bus for
- * @sizeof_priv:	Space to allocate for private structure.
- *
- * Managed mdiobus_alloc_size. mii_bus allocated with this function is
- * automatically freed on driver detach.
- *
- * If an mii_bus allocated with this function needs to be freed separately,
- * devm_mdiobus_free() must be used.
- *
- * RETURNS:
- * Pointer to allocated mii_bus on success, NULL on failure.
- */
-struct mii_bus *devm_mdiobus_alloc_size(struct device *dev, int sizeof_priv)
-{
-	struct mii_bus **ptr, *bus;
-
-	ptr = devres_alloc(_devm_mdiobus_free, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return NULL;
-
-	/* use raw alloc_dr for kmalloc caller tracing */
-	bus = mdiobus_alloc_size(sizeof_priv);
-	if (bus) {
-		*ptr = bus;
-		devres_add(dev, ptr);
-		bus->is_managed = 1;
-	} else {
-		devres_free(ptr);
-	}
-
-	return bus;
-}
-EXPORT_SYMBOL_GPL(devm_mdiobus_alloc_size);
-
-/**
- * devm_mdiobus_free - Resource-managed mdiobus_free()
- * @dev:		Device this mii_bus belongs to
- * @bus:		the mii_bus associated with the device
- *
- * Free mii_bus allocated with devm_mdiobus_alloc_size().
- */
-void devm_mdiobus_free(struct device *dev, struct mii_bus *bus)
-{
-	int rc;
-
-	rc = devres_release(dev, _devm_mdiobus_free,
-			    devm_mdiobus_match, bus);
-	WARN_ON(rc);
-}
-EXPORT_SYMBOL_GPL(devm_mdiobus_free);
-
 /**
  * mdiobus_release - mii_bus device release callback
  * @d: the target struct device that contains the mii_bus
diff --git a/drivers/net/phy/mdio_devres.c b/drivers/net/phy/mdio_devres.c
index 3ee887733d4a..344d2c748c16 100644
--- a/drivers/net/phy/mdio_devres.c
+++ b/drivers/net/phy/mdio_devres.c
@@ -1,25 +1,83 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#include <linux/device.h>
 #include <linux/phy.h>
+#include <linux/stddef.h>
+
+struct mdiobus_devres {
+	struct mii_bus *mii;
+};
+
+static void devm_mdiobus_free(struct device *dev, void *this)
+{
+	struct mdiobus_devres *dr = this;
+
+	mdiobus_free(dr->mii);
+}
+
+/**
+ * devm_mdiobus_alloc_size - Resource-managed mdiobus_alloc_size()
+ * @dev:		Device to allocate mii_bus for
+ * @sizeof_priv:	Space to allocate for private structure
+ *
+ * Managed mdiobus_alloc_size. mii_bus allocated with this function is
+ * automatically freed on driver detach.
+ *
+ * RETURNS:
+ * Pointer to allocated mii_bus on success, NULL on out-of-memory error.
+ */
+struct mii_bus *devm_mdiobus_alloc_size(struct device *dev, int sizeof_priv)
+{
+	struct mdiobus_devres *dr;
+
+	dr = devres_alloc(devm_mdiobus_free, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return NULL;
+
+	dr->mii = mdiobus_alloc_size(sizeof_priv);
+	if (!dr->mii) {
+		devres_free(dr);
+		return NULL;
+	}
+
+	devres_add(dev, dr);
+	return dr->mii;
+}
+EXPORT_SYMBOL(devm_mdiobus_alloc_size);
+
+static void devm_mdiobus_unregister(struct device *dev, void *this)
+{
+	struct mdiobus_devres *dr = this;
+
+	mdiobus_unregister(dr->mii);
+}
 
 /**
  * __devm_mdiobus_register - Resource-managed variant of mdiobus_register()
+ * @dev:	Device to register mii_bus for
  * @bus:	MII bus structure to register
  * @owner:	Owning module
  *
  * Returns 0 on success, negative error number on failure.
  */
-int __devm_mdiobus_register(struct mii_bus *bus, struct module *owner)
+int __devm_mdiobus_register(struct device *dev, struct mii_bus *bus,
+			    struct module *owner)
 {
+	struct mdiobus_devres *dr;
 	int ret;
 
-	if (!bus->is_managed)
-		return -EPERM;
+	dr = devres_alloc(devm_mdiobus_unregister, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
 
 	ret = __mdiobus_register(bus, owner);
-	if (!ret)
-		bus->is_managed_registered = 1;
+	if (ret) {
+		devres_free(dr);
+		return ret;
+	}
 
-	return ret;
+	dr->mii = bus;
+	devres_add(dev, dr);
+	return 0;
 }
 EXPORT_SYMBOL(__devm_mdiobus_register);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 62149945c5b3..fa6697edefb3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -260,9 +260,6 @@ struct mii_bus {
 	int (*reset)(struct mii_bus *bus);
 	struct mdio_bus_stats stats[PHY_MAX_ADDR];
 
-	unsigned int is_managed:1;	/* is device-managed */
-	unsigned int is_managed_registered:1;
-
 	/*
 	 * A lock to ensure that only one thing can read/write
 	 * the MDIO bus at a time
@@ -313,9 +310,11 @@ static inline struct mii_bus *mdiobus_alloc(void)
 }
 
 int __mdiobus_register(struct mii_bus *bus, struct module *owner);
-int __devm_mdiobus_register(struct mii_bus *bus, struct module *owner);
+int __devm_mdiobus_register(struct device *dev, struct mii_bus *bus,
+			    struct module *owner);
 #define mdiobus_register(bus) __mdiobus_register(bus, THIS_MODULE)
-#define devm_mdiobus_register(bus) __devm_mdiobus_register(bus, THIS_MODULE)
+#define devm_mdiobus_register(dev, bus) \
+		__devm_mdiobus_register(dev, bus, THIS_MODULE)
 
 void mdiobus_unregister(struct mii_bus *bus);
 void mdiobus_free(struct mii_bus *bus);
@@ -326,7 +325,6 @@ static inline struct mii_bus *devm_mdiobus_alloc(struct device *dev)
 }
 
 struct mii_bus *mdio_find_bus(const char *mdio_name);
-void devm_mdiobus_free(struct device *dev, struct mii_bus *bus);
 struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
 
 #define PHY_INTERRUPT_DISABLED	false
-- 
2.26.1

