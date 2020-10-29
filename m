Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6654329E874
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgJ2KIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbgJ2KIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:45 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09958C0613CF;
        Thu, 29 Oct 2020 03:08:45 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id v19so2412153edx.9;
        Thu, 29 Oct 2020 03:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gCZxev2ha8Fo2QPH4Cy6SfUb+bofgsivfOY4ybWBIZg=;
        b=tNzBDghI9//MaoMaCCkPLO8017S1Tb1fuk54sAkrL8dysFQLhqRAcXONdVcPfA6f4U
         cfZighrF6pKdZz73DuNhWRkbydKsrRRPdgB4XDbLyytKGbZ8RdnYn8JOW+lyuJMjrQK3
         nFh6uz3Vt6cKRACCLIo61UvGYKMRA7+qiESXP9nE9qvdsqlbuBibz7bNXTW7jeHa4ulz
         YrxEiVYSIu9yojSzrHK4yzNgDmTpYlH693Z72ddH973zu+GWGwRCniH3e9+byXoOUvPX
         8lAoJpS+FPLRvxsOXQjwlJ/IKHcXZBc7ZOg4mw0Mqh9HOjOaB5Z4SdHn5V5BadppmsLA
         XrsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gCZxev2ha8Fo2QPH4Cy6SfUb+bofgsivfOY4ybWBIZg=;
        b=rCAUq4CoutJYgGAcmeZ5LPAA4ekF8I/gY/Ft+pSHJ5jmWy8BsOs51yNZoNPFhuuppV
         SOxaGP8SP3s7SRx80hWtGTpuyixoYnHSCuh7XOP0Ql4GxxEWn3yEfy8qgohHrjUZ72Fv
         8Ye4luIoly62QS9bDNSGw8FDwsOwCftRTE9VQwim51RyiWc+yjrmEXHcrcb7nOwjlnwU
         U2A2G5ghK8JUSAMzA4gfoBJn0FTqdyl9Gok16g+FL5Gdhw2ZxtrFtkAZBvvYMWzsYosd
         5at1UyvpKtOklcUojg+nmU4E9TRkDHQzW/phcDDP1e/Pmzawj54EktM0GRziKw1CsPzF
         nnyw==
X-Gm-Message-State: AOAM533pPQ8rGSz27wtVBtr96s0LVC+VRKEhM7mzhdp5TI3aYdXZqKEg
        yU6j29UVsEbfIKNwNJPJvok=
X-Google-Smtp-Source: ABdhPJz/N9AvJdBDfUaOACtC3ODaDOetSKX2ZQP3nLqv5p2iPCRcC/tIPYWVG1uGi7zpTJzdG3+p6w==
X-Received: by 2002:a05:6402:142a:: with SMTP id c10mr3180675edx.261.1603966123723;
        Thu, 29 Oct 2020 03:08:43 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:43 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH net-next 03/19] net: phy: make .ack_interrupt() optional
Date:   Thu, 29 Oct 2020 12:07:25 +0200
Message-Id: <20201029100741.462818-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

As a first step into making phylib and all PHY drivers to actually
have support for shared IRQs, make the .ack_interrupt() callback
optional.

After all drivers have been moved to implement the generic
interrupt handle, the phy_drv_supports_irq() check will be
changed again to only require the .handle_interrupts() callback.

Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Andre Edich <andre.edich@microchip.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Divya Koppera <Divya.Koppera@microchip.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Mathias Kresin <dev@kresin.me>
Cc: Maxim Kochetkov <fido_max@inbox.ru>
Cc: Michael Walle <michael@walle.cc>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Cc: Willy Liu <willy.liu@realtek.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 413a0a2c5d51..f54f483d7fd6 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2815,7 +2815,7 @@ EXPORT_SYMBOL(phy_get_internal_delay);
 
 static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 {
-	return phydrv->config_intr && phydrv->ack_interrupt;
+	return phydrv->config_intr && (phydrv->ack_interrupt || phydrv->handle_interrupt);
 }
 
 /**
-- 
2.28.0

