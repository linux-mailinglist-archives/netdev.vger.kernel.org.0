Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA36552000
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242560AbiFTPMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242175AbiFTPMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:07 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386BB13FAD
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:47 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id b23so3654725ljh.7
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=odsCatuXRn3NiFBtyBRCzHVor61VJmIiPLvNMLhLp6I=;
        b=aZ2SA144QSpo6RHPerj2ftJyZhKtwm1sbmaAaXQeL8x/+FjvAw1MuVtdCiO1orB+c5
         PssXfydj1OxhxMzSx5OEdScZJfG+HvDkJxx5WkSBG4es+EcPWMncU9JqCqrPGSPMTcbz
         muMw85qeCuumFnWW1OKyMMbnPM1C4Rix+jVgu0ta9mx2SRKIU4hEpsivzXa6TzH4xyW/
         cwOez0dj6qOpr7ErEML5XyhVBcRzLLN5mwunrciIkU1gTa8ys3ekZ4fh0LNrNwudQghn
         ivCGgNJK73nka/wA1n8QIfPFx96JR/3yPdqHxwR+Nd53rGfsrImCxuN9gJ2ixjmVIk/G
         ru5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=odsCatuXRn3NiFBtyBRCzHVor61VJmIiPLvNMLhLp6I=;
        b=goMzX4Wlk68EYsS/X1TKTi9GEDwVMwguKUpVYdu768JyMSR8wVQLNxivNAbteZDApN
         X1O7sIgYKeAYAd+gJcK1IvewjhqdaWM5sRSMpsaezNFqgAUcIHRaKMkCOlorGI5pS09O
         pbEu6hfuh+i6hKnSsR6+ZLaYVYDY8Ln1P7/lNCKX1+MCNfL+S+7/7UBzi9RcpjZI9MY0
         PXIRJJa2HDThZYOKqmZnm2GFCFVpop5ENZu5YYeGIMlCoA1pEIyt1z8eyoVdeUTfxG+o
         GQRT0a8UXs103w0VPIL6neobrKEwWr+OfIKwk0+SUp7rvEb9eTw/3mD3kdm8ax3Odk7F
         OdXg==
X-Gm-Message-State: AJIora9ToMVLCCdpFGH2KJ+vqj7d58UlqcN8NJ2/MwPg6LtS9rIZJVyJ
        BcJP4XQ3iF2erwK8qVw7Hlu1wA==
X-Google-Smtp-Source: AGRyM1uVExzZpk82Zbw+UxgYL4S8+8n1cDZH0dX8WGn051iDAvPPamQIsf6HPyuEmJXNRZSVdWgdJA==
X-Received: by 2002:a05:651c:b29:b0:255:6ecc:96f with SMTP id b41-20020a05651c0b2900b002556ecc096fmr11849054ljr.176.1655737365366;
        Mon, 20 Jun 2022 08:02:45 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:44 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        lenb@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH 01/12] net: phy: fixed_phy: switch to fwnode_ API
Date:   Mon, 20 Jun 2022 17:02:14 +0200
Message-Id: <20220620150225.1307946-2-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 include/linux/phy_fixed.h   |  4 +--
 drivers/net/mdio/of_mdio.c  |  2 +-
 drivers/net/phy/fixed_phy.c | 37 ++++++++------------
 3 files changed, 18 insertions(+), 25 deletions(-)

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
index aef739c20ac4..0dbe6c344b05 100644
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
@@ -186,16 +186,15 @@ static void fixed_phy_del(int phy_addr)
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
+	if (!fwnode)
 		return NULL;
 
-	fixed_link_node = of_get_child_by_name(np, "fixed-link");
+	fixed_link_node = fwnode_get_named_child_node(fwnode, "fixed-link");
 	if (!fixed_link_node)
 		return NULL;
 
@@ -204,7 +203,7 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
 	 * Linux device associated with it, we simply have obtain
 	 * the GPIO descriptor from the device tree like this.
 	 */
-	gpiod = fwnode_gpiod_get_index(of_fwnode_handle(fixed_link_node),
+	gpiod = fwnode_gpiod_get_index(fixed_link_node,
 				       "link", 0, GPIOD_IN, "mdio");
 	if (IS_ERR(gpiod) && PTR_ERR(gpiod) != -EPROBE_DEFER) {
 		if (PTR_ERR(gpiod) != -ENOENT)
@@ -212,20 +211,14 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
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
@@ -238,7 +231,7 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 
 	/* Check if we have a GPIO associated with this fixed phy */
 	if (!gpiod) {
-		gpiod = fixed_phy_get_gpiod(np);
+		gpiod = fixed_phy_get_gpiod(fwnode);
 		if (IS_ERR(gpiod))
 			return ERR_CAST(gpiod);
 	}
@@ -269,8 +262,8 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 		phy->asym_pause = status->asym_pause;
 	}
 
-	of_node_get(np);
-	phy->mdio.dev.of_node = np;
+	fwnode_handle_get(fwnode);
+	phy->mdio.dev.fwnode = fwnode;
 	phy->is_pseudo_fixed_link = true;
 
 	switch (status->speed) {
@@ -299,7 +292,7 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 	ret = phy_device_register(phy);
 	if (ret) {
 		phy_device_free(phy);
-		of_node_put(np);
+		fwnode_handle_put(fwnode);
 		fixed_phy_del(phy_addr);
 		return ERR_PTR(ret);
 	}
@@ -309,9 +302,9 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 
 struct phy_device *fixed_phy_register(unsigned int irq,
 				      struct fixed_phy_status *status,
-				      struct device_node *np)
+				      struct fwnode_handle *fwnode)
 {
-	return __fixed_phy_register(irq, status, np, NULL);
+	return __fixed_phy_register(irq, status, fwnode, NULL);
 }
 EXPORT_SYMBOL_GPL(fixed_phy_register);
 
@@ -327,7 +320,7 @@ EXPORT_SYMBOL_GPL(fixed_phy_register_with_gpiod);
 void fixed_phy_unregister(struct phy_device *phy)
 {
 	phy_device_remove(phy);
-	of_node_put(phy->mdio.dev.of_node);
+	fwnode_handle_put(phy->mdio.dev.fwnode);
 	fixed_phy_del(phy->mdio.addr);
 }
 EXPORT_SYMBOL_GPL(fixed_phy_unregister);
-- 
2.29.0

