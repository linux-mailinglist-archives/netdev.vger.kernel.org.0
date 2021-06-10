Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A5E3A30EA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhFJQmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhFJQmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:42:37 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A140CC061574;
        Thu, 10 Jun 2021 09:40:23 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l1so203627ejb.6;
        Thu, 10 Jun 2021 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=shfC9D595uDApwpxEXW8RRDC5cbltzSKhmOaalAiSMg=;
        b=QGBpbB+sbXZx4uG7W9s9OIFYCVD0zB0Jw8s6tz2sjm9ezoAHS/NAYZgWrJj7VqJ410
         yqcid0G80rGzmVGzMcl7vkqQ2MeOru5Mr3SZrdB4ojLFAUIEqxOAIpIRmVdpEIHCiTBS
         KzN9MEX1VHIwG9sFymoIK25PaBgGHSkTe3ZONahCai80COKNj614e9bWpq4P/K7s7Ys0
         /AmZ4GPbZE/gVW4SyAAzi6HEdZKypuGW7rN+4+FkDy4BKruynsF5/LGaVcr/1kjDeokt
         e2qW0VTV3grlbQ5PVg/MeqjwzVItY/BjzHeH6zRR0j0PT73gFkdKXHoewTACAx6MfN0E
         XOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=shfC9D595uDApwpxEXW8RRDC5cbltzSKhmOaalAiSMg=;
        b=arXfpbAEdWAc3l5AF+QkbrDmCVU1qEQlE1lqU5w/M8xQnNa6x5uia1R3GimEogUGsI
         55KiC4QPo/4LkI7uXgw3e+Dp83izb4IWFmQkuzmSnzBUoFdDqat2++L0nZ0neHB9uJTv
         KtWPgXtref8EBV+UhdCvOesALigOMVVBL5xgAFUdfa4uH2gfxjcPUcD+MJsN0DkQbDId
         lmABPFyPX3Mw+IzYTfk6r/ESPmknWcWlI+eXDgCv7qcy8x3XVxQr1WoX+kwrfeEGVW0y
         JfF61TYJ8xiYN641hBsy8dt2ghdH8gdi0F1w5HMRPhGAb3QsIlvQtFR5SFK6Fnb+4bUA
         BQ7g==
X-Gm-Message-State: AOAM531ohY5Fuepedng36Mh3HcsP8tpmFXS62Mu23FEsAMY42mPRZla4
        PTJuUlCD9B8nfbo6L2ATYcQ=
X-Google-Smtp-Source: ABdhPJz/zjr86kubhnfYba4VQBUWzENHrxk5/xcSj1PnwyXEDtV6uD6kq3yCQWlvf9t7HCbDOiPe1A==
X-Received: by 2002:a17:906:6d45:: with SMTP id a5mr457515ejt.399.1623343222093;
        Thu, 10 Jun 2021 09:40:22 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:21 -0700 (PDT)
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
Subject: [PATCH net-next v8 03/15] net: phy: Introduce phy related fwnode functions
Date:   Thu, 10 Jun 2021 19:39:05 +0300
Message-Id: <20210610163917.4138412-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Define fwnode_phy_find_device() to iterate an mdiobus and find the
phy device of the provided phy fwnode. Additionally define
device_phy_find_device() to find phy device of provided device.

Define fwnode_get_phy_node() to get phy_node using named reference.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
- Add more info on legacy DT properties "phy" and "phy-device"
- Redefine fwnode_phy_find_device() to follow of_phy_find_device()

Changes in v2:
- use reverse christmas tree ordering for local variables

 drivers/net/phy/phy_device.c | 62 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 20 ++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 363cc70d00ca..f651c4feb49f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -2886,6 +2887,67 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL(fwnode_mdio_find_device);
 
+/**
+ * fwnode_phy_find_device - For provided phy_fwnode, find phy_device.
+ *
+ * @phy_fwnode: Pointer to the phy's fwnode.
+ *
+ * If successful, returns a pointer to the phy_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ */
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	struct mdio_device *mdiodev;
+
+	mdiodev = fwnode_mdio_find_device(phy_fwnode);
+	if (!mdiodev)
+		return NULL;
+
+	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
+		return to_phy_device(&mdiodev->dev);
+
+	put_device(&mdiodev->dev);
+
+	return NULL;
+}
+EXPORT_SYMBOL(fwnode_phy_find_device);
+
+/**
+ * device_phy_find_device - For the given device, get the phy_device
+ * @dev: Pointer to the given device
+ *
+ * Refer return conditions of fwnode_phy_find_device().
+ */
+struct phy_device *device_phy_find_device(struct device *dev)
+{
+	return fwnode_phy_find_device(dev_fwnode(dev));
+}
+EXPORT_SYMBOL_GPL(device_phy_find_device);
+
+/**
+ * fwnode_get_phy_node - Get the phy_node using the named reference.
+ * @fwnode: Pointer to fwnode from which phy_node has to be obtained.
+ *
+ * Refer return conditions of fwnode_find_reference().
+ * For ACPI, only "phy-handle" is supported. Legacy DT properties "phy"
+ * and "phy-device" are not supported in ACPI. DT supports all the three
+ * named references to the phy node.
+ */
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *phy_node;
+
+	/* Only phy-handle is used for ACPI */
+	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
+	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
+		return phy_node;
+	phy_node = fwnode_find_reference(fwnode, "phy", 0);
+	if (IS_ERR(phy_node))
+		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
+	return phy_node;
+}
+EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7aa97f4e5387..f9b5fb099fa6 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1378,6 +1378,9 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
+struct phy_device *device_phy_find_device(struct device *dev);
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
@@ -1388,6 +1391,23 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
 	return 0;
 }
 
+static inline
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	return NULL;
+}
+
+static inline struct phy_device *device_phy_find_device(struct device *dev)
+{
+	return NULL;
+}
+
+static inline
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
+
 static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-- 
2.31.1

