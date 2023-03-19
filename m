Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C046C0430
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCSTTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCSTSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:18:46 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6BC59FF;
        Sun, 19 Mar 2023 12:18:44 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m2so8523705wrh.6;
        Sun, 19 Mar 2023 12:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NCx6caR6IZgTqSPdn2HwL+62wmCa1NHNRk8GEDmxS/c=;
        b=MMxVlZBgzFIcfZOHEwBaQwsI4ky4mTC9a0gj8/TxWSMHVPI9j3Qak2ZLUGvgfSX7Mx
         Dmr4mHC3hGAvUYAvivjDzt9B4vwWBvnm1ntuGwATuvl2skEjDKX07ttVZCwblzkZrLay
         OsWlINOoYzymwsYKwyVCbvD/e5P6jBddf6lG4RvBT2fMNMFNLIRYvDfRYCwNbsoOMfWo
         M/yIzvOJqBWvzngpzBIXELOwq2Ad9F4u+Q1yGDHsyRa1LLdFLE7Jgir4QQTjbSFCo8Qe
         Osk1yMdVUQYgrW0hnxCkWdK02K9GILrsgyKx1Ctl0tsmkEzRHAFYl9lDRC4IDB6h9vLR
         7GvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NCx6caR6IZgTqSPdn2HwL+62wmCa1NHNRk8GEDmxS/c=;
        b=CreQ18z9mQP1UgC0nZ2cjLEj24PZr5IMDlZZwZ0+D+9ELRCuWjh7MbBf6KQINzEVMp
         cEkrlr8tRO5sbJB/DVgu7rp0Oq6/qjMrM2AqB93vNyZ9ut/6M8lBq8NmBT323q9c37tp
         WKeafDDnfNpduYonwr2Uwp7wvFvprltKXdNqJWcukV0owRINjm1uYMIJDr7iLY2Vl9sJ
         iDBXrSCE0i1hIYzqY5ILNH43BjPFUVyBKyoH4J0UZIpLtmAx+aIg6ro0lZl6d/E07efA
         rLT5OUMAKQBbWHqXa21Vl6aWp9UEJJxPEmkB8oEufctwA7jgO43q5Ms/Nvagl/g9jnLg
         Yk4g==
X-Gm-Message-State: AO0yUKUX79gf0lzUHCp97WVpGBnmzb9vQ4oEMWLEd4ASJdgVaXxMH/Bt
        NkU1TF3/+hkGT4urmK7KzLs=
X-Google-Smtp-Source: AK7set8fsq6zQlxjf9ZFshDSZySkAXi7AJNk/hdFefpQPp7yImbuKtjN2QnYSs99mmKQyNUyTYQYuw==
X-Received: by 2002:adf:de90:0:b0:2ce:aed4:7f22 with SMTP id w16-20020adfde90000000b002ceaed47f22mr12428360wrl.50.1679253523176;
        Sun, 19 Mar 2023 12:18:43 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:42 -0700 (PDT)
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
Subject: [net-next PATCH v5 06/15] net: phy: phy_device: Call into the PHY driver to set LED brightness
Date:   Sun, 19 Mar 2023 20:18:05 +0100
Message-Id: <20230319191814.22067-7-ansuelsmth@gmail.com>
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

Linux LEDs can be software controlled via the brightness file in /sys.
LED drivers need to implement a brightness_set function which the core
will call. Implement an intermediary in phy_device, which will call
into the phy driver if it implements the necessary function.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/phy_device.c | 15 ++++++++++++---
 include/linux/phy.h          | 11 +++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 39af989947f9..141d63ef3897 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2991,11 +2991,18 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
-/* Dummy implementation until calls into PHY driver are added */
 static int phy_led_set_brightness(struct led_classdev *led_cdev,
 				  enum led_brightness value)
 {
-	return 0;
+	struct phy_led *phyled = to_phy_led(led_cdev);
+	struct phy_device *phydev = phyled->phydev;
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = phydev->drv->led_brightness_set(phydev, phyled->index, value);
+	mutex_unlock(&phydev->lock);
+
+	return err;
 }
 
 static int of_phy_led(struct phy_device *phydev,
@@ -3012,12 +3019,14 @@ static int of_phy_led(struct phy_device *phydev,
 		return -ENOMEM;
 
 	cdev = &phyled->led_cdev;
+	phyled->phydev = phydev;
 
 	err = of_property_read_u32(led, "reg", &phyled->index);
 	if (err)
 		return err;
 
-	cdev->brightness_set_blocking = phy_led_set_brightness;
+	if (phydev->drv->led_brightness_set)
+		cdev->brightness_set_blocking = phy_led_set_brightness;
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 11fb76a1c507..2a5ee66b79b0 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -841,15 +841,19 @@ struct phy_plca_status {
  * struct phy_led: An LED driven by the PHY
  *
  * @list: List of LEDs
+ * @phydev: PHY this LED is attached to
  * @led_cdev: Standard LED class structure
  * @index: Number of the LED
  */
 struct phy_led {
 	struct list_head list;
+	struct phy_device *phydev;
 	struct led_classdev led_cdev;
 	u32 index;
 };
 
+#define to_phy_led(d) container_of(d, struct phy_led, led_cdev)
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -1072,6 +1076,13 @@ struct phy_driver {
 	/** @get_plca_status: Return the current PLCA status info */
 	int (*get_plca_status)(struct phy_device *dev,
 			       struct phy_plca_status *plca_st);
+
+	/* Set a PHY LED brightness. Index indicates which of the PHYs
+	 * led should be set. Value follows the standard LED class meaning,
+	 * e.g. LED_OFF, LED_HALF, LED_FULL.
+	 */
+	int (*led_brightness_set)(struct phy_device *dev,
+				  u32 index, enum led_brightness value);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.39.2

