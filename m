Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5826D6B9B16
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjCNQSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjCNQSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:18:01 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D1DACE2C;
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id y14so2211381wrq.4;
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mcPDqv1MH0gdrEhrxsDvDnbiYWzw+6vrk0oNxbr+mS0=;
        b=D1e2CH/f1ZCpmavJDAsroXoWcjiMQI/0VbpSHMMGtGkrnOo8btyw5KwJE2cPL4Zmuq
         uWvdBMTtHTuKWN//E1vyNY0kAavHh07YZYE3PTG1HwtD00TKJ8AyRenztNeuZUKGL1/n
         xMblzmMl5564QkdZfwgkBJ1yS5yq8vTwSrLeHBCjs6pwOG5u2PGzjgDcDig4SAkW22b+
         +xrB+VNRwUXiXko8a2vzKqWFCiD3zGN/A1zXHeeQ1uGPcuyXayjq/gWX8d88Dksf9PcM
         RUIvcmL4VAjczpWHkAQJnxPXZR+LYIUkLDwA6NAkjy9v3HP/c4uI2mGkcJe1SNuUt5gI
         V7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mcPDqv1MH0gdrEhrxsDvDnbiYWzw+6vrk0oNxbr+mS0=;
        b=AhU4TODBMM8WbBJ6jtFycQ0yqTUON83/m5gfG8foVcsqXUqKXD+YhBJ/xjjEulCVpC
         yIOTPIOs79o0WnmX/3YZY6upByh2ULnVmSr4DMZs5HxYEwooAIiQmii9VXWUoVcxslg+
         vxMs29WoAZ1DC0aQZhzw8gUA/E4HG9jZuQ8mDDEmSWNcMfCQwO6hDmh8hbGemZA0w3Sl
         sfVVesnkZk5A6omQcFlbZbeO0h3UigVWiJ0xp62Y/ugRZc+mrZkG8cSrAbKnwbGntvuC
         eee1NjeHj2RCPvDI/2ogD9beQTPBalarUrL4+NaW4m8eZWyP+2dljNnH48d7j4RBOuI+
         xqXg==
X-Gm-Message-State: AO0yUKUD1Ma6h0rHB4lH87iH/3j/nujkTC1L8z2txID8x7XoDp1O2L8K
        V89LKmBT92GiD7iE+23VFeQ=
X-Google-Smtp-Source: AK7set8a7/AmQX7PPf5abhQ/ZBDr/Jz8ga38bbW4w6nrGzK2WDLFQPrqAYuv/J80ISAlt5RIaHD7PA==
X-Received: by 2002:adf:eb46:0:b0:2cf:e8f4:d1ea with SMTP id u6-20020adfeb46000000b002cfe8f4d1eamr2530041wrn.29.1678810652188;
        Tue, 14 Mar 2023 09:17:32 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:31 -0700 (PDT)
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
Subject: [net-next PATCH v3 08/14] net: phy: marvell: Implement led_blink_set()
Date:   Tue, 14 Mar 2023 11:15:10 +0100
Message-Id: <20230314101516.20427-9-ansuelsmth@gmail.com>
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

The Marvell PHY can blink the LEDs, simple on/off. All LEDs blink at
the same rate, and the reset default is 84ms per blink, which is
around 12Hz.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/marvell.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index e44a4a26346a..3252b15266e2 100644
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
+	u16 reg;
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

