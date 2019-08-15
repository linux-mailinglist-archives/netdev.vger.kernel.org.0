Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493CB8EB42
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731821AbfHOMOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:14:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45266 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731754AbfHOMOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:14:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id q12so1999257wrj.12
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ite2+cyYKr5Ubv/Uz/iYj17u6zNVkWX7EHgtLXwUr4c=;
        b=ATIonCGS1A4ZduM6rWOkDqDC2oYNiAYXqtEZXHZx+nGndCNEuCJb6p9pm5g9MXrEt0
         R11N8ep2fNRrgyZaDDejlSkxXwgjouLQyc5BobM5emO/E0cTecgdczxRMbA6owZXjce1
         k7m0f2PO3iq/bVQzDluQ9xHdT3/3SHloFqvpXdImX80/TnPkkrzzEyaqaV196CT0X140
         Wb7THAd5u/DEGLpSzBxgJ3i/FAsRqErezkXaFG1lrzdopeZSqcYgNNGi7xgiijeWfMeh
         GLvN5AkuN9YXGMmW8BwXw778E4yVrkZyFIlComL5Wn6QmUY5dfN1UKPcgGTlXtK/N9am
         dXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ite2+cyYKr5Ubv/Uz/iYj17u6zNVkWX7EHgtLXwUr4c=;
        b=cWqMrr6nDdqA7Y/7atnyxSFYU79Yr7hb+KQt4kSkeMlM+nOuYS1weGy/CW9YIGJ5uC
         UlOxvSQpnGwaNZIa3bqpuzm2A9BJxmjx/r1F4DD3DpycNpEAgQ70v3UyZM2DONSrcpWC
         8yITx9+51kEYZoqhO9wz5Tgq6eYNq63gzVx0XE+hamaFXBSAN2gphdKZ9WPOq+KpPteQ
         j+GYnoCz6ipFoBoyseBr2cxVErIa2liLy7L7tGLJ6u4rdCD3IHdtdozgC+vYoMFC9n2M
         R2p/ajqop/ly+9IAZXDjjLNxwp3UfoaP1b9NaRqhX5pfPx0A0UzYTsMX2c4WxrIn3cqm
         xIGA==
X-Gm-Message-State: APjAAAU3BahO7eGpOoUp25tiOltD8sBmw0uI8mTd8GA2F5gD6tb7XyOe
        45TnSh1UcMX/sMg3iIMboz7QLVRQ
X-Google-Smtp-Source: APXvYqxTMMTl4WT9JbR1MNUVR4kI8LA9wF+8dk5RwB7zfCMXe4TWSPwqk0i7e4yff3xI6JalrLWoZA==
X-Received: by 2002:a5d:5701:: with SMTP id a1mr5206640wrv.95.1565871270746;
        Thu, 15 Aug 2019 05:14:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id r16sm5122742wrc.81.2019.08.15.05.14.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 05:14:30 -0700 (PDT)
Subject: [PATCH net-next v2 2/2] r8169: use the generic EEE management
 functions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <88a71ee7-a17d-ac9c-c998-d0ea35e5c566@gmail.com>
Message-ID: <14f2831d-5f89-1345-5674-b25f7d95255f@gmail.com>
Date:   Thu, 15 Aug 2019 14:14:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <88a71ee7-a17d-ac9c-c998-d0ea35e5c566@gmail.com>
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
v2.
- rebased
---
 drivers/net/ethernet/realtek/r8169_main.c | 172 +++-------------------
 1 file changed, 24 insertions(+), 148 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 34d072f0c..c9550b4f9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -733,6 +733,13 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 	       tp->mac_version != RTL_GIGA_MAC_VER_39;
 }
 
+static bool rtl_supports_eee(struct rtl8169_private *tp)
+{
+	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
+	       tp->mac_version != RTL_GIGA_MAC_VER_37 &&
+	       tp->mac_version != RTL_GIGA_MAC_VER_39;
+}
+
 struct rtl_cond {
 	bool (*check)(struct rtl8169_private *);
 	const char *msg;
@@ -1945,144 +1952,40 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
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
@@ -2093,38 +1996,10 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
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
@@ -2151,10 +2026,11 @@ static const struct ethtool_ops rtl8169_ethtool_ops = {
 
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


