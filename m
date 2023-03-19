Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3132D6C0432
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjCSTTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjCSTSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:18:50 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7134F968;
        Sun, 19 Mar 2023 12:18:47 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id h17so8511449wrt.8;
        Sun, 19 Mar 2023 12:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ezsnOVpve2+kzTAIvtEvXAR8w742axG9ioJbZmh2wbA=;
        b=LMbQRhbVQBp13CYGQy9BpUeGJX9d2zPyAyz1L8QWqGqPeHvggoSEo29h5e75Mai5Ru
         SpX5PtmdoEa55ZkutLVBv0PMtQmAE00Gvn0AbcWGiwfo6fQxgpR2L+Cp3wFxo+pSXwOo
         A9Iq9g7taZHCLMCBV5ayWuUZU3kB5eQs/Ysk532BdStC//+oi2R6e0a9X8x4NaWlSgX7
         cqIZkQmWwLtPU75jHclkspOv21xnRaeA2UYw8ydbS+J3IbV28VWNgMwU/XclCExX5Esf
         SQkC534aHw9ftO8BJGERz2cxQMrZrnEsux58jk1v8AZFm1MvzjieRk9ytEDqUNpiXigx
         tV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ezsnOVpve2+kzTAIvtEvXAR8w742axG9ioJbZmh2wbA=;
        b=46nWLH33YNWQxqAHvqmi0Q0WiMzKJeq1BetbMzLQ4RPJUA9Bywn6LWNiF22Jotm/Gz
         JZTzGG86uY0tuKx5I8nRfVxnICLfi24WhmluOIZwrZX96YHpHzur9wnZ0zd7Q9wODs1Z
         YonTCu11bMjruo7PhkNLFXE5t66bd3XqxFumw2zkIUguyz3ZN1Te45OlsTItSWS7P+X2
         WJDZsS/istjkpCA6PH5o790aThCxc8AM8mY20oQF2BkK+cVF1gyi0oJpYrIZQul8VclG
         MM5mWZFhbMd5bP17xTZ4z3tpK7eU3VcDvNm7fAfjs3rpEDkJXdReo74RRXPzNBX1tWmp
         UZ3A==
X-Gm-Message-State: AO0yUKVbB4nqcmHYoAjulsvQ+hoCqOb1KY5BLU1kPPQSD9BK9MfR211V
        aKqioBL/RQquvnHfvK0B0Ec=
X-Google-Smtp-Source: AK7set8CkczEyFzQp8MJp8UlLnRzJgsh6ijwYsaY84PB1rYCQHpfOS6wwImft3lDUdZfZOaEyc+lYg==
X-Received: by 2002:a5d:4381:0:b0:2ce:a8e2:f89e with SMTP id i1-20020a5d4381000000b002cea8e2f89emr10826621wrq.46.1679253525922;
        Sun, 19 Mar 2023 12:18:45 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:45 -0700 (PDT)
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
Subject: [net-next PATCH v5 08/15] net: phy: phy_device: Call into the PHY driver to set LED blinking
Date:   Sun, 19 Mar 2023 20:18:07 +0100
Message-Id: <20230319191814.22067-9-ansuelsmth@gmail.com>
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

Linux LEDs can be requested to perform hardware accelerated
blinking. Pass this to the PHY driver, if it implements the op.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
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

