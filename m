Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686DA194664
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgCZSQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:16:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45122 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728563AbgCZSQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:16:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id t7so9007476wrw.12
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 11:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=c3HUmOFUUolADQEMq4OYXL+THjdw2w1uRLCtLXHaswA=;
        b=NSQGLjR3eC/fcJQPkRWvUiQq58jrn7PKfEnBnOxA6U6uBEZUNoCCveZnkEhD6gKnmn
         sXLDH4avrmhAB6IQHTT0ggQOXkvbE0XJZ8QRvIXru9JZkoEeJlkxdoMb67AmH+jtl5vg
         LnBGNOt1rFmM+GK4bw+2KkCpFIgCK5gD8YN7jPHCrGHG+SKHwirOElgGCCKjbV7hXICX
         NSYJZct3nbnucvPdSee+/kN/sBKObNpHlZEEDHFAibUeU4sdIac0LBtrqC1YjTME+vH5
         TcjDdZ91DlYj0IYF0lDPe8U0kmxgurV/0x6BvctZgoArRVZvP43pfpFnoe6xT4M13mmR
         3b5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=c3HUmOFUUolADQEMq4OYXL+THjdw2w1uRLCtLXHaswA=;
        b=iXCQL1eK+YBIWbAibeOX+V6tN6xhzVbdKVh9gtaghRW94EOTMth+z6D20/s/t8CCGS
         n/tFxcIQL1CAk85cDTZJcxN44Lnjjb4m08X6AybMqPnv8BhoVtWPuX5R61lZxERO+YIv
         hyBrzl3zLui848UQvlK1WdF1ivkYDoooj3Aek1jPExSqrEbdX8x419gG+rPIZ0YTv/Zn
         N7tIPOldtWbOrdh+qVS4RyuFF6G8y28fgOmlX3elhcHqtaczJm7YIi66Zm9axTXmETi0
         WN5kik1MM1deCsi2tW/cn+6+CS7smgxKL8eg3G28rk3thmsjkMROTRu+U6Br2WJ797YY
         Fk1A==
X-Gm-Message-State: ANhLgQ2ySyc38zL4+SUhchZk4fTJpsPsMMzOK/b0QH3fQAmFDeISmCzg
        y50jiDmkF643McDtpr+7PWJ/SKDV
X-Google-Smtp-Source: ADFU+vvkRlVdJIibD78wHIQMcOxGWoMWlw8OrQW++EmzJ5FXcvfCpSydcND+Qkqc4g9o+oXHfBa1dQ==
X-Received: by 2002:a5d:550a:: with SMTP id b10mr10691711wrv.163.1585246589806;
        Thu, 26 Mar 2020 11:16:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d031:3b7b:1a72:8f94? (p200300EA8F296000D0313B7B1A728F94.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d031:3b7b:1a72:8f94])
        by smtp.googlemail.com with ESMTPSA id t16sm4810340wra.17.2020.03.26.11.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 11:16:29 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: don't touch suspended flag if there's no
 suspend/resume callback
Message-ID: <313dae57-8c05-a82b-ea87-a0822e9462f0@gmail.com>
Date:   Thu, 26 Mar 2020 18:58:24 +0100
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

So far we set phydev->suspended to true in phy_suspend() even if the
PHY driver doesn't implement the suspend callback. This applies
accordingly for the resume path. The current behavior doesn't cause
any issue I'd be aware of, but it's not logical and misleading,
especially considering the description of the flag:
"suspended: Set to true if this phy has been suspended successfully"

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 3b8f6b0b4..d6024b678 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1519,23 +1519,22 @@ EXPORT_SYMBOL(phy_detach);
 
 int phy_suspend(struct phy_device *phydev)
 {
-	struct phy_driver *phydrv = to_phy_driver(phydev->mdio.dev.driver);
-	struct net_device *netdev = phydev->attached_dev;
 	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
-	int ret = 0;
+	struct net_device *netdev = phydev->attached_dev;
+	struct phy_driver *phydrv = phydev->drv;
+	int ret;
 
 	/* If the device has WOL enabled, we cannot suspend the PHY */
 	phy_ethtool_get_wol(phydev, &wol);
 	if (wol.wolopts || (netdev && netdev->wol_enabled))
 		return -EBUSY;
 
-	if (phydev->drv && phydrv->suspend)
-		ret = phydrv->suspend(phydev);
-
-	if (ret)
-		return ret;
+	if (!phydrv || !phydrv->suspend)
+		return 0;
 
-	phydev->suspended = true;
+	ret = phydrv->suspend(phydev);
+	if (!ret)
+		phydev->suspended = true;
 
 	return ret;
 }
@@ -1543,18 +1542,17 @@ EXPORT_SYMBOL(phy_suspend);
 
 int __phy_resume(struct phy_device *phydev)
 {
-	struct phy_driver *phydrv = to_phy_driver(phydev->mdio.dev.driver);
-	int ret = 0;
+	struct phy_driver *phydrv = phydev->drv;
+	int ret;
 
 	WARN_ON(!mutex_is_locked(&phydev->lock));
 
-	if (phydev->drv && phydrv->resume)
-		ret = phydrv->resume(phydev);
-
-	if (ret)
-		return ret;
+	if (!phydrv || !phydrv->resume)
+		return 0;
 
-	phydev->suspended = false;
+	ret = phydrv->resume(phydev);
+	if (!ret)
+		phydev->suspended = false;
 
 	return ret;
 }
-- 
2.26.0

