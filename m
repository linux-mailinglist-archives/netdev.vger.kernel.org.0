Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CE366CDFC
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbjAPRxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbjAPRwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:52:30 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E163B648
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:01 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id c3so807603ljh.1
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7zRzIvSvAnePdgerXrTk1rkO3KZL7nxc+XvMTxQPhY=;
        b=Xw/fj4+FQpuzGP7EaLIXAVXbJxMPn0Ykf3JEyIVvh0e4CzvpJ+Ly0jSQ3R8nTXqfzg
         VJGosRKpmExhQ9GpsUvmDtQWbOHyRkh5QTYCstCk04Rt4pkYX0ma0fOiQcPnskzbcRJL
         /gXJNwOBsx1qqirgcQ1+ghYY1A9aNvklPV3uqw8rsqrbN5J6fqLdwuBgwkGtHVjG5xXh
         UjpZbwI3W8mHWLpQaDCUMqXYCweFwB+cv2KJAV2xSc9lzC27lMd7ha/3jy/6nDiXGfRs
         wl4xkixjqViuR8690NymFAvdA+n3U759J6sArzAcVTCri00qP0eYxpdBX5C3t9kbNfXx
         N8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p7zRzIvSvAnePdgerXrTk1rkO3KZL7nxc+XvMTxQPhY=;
        b=N2LMIiM5fajWC9lcTBRwQPqaj0w80v1kihb/7TX7xnzBrmD7X4qJncqlBY4KZa+ukj
         2MgF4NknPgnG6TG266aX0yWxLAGUZFGcoHQjexD1uENxqXrJqpNC10K0zJ2BJPMlpOns
         xHwQALSMHttzpW4dzHA1g33BsYwxYe6CC++LqRHAF8wSo8FVvuY70Dd2FpnpBTsV8age
         CzRkUej9cs265PweAxdsYxzArcxs910OlIjTIWFq6ZYSL2Hp9coLs68W//7hV68duLmO
         TICRKM/JaoE1DJHygOcPCrlkesUkGdcmKHRacaAm9FtHfr9uLnXXvuhUF3MEuSQ0iF6Y
         GYZQ==
X-Gm-Message-State: AFqh2kpSzawYJPvUaI4NpPYQA/hVdGD9MTm74DiCBv+U9ut9A9l82vWD
        t6+FembPvZv9vAxETL478xYKRA==
X-Google-Smtp-Source: AMrXdXvNYSPJXM5gb+VT2fXLJrPCPxJy38bDlYjViAKETboBghKQPve9JtUslr/FnDDbMt26+/vwHg==
X-Received: by 2002:a2e:838b:0:b0:285:478a:7f2c with SMTP id x11-20020a2e838b000000b00285478a7f2cmr164267ljg.38.1673890499896;
        Mon, 16 Jan 2023 09:34:59 -0800 (PST)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id k20-20020a2e8894000000b0028b7f51414fsm707333lji.80.2023.01.16.09.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:34:59 -0800 (PST)
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
Subject: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API to fwnode_
Date:   Mon, 16 Jan 2023 18:34:14 +0100
Message-Id: <20230116173420.1278704-3-mw@semihalf.com>
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

fixed-link PHYs API is used by DSA and a number of drivers
and was depending on of_. Switch to fwnode_ so to make it
hardware description agnostic and allow to be used in ACPI
world as well.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/fwnode_mdio.h    | 19 ++++
 drivers/net/mdio/fwnode_mdio.c | 96 ++++++++++++++++++++
 drivers/net/mdio/of_mdio.c     | 79 +---------------
 3 files changed, 118 insertions(+), 76 deletions(-)

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
index b782c35c4ac1..56f57381ae69 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -10,6 +10,7 @@
 #include <linux/fwnode_mdio.h>
 #include <linux/of.h>
 #include <linux/phy.h>
+#include <linux/phy_fixed.h>
 #include <linux/pse-pd/pse.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
@@ -185,3 +186,98 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	return rc;
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
+	return fwnode_property_count_u32(fwnode, "fixed-link") == 5;
+}
+EXPORT_SYMBOL(fwnode_phy_is_fixed_link);
+
+int fwnode_phy_register_fixed_link(struct fwnode_handle *fwnode)
+{
+	struct fixed_phy_status status = {};
+	struct fwnode_handle *fixed_link_node;
+	u32 fixed_link_prop[5];
+	const char *managed;
+	int rc;
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
+		rc = fwnode_property_read_u32(fixed_link_node, "speed",
+					      &status.speed);
+		if (rc) {
+			fwnode_handle_put(fixed_link_node);
+			return rc;
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
+	rc = fwnode_property_read_u32_array(fwnode, "fixed-link", fixed_link_prop,
+					    ARRAY_SIZE(fixed_link_prop));
+	if (rc)
+		return rc;
+
+	status.link = 1;
+	status.duplex = fixed_link_prop[1];
+	status.speed  = fixed_link_prop[2];
+	status.pause  = fixed_link_prop[3];
+	status.asym_pause = fixed_link_prop[4];
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
index ba22b7110cdc..e6b3a4e251a1 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -353,91 +353,18 @@ EXPORT_SYMBOL(of_phy_get_and_connect);
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

