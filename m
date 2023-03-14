Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4306B9AFF
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjCNQSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCNQRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:17:49 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43246ADC3D;
        Tue, 14 Mar 2023 09:17:28 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r29so6854693wra.13;
        Tue, 14 Mar 2023 09:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qIIOBe7NJABZRFq7ORmufJwFdwVU7XOjO161+6pddBo=;
        b=dtpenmKpkZtXXEJD24OKazKV0u2bhC9Coau1CVgmS4zkPAcMGuGQh0jyoIGSEmTmDk
         mjxUtx7F70gQzYUadWYKyOnl/i9A3YaY4ptXygJD6Lxd3qXvSqPqCV6dEJTKfclPqc5T
         TC0WXLNodBfK7luBymPM3WHRFSidaZ8ZHYSEV6+mOp04swUyFkhsIVevmVTLhTCiXNN7
         2xosGLjGQg55L5VxS054TaWbXKULS4lzdv7S14m4dpbkI7l8BEBxUiNSdtaOz9Dz6pgc
         Gwm/Tl4mKLnc3QLILtdlDGkK3A9NUCA4ioHi1lOUejPw6CyfG/nBCx9tVMizeD94oayC
         QAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qIIOBe7NJABZRFq7ORmufJwFdwVU7XOjO161+6pddBo=;
        b=PLihw7goEW1rRqh0IRAiFkzYwzypO45QNoW7hz0FepsHnHHQY2dGYCm1kxccDTxjIb
         SAN914gKLjEvfHI+5dpPy61a1LTjjESfHw9RU810HENGSO3kJ9HrNkEqIObQkB3hkpjf
         OZAk9ebb4h+JMTvFUMHTuDERn+F7+j0a65tM5a5E4YieM+LDZUhlgAUE/OXYXJa0joqU
         J97l/F2q0hwVrSUhD0127gIYmTPw56iMS9H/r19g07SKL8JqiCNFgmP28FLsuuxs87fx
         lxecgIEEcMKTjXk2O+5YseohtHh+6QgRr8gaUlvAU7KFosHcW/GEyqAYShbLRxMLvzCI
         KnOQ==
X-Gm-Message-State: AO0yUKWHsnhieweUhBOFLlBRqngHz30dRpOd/508xCh9Ks194wmQXTr7
        vBQlObZZ+nQV+/HozYnJHPE=
X-Google-Smtp-Source: AK7set8QTl7vOCuGcNET+BonHQS6+r/ky7GK02wCH+ldgxsZvePf77QVrefp1oYP6uxK+nyIm+KAKw==
X-Received: by 2002:adf:f44c:0:b0:2cf:6089:2408 with SMTP id f12-20020adff44c000000b002cf60892408mr6055723wrp.0.1678810646525;
        Tue, 14 Mar 2023 09:17:26 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:26 -0700 (PDT)
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
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v3 04/14] net: phy: Add a binding for PHY LEDs
Date:   Tue, 14 Mar 2023 11:15:06 +0100
Message-Id: <20230314101516.20427-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314101516.20427-1-ansuelsmth@gmail.com>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
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
 drivers/net/phy/phy_device.c | 89 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 16 +++++++
 2 files changed, 105 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9ba8f973f26f..8acade42615c 100644
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
@@ -658,6 +660,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	device_initialize(&mdiodev->dev);
 
 	dev->state = PHY_DOWN;
+	INIT_LIST_HEAD(&dev->led_list);
 
 	mutex_init(&dev->lock);
 	INIT_DELAYED_WORK(&dev->state_queue, phy_state_machine);
@@ -2964,6 +2967,85 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
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
+	phyled->phydev = phydev;
+	cdev = &phyled->led_cdev;
+	INIT_LIST_HEAD(&phyled->led_list);
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
+	list_add(&phyled->led_list, &phydev->led_list);
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
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void phy_leds_remove(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct led_classdev *cdev;
+	struct phy_led *phyled;
+
+	list_for_each_entry(phyled, &phydev->led_list, led_list) {
+		cdev = &phyled->led_cdev;
+		devm_led_classdev_unregister(dev, cdev);
+	}
+}
+
 /**
  * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
  * @fwnode: pointer to the mdio_device's fwnode
@@ -3142,6 +3224,11 @@ static int phy_probe(struct device *dev)
 	/* Set the state to READY by default */
 	phydev->state = PHY_READY;
 
+	/* Get the LEDs from the device tree, and instantiate standard
+	 * LEDs for them.
+	 */
+	of_phy_leds(phydev);
+
 out:
 	/* Assert the reset signal */
 	if (err)
@@ -3156,6 +3243,8 @@ static int phy_remove(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
+	phy_leds_remove(phydev);
+
 	cancel_delayed_work_sync(&phydev->state_queue);
 
 	mutex_lock(&phydev->lock);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fbeba4fee8d4..1b1efe120f0f 100644
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
@@ -595,6 +596,7 @@ struct macsec_ops;
  * @phy_num_led_triggers: Number of triggers in @phy_led_triggers
  * @led_link_trigger: LED trigger for link up/down
  * @last_triggered: last LED trigger for link speed
+ * @led_list: list of PHY LED structures
  * @master_slave_set: User requested master/slave configuration
  * @master_slave_get: Current master/slave advertisement
  * @master_slave_state: Current master/slave configuration
@@ -690,6 +692,7 @@ struct phy_device {
 
 	struct phy_led_trigger *led_link_trigger;
 #endif
+	struct list_head led_list;
 
 	/*
 	 * Interrupt number for this PHY
@@ -825,6 +828,19 @@ struct phy_plca_status {
 	bool pst;
 };
 
+/* phy_led: An LED driven by the PHY
+ *
+ * phydev: Pointer to the PHY this LED belongs to
+ * led_cdev: Standard LED class structure
+ * index: Number of the LED
+ */
+struct phy_led {
+	struct list_head led_list;
+	struct phy_device *phydev;
+	struct led_classdev led_cdev;
+	u32 index;
+};
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
-- 
2.39.2

