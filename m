Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6C96BDED5
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCQCeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCQCdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:41 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B379E6E83;
        Thu, 16 Mar 2023 19:33:33 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id o7so3191234wrg.5;
        Thu, 16 Mar 2023 19:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EAIyowZ09FXZUmzLZp+e5DauphCJoO6duVGhgX3FJVo=;
        b=WmTIDck6RfM6KIxwjL+6WbrVKpHsyN/oiYJ6CrLgqmzPgKKyo/U6AMZ3/6XSd0VjUh
         mvYHtD6mBFd0PgdTDdFG3ltEgyVyYUinJ3Wx9axdB9xaSGJvLhWcMFTs49N3CR2lIfeZ
         Q9B17hiLUJJiOlltnC7FACFsDLW7VIt4fR2fFeSKtE8rJnB81Riz0p3aqWqBWrBLNQ+8
         SiwqcwLE3wCXAHspGgtjwASeDGs5UHO713KMmI3b2J+1jsgPeAI5YKq7VEuBG2w66g9j
         k+9V1d7kpj6CS8D+aIg5CynIok22SI/EAXXgP9CR9WoWQXrYRxri0BxWv9O8rMjHUi5Y
         27KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EAIyowZ09FXZUmzLZp+e5DauphCJoO6duVGhgX3FJVo=;
        b=WYS+39facGA9HYRh0Kx40wLtZPLML4QGBbQwPWAH4pCVlAj/t3UOBe9C91Q8+SrSk6
         pizJqSb6t8SjNxTbIV8Y8lnx9LUH/5BBomHUVoyzL0FmdJ783vHP158aO223fFAM7zKF
         /QMcxNBcN6xklxsQNNpzwblUNNF1kOyNRvPP18S20UNT6VGZs/6iEjFpZfI2sx7vu7CD
         Cwd8BvZXcmSTJbj9mQjc5qiuOd6xUSB9j7/28pecnLT99cF5vCzzDfHUP2J19x/XyCQO
         ZOdHmPaVvHUcmE/VEQT+TBZS+7Qe5pD0PZPkC3YfDn+Ln4GRNN0pCSp3j5Ci86aYfULC
         Eufg==
X-Gm-Message-State: AO0yUKUu0nJNo9/hAerdpoogA2d0C6UIv9MnStTkhlJUYTgAWKCW9nD0
        Ifhtr6pqXEVgshMQkOpXrUU=
X-Google-Smtp-Source: AK7set9An/RnMF2bxwqBBST/FXNnWn65rXRDqvSwgdOgJVCcwLeom+PFgH2uSJ3CcNP12q1jTNS6xw==
X-Received: by 2002:a5d:6084:0:b0:2ce:9e0a:10ae with SMTP id w4-20020a5d6084000000b002ce9e0a10aemr5657138wrt.53.1679020410340;
        Thu, 16 Mar 2023 19:33:30 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:30 -0700 (PDT)
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
Subject: [net-next PATCH v4 08/14] net: phy: marvell: Implement led_blink_set()
Date:   Fri, 17 Mar 2023 03:31:19 +0100
Message-Id: <20230317023125.486-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317023125.486-1-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
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

The Marvell PHY can blink the LEDs, simple on/off. All LEDs blink at
the same rate, and the reset default is 84ms per blink, which is
around 12Hz.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/marvell.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index cadf9da13b82..c86283a4c0a9 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -147,6 +147,8 @@
 #define MII_88E1318S_PHY_LED_FUNC		0x10
 #define MII_88E1318S_PHY_LED_FUNC_OFF		(0x8)
 #define MII_88E1318S_PHY_LED_FUNC_ON		(0x9)
+#define MII_88E1318S_PHY_LED_FUNC_HI_Z		(0xa)
+#define MII_88E1318S_PHY_LED_FUNC_BLINK		(0xb)
 #define MII_88E1318S_PHY_LED_TCR		0x12
 #define MII_88E1318S_PHY_LED_TCR_FORCE_INT	BIT(15)
 #define MII_88E1318S_PHY_LED_TCR_INTn_ENABLE	BIT(7)
@@ -2862,6 +2864,35 @@ static int m88e1318_led_brightness_set(struct phy_device *phydev,
 			       MII_88E1318S_PHY_LED_FUNC, reg);
 }
 
+static int m88e1318_led_blink_set(struct phy_device *phydev, u32 index,
+				  unsigned long *delay_on,
+				  unsigned long *delay_off)
+{
+	int reg;
+
+	reg = phy_read_paged(phydev, MII_MARVELL_LED_PAGE,
+			     MII_88E1318S_PHY_LED_FUNC);
+	if (reg < 0)
+		return reg;
+
+	switch (index) {
+	case 0:
+	case 1:
+	case 2:
+		reg &= ~(0xf << (4 * index));
+			reg |= MII_88E1318S_PHY_LED_FUNC_BLINK << (4 * index);
+			/* Reset default is 84ms */
+			*delay_on = 84 / 2;
+			*delay_off = 84 / 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return phy_write_paged(phydev, MII_MARVELL_LED_PAGE,
+			       MII_88E1318S_PHY_LED_FUNC, reg);
+}
+
 static int marvell_probe(struct phy_device *phydev)
 {
 	struct marvell_priv *priv;
@@ -3112,6 +3143,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1145,
@@ -3219,6 +3251,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -3246,6 +3279,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1545,
@@ -3273,6 +3307,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -3415,6 +3450,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
 		.led_brightness_set = m88e1318_led_brightness_set,
+		.led_blink_set = m88e1318_led_blink_set,
 	},
 };
 
-- 
2.39.2

