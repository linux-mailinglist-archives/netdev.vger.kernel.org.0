Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD919202669
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 22:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgFTUlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 16:41:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35462 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbgFTUlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 16:41:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id g21so7767382wmg.0
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 13:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TTLWmjKxAwv8bPTEagfTqrRpYM/B/rTviPHt3e3T88U=;
        b=KFmAXvns4f/sJLcdsavtfQkyuz/cbYWPNVeu+z9myRXK7F4QW7qCW7ig48etKNqL3m
         hVE6c+LIPPL3cj95MlpcM07nzhfrgT3weSU9Chut39dkJ4y/zSaIAEXbiUDTjhY129H5
         bkdtLucscef8jpfmGh5PtThXm8k3XIvjCaRbrNXtRSKS4dVMNNeBv10cQpwhT/oZ2KA6
         Hb6giRrXEGeYNltDVASLpGP/i2/ngRLnuzAQ5yfz2QLIHtFo64bfPSwXuwm6jKJafqwr
         QcEyRKhkECAUdWNpqmWU+ddXsEzC7n6AFmCVfzLoHfjHGArGtWj2c3vkbkBDbUaVCjlU
         eySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TTLWmjKxAwv8bPTEagfTqrRpYM/B/rTviPHt3e3T88U=;
        b=TX7nYCik4JpCnLEXAgxUTOjJJr28FSErzOMQro35OOOIOViJwne240I3dCzC+nFlsy
         kkqFfzeLRrb035WX3BS78hEAr3vN/tev/MhLfclHPTHKtRtM4O+PoI7J8iBaMcCzYcJj
         4V2xKOvMXVbGG2g/IHgsiMdyxFCghBdWZwXqmr3Esmur+Oy5nhaTpAU+MwPInUToV3+o
         gluEV847ppg3jRohIcs6088m68bzzoaPy3dXkFPF8Swnpkr7HRTDd2+PYQJ6tileBlu/
         axcEZut9UwWBhM6dOhYj5Tb7GKZqsGswaxMbuHzk4wjsXw5BT/f9sE8XtGX0xV0LEb4Q
         x3/w==
X-Gm-Message-State: AOAM532QrP3nvi+uxwKYEpjI/BsPnQHeUh0T2Zs1MIt/uiSTDEysRfvG
        JIz7UTtGEsIbb2uiHPHkYYZ3Fncx
X-Google-Smtp-Source: ABdhPJyKgAekm3yWNeOZ5hG6tuZtgWMDgwzlufT/tMBnBbiRNqe6QGauV0VYn7FsYi8KzVVxJbJfyA==
X-Received: by 2002:a1c:b143:: with SMTP id a64mr10749091wmf.133.1592685602152;
        Sat, 20 Jun 2020 13:40:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b4cc:8098:204b:37c5? (p200300ea8f235700b4cc8098204b37c5.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b4cc:8098:204b:37c5])
        by smtp.googlemail.com with ESMTPSA id v11sm1034wmb.3.2020.06.20.13.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 13:40:02 -0700 (PDT)
Subject: [PATCH net-next 2/7] r8169: mark device as not present when in PCI D3
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Message-ID: <b4716dcd-d998-f0bc-22ad-3636ee6b7a56@gmail.com>
Date:   Sat, 20 Jun 2020 22:36:26 +0200
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

Mark the netdevice as detached whenever we go into PCI D3hot.
This allows to remove some checks e.g. from ethtool ops because
dev_ethtool() checks for netif_device_present() in the beginning.

In this context move waking up the queue out of rtl_reset_work()
because in cases where netif_device_attach() is called afterwards
the queue should be woken up by the latter function only.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 25 +++++++++++++----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 98391797b..91e3ada64 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3980,10 +3980,9 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 
 static void rtl_reset_work(struct rtl8169_private *tp)
 {
-	struct net_device *dev = tp->dev;
 	int i;
 
-	netif_stop_queue(dev);
+	netif_stop_queue(tp->dev);
 
 	rtl8169_cleanup(tp, false);
 
@@ -3992,7 +3991,6 @@ static void rtl_reset_work(struct rtl8169_private *tp)
 
 	napi_enable(&tp->napi);
 	rtl_hw_start(tp);
-	netif_wake_queue(dev);
 }
 
 static void rtl8169_tx_timeout(struct net_device *dev, unsigned int txqueue)
@@ -4577,8 +4575,10 @@ static void rtl_task(struct work_struct *work)
 	    !test_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags))
 		goto out_unlock;
 
-	if (test_and_clear_bit(RTL_FLAG_TASK_RESET_PENDING, tp->wk.flags))
+	if (test_and_clear_bit(RTL_FLAG_TASK_RESET_PENDING, tp->wk.flags)) {
 		rtl_reset_work(tp);
+		netif_wake_queue(tp->dev);
+	}
 out_unlock:
 	rtl_unlock_work(tp);
 }
@@ -4823,11 +4823,10 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 
 static void rtl8169_net_suspend(struct rtl8169_private *tp)
 {
-	if (!netif_running(tp->dev))
-		return;
-
 	netif_device_detach(tp->dev);
-	rtl8169_down(tp);
+
+	if (netif_running(tp->dev))
+		rtl8169_down(tp);
 }
 
 #ifdef CONFIG_PM
@@ -4843,8 +4842,6 @@ static int __maybe_unused rtl8169_suspend(struct device *device)
 
 static void __rtl8169_resume(struct rtl8169_private *tp)
 {
-	netif_device_attach(tp->dev);
-
 	rtl_pll_power_up(tp);
 	rtl8169_init_phy(tp);
 
@@ -4866,6 +4863,8 @@ static int __maybe_unused rtl8169_resume(struct device *device)
 	if (netif_running(tp->dev))
 		__rtl8169_resume(tp);
 
+	netif_device_attach(tp->dev);
+
 	return 0;
 }
 
@@ -4873,8 +4872,10 @@ static int rtl8169_runtime_suspend(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
-	if (!tp->TxDescArray)
+	if (!tp->TxDescArray) {
+		netif_device_detach(tp->dev);
 		return 0;
+	}
 
 	rtl_lock_work(tp);
 	__rtl8169_set_wol(tp, WAKE_PHY);
@@ -4898,6 +4899,8 @@ static int rtl8169_runtime_resume(struct device *device)
 	if (tp->TxDescArray)
 		__rtl8169_resume(tp);
 
+	netif_device_attach(tp->dev);
+
 	return 0;
 }
 
-- 
2.27.0


