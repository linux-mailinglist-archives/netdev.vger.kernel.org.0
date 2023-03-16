Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFF16BDA8C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjCPVEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPVEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:04:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F6AADC2D;
        Thu, 16 Mar 2023 14:04:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x11so1048774pja.5;
        Thu, 16 Mar 2023 14:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679000659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7yA8VLo8AKbbBQoecIxm7AOVLG0SfrQHu8jknsp4Hoo=;
        b=IuUYLDXCTIkKnsYqyH4zx+Qs+q1+8u8X60HKFDUeMefXSXCQ4N2x4vrexiNS34Umw3
         jWfIklVZaD7vMw8o8CS4Zm7sk/HKDviYW6JJkg0OE6yVRPi46k9MmVuP+zsvVb+qV2Gx
         hFFFCa2DL+EXAk2DyqunRsOItmuqNds2J+HejJAYXmpgKS8J7SvDiS6mm3WH55BGv+rS
         MkJmb6ASwbDnn8hf4rNgcxt3ZQSHWuTrvrcq3hP69gVsRz6fR+2dFdlWrMAxCJwkm5M/
         +/oHFnKi9TY4jDTXNwDOo6oGFNg0iTIap95M8i0dLoh1SwC9yHG9bruv9a5NesjG2M07
         uKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679000659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7yA8VLo8AKbbBQoecIxm7AOVLG0SfrQHu8jknsp4Hoo=;
        b=Gt33pzpkhXISa3cyKxudW6dwyZSeSGaMe+U+DBFy6NM1Zn+Ax6L7PoJO2+Npd+xuGR
         iYGxqWn1o7mAd0hqP/fjzR24Y5728Wn/ffyMgP+W1nngswOJKBgQ2PDDEsvJIzfzQBFg
         vGhkIPCtaUWUKGulQv/Rhf/rLARAdg0pLH2VI2jv2DpgAYDZvvpW2ECvT9+MXd5qUgfO
         rfpHXMDTL8fbsKoyd3obT3q/abQ1dew0DD4UFJfO/dn4HYuKKi8eMAzUqo9PSYfCH+AW
         yy3O03wmRMcyeuu9VjhfEOADwkojMMS88m//30yIN2PgJQ7pBCLgjcJNDOcrWGO4bFmG
         HWkg==
X-Gm-Message-State: AO0yUKXDMDf8KQ5GOn4Z2MXiLjG1mpCg1PZliwDa+xnWdKQFf8fIDRTB
        ocgmXzAZ6LGXsIAEB+m2jo5kms/82WY=
X-Google-Smtp-Source: AK7set/y711+igfzIRN1zF9zhjO06cdRULfgd5NdYHrUi2JsIgB7NSBMVPUOR0LHGbt8LuPGV2RYUg==
X-Received: by 2002:a05:6a20:6a0a:b0:d4:156f:45ad with SMTP id p10-20020a056a206a0a00b000d4156f45admr5930353pzk.58.1679000659484;
        Thu, 16 Mar 2023 14:04:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 14-20020aa7914e000000b005e099d7c30bsm106599pfi.205.2023.03.16.14.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 14:04:18 -0700 (PDT)
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
Subject: [PATCH 1/2] net: mdio: fix owner field for mdio buses registered using device-tree
Date:   Thu, 16 Mar 2023 13:53:00 -0700
Message-Id: <20230316205301.2087667-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316205301.2087667-1-f.fainelli@gmail.com>
References: <20230316205301.2087667-1-f.fainelli@gmail.com>
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
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/of_mdio.c    |  9 +++++----
 drivers/net/phy/mdio_devres.c |  8 ++++----
 include/linux/of_mdio.h       | 22 +++++++++++++++++++---
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 510822d6d0d9..9c39a0a0d569 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -146,14 +146,15 @@ EXPORT_SYMBOL(of_mdiobus_child_is_phy);
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
@@ -172,7 +173,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
 
 	/* Register the MDIO bus */
-	rc = mdiobus_register(mdio);
+	rc = __mdiobus_register(mdio, owner);
 	if (rc)
 		return rc;
 
@@ -236,7 +237,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	mdiobus_unregister(mdio);
 	return rc;
 }
-EXPORT_SYMBOL(of_mdiobus_register);
+EXPORT_SYMBOL(__of_mdiobus_register);
 
 /**
  * of_mdio_find_device - Given a device tree node, find the mdio_device
diff --git a/drivers/net/phy/mdio_devres.c b/drivers/net/phy/mdio_devres.c
index b560e99695df..83ff4a91d346 100644
--- a/drivers/net/phy/mdio_devres.c
+++ b/drivers/net/phy/mdio_devres.c
@@ -103,8 +103,8 @@ EXPORT_SYMBOL(__devm_mdiobus_register);
  * @mdio:	MII bus structure to register
  * @np:		Device node to parse
  */
-int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
-			     struct device_node *np)
+int __devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			       struct device_node *np, struct module *owner)
 {
 	struct mdiobus_devres *dr;
 	int ret;
@@ -117,7 +117,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 	if (!dr)
 		return -ENOMEM;
 
-	ret = of_mdiobus_register(mdio, np);
+	ret = __of_mdiobus_register(mdio, np, owner);
 	if (ret) {
 		devres_free(dr);
 		return ret;
@@ -127,7 +127,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
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

