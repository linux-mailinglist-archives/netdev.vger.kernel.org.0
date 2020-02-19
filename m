Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D85164F68
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgBSUA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:00:58 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44713 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbgBSUA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 15:00:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id y5so588795pfb.11;
        Wed, 19 Feb 2020 12:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E+ODUO2TskpAbtFr2qyA3nn46cxkcLiArVOXKcyYxHA=;
        b=dlIhDHUQxjMGXorPCXm0ys37HBeXXH6MdFbIbI5A4GDlpIz+e/RTUp8VA5a9gouwne
         y78Yhbn28xXtmk4gyoME3Xv2m+3f9tyzXRxGs9MBE/ezfx5m3j57UqeYrsrA5bjyNzmg
         thCwQQlIUs/IZJAlhQ/EsVQZ+/mwhgnjkkMlqtH5P92JiISTdN0yd2AtZVVhPlRIVbcE
         XGrhuVg0fMIWOT1GPd0ZQIE/ZoT+0LnPqSPh2wV9XINHDfXsb60AIsfdhHRftPafvw9h
         Sam2xmDiCkr22aEJ4TDn67ufXYhnaHhtD1UFBKeQxHeOIdlBQ+Aej0Wo3s3r5kkTvz6T
         5ruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E+ODUO2TskpAbtFr2qyA3nn46cxkcLiArVOXKcyYxHA=;
        b=YMG9L+ap4hLKoA18y0Y5C1SwDa8UEJVCGTpJ9/P7HYVfSBubLJwim31jmCHaSerhea
         Pi98Qk4xCEFOCBkRh7LxWi/xDZXGeO/fRvjqxxPQeNwtvt6pxPfhnt8/VHPqNEcHVGLA
         ZrSvuDjmgJS2R72e1Ukmv/XGgxtWcSJa8hrYmM81OAJCq48R02cMUO+3jjhoAYM1t2Q8
         /AMviSa9qjyZiNq8KspPJaArAIPHc1n9t3oITEAmu1L5k5UHjFn+6jqu7N6GF+fJhiFo
         UHfILvdglJf+OMLoAh6XAh1wQH6PVFkZa/+8b6vVlBnazTZNKMQNglfbxka+Au1R8o1X
         GxAw==
X-Gm-Message-State: APjAAAUMx9brdSpyg7g/4svXRsICjdaH87RN+kCL1rSNHMjtuwbTeMv3
        Ix8A3K/5rsBmjxd34KtWx6f/hu6t
X-Google-Smtp-Source: APXvYqxp/AhYCeNLPuhAl8X5vt1vjZUBrc7uweR9IkGAcQQD7/A/afsD4BMQFzCBOFyIcBYPVN+GGQ==
X-Received: by 2002:a62:e30f:: with SMTP id g15mr27822212pfh.124.1582142455032;
        Wed, 19 Feb 2020 12:00:55 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2sm625926pjv.18.2020.02.19.12.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 12:00:53 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2 1/3] net: phy: broadcom: Allow BCM54810 to use bcm54xx_adjust_rxrefclk()
Date:   Wed, 19 Feb 2020 12:00:47 -0800
Message-Id: <20200219200049.12512-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219200049.12512-1-f.fainelli@gmail.com>
References: <20200219200049.12512-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function bcm54xx_adjust_rxrefclk() works correctly on the BCM54810
PHY, allow this device ID to proceed through.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

