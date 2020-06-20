Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71F920266B
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 22:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgFTUlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 16:41:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35994 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbgFTUlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 16:41:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id k6so490028wrn.3
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 13:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qv76KDmBqfD0rp4FDfAP06h705PU7V5OkYcrdIsdhwQ=;
        b=dtVYkQADZvlbCKjj8qI0LFB6eo2H10wrB7mFVIaZtaBliGRJLp5V9gAshIWzhoFuk6
         sC2iWxUvUCD12VDhzH2nedV3D6lJEg369TZIYwyq0iShmGfthp5MUgmiX4D5IkPhShoX
         T7OTHMaVnqnUhp8QGLIRpuo6O2DmkK2+3CH9xYFnBEmytKyNC6/PCOyrWidqtg9J4n+H
         9tTT/NToVHLTVjX2Kq79dKtJJGF2MWgzDLnW8Fr5N6PXpDpJkBIdU+5KGqinlrOJgVc5
         RCRg/CEXilBNAY7vMZjU/TF8p/uhm7kcLtPN5HfLw1SVf9dDJNJ6/1kXOoPUog7brQOg
         byew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qv76KDmBqfD0rp4FDfAP06h705PU7V5OkYcrdIsdhwQ=;
        b=UGtzUHfA4GCoevzjer9arJawCcqko+KiMCfVxS7TzhSaR2XWcdpTqGD97MNABhlYTN
         2xYbuLUKWjNNVZB1r14S+9vioSKT+ezqM+RcnDroHQ4v9m80Osr4Bj27QtpCOUDRwSWF
         OG+plIF2RjRfMchILIUrMOUQrLkoY1xcN0P5GO5V3phfx4mc6uSIY4kUSdNNHvWo69vF
         RC/WSw7R2UBJyVOwO4svp8qDDClErp0rU8SNJQLFE+Rjwz/JDcuJ6bkqV41yTSHJCem0
         sEGwShsUVIsBxxCdAxU73hSzpXxUv3RQkQDFmZsVXMiLZExzp06ya4u6piiVFqxbeHu9
         upyQ==
X-Gm-Message-State: AOAM531K6WJklyev1iJJlDp0Wltxd6IBFWOqKJsz5YsZGh8JULFufRbK
        cpfPMg34TzuGd/4wVpsOl9JUgMam
X-Google-Smtp-Source: ABdhPJwzMOxohSIPacIaItRIwDku2rxtbg4DSUdkdpBn+V/+SsDnFwfyNaEcL12ZrkIlT1bDs7ESjA==
X-Received: by 2002:a5d:4d0d:: with SMTP id z13mr11233722wrt.220.1592685604140;
        Sat, 20 Jun 2020 13:40:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b4cc:8098:204b:37c5? (p200300ea8f235700b4cc8098204b37c5.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b4cc:8098:204b:37c5])
        by smtp.googlemail.com with ESMTPSA id f11sm11723687wrj.2.2020.06.20.13.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 13:40:03 -0700 (PDT)
Subject: [PATCH net-next 4/7] r8169: add rtl8169_up
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Message-ID: <47d5eb6f-08f0-a538-794b-8ac43743678f@gmail.com>
Date:   Sat, 20 Jun 2020 22:37:50 +0200
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

Factor out bringing device up to a new function rtl8169_up(), similar
to rtl8169_down() for bringing the device down.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 48 ++++++++---------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c8e0f2bb5..2414df29c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4616,6 +4616,19 @@ static void rtl8169_down(struct rtl8169_private *tp)
 	rtl_unlock_work(tp);
 }
 
+static void rtl8169_up(struct rtl8169_private *tp)
+{
+	rtl_lock_work(tp);
+	rtl_pll_power_up(tp);
+	rtl8169_init_phy(tp);
+	napi_enable(&tp->napi);
+	set_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags);
+	rtl_reset_work(tp);
+
+	phy_start(tp->phydev);
+	rtl_unlock_work(tp);
+}
+
 static int rtl8169_close(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -4691,25 +4704,10 @@ static int rtl_open(struct net_device *dev)
 	if (retval)
 		goto err_free_irq;
 
-	rtl_lock_work(tp);
-
-	set_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags);
-
-	napi_enable(&tp->napi);
-
-	rtl8169_init_phy(tp);
-
-	rtl_pll_power_up(tp);
-
-	rtl_hw_start(tp);
-
+	rtl8169_up(tp);
 	rtl8169_init_counter_offsets(tp);
-
-	phy_start(tp->phydev);
 	netif_start_queue(dev);
 
-	rtl_unlock_work(tp);
-
 	pm_runtime_put_sync(&pdev->dev);
 out:
 	return retval;
@@ -4798,20 +4796,6 @@ static int __maybe_unused rtl8169_suspend(struct device *device)
 	return 0;
 }
 
-static void __rtl8169_resume(struct rtl8169_private *tp)
-{
-	rtl_pll_power_up(tp);
-	rtl8169_init_phy(tp);
-
-	phy_start(tp->phydev);
-
-	rtl_lock_work(tp);
-	napi_enable(&tp->napi);
-	set_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags);
-	rtl_reset_work(tp);
-	rtl_unlock_work(tp);
-}
-
 static int __maybe_unused rtl8169_resume(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
@@ -4819,7 +4803,7 @@ static int __maybe_unused rtl8169_resume(struct device *device)
 	rtl_rar_set(tp, tp->dev->dev_addr);
 
 	if (netif_running(tp->dev))
-		__rtl8169_resume(tp);
+		rtl8169_up(tp);
 
 	netif_device_attach(tp->dev);
 
@@ -4855,7 +4839,7 @@ static int rtl8169_runtime_resume(struct device *device)
 	rtl_unlock_work(tp);
 
 	if (tp->TxDescArray)
-		__rtl8169_resume(tp);
+		rtl8169_up(tp);
 
 	netif_device_attach(tp->dev);
 
-- 
2.27.0


