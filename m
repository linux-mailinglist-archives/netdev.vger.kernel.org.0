Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C4D66CDFB
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbjAPRxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbjAPRwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:52:23 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068CF3B3D0
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:00 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id s25so30711967lji.2
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zEb4lOT+O4pg8nXGe0kZqRkEJZCgvHhijruZskMfGvU=;
        b=dlmINt9wdDatqcnTccEZ9/hR53OWh+oxXX5cJLeZo1u/d6bJ+UNoZEHgBgmogD2WM8
         66VKndzb2dX6JsroREQjsRE6SPWlTACzrUSE+jcDUdhYDF/I2iVrfIaGK+Vj65P5SvZC
         NfRT/Vw19FSIPXHj2IjulhCaQSQQJaNNeKAHP4+2ZofTPVjLVBfgGFq4y8kPKP9f+drF
         9ET7i3oehoHRk5d707PX3l0B2ep3UDVoadZ7RSozuqBhGa0nHrt8S2kfJoVAEwKMqmGA
         3SNq4hJ29rhHfeFmVkjtB4tY6wL4nWrAY+HegdmzdOmMQ7VMIlglnpmoQMjyXn3SXpgx
         Vihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zEb4lOT+O4pg8nXGe0kZqRkEJZCgvHhijruZskMfGvU=;
        b=p6UV58EQysSW7qMhOWI4j7irRH+HDI3CzmEFbsAB81HLlFtn20cRitP+hMHRbqqAtF
         U2xR+10oWx3gfiC+TTBRXMZUO7yk0pYMqYnT2bWyw58QzZKAWScSiaY/LK1UBuZR89E5
         AzfDM400kLMtZLBocwIRaTyt5J1KRRrEgjeJsgsm4qxIEx63FrhLEXYrIrBGQp5OYHjW
         +gMGAtgFJmCWwaTMAmWPVPm0cQancq2Yjauilg2S2yBQ6YL8V0OsoqXyRo8/qhLfIUMZ
         zFimpJMroEJynV8lqJ3lV73bPQu+v+GAkFCmZ1ng6IH5fiWSIVJ8WFTQ7XPoAfjRu2FJ
         vh+g==
X-Gm-Message-State: AFqh2kqB7ahQNIxIO95Bd8pSNUylx0Izqn8JG3cEIJHRmVg/H3RZI4Ei
        kI8aOtSEZlJx97qsE7SdLixqjw==
X-Google-Smtp-Source: AMrXdXsEOa+Vzqq3OenNeL3qmLI1gI2AEgLe399qXt7MFvh/gXSieRTo+VZPpvXMF3DKfZvSP+/hSQ==
X-Received: by 2002:a2e:868e:0:b0:280:2c4e:3d3e with SMTP id l14-20020a2e868e000000b002802c4e3d3emr3321703lji.41.1673890498322;
        Mon, 16 Jan 2023 09:34:58 -0800 (PST)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id k20-20020a2e8894000000b0028b7f51414fsm707333lji.80.2023.01.16.09.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:34:57 -0800 (PST)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, mw@semihalf.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: [net-next: PATCH v4 1/8] net: phy: fixed_phy: switch to fwnode_ API
Date:   Mon, 16 Jan 2023 18:34:13 +0100
Message-Id: <20230116173420.1278704-2-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20230116173420.1278704-1-mw@semihalf.com>
References: <20230116173420.1278704-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to use fixed_phy driver and its helper functions without Device
Tree dependency, by swtiching from of_ to fwnode_ API.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/phy_fixed.h   |  6 +--
 drivers/net/mdio/of_mdio.c  |  2 +-
 drivers/net/phy/fixed_phy.c | 39 +++++++-------------
 3 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/include/linux/phy_fixed.h b/include/linux/phy_fixed.h
index 1acafd86ab13..b3edf0c7c687 100644
--- a/include/linux/phy_fixed.h
+++ b/include/linux/phy_fixed.h
@@ -12,7 +12,7 @@ struct fixed_phy_status {
 	int asym_pause;
 };
 
-struct device_node;
+struct fwnode_handle;
 struct gpio_desc;
 struct net_device;
 
@@ -22,7 +22,7 @@ extern int fixed_phy_add(unsigned int irq, int phy_id,
 			 struct fixed_phy_status *status);
 extern struct phy_device *fixed_phy_register(unsigned int irq,
 					     struct fixed_phy_status *status,
-					     struct device_node *np);
+					     struct fwnode_handle *fwnode);
 
 extern struct phy_device *
 fixed_phy_register_with_gpiod(unsigned int irq,
@@ -41,7 +41,7 @@ static inline int fixed_phy_add(unsigned int irq, int phy_id,
 }
 static inline struct phy_device *fixed_phy_register(unsigned int irq,
 						struct fixed_phy_status *status,
-						struct device_node *np)
+						struct fwnode_handle *fwnode)
 {
 	return ERR_PTR(-ENODEV);
 }
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 510822d6d0d9..ba22b7110cdc 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -423,7 +423,7 @@ int of_phy_register_fixed_link(struct device_node *np)
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

