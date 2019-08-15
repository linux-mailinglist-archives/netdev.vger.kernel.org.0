Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042AC8E88A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbfHOJrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:47:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42830 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730378AbfHOJro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:47:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id b16so1676613wrq.9
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 02:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tAtvyxeCv4ClHFYyjhidg97L8qlsI7FF1pHqnwokd1Q=;
        b=tm3ZlW60JVY1xZElxwwNZgO7On5w3MChOzIVwc9SlnljiqgEzcz94QglKJSI24+tpx
         8sby24Ql2LL3u5Utf1Z3HUckR7KhyGwM/SVzmHte/3QW87UcclVziMVJeDLBy5VqgWTv
         zi8jnYhkO7IZ1/i9ML2+xKPMCN3uMyTMfZlcS2ix1xPJs/u2jbaeU0sE8BvxX9CU3XzS
         4HrSAGGlyJDnXGvK6wr0d5XnTJXztKulIbOAXnbvLEqAqcDSuqW5Oek1uQvryYCmMJev
         9aYHARgTsWsvDu1qlNG7doBjIM9TwTj1mGf2hkb90y1PvttHtw/TOE7+QrkT3MvpQP6n
         bOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tAtvyxeCv4ClHFYyjhidg97L8qlsI7FF1pHqnwokd1Q=;
        b=fA39+XjjzOHRTLzaElQTlhQ49zS7ZQzbq2pS1z0fJtvU4CObUHW8d8pvsPmUqP96QR
         gngVKBObfmjBDjYb7dVHDCIVnkcoFJzJ/zR/IT0HbTZKuH0n0mygCX3fbri0JRIFx205
         pSNNVGq8Q1bvGAXEk6HxLtwOGaVif40sILA75BsTb+p1tXFrqdOKaQndj/9pf9dDFhE4
         kfxvp/CUNiEoL6KEA/hQJf2Iet2w0XS4gwnXojD2gsQCr5Lqp9L0vt4WlslwFL53mr8f
         Ja2PBcBxM1HAojTtPXcJ4IljUv6cv0zwSmiapovLiadxcT8q9g+oQmLLuEbGcnPyFOGb
         LFUw==
X-Gm-Message-State: APjAAAWcDZbbigEAyWjFVAhT84QBDcWvfB9s1qVbzeyly1/Vc3tdV/Vs
        RT5fpSdhXzlhg/S+lOtGenARuY8X
X-Google-Smtp-Source: APXvYqyv52s9zyPM04BagYxPxsD2tgB3gQu32lSkLmrq0fqulFWuwXtj8W3wyhx0Xhy0oXgCxvrS3Q==
X-Received: by 2002:adf:afe7:: with SMTP id y39mr4341517wrd.350.1565862462095;
        Thu, 15 Aug 2019 02:47:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:7cbb:1cda:9a01:259c? (p200300EA8F2F32007CBB1CDA9A01259C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:7cbb:1cda:9a01:259c])
        by smtp.googlemail.com with ESMTPSA id p69sm1666481wme.36.2019.08.15.02.47.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:47:41 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: use the generic EEE management functions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4a6878bf-344e-2df5-df00-b80c7c0982d1@gmail.com>
Message-ID: <c5a137b1-d9d3-070c-55a1-938d6b77bdbc@gmail.com>
Date:   Thu, 15 Aug 2019 11:47:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4a6878bf-344e-2df5-df00-b80c7c0982d1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the Realtek PHY driver maps the vendor-specific EEE registers
to the standard MMD registers, we can remove all special handling and
use the generic functions phy_ethtool_get/set_eee.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 172 +++-------------------
 1 file changed, 24 insertions(+), 148 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7dd75c047..bd9077f85 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -758,6 +758,13 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 	       tp->mac_version <= RTL_GIGA_MAC_VER_51;
 }
 
+static bool rtl_supports_eee(struct rtl8169_private *tp)
+{
+	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
+	       tp->mac_version != RTL_GIGA_MAC_VER_37 &&
+	       tp->mac_version != RTL_GIGA_MAC_VER_39;
+}
+
 static void rtl_read_mac_from_reg(struct rtl8169_private *tp, u8 *mac, int reg)
 {
 	int i;
@@ -2014,144 +2021,40 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	return 0;
 }
 
-static int rtl_get_eee_supp(struct rtl8169_private *tp)
-{
-	struct phy_device *phydev = tp->phydev;
-	int ret;
-
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_35:
-	case RTL_GIGA_MAC_VER_36:
-	case RTL_GIGA_MAC_VER_38:
-		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
-		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		ret = phy_read_paged(phydev, 0x0a5c, 0x12);
-		break;
-	default:
-		ret = -EPROTONOSUPPORT;
-		break;
-	}
-
-	return ret;
-}
-
-static int rtl_get_eee_lpadv(struct rtl8169_private *tp)
-{
-	struct phy_device *phydev = tp->phydev;
-	int ret;
-
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_35:
-	case RTL_GIGA_MAC_VER_36:
-	case RTL_GIGA_MAC_VER_38:
-		ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_LPABLE);
-		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		ret = phy_read_paged(phydev, 0x0a5d, 0x11);
-		break;
-	default:
-		ret = -EPROTONOSUPPORT;
-		break;
-	}
-
-	return ret;
-}
-
-static int rtl_get_eee_adv(struct rtl8169_private *tp)
-{
-	struct phy_device *phydev = tp->phydev;
-	int ret;
-
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_35:
-	case RTL_GIGA_MAC_VER_36:
-	case RTL_GIGA_MAC_VER_38:
-		ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV);
-		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		ret = phy_read_paged(phydev, 0x0a5d, 0x10);
-		break;
-	default:
-		ret = -EPROTONOSUPPORT;
-		break;
-	}
-
-	return ret;
-}
-
-static int rtl_set_eee_adv(struct rtl8169_private *tp, int val)
-{
-	struct phy_device *phydev = tp->phydev;
-	int ret = 0;
-
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_35:
-	case RTL_GIGA_MAC_VER_36:
-	case RTL_GIGA_MAC_VER_38:
-		ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, val);
-		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
-		phy_write_paged(phydev, 0x0a5d, 0x10, val);
-		break;
-	default:
-		ret = -EPROTONOSUPPORT;
-		break;
-	}
-
-	return ret;
-}
-
 static int rtl8169_get_eee(struct net_device *dev, struct ethtool_eee *data)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct device *d = tp_to_dev(tp);
 	int ret;
 
+	if (!rtl_supports_eee(tp))
+		return -EOPNOTSUPP;
+
 	pm_runtime_get_noresume(d);
 
 	if (!pm_runtime_active(d)) {
 		ret = -EOPNOTSUPP;
-		goto out;
+	} else {
+		ret = phy_ethtool_get_eee(tp->phydev, data);
 	}
 
-	/* Get Supported EEE */
-	ret = rtl_get_eee_supp(tp);
-	if (ret < 0)
-		goto out;
-	data->supported = mmd_eee_cap_to_ethtool_sup_t(ret);
-
-	/* Get advertisement EEE */
-	ret = rtl_get_eee_adv(tp);
-	if (ret < 0)
-		goto out;
-	data->advertised = mmd_eee_adv_to_ethtool_adv_t(ret);
-	data->eee_enabled = !!data->advertised;
-
-	/* Get LP advertisement EEE */
-	ret = rtl_get_eee_lpadv(tp);
-	if (ret < 0)
-		goto out;
-	data->lp_advertised = mmd_eee_adv_to_ethtool_adv_t(ret);
-	data->eee_active = !!(data->advertised & data->lp_advertised);
-out:
 	pm_runtime_put_noidle(d);
-	return ret < 0 ? ret : 0;
+
+	return ret;
 }
 
 static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct device *d = tp_to_dev(tp);
-	int old_adv, adv = 0, cap, ret;
+	int ret;
+
+	if (!rtl_supports_eee(tp))
+		return -EOPNOTSUPP;
 
 	pm_runtime_get_noresume(d);
 
-	if (!dev->phydev || !pm_runtime_active(d)) {
+	if (!pm_runtime_active(d)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2162,38 +2065,10 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 		goto out;
 	}
 
-	/* Get Supported EEE */
-	ret = rtl_get_eee_supp(tp);
-	if (ret < 0)
-		goto out;
-	cap = ret;
-
-	ret = rtl_get_eee_adv(tp);
-	if (ret < 0)
-		goto out;
-	old_adv = ret;
-
-	if (data->eee_enabled) {
-		adv = !data->advertised ? cap :
-		      ethtool_adv_to_mmd_eee_adv_t(data->advertised) & cap;
-		/* Mask prohibited EEE modes */
-		adv &= ~dev->phydev->eee_broken_modes;
-	}
-
-	if (old_adv != adv) {
-		ret = rtl_set_eee_adv(tp, adv);
-		if (ret < 0)
-			goto out;
-
-		/* Restart autonegotiation so the new modes get sent to the
-		 * link partner.
-		 */
-		ret = phy_restart_aneg(dev->phydev);
-	}
-
+	ret = phy_ethtool_set_eee(tp->phydev, data);
 out:
 	pm_runtime_put_noidle(d);
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 static const struct ethtool_ops rtl8169_ethtool_ops = {
@@ -2220,10 +2095,11 @@ static const struct ethtool_ops rtl8169_ethtool_ops = {
 
 static void rtl_enable_eee(struct rtl8169_private *tp)
 {
-	int supported = rtl_get_eee_supp(tp);
+	struct phy_device *phydev = tp->phydev;
+	int supported = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
 
 	if (supported > 0)
-		rtl_set_eee_adv(tp, supported);
+		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, supported);
 }
 
 static void rtl8169_get_mac_version(struct rtl8169_private *tp)
-- 
2.22.1


