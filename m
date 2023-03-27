Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC35D6CA6F4
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbjC0OLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjC0OLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:08 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373B1FD;
        Mon, 27 Mar 2023 07:11:07 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e18so8938971wra.9;
        Mon, 27 Mar 2023 07:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VS4Y4VE+qD1sbEQA++3DBYlzLaLe6ttk+7bys4bpMfg=;
        b=cM2+GKmy1XCwbinUNKI+uBWEsLSstaR9GMVumm6cBIc+FYJZ3ptKARqeMbKmxyg/qJ
         C9fuYDgXd64G6zdvqnKfu5SQVOBNpJDkR1fHEqdJGze0wN+TubNqFHuTsSocLiCnC6S1
         Qie78HprbbWbD4bqgnPrljqUyAa6t3B2XLfC1FdlJEgRjvBBUGZ3Azef4ETeBaodM16o
         dnCBPIzBa5ILCjkVO+WbUye7FbGK8v4A51SJCbgvtb6cc1fj0+mtEkRbIK4vtkWlkTaU
         VMlDYRi0tyU7tRkOd16GpWgMLKEqlCQCHAtthiNWqRY/1NnQS4/7D3Z4JHfdq0WkFJ5d
         MWqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VS4Y4VE+qD1sbEQA++3DBYlzLaLe6ttk+7bys4bpMfg=;
        b=Vdfa9zRBAkOdS4rA3wJDsWa/rZBPVN3BpRCj/gP+Cz+ZpKmBFkWrw/Gu1+pMoaN7Mj
         BvF4g4u/wyuFBY8mxp8BJ2rHeihdNN0gotSbg7TXXZcUCvv4UqGTBBC9eT8jZwY4WYTt
         gcUz6YJDkGWtmhV1DyB2rD2ARqSNsXFsW5O7lwpaFysvQn/eWBFwFTR28+CtYBCTSIeE
         7hU+FRObLe6Ap7dDTxGlUZDzESy5vafkdHZ7yRcpu/4lRou8hjUnW6AchtZMfnrjhjky
         LcczxN/6GfUwDbXdOUJQXrv58wNi5C+wluZGwa1pqon4s9g+6NNJhg+42YRQ+nTVLxBu
         DV9Q==
X-Gm-Message-State: AAQBX9fL7kxZKIQp0ig1hdbLZ3nH6KGohjFocikeqHXvHrju3bc7ozmb
        2FzfU0qAGG4rUJuxgCy5gVQcnvOuNEg=
X-Google-Smtp-Source: AKy350bDr4Fi3H7MVbjez4sts5y0pO+RsjRG00pgS5hPthYZukR4SdibVpiM/1AJemBUYZ3IcSBPHw==
X-Received: by 2002:a5d:4a46:0:b0:2d4:766d:e02f with SMTP id v6-20020a5d4a46000000b002d4766de02fmr9778530wrs.59.1679926266602;
        Mon, 27 Mar 2023 07:11:06 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:06 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 05/16] net: phy: Add a binding for PHY LEDs
Date:   Mon, 27 Mar 2023 16:10:20 +0200
Message-Id: <20230327141031.11904-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 drivers/net/phy/phy_device.c | 75 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 16 ++++++++
 3 files changed, 92 insertions(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 54874555c921..ae03562efe3a 100644
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

