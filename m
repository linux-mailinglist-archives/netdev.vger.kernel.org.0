Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81EA58203F
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiG0Gnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiG0Gnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:43:43 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1133AE4D
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:41 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id u17so8624425lji.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cJn5eJrQBgo7tuywMv4Py5sc3iuwS0QcYqm0ShMZmnU=;
        b=KnxA90C523PXH75NDyqi2SpJTXCgXziLJQj51RiAra8BA3zLILBIkW7kMXtvY7KVCH
         lWrqBYwwgi9yEWM4wFJo/F3HoaLWLouFvJTq5BYE7KqbyS1/r8Cx3cmXwSMwwVzuSGGD
         BuSJGP9PAzlEyZphLGIIfz9SvWawvpQGhtgpxgJp+UL+JB5WKSTFq48dzeJssdjd1lDA
         zlpDtPXKLM3bRaJtxid1AzlMggIFCMckcDY5afbT8Tm37D53Q5LWuMDuc1NO87uifkfJ
         QLuVS1ih6jhC0S2sxh00U1G+q4f2RS4p5ZgSca9URyrnRiO1gJbh8Lev0MV3bXnspLKu
         aFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cJn5eJrQBgo7tuywMv4Py5sc3iuwS0QcYqm0ShMZmnU=;
        b=L2iyDiSHw9H3e1mqFMa3Ce6dykmF1/pwyIUCF7wXuLxRuDRfVPl1U6DtHHjTpMyn8F
         uMIidICfsxnK8itoL0jN6WqM2A1xFezHdhl8kL4RJofyNjaBewr/2QgXFVyC6RC0Y8Px
         RNgba1quvGDlrkn6GiUZo0jSQ3Jppx4qvCM+JQB1hi5lwgQ4UwAy9O+mZmQVTPb0Gcen
         5TIQPpctrcB6gxS0P148zc5M1WfknVYefl8cMk0EKmItW1lu1DFJZGplBSuIRBJSslXX
         26GcShNJYt3K0PjX6DpIooRpQ1OczL1/7HUbZeJGrwsfu4mMZ4KL6ec67EQIbFaaMR++
         H+iw==
X-Gm-Message-State: AJIora/Z7604ry2lal8yKcRQGOtrUUIOBs8Q2hm8vWj5AZm8I3Ipz16/
        /u73dhEZPn6lSQ0DROg+2dJt2A==
X-Google-Smtp-Source: AGRyM1vYUz1GhQ7qGNoIE2fR7VrH4ISlLslGzu1m/eJZZ89qmboUkipzw9u4TCMeqWdGyKa/ve2pHQ==
X-Received: by 2002:a2e:a287:0:b0:25d:b515:430c with SMTP id k7-20020a2ea287000000b0025db515430cmr7383480lja.358.1658904219726;
        Tue, 26 Jul 2022 23:43:39 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id w19-20020a05651234d300b0048a97a1df02sm1157231lfr.6.2022.07.26.23.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 23:43:39 -0700 (PDT)
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
Subject: [net-next: PATCH v3 1/8] net: phy: fixed_phy: switch to fwnode_ API
Date:   Wed, 27 Jul 2022 08:43:14 +0200
Message-Id: <20220727064321.2953971-2-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220727064321.2953971-1-mw@semihalf.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
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

This patch allows to use fixed_phy driver and its helper
functions without Device Tree dependency, by swtiching from
of_ to fwnode_ API.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/phy_fixed.h   |  6 +--
 drivers/net/mdio/of_mdio.c  |  2 +-
 drivers/net/phy/fixed_phy.c | 39 +++++++-------------
 3 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/include/linux/phy_fixed.h b/include/linux/phy_fixed.h
index 52bc8e487ef7..e3a03494f218 100644
--- a/include/linux/phy_fixed.h
+++ b/include/linux/phy_fixed.h
@@ -10,7 +10,7 @@ struct fixed_phy_status {
 	int asym_pause;
 };
 
-struct device_node;
+struct fwnode_handle;
 struct gpio_desc;
 
 #if IS_ENABLED(CONFIG_FIXED_PHY)
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

