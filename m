Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626006AF8E5
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjCGWdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCGWdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:40 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1131F9E51E;
        Tue,  7 Mar 2023 14:33:34 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso81284wms.5;
        Tue, 07 Mar 2023 14:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFKfyegjpAF6RoRRpVAGQR9empILN5kAdm3BJUNpaCg=;
        b=OGx0YwG2swcAIAnRSezmOEktltT4pyXlqAQVZzO0srWnoD9MU8CV+V5a8eG06lFMZH
         hc2X/JqbmpuDT363nP+d1w6jpjNWUsquAtRUCAmj6dwSd5k9r/wiMzybfvLiHPk6bCDM
         jT4kGExubAq8c+23XTyKYB+j2bJ5Picl2zHlb11xU2rtZBh6ai1IlcKwmdi/qOT99IKk
         817yXxA013zL0FHereOgrheqMuOr/PipPswHWBOvavzLUr+7bM5F5sQeJGoKWkY1X+ca
         G7QI3g4o4aqlvNehyZx9AL/iZBefsI9a8gbVE40YapR8vxH/gLx6tckPBYjq3YDNGerI
         5m9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gFKfyegjpAF6RoRRpVAGQR9empILN5kAdm3BJUNpaCg=;
        b=pUlI0i0OUCqRwTYMcdMT4hj1xIJDRIFp4vzOZcoHb5WX2RCT8arMtTYxjfDmuTdqaV
         OYblffIaZTSQUyH9HZC9flUDchVzLGxwRaUh8geQjyWSPPcHcF6h9CkD954M+f8qhv2q
         SWiZ6PF9USOSVd+O5FH4n3tOh4eyBgKpkb9rsMYoIzRNG/fCharhnwnD0yiReukekSa+
         apThzsJMcA1TVUCisASFAlDhApreSYt4cDV6dPxkgCjUmmdgd3Qk8v9X69CErWGc0BSH
         AvWVyaURJbOwMhK0ZUkA0EcmpD/i3DSSlZs2ZAM7uP2Ucs5uIl8cfIz0XgBIAgKiaDoY
         mdVw==
X-Gm-Message-State: AO0yUKWXZVWiqOFBXb6CSyUdmji2Db/A7U7BrneZ4o/2xM5YGtFOY/0T
        D3LsFqhMrvQDpvqPwIrAx8A=
X-Google-Smtp-Source: AK7set/dV5nZ+FNI2b7VXbj45v+N2uFo+8OdCBTd8TWevumfE0EUKAdS4gIC3ZFzOO/T1LNL/84COA==
X-Received: by 2002:a05:600c:a0b:b0:3ea:fca4:8c48 with SMTP id z11-20020a05600c0a0b00b003eafca48c48mr13505083wmp.23.1678228412313;
        Tue, 07 Mar 2023 14:33:32 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:31 -0800 (PST)
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
Subject: [net-next PATCH 06/11] net: phy: phy_device: Call into the PHY driver to set LED blinking.
Date:   Tue,  7 Mar 2023 18:00:41 +0100
Message-Id: <20230307170046.28917-7-ansuelsmth@gmail.com>
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

Linux LEDs can be requested to perform hardware accelerated
blinking. Pass this to the PHY driver, if it implements the op.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
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

