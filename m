Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2205C1E9418
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 00:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgE3WAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 18:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3WAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 18:00:13 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A56EC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:13 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u13so7190360wml.1
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zORDjaE+Zdr/eR99IjMCj3epoIbDCMr2hkEORPAp5U4=;
        b=rGiMqF6+bOIF3hB7bwVDlQYPJlt9yV9Fu9/Ml2fsqLUx8G6asGVCQeBomxTp0tq0WJ
         l9DqIrKXJG/w0brOxvdDMC764337CxbHDwmjW+7X7gsu/hvy5QkBWicqB9MiF7XI77br
         3mSV6uItCXGxmSynmTMInR/eMFHr59uD77nyfCZvOK1kEywsM96Q4DbBf3o+EfAWaDhx
         nsFKhfl4Kp1fi5GZK8qfkgW/OL6IeGlWoSGYEHJvOFVsCjRe6SxU/fTSSnTz43ZjQE8B
         fO5FigN18aa/DcHN98V+/6GqzlCHw626vtJ7OhfZ8jWgc2rZQ6eakioQzlL0r8SdPXBg
         Q+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zORDjaE+Zdr/eR99IjMCj3epoIbDCMr2hkEORPAp5U4=;
        b=VDeCcCK/nR77LUR56QSe7J5BX7lY398pR0+kz7OGOO8loYbt5iSSbN3iQKp9Z1BTxe
         R041AJsIJfqPZxLOUN7+davYRdyTOjLPEB5YIN/NjaXkTltMqlrcxcNeQrjRE7nvHOXE
         qkI2qLn0GN6nOMlnFNzFUrj4vl8tlXTsDuuiKvAB7iujsKIA486bpx7TE7NvNj1rugCc
         amDEdPiX43Ze9DJcGzPX5yDImmDinl1+eQxHyAFbQ0hNEpiUb7U2AwjzC56nyoYsUBPt
         X5mPrlVz1dKi1kynonoSSxb6ZGuI7oGMLF9Awr19NualubC5CnHanSdz9TcMIQG0TlEE
         YAZA==
X-Gm-Message-State: AOAM533lW19t3B4RX4ZudvC40bt84/VO2MuHy0eJ1FZEA/HHWCrxXJX5
        X1j+UwPvDbcji4Q7KDL3b/CNqFBy
X-Google-Smtp-Source: ABdhPJwpRzLpDvtPxU/SH3cqh+ww2V0f4D/80RuYYHMgGv0Py0MHZnOqfkb2Un42OhgdKQkLo65Qkw==
X-Received: by 2002:a1c:5fd4:: with SMTP id t203mr13788639wmb.184.1590876011452;
        Sat, 30 May 2020 15:00:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0? (p200300ea8f2357008c7380e5b6bad8b0.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0])
        by smtp.googlemail.com with ESMTPSA id 37sm15617079wrk.61.2020.05.30.15.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 15:00:11 -0700 (PDT)
Subject: [PATCH net-next 1/6] r8169: change driver data type
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Message-ID: <29eabcd4-fd77-58f8-3091-acc607949e28@gmail.com>
Date:   Sat, 30 May 2020 23:54:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change driver private data type to struct rtl8169_private * to avoid
some overhead.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 60 ++++++++++-------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d672ae77c..810398ef7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4816,15 +4816,13 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	pm_runtime_put_noidle(&pdev->dev);
 }
 
-static void rtl8169_net_suspend(struct net_device *dev)
+static void rtl8169_net_suspend(struct rtl8169_private *tp)
 {
-	struct rtl8169_private *tp = netdev_priv(dev);
-
-	if (!netif_running(dev))
+	if (!netif_running(tp->dev))
 		return;
 
 	phy_stop(tp->phydev);
-	netif_device_detach(dev);
+	netif_device_detach(tp->dev);
 
 	rtl_lock_work(tp);
 	napi_disable(&tp->napi);
@@ -4840,20 +4838,17 @@ static void rtl8169_net_suspend(struct net_device *dev)
 
 static int rtl8169_suspend(struct device *device)
 {
-	struct net_device *dev = dev_get_drvdata(device);
-	struct rtl8169_private *tp = netdev_priv(dev);
+	struct rtl8169_private *tp = dev_get_drvdata(device);
 
-	rtl8169_net_suspend(dev);
+	rtl8169_net_suspend(tp);
 	clk_disable_unprepare(tp->clk);
 
 	return 0;
 }
 
-static void __rtl8169_resume(struct net_device *dev)
+static void __rtl8169_resume(struct rtl8169_private *tp)
 {
-	struct rtl8169_private *tp = netdev_priv(dev);
-
-	netif_device_attach(dev);
+	netif_device_attach(tp->dev);
 
 	rtl_pll_power_up(tp);
 	rtl8169_init_phy(tp);
@@ -4869,23 +4864,21 @@ static void __rtl8169_resume(struct net_device *dev)
 
 static int rtl8169_resume(struct device *device)
 {
-	struct net_device *dev = dev_get_drvdata(device);
-	struct rtl8169_private *tp = netdev_priv(dev);
+	struct rtl8169_private *tp = dev_get_drvdata(device);
 
-	rtl_rar_set(tp, dev->dev_addr);
+	rtl_rar_set(tp, tp->dev->dev_addr);
 
 	clk_prepare_enable(tp->clk);
 
-	if (netif_running(dev))
-		__rtl8169_resume(dev);
+	if (netif_running(tp->dev))
+		__rtl8169_resume(tp);
 
 	return 0;
 }
 
 static int rtl8169_runtime_suspend(struct device *device)
 {
-	struct net_device *dev = dev_get_drvdata(device);
-	struct rtl8169_private *tp = netdev_priv(dev);
+	struct rtl8169_private *tp = dev_get_drvdata(device);
 
 	if (!tp->TxDescArray)
 		return 0;
@@ -4894,7 +4887,7 @@ static int rtl8169_runtime_suspend(struct device *device)
 	__rtl8169_set_wol(tp, WAKE_ANY);
 	rtl_unlock_work(tp);
 
-	rtl8169_net_suspend(dev);
+	rtl8169_net_suspend(tp);
 
 	/* Update counters before going runtime suspend */
 	rtl8169_update_counters(tp);
@@ -4904,10 +4897,9 @@ static int rtl8169_runtime_suspend(struct device *device)
 
 static int rtl8169_runtime_resume(struct device *device)
 {
-	struct net_device *dev = dev_get_drvdata(device);
-	struct rtl8169_private *tp = netdev_priv(dev);
+	struct rtl8169_private *tp = dev_get_drvdata(device);
 
-	rtl_rar_set(tp, dev->dev_addr);
+	rtl_rar_set(tp, tp->dev->dev_addr);
 
 	if (!tp->TxDescArray)
 		return 0;
@@ -4916,16 +4908,16 @@ static int rtl8169_runtime_resume(struct device *device)
 	__rtl8169_set_wol(tp, tp->saved_wolopts);
 	rtl_unlock_work(tp);
 
-	__rtl8169_resume(dev);
+	__rtl8169_resume(tp);
 
 	return 0;
 }
 
 static int rtl8169_runtime_idle(struct device *device)
 {
-	struct net_device *dev = dev_get_drvdata(device);
+	struct rtl8169_private *tp = dev_get_drvdata(device);
 
-	if (!netif_running(dev) || !netif_carrier_ok(dev))
+	if (!netif_running(tp->dev) || !netif_carrier_ok(tp->dev))
 		pm_schedule_suspend(device, 10000);
 
 	return -EBUSY;
@@ -4970,13 +4962,12 @@ static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
 
 static void rtl_shutdown(struct pci_dev *pdev)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct rtl8169_private *tp = netdev_priv(dev);
+	struct rtl8169_private *tp = pci_get_drvdata(pdev);
 
-	rtl8169_net_suspend(dev);
+	rtl8169_net_suspend(tp);
 
 	/* Restore original MAC address */
-	rtl_rar_set(tp, dev->perm_addr);
+	rtl_rar_set(tp, tp->dev->perm_addr);
 
 	rtl8169_hw_reset(tp);
 
@@ -4993,13 +4984,12 @@ static void rtl_shutdown(struct pci_dev *pdev)
 
 static void rtl_remove_one(struct pci_dev *pdev)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct rtl8169_private *tp = netdev_priv(dev);
+	struct rtl8169_private *tp = pci_get_drvdata(pdev);
 
 	if (pci_dev_run_wake(pdev))
 		pm_runtime_get_noresume(&pdev->dev);
 
-	unregister_netdev(dev);
+	unregister_netdev(tp->dev);
 
 	if (r8168_check_dash(tp))
 		rtl8168_driver_stop(tp);
@@ -5007,7 +4997,7 @@ static void rtl_remove_one(struct pci_dev *pdev)
 	rtl_release_firmware(tp);
 
 	/* restore original MAC address */
-	rtl_rar_set(tp, dev->perm_addr);
+	rtl_rar_set(tp, tp->dev->perm_addr);
 }
 
 static const struct net_device_ops rtl_netdev_ops = {
@@ -5446,7 +5436,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!tp->counters)
 		return -ENOMEM;
 
-	pci_set_drvdata(pdev, dev);
+	pci_set_drvdata(pdev, tp);
 
 	rc = r8169_mdio_register(tp);
 	if (rc)
-- 
2.26.2


