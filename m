Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF56D575E23
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiGOIuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiGOIut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:50:49 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13307823B4
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:43 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id d12so6741025lfq.12
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XlwLsPYG5i93bmO2q8/Pe3x/LuD1+PCcBdrlng7Aedg=;
        b=Aj1o6NogwqqstqnVImvNma+KFET4cd1xUCZ3D/txdxgZaP4x6ZIrzqhHH58JH3Dab5
         OI7Z/IIP/MPTsPM0Jj8X4n8f0LbQt0Jn90OuLrJsU2y8VJ1S/FIto6e0ZXcXZt1RRUZg
         ayiaiLmIcwDyihdsgakRfU/q1osN4jh2Q1O04rKFlusckqyUmqN3TMUk8i+rKAIQWT2r
         UBLuMYvpqQsoajxq6rhto9qmFGYPXkHpUNf4WJuw2XxaLq5DWAKxJK3yQ/ziaN6o/FSP
         2iR95EFRSJx/mc8N4SRdojYOqQycKJooAyMPf6RWDpShuUQOzOivJ0JeTjpIvXoDLB1k
         C/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XlwLsPYG5i93bmO2q8/Pe3x/LuD1+PCcBdrlng7Aedg=;
        b=is7umjAqO4bAOETmTwUT9duWBw+ooYSwg636Bvo4kdP5fsufKQPcHEZPyVvexFabn3
         QS1J+H6x+wpHlD+qnGEkkkaNmlmzRDsH2h0z6AWDO50gh09nby4vYtEs3qLGl0BeYQgd
         OLL7YE0zjKZRmhWE+1xA2wuXaqGgU4ilSW8QVRbaPaHJQv2pRwNz8VysXU8a7aME4pTz
         NWeoT/8Q+Yru+3E12gK+plTLT4eR2GScDT2mGWCUljzLbAztMn6myBAaVPuxcu2WZtOA
         NJ58t+tiAwmxxssZmxeS4i4qEGkeQY99g5qP1ML1Lx7boxEqKWAsu4//52HQU1xrTLLn
         a2lA==
X-Gm-Message-State: AJIora+2F5vSk5Ec/FKfcKSPxW9dxuFI5C4ICYZ15DLjqEj2ynwcHCEA
        znddjrZoYMEi/h5CWZfRkoUPpA==
X-Google-Smtp-Source: AGRyM1vWd0JqSFC8cwniB2kMWKofB28D0S+ZE0Hfe8UwLV/npzmuHk/z6XTQOX49HNz+un4V6Ebl/g==
X-Received: by 2002:ac2:4d5c:0:b0:48a:4ac:d0e4 with SMTP id 28-20020ac24d5c000000b0048a04acd0e4mr7770832lfp.519.1657875041312;
        Fri, 15 Jul 2022 01:50:41 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e4-20020a2e9e04000000b0025d773448basm667846ljk.23.2022.07.15.01.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 01:50:40 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH v2 1/8] net: phy: fixed_phy: switch to fwnode_ API
Date:   Fri, 15 Jul 2022 10:50:05 +0200
Message-Id: <20220715085012.2630214-2-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220715085012.2630214-1-mw@semihalf.com>
References: <20220715085012.2630214-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to use fixed_phy driver and its helper
functions without Device Tree dependency, by swtiching from
of_ to fwnode_ API.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/phy_fixed.h   |  4 +-
 drivers/net/mdio/of_mdio.c  |  2 +-
 drivers/net/phy/fixed_phy.c | 39 +++++++-------------
 3 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/include/linux/phy_fixed.h b/include/linux/phy_fixed.h
index 52bc8e487ef7..449a927231ec 100644
--- a/include/linux/phy_fixed.h
+++ b/include/linux/phy_fixed.h
@@ -19,7 +19,7 @@ extern int fixed_phy_add(unsigned int irq, int phy_id,
 			 struct fixed_phy_status *status);
 extern struct phy_device *fixed_phy_register(unsigned int irq,
 					     struct fixed_phy_status *status,
-					     struct device_node *np);
+					     struct fwnode_handle *fwnode);
 
 extern struct phy_device *
 fixed_phy_register_with_gpiod(unsigned int irq,
@@ -38,7 +38,7 @@ static inline int fixed_phy_add(unsigned int irq, int phy_id,
 }
 static inline struct phy_device *fixed_phy_register(unsigned int irq,
 						struct fixed_phy_status *status,
-						struct device_node *np)
+						struct fwnode_handle *fwnode)
 {
 	return ERR_PTR(-ENODEV);
 }
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 9e3c815a070f..d755fe1ecdda 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -421,7 +421,7 @@ int of_phy_register_fixed_link(struct device_node *np)
 	return -ENODEV;
 
 register_phy:
-	return PTR_ERR_OR_ZERO(fixed_phy_register(PHY_POLL, &status, np));
+	return PTR_ERR_OR_ZERO(fixed_phy_register(PHY_POLL, &status, of_fwnode_handle(np)));
 }
 EXPORT_SYMBOL(of_phy_register_fixed_link);
 
diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index aef739c20ac4..e59d186f78e6 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -15,9 +15,9 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
+#include <linux/property.h>
 #include <linux/err.h>
 #include <linux/slab.h>
-#include <linux/of.h>
 #include <linux/gpio/consumer.h>
 #include <linux/idr.h>
 #include <linux/netdevice.h>
@@ -186,16 +186,12 @@ static void fixed_phy_del(int phy_addr)
 	}
 }
 
-#ifdef CONFIG_OF_GPIO
-static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
+static struct gpio_desc *fixed_phy_get_gpiod(struct fwnode_handle *fwnode)
 {
-	struct device_node *fixed_link_node;
+	struct fwnode_handle *fixed_link_node;
 	struct gpio_desc *gpiod;
 
-	if (!np)
-		return NULL;
-
-	fixed_link_node = of_get_child_by_name(np, "fixed-link");
+	fixed_link_node = fwnode_get_named_child_node(fwnode, "fixed-link");
 	if (!fixed_link_node)
 		return NULL;
 
@@ -204,28 +200,21 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
 	 * Linux device associated with it, we simply have obtain
 	 * the GPIO descriptor from the device tree like this.
 	 */
-	gpiod = fwnode_gpiod_get_index(of_fwnode_handle(fixed_link_node),
-				       "link", 0, GPIOD_IN, "mdio");
+	gpiod = fwnode_gpiod_get_index(fixed_link_node, "link", 0, GPIOD_IN, "mdio");
 	if (IS_ERR(gpiod) && PTR_ERR(gpiod) != -EPROBE_DEFER) {
 		if (PTR_ERR(gpiod) != -ENOENT)
 			pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
 			       fixed_link_node);
 		gpiod = NULL;
 	}
-	of_node_put(fixed_link_node);
+	fwnode_handle_put(fixed_link_node);
 
 	return gpiod;
 }
-#else
-static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
-{
-	return NULL;
-}
-#endif
 
 static struct phy_device *__fixed_phy_register(unsigned int irq,
 					       struct fixed_phy_status *status,
-					       struct device_node *np,
+					       struct fwnode_handle *fwnode,
 					       struct gpio_desc *gpiod)
 {
 	struct fixed_mdio_bus *fmb = &platform_fmb;
@@ -238,7 +227,7 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 
 	/* Check if we have a GPIO associated with this fixed phy */
 	if (!gpiod) {
-		gpiod = fixed_phy_get_gpiod(np);
+		gpiod = fixed_phy_get_gpiod(fwnode);
 		if (IS_ERR(gpiod))
 			return ERR_CAST(gpiod);
 	}
@@ -269,8 +258,8 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 		phy->asym_pause = status->asym_pause;
 	}
 
-	of_node_get(np);
-	phy->mdio.dev.of_node = np;
+	fwnode_handle_get(fwnode);
+	device_set_node(&phy->mdio.dev, fwnode);
 	phy->is_pseudo_fixed_link = true;
 
 	switch (status->speed) {
@@ -299,7 +288,7 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 	ret = phy_device_register(phy);
 	if (ret) {
 		phy_device_free(phy);
-		of_node_put(np);
+		fwnode_handle_put(fwnode);
 		fixed_phy_del(phy_addr);
 		return ERR_PTR(ret);
 	}
@@ -309,9 +298,9 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 
 struct phy_device *fixed_phy_register(unsigned int irq,
 				      struct fixed_phy_status *status,
-				      struct device_node *np)
+				      struct fwnode_handle *fwnode)
 {
-	return __fixed_phy_register(irq, status, np, NULL);
+	return __fixed_phy_register(irq, status, fwnode, NULL);
 }
 EXPORT_SYMBOL_GPL(fixed_phy_register);
 
@@ -327,7 +316,7 @@ EXPORT_SYMBOL_GPL(fixed_phy_register_with_gpiod);
 void fixed_phy_unregister(struct phy_device *phy)
 {
 	phy_device_remove(phy);
-	of_node_put(phy->mdio.dev.of_node);
+	fwnode_handle_put(dev_fwnode(&phy->mdio.dev));
 	fixed_phy_del(phy->mdio.addr);
 }
 EXPORT_SYMBOL_GPL(fixed_phy_unregister);
-- 
2.29.0

