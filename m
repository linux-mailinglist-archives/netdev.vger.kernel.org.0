Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D965D86950
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404263AbfHHTGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:06:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38690 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404197AbfHHTGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:06:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so95960901wrr.5
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GBMYizvJC2b+j4pdXuk0V8lP2jZyyyEusrUBzHW30hA=;
        b=muFjxN6WYeERjHDysM+2VEbFreJ0IqBslV6dM2drePaG3u5Gp4BSLHMYRPDtkssxjl
         MR+Y3yyDkoT8UXKPFn6lmesLlhNMujz+WY8q1US3TvCiQr6cXlPCwKAjy0qCQc1Qn1vl
         gKHWCVljUsZvnAb3okrWTeADMuQN6qM7YxCBBgkL4T6Upx2v81MVZ8YXVwubIHTdT7YP
         0j/I79py+9N6mtULFwRUWp7rnwRRZHXtJUaQ29t7pceAShh7NqX4b7WTZCh+S/GLZE6/
         7J7EPGZG3qrn7b87SyPoje058HHq9JTJSkNvwBuGiWKlmOM5cFeWjxSAOeu2FCueyifz
         SW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GBMYizvJC2b+j4pdXuk0V8lP2jZyyyEusrUBzHW30hA=;
        b=DJaOjeccs/CPHmN8QgJozjcpidhDR1aY7uSWZuQa88a10+t7QptFTgcrm7KEz3gcZP
         XY7aXAvB6i5InkxkHrlTEOTc8Q3fWGXRpQvXF1RV3yKJezGBnSzdD2ipP0VF2OCxvARV
         mmwNQ4T+X8GZDsx2Jvj+N0RU65WJPQMEvrT69Vp2tOKjYwHSSVO+sFNGTIfVew9W8240
         qiqUrsgRZhebNPt0MGCY+oJQ8SQ08HaeBp92vYQrtl38nK6KQdyigizFF9F06qKI3HDv
         dMRdn8sBMzp8hJpHGHPuMw9274QDCp+Xhc7cofj8vTr1E5FnN5Rn6Vjvk2mlRdaC2FFH
         nZBw==
X-Gm-Message-State: APjAAAWKyuT4jsMCUOsmw+6dt7arg2/ruGjbrOE/gX+von1KP7XS6yW6
        j0ef7fF6KIadLVslUfYtg8soMr8b
X-Google-Smtp-Source: APXvYqwS1UT+f3Qxp21qY8iU5fYY/L9ZsEW0sQ0OujXDuuDQxsCwCXzhk/pPOOAgn4+NUzK6GYj8OQ==
X-Received: by 2002:a5d:50d1:: with SMTP id f17mr17705821wrt.124.1565291164844;
        Thu, 08 Aug 2019 12:06:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id f134sm6394502wmg.20.2019.08.08.12.06.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 12:06:04 -0700 (PDT)
Subject: [PATCH net-next 3/3] net: phy: realtek: add support for the 2.5Gbps
 PHY in RTL8125
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
Message-ID: <64769c3d-42b6-8eb8-26e4-722869408986@gmail.com>
Date:   Thu, 8 Aug 2019 21:05:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
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
known to differentiate them. This means we can't autodetect 2.5Gbps
support and the network driver has to add 2.5Gbps to the supported
and advertised modes.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 48 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a669945eb..35c981476 100644
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
@@ -256,6 +261,47 @@ static int rtl8366rb_config_init(struct phy_device *phydev)
 	return ret;
 }
 
+static int rtlgen_config_aneg(struct phy_device *phydev)
+{
+	int ret = 0;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+	    phydev->supported) && phydev->autoneg == AUTONEG_ENABLE) {
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
+static int rtlgen_read_status(struct phy_device *phydev)
+{
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+	    phydev->supported) && phydev->autoneg == AUTONEG_ENABLE) {
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
@@ -328,6 +374,8 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc800),
 		.name		= "Generic Realtek PHY",
+		.config_aneg	= rtlgen_config_aneg,
+		.read_status	= rtlgen_read_status,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
-- 
2.22.0


