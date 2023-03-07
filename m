Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73BE6AF8C4
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjCGWdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCGWdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:31 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298B89AA35;
        Tue,  7 Mar 2023 14:33:30 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id m25-20020a7bcb99000000b003e7842b75f2so85150wmi.3;
        Tue, 07 Mar 2023 14:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PNA75+ffAuv7QuOxp1Cc8LTrOxCzACAVhyEOObz9ATQ=;
        b=Ous/JScFrx1dSu9x6+tQiT/MLYKi3xMjoh/2zzApSkvb/hTI3pwPN0Iv5VWQ/6kcLz
         uw/bNtz9yrxt1Dm+77uj2Hij9B9Ilt/yncfd0KzeZmFqicT+I+Oml35h10/7rs+QtTig
         f1znzcLnWi71teXhkEEhYaezDTos9OtE3JkbwXxBofL00/PYxjuyWOn2c2Pi0IEylKPd
         CGjZaa0YCGiRVy/XrsSuX3hua0ywvkQMwFYfI9y1+I9JrcgqXZhfAnm2xp5WmjPfHO9e
         BMj9jwEDNbPTctxTPqcfYdQRl3W3HIRXf1oDa045h9Vs81BlCdE1nQKH8V92P9TblByl
         /SQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PNA75+ffAuv7QuOxp1Cc8LTrOxCzACAVhyEOObz9ATQ=;
        b=w6MhwfQt/IvZupmv/UZBP97joijAnw1e1YFcxmUo2GlCtcxDQ5dhtSY5ICCQmOVHm7
         H5dielbJN9punkIllVAqzpPUJLTJu2VVJcdyaQZCYH9q/Zuz4NqT97u4bI0nuHnNgtVK
         +QLPs7PlmvjMsCs59hK0gp0TbOXomOhM3ZIQrIvcLBv3u3o1PLgvHaU/ha1xxtpRzt86
         HrKJVdq4KxasypKOHsGKDpk0yBlfYMIi0WVm5U2xjf5sWgNAe6Uf6NscXW+SMmMIZyw0
         gmkfgEGMwCuyN4U6OSx6NUBGP7XuNgj1MWglFaHZJovDc06VLXIhPwQN4EifAdv+bDZW
         vAcg==
X-Gm-Message-State: AO0yUKXoEvAMu/31pzHvhvcjpZCuvTrXkmkXSvKzERmdhvgh0loY0kuT
        8GSuAytNCBvNuV/9i/rNEv8=
X-Google-Smtp-Source: AK7set9RLmmfjOKKC2D+hLDppQ5/16MJZhaGu25c4q4km1PSZeLZ3CPqlu+9ygLhvoGX1Olx6hwHgw==
X-Received: by 2002:a05:600c:a09:b0:3ea:c100:e974 with SMTP id z9-20020a05600c0a0900b003eac100e974mr15119103wmp.26.1678228408515;
        Tue, 07 Mar 2023 14:33:28 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:28 -0800 (PST)
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
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH 03/11] net: phy: Add a binding for PHY LEDs
Date:   Tue,  7 Mar 2023 18:00:38 +0100
Message-Id: <20230307170046.28917-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170046.28917-1-ansuelsmth@gmail.com>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
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

