Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3DF8AF43
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfHMGJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:09:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54907 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfHMGJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:09:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so349739wme.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 23:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=eGSBhX4lMhPbxgcSsPM/vLrNFrqj96DvedloTGnyIOY=;
        b=S13ddFbPGhp6mIwSTB2kkrzYrnVVww6wIQiXah05jUvob+PQV2kNyS4JngS52KNWY1
         57EFFCqf4187qlqdtSHO24w+3BzDkHquiTxb3EXqEN69vvoS0NBLrkAZ+QqbI85XC5LQ
         Xr56792+ElzqiBXcPGKjLhQKytVY4weQvgn9NIMXuUfS4Bl69MHiy4f9JccNhy3YftWn
         fQLivMfET7oaAxhp6gx0dYSj/BcRECKqkOzvBQVW9Xwu9ctIUxlOQaGADfioy0t1eMO7
         rCknk92cI+mRHEbzv8Pk7VQL+WSf+cXsXd11mXXqsOwyd/91z6aOc0KptdCNvjc5KSm0
         OvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=eGSBhX4lMhPbxgcSsPM/vLrNFrqj96DvedloTGnyIOY=;
        b=EF2Dm8abKzPyA9/MPrFWh8uNWydmS5xxgy3DhOEJKipLWM+dkh34YWrk0yR8G88/w7
         PaelC4yb1Ft+jd2aOHQEf0BoEaXtGj6NlDjdLBsb3gb+OpUsoZ3Gbstk8WKE7CLs/H0N
         fWr0GLkrW8DYdiY74Hugefr1vQX6ZnGMHRduL7D0sbWv4g8VNMjpdLG1RJgJUyQHi5pY
         JIKpRIkt+w+W240tcJo/7mzUrsOgJUcH9NxMPzhhp/PJWzHFwrfZYcBavcRZGpMXvwTi
         Bnqp1c2yRaPnyZu+COnfFmOBpZFKVQ/4J/7/cIz9B+VnPDNYm6HFbDIVscUQ+NDYBbDs
         ojjg==
X-Gm-Message-State: APjAAAV2uJ4MlTEnsJKk+i1xSvUEBw8i8Nhmt3xnRGzfY/9+NXwsC/T4
        fA44J3Zsp+Ns4YjrXhpZ6J7bGGs9
X-Google-Smtp-Source: APXvYqxeuLXiw1SPX5MOD55PRa9bkx6wx1r+8a3wPhNF6rkpuXMFfwicwE5yJ/c1n9lY78TX8KfpxA==
X-Received: by 2002:a1c:200a:: with SMTP id g10mr992308wmg.160.1565676594179;
        Mon, 12 Aug 2019 23:09:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:19ec:e8b6:e9e2:3648? (p200300EA8F2F320019ECE8B6E9E23648.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:19ec:e8b6:e9e2:3648])
        by smtp.googlemail.com with ESMTPSA id x6sm115684204wrt.63.2019.08.12.23.09.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 23:09:53 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: realtek: add NBase-T PHY auto-detection
Message-ID: <e69e636d-9109-aec9-4d8a-e36af37a706b@gmail.com>
Date:   Tue, 13 Aug 2019 08:09:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek provided information on how the new NIC-integrated PHY's
expose whether they support 2.5G/5G/10G. This allows to automatically
differentiate 1Gbps and 2.5Gbps PHY's, and therefore allows to
remove the fake PHY ID mechanism for RTL8125.
So far RTL8125 supports 2.5Gbps only, but register layout for faster
modes has been defined already, so let's use this information to be
future-proof.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 48 +++++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 5b466e80d..c49a1fb13 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -39,11 +39,16 @@
 #define RTL8366RB_POWER_SAVE			0x15
 #define RTL8366RB_POWER_SAVE_ON			BIT(12)
 
+#define RTL_SUPPORTS_5000FULL			BIT(14)
+#define RTL_SUPPORTS_2500FULL			BIT(13)
+#define RTL_SUPPORTS_10000FULL			BIT(0)
 #define RTL_ADV_2500FULL			BIT(7)
 #define RTL_LPADV_10000FULL			BIT(11)
 #define RTL_LPADV_5000FULL			BIT(6)
 #define RTL_LPADV_2500FULL			BIT(5)
 
+#define RTL_GENERIC_PHYID			0x001cc800
+
 MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
 MODULE_LICENSE("GPL");
@@ -263,8 +268,18 @@ static int rtl8366rb_config_init(struct phy_device *phydev)
 
 static int rtl8125_get_features(struct phy_device *phydev)
 {
-	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
-			 phydev->supported);
+	int val;
+
+	val = phy_read_paged(phydev, 0xa61, 0x13);
+	if (val < 0)
+		return val;
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+			 phydev->supported, val & RTL_SUPPORTS_2500FULL);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
+			 phydev->supported, val & RTL_SUPPORTS_5000FULL);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+			 phydev->supported, val & RTL_SUPPORTS_10000FULL);
 
 	return genphy_read_abilities(phydev);
 }
@@ -308,6 +323,29 @@ static int rtl8125_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static bool rtlgen_supports_2_5gbps(struct phy_device *phydev)
+{
+	int val;
+
+	phy_write(phydev, RTL821x_PAGE_SELECT, 0xa61);
+	val = phy_read(phydev, 0x13);
+	phy_write(phydev, RTL821x_PAGE_SELECT, 0);
+
+	return val >= 0 && val & RTL_SUPPORTS_2500FULL;
+}
+
+static int rtlgen_match_phy_device(struct phy_device *phydev)
+{
+	return phydev->phy_id == RTL_GENERIC_PHYID &&
+	       !rtlgen_supports_2_5gbps(phydev);
+}
+
+static int rtl8125_match_phy_device(struct phy_device *phydev)
+{
+	return phydev->phy_id == RTL_GENERIC_PHYID &&
+	       rtlgen_supports_2_5gbps(phydev);
+}
+
 static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
@@ -378,15 +416,15 @@ static struct phy_driver realtek_drvs[] = {
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 	}, {
-		PHY_ID_MATCH_EXACT(0x001cc800),
-		.name		= "Generic Realtek PHY",
+		.name		= "Generic FE-GE Realtek PHY",
+		.match_phy_device = rtlgen_match_phy_device,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 	}, {
-		PHY_ID_MATCH_EXACT(0x001cca50),
 		.name		= "RTL8125 2.5Gbps internal",
+		.match_phy_device = rtl8125_match_phy_device,
 		.get_features	= rtl8125_get_features,
 		.config_aneg	= rtl8125_config_aneg,
 		.read_status	= rtl8125_read_status,
-- 
2.22.0

