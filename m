Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D2E2EBE33
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbhAFNE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbhAFNE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:04:27 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4B5C06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:03:47 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id r4so2551770wmh.5
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9jRjlY6Qgokkv+f6zbgcXHg0t369M9dCUMUcQDm0n+0=;
        b=lvjgJ+0C1b2TBY0JnMnl+TetpQt8z+VxUWHg5HM/VjiVhaBTXq1kmvKSmxx1Rm4Xpv
         pm5Tm7vzWQkR+2u7Ds1wYoHRmUP9QiUnXSz/CYyCOJKtnSGlE3hj3BFED3LzPKlJaeoi
         jpcQsjORm2s1l45Mbx8nqLpPJNyzIQAPwBBB9P7E9GM7dmZ6BzzP6WJMRbZRHPq8D+M3
         xuc+rMqejAQDkyRJMo04EgjrXEAC+XUGkRKZ8tF23g/ybXojO7izqN6EBiYNLqlQXfXI
         lJ+ixoZFbe5kfJk7fRrQACzAqcL19aNCd2KtyjLJwX7uMQBFXbefmKpdKQVgoaYxzFY0
         PnLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9jRjlY6Qgokkv+f6zbgcXHg0t369M9dCUMUcQDm0n+0=;
        b=sI0+xKWvC0k8F4AdyxX/Hst+s7j5bm0MAoquLnjqi3KtxDChn1FPnaVI8gme+vl8ls
         AfMiXU0fmKGh1RW9fj4TF1gQcOVagFRsoancVzcJ6hfcT2pfWZduTzz1wec4F8AMacbQ
         rZYI7JSn3efOtckoTWppH6B5/5bhbb1f8Woq3ceL0LuYO2BTxSuj0yMwbnq0qquh4oGC
         8+3YMx+MG76GWEMc23NTqxvYS/TkYGz0TF4XSgAbCUcZ0Vt7t6XaLJVP7ej1YXX9+kDW
         ZreUl+Q7cguyAexqF9R8wIAiZMMY0ct0wnP25/K0cfcaXSe45NWrPS9iGhFbRrVHd6pB
         r28g==
X-Gm-Message-State: AOAM5304msi1uHWqJo8ZVYFs9wto2sY//WawmZtEVSNKbaPy2fsHb2BP
        qKKDeYCfWLlEeA8XMxgMuLp2aBhNsO8=
X-Google-Smtp-Source: ABdhPJzzqQLtX+tTUTNl/yLJWAqjD6Ym6HncfEHnZRcqi8r0sbkAy4AgXNqWbjlm88/4g5hW0OsvxQ==
X-Received: by 2002:a1c:6446:: with SMTP id y67mr3609401wmb.144.1609938225219;
        Wed, 06 Jan 2021 05:03:45 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id s13sm3199672wra.53.2021.01.06.05.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 05:03:44 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: replace mutex_is_locked with
 lockdep_assert_held in phylib
Message-ID: <ccc40b9d-8ee0-43a1-5009-2cc95ca79c85@gmail.com>
Date:   Wed, 6 Jan 2021 14:03:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to lockdep_assert_held(_once), similar to what is being done
in other subsystems. One advantage is that there's zero runtime
overhead if lockdep support isn't enabled.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/mdio_bus.c   | 4 ++--
 drivers/net/phy/phy.c        | 2 +-
 drivers/net/phy/phy_device.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 2b42e4606..040509b81 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -740,7 +740,7 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 {
 	int retval;
 
-	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
+	lockdep_assert_held_once(&bus->mdio_lock);
 
 	retval = bus->read(bus, addr, regnum);
 
@@ -766,7 +766,7 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 {
 	int err;
 
-	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
+	lockdep_assert_held_once(&bus->mdio_lock);
 
 	err = bus->write(bus, addr, regnum, val);
 
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 45f75533c..9cb7e4dbf 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -724,7 +724,7 @@ static int phy_check_link_status(struct phy_device *phydev)
 {
 	int err;
 
-	WARN_ON(!mutex_is_locked(&phydev->lock));
+	lockdep_assert_held(&phydev->lock);
 
 	/* Keep previous state if loopback is enabled because some PHYs
 	 * report that Link is Down when loopback is enabled.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 80c2e646c..8447e56ba 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1740,7 +1740,7 @@ int __phy_resume(struct phy_device *phydev)
 	struct phy_driver *phydrv = phydev->drv;
 	int ret;
 
-	WARN_ON(!mutex_is_locked(&phydev->lock));
+	lockdep_assert_held(&phydev->lock);
 
 	if (!phydrv || !phydrv->resume)
 		return 0;
-- 
2.30.0

