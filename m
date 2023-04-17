Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0262C6E4CC3
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjDQPVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjDQPVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:21:04 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B93C154;
        Mon, 17 Apr 2023 08:20:30 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-2f9b9aa9d75so658238f8f.0;
        Mon, 17 Apr 2023 08:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744829; x=1684336829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=II7AVpluR/mcohVGgSi1tMSvxtZUm75jmfq4y6fCXJ4=;
        b=oToAgzLhWBnsQnWGjJpxLd4WVjBI/fuVUW3fXl5ajmSOWip/2LeVhnCOQODRIGRVNV
         l4KEdoGZd31Ct6BBGgT6+rhzeBGvXFaE2Ci74Z/rQE30YGdWFxnqCw18Yfi2iS9PvFB8
         B/VNeWrDs/QjscHOE2O59WGosYcD2eTiHlUfDuzPtCYVJ5lecklsZuPuSXhwDmfRobkA
         BcweX5OWCO1WxmIpOnhRkyzmw66IrH9OvkezboRGYHM1n2MXF4ROACcnBLh73rhWIN7S
         Yow1nRqiQvoEDf1lneXyRvN36b/3XmiRcbUGuw3CwbTDeYQPStwpRhwymKGWWnosnGZM
         MjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744829; x=1684336829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=II7AVpluR/mcohVGgSi1tMSvxtZUm75jmfq4y6fCXJ4=;
        b=ZgIIf6up0ly80p5n45aTBmr3DmJH1p/ZXxW0qzqOlg7Y/pAlPiGLVq/8R7rlQRkU/6
         2lMMgqeqzeuET1CgBDv6tBDeT28WQWi5kmfuvLaV64lsqU57VIXyudzhlmimQz+QP6TH
         jxm7Z5c1I2xsHIzxmYWEnM9psSnP9Gvc+V0ZVLUC5wsDpEh657WjCUav/va/cGuhwEad
         MKJNdRYIAWihDqlnn4cOrlo/EdnsDPPNGMdZ/y+QHGdleq92lFTUZpkjmfATTS7YNFdG
         7UGhKxsWez03VphrE9jIJPVnmBmUQYXED+oKByqM5kJ4/OnINB39J7De5XbWngzQ/BAz
         0E3A==
X-Gm-Message-State: AAQBX9dp0tbS1d7wMnikBd7KltV2xbNufVIic6OQOBcxxyYDsCCNWbBe
        6TQodRZd8Glzx9C+Jeetqj8=
X-Google-Smtp-Source: AKy350bftEUxq8re0i0coLroY3HkJGrpY8WK2aL1Sp4V6LgzG4NCsSgJW7zBaeFog6Tm3I6jYmps4Q==
X-Received: by 2002:adf:f089:0:b0:2cf:e422:e28c with SMTP id n9-20020adff089000000b002cfe422e28cmr5440702wro.42.1681744828242;
        Mon, 17 Apr 2023 08:20:28 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:20:18 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v7 05/16] net: phy: Add a binding for PHY LEDs
Date:   Mon, 17 Apr 2023 17:17:27 +0200
Message-Id: <20230417151738.19426-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

Define common binding parsing for all PHY drivers with LEDs using
phylib. Parse the DT as part of the phy_probe and add LEDs to the
linux LED class infrastructure. For the moment, provide a dummy
brightness function, which will later be replaced with a call into the
PHY driver. This allows testing since the LED core might otherwise
reject an LED whose brightness cannot be set.

Add a dependency on LED_CLASS. It either needs to be built in, or not
enabled, since a modular build can result in linker errors.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/Kconfig      |  1 +
 drivers/net/phy/phy_device.c | 76 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 16 ++++++++
 3 files changed, 93 insertions(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 6b9525def973..b8cc49820ced 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -18,6 +18,7 @@ menuconfig PHYLIB
 	depends on NETDEVICES
 	select MDIO_DEVICE
 	select MDIO_DEVRES
+	depends on LEDS_CLASS || LEDS_CLASS=n
 	help
 	  Ethernet controllers are usually attached to PHY
 	  devices.  This option provides infrastructure for
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 917ba84105fc..61b971251de5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -19,10 +19,12 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/mdio.h>
 #include <linux/mii.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
@@ -674,6 +676,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	device_initialize(&mdiodev->dev);
 
 	dev->state = PHY_DOWN;
+	INIT_LIST_HEAD(&dev->leds);
 
 	mutex_init(&dev->lock);
 	INIT_DELAYED_WORK(&dev->state_queue, phy_state_machine);
@@ -2988,6 +2991,74 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/* Dummy implementation until calls into PHY driver are added */
+static int phy_led_set_brightness(struct led_classdev *led_cdev,
+				  enum led_brightness value)
+{
+	return 0;
+}
+
+static int of_phy_led(struct phy_device *phydev,
+		      struct device_node *led)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct led_init_data init_data = {};
+	struct led_classdev *cdev;
+	struct phy_led *phyled;
+	int err;
+
+	phyled = devm_kzalloc(dev, sizeof(*phyled), GFP_KERNEL);
+	if (!phyled)
+		return -ENOMEM;
+
+	cdev = &phyled->led_cdev;
+
+	err = of_property_read_u8(led, "reg", &phyled->index);
+	if (err)
+		return err;
+
+	cdev->brightness_set_blocking = phy_led_set_brightness;
+	cdev->max_brightness = 1;
+	init_data.devicename = dev_name(&phydev->mdio.dev);
+	init_data.fwnode = of_fwnode_handle(led);
+	init_data.devname_mandatory = true;
+
+	err = devm_led_classdev_register_ext(dev, cdev, &init_data);
+	if (err)
+		return err;
+
+	list_add(&phyled->list, &phydev->leds);
+
+	return 0;
+}
+
+static int of_phy_leds(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device_node *leds, *led;
+	int err;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return 0;
+
+	if (!node)
+		return 0;
+
+	leds = of_get_child_by_name(node, "leds");
+	if (!leds)
+		return 0;
+
+	for_each_available_child_of_node(leds, led) {
+		err = of_phy_led(phydev, led);
+		if (err) {
+			of_node_put(led);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
  * @fwnode: pointer to the mdio_device's fwnode
@@ -3183,6 +3254,11 @@ static int phy_probe(struct device *dev)
 	/* Set the state to READY by default */
 	phydev->state = PHY_READY;
 
+	/* Get the LEDs from the device tree, and instantiate standard
+	 * LEDs for them.
+	 */
+	err = of_phy_leds(phydev);
+
 out:
 	/* Re-assert the reset signal on error */
 	if (err)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2f83cfc206e5..bd6b5e9bb729 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
+#include <linux/leds.h>
 #include <linux/linkmode.h>
 #include <linux/netlink.h>
 #include <linux/mdio.h>
@@ -600,6 +601,7 @@ struct macsec_ops;
  * @phy_num_led_triggers: Number of triggers in @phy_led_triggers
  * @led_link_trigger: LED trigger for link up/down
  * @last_triggered: last LED trigger for link speed
+ * @leds: list of PHY LED structures
  * @master_slave_set: User requested master/slave configuration
  * @master_slave_get: Current master/slave advertisement
  * @master_slave_state: Current master/slave configuration
@@ -699,6 +701,7 @@ struct phy_device {
 
 	struct phy_led_trigger *led_link_trigger;
 #endif
+	struct list_head leds;
 
 	/*
 	 * Interrupt number for this PHY
@@ -834,6 +837,19 @@ struct phy_plca_status {
 	bool pst;
 };
 
+/**
+ * struct phy_led: An LED driven by the PHY
+ *
+ * @list: List of LEDs
+ * @led_cdev: Standard LED class structure
+ * @index: Number of the LED
+ */
+struct phy_led {
+	struct list_head list;
+	struct led_classdev led_cdev;
+	u8 index;
+};
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
-- 
2.39.2

