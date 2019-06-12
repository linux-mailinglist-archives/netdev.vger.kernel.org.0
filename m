Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB443033
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbfFLTbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:31:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39707 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbfFLTbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 15:31:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so7687286wma.4;
        Wed, 12 Jun 2019 12:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GRfoFY5xQdWZ+zyZrF8x4tIZrgk1L2WHamAGKM9+HbI=;
        b=cW8ArLx8R6N5xr2r4LBArrHMDLSr4xhtVhXTwo3cyH0pZ/Ul6OiDLvY2QJnAMERvEa
         9GrVEbOvQJLUAuXBKGRrL8k65d+/0f9Cjja/chMLJZhUR0raNc2wwZ47FKlQlN6Nbx/D
         ejpOw4FfY3PrAM3/7MbYX81LqOGrDuDgiBOb/dwgC+53qCoR1xA1PNqMkd5YUX34sCoN
         q49RuefrUfE/Onr+8uxvEZPe0Az08fWHcsYGxEKx1v6UfnZEeoMx2hg+uI/Png6MHmPd
         us7w/AZSrYIVyB7zLRaZ1nX/1Hdx7saB9BgGgjZIZ2AAPqhn6lDoAVz5GoKKWx6ghSbE
         a3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GRfoFY5xQdWZ+zyZrF8x4tIZrgk1L2WHamAGKM9+HbI=;
        b=lfrs9HnPTZMT5D9aIwvjj6QmrULM8AUqup+Sa0rYhmgJxJksytjkWdg0oI6Uc7Qe6D
         zZm82lsDBo/+7EiDkPubD0Uoa5EQrrBT4SR8dilYLnxWynkj34MT6l4ZJ3uWAiDdoTl0
         Wwm06lCQdp52dAkEHjMYqP+NfqLjNahUx5qayTkRXT73xQGFGdHfsoDqOGioLXA9sdbW
         z5vprdEZbKUT4lV7Gv5q3/G1CL3q8uFbjKr/QcnHuw4iTKnt/4jxeJFS/oabD95LLywa
         M6FBsX5njemGyOYU8ygS7jIpaUs0ITpMxPZmpYf3nZyKIUa8FK+/61T/Zau8RYdqNr3s
         rn4A==
X-Gm-Message-State: APjAAAXUZl8kib+ZmNrI/Ce677OHXyS9UTWgf7MQrsyXvLldtV4/jl+K
        RPEc9abRYOXX+pnHYFzjC878g8S2
X-Google-Smtp-Source: APXvYqzJTIuqNtlPTGYXYCdx+JjK4QSoXYxNTFy2H98HO1zZ/AhRoqP4/zsWF3ehw7sYe6DLw8k+1Q==
X-Received: by 2002:a1c:f515:: with SMTP id t21mr573668wmh.39.1560367895665;
        Wed, 12 Jun 2019 12:31:35 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:33dd:a400:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q15sm379054wrr.19.2019.06.12.12.31.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 12:31:35 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        andrew@lunn.ch
Cc:     linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        maxime.ripard@bootlin.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v2 1/1] net: stmmac: use GPIO descriptors in stmmac_mdio_reset
Date:   Wed, 12 Jun 2019 21:31:15 +0200
Message-Id: <20190612193115.6751-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190612193115.6751-1-martin.blumenstingl@googlemail.com>
References: <20190612193115.6751-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch stmmac_mdio_reset to use GPIO descriptors. GPIO core handles the
"snps,reset-gpio" for GPIO descriptors so we don't need to take care of
it inside the driver anymore.

The advantage of this is that we now preserve the GPIO flags which are
passed via devicetree. This is required on some newer Amlogic boards
which use an Open Drain pin for the reset GPIO. This pin can only output
a LOW signal or switch to input mode but it cannot output a HIGH signal.
There are already devicetree bindings for these special cases and GPIO
core already takes care of them but only if we use GPIO descriptors
instead of GPIO numbers.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 27 +++++++++----------
 include/linux/stmmac.h                        |  2 +-
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 093a223fe408..f1c39dd048e7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -20,11 +20,11 @@
   Maintainer: Giuseppe Cavallaro <peppe.cavallaro@st.com>
 *******************************************************************************/
 
+#include <linux/gpio/consumer.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/mii.h>
 #include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/slab.h>
@@ -251,37 +251,36 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 
 #ifdef CONFIG_OF
 	if (priv->device->of_node) {
+		struct gpio_desc *reset_gpio;
+
 		if (data->reset_gpio < 0) {
 			struct device_node *np = priv->device->of_node;
 
 			if (!np)
 				return 0;
 
-			data->reset_gpio = of_get_named_gpio(np,
-						"snps,reset-gpio", 0);
-			if (data->reset_gpio < 0)
-				return 0;
+			reset_gpio = devm_gpiod_get_optional(priv->device,
+							     "snps,reset",
+							     GPIOD_OUT_LOW);
+			if (IS_ERR(reset_gpio))
+				return PTR_ERR(reset_gpio);
 
-			data->active_low = of_property_read_bool(np,
-						"snps,reset-active-low");
 			of_property_read_u32_array(np,
 				"snps,reset-delays-us", data->delays, 3);
+		} else {
+			reset_gpio = gpio_to_desc(data->reset_gpio);
 
-			if (devm_gpio_request(priv->device, data->reset_gpio,
-					      "mdio-reset"))
-				return 0;
+			gpiod_direction_output(reset_gpio, 0);
 		}
 
-		gpio_direction_output(data->reset_gpio,
-				      data->active_low ? 1 : 0);
 		if (data->delays[0])
 			msleep(DIV_ROUND_UP(data->delays[0], 1000));
 
-		gpio_set_value(data->reset_gpio, data->active_low ? 0 : 1);
+		gpiod_set_value_cansleep(reset_gpio, 1);
 		if (data->delays[1])
 			msleep(DIV_ROUND_UP(data->delays[1], 1000));
 
-		gpio_set_value(data->reset_gpio, data->active_low ? 1 : 0);
+		gpiod_set_value_cansleep(reset_gpio, 0);
 		if (data->delays[2])
 			msleep(DIV_ROUND_UP(data->delays[2], 1000));
 	}
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 4335bd771ce5..816edb545592 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -97,7 +97,7 @@ struct stmmac_mdio_bus_data {
 	int *irqs;
 	int probed_phy_irq;
 #ifdef CONFIG_OF
-	int reset_gpio, active_low;
+	int reset_gpio;
 	u32 delays[3];
 #endif
 };
-- 
2.22.0

