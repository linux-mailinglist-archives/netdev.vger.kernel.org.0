Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63353194DA6
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgC0AA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:00:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34342 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgC0AA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 20:00:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id 26so8861065wmk.1
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 17:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=tvLKvFsrnuzEPfF3Q8TrynVX6A3gZAol5Yq0LDVYUKI=;
        b=dSiGxi+/Tu4vefOtVz0aMuN5zUWTXwXwGzeaNhq2YbWwqCODOqddUkMGnkn9jpuxvN
         1Mi3EHoHs/IE3AewgVwHUZarDURIBB11JJi5eF8C0R6zm+U0mV7lmGq++B0DHvxCZ1ch
         Sx7sLlJXvj3gdseCX7kPgwKJsIQRUlKuSKlLGOuGihdYJwT4vjUwy2EDD+c6UE016b5c
         hFIqWWZhc2EL7hoRT7rNEJqd42rM5lu5MGeGA5HCh+JEi0w1FGaMHdxuMJN+tTQYkxdk
         WRTKoHfl+k/vn3AQzakVQoaQFOuqlKuCnGFW04W1hrTa9alxMJAw2PmDYOX49vOe2iN1
         X3ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=tvLKvFsrnuzEPfF3Q8TrynVX6A3gZAol5Yq0LDVYUKI=;
        b=C0H072rwX/j4wc6farmGQaZ0oKiAvi0Iy0zT7Vj+cHkT8atMkJyuPR2ig+FR61Cw4g
         g4KncgDECtU1jl8HQ37E5SwQCzjE55rsTe12Ul+ZTp2H0EpmGUYigln88WHoemya0Quq
         bD+s/3O9Mk1OcM1ryfXqaBp8Egi33GzzTJ0PN05OPmC1mHG4oGqhlBkapFbfABnoVDIB
         OeMnXoUD2MKVqVFtkS0bARA8AH1RlWmx5wFk3EAVLC4AyxyUMmStkKQ0DNuUUYjFrzka
         iqkdhAyPGvgcgJcoszNBZIa0sIc+ilpugS7Rviccdm1meBcCeS9Q0TVo+o3IvdNhpQ4g
         dRCA==
X-Gm-Message-State: ANhLgQ1dAD8H9fPeLs71+eWicS5NX0mX+P3w66641eDUYfCmzxDbuZ/o
        QzWyoQVoW+IQQjCPAfGwLGufyBlj
X-Google-Smtp-Source: ADFU+vuVa9X9jlhKXhdE+hAHEF2QqfFNpA6G5/MaALHrRSm1HXA7cdNAIGa/1XPXN3NjQQ6RZhOEIQ==
X-Received: by 2002:a7b:ca52:: with SMTP id m18mr2429716wml.156.1585267227057;
        Thu, 26 Mar 2020 17:00:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d031:3b7b:1a72:8f94? (p200300EA8F296000D0313B7B1A728F94.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d031:3b7b:1a72:8f94])
        by smtp.googlemail.com with ESMTPSA id c85sm5705151wmd.48.2020.03.26.17.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 17:00:26 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2] net: phy: probe PHY drivers synchronously
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <612b81d5-c4c1-5e20-a667-893eeeef0bf5@gmail.com>
Date:   Fri, 27 Mar 2020 01:00:22 +0100
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

Default still is sync probing, except async probing is explicitly
requested. I saw some comments that the intention is to promote
async probing for more parallelism in boot process and want to be
prepared for the case that the default is changed to async probing.

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

