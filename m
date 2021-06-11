Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04423A4098
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhFKK6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:58:17 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:47045 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbhFKK5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:41 -0400
Received: by mail-ej1-f50.google.com with SMTP id he7so3863177ejc.13;
        Fri, 11 Jun 2021 03:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GzH0xLYISJ6Vd/Atl9MgKS6w5X2okzZek72YxwDeWYI=;
        b=iKwdlqzxNZSLbu0xyCxy17Aux6M2F/HwDuxcFSI0O3mkYzJAZh6GTHfVlaJ7QvL2ui
         EzjiEBCKQIzCGr8cjpPgIR515dtXNAoSRLgHELR4k/Az2RNRHo9UtbrEIDDSY98ypVSW
         +SICbnKsFfLkc28HfVxR63DDADv/sVm9VQPKwa4W65hf9mPYykTI3ZGtwtb545SS4DtU
         u8ZWHTyO6hEc/lh38l0AOKTX3cBQ8DKYL7NizhQ1u+NYnsh7M/mN86OurE6X8Qdz8p9V
         //6q1bgxWOKPZG7gZPMw7LTbFALPmRAjjx0Yw1BWszx+OL53OzAzKDbo9Ik417JqRyPZ
         j6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GzH0xLYISJ6Vd/Atl9MgKS6w5X2okzZek72YxwDeWYI=;
        b=jkl4dzXD6M3PdC4uSQ1vyFAAzieBs2HSKxuLENIU+5rIatJnEEPuQxg+7umQWGt82V
         f2ibwMrwLnzlBSsh8Cb8iYjMep3U3boJnmIhFUogQ0O5Gm8W9lIrRPkxa58lnEOLy9Be
         z//WwEpV80c8Hd563r7Cw9PBczBhyZuJYXhhzb64fFJ0Y4mjm22VkAi1X6i+6GjhlnWp
         MwYM4AkfOW8f0Ie+6VjufK8GcJsnQCfle0u0VwnADKATDQmMEMaHHRmKB1YbkOhzIvqs
         aDqB8DXXc/8RTlMXI2PLbOx/uHE3Age+rLri/b6Z58PCb2TLBCwKWTv4AhhpwZV3yvF5
         zgKw==
X-Gm-Message-State: AOAM533K3ZuXR3F055s57rEud3z9Lxhe61+ppeIsD5dpyMmjpDTE79ja
        yW1bmqXw7bYX0hnnwJhr8Ek=
X-Google-Smtp-Source: ABdhPJw1U7gENqByO4ZDMFx43dJ6eDrKaFxi1vEtQlArUOIZDXeV0frebgta8bLKKW+PorQxv/fc1g==
X-Received: by 2002:a17:906:c2d6:: with SMTP id ch22mr3085535ejb.227.1623408882632;
        Fri, 11 Jun 2021 03:54:42 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:54:42 -0700 (PDT)
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
Subject: [PATCH net-next v9 02/15] net: phy: Introduce fwnode_mdio_find_device()
Date:   Fri, 11 Jun 2021 13:53:48 +0300
Message-Id: <20210611105401.270673-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Define fwnode_mdio_find_device() to get a pointer to the
mdio_device from fwnode passed to the function.

Refactor of_mdio_find_device() to use fwnode_mdio_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9: None
Changes in v8: None
Changes in v7:
- correct fwnode_mdio_find_device() description

Changes in v6:
- fix warning for function parameter of fwnode_mdio_find_device()

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None


 drivers/net/mdio/of_mdio.c   | 11 +----------
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  7 +++++++
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 8e97d5b825f5..6ef8b6e40189 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -347,16 +347,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
  */
 struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
-	struct device *d;
-
-	if (!np)
-		return NULL;
-
-	d = bus_find_device_by_of_node(&mdio_bus_type, np);
-	if (!d)
-		return NULL;
-
-	return to_mdio_device(d);
+	return fwnode_mdio_find_device(of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_mdio_find_device);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 495d86b4af7c..dca454b5c209 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2875,6 +2875,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/**
+ * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
+ * @fwnode: pointer to the mdio_device's fwnode
+ *
+ * If successful, returns a pointer to the mdio_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ * The caller should call put_device() on the mdio_device after its use.
+ */
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	struct device *d;
+
+	if (!fwnode)
+		return NULL;
+
+	d = bus_find_device_by_fwnode(&mdio_bus_type, fwnode);
+	if (!d)
+		return NULL;
+
+	return to_mdio_device(d);
+}
+EXPORT_SYMBOL(fwnode_mdio_find_device);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ed332ac92e25..7aa97f4e5387 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1377,10 +1377,17 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
+static inline
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	return 0;
+}
+
 static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-- 
2.31.1

