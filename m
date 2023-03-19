Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA556C0433
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjCSTTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjCSTSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:18:48 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F936977B;
        Sun, 19 Mar 2023 12:18:46 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j2so8508881wrh.9;
        Sun, 19 Mar 2023 12:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I03i0AWrulDKLnS6IGJCsuyb6CMg/g/eSeO6qoSzm0E=;
        b=m2G6fqst6xNiEiWCS+uBgPjPLL1mSZwnuXjYkWZ+i4KjUKWHPyYGicNWHls/kU2p5i
         IB8CX22kumFv8A3gW5TYAWTBJXZou6UoZo2Sa6daICCqwon5sPEjRBGL7FSnLHSNH4gX
         +wkRf2H0cF1ld5KF8WsyMSd0DciD4JOMwGWoIwwN91BC8nDEFNYMxLwLAZ0mK8b26Dyw
         w/o1BncYp8LXeOA1EalPvv+NbSLF15LcGfwhfhAixJ1vtDbNWciXVAWIdTdrj0jrT8q2
         plXuFNucGlDkfTzXup/fZphh2UIQt20glN2XbGr7RZCv4wxE1odZ5+F+y13ZXKguDRET
         GZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I03i0AWrulDKLnS6IGJCsuyb6CMg/g/eSeO6qoSzm0E=;
        b=x6g/jo/oOUlQkv08/Go8C2fS3OvfnsB61rjdsFRSC5A2q4haJ+/lSiW83YjhFggdFm
         RAmwTLe7gowsi0uAkZujJ41zxkFS75svykYFeXc5desc9hAHX1/b4BxsO+I/VWIkS+x+
         EQDr3qsleDp6mWAPQ7T1b1VYUmTh0STIBJ4yreRCJmqg7OAevh6wdgs7XKx++jf9IjLl
         MEVQvgljo8yh02jaz5PNsZe/5NplUnrKVPOz2IleG1khkKGhJHiyyPVH6MXV5v2w+Pvl
         IukHv0qxCcpZ6jPGTNhcD4MbQM6eTYdn1ypcnGUwvs7JTECFnojbMSooFwjO4hS06Xbw
         RfZA==
X-Gm-Message-State: AO0yUKVZBlwTxHlsf98RvKYNp9GmEEFdhAAz3+bma88vGA93dZVI9ywW
        eDA4SX426HQA6x+w3XZJdWI=
X-Google-Smtp-Source: AK7set+Zc1D46FmhuQEgMV/0yTk7Po5rFjwesYeQfwuSoEnvmhgc4qCt8ECWJMZYoD9A987DXITjJw==
X-Received: by 2002:adf:fbc8:0:b0:2d6:cc82:3c49 with SMTP id d8-20020adffbc8000000b002d6cc823c49mr1042691wrs.13.1679253524565;
        Sun, 19 Mar 2023 12:18:44 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:44 -0700 (PDT)
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
Subject: [net-next PATCH v5 07/15] net: phy: marvell: Add software control of the LEDs
Date:   Sun, 19 Mar 2023 20:18:06 +0100
Message-Id: <20230319191814.22067-8-ansuelsmth@gmail.com>
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

Add a brightness function, so the LEDs can be controlled from
software using the standard Linux LED infrastructure.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/marvell.c | 45 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 63a3644d86c9..5f4caca93983 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -144,11 +144,13 @@
 /* WOL Event Interrupt Enable */
 #define MII_88E1318S_PHY_CSIER_WOL_EIE			BIT(7)
 
-/* LED Timer Control Register */
-#define MII_88E1318S_PHY_LED_TCR			0x12
-#define MII_88E1318S_PHY_LED_TCR_FORCE_INT		BIT(15)
-#define MII_88E1318S_PHY_LED_TCR_INTn_ENABLE		BIT(7)
-#define MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW		BIT(11)
+#define MII_88E1318S_PHY_LED_FUNC		0x10
+#define MII_88E1318S_PHY_LED_FUNC_OFF		(0x8)
+#define MII_88E1318S_PHY_LED_FUNC_ON		(0x9)
+#define MII_88E1318S_PHY_LED_TCR		0x12
+#define MII_88E1318S_PHY_LED_TCR_FORCE_INT	BIT(15)
+#define MII_88E1318S_PHY_LED_TCR_INTn_ENABLE	BIT(7)
+#define MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW	BIT(11)
 
 /* Magic Packet MAC address registers */
 #define MII_88E1318S_PHY_MAGIC_PACKET_WORD2		0x17
@@ -2832,6 +2834,34 @@ static int marvell_hwmon_probe(struct phy_device *phydev)
 }
 #endif
 
+static int m88e1318_led_brightness_set(struct phy_device *phydev,
+				       u32 index, enum led_brightness value)
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
+		if (value == LED_OFF)
+			reg |= MII_88E1318S_PHY_LED_FUNC_OFF << (4 * index);
+		else
+			reg |= MII_88E1318S_PHY_LED_FUNC_ON << (4 * index);
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
@@ -3081,6 +3111,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1145,
@@ -3187,6 +3218,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -3213,6 +3245,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1545,
@@ -3239,6 +3272,7 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -3380,6 +3414,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
+		.led_brightness_set = m88e1318_led_brightness_set,
 	},
 };
 
-- 
2.39.2

