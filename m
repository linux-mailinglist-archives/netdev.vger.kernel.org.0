Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAFB882D5
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436479AbfHISpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:45:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37751 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfHISpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:45:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so6453684wmf.2
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 11:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iAl3FTn1nncAdom/v1tJNkBn6eoR882on+kp/bND09c=;
        b=AlJeUGLguwZeqPoprt2rfp2u6brRW9nXLpw/mIuvSwcL2MueEsjlv3yG9kJn5eWNwV
         LlAiW/fWZFxLXDNhZvUPJ/cGCUPAnhthe5gwZGD6V3KclQyXzHmvbaU/k2oaNCHfOP+x
         vtMHX08y+xzISPIjF2n+xaDjzt3Xj0wVSGxPUoVv7aTNNj7wdN4dPZzSzlc1rGtb/nZj
         pRO/yklE2TZEjabkaN+eo2j7R70mD/jN7W6rhaDY7z7iUVmZAePIVW5sdJ5neGSymB07
         E5O4npMiRvoDBK3XUtmK4D1WbWAFyEil4VAJsflGxlzPMnhY8PMXyWgfzPNRlJ4MExTe
         sMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iAl3FTn1nncAdom/v1tJNkBn6eoR882on+kp/bND09c=;
        b=tm0BRtwFfnrKFtdOvEYfvju+nbyxviPOZsAC3G4DACgATPE7GBcnoCMdDbx4BbMQe7
         t7pnqcAkWHODMfXcRQSXo/6zveMNA30VIkPm+R+0pLcz6mEpsGk+ZncWbboLH8kiFw/x
         pYs3pfOVsFgQA11TD6HmOdwn1kgyRdBDoLuHk413ECGQnvgvtecBOcn2LBtRPKrXbhih
         ZYkjOq4AmzgGzFi3KIK2zVIrzneduXz4HPBfQhTgmwJb+g+/pNT7quNrmYRJWJ+0y+oo
         RBHEY5qMsD6Uda7l69z1yH1p9IkzSh2JCGgAPlaGF6ARD6RvFV8EHLNsV6aqRd4qXobs
         ihyg==
X-Gm-Message-State: APjAAAUtqSrejPIsUOXjQn9PNpFKGdtZf3lZqZPRKuYRJqei7++GSh5j
        HpHNUaAAX8m3pbVe4xpuBA1W8dV+
X-Google-Smtp-Source: APXvYqwHS09AUotk0ZYDKTyIxATvz6sHaINV5LPTR/XiyM8QMlgsJmyZzMlI8HOiVz+/mXLnJ9pzHw==
X-Received: by 2002:a1c:407:: with SMTP id 7mr13105147wme.113.1565376332659;
        Fri, 09 Aug 2019 11:45:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id q20sm29239305wrc.79.2019.08.09.11.45.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 11:45:32 -0700 (PDT)
Subject: [PATCH net-next v2 4/4] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
Message-ID: <49454e5b-465d-540e-cc01-07717a773e33@gmail.com>
Date:   Fri, 9 Aug 2019 20:45:14 +0200
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

This adds support for the integrated 2.5Gbps PHY in Realtek RTL8125.
Advertisement of 2.5Gbps mode is done via a vendor-specific register.
Same applies to reading NBase-T link partner advertisement.
Unfortunately this 2.5Gbps PHY shares the PHY ID with the integrated
1Gbps PHY's in other Realtek network chips and so far no method is
known to differentiate them. As a workaround use a dedicated fake PHY ID
that is set by the network driver by intercepting the MDIO PHY ID read.

v2:
- Create dedicated PHY driver and use a fake PHY ID that is injected by
  the network driver. Suggested by Andrew Lunn.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 62 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a669945eb..5b466e80d 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -39,6 +39,11 @@
 #define RTL8366RB_POWER_SAVE			0x15
 #define RTL8366RB_POWER_SAVE_ON			BIT(12)
 
+#define RTL_ADV_2500FULL			BIT(7)
+#define RTL_LPADV_10000FULL			BIT(11)
+#define RTL_LPADV_5000FULL			BIT(6)
+#define RTL_LPADV_2500FULL			BIT(5)
+
 MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
 MODULE_LICENSE("GPL");
@@ -256,6 +261,53 @@ static int rtl8366rb_config_init(struct phy_device *phydev)
 	return ret;
 }
 
+static int rtl8125_get_features(struct phy_device *phydev)
+{
+	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+			 phydev->supported);
+
+	return genphy_read_abilities(phydev);
+}
+
+static int rtl8125_config_aneg(struct phy_device *phydev)
+{
+	int ret = 0;
+
+	if (phydev->autoneg == AUTONEG_ENABLE) {
+		u16 adv2500 = 0;
+
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+				      phydev->advertising))
+			adv2500 = RTL_ADV_2500FULL;
+
+		ret = phy_modify_paged_changed(phydev, 0xa5d, 0x12,
+					       RTL_ADV_2500FULL, adv2500);
+		if (ret < 0)
+			return ret;
+	}
+
+	return __genphy_config_aneg(phydev, ret);
+}
+
+static int rtl8125_read_status(struct phy_device *phydev)
+{
+	if (phydev->autoneg == AUTONEG_ENABLE) {
+		int lpadv = phy_read_paged(phydev, 0xa5d, 0x13);
+
+		if (lpadv < 0)
+			return lpadv;
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+			phydev->lp_advertising, lpadv & RTL_LPADV_10000FULL);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
+			phydev->lp_advertising, lpadv & RTL_LPADV_5000FULL);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+			phydev->lp_advertising, lpadv & RTL_LPADV_2500FULL);
+	}
+
+	return genphy_read_status(phydev);
+}
+
 static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
@@ -332,6 +384,16 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001cca50),
+		.name		= "RTL8125 2.5Gbps internal",
+		.get_features	= rtl8125_get_features,
+		.config_aneg	= rtl8125_config_aneg,
+		.read_status	= rtl8125_read_status,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
2.22.0


