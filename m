Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C125B6C041E
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjCSTTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCSTSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:18:45 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768921FF6;
        Sun, 19 Mar 2023 12:18:43 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t15so8515811wrz.7;
        Sun, 19 Mar 2023 12:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0MakyRcFEWBZQiWEXykX8ky94BsPvBnh7BhgiO6dB5k=;
        b=ktTQb++or6bxcgenSg9H3uoy0NKlIdMXs5VyshZ2T5aAYD4JsGyFowKAH6XptpbzDa
         5mwPrtZByvjEQzuu1a0c/qe4LD0B1dGj6MUrT1vw0v37COG7s6NPM1bqXPCq3NA4V15i
         5renmpPDNmI1nPnAJkpkwyLv+tMOxrh3yu26F75vWkt96xMbHYDVSznmXg/bPDBebhUA
         f0Giu6187l9uRPTizN57xJsBVcxqOoUAfwhGXu3iH6vH8N/q9BEVtw4fMK23T8XPnbzc
         GVQWILvN8dllu33YCISqbqYeroLHCFSkrUTHcnnd/H8779a9lvqkSIwJOQa7i5QaVKsp
         RjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0MakyRcFEWBZQiWEXykX8ky94BsPvBnh7BhgiO6dB5k=;
        b=aXFdK8LMwr/SpWz6DLp3Xl2wpwKb9WvMW0DGEE3KDmVL8JdatPnqhZWOJGsYivYDBl
         ghcw/9rSIr9xzk3i1qG9/hvJXP+8xZR60mRm32vQQ51UpLKMGnujBLMABz6GvA9ev4ow
         qhwY2KsbYPUiE2lIVHOSihM+5F0M0xS9WheliI+zPRS2vWVdReJpSej73DvbZddMYBVY
         OiXuqSpGdB1qg6ojf70D6MEJ6CGoJm5tiJyBL9slrJR6YjgSRZEqwzaevZUO+/R4Tn1p
         4afG42Mmeh7IYl0KdzCSbNPGhKkQ6/JVBdJ6bLVxd6DCiZkmi1Y8pAZqPJEI9O/1ADO8
         Nveg==
X-Gm-Message-State: AO0yUKXeyG7ImhdOUGvXxq44cMJqHo5sbA7SAz+Gaam2IUgJ4uOejdvP
        ATgM4oKkn4+EsXrSOZOUsTU=
X-Google-Smtp-Source: AK7set9O+5bZt+xpJcOS4iWaiI2yqHiSnmVceICpt6EYRYsrCRnjbAf1C8+cyOagjusjvV1c1sB2eg==
X-Received: by 2002:a5d:6511:0:b0:2d1:6104:76ab with SMTP id x17-20020a5d6511000000b002d1610476abmr9730929wru.2.1679253521860;
        Sun, 19 Mar 2023 12:18:41 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:41 -0700 (PDT)
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
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v5 05/15] net: phy: Add a binding for PHY LEDs
Date:   Sun, 19 Mar 2023 20:18:04 +0100
Message-Id: <20230319191814.22067-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319191814.22067-1-ansuelsmth@gmail.com>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
PHY driver.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/phy_device.c | 75 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 16 ++++++++
 2 files changed, 91 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c0760cbf534b..39af989947f9 100644
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
@@ -2988,6 +2991,73 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
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
+	err = of_property_read_u32(led, "reg", &phyled->index);
+	if (err)
+		return err;
+
+	cdev->brightness_set_blocking = phy_led_set_brightness;
+	cdev->max_brightness = 1;
+	init_data.devicename = dev_name(&phydev->mdio.dev);
+	init_data.fwnode = of_fwnode_handle(led);
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
@@ -3183,6 +3253,11 @@ static int phy_probe(struct device *dev)
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
index fefd5091bc24..11fb76a1c507 100644
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
+	u32 index;
+};
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
-- 
2.39.2

