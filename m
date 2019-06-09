Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11713AAF2
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 20:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfFISGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 14:06:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44681 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbfFISGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 14:06:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id b17so6868787wrq.11;
        Sun, 09 Jun 2019 11:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+JDC+lw/WChmI4eIlkxJqi4XA35RjFjMXnl1SFE8Zw=;
        b=rIPNPBN3FxtgYpi973wdZA5hbzAbfgGEA1sFuHADXWrscohB30pZOv4p05jtvcQhLB
         H5/1lXIiZFfOcpSXtLheGEyypOY4cDSZtvYrpdmBHCTKks5okNEG/VrzsusLIvbaSqGa
         HKyQpwz/kES5l+WcpB/zj+6/gJRhqYrCB0D0CZbSNC/1NVKM7i73s++/uHpE4kUNW0TG
         OQkam1yor45+bRDZd+mxuNN5ZYIKCN/EAapXGEDiY0gZbGNDeLYGuRA7n/aPZH2A6Vo7
         1Sv2IgXVy9g8XIByrnLu+aoHeFuRwTAXjpqo+QlSXpC/00KmGfPqodT37rKahdX09div
         tmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+JDC+lw/WChmI4eIlkxJqi4XA35RjFjMXnl1SFE8Zw=;
        b=pZLH2wUe5ml/bPbtOErf0S0M6gXFnN+oUOkE3Pdc0UzUAEngDDgcJ8xLi+/ZVJjWIz
         4B8Tr0PG8NBnZMEB1fPUIxoI6wEwKKFkR7HW5aRgF76S0tqHR/sywOOZ3+Egn/Iy95nW
         ZMacBABHIC5D40tPU280XCWSVfJk7kZP7Lstcq5SGVF1Kit+gYSKD00UfAwNPCheoSjw
         BHQ8zFNKohWGYWFTEW++wMGNhxXSN1w7N3sH41K33ivr1DriDl9FZP9VZzI5mvUA8nfR
         S9pC5Jzsfy9QISDs7V81phwiNc26BV4Pum2zZarKo/1yo9l7GabP02rP2NuoQ0+0LK0N
         8DvA==
X-Gm-Message-State: APjAAAWKo/Xgea8cBnaAgi2BtbcyfKqvMzmL6fr5FauOkRC1niUYVbWm
        TCA3RTsiUqU739KETsIIMZ1WcDW0
X-Google-Smtp-Source: APXvYqxL3wLbt7xnWlgNfBsQLu1vOJsDLKzJ5xLFdJ94Txj4JCWTdM3Pa3jsExSk+j1V9ZUl26XLIw==
X-Received: by 2002:a5d:5007:: with SMTP id e7mr14502557wrt.231.1560103598868;
        Sun, 09 Jun 2019 11:06:38 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400B42D8EB9D711C35E.dip0.t-ipconnect.de. [2003:f1:33dd:a400:b42d:8eb9:d711:c35e])
        by smtp.googlemail.com with ESMTPSA id h14sm2007731wrs.66.2019.06.09.11.06.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 11:06:38 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Cc:     devicetree@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        khilman@baylibre.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC next v1 2/5] gpio: of: parse stmmac PHY reset line specific active-low property
Date:   Sun,  9 Jun 2019 20:06:18 +0200
Message-Id: <20190609180621.7607-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
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
---
 drivers/gpio/gpiolib-of.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index aec7bd86ae7e..2533f2471821 100644
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
2.21.0

