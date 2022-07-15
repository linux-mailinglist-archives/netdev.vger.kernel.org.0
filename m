Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4E3575E18
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiGOIu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiGOIut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:50:49 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED00823B8
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:44 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id bp17so6791412lfb.3
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1I6Xn/UXiMT6VknV/yDkGje3BjUktQ7ZyDrns9mPDHA=;
        b=tUnGCC/GQIIyy+t0787Awd+rfsuwYSWkGp2De2EmOe1fCjEUbDwof/Q37g0pE6s0DZ
         kZY0Pj//cVOE2vo0ua8cQh0IwvC+G0kaNNX+gsCWKS1xbVxUysDXcpOfrO7wzHXi7QEz
         oX1ggXIy5MVrQe5/GFETbeobhEPaXNg9YWyQlDjcPZEjDqiLq1vqadJF2UwldLrwThqX
         71QvHMkJbqTmUJnMP0FTlO47YRwXjOkTvdx/h8JjvxJqwQbfgHxEMFpKRs+bgm3h8ZQ3
         B6g5D666RYyzhMG8eIlYGuUas47nnEqPlTMIZSdhpAMv2t/n3UB3dUTwjL7x4cPMZ98l
         06vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1I6Xn/UXiMT6VknV/yDkGje3BjUktQ7ZyDrns9mPDHA=;
        b=LPykk8IfdWZF7AOBHNUvuiQogL0KKlIA8dOlTp/UtaXHOYHbM9CSMlMasRY6C4gFzv
         FL5UqrQ7qZMaeM1em6TwnDHVyZYtARkfyGcTj5CopBIjKMIlJczGE1CNPWE1z0rQHzgc
         8diwumaaKs3ViZIogI7D6b63PKQKvRP5eiEzWAZB+mfFpsCPsHWMbZw1bh5ROzETtTci
         N/L+t0k7f/X+wChf5ydYX+CwWSp3Yzg1ZnZH6/rvcimawjj/p4vnfGmYgzhXS/hWDjQI
         1KS43YrxSx78MD5preFZ79f7SeSvgIgQox3S1dOmpEnF8M+jcEp1R5RG003As/E2Otj2
         95FA==
X-Gm-Message-State: AJIora+JqiCz9iQQgVfx1ggtlLZYR5eyoeQlabTJYBnBYqqAA9dSdCZ1
        qZHNBQJ2R3Q4EH60hxOJtZyfWA==
X-Google-Smtp-Source: AGRyM1sT+txbuj8aeOb+S4GbLEviAUKdHHPRLnU1Lw59c82guf+N90aYkPJYVMfC78qi/Enaont8aA==
X-Received: by 2002:a05:6512:505:b0:489:c93d:a95c with SMTP id o5-20020a056512050500b00489c93da95cmr8083214lfb.115.1657875042728;
        Fri, 15 Jul 2022 01:50:42 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e4-20020a2e9e04000000b0025d773448basm667846ljk.23.2022.07.15.01.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 01:50:42 -0700 (PDT)
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
Subject: [net-next: PATCH v2 2/8] net: mdio: switch fixed-link PHYs API to fwnode_
Date:   Fri, 15 Jul 2022 10:50:06 +0200
Message-Id: <20220715085012.2630214-3-mw@semihalf.com>
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

fixed-link PHYs API is used by DSA and a number of drivers
and was depending on of_. Switch to fwnode_ so to make it
hardware description agnostic and allow to be used in ACPI
world as well.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/fwnode_mdio.h    |  19 ++++
 drivers/net/mdio/fwnode_mdio.c | 100 ++++++++++++++++++++
 drivers/net/mdio/of_mdio.c     |  79 +---------------
 3 files changed, 122 insertions(+), 76 deletions(-)

diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index faf603c48c86..98755b8c6c8a 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -16,6 +16,11 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr);
 
+int fwnode_phy_register_fixed_link(struct fwnode_handle *fwnode);
+
+void fwnode_phy_deregister_fixed_link(struct fwnode_handle *fwnode);
+
+bool fwnode_phy_is_fixed_link(struct fwnode_handle *fwnode);
 #else /* CONFIG_FWNODE_MDIO */
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
@@ -30,6 +35,20 @@ static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 {
 	return -EINVAL;
 }
+
+static inline int fwnode_phy_register_fixed_link(struct fwnode_handle *fwnode)
+{
+	return -ENODEV;
+}
+
+static inline void fwnode_phy_deregister_fixed_link(struct fwnode_handle *fwnode)
+{
+}
+
+static inline bool fwnode_phy_is_fixed_link(struct fwnode_handle *fwnode)
+{
+	return false;
+}
 #endif
 
 #endif /* __LINUX_FWNODE_MDIO_H */
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1c1584fca632..454fdae24150 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -10,6 +10,7 @@
 #include <linux/fwnode_mdio.h>
 #include <linux/of.h>
 #include <linux/phy.h>
+#include <linux/phy_fixed.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
@@ -147,3 +148,102 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	return 0;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
+
+/*
+ * fwnode_phy_is_fixed_link() and fwnode_phy_register_fixed_link() must
+ * support two bindings:
+ * - the old binding, where 'fixed-link' was a property with 5
+ *   cells encoding various information about the fixed PHY
+ * - the new binding, where 'fixed-link' is a sub-node of the
+ *   Ethernet device.
+ */
+bool fwnode_phy_is_fixed_link(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *fixed_link_node;
+	const char *managed;
+	int len;
+
+	/* New binding */
+	fixed_link_node = fwnode_get_named_child_node(fwnode, "fixed-link");
+	if (fixed_link_node) {
+		fwnode_handle_put(fixed_link_node);
+		return true;
+	}
+
+	if (fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
+	    strcmp(managed, "auto") != 0)
+		return true;
+
+	/* Old binding */
+	len = fwnode_property_count_u32(fwnode, "fixed-link");
+	if (len == 5)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(fwnode_phy_is_fixed_link);
+
+int fwnode_phy_register_fixed_link(struct fwnode_handle *fwnode)
+{
+	struct fixed_phy_status status = {};
+	struct fwnode_handle *fixed_link_node;
+	u32 fixed_link_prop[5];
+	const char *managed;
+
+	if (fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
+	    strcmp(managed, "in-band-status") == 0) {
+		/* status is zeroed, namely its .link member */
+		goto register_phy;
+	}
+
+	/* New binding */
+	fixed_link_node = fwnode_get_named_child_node(fwnode, "fixed-link");
+	if (fixed_link_node) {
+		status.link = 1;
+		status.duplex = fwnode_property_present(fixed_link_node,
+							"full-duplex");
+		if (fwnode_property_read_u32(fixed_link_node, "speed",
+					     &status.speed)) {
+			fwnode_handle_put(fixed_link_node);
+			return -EINVAL;
+		}
+		status.pause = fwnode_property_present(fixed_link_node, "pause");
+		status.asym_pause = fwnode_property_present(fixed_link_node,
+							    "asym-pause");
+		fwnode_handle_put(fixed_link_node);
+
+		goto register_phy;
+	}
+
+	/* Old binding */
+	if (fwnode_property_read_u32_array(fwnode, "fixed-link", fixed_link_prop,
+					   ARRAY_SIZE(fixed_link_prop)) == 0) {
+		status.link = 1;
+		status.duplex = fixed_link_prop[1];
+		status.speed  = fixed_link_prop[2];
+		status.pause  = fixed_link_prop[3];
+		status.asym_pause = fixed_link_prop[4];
+		goto register_phy;
+	}
+
+	return -ENODEV;
+
+register_phy:
+	return PTR_ERR_OR_ZERO(fixed_phy_register(PHY_POLL, &status, fwnode));
+}
+EXPORT_SYMBOL(fwnode_phy_register_fixed_link);
+
+void fwnode_phy_deregister_fixed_link(struct fwnode_handle *fwnode)
+{
+	struct phy_device *phydev;
+
+	phydev = fwnode_phy_find_device(fwnode);
+	if (!phydev)
+		return;
+
+	fixed_phy_unregister(phydev);
+
+	put_device(&phydev->mdio.dev);	/* fwnode_phy_find_device() */
+	phy_device_free(phydev);	/* fixed_phy_register() */
+}
+EXPORT_SYMBOL(fwnode_phy_deregister_fixed_link);
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index d755fe1ecdda..409da6e92f7d 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -351,91 +351,18 @@ EXPORT_SYMBOL(of_phy_get_and_connect);
  */
 bool of_phy_is_fixed_link(struct device_node *np)
 {
-	struct device_node *dn;
-	int len, err;
-	const char *managed;
-
-	/* New binding */
-	dn = of_get_child_by_name(np, "fixed-link");
-	if (dn) {
-		of_node_put(dn);
-		return true;
-	}
-
-	err = of_property_read_string(np, "managed", &managed);
-	if (err == 0 && strcmp(managed, "auto") != 0)
-		return true;
-
-	/* Old binding */
-	if (of_get_property(np, "fixed-link", &len) &&
-	    len == (5 * sizeof(__be32)))
-		return true;
-
-	return false;
+	return fwnode_phy_is_fixed_link(of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_phy_is_fixed_link);
 
 int of_phy_register_fixed_link(struct device_node *np)
 {
-	struct fixed_phy_status status = {};
-	struct device_node *fixed_link_node;
-	u32 fixed_link_prop[5];
-	const char *managed;
-
-	if (of_property_read_string(np, "managed", &managed) == 0 &&
-	    strcmp(managed, "in-band-status") == 0) {
-		/* status is zeroed, namely its .link member */
-		goto register_phy;
-	}
-
-	/* New binding */
-	fixed_link_node = of_get_child_by_name(np, "fixed-link");
-	if (fixed_link_node) {
-		status.link = 1;
-		status.duplex = of_property_read_bool(fixed_link_node,
-						      "full-duplex");
-		if (of_property_read_u32(fixed_link_node, "speed",
-					 &status.speed)) {
-			of_node_put(fixed_link_node);
-			return -EINVAL;
-		}
-		status.pause = of_property_read_bool(fixed_link_node, "pause");
-		status.asym_pause = of_property_read_bool(fixed_link_node,
-							  "asym-pause");
-		of_node_put(fixed_link_node);
-
-		goto register_phy;
-	}
-
-	/* Old binding */
-	if (of_property_read_u32_array(np, "fixed-link", fixed_link_prop,
-				       ARRAY_SIZE(fixed_link_prop)) == 0) {
-		status.link = 1;
-		status.duplex = fixed_link_prop[1];
-		status.speed  = fixed_link_prop[2];
-		status.pause  = fixed_link_prop[3];
-		status.asym_pause = fixed_link_prop[4];
-		goto register_phy;
-	}
-
-	return -ENODEV;
-
-register_phy:
-	return PTR_ERR_OR_ZERO(fixed_phy_register(PHY_POLL, &status, of_fwnode_handle(np)));
+	return fwnode_phy_register_fixed_link(of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_phy_register_fixed_link);
 
 void of_phy_deregister_fixed_link(struct device_node *np)
 {
-	struct phy_device *phydev;
-
-	phydev = of_phy_find_device(np);
-	if (!phydev)
-		return;
-
-	fixed_phy_unregister(phydev);
-
-	put_device(&phydev->mdio.dev);	/* of_phy_find_device() */
-	phy_device_free(phydev);	/* fixed_phy_register() */
+	fwnode_phy_deregister_fixed_link(of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_phy_deregister_fixed_link);
-- 
2.29.0

