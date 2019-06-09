Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 936AF3AAFF
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 20:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbfFISHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 14:07:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41085 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbfFISGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 14:06:43 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so6873612wrm.8;
        Sun, 09 Jun 2019 11:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TqXz/MCeI1smMWv/lBknpm+xQVHD8zLca+ZLsE7CsxM=;
        b=cIHMqIRAANO+YYtVflRdIOjyQQiMyWzgkuArvUa0ZqXdUEqWrZg3+SELonp5CYakHf
         BJtfzZRheP6EXq3w7YoHV48guAMmSuNCBd5yDk2RB0PBGz8nDE5rP0VBKTcTXyzWKBTH
         6vYOaOV1L+zjpdS3SmQAV/uqx+ovVKWNAAM6Tc9ddILTVFboRbYhmcSTtlHMM25fNug8
         NkhrSFSp8+5Zf/FfVE5ZoO1byAYom2+3a/fU8uOXg9HhK0x9/kClKI9qWgvcWGHMCngP
         qSjp1dBKcd4BN5iIKvpBLLouWqZg81JlhCHVqceAo+bHxNLH0sfqhVbG1qeJA0eJPpL1
         9wmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TqXz/MCeI1smMWv/lBknpm+xQVHD8zLca+ZLsE7CsxM=;
        b=AvM+PD0urIeu0paDu75NS/L5CknAmqdzeNdBOva9y/sjW0kaBHXNXai4R9Pj9Ms3Zo
         30BM524yYTkY/Evh2DpJ5pIo9VMtJHfh5ZxTYAvjFefTbXrT0EnwyeVOXaC/bMYy0e6x
         S0g25+S/OCUC+SB0Ue4Wm2ZBom3PXUPaeaOpUjqqwpDqzaCHksofuwdQ74UQCzecpHrw
         tDKkf7afQfIHxY169A7FAsgtmaaJt1S6CVZZNFnNNURLCVjg2F6QQaKv5hPHo2LO2eSy
         dm5WJIkFPcQAla7sgjkDLg4rc6pnamMNHY0RiFc2upG9GFUXZLWdn3c+vkKo6raD5mAq
         Nxtg==
X-Gm-Message-State: APjAAAVTJI2wOOWXAx8lUOQtqhudyYTx372fMdCyHLFYsF8h5pay8bpo
        z3u9R7McvRrQ4CAeMd+ZZTFgIBzv
X-Google-Smtp-Source: APXvYqx/9JrA/M8rWMKnXIIb7nHkPwhbRW1rK3/nUNwz5X/AHp/yd/w5vWfFZrKKVybNXW+yf7lcMQ==
X-Received: by 2002:a5d:694a:: with SMTP id r10mr19273919wrw.345.1560103601231;
        Sun, 09 Jun 2019 11:06:41 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400B42D8EB9D711C35E.dip0.t-ipconnect.de. [2003:f1:33dd:a400:b42d:8eb9:d711:c35e])
        by smtp.googlemail.com with ESMTPSA id h14sm2007731wrs.66.2019.06.09.11.06.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 11:06:40 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Cc:     devicetree@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        khilman@baylibre.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC next v1 4/5] net: stmmac: use device_property_read_u32_array to read the reset delays
Date:   Sun,  9 Jun 2019 20:06:20 +0200
Message-Id: <20190609180621.7607-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change stmmac_mdio_reset() to use device_property_read_u32_array()
instead of of_property_read_u32_array().

This is meant as a cleanup because we can drop the struct device_node
variable. Also it will make it easier to get rid of struct
stmmac_mdio_bus_data (or at least make it private) in the future because
non-OF platforms can now pass the reset delays as device properties.

No functional changes (neither for OF platforms nor for ones that are
not using OF, because the modified code is still contained in an "if
(priv->device->of_node)").

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 21bbe3ba3e8e..4614f1f2bffb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -24,9 +24,9 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/mii.h>
-#include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 
 #include "dwxgmac2.h"
@@ -254,16 +254,15 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 		struct gpio_desc *reset_gpio;
 
 		if (data->reset_gpio < 0) {
-			struct device_node *np = priv->device->of_node;
-
 			reset_gpio = devm_gpiod_get_optional(priv->device,
 							     "snps,reset",
 							     GPIOD_OUT_LOW);
 			if (IS_ERR(reset_gpio))
 				return PTR_ERR(reset_gpio);
 
-			of_property_read_u32_array(np,
-				"snps,reset-delays-us", data->delays, 3);
+			device_property_read_u32_array(priv->device,
+						       "snps,reset-delays-us",
+						       data->delays, 3);
 		} else {
 			reset_gpio = gpio_to_desc(data->reset_gpio);
 
-- 
2.21.0

