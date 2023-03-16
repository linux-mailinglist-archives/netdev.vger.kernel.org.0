Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA4F6BDCEF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCPXdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCPXd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:33:29 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D688EB5B5E;
        Thu, 16 Mar 2023 16:33:27 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so3244932pjb.0;
        Thu, 16 Mar 2023 16:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679009607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4K0Alwze5WVk+SyveUpIJIy4H5vU2BjyURw6e2he+A=;
        b=kVJaCl5u8yTAc3z47TfaSigSgSiadKLEbNWni/pksuix4OqOgDIe9Y6lkOaaEzV8X2
         A6Ns9pIBYE5yutwSKC/OUG4qQzp4iOBqkDTxgyXbzJjfQzjaoiw+378H5dYAZXMsgJ+x
         6xAwK1NS6wP2sh0ejPq4uPhDo6vtSosjFmg1yUW+9YQSE2zgvocJYEDmAoLnHqM1nA9w
         nJxU8j1A9feRvksdzp3lhy70TV73z3yHCpO+dho3xRGXRx1EHpReooaMq8He7f9Whdbg
         HVCXll4f8rccBfHtgb9e0RN9AqKOW3whfqbbDhhbN38buJNNj9KRx13X6ouxAsjwTsCB
         Qe7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679009607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4K0Alwze5WVk+SyveUpIJIy4H5vU2BjyURw6e2he+A=;
        b=XAuP95yWekQoP4g6gw6Lb4jlg3T/LH+KXvdYvvEJLo3S+R5qPvWnYw8c7BeRq5TCmo
         ARScxFGdDeG4m6sEZE6bNcCwKzdHXWV+Q+KpxcCJGMFTOTRUTHzmVb1Btr08UiMYtuf6
         0/bhsZXArNWI2ry7A5zzs/3Aph77eusIccpoQ7D4FrFopP7ZkHJKFCqPWNL49BHK5TXk
         gP+Vc/ZKGRfa5l3NzQE9r8zlCtIL3MWKv1WG8KvR1mmJw0UOUQiDvi6Mq/ke0Vda7zMs
         d0fo1fc7+ZnYoFAweyg997kTuuNeCskBidjy7eLdLUVkYD+bDhjFlSmZsg7FQxNM6j87
         dapw==
X-Gm-Message-State: AO0yUKUnTPkCH80Z0aBIaGNAgimkazspwkRIpnQHAlsTRdhPEJqbYyGm
        TsfxWBBG1n021hHodpX1HngDdiNwApg=
X-Google-Smtp-Source: AK7set92KOAQjcrQ/76znZsyr2swq/77/PX7yGAjQDt7E06HZ5SR8BVr8bKkCe2484UYkfEVnlfr6w==
X-Received: by 2002:a17:902:d4c2:b0:1a1:86b4:7207 with SMTP id o2-20020a170902d4c200b001a186b47207mr5940399plg.2.1679009606741;
        Thu, 16 Mar 2023 16:33:26 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j1-20020a170903024100b0019f3cc3fc99sm260900plh.16.2023.03.16.16.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 16:33:26 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE)
Subject: [PATCH v2 1/2] net: mdio: fix owner field for mdio buses registered using device-tree
Date:   Thu, 16 Mar 2023 16:33:16 -0700
Message-Id: <20230316233317.2169394-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316233317.2169394-1-f.fainelli@gmail.com>
References: <20230316233317.2169394-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

Bus ownership is wrong when using of_mdiobus_register() to register an mdio
bus. That function is not inline, so when it calls mdiobus_register() the wrong
THIS_MODULE value is captured.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Fixes: 90eff9096c01 ("net: phy: Allow splitting MDIO bus/device support from PHYs")
[florian: fix kdoc, added Fixes tag]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/of_mdio.c    | 12 +++++++-----
 drivers/net/phy/mdio_devres.c | 11 ++++++-----
 include/linux/of_mdio.h       | 22 +++++++++++++++++++---
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 510822d6d0d9..1e46e39f5f46 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -139,21 +139,23 @@ bool of_mdiobus_child_is_phy(struct device_node *child)
 EXPORT_SYMBOL(of_mdiobus_child_is_phy);
 
 /**
- * of_mdiobus_register - Register mii_bus and create PHYs from the device tree
+ * __of_mdiobus_register - Register mii_bus and create PHYs from the device tree
  * @mdio: pointer to mii_bus structure
  * @np: pointer to device_node of MDIO bus.
+ * @owner: module owning the @mdio object.
  *
  * This function registers the mii_bus structure and registers a phy_device
  * for each child node of @np.
  */
-int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
+int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
+			  struct module *owner)
 {
 	struct device_node *child;
 	bool scanphys = false;
 	int addr, rc;
 
 	if (!np)
-		return mdiobus_register(mdio);
+		return __mdiobus_register(mdio, owner);
 
 	/* Do not continue if the node is disabled */
 	if (!of_device_is_available(np))
@@ -172,7 +174,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
 
 	/* Register the MDIO bus */
-	rc = mdiobus_register(mdio);
+	rc = __mdiobus_register(mdio, owner);
 	if (rc)
 		return rc;
 
@@ -236,7 +238,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	mdiobus_unregister(mdio);
 	return rc;
 }
-EXPORT_SYMBOL(of_mdiobus_register);
+EXPORT_SYMBOL(__of_mdiobus_register);
 
 /**
  * of_mdio_find_device - Given a device tree node, find the mdio_device
diff --git a/drivers/net/phy/mdio_devres.c b/drivers/net/phy/mdio_devres.c
index b560e99695df..69b829e6ab35 100644
--- a/drivers/net/phy/mdio_devres.c
+++ b/drivers/net/phy/mdio_devres.c
@@ -98,13 +98,14 @@ EXPORT_SYMBOL(__devm_mdiobus_register);
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 /**
- * devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
+ * __devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
  * @dev:	Device to register mii_bus for
  * @mdio:	MII bus structure to register
  * @np:		Device node to parse
+ * @owner:	Owning module
  */
-int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
-			     struct device_node *np)
+int __devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			       struct device_node *np, struct module *owner)
 {
 	struct mdiobus_devres *dr;
 	int ret;
@@ -117,7 +118,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 	if (!dr)
 		return -ENOMEM;
 
-	ret = of_mdiobus_register(mdio, np);
+	ret = __of_mdiobus_register(mdio, np, owner);
 	if (ret) {
 		devres_free(dr);
 		return ret;
@@ -127,7 +128,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 	devres_add(dev, dr);
 	return 0;
 }
-EXPORT_SYMBOL(devm_of_mdiobus_register);
+EXPORT_SYMBOL(__devm_of_mdiobus_register);
 #endif /* CONFIG_OF_MDIO */
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index da633d34ab86..8a52ef2e6fa6 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -14,9 +14,25 @@
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 bool of_mdiobus_child_is_phy(struct device_node *child);
-int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
-int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
-			     struct device_node *np);
+int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
+			  struct module *owner);
+
+static inline int of_mdiobus_register(struct mii_bus *mdio,
+				      struct device_node *np)
+{
+	return __of_mdiobus_register(mdio, np, THIS_MODULE);
+}
+
+int __devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			       struct device_node *np, struct module *owner);
+
+static inline int devm_of_mdiobus_register(struct device *dev,
+					   struct mii_bus *mdio,
+					   struct device_node *np)
+{
+	return __devm_of_mdiobus_register(dev, mdio, np, THIS_MODULE);
+}
+
 struct mdio_device *of_mdio_find_device(struct device_node *np);
 struct phy_device *of_phy_find_device(struct device_node *phy_np);
 struct phy_device *
-- 
2.34.1

