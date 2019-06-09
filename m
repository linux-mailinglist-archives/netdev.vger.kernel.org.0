Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7CA53AAFC
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 20:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbfFISGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 14:06:43 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:33379 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729540AbfFISGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 14:06:43 -0400
Received: by mail-wr1-f51.google.com with SMTP id n9so6929047wru.0;
        Sun, 09 Jun 2019 11:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JK2PulRNGQmFo+RP5Op3ozfnTDQeRnONpdvKX0IfeL0=;
        b=eEMGV64K6Dkp3fWw3ioIkBFOiKweVwTU9WGCM5duGAqykGKN3LM2KtArW0Pcqsihni
         RbvbNv4Xah8lbvMgyLiLVabwbAp+b6WSEyBGlI6gzOmepc4mLHMKyjlrUk3YEfiFPDAr
         eW5X3IBGH1BFS6befrawNPAoFYfaUIKiATlEUiB2B3e15NmEMSRe+GOr+1yXhDtw1+of
         Bqc4aoX1zwxiG0jash5n+hSk7AkWEJXXL896PlcDaftDYIVA18qmWAMG4xwyYkboXO/N
         G5ZW3oobBaxoIWKHbIpaJJtVXl+AG4EsSbbM303lMrpyueFWrPx93mHsDDv7c2axUtNo
         E+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JK2PulRNGQmFo+RP5Op3ozfnTDQeRnONpdvKX0IfeL0=;
        b=XIeOLs3IcOOEcfZCL5lQGXqRttgUIdS9SmMZywr+vFdiZ0rNBosB8CjyohQ86BIEdN
         fzFrN2GxgjuO1XjONAFVpQycOdiPtMfF6Nj2w0aUusqqIHltzfyzO2XTnv2DiUj1f987
         I5ix3caOrWAekRy15xB5nifJoPLXa7oMjBLk0siGt6blReLrUUh5APJzBUSesMuLics+
         bD0qntI2kzPdMr37uUfk0Z/hz8ji/Uz0HDYnhrXM9S5ni9pedxu0Hy+XyW2J9+aiKMdw
         Czqt78JbRtL/GMmZDemIZm6jLJsvTYfSXIfXZLivHiJbiZv7NIzTiB68pcn/9g0xp3r2
         vr+Q==
X-Gm-Message-State: APjAAAWy/qLtDxcmKH7EAdGzIOmnvQFkDKqqJtA4BCs+gGvKQx0k6cj+
        q4Oj31iLWXVEc3UwE4D4zo4UUQj1
X-Google-Smtp-Source: APXvYqwR6AUeRy3jJYBszo8W1YC0z7PSrhbXvMQ6iABRsfpGm6KCOpQTGRtKGcOmO7GX0cLUzDix3A==
X-Received: by 2002:a5d:5510:: with SMTP id b16mr7107494wrv.267.1560103600015;
        Sun, 09 Jun 2019 11:06:40 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400B42D8EB9D711C35E.dip0.t-ipconnect.de. [2003:f1:33dd:a400:b42d:8eb9:d711:c35e])
        by smtp.googlemail.com with ESMTPSA id h14sm2007731wrs.66.2019.06.09.11.06.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 11:06:39 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Cc:     devicetree@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        khilman@baylibre.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC next v1 3/5] net: stmmac: use GPIO descriptors in stmmac_mdio_reset
Date:   Sun,  9 Jun 2019 20:06:19 +0200
Message-Id: <20190609180621.7607-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
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
---
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 27 +++++++++----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index cb9aad090cc9..21bbe3ba3e8e 100644
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
@@ -251,34 +251,33 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 
 #ifdef CONFIG_OF
 	if (priv->device->of_node) {
+		struct gpio_desc *reset_gpio;
+
 		if (data->reset_gpio < 0) {
 			struct device_node *np = priv->device->of_node;
 
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
-- 
2.21.0

