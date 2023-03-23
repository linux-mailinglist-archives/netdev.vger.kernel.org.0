Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6C26C6809
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjCWMT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbjCWMS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:18:58 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796DE2A15A;
        Thu, 23 Mar 2023 05:18:12 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n19so3128238wms.0;
        Thu, 23 Mar 2023 05:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679573891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YnLkHxTE9JMQ3mQ73hylj+o2pAwcVcAzmO3U/Fr8anQ=;
        b=jXTo8/dUCegCVMIrOUd9h8hCeB6RNu8td8IAMWEHC8hT/mXfvfaPmvXBdJjQyhnLX9
         vFol+Xzzl3GvWLRGJPAo27tpwBYpoPLnZeYprcG31QfKiJ7pyLqYvxHLem12+l7rG66A
         b9qWDk9GQcLHHPNQS64+1Q6+6ChFQJQ+HxkGU2iE3Ky0w7WaXsnXD2BJD+zCUMn7oWUz
         hOU3lYcmMII+jCVWDcW8MZnxdaK18kTLXT/Gfiy/N/DItNjKWt4sURpxBUZfz0m83svz
         LEUim7JUGNrAfKTekpewu+pyT1xjaAQDdcTQQcFXzYUZtc3dkMh/EoAR7XOvXZhTbBE1
         L/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679573891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YnLkHxTE9JMQ3mQ73hylj+o2pAwcVcAzmO3U/Fr8anQ=;
        b=ewe47bdiDiaGti30qbN21OZ3+TAhnpViliobqot5RSevW67EmdI1MIq6O3T7Nnbssu
         1lEbCBfEleOFyvqOPy/ruGHDjWMU+erxvz7J9bW7bNrVZGuH5xyK28qwj6DSPIHutGHL
         WMJXtSNh40hVsjlC2Jz4MV0J7tWpF87y5utL3V5m75lZGo8/wTNjgsUAHEEJzlXbLlDw
         snFtg/LWX6VPl/u7MfMNwdaG08Qfr1FfRgC1QqAenxLrL12wceKgNYkTyVJtH/l8D10w
         csnCIaJ+WvgHcyl3Y7mUaUUl7k/DpsyWPKS0pDel72LwzAh6Al9+kKeXTyW5pYvV2GKR
         scMw==
X-Gm-Message-State: AO0yUKUIjFmyOdqpXG+Rd/7YmZw37UY3DE/2+nbxdEw3wugwI+URJe/E
        vZAc91jAm8xS6vFc/m42z4A=
X-Google-Smtp-Source: AK7set/Hl2qlFjtTdqBwTJHpFAScT+oLtuCFt1f0Cm4tah6cl4SscmNx5dpvRZvB02b4sCzssTie8w==
X-Received: by 2002:a7b:c5cd:0:b0:3ee:4f92:907b with SMTP id n13-20020a7bc5cd000000b003ee4f92907bmr2203540wmk.14.1679573890738;
        Thu, 23 Mar 2023 05:18:10 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id m5-20020a05600c4f4500b003ebff290a52sm1760211wmq.28.2023.03.23.05.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 05:18:10 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     paul.geurts@prodrive-technologies.com, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
Date:   Thu, 23 Mar 2023 13:18:04 +0100
Message-Id: <20230323121804.2249605-3-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230323121804.2249605-1-noltari@gmail.com>
References: <20230323121804.2249605-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Paul Geurts <paul.geurts@prodrive-technologies.com>

Add support for the BCM53134 Ethernet switch in the existing b53 dsa driver.
BCM53134 is very similar to the BCM58XX series.

Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 53 +++++++++++++++++++++++++++++++-
 drivers/net/dsa/b53/b53_mdio.c   |  5 ++-
 drivers/net/dsa/b53/b53_priv.h   |  9 +++++-
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 1f9b251a5452..aaa0813e6f59 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1282,6 +1282,42 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 	if (is63xx(dev) && port >= B53_63XX_RGMII0)
 		b53_adjust_63xx_rgmii(ds, port, phydev->interface);
 
+	if (is53134(dev) && phy_interface_is_rgmii(phydev)) {
+		if (port == dev->imp_port)
+			off = B53_RGMII_CTRL_IMP;
+		else
+			off = B53_RGMII_CTRL_P(port);
+
+		/* Configure the port RGMII clock delay by DLL disabled and
+		 * tx_clk aligned timing (restoring to reset defaults)
+		 */
+		b53_read8(dev, B53_CTRL_PAGE, off, &rgmii_ctrl);
+		rgmii_ctrl &= ~(RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
+
+		/* PHY_INTERFACE_MODE_RGMII_TXID means TX internal delay, make
+		 * sure that we enable the port TX clock internal delay to
+		 * account for this internal delay that is inserted, otherwise
+		 * the switch won't be able to receive correctly.
+		 *
+		 * PHY_INTERFACE_MODE_RGMII means that we are not introducing
+		 * any delay neither on transmission nor reception, so the
+		 * BCM53134 must also be configured accordingly to account for
+		 * the lack of delay and introduce
+		 *
+		 * The BCM53134 switch has its RX clock and TX clock control
+		 * swapped, hence the reason why we modify the TX clock path in
+		 * the "RGMII" case
+		 */
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+			rgmii_ctrl |= RGMII_CTRL_DLL_TXC;
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
+			rgmii_ctrl |= RGMII_CTRL_DLL_TXC | RGMII_CTRL_DLL_RXC;
+		b53_write8(dev, B53_CTRL_PAGE, off, rgmii_ctrl);
+
+		dev_info(ds->dev, "Configured port %d for %s\n", port,
+			 phy_modes(phydev->interface));
+	}
+
 	if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
 		if (port == dev->imp_port)
 			off = B53_RGMII_CTRL_IMP;
@@ -2613,6 +2649,20 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
 	},
+	{
+		.chip_id = BCM53134_DEVICE_ID,
+		.dev_name = "BCM53134",
+		.vlans = 4096,
+		.enabled_ports = 0x12f,
+		.imp_port = 8,
+		.cpu_port = B53_CPU_PORT,
+		.vta_regs = B53_VTA_REGS,
+		.arl_bins = 4,
+		.arl_buckets = 1024,
+		.duplex_reg = B53_DUPLEX_STAT_GE,
+		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
+		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+	},
 };
 
 static int b53_switch_init(struct b53_device *dev)
@@ -2671,7 +2721,7 @@ static int b53_switch_init(struct b53_device *dev)
 	dev->ds->num_ports = min_t(unsigned int, dev->num_ports, DSA_MAX_PORTS);
 
 	/* Include non standard CPU port built-in PHYs to be probed */
-	if (is539x(dev) || is531x5(dev)) {
+	if (is539x(dev) || is531x5(dev) || is53134(dev)) {
 		for (i = 0; i < dev->num_ports; i++) {
 			if (!(dev->ds->phys_mii_mask & BIT(i)) &&
 			    !b53_possible_cpu_port(dev->ds, i))
@@ -2790,6 +2840,7 @@ int b53_switch_detect(struct b53_device *dev)
 		case BCM53012_DEVICE_ID:
 		case BCM53018_DEVICE_ID:
 		case BCM53019_DEVICE_ID:
+		case BCM53134_DEVICE_ID:
 			dev->chip_id = id32;
 			break;
 		default:
diff --git a/drivers/net/dsa/b53/b53_mdio.c b/drivers/net/dsa/b53/b53_mdio.c
index 6ddc03b58b28..8b422b298cd5 100644
--- a/drivers/net/dsa/b53/b53_mdio.c
+++ b/drivers/net/dsa/b53/b53_mdio.c
@@ -286,6 +286,7 @@ static const struct b53_io_ops b53_mdio_ops = {
 #define B53_BRCM_OUI_2	0x03625c00
 #define B53_BRCM_OUI_3	0x00406000
 #define B53_BRCM_OUI_4	0x01410c00
+#define B53_BRCM_OUI_5	0xae025000
 
 static int b53_mdio_probe(struct mdio_device *mdiodev)
 {
@@ -313,7 +314,8 @@ static int b53_mdio_probe(struct mdio_device *mdiodev)
 	if ((phy_id & 0xfffffc00) != B53_BRCM_OUI_1 &&
 	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_2 &&
 	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_3 &&
-	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_4) {
+	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_4 &&
+	    (phy_id & 0xfffffc00) != B53_BRCM_OUI_5) {
 		dev_err(&mdiodev->dev, "Unsupported device: 0x%08x\n", phy_id);
 		return -ENODEV;
 	}
@@ -375,6 +377,7 @@ static const struct of_device_id b53_of_match[] = {
 	{ .compatible = "brcm,bcm53115" },
 	{ .compatible = "brcm,bcm53125" },
 	{ .compatible = "brcm,bcm53128" },
+	{ .compatible = "brcm,bcm53134" },
 	{ .compatible = "brcm,bcm5365" },
 	{ .compatible = "brcm,bcm5389" },
 	{ .compatible = "brcm,bcm5395" },
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index a689a6950189..7888be1fd23f 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -80,6 +80,7 @@ enum {
 	BCM583XX_DEVICE_ID = 0x58300,
 	BCM7445_DEVICE_ID = 0x7445,
 	BCM7278_DEVICE_ID = 0x7278,
+	BCM53134_DEVICE_ID = 0x5075,
 };
 
 struct b53_pcs {
@@ -215,7 +216,13 @@ static inline int is58xx(struct b53_device *dev)
 	return dev->chip_id == BCM58XX_DEVICE_ID ||
 		dev->chip_id == BCM583XX_DEVICE_ID ||
 		dev->chip_id == BCM7445_DEVICE_ID ||
-		dev->chip_id == BCM7278_DEVICE_ID;
+		dev->chip_id == BCM7278_DEVICE_ID ||
+		dev->chip_id == BCM53134_DEVICE_ID;
+}
+
+static inline int is53134(struct b53_device *dev)
+{
+	return dev->chip_id == BCM53134_DEVICE_ID;
 }
 
 #define B53_63XX_RGMII0	4
-- 
2.30.2

