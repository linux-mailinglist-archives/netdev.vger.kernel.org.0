Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675446CA702
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjC0OMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbjC0OLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB5F5BAD;
        Mon, 27 Mar 2023 07:11:13 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l27so8959455wrb.2;
        Mon, 27 Mar 2023 07:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRiYNrAPbY9LjHto8cdOA0hKely2iuKhfCEH8qUJeKY=;
        b=CNM6QGOG+p9Jm8pXUoNu0FHagC/JN1PPMk6W47C2fDsyjH+SsXK7POzape3ilu99Yp
         /DKa2luEgWDowtLoT6AyPZv3fiAPl9I4G1tUBFkV5o4Bkec24jYEsDByYSeRhwhToIy+
         goFQjsk2yFqEW+G09ch6c0iTmOU5ZMUqBBx/+/RJeBv441oWBj4V9I4S8v3Exc7mNsW4
         zMp3CgACqn6xVMJ3G3LSUwnvGo3A4Ga5ATyhJzhmfpSzLEKl33Ye/f0RKVX2SwUtEGmD
         gX6YO2zD0pkBuwAAEqA9+vMNQc7vGyFIBAtPoLCLXWu8noro7PsHblCzg4pjdtCTKYTI
         M+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bRiYNrAPbY9LjHto8cdOA0hKely2iuKhfCEH8qUJeKY=;
        b=HbW6XnnmJQmt7nNQhfTDxjEjkNGhrXCpOD4pvoZrfLdiOyzCi9kjqaG0iswKt/pr/0
         uAiuHq5vqyrbg/F/drTAPDRbumHyOPspfxD6QXOUjbeMDj2u3SYaIkqaG9bmpK1KCaSU
         uDZ/jKFuSOtsG0wPGWwfMi02humfDZgJSwt1VtjXSu22BuS6h3eaR5zxBxmjWBAxARjn
         4BFkmE+84pXuW3duMEA5w7ct+qoGr1OsXBh/w1FvWx4pb154JsRhPSpWNmWunDNDXbNL
         CWga52mJKFPe6eb+yPJHkgBcsd81J/tYhNeoJGuSfsXiU4NyVwTTl9UIS8xMeFbKu6oX
         FpJw==
X-Gm-Message-State: AAQBX9fu5+PBYhDetWXF5tpzz7U5YHmKYMF0TuH2x0OlJR0KKl11xiXp
        qVC/2/LmMigIbYk/lJyj7tY=
X-Google-Smtp-Source: AKy350Zyd4GdyC+B9On5LCeJK0g0NP6GfozMwxMYb3nOLgkSxz5mjZTxI9VQD4trDqem4NHdABsG5g==
X-Received: by 2002:a5d:4e52:0:b0:2cd:bc79:5432 with SMTP id r18-20020a5d4e52000000b002cdbc795432mr9735430wrt.25.1679926271438;
        Mon, 27 Mar 2023 07:11:11 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:11 -0700 (PDT)
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
Cc:     Michal Kubiak <michal.kubiak@intel.com>
Subject: [net-next PATCH v6 08/16] net: phy: phy_device: Call into the PHY driver to set LED blinking
Date:   Mon, 27 Mar 2023 16:10:23 +0200
Message-Id: <20230327141031.11904-9-ansuelsmth@gmail.com>
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

Linux LEDs can be requested to perform hardware accelerated
blinking. Pass this to the PHY driver, if it implements the op.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/net/phy/phy_device.c | 18 ++++++++++++++++++
 include/linux/phy.h          |  8 ++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 141d63ef3897..79a52dc3c50a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3005,6 +3005,22 @@ static int phy_led_set_brightness(struct led_classdev *led_cdev,
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
@@ -3027,6 +3043,8 @@ static int of_phy_led(struct phy_device *phydev,
 
 	if (phydev->drv->led_brightness_set)
 		cdev->brightness_set_blocking = phy_led_set_brightness;
+	if (phydev->drv->led_blink_set)
+		cdev->blink_set = phy_led_blink_set;
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2a5ee66b79b0..cad757d55ec9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1083,6 +1083,14 @@ struct phy_driver {
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

