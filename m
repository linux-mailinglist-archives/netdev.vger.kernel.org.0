Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF4820266A
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 22:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgFTUlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 16:41:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54637 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgFTUlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 16:41:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id g10so11481967wmh.4
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 13:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8if5VLVE23rut99roRfvFWvyMrVo4niv27CJf48eOLI=;
        b=sCBjb/a9/W/v2AadejfBLClKKv50dfofYjKGHoujotic9e3ZxLwxodZt4iH6qHXfqE
         eoIP3dxIKnnv5rd2r8H5p0iMIpAA68tjlq51VGTUuqOfuIfndpQspuxiZYmCrx4Fy4h+
         OTX0nWeth1SVYiEPrlgK5wurxRWyVSNw6AlRVJoxXEBtbraCNeO+rFhfX/JcB5ShYZbC
         +RqdVqv+pr4HgUs3dbWDRtzULIciMU/DpVpf6nxWrxnvF1BRZQJ4PZMFZ+FdX4Zm2Gvo
         wyCAc1CrfF56XYeVEQB9JLafv1OIDgRGJYBbsjwqBnG7wjGSXOv3s8nE03toyoad7bbR
         VDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8if5VLVE23rut99roRfvFWvyMrVo4niv27CJf48eOLI=;
        b=jTJMwje7WYdJGhqdM2YJRVA3OedaaMeTeI8x24ZSNV8AkLi5r+Sl8RSJp+M0+ZRGMJ
         gnPFE6AlAef/uOhTeX2rT9vXOegEWBGx/z0h4gOsMWScD3nPusvEeSzkcfZO+sq0HqIm
         3RYpugAgm94H7aIq7a7pBrA7LKaARWVtl1u2cJ8MWmR/gB0hlT6gy6ZR/+igIq5Ng7JT
         WGSUrBZxFemA4ctOb8Fbb/BH0+Dq+waLUwntHtSG30yPmDWQxIT+RJH6s6FxZSpY2enB
         +8xsw2/TM0YrP5CbBPRWKWlqPCIzfCuT9MxCMf9eXPjCbjx26PT74Qh4Tsl6dbEffTUe
         d50Q==
X-Gm-Message-State: AOAM532zLEf51CQVy5eOLIAp5T8JOEI52pObiy/cKnLMBfKgZ8bRboP0
        1KlVpKvZ9kdQOJUm+h71/O89mtO8
X-Google-Smtp-Source: ABdhPJz280oQgjUhNR2O6VG9bUQKuKdG/d5xGTrFSBw6QbQqLBg2KVwVK+3Qql1aZoj4Vl1qtoy56Q==
X-Received: by 2002:a7b:c3c6:: with SMTP id t6mr9766614wmj.159.1592685603188;
        Sat, 20 Jun 2020 13:40:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b4cc:8098:204b:37c5? (p200300ea8f235700b4cc8098204b37c5.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b4cc:8098:204b:37c5])
        by smtp.googlemail.com with ESMTPSA id y7sm6730868wrt.11.2020.06.20.13.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 13:40:02 -0700 (PDT)
Subject: [PATCH net-next 3/7] r8169: remove no longer needed checks for device
 being runtime-active
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Message-ID: <890dcd83-26df-1e85-3ab3-ec5d650fa3b4@gmail.com>
Date:   Sat, 20 Jun 2020 22:37:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because the netdevice is marked as detached now when parent is not
accessible we can remove quite some checks.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 54 +++--------------------
 1 file changed, 6 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 91e3ada64..c8e0f2bb5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1422,24 +1422,17 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
-	struct device *d = tp_to_dev(tp);
 
 	if (wol->wolopts & ~WAKE_ANY)
 		return -EINVAL;
 
-	pm_runtime_get_noresume(d);
-
 	rtl_lock_work(tp);
 
 	tp->saved_wolopts = wol->wolopts;
-
-	if (pm_runtime_active(d))
-		__rtl8169_set_wol(tp, tp->saved_wolopts);
+	__rtl8169_set_wol(tp, tp->saved_wolopts);
 
 	rtl_unlock_work(tp);
 
-	pm_runtime_put_noidle(d);
-
 	return 0;
 }
 
@@ -1657,17 +1650,10 @@ static void rtl8169_get_ethtool_stats(struct net_device *dev,
 				      struct ethtool_stats *stats, u64 *data)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
-	struct device *d = tp_to_dev(tp);
-	struct rtl8169_counters *counters = tp->counters;
-
-	ASSERT_RTNL();
-
-	pm_runtime_get_noresume(d);
-
-	if (pm_runtime_active(d))
-		rtl8169_update_counters(tp);
+	struct rtl8169_counters *counters;
 
-	pm_runtime_put_noidle(d);
+	counters = tp->counters;
+	rtl8169_update_counters(tp);
 
 	data[0] = le64_to_cpu(counters->tx_packets);
 	data[1] = le64_to_cpu(counters->rx_packets);
@@ -1899,48 +1885,26 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 static int rtl8169_get_eee(struct net_device *dev, struct ethtool_eee *data)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
-	struct device *d = tp_to_dev(tp);
-	int ret;
 
 	if (!rtl_supports_eee(tp))
 		return -EOPNOTSUPP;
 
-	pm_runtime_get_noresume(d);
-
-	if (!pm_runtime_active(d)) {
-		ret = -EOPNOTSUPP;
-	} else {
-		ret = phy_ethtool_get_eee(tp->phydev, data);
-	}
-
-	pm_runtime_put_noidle(d);
-
-	return ret;
+	return phy_ethtool_get_eee(tp->phydev, data);
 }
 
 static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
-	struct device *d = tp_to_dev(tp);
 	int ret;
 
 	if (!rtl_supports_eee(tp))
 		return -EOPNOTSUPP;
 
-	pm_runtime_get_noresume(d);
-
-	if (!pm_runtime_active(d)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
 	ret = phy_ethtool_set_eee(tp->phydev, data);
 
 	if (!ret)
 		tp->eee_adv = phy_read_mmd(dev->phydev, MDIO_MMD_AN,
 					   MDIO_AN_EEE_ADV);
-out:
-	pm_runtime_put_noidle(d);
 	return ret;
 }
 
@@ -2222,19 +2186,13 @@ static void rtl_rar_set(struct rtl8169_private *tp, u8 *addr)
 static int rtl_set_mac_address(struct net_device *dev, void *p)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
-	struct device *d = tp_to_dev(tp);
 	int ret;
 
 	ret = eth_mac_addr(dev, p);
 	if (ret)
 		return ret;
 
-	pm_runtime_get_noresume(d);
-
-	if (pm_runtime_active(d))
-		rtl_rar_set(tp, dev->dev_addr);
-
-	pm_runtime_put_noidle(d);
+	rtl_rar_set(tp, dev->dev_addr);
 
 	return 0;
 }
-- 
2.27.0


