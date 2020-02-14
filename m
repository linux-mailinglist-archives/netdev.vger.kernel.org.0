Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E4215FAC3
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgBNXjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:39:13 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43336 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgBNXjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:39:01 -0500
Received: by mail-pg1-f194.google.com with SMTP id u12so5341892pgb.10;
        Fri, 14 Feb 2020 15:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J51rZFtUWejHx0NVomPgc8yJ23PytH7hLfoorhmh/K0=;
        b=lCJ3w7UHoQ+ChhzMM3NbHgUIwqxBd+YsbCR68eN+XR5msMJLYhIrNKBBqWDw7YC+iZ
         xIW0QB0kb55smSO76X1AFQSBh6JTY4s+jQTzOsIQv4yUtMlS5nZHqyC+Zx0PJcxfggJM
         HvoJ/Ps7u8nDdDDKEux5oQ2Hvk3JkRyGmJHI4wm58KH/EwZhr/6wbe7KS/DZ3Uz2OF5Z
         LlyuNQz95jxU/ULjfI11wTaHWyLxt9bqGlWb5jCT0gsjbX/87Kq9NGJM0ae87gsXN35e
         az+45xuJTfAZoUedi8HzrdNY2NNhUfnTq38cfVMGKoSRoa0lEz5gqLNhtPElaDRLFsZj
         RiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J51rZFtUWejHx0NVomPgc8yJ23PytH7hLfoorhmh/K0=;
        b=ZNPP71ixlj4ZzAS5kpA6/gmkKznpl6+Bc8xAugm0EXM8DIAt12rBAHUt323XRSOLBD
         K90QSKKvni76Rq2X+qsZ0TavdNq/B1WrOUjrZQ0D4kaFNtaRb/mnYwYkWd0jSDn1Ghrq
         IObL8KQxUCbZMw2BLADhnjahdnpuo7zLnMDmWiB9jl9aQbAVwyIbP9mxwoIskD1bwsGv
         4pB3O2RaBDz135DerK90n4IHDeyeTSArfLLOyuiV+h+oioro/WnPErBwotIGbDdc+ohD
         xx5qKdlJOi0kJHZeGuUuFy3DoTW4MXGkXWisFVMbtlVw7g602rlo3fy8IHUOXAG4UXSD
         p88w==
X-Gm-Message-State: APjAAAUTs/k/qhyxhSlDZpKCbIP3EQQBSOIC5Z3uirU6urgYrNw5CEy/
        iK2gGDnYItPWD2CEY9LAIIBfGET1
X-Google-Smtp-Source: APXvYqxy1Rl9we7WRyYQPBg7gJ1lQj3o0JKSowHRWRcHJPuszIMFRPOKj/YQoGOY0P9QyPvcHsESWQ==
X-Received: by 2002:a63:615:: with SMTP id 21mr6020303pgg.440.1581723540191;
        Fri, 14 Feb 2020 15:39:00 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p17sm7797397pfn.31.2020.02.14.15.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 15:38:59 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/3] net: phy: broadcom: Have bcm54xx_adjust_rxrefclk() check for flags
Date:   Fri, 14 Feb 2020 15:38:52 -0800
Message-Id: <20200214233853.27217-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214233853.27217-1-f.fainelli@gmail.com>
References: <20200214233853.27217-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bcm54xx_adjust_rxrefclk() already checks for the flags and will
correctly reacting to the 3 different flags it check, allow it to be
unconditionally called.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 4ad2128cc454..b4eae84a9195 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -273,10 +273,7 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 	    (phydev->dev_flags & PHY_BRCM_CLEAR_RGMII_MODE))
 		bcm_phy_write_shadow(phydev, BCM54XX_SHD_RGMII_MODE, 0);
 
-	if ((phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED) ||
-	    (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) ||
-	    (phydev->dev_flags & PHY_BRCM_AUTO_PWRDWN_ENABLE))
-		bcm54xx_adjust_rxrefclk(phydev);
+	bcm54xx_adjust_rxrefclk(phydev);
 
 	if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E) {
 		err = bcm54210e_config_init(phydev);
-- 
2.17.1

