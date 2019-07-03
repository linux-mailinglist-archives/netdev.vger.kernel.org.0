Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4C45ECDF
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 21:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfGCThw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 15:37:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35784 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfGCThk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 15:37:40 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so577826pfn.2
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 12:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=92MMMWQ7DnIvwLqCz1ZLToZjaHseBvhkT/Mp2Z/Tv9k=;
        b=S9JgP9iyGcwTSuU5Ibit1VXMos7cpzyQTnSn13mK3rBRD5RmlHy8K8BGo9PpVDpicm
         z91XR7hdWMinwUYnD2j3tir2SgCHM4vtnDYaVlLMAUV5GkU+GNApM3Xp/yKgxkOF5bl2
         euIrKxgCx3A5x3TnLLAMLZAbwp/QuaMWGLyyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=92MMMWQ7DnIvwLqCz1ZLToZjaHseBvhkT/Mp2Z/Tv9k=;
        b=YlstBy0xJbBHNQA1CIop2FMTZl6CKTbX60URYXLuTyMc5Qogtk5xAYr4nbwrWo8k1j
         DwJQ+U1QpBlsn4+VlvkW6PJrmbNqVhsNgZ+uKpfajY5HgZ/4r4+w8V4E6vxOrXZbZw2a
         54s+8dPExLwQvJ9OiKMdaiBO73nnEgj/0rxUyK4LTEZ3J2aP8KxypwYhbFFxGieGRVy7
         PWYqa7hMMxJjNUBz+JYwncIOf/0y/715UsMFjLRUP8CsEGrs/plGD50zj5r+ZvF/AQqd
         ZfullJ7BPcM39obYcS0r3KrIkjxIwjAzoMQ43aJaPsfZns7Odqvj0CNP/QpYvZFco1FR
         sSVw==
X-Gm-Message-State: APjAAAUrOLXLaQX/FPPWEgJL6LSWM3U2fK4Ezyhv9ESq9jZsBFDdyFML
        PNorOZc6qIcithtojGD5cneg3Q==
X-Google-Smtp-Source: APXvYqz+i2vxmI1brUUWvEihoY3pc7PssJnkoB8NUdEDOglIhqwlU4hxiv0B0CGnk5evw/zLyeO/uA==
X-Received: by 2002:a63:2a83:: with SMTP id q125mr38238567pgq.102.1562182659699;
        Wed, 03 Jul 2019 12:37:39 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id p23sm4448964pfn.10.2019.07.03.12.37.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 12:37:39 -0700 (PDT)
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
Subject: [PATCH v2 7/7] net: phy: realtek: configure RTL8211E LEDs
Date:   Wed,  3 Jul 2019 12:37:24 -0700
Message-Id: <20190703193724.246854-7-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190703193724.246854-1-mka@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
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
Changes in v2:
- patch added to the series
---
 drivers/net/phy/realtek.c | 63 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 45fee4612031..559aec547738 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -9,6 +9,7 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
+#include <linux/bits.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -35,6 +36,15 @@
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
@@ -124,6 +134,56 @@ static int rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
 	return phy_restore_page(phydev, oldpage, ret);
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
+		lacr_bits |= (u16)(val >> 16) <<
+			(RLT8211E_LACR_LEDACTCTRL_SHIFT + i);
+		lcr_bits |= (u16)(val & 0xf) << (i * 4);
+	}
+
+	oldpage = rtl8211e_select_ext_page(phydev, 44);
+	if (oldpage < 0) {
+		dev_err(dev, "failed to select extended page: %d\n", oldpage);
+		goto err;
+	}
+
+	ret = __phy_modify(phydev, RTL8211E_LACR,
+			   RLT8211E_LACR_LEDACTCTRL_MASK, lacr_bits);
+	if (ret) {
+		dev_err(dev, "failed to write LACR reg: %d\n", ret);
+		goto err;
+	}
+
+	ret = __phy_modify(phydev, RTL8211E_LCR,
+			   RTL8211E_LCR_LEDCTRL_MASK, lcr_bits);
+	if (ret)
+		dev_err(dev, "failed to write LCR reg: %d\n", ret);
+
+err:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -137,8 +197,7 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 			dev_err(dev, "failed to enable SSC on RXC: %d\n", ret);
 	}
 
-	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
-		rtl8211e_disable_eee_led_mode(phydev);
+	rtl8211e_config_leds(phydev);
 
 	return 0;
 }
-- 
2.22.0.410.gd8fdbe21b5-goog

