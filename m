Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD85582047
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiG0Goh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiG0Gno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:43:44 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFD53B94B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:43 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id p21so11122165ljh.12
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1I6Xn/UXiMT6VknV/yDkGje3BjUktQ7ZyDrns9mPDHA=;
        b=VyV9z9XcHmSKY/u+3U+ob/ycFMUa7f5bUOn+KNNvQdUmPbbqJSVo6GNMx1l0c+WFVF
         nsz/45MckkVUmrrFwnK9eBECxxhD9pFmpG9rKsQq9M4napzTyi3nNFi/rElJr8Ve0NhZ
         lUdSmMDveFfx1ZdHDk8zIdBl+iyDgrgSlff/+vgWF/GSAnWAW209aAEtcmNjI2jpNh/+
         OuPpiSSl9wbFVTGnqiVeHztIxD3Apr532L2PjVytPkwIZRGywgRn8yGtbG9vphpk45VY
         uFQC9aNJX8WGCS+1mZU4jMDykTy1IEno9mqhjMTkFq7Z0xxyT+WMG4CLaS6WqC1jAIm7
         Lu0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1I6Xn/UXiMT6VknV/yDkGje3BjUktQ7ZyDrns9mPDHA=;
        b=2GPovJKzuP7y51Dn6rMJaiiHABY+rjZYcfwTXND3C607VVGfCtgyBD/xsrldsnPmol
         RO2g85Tt/Bqr/Z5ZKG5mov25r5UWf4ZlvGKLNx8TGaAoNcuIE11h3Jw3N4fJF0enlLQ0
         blLS+zmMyg7BUVtol3LG1RihYmi3KT4JD3/4EZfAVgHMNahvznLwZbhJex7tiQP9FnDT
         AUxKfe/OLkrYB+MBhpLKWEXazGTOKCkiPzwmef3sIQYTN0dGyOlAdW/w940yHI+9NYOl
         abISAS0/2uDVxya7Vn79x1NGdih5fnPdk/YCs1f+LPiWeDRQRq3QT5lrx1ZHsmA2CsNM
         AdCw==
X-Gm-Message-State: AJIora+QchL70JwAZvryfYNl0hCyoffmMieRcJ5wAep5o69/BUw+2M2w
        om5U9fQEMaO3vV63yfOfrxpHwg==
X-Google-Smtp-Source: AGRyM1v2Jzg8MJOoV3C0xCVgg4McEUzad5WIKWRz1P+ChhkRcykn+p8NckVdHoYsFxms8sfYYTk0Bw==
X-Received: by 2002:a2e:be90:0:b0:25e:1496:a0b8 with SMTP id a16-20020a2ebe90000000b0025e1496a0b8mr2264676ljr.194.1658904221266;
        Tue, 26 Jul 2022 23:43:41 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id w19-20020a05651234d300b0048a97a1df02sm1157231lfr.6.2022.07.26.23.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 23:43:40 -0700 (PDT)
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
Subject: [net-next: PATCH v3 2/8] net: mdio: switch fixed-link PHYs API to fwnode_
Date:   Wed, 27 Jul 2022 08:43:15 +0200
Message-Id: <20220727064321.2953971-3-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220727064321.2953971-1-mw@semihalf.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
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

