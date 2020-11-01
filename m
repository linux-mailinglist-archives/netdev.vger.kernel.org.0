Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2DC2A1E27
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgKAMzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgKAMw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:26 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B8AC061A04;
        Sun,  1 Nov 2020 04:52:25 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id v4so11399871edi.0;
        Sun, 01 Nov 2020 04:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n5W+ROLvWRCB6lTVb9DWGVA66kjGHAbhcZbQXXZedOg=;
        b=rNoYRpHigSkIPHKK39F4fwHBL8HBSpM4cGUhzwwZRnq+uPy9cA93A5uOuQL7Z/ykLS
         JJkHT5zeOtOr63pmuhVb4TGCpJhIM2XN2hm0eEvQqTACLqGBLthyVxj/eFwFe1/JbpBI
         58c0QO4QQUbPqbZgkFF7ELbQeffSt1gNt8+eMcprPZkJXjgKPfbyzh7wQcMBtt8Dofpc
         aE020KmdbIVrSBqiKKAZcx5YrAf7CWrh0ESQaNuQi3p6JijFoAd6mn2hx47jyi5lndH5
         MnmRhbzDNBolFBXGmhpzL1QI+a3ujUoTYKX3JeQNHgXHfyQybA/Oh6icQVyt4tII2gtb
         ic3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n5W+ROLvWRCB6lTVb9DWGVA66kjGHAbhcZbQXXZedOg=;
        b=Q1eiXgezzgjqDidhRx2LQ3we/ckmDRfJBPcenMyXRqwONxQbSzsj84MgoZhQc/5/WM
         Yw3QqX5WLaQXiyNNUbACiol3LhMRzSY80JoJIvkRHJ5C38o3A/7Q3Fz+VCjys1YIC8kJ
         m0zI2+PieBU6w4wT50akLBxRrnzzQPH13ZNlztCmOVcgCxPuOGPDnVmWytBgPjuSnoqM
         iEgubcJs8egoMbCJ4/4yQaDBRkHP04jil4zE5JHvxXmrw36WnrESEDzS4SyzRNXrhog4
         r3+Wa/O9g5Rl2Lq4+SwrRA3aYrWkgV98RXHwXnrPU7BVocLewonAuap40ZKOOjly1mvV
         kD/A==
X-Gm-Message-State: AOAM530egoVxNlWKPNkVv/LL5oEN0eiWvZq1td8o8gId/IIym/el/Wav
        LxXlVuU1PQ8EuIVaOjBQI9o=
X-Google-Smtp-Source: ABdhPJzAYNkrYyPQUNa/4pLKbBoV50SqCed2+gaF+KvDzxLnOQcFSGxfLD8M1LjHo5Axh5MLHGvKiA==
X-Received: by 2002:aa7:d1d5:: with SMTP id g21mr12071763edp.348.1604235144548;
        Sun, 01 Nov 2020 04:52:24 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:23 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: [PATCH net-next v2 03/19] net: phy: make .ack_interrupt() optional
Date:   Sun,  1 Nov 2020 14:50:58 +0200
Message-Id: <20201101125114.1316879-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
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
Changes in v2:
 - none

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

