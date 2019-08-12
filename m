Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDAB8A937
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfHLVVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:21:10 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42799 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfHLVVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:21:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id b16so9129560wrq.9
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pK01+2E8hBH5GnrGs+fyAcTQitm8OTGzrznkdBwaeXU=;
        b=qYbwUeqdMJyN71czO7/iuTOXfbob6xeZo2djHXOmw1exa91eoRpERLHJUl4OqGd5m0
         Lbq9lmcesUkzN3m/KtcBESyWBN8eLkxOAEYDgxwHMsuiStTfxh8knkRULnl7CG8hHa0a
         b+MrtH16XPI2MH/xkDNmcabrGuDkpbtXmTsO9nxVPqSAgxLRWKn7yLCejYJgPFTgzpI5
         4JkE9yVL2jnJhpzZcaD6Zr/ATAJmVcWSACVkJYSObMNiGrA4OAL8KkXqZgwllwRNVfqz
         BW6hT6MlAWu7LqL+e4vIBMbuMBiTyevu3iZoRRkTa9K3Lhm8G2X6y3GvVDQIK1oS35hO
         ZNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pK01+2E8hBH5GnrGs+fyAcTQitm8OTGzrznkdBwaeXU=;
        b=phw8igz4jC68Qgxjd59+D0pY+AauORSOotdimOmqJC82KcDGiqPDLxoRKKUnEV53g7
         sYqWgWZBmfln2GAxAowsQbeC0VGjIK9f7CPQkexsdawh9tf/GNSjxxayRCpby5xDssVA
         IL6nJVkdUaWlZIptTVBFBDpyMrdwIO9iARt2A4Jy6qmC6i1pvUNkAjX3bAlKRWrvMHIC
         mHjfBZ9tRXhfKM+nwGSik9k6OSm+nYk62iD2IxQnu96kNtpZPcYVRuvmPR+gS2KBAegC
         W3ORaDhfGk8ooGqvjWgbCuPJ0oY7TxqS4WRTgBvjEJ91jr33CHN/kBLGGSH8VYEYwl4T
         pHJQ==
X-Gm-Message-State: APjAAAWc6Cuo76VeSMQjTyIbqi9tuPX2o1AV2Mrr23Nki+b3NSoz1fm5
        MbA7yEAtEiwF9tJma2JgoPPlzdqw
X-Google-Smtp-Source: APXvYqwrQzOiHkGa9Hd3Rv6MiNtdZYDmjUegHejpeF/BefFYEztTlfkdn/PeR82hiMgcEW+lTJcvqw==
X-Received: by 2002:a5d:6409:: with SMTP id z9mr29856583wru.308.1565644866848;
        Mon, 12 Aug 2019 14:21:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id n14sm209794107wra.75.2019.08.12.14.21.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:21:06 -0700 (PDT)
Subject: [PATCH net-next 3/3] net: phy: let phy_speed_down/up support speeds
 >1Gbps
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
Message-ID: <e6f96369-aa6e-19f3-76af-5e9d6df03aab@gmail.com>
Date:   Mon, 12 Aug 2019 23:20:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far phy_speed_down/up can be used up to 1Gbps only. Remove this
restriction by using new helper __phy_speed_down. New member adv_old
in struct phy_device is used by phy_speed_up to restore the advertised
modes before calling phy_speed_down. Don't simply advertise what is
supported because a user may have intentionally removed modes from
advertisement.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 60 ++++++++++++-------------------------------
 include/linux/phy.h   |  2 ++
 2 files changed, 18 insertions(+), 44 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef7aa738e..f8e68b3b4 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -608,38 +608,21 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
  */
 int phy_speed_down(struct phy_device *phydev, bool sync)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_tmp);
 	int ret;
 
 	if (phydev->autoneg != AUTONEG_ENABLE)
 		return 0;
 
-	linkmode_copy(adv_old, phydev->advertising);
-	linkmode_copy(adv, phydev->lp_advertising);
-	linkmode_and(adv, adv, phydev->supported);
-
-	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, adv) ||
-	    linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, adv)) {
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
-				   phydev->advertising);
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-				   phydev->advertising);
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
-				   phydev->advertising);
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-				   phydev->advertising);
-	} else if (linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
-				     adv) ||
-		   linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-				     adv)) {
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
-				   phydev->advertising);
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-				   phydev->advertising);
-	}
+	linkmode_copy(adv_tmp, phydev->advertising);
+
+	ret = __phy_speed_down(phydev);
+	if (ret)
+		return ret;
 
-	if (linkmode_equal(phydev->advertising, adv_old))
+	linkmode_copy(phydev->adv_old, adv_tmp);
+
+	if (linkmode_equal(phydev->advertising, adv_tmp))
 		return 0;
 
 	ret = phy_config_aneg(phydev);
@@ -658,30 +641,19 @@ EXPORT_SYMBOL_GPL(phy_speed_down);
  */
 int phy_speed_up(struct phy_device *phydev)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(all_speeds) = { 0, };
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(not_speeds);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(speeds);
-
-	linkmode_copy(adv_old, phydev->advertising);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_tmp);
 
 	if (phydev->autoneg != AUTONEG_ENABLE)
 		return 0;
 
-	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, all_speeds);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, all_speeds);
+	if (linkmode_empty(phydev->adv_old))
+		return 0;
 
-	linkmode_andnot(not_speeds, adv_old, all_speeds);
-	linkmode_copy(supported, phydev->supported);
-	linkmode_and(speeds, supported, all_speeds);
-	linkmode_or(phydev->advertising, not_speeds, speeds);
+	linkmode_copy(adv_tmp, phydev->advertising);
+	linkmode_copy(phydev->advertising, phydev->adv_old);
+	linkmode_zero(phydev->adv_old);
 
-	if (linkmode_equal(phydev->advertising, adv_old))
+	if (linkmode_equal(phydev->advertising, adv_tmp))
 		return 0;
 
 	return phy_config_aneg(phydev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 4be6d3b47..3c2be52b1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -403,6 +403,8 @@ struct phy_device {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
+	/* used with phy_speed_down */
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
 
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
-- 
2.22.0


