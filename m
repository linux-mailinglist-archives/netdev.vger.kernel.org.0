Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F171462966
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403992AbfGHTZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:23 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43165 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403956AbfGHTZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id cl9so8744966plb.10
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RvgoMdD3Hp5MNxLK+UifXpyN/q0ZxRgeuu9cUaFHqr8=;
        b=SpMlpQid2jj35QITypL4R5jsoWc0eG7EtxUCSVBodyEYgZle89BhBjfYFUQcF2IcgI
         mXOOm3S92C45cfdZOxjxUNPEiD0QpH1HZiyzpYze+Mrg3gwzJZnA0thsvhG+Ajpoyf6/
         6XTwCEWLcN8yOYJBHr+iZ35NTAosHvvbZSfqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RvgoMdD3Hp5MNxLK+UifXpyN/q0ZxRgeuu9cUaFHqr8=;
        b=PUOPJYaCjPDwrhRJHwFed9WK8UTt0ERE9WygTY9SrDnoei4u34VNnFXbv/ST0k3Q7S
         TteWn0XzAkZB1/j4MMjFeXPiEuDJe6KTp2205MCojcZ9JmZlXmLLxW4ORaKwtm55vHP8
         Q8fvnPRYU0yyB9zHKXjqwtJlYGU3jxqIzSwoSA/3LXvmeb8Us3c1a3NVdNiAhfkS5ai2
         Yyc/oFakG5GChx5r0VwJlUhLzbdugbyibCXfuzFzxwsRAc4cKYUJePEVVmQL3BpmXvah
         DFotoJooMdzK2zRIHIlnA/B3x4LGIL/cCVa5DZCPGL9QkFVWL/a0roQoK4df9jRJ/nnY
         Beuw==
X-Gm-Message-State: APjAAAX9vMT5KyWy7Gjeuqw+ZmjZLUbn/n6okuXVpvXMA2YQxfnahD+u
        E1Mu6+m0lWmGdCVhSwRnabnBgg==
X-Google-Smtp-Source: APXvYqyYbItR6VGpkLNF5CZeyV8kogEprG74LIry/HE4PBk2qDVJtcyVuPh67bU1HhhmNxBuH27ERw==
X-Received: by 2002:a17:902:fe93:: with SMTP id x19mr25192719plm.77.1562613920330;
        Mon, 08 Jul 2019 12:25:20 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id e13sm14330516pff.45.2019.07.08.12.25.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:19 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v3 7/7] net: phy: realtek: configure RTL8211E LEDs
Date:   Mon,  8 Jul 2019 12:24:59 -0700
Message-Id: <20190708192459.187984-8-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708192459.187984-1-mka@chromium.org>
References: <20190708192459.187984-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure the RTL8211E LEDs behavior when the device tree property
'realtek,led-modes' is specified.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
TODO: DT validation

Changes in v3:
- sanity check led-modes values
- set LACR bits in a more readable way
- use phydev_err() instead of dev_err()
- log an error if LED configuration fails

Changes in v2:
- patch added to the series
---
 drivers/net/phy/realtek.c | 72 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 5854412403b5..e9fb67654c4e 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -9,10 +9,12 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
+#include <linux/bits.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/phy.h>
+#include <dt-bindings/net/realtek.h>
 
 #define RTL821x_PHYSR				0x11
 #define RTL821x_PHYSR_DUPLEX			BIT(13)
@@ -34,6 +36,15 @@
 #define RTL8211E_EEE_LED_MODE1			0x05
 #define RTL8211E_EEE_LED_MODE2			0x06
 
+/* RTL8211E extension page 44 */
+#define RTL8211E_LACR				0x1a
+#define RLT8211E_LACR_LEDACTCTRL_SHIFT		4
+#define RLT8211E_LACR_LEDACTCTRL_MASK		GENMASK(6, 4)
+#define RTL8211E_LCR				0x1c
+#define RTL8211E_LCR_LEDCTRL_MASK		(GENMASK(2, 0) | \
+						 GENMASK(6, 4) | \
+						 GENMASK(10, 8))
+
 /* RTL8211E extension page 160 */
 #define RTL8211E_SCR				0x1a
 #define RTL8211E_SCR_DISABLE_RXC_SSC		BIT(2)
@@ -123,6 +134,62 @@ static void rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
 	phy_restore_page(phydev, oldpage, err);
 }
 
+static int rtl8211e_config_leds(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	int count, i, oldpage, ret;
+	u16 lacr_bits = 0, lcr_bits = 0;
+
+	if (!dev->of_node)
+		return 0;
+
+	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
+		rtl8211e_disable_eee_led_mode(phydev);
+
+	count = of_property_count_elems_of_size(dev->of_node,
+						"realtek,led-modes",
+						sizeof(u32));
+	if (count < 0 || count > 3)
+		return -EINVAL;
+
+	for (i = 0; i < count; i++) {
+		u32 val;
+
+		of_property_read_u32_index(dev->of_node,
+					   "realtek,led-modes", i, &val);
+		if ((val > RTL8211E_LINK_10_100_1000 &&
+		    val < RTL8211E_LINK_ACTIVITY) ||
+		    val > (RTL8211E_LINK_ACTIVITY | RTL8211E_LINK_10_100_1000))
+			return -EINVAL;
+
+		if (val & RTL8211E_LINK_ACTIVITY)
+			lacr_bits |= BIT(RLT8211E_LACR_LEDACTCTRL_SHIFT + i);
+
+		lcr_bits |= (u16)(val & 0xf) << (i * 4);
+	}
+
+	oldpage = rtl8211e_select_ext_page(phydev, 44);
+	if (oldpage < 0) {
+		phydev_err(phydev, "failed to select extended page: %d\n", oldpage);
+		goto err;
+	}
+
+	ret = __phy_modify(phydev, RTL8211E_LACR,
+			   RLT8211E_LACR_LEDACTCTRL_MASK, lacr_bits);
+	if (ret) {
+		phydev_err(phydev, "failed to write LACR reg: %d\n", ret);
+		goto err;
+	}
+
+	ret = __phy_modify(phydev, RTL8211E_LCR,
+			   RTL8211E_LCR_LEDCTRL_MASK, lcr_bits);
+	if (ret)
+		phydev_err(phydev, "failed to write LCR reg: %d\n", ret);
+
+err:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -267,8 +334,9 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 				   ret);
 	}
 
-	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
-		rtl8211e_disable_eee_led_mode(phydev);
+	ret = rtl8211e_config_leds(phydev);
+	if (ret)
+		phydev_err(phydev, "LED configuration failed: %d\n", ret);
 
 	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
 	switch (phydev->interface) {
-- 
2.22.0.410.gd8fdbe21b5-goog

