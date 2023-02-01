Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F3B685EFE
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjBAFez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBAFey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:34:54 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964593608D;
        Tue, 31 Jan 2023 21:34:53 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id jh15so8329463plb.8;
        Tue, 31 Jan 2023 21:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFD+Vrnd0XDD4nt9rmOxBW0D3X3nxjbF33yttjrNMpE=;
        b=gzu371xpPFb9Ngyx/RNXq84lJl9z6YgBBkokz0eJNuFelO7k90deJDAE2AmLqo5B6E
         NDRhI81m8IQE3+dpsSnTqa7GYjkBpFmOhcwUftQ//05arPMSdySvQUCjhJMdeivUqk37
         uEKfbaUPq5By+W7mpR+xkg1lMuZtLoTl6PQuNaoqGZ+oFPi7t0VXY7UXdU/sYpIA0XuH
         DqF9U0/QB4XcP1UElEEblGD/XIj54cLJrHq4FiRFm27jSA5QOWmkv+OeqfvRPfVZUJoy
         wq80/zhCULac5jzAP8q3IKI6/zStC5RKDALSeoCUcyGDbRbRCgU4ibdcOfE46JEO8nhV
         S7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZFD+Vrnd0XDD4nt9rmOxBW0D3X3nxjbF33yttjrNMpE=;
        b=UXHIuvEXvGUmbSxBcqHhpQ45eSXlhs84rgNFNxD0pLRSKiUfsez/394kABTpKrK/aL
         jaBAGY/yysJ2RkEZfBkPCeaAGSgpekaXmN3oWBvhfeA6ZqMoZHUx4Mc+zoEV+a6yZKp5
         TacwZ5DgIms4SuFUUkr2Q3qt6NEBRZNtoXXq3NLDXITiMpZqZshELal0EMO+F8SPE7pq
         yhEnW2gZ/UmL0wSQHz2r0q4HXaIcT1CSnisPtev/6+QUe4trX/spysgcOBso7Ob17yPo
         5QiQTGHbvxPPjwlW4f8dgHzc26c2O5rbdwiJ13ZnuSQFEnk45vmsBcdMoJtkwHwNJm++
         MhPg==
X-Gm-Message-State: AO0yUKW/WLT/sv39GVrR0Gb6PJrQ2osJXMqeqXI62AK5Ir9e2nKDAaWL
        9Z7kaUuNiSehPCQmJeQzs3T4an9SqbM=
X-Google-Smtp-Source: AK7set9oPnlLah1vw+94t4t064jaqb0tGmGNH3hyhZsDN1TXKY02wMLm4pe1X4z6/LlVIDgv6+TEgg==
X-Received: by 2002:a17:90b:33d1:b0:22b:ec81:c36c with SMTP id lk17-20020a17090b33d100b0022bec81c36cmr774688pjb.45.1675229692826;
        Tue, 31 Jan 2023 21:34:52 -0800 (PST)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id kb1-20020a17090ae7c100b001fde655225fsm3233026pjb.2.2023.01.31.21.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 21:34:51 -0800 (PST)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/2] ieee802154: at86rf230: drop support for platform data
Date:   Tue, 31 Jan 2023 21:34:46 -0800
Message-Id: <20230201053447.4098486-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
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

There are no users of platform data in the mainline tree, and new
boards should use either ACPI or device tree, so let's stop supporting
it. This will help with converting the driver to gpiod API.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/ieee802154/at86rf230.c | 42 ++++++++----------------------
 include/linux/spi/at86rf230.h      | 20 --------------
 2 files changed, 11 insertions(+), 51 deletions(-)
 delete mode 100644 include/linux/spi/at86rf230.h

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 15f283b26721..d6b6b355348b 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -17,8 +17,8 @@
 #include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
+#include <linux/property.h>
 #include <linux/spi/spi.h>
-#include <linux/spi/at86rf230.h>
 #include <linux/regmap.h>
 #include <linux/skbuff.h>
 #include <linux/of_gpio.h>
@@ -1415,32 +1415,6 @@ static int at86rf230_hw_init(struct at86rf230_local *lp, u8 xtal_trim)
 	return at86rf230_write_subreg(lp, SR_SLOTTED_OPERATION, 0);
 }
 
-static int
-at86rf230_get_pdata(struct spi_device *spi, int *rstn, int *slp_tr,
-		    u8 *xtal_trim)
-{
-	struct at86rf230_platform_data *pdata = spi->dev.platform_data;
-	int ret;
-
-	if (!IS_ENABLED(CONFIG_OF) || !spi->dev.of_node) {
-		if (!pdata)
-			return -ENOENT;
-
-		*rstn = pdata->rstn;
-		*slp_tr = pdata->slp_tr;
-		*xtal_trim = pdata->xtal_trim;
-		return 0;
-	}
-
-	*rstn = of_get_named_gpio(spi->dev.of_node, "reset-gpio", 0);
-	*slp_tr = of_get_named_gpio(spi->dev.of_node, "sleep-gpio", 0);
-	ret = of_property_read_u8(spi->dev.of_node, "xtal-trim", xtal_trim);
-	if (ret < 0 && ret != -EINVAL)
-		return ret;
-
-	return 0;
-}
-
 static int
 at86rf230_detect_device(struct at86rf230_local *lp)
 {
@@ -1548,19 +1522,24 @@ static int at86rf230_probe(struct spi_device *spi)
 	struct at86rf230_local *lp;
 	unsigned int status;
 	int rc, irq_type, rstn, slp_tr;
-	u8 xtal_trim = 0;
+	u8 xtal_trim;
 
 	if (!spi->irq) {
 		dev_err(&spi->dev, "no IRQ specified\n");
 		return -EINVAL;
 	}
 
-	rc = at86rf230_get_pdata(spi, &rstn, &slp_tr, &xtal_trim);
+	rc = device_property_read_u8(&spi->dev, "xtal-trim", &xtal_trim);
 	if (rc < 0) {
-		dev_err(&spi->dev, "failed to parse platform_data: %d\n", rc);
-		return rc;
+		if (rc != -EINVAL) {
+			dev_err(&spi->dev,
+				"failed to parse xtal-trim: %d\n", rc);
+			return rc;
+		}
+		xtal_trim = 0;
 	}
 
+	rstn = of_get_named_gpio(spi->dev.of_node, "reset-gpio", 0);
 	if (gpio_is_valid(rstn)) {
 		rc = devm_gpio_request_one(&spi->dev, rstn,
 					   GPIOF_OUT_INIT_HIGH, "rstn");
@@ -1568,6 +1547,7 @@ static int at86rf230_probe(struct spi_device *spi)
 			return rc;
 	}
 
+	slp_tr = of_get_named_gpio(spi->dev.of_node, "sleep-gpio", 0);
 	if (gpio_is_valid(slp_tr)) {
 		rc = devm_gpio_request_one(&spi->dev, slp_tr,
 					   GPIOF_OUT_INIT_LOW, "slp_tr");
diff --git a/include/linux/spi/at86rf230.h b/include/linux/spi/at86rf230.h
deleted file mode 100644
index d278576ab692..000000000000
--- a/include/linux/spi/at86rf230.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * AT86RF230/RF231 driver
- *
- * Copyright (C) 2009-2012 Siemens AG
- *
- * Written by:
- * Dmitry Eremin-Solenikov <dmitry.baryshkov@siemens.com>
- */
-#ifndef AT86RF230_H
-#define AT86RF230_H
-
-struct at86rf230_platform_data {
-	int rstn;
-	int slp_tr;
-	int dig2;
-	u8 xtal_trim;
-};
-
-#endif
-- 
2.39.1.456.gfc5497dd1b-goog

