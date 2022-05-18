Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC6852C427
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242458AbiERUKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242392AbiERUKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:10:00 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F562375F1
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:09:51 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h5so3027930wrb.11
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zWSv1nsIrifugG1nZe+GG3CiYU/pokPOKop6RME5qNI=;
        b=qCU5VnLvgmoMb3sOSQ/yF4RotpAJ/DggXO7ITDvwgXeUbi++LQbYCQZVvxAC9EWHYJ
         Aq60BDj9bXJOIRTA+nNPwZ6iuQYMVUinVtV2xEl7u0NhDY+FdcL+1lUs5E0xAJZ2lGOc
         jZbWd59afyneSyQLuQmk5EgWYVPDMgInKRMAlVI23UIY343D34oREuXRKZnrUmUJwdqf
         91nElBZnYyKcy0ewUU+t1WoWWyBeHW4XnkE65hQj4NLWTS7KQ56VuJe62d89P1iPDt39
         5volX/xxiaQoVctOPh19b9jEBOX3pyctNFjSARMLa5VIR/FhqvDlcJF945k6Qklgtt91
         mZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zWSv1nsIrifugG1nZe+GG3CiYU/pokPOKop6RME5qNI=;
        b=lxsokjSvZQlnE+5vGPgbuzA/ZRgGlrZb4KBqpP0+jcTW/hcga+v9oVBYT1daE3clLj
         njIacrozfRio8rGaKwGsMmNbJjT28m8zz8q2xwZ/NbiQnSo4bGdmSuM2mncbt7LCS8SY
         thFDhD4LdT51Yuy2XviJoh4PjdDj4ad4eRwmRSeuod4tRTAG7epfGr3+ZZ33fHWRTCVl
         cTpcdFkwu0jFCxPPqm++VXLp43R2Sw4MT3+oHEXeFD2rTrdVeL4uEO48iS0h8g98faV5
         GzJAJGMx/gasENbH9Nk602OMIAfHK7ucKRKFJwf3b+EPGhKejc/x4uSvmb56+M231IdH
         rC7A==
X-Gm-Message-State: AOAM530GvqCY63wF8C71al9J3JhH/s6NyqCnMXyC8Bmd+TDH3bJmfxIG
        n1iBeOKZW4h+5WKgn8JgcfEZDA==
X-Google-Smtp-Source: ABdhPJxKaX4nnr3QSNO0ZrccrSGjmO+tuS/umKcp/f/i8ZDGyDoxnlqao/HKDNSLYAaLrFkeftXIQA==
X-Received: by 2002:adf:eb82:0:b0:20c:a2eb:5fe6 with SMTP id t2-20020adfeb82000000b0020ca2eb5fe6mr1091386wrn.563.1652904590013;
        Wed, 18 May 2022 13:09:50 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o23-20020a05600c511700b0039456c00ba7sm6859281wms.1.2022.05.18.13.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 13:09:49 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 3/5] phy: handle optional regulator for PHY
Date:   Wed, 18 May 2022 20:09:37 +0000
Message-Id: <20220518200939.689308-4-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518200939.689308-1-clabbe@baylibre.com>
References: <20220518200939.689308-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add handling of optional regulators for PHY.
Regulators need to be enabled before PHY scanning, so MDIO bus
initiate this task.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/mdio/Kconfig       |  1 +
 drivers/net/mdio/fwnode_mdio.c | 34 ++++++++++++++++++++++++++++++----
 drivers/net/phy/phy_device.c   | 10 ++++++++++
 include/linux/phy.h            |  3 +++
 4 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index bfa16826a6e1..3f8098fac74b 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -22,6 +22,7 @@ config MDIO_BUS
 config FWNODE_MDIO
 	def_tristate PHYLIB
 	depends on (ACPI || OF) || COMPILE_TEST
+	depends on REGULATOR
 	select FIXED_PHY
 	help
 	  FWNODE MDIO bus (Ethernet PHY) accessors
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1c1584fca632..c97ccb0863f9 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -10,6 +10,7 @@
 #include <linux/fwnode_mdio.h>
 #include <linux/of.h>
 #include <linux/phy.h>
+#include <linux/regulator/consumer.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
@@ -94,7 +95,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	struct phy_device *phy;
 	bool is_c45 = false;
 	u32 phy_id;
-	int rc;
+	int rc, reg_cnt = 0;
+	struct regulator_bulk_data *consumers;
+	struct device_node *nchild = NULL;
+	u32 reg;
 
 	mii_ts = fwnode_find_mii_timestamper(child);
 	if (IS_ERR(mii_ts))
@@ -105,15 +109,33 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	if (rc >= 0)
 		is_c45 = true;
 
+	for_each_child_of_node(bus->dev.of_node, nchild) {
+		of_property_read_u32(nchild, "reg", &reg);
+		if (reg != addr)
+			continue;
+		reg_cnt = regulator_bulk_get_all(&bus->dev, nchild, &consumers);
+		if (reg_cnt > 0) {
+			rc = regulator_bulk_enable(reg_cnt, consumers);
+			if (rc)
+				return rc;
+		} else {
+			dev_err(&bus->dev, "Fail to regulator_bulk_get_all err=%d\n", reg_cnt);
+		}
+	}
+
 	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
 		phy = get_phy_device(bus, addr, is_c45);
 	else
 		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
 	if (IS_ERR(phy)) {
 		unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
+		rc = PTR_ERR(phy);
+		goto error;
 	}
 
+	phy->regulator_cnt = reg_cnt;
+	phy->consumers = consumers;
+
 	if (is_acpi_node(child)) {
 		phy->irq = bus->irq[addr];
 
@@ -127,14 +149,14 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		if (rc) {
 			phy_device_free(phy);
 			fwnode_handle_put(phy->mdio.dev.fwnode);
-			return rc;
+			goto error;
 		}
 	} else if (is_of_node(child)) {
 		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
 		if (rc) {
 			unregister_mii_timestamper(mii_ts);
 			phy_device_free(phy);
-			return rc;
+			goto error;
 		}
 	}
 
@@ -145,5 +167,9 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	if (mii_ts)
 		phy->mii_ts = mii_ts;
 	return 0;
+error:
+	if (reg_cnt > 0)
+		regulator_bulk_disable(reg_cnt, consumers);
+	return rc;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 431a8719c635..711919e40ef7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -27,6 +27,7 @@
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
 #include <linux/property.h>
+#include <linux/regulator/consumer.h>
 #include <linux/sfp.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -1785,6 +1786,9 @@ int phy_suspend(struct phy_device *phydev)
 	if (!ret)
 		phydev->suspended = true;
 
+	if (phydev->regulator_cnt > 0)
+		regulator_bulk_disable(phydev->regulator_cnt, phydev->consumers);
+
 	return ret;
 }
 EXPORT_SYMBOL(phy_suspend);
@@ -1811,6 +1815,12 @@ int phy_resume(struct phy_device *phydev)
 {
 	int ret;
 
+	if (phydev->regulator_cnt > 0) {
+		ret = regulator_bulk_enable(phydev->regulator_cnt, phydev->consumers);
+		if (ret)
+			return ret;
+	}
+
 	mutex_lock(&phydev->lock);
 	ret = __phy_resume(phydev);
 	mutex_unlock(&phydev->lock);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 508f1149665b..ef4e0ce67194 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -704,6 +704,9 @@ struct phy_device {
 	void (*phy_link_change)(struct phy_device *phydev, bool up);
 	void (*adjust_link)(struct net_device *dev);
 
+	int regulator_cnt;
+	struct regulator_bulk_data *consumers;
+
 #if IS_ENABLED(CONFIG_MACSEC)
 	/* MACsec management functions */
 	const struct macsec_ops *macsec_ops;
-- 
2.35.1

