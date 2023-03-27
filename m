Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25136CA70A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbjC0OMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbjC0OLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:39 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E395C469E;
        Mon, 27 Mar 2023 07:11:14 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q19so5881880wrc.5;
        Mon, 27 Mar 2023 07:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZjvAY85UXOr+ThDvTHRudHDXforsIMNPqrBvOVPkO7w=;
        b=BnBagk+9VpROq4Tf1RT9RRu/EhgB2nIGt8rdECWKEYlpOn+2R1KjpHlKJO/6REt+aO
         XFGR5TfJKQ0nuUN5fTbNDE946t3JktNw9oJj0u4t/vMygscrUNVxoqK4m9qEsN1Z+pJF
         MZqCGo9dsFhLJG38XvG6OSEUAclg5Tj5K5po1Yxb47WEz0nhRQf4Q4IyHNDQFKXAUx+I
         BFFlZ4/rZ1JVQEbcq8Swdhj9tMseeAbRbohgKSHGg/WXdpofX69nY9r4m/XLtINhcTT2
         cX+l0rouWy4G2Km3KG9sEXFRA2fq72z9y7xKXgubftbKT5GUrdUJc+q1yoBG0Sych1a/
         zHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZjvAY85UXOr+ThDvTHRudHDXforsIMNPqrBvOVPkO7w=;
        b=OxpHOJVSzTu16ML4HbATn3j2Why6WIsDt/vo/4qSrWYDm4DLoj+/xbFEJkAS+KxLkO
         U84Vw1Qu0DToBXKGQHcse8k1awL2Wb4rlvXkAdLBufLRU29OA1/yW4LGPRNvZ9WWvbs+
         XmPPZjevq5gWi5bjSdb9E1HilmzKFaG/f86N3F8sNbuYt8XMIrgtSEiORZX2NdMJinN5
         6mQLWXvQ+ZjbA5ofwdhmaHfz/Kwi0x8MKL1VvjzkstRXjfGHK3TQlQSl9nUY8bpvEyRb
         gx8osmkGI7vfyighexGE6grOF+IVHDWMQwdSUnMHUqOoIhCpQKPBYi2uWYmy4jqZvBDr
         YJGw==
X-Gm-Message-State: AAQBX9d4lDXLx/SG26AEr60iCnjHi3KHcJtlaNmqxoCiKgzNeYE4ZZZq
        tZ32JDTgXf/00kvBDR7UYg4=
X-Google-Smtp-Source: AKy350YasPcjRwvxxin6Tg6KZYi/hXbAFqXIRYrBEybGSS73LmuVVbvFEZzt70RIX8lNCFVSj2dk/w==
X-Received: by 2002:adf:f04f:0:b0:2d7:a918:a2b7 with SMTP id t15-20020adff04f000000b002d7a918a2b7mr9525140wro.48.1679926273273;
        Mon, 27 Mar 2023 07:11:13 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:12 -0700 (PDT)
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
Subject: [net-next PATCH v6 09/16] net: phy: marvell: Implement led_blink_set()
Date:   Mon, 27 Mar 2023 16:10:24 +0200
Message-Id: <20230327141031.11904-10-ansuelsmth@gmail.com>
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

The Marvell PHY can blink the LEDs, simple on/off. All LEDs blink at
the same rate, and the reset default is 84ms per blink, which is
around 12Hz.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/net/phy/marvell.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5f4caca93983..c00f67f229f5 100644
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

