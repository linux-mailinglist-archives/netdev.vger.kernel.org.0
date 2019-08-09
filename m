Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF48882D2
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfHISpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:45:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35723 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfHISpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:45:31 -0400
Received: by mail-wr1-f67.google.com with SMTP id k2so13268345wrq.2
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 11:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oYAMc+kmFQb3nf2Vnw0NoEB+iuyFnIPOztJHbaIErBU=;
        b=IWpARw/LVVR0oVRIkrtpzA0U7lAKo07ZdgBBARjqVqW2sMHNxj0/zhcnWMGewcr2uB
         TzALpDdfKaQBcbGmgyANl9DNuw8Wu4C16JR8I6r+6dEnIZvoH8YIazZPgNHPj/PpPQss
         dSpYYg1Z4m4x6aQwzFVxcEa3Y40hbr0xEyzrpIp/cfq5DA0BIDb+GVld74ZWuxxqp0Hw
         whqZAc+lVAfdAaxLKV2CkuI9YtAKRdhyjc9dtlmUJ2mXD+4M+FiRQFSPewCbUNMR4c+z
         5wQCCERm1gtp95CkDoTH8hNNAIgvp8+atRbFad2hlN+Fb8Ti1Evxplz1hLwuO1Iw/W4Z
         Tkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oYAMc+kmFQb3nf2Vnw0NoEB+iuyFnIPOztJHbaIErBU=;
        b=UpJiGjI3gQzCTlU9bg/mimGWyd/NHCdMjS/j3o9iUuxr3RULsWFhJmRIHpefWLAv3C
         uv6GtoCkrseCSN9uhfSe47GqtC7nh0KXT65brtydMe/ddaueBAl2LFyND77JxUQv3WMq
         RkBX0EzNrFKsC2rLSDwvxH2sMlOI1mWNvbDXO/QBz+9m9CAh/BQpqj0m+iLrYRl3c+yw
         3QCbAVO/nKlrRUZHUbgmhEPlwS9T9eR4xSzGmbf85RcQG4XT+k7FvDGA83RUADEyd0Xv
         S4AXqc85Msmc9hCLxkogO3bKK6jyqcUU+Qu18dea5Uj1AWDhAAsiD11qdrEejoFGCGDP
         /7ww==
X-Gm-Message-State: APjAAAXvf61Rh6WpOskojYGnINGUjYm7JSowgckf8/WLMwAixUvwu9Ue
        A09gt3MGFt74uOawGnGFav7JOEdl
X-Google-Smtp-Source: APXvYqxv+FlLOrpZ92WbRCkT91DdsZvfDLg6Xa8KHTZfFGxtyDkYofwZJwMBwxy2jInIP9S74L/qdw==
X-Received: by 2002:a5d:664a:: with SMTP id f10mr11067642wrw.90.1565376328700;
        Fri, 09 Aug 2019 11:45:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id s3sm6933618wmh.27.2019.08.09.11.45.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 11:45:28 -0700 (PDT)
Subject: [PATCH net-next v2 1/4] net: phy: simplify genphy_config_advert by
 using the linkmode_adv_to_xxx_t functions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
Message-ID: <6ba42ade-5874-9bc9-4f4d-b80f79c0deca@gmail.com>
Date:   Fri, 9 Aug 2019 20:43:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using linkmode_adv_to_mii_adv_t and linkmode_adv_to_mii_ctrl1000_t
allows to simplify the code. In addition avoiding the conversion to
the legacy u32 advertisement format allows to remove the warning.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v2:
- added to series
---
 drivers/net/phy/phy_device.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7ddd91df9..a70a98dc9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1564,24 +1564,20 @@ EXPORT_SYMBOL(phy_reset_after_clk_enable);
  */
 static int genphy_config_advert(struct phy_device *phydev)
 {
-	u32 advertise;
-	int bmsr, adv;
-	int err, changed = 0;
+	int err, bmsr, changed = 0;
+	u32 adv;
 
 	/* Only allow advertising what this PHY supports */
 	linkmode_and(phydev->advertising, phydev->advertising,
 		     phydev->supported);
-	if (!ethtool_convert_link_mode_to_legacy_u32(&advertise,
-						     phydev->advertising))
-		phydev_warn(phydev, "PHY advertising (%*pb) more modes than genphy supports, some modes not advertised.\n",
-			    __ETHTOOL_LINK_MODE_MASK_NBITS,
-			    phydev->advertising);
+
+	adv = linkmode_adv_to_mii_adv_t(phydev->advertising);
 
 	/* Setup standard advertisement */
 	err = phy_modify_changed(phydev, MII_ADVERTISE,
 				 ADVERTISE_ALL | ADVERTISE_100BASE4 |
 				 ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM,
-				 ethtool_adv_to_mii_adv_t(advertise));
+				 adv);
 	if (err < 0)
 		return err;
 	if (err > 0)
@@ -1598,13 +1594,7 @@ static int genphy_config_advert(struct phy_device *phydev)
 	if (!(bmsr & BMSR_ESTATEN))
 		return changed;
 
-	/* Configure gigabit if it's supported */
-	adv = 0;
-	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
-			      phydev->supported) ||
-	    linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-			      phydev->supported))
-		adv = ethtool_adv_to_mii_ctrl1000_t(advertise);
+	adv = linkmode_adv_to_mii_ctrl1000_t(phydev->advertising);
 
 	err = phy_modify_changed(phydev, MII_CTRL1000,
 				 ADVERTISE_1000FULL | ADVERTISE_1000HALF,
-- 
2.22.0


