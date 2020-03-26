Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6315C194666
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgCZSQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:16:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33096 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbgCZSQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:16:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so9111817wrd.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 11:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=peX2Z6ZaF87VrymRtdMS9iPZrZ1C3/EDZETFS5YZIdw=;
        b=KmpfuvGgW1AFQO0zcFeAtpZ360fLm2Tsbam5LmoiG45TqAnKaXT3Kbb20YgYL50z3E
         DTu3IoBfcZLY7/DOVhoKKhNbcj7PeAKHwqsf9UbLwP+yg2nPGqbpIeLYdDlimx3CIbrQ
         jYFsjYm5cl5ay2nct+6zJ1Zy+VPU8NZKTdub5J+97t1XTkdsQ77zFEPe5lbgWSJm0Twt
         qaujJMCilmMYBo44c9iXqDzTAimp1IXDFDZIt2tJ6WqjFZ1s+UiwYYcOM9DlwD9UGjYJ
         y1vA+yMPLvxazMvc57SABEnJLCTFGyyTbIxXiOdYbDwfGia1JkPn6cbBbKYpGbuelb1w
         Y4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=peX2Z6ZaF87VrymRtdMS9iPZrZ1C3/EDZETFS5YZIdw=;
        b=KiznBcMghYlt659JlI0HSyL+wCkSSr0UHESWVljb4kKsJOFRg0TtSjGXDgvdrgHSAf
         FUu+E2DQ+cpFXpx3yB9zJm+dKRtt81VqfvLFh/FMOkHOIazMuIc6tmLO11uamxymOmI+
         tm53W8OK3DUciJFOcMR+XMzaOuw2nzAIeM1PXGq3vIL7amxr8FOVRB9c1vsKOk0M8AOP
         uT860lmTtKPNZhLjhoebT4/Z8i9vMbodlzcTZsK+lQzYYwgkLRSY7lF3cqurim7xyanY
         gMVq/DGtuwOhxywN7nWm2uZ0s0KrZumJ+QcTYK35y08xP1Kw0ZPv50nRAX4fM2h9SuxE
         qo2A==
X-Gm-Message-State: ANhLgQ26vJrrndhwn60tCDsSCVHUMU6VQ37hvVpT1HiRC7ENPS1mruI7
        HNq5lgx7PmOB/Vw002kOgRN/bCbU
X-Google-Smtp-Source: ADFU+vtULFfKrsdLPOupaFoWZNBjTLqWrir80aQB9hJo1Y1r3l/NNSjIwBs6JUbH1HTylBNIBuwuBA==
X-Received: by 2002:adf:97d5:: with SMTP id t21mr10139539wrb.45.1585246590921;
        Thu, 26 Mar 2020 11:16:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d031:3b7b:1a72:8f94? (p200300EA8F296000D0313B7B1A728F94.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d031:3b7b:1a72:8f94])
        by smtp.googlemail.com with ESMTPSA id d18sm5095062wrn.9.2020.03.26.11.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 11:16:30 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: probe PHY drivers synchronously
Message-ID: <86582ac9-e600-bdb5-3d2e-d2d99ed544f4@gmail.com>
Date:   Thu, 26 Mar 2020 19:16:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we have scenarios like

mdiobus_register()
	-> loads PHY driver module(s)
	-> registers PHY driver(s)
	-> may schedule async probe
phydev = mdiobus_get_phy()
<phydev action involving PHY driver>

or

phydev = phy_device_create()
	-> loads PHY driver module
	-> registers PHY driver
	-> may schedule async probe
<phydev action involving PHY driver>

then we expect the PHY driver to be bound to the phydev when triggering
the action. This may not be the case in case of asynchronous probing.
Therefore ensure that PHY drivers are probed synchronously.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d6024b678..ac2784192 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2575,6 +2575,7 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner)
 	new_driver->mdiodrv.driver.probe = phy_probe;
 	new_driver->mdiodrv.driver.remove = phy_remove;
 	new_driver->mdiodrv.driver.owner = owner;
+	new_driver->mdiodrv.driver.probe_type = PROBE_FORCE_SYNCHRONOUS;
 
 	retval = driver_register(&new_driver->mdiodrv.driver);
 	if (retval) {
-- 
2.26.0

