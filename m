Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29B29FCB
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404175AbfEXUY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:24:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33687 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403762AbfEXUY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:24:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id d9so11189354wrx.0
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 13:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hbjYOY61r3bAHY9nVhtOSlCW13BSASK2s4WbQPxCIx0=;
        b=VcSXwyI6pv9Bh79wA/J1qGYNhCjdfKJOk6IRssTp/5Y/+Dj06uOHZ/R5ojphmyg6zL
         nO63ZCMu3iQ/Jluj8jvXG4IAgjgBPfreuaKgzI/cmHJ5meqm/FrVbTcOixTl8e32PqU4
         29LG5ikg5mDvm0sVXxi3PlFikKHZxlkvPJ/UqLS5rEmaYLTE/FfIYWyUcyiRCCGi7PPV
         hfaUMVAuC56+H+v0EDW1+e/YczpTteET4yJyHpKTvYFjWgmD+cVMBV6o4yk0QtHMFT/p
         pJGhYu5l3zsZo+/71sSBqTMnv0ef97jvSspiNiDLxBFukr3+GU2MJ9CoIOqABJo37kps
         mJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hbjYOY61r3bAHY9nVhtOSlCW13BSASK2s4WbQPxCIx0=;
        b=C/KqWpAmuCpJz+n/RBxEomnJcCj3ZFU+fPOXuUs9LEN82Ap4/WDXmrJwprVa3JHwY1
         5dC0B82TlAp5jjMZHGWFbCDMh6qiABlvEOx8t8Jd648OoqqwegDkOE3v4LPm+MO8svrV
         7UAsx06OvcWDLVoLHiph+Y4TmSH4Xu6G/yL3jvoMzltm/3+VsFqLC4VBNAVgVlL2ZpOx
         eyFCnHQu/9t9hiLZ5zma7vk0VuyB0IgWJfn7vvny0ECqxaVEJfmm4dirJYx1pjDRspBN
         V1M1MfR+Gn78ougVqeu+G1USZDJLrYpJVDmYJ0dWgeWfe0nF53k1xXLVSyYTfm3oj3aj
         /nrg==
X-Gm-Message-State: APjAAAXgZpYrkwEg1GYTnOaApzIJgH3tQYUp3+UhTVyYeCDfFafNC63O
        SiT4Y5VuQs3AQ00Z3kVV7rdUCMJ/
X-Google-Smtp-Source: APXvYqwu8PIeN8boTqUiuMo+hsGujINk8sYQSiFzt5OpQw0qv8ieTEI6OzjP/d6g4WYIqux0SwQ7HQ==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr4926506wrw.309.1558729464068;
        Fri, 24 May 2019 13:24:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f? (p200300EA8BE97A00E8AA5F65936F3A1F.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f])
        by smtp.googlemail.com with ESMTPSA id a128sm3366687wmc.13.2019.05.24.13.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 13:24:23 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: bcm87xx: improve bcm87xx_config_init and
 feature detection
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <9ab5f57a-a0be-ca78-a824-df406244ed7b@gmail.com>
Date:   Fri, 24 May 2019 22:24:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY drivers don't have to and shouldn't fiddle with phylib internals.
Most of the code in bcm87xx_config_init() can be removed because
phylib takes care.

In addition I replaced usage of PHY_10GBIT_FEC_FEATURES with an
implementation of the get_features callback. PHY_10GBIT_FEC_FEATURES
is used by this driver only and it's questionable whether there
will be any other PHY supporting this mode only. Having said that
in one of the next kernel versions we may decide to remove it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/bcm87xx.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
index f0c0eefe2..f6dce6850 100644
--- a/drivers/net/phy/bcm87xx.c
+++ b/drivers/net/phy/bcm87xx.c
@@ -81,22 +81,18 @@ static int bcm87xx_of_reg_init(struct phy_device *phydev)
 }
 #endif /* CONFIG_OF_MDIO */
 
-static int bcm87xx_config_init(struct phy_device *phydev)
+static int bcm87xx_get_features(struct phy_device *phydev)
 {
-	linkmode_zero(phydev->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseR_FEC_BIT,
 			 phydev->supported);
-	linkmode_zero(phydev->advertising);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseR_FEC_BIT,
-			 phydev->advertising);
-	phydev->state = PHY_NOLINK;
-	phydev->autoneg = AUTONEG_DISABLE;
-
-	bcm87xx_of_reg_init(phydev);
-
 	return 0;
 }
 
+static int bcm87xx_config_init(struct phy_device *phydev)
+{
+	return bcm87xx_of_reg_init(phydev);
+}
+
 static int bcm87xx_config_aneg(struct phy_device *phydev)
 {
 	return -EINVAL;
@@ -194,7 +190,7 @@ static struct phy_driver bcm87xx_driver[] = {
 	.phy_id		= PHY_ID_BCM8706,
 	.phy_id_mask	= 0xffffffff,
 	.name		= "Broadcom BCM8706",
-	.features	= PHY_10GBIT_FEC_FEATURES,
+	.get_features	= bcm87xx_get_features,
 	.config_init	= bcm87xx_config_init,
 	.config_aneg	= bcm87xx_config_aneg,
 	.read_status	= bcm87xx_read_status,
@@ -206,7 +202,7 @@ static struct phy_driver bcm87xx_driver[] = {
 	.phy_id		= PHY_ID_BCM8727,
 	.phy_id_mask	= 0xffffffff,
 	.name		= "Broadcom BCM8727",
-	.features	= PHY_10GBIT_FEC_FEATURES,
+	.get_features	= bcm87xx_get_features,
 	.config_init	= bcm87xx_config_init,
 	.config_aneg	= bcm87xx_config_aneg,
 	.read_status	= bcm87xx_read_status,
-- 
2.21.0

