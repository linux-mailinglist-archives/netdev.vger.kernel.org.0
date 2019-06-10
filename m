Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F793BA4C
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbfFJRFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:05:33 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35685 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbfFJRFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:05:32 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so110485wml.0;
        Mon, 10 Jun 2019 10:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U333hXUxyQhiqlTlWhPVMGKcPUQsglAuf+7XETbuhQ0=;
        b=EuwZ9CI9TRpQ84BisjKdi9pjg2eefrWXVLkXsGK2DzD35kxciUA1a5Y7RdBpprceED
         0+ki6jQ5tmyBuxBWnu4z2lawxRauHHha4h+1whSl8Y9OpnNI0kagg6z4sok3d5PTNWV5
         Immur+79WjzdGBoXMtA9IFoCPk5uZTmiZ+SBmtmOFWtQl+G8gWsNKXxglmTbogajJrGT
         SvAeFPOLL5DIm+UBwYSlIh7QIhAT9eDl8Hd7F9wW1rEXp+RsFXvFLqwglH9mV7uiZAoz
         Oq5ijbNgGaB3pSOl2kS9+XKun63d4ehI0mIhsWridFqZfO9emPYNKKKcG85I/T3EjMwN
         refQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U333hXUxyQhiqlTlWhPVMGKcPUQsglAuf+7XETbuhQ0=;
        b=FdGy8pf83o4VgSZLmUG7dm+YUDibV2ppS1184ICoaeD+CkKohHEL+gZ0DcWv0XZDwU
         kArI3SNqPXWi8NqbDCkjDVnqCPsSL8pNw2EOArk3+uXZ9Ss2z7HcXABirWvLV7E6GdAD
         c7bkvG0xesmdgBICdgqGab8CNtF/bnZJmwedxrmSJcw3ZO6RCly3bA43i6yi5YPIHRAg
         +Q3vxZgMN9EfjIz6BaH+JgkNRSwr2ZEZ8YG2pDfPtG4eAW1+rwFVXMO1rVglHUqVgUGK
         kiccy/VaP8Ztu4J/BQI2zTAcvu00ZsGfmgtmAWgUthkM6lJWgy3xaF2v5b2hgTTxfrRK
         7cRw==
X-Gm-Message-State: APjAAAVwMeG/eJA1JGKEwPBfeNVlChRaWHTQgwwAJ1m0ZMJm312Xutf5
        LoA5BeUzjyUJgG25aY0d/Yo=
X-Google-Smtp-Source: APXvYqw/sJe73OJ/n8Bn3G6ZRNzoYNUjNZpgT9wrlMFjix8pu35QsHAFFRx5k8sKTKqlNoiLmchwaQ==
X-Received: by 2002:a1c:ed0b:: with SMTP id l11mr13861973wmh.103.1560186330361;
        Mon, 10 Jun 2019 10:05:30 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA40000C4C39937FBD289.dip0.t-ipconnect.de. [2003:f1:33dd:a400:c4:c399:37fb:d289])
        by smtp.googlemail.com with ESMTPSA id r5sm21558160wrg.10.2019.06.10.10.05.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 10:05:29 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        linux-gpio@vger.kernel.org
Cc:     andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/1] gpio: of: parse stmmac PHY reset line specific active-low property
Date:   Mon, 10 Jun 2019 19:05:23 +0200
Message-Id: <20190610170523.26554-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190610170523.26554-1-martin.blumenstingl@googlemail.com>
References: <20190610170523.26554-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stmmac driver currently ignores the GPIO flags which are passed via
devicetree because it operates with legacy GPIO numbers instead of GPIO
descriptors. stmmac assumes that the GPIO is "active HIGH" by default.
This can be overwritten by setting "snps,reset-active-low" to make the
reset line "active LOW".

Recent Amlogic SoCs (G12A which includes S905X2 and S905D2 as well as
G12B which includes S922X) use GPIOZ_14 or GPIOZ_15 for the PHY reset
line. These GPIOs are special because they are marked as "3.3V input
tolerant open drain" pins which means they can only drive the pin output
LOW (to reset the PHY) or to switch to input mode (to take the PHY out
of reset).
The GPIO subsystem already supports this with the GPIO_OPEN_DRAIN and
GPIO_OPEN_SOURCE flags in the devicetree bindings.

Add the stmmac PHY reset line specific active low parsing to gpiolib-of
so stmmac can be ported to GPIO descriptors while being backwards
compatible with device trees which use the "old" way of specifying the
polarity.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib-of.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 00deb885409c..a8f02f551d6b 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -158,6 +158,12 @@ static void of_gpio_flags_quirks(struct device_node *np,
 			}
 		}
 	}
+
+	/* Legacy handling of stmmac's active-low PHY reset line */
+	if (IS_ENABLED(CONFIG_STMMAC_ETH) &&
+	    !strcmp(propname, "snps,reset-gpio") &&
+	    of_property_read_bool(np, "snps,reset-active-low"))
+		*flags |= OF_GPIO_ACTIVE_LOW;
 }
 
 /**
-- 
2.22.0

