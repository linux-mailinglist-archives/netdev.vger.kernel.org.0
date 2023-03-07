Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A769B6AF8E0
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjCGWeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjCGWdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:44 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CB59EF67;
        Tue,  7 Mar 2023 14:33:35 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k37so8794595wms.0;
        Tue, 07 Mar 2023 14:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DtgsVIE8/r/u/FOFl3VwbasZiOSZ2CLInrLaIK3WMmg=;
        b=iVDt98pbmXd3eMwwYRCK3CvogbBXGTgRDbyFDl+2FLPPKNkNML1w+vuxmmkp+HPk6Y
         QGTRm6Ectf0ewJgfpNouJXdD3gDvPfuac2PljVF8OVaukK5irObEFIMSVAsM6rAWxdNK
         JJ/t+9SW4KlSaTkXhNT95LhZW6E8izylTDILKBLNlwxFOQ+FloSFiLyZH9i6oJQ11qGK
         rkSPBA2Qobs7SoDnfH+GZ83CABU8qHX/3VrnYUU1gmNMuHv+in27KBuZuccJ7M0kvFde
         r702WMN1joiuPLHAI8utejeeUgZEpe3t8IFxmBjlA73vTPKMh2Zqp9+hGQfupKjm/APp
         ygcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtgsVIE8/r/u/FOFl3VwbasZiOSZ2CLInrLaIK3WMmg=;
        b=lxAc91WTQuIHspZOkgUWbR+MUPMUczuOXn5Yay/ffrwD9HC5KloTUW+3NbOdq9gLBj
         pYlrr8Tvxy7oxxsgoujr2Rlljwk00EiBJoC6tp8zAEdLrB+q+KQOPnckK9PsoGygN2X4
         TbFlByo0FNnR4kPn2ZUqLjMhRi+pjOO1etNJ/nluEW5PS4/3BPp8FCwH6PCPCN4pVgec
         GZwa7HY4jhaYWwgsIOdA0JH9PrOP4wrCYMOX3GkU0+Jft+g4BFptk1pNCMxVn4W5oV7E
         Xh5Cfnx4S//j6YDbzJMQvJewg0Wo4/5H9uOcK6sznkLY90I5m//og+NuVcoAh0d8C1va
         Jgkw==
X-Gm-Message-State: AO0yUKXXdalQzoGJEYYpAVuXhsKMYssZfZD1DL6C8mQC7IjKPCk7M2jT
        2g1rfQ+hm1Tw9bqFPGhZmFg=
X-Google-Smtp-Source: AK7set8P7t6kpUcxeJrplX3CptVfnEYQjz1vmuqiJilS11ababOC1f5ZfYQ4RtW+UbLV6bmwOKaGzQ==
X-Received: by 2002:a05:600c:1546:b0:3eb:2f06:c989 with SMTP id f6-20020a05600c154600b003eb2f06c989mr14515076wmg.22.1678228413591;
        Tue, 07 Mar 2023 14:33:33 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:33 -0800 (PST)
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
Subject: [net-next PATCH 07/11] net: phy: marvell: Implement led_blink_set()
Date:   Tue,  7 Mar 2023 18:00:42 +0100
Message-Id: <20230307170046.28917-8-ansuelsmth@gmail.com>
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

The Marvell PHY can blink the LEDs, simple on/off. All LEDs blink at
the same rate, and the reset default is 84ms per blink, which is
around 12Hz.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
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

