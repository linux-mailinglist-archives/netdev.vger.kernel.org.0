Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261D56AF8D1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjCGWds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCGWdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:35 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031D79BE3C;
        Tue,  7 Mar 2023 14:33:31 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so88358wmb.3;
        Tue, 07 Mar 2023 14:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WKaejEkwd7x7h0zVDdJBQrWswFotreBUxLmSKtjxwLI=;
        b=di+9QEKVE16tj01XPCZMIyCFK7Anfrsm/6mIfACWi15xdVPAF2EGAhvTM9IdRpw9ci
         te1m+VbZXvxI4235YjygsOcjBJuyKGGKx2eMeTbCKaJhDh/d1jw87//ALmRbSqc5q2+F
         /9BvcJ4xRtTxjluUvFuoii/kKcUDAdPC750MkMuhCnr5Hziu0aCaJLPfXt5zcddcdzmf
         chBhXASMkrZZJL1XjDH2a774Mw2lzvULIg7EYshR1e9fRj9OX8jNkayWjihhhg6NdGpX
         yrMAq3QlBZaT0X3dHMfeipe5Y/mBJeBV8pAwjfUMi9Ohak7kxOPbCqCY5qFLyWHR9Imy
         IAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKaejEkwd7x7h0zVDdJBQrWswFotreBUxLmSKtjxwLI=;
        b=euSdGRkinHmeu7KC+PIer1UxDErUlPgDQttpaqPio6ZJlcBjDNpG8nYWHc/J13zAJq
         MgZoA8swcDAqpmmhb8frmI4LQS4Ib/ULA2/8j+MBtfhkRCjbKWi11rA5W9TYjNGTUYJs
         SB+l4m7dKmB4MY3LnjlQmsB7zGfJ34p4e5amRL4FtyPJjnhBGODTKDNsVqvLHMB7vSwg
         3LqV7qR8SOsRQzoRc3Yjml7vNulDPq3ePu2QH4SlHTJkQg7u+hHaODr5H7h1sw0NW5tE
         7N1ZfcttDYTRQn3wBCLFy6myjGZXFxbTCu4cc3wmKtmUiXxEMJ6pi0x8FwVu48QV/fH3
         MyhA==
X-Gm-Message-State: AO0yUKV0sBOT68VhSG4aI2QIUgrK9zA7C27zfPlYiNPE8+dfl8bKL+L4
        GfvZsNdWkAs0K9tTEFh2aDQ=
X-Google-Smtp-Source: AK7set+X1R7wL4H+5FLmHv81NW3Frc4k/b4zPNyfVIi5ntM6gTNEfdWfJjKyJXPWyS8i48ZaQdOk/g==
X-Received: by 2002:a05:600c:4ec6:b0:3e2:147f:ac16 with SMTP id g6-20020a05600c4ec600b003e2147fac16mr14763611wmq.10.1678228409772;
        Tue, 07 Mar 2023 14:33:29 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:29 -0800 (PST)
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
Subject: [net-next PATCH 04/11] net: phy: phy_device: Call into the PHY driver to set LED brightness.
Date:   Tue,  7 Mar 2023 18:00:39 +0100
Message-Id: <20230307170046.28917-5-ansuelsmth@gmail.com>
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

Linux LEDs can be software controlled via the brightness file in /sys.
LED drivers need to implement a brightness_set function which the core
will call. Implement an intermediary in phy_device, which will call
into the phy driver if it implements the necessary function.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 14 +++++++++++---
 include/linux/phy.h          |  9 +++++++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8acade42615c..e4df4fcb6b05 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2967,11 +2967,18 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
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
@@ -2995,7 +3002,8 @@ static int of_phy_led(struct phy_device *phydev,
 	if (err)
 		return err;
 
-	cdev->brightness_set_blocking = phy_led_set_brightness;
+	if (phydev->drv->led_brightness_set)
+		cdev->brightness_set_blocking = phy_led_set_brightness;
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1b1efe120f0f..83d3ed7485e0 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -841,6 +841,8 @@ struct phy_led {
 	u32 index;
 };
 
+#define to_phy_led(d) container_of(d, struct phy_led, led_cdev)
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
@@ -1063,6 +1065,13 @@ struct phy_driver {
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

