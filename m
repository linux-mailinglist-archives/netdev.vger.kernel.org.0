Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659F16B9B0F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjCNQSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjCNQSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:18:00 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5091CACE27;
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o7so5496941wrg.5;
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cWl8tt6nddXYjDq6pzISEdAAK++EcnsjtXcgJ1R08pw=;
        b=frwVXNK7BvlIsgBhXHgTowPejdqKimT7IaqvOMFSkJUyihwIEAbG769U0YDB1n5tHV
         pec/8mkp9KDVjBeIV3t0gKysg05mTJAH909NCT/iAaq7IPpgnqrwpBt5I7qs21wb8EH7
         gzjxvYCw3TjAQ4nkPe7eVGTVrF6QiIhwtQxST0iEs5mUFREItlaMbJdZe0p2bgzJtMuz
         EwtfOCoGV+W4G72HUQURjnTwPJ6nyOoOtKOVFlVE6QcKtnEs0j+hPf3s+3VKxQr72Uyf
         wCGULVk+bAGSH4kvAvSnka7/cmyLt422JuSJOKeSAeGk2XA6t6zaMfI7z7dDAzeFvEQ7
         592Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cWl8tt6nddXYjDq6pzISEdAAK++EcnsjtXcgJ1R08pw=;
        b=D+53U0yhqNzef1GoW+MZ+H/gUt+i/ojgsuijtzUI9SvdKMd0E6AQgOw6JFcZQ595nn
         YNwKbscU4Tk/lMF2EaxIMfGLZEaUBmhkSZjU2PFDIzGsBUXR+HeCNjJ3mcIqmHAJ4sZD
         3UrFZ0y4gB3l05VkCF8Ke/rMbI34hGqG/oQGa6gx18mTzrKkzD3PzCxLeEC/h32h04Kh
         KFjoDrAcNgQtK4gGkulxVimCklkiG7f964CRd6g/dBY32Wx3ePZis916JRp+oHhKg6Z8
         IIDxk49+OcsmOa1MAu3pGgURUTkwxPo306UTH3Gjjb093kwEittnP56qAqT2ydF+TQDv
         87xw==
X-Gm-Message-State: AO0yUKVnITJbM3Z+DKHV9/hvuYK84dg7sJ3NKOmEck9BhS20x/rVmZrf
        k6R19nWbqysd0ottesK34GP8YU1wTFI=
X-Google-Smtp-Source: AK7set+mqaSObXHOfJkh5HjPCMjpisiRhXVRSJmoJGgR22VpkvTUnB4Yfjrf757TSQIHgdLwe4TCTg==
X-Received: by 2002:a5d:4012:0:b0:2c5:532a:98c4 with SMTP id n18-20020a5d4012000000b002c5532a98c4mr10942379wrp.33.1678810650821;
        Tue, 14 Mar 2023 09:17:30 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:30 -0700 (PDT)
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
Subject: [net-next PATCH v3 07/14] net: phy: phy_device: Call into the PHY driver to set LED blinking.
Date:   Tue, 14 Mar 2023 11:15:09 +0100
Message-Id: <20230314101516.20427-8-ansuelsmth@gmail.com>
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

Linux LEDs can be requested to perform hardware accelerated
blinking. Pass this to the PHY driver, if it implements the op.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/phy_device.c | 18 ++++++++++++++++++
 include/linux/phy.h          |  8 ++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e4df4fcb6b05..ae8ec721353d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2981,6 +2981,22 @@ static int phy_led_set_brightness(struct led_classdev *led_cdev,
 	return err;
 }
 
+static int phy_led_blink_set(struct led_classdev *led_cdev,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off)
+{
+	struct phy_led *phyled = to_phy_led(led_cdev);
+	struct phy_device *phydev = phyled->phydev;
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = phydev->drv->led_blink_set(phydev, phyled->index,
+					 delay_on, delay_off);
+	mutex_unlock(&phydev->lock);
+
+	return err;
+}
+
 static int of_phy_led(struct phy_device *phydev,
 		      struct device_node *led)
 {
@@ -3004,6 +3020,8 @@ static int of_phy_led(struct phy_device *phydev,
 
 	if (phydev->drv->led_brightness_set)
 		cdev->brightness_set_blocking = phy_led_set_brightness;
+	if (phydev->drv->led_blink_set)
+		cdev->blink_set = phy_led_blink_set;
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 83d3ed7485e0..b1ac3c8a97e6 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1072,6 +1072,14 @@ struct phy_driver {
 	 */
 	int (*led_brightness_set)(struct phy_device *dev,
 				  u32 index, enum led_brightness value);
+	/* Activate hardware accelerated blink, delays are in milliseconds
+	 * and if both are zero then a sensible default should be chosen.
+	 * The call should adjust the timings in that case and if it can't
+	 * match the values specified exactly.
+	 */
+	int (*led_blink_set)(struct phy_device *dev, u32 index,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.39.2

