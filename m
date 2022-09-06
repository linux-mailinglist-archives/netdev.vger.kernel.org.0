Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C4D5AF656
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiIFUuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiIFUtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:49:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71F61115;
        Tue,  6 Sep 2022 13:49:27 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso3000632pjq.1;
        Tue, 06 Sep 2022 13:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=sTu5hnPVKKbrS3kjiFxTAtowIT69L16Eo7T0raDDBz8=;
        b=PjbMcCIvT/98vMSwy7Uft37YfmyFNTwgkXWNFfk8vx9uBlS22i518kxRi0fXoE533o
         /U8ho5nF8JVcVnIpG0+YfZL928BOE21VIKWYU7Br+z9WktyHydfqTn/9NdE/bglLFo2j
         J69cYeNWDDBNwS/jVBjY9r/HvAh826HOANJttJcaFXukqLpJjt9RsbFdijbRStG2/+cO
         fWoRf7bFZjvXXPxVNZCS+YxM7eaN/FvAgp56QS+8jmxwGVevCALLz7ha1eyh2gx7FZ7X
         qCUY0/nYF6rbbWLoMfTIpU0tjy9O6ucsZ7PTgi1AXgk5vLVNwBe/ktAMXgf+gwLs+WDq
         ST7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=sTu5hnPVKKbrS3kjiFxTAtowIT69L16Eo7T0raDDBz8=;
        b=3o1VgGnNgSCoIAUF3kiHdA78XNNiw4B6Q8+8qVNt+DxBKQztWFAPUSM3vOZzHQQa0y
         mriowDbbvGWvs07oelFHo8MZ+wnYjuhhUE9krD8AdXAsiD7wHzlUpch00uA+EimiYkkM
         gp5RCU8YWupIjyS/UP8wk+BoJ8QJWi7MJwTDFUe5FdnyFQ+2hyE9zemn7fHA9YQUuPVh
         SQARZJOLo9v6NtQ9Dwm/UfqREfMv+pryhp6pQQzks6CIcaBigueR24G0+zAKL1Sj8wCs
         oSqHvv3AfQUlL0X3AXr7/tfOCOLkoxKiHi6n/qNwexWCQZxnecE5dGWGqzqaIJeXnbZW
         6x4Q==
X-Gm-Message-State: ACgBeo208PhZ99UtEj23eNpN/fu/uTOf0vDgHhZy2bYpJYbhOQ7xuHq5
        2yfhxsqlsIkCuDgP14nNnRw=
X-Google-Smtp-Source: AA6agR6+VULZsUOMRYNWWPiGqXh6RG1ze3qzfNOU/4KRhldhDUoQ0OSIToeruWkQ9H6MGIzYRfgcCQ==
X-Received: by 2002:a17:90b:4d8e:b0:200:73b4:4da2 with SMTP id oj14-20020a17090b4d8e00b0020073b44da2mr11338265pjb.197.1662497367075;
        Tue, 06 Sep 2022 13:49:27 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:abc4:5d24:5a73:a96b])
        by smtp.gmail.com with ESMTPSA id e6-20020a656886000000b00434e2e1a82bsm61664pgt.66.2022.09.06.13.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 13:49:26 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net: phy: spi_ks8895: switch to using gpiod API
Date:   Tue,  6 Sep 2022 13:49:22 -0700
Message-Id: <20220906204922.3789922-3-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch switches the driver away from legacy gpio/of_gpio API to
gpiod API, and removes use of of_get_named_gpio_flags() which I want to
make private to gpiolib.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/phy/spi_ks8995.c | 69 ++++++++----------------------------
 1 file changed, 14 insertions(+), 55 deletions(-)

diff --git a/drivers/net/phy/spi_ks8995.c b/drivers/net/phy/spi_ks8995.c
index ff37f8ba6758..d4202d40d47a 100644
--- a/drivers/net/phy/spi_ks8995.c
+++ b/drivers/net/phy/spi_ks8995.c
@@ -17,7 +17,6 @@
 #include <linux/device.h>
 #include <linux/gpio/consumer.h>
 #include <linux/of.h>
-#include <linux/of_gpio.h>
 
 #include <linux/spi/spi.h>
 
@@ -137,15 +136,10 @@ static const struct ks8995_chip_params ks8995_chip[] = {
 	},
 };
 
-struct ks8995_pdata {
-	int reset_gpio;
-	enum of_gpio_flags reset_gpio_flags;
-};
-
 struct ks8995_switch {
 	struct spi_device	*spi;
 	struct mutex		lock;
-	struct ks8995_pdata	*pdata;
+	struct gpio_desc	*reset_gpio;
 	struct bin_attribute	regs_attr;
 	const struct ks8995_chip_params	*chip;
 	int			revision_id;
@@ -401,24 +395,6 @@ static int ks8995_get_revision(struct ks8995_switch *ks)
 	return err;
 }
 
-/* ks8995_parse_dt - setup platform data from devicetree
- * @ks: pointer to switch instance
- *
- * Parses supported DT properties and sets up platform data
- * accordingly.
- */
-static void ks8995_parse_dt(struct ks8995_switch *ks)
-{
-	struct device_node *np = ks->spi->dev.of_node;
-	struct ks8995_pdata *pdata = ks->pdata;
-
-	if (!np)
-		return;
-
-	pdata->reset_gpio = of_get_named_gpio_flags(np, "reset-gpios", 0,
-		&pdata->reset_gpio_flags);
-}
-
 static const struct bin_attribute ks8995_registers_attr = {
 	.attr = {
 		.name   = "registers",
@@ -449,38 +425,22 @@ static int ks8995_probe(struct spi_device *spi)
 	ks->spi = spi;
 	ks->chip = &ks8995_chip[variant];
 
-	if (ks->spi->dev.of_node) {
-		ks->pdata = devm_kzalloc(&spi->dev, sizeof(*ks->pdata),
-					 GFP_KERNEL);
-		if (!ks->pdata)
-			return -ENOMEM;
-
-		ks->pdata->reset_gpio = -1;
-
-		ks8995_parse_dt(ks);
+	ks->reset_gpio = devm_gpiod_get_optional(&spi->dev, "reset",
+						 GPIOD_OUT_HIGH);
+	err = PTR_ERR_OR_ZERO(ks->reset_gpio);
+	if (err) {
+		dev_err(&spi->dev,
+			"failed to get reset gpio: %d\n", err);
+		return err;
 	}
 
-	if (!ks->pdata)
-		ks->pdata = spi->dev.platform_data;
+	err = gpiod_set_consumer_name(ks->reset_gpio, "switch-reset");
+	if (err)
+		return err;
 
 	/* de-assert switch reset */
-	if (ks->pdata && gpio_is_valid(ks->pdata->reset_gpio)) {
-		unsigned long flags;
-
-		flags = (ks->pdata->reset_gpio_flags == OF_GPIO_ACTIVE_LOW ?
-			 GPIOF_ACTIVE_LOW : 0);
-
-		err = devm_gpio_request_one(&spi->dev,
-					    ks->pdata->reset_gpio,
-					    flags, "switch-reset");
-		if (err) {
-			dev_err(&spi->dev,
-				"failed to get reset-gpios: %d\n", err);
-			return -EIO;
-		}
-
-		gpiod_set_value(gpio_to_desc(ks->pdata->reset_gpio), 0);
-	}
+	/* FIXME: this likely requires a delay */
+	gpiod_set_value_cansleep(ks->reset_gpio, 0);
 
 	spi_set_drvdata(spi, ks);
 
@@ -524,8 +484,7 @@ static void ks8995_remove(struct spi_device *spi)
 	sysfs_remove_bin_file(&spi->dev.kobj, &ks->regs_attr);
 
 	/* assert reset */
-	if (ks->pdata && gpio_is_valid(ks->pdata->reset_gpio))
-		gpiod_set_value(gpio_to_desc(ks->pdata->reset_gpio), 1);
+	gpiod_set_value_cansleep(ks->reset_gpio, 1);
 }
 
 /* ------------------------------------------------------------------------ */
-- 
2.37.2.789.g6183377224-goog

