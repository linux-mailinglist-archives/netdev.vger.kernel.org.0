Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2425552006
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbiFTPMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242875AbiFTPMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:08 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FE019FA2
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a2so17707406lfg.5
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xFucQ3C/FYSxEEKLXgm7WEUAFTqRGfOx5PDeN0uOhvc=;
        b=I/l5jek5ysAPkzJhksovOM5xmWjXfNbCusHoQYicryGVeH2FpRoLLs1n7zbOGDy0w0
         2JhlU2J/4rMAtZMYtqplfZSwsvgYiaLEJ0i1gdIj6W69DJ7tznZre1A5fQKR+WtgEzkf
         Jgfms8bXzux9le5rE4IsfakL8nt33uedbbwWUeNEkjghENjTsacOG46qJV38EP1WH7oI
         eReHw7Eqzr5imRh9gcg8olJHtAWHq147h0oWqlYVSyDpvi181fBSDXat/KfmQco8FoaA
         QdHlrunaRjrMS5tCDCnBrYKFtfrYRXxDCw6EljUXWA9R+PA1zBJen6/tkE7Gzemjk4hf
         YNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xFucQ3C/FYSxEEKLXgm7WEUAFTqRGfOx5PDeN0uOhvc=;
        b=NncIsvJFk355a/NvmTBcsUEPdChzavhfoPaApO8jjFEv7oU8Yb/1gzS5g7TrmJHUxq
         tRCML8HkZDB2qVmT2c7mtDIn1zIAUt8eylqoZmNYr/9mZSQTgS2qbwkk8/xqtd5va7cn
         AL4NNFUR9rQnRaQk+2AcHoM31Cak5Rigz3NOzsUdtiZiZvZV8SF+nJxL9Y/sDMwUvKTe
         Z08uOlognnl9TZHd6l0HKUXFvJ/+Y78/3WmUTxcbYv4R2zJcQsHTvXnepdxe5eYtcwdV
         Z1oJvJA1JOWeTnxHnY741qf1B8++/Vnjn4ceMfHWtB3HFJad68JSKJZlHNYIzaUyWEoP
         dkMw==
X-Gm-Message-State: AJIora9KsRCDmuUMbL0VxgGKGnRlLfWpPiJROkeB0eiVHNwkmFk4kaAS
        Jr4RcIH9TTWdfgf/x2MsmaPNrQ==
X-Google-Smtp-Source: AGRyM1uP5Akkrn+zO5ywGqHgQ1zT/LsX1aQLDykb/IEqucwHpSCG6STCHEn2ODcLvYDyjcwthz1pGA==
X-Received: by 2002:a05:6512:2207:b0:47f:70b3:52d with SMTP id h7-20020a056512220700b0047f70b3052dmr2566673lfu.174.1655737366560;
        Mon, 20 Jun 2022 08:02:46 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:46 -0700 (PDT)
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
Subject: [net-next: PATCH 02/12] net: mdio: switch fixed-link PHYs API to fwnode_
Date:   Mon, 20 Jun 2022 17:02:15 +0200
Message-Id: <20220620150225.1307946-3-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 1c1584fca632..b1c20c48b6cb 100644
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
+	len = fwnode_property_read_u32_array(fwnode, "fixed-link", NULL, 0);
+	if (len == (5 * sizeof(u32)))
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

