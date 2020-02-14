Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF2515FABE
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgBNXjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:39:01 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38671 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbgBNXjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:39:00 -0500
Received: by mail-pl1-f195.google.com with SMTP id t6so4285568plj.5;
        Fri, 14 Feb 2020 15:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+N06HXrDY2QrfyGiKTgLMNY+oN0lEAf54vNFOw6UUXM=;
        b=PjX8FEhBrKtqmxBBA2VeduzK83Md0W9O+9Igw/oI4kjsiFcj7pCpru7bV7/cEot1n7
         vJ1ZUcjy2tIIR7MQff+mH0W/GekH/1IDMOJePwAxNGX4nmeUdSTjt3fk7oFPHglTp2tT
         APkMW6k93mathXopopkYIcZxfhtThskCxy1Uh10Tn9Lpn2cS7wKKqx/BMIW7oRzfYmSK
         oQkxMWqebrODsgmTTbbDEwiJHJGNFGq6oBWkNPLY8T3PVuz3oPhQS7sqonnJ+i0rU//L
         V79a13rHi6EqNkjoL+733M7OzafBT9rv8PUxdPbQdOE1l5ooDNkI2JoC8UF1ZiimjroD
         cbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+N06HXrDY2QrfyGiKTgLMNY+oN0lEAf54vNFOw6UUXM=;
        b=C0MOdvjosmPj3ZM6vNttwfIWK/YvG+LVOnTcRmcIv52uowXbKUZwmMLGyztpVwjTpX
         xVe1thsdYSey+pk9i6d5mqTyRSQ+Uipcbxm56vSspryY79gBQvFBEUZS9p3jeu9dbh94
         bbhTMQVlrVQpVaKRVrfuFL9+JuMLoBxyAm7PaKaXy/T6caasdEzppTBWZjeGSCvZlu+f
         bTGe07jGbS9w6PkBpD9VQ45ZCwRrqOS6nen0fE8zV3MmjK3BjP0JW9I57YWTOPfHjHwg
         cWNhleVspDmz4KEKukzLC8lhmaSWy6vTeOGk5pOf8XUGuNJPDdYhifHrRk6BKWYY16RJ
         EKWQ==
X-Gm-Message-State: APjAAAVpuoFCtXf2d85DpdfswiDy9KgJQs5aHph+IWBE1ppFBhNd3J0C
        s7wi+Bs5Gad+RxFgbnp7dMBh+dWh
X-Google-Smtp-Source: APXvYqz6hV/py6h7BU4b09+y/9EueGEU6SIrVkathBINmwRIxVPbvC9zs3Z4F7TxIXwHG6IVH6n9Nw==
X-Received: by 2002:a17:90a:b106:: with SMTP id z6mr6503869pjq.91.1581723539070;
        Fri, 14 Feb 2020 15:38:59 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p17sm7797397pfn.31.2020.02.14.15.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 15:38:58 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/3] net: phy: broadcom: Allow BCM54810 to use bcm54xx_adjust_rxrefclk()
Date:   Fri, 14 Feb 2020 15:38:51 -0800
Message-Id: <20200214233853.27217-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214233853.27217-1-f.fainelli@gmail.com>
References: <20200214233853.27217-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function bcm54xx_adjust_rxrefclk() works correctly on the BCM54810
PHY, allow this device ID to proceed through.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 7d68b28bb893..4ad2128cc454 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -194,7 +194,8 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 	/* Abort if we are using an untested phy. */
 	if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM57780 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610 &&
-	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610M)
+	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610M &&
+	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54810)
 		return;
 
 	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_SCR3);
-- 
2.17.1

