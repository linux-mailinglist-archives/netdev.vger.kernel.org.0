Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDDA2F2A05
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405418AbhALI30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405405AbhALI30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:29:26 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81444C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:28:45 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 190so1106570wmz.0
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l0azDAxFxfqdbj7nWlyJ2wSq6xWvCEoOtEgYv1pxqRw=;
        b=bJ1+MXu2A+uIDlRmoihGslRkuOAtdf5LpKh5Fl9fYyP6ER8IKwff6OU557nyFnpo3C
         r+Q/Y9N8bBySFfDqUXUOI9yexE3fU4u50LVxSRdnhFB8nwsJeoxLhU/2oO8ur7wUlcvN
         uazLVIsSrygxYpWVTyDB0ezWzE8KSO8sdjpE9/lmrmUMSwaEV1xOjiZfsg5QKCnGnSNC
         G33KYTQX7P9O8V04LXmFgl1AmICL07uqFXRbOK/1jyWqhLtx5WZ3ZAnAXaZQauvlWojH
         92/qRfE2k21dMobqJEK7ghBc3BDXLSFsI6QdGcREDnPPbuJvBhJG6nype6Ps4YYtwvP5
         369g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l0azDAxFxfqdbj7nWlyJ2wSq6xWvCEoOtEgYv1pxqRw=;
        b=OeCHO9NYVEUF2BceQvPQGr1w4mNcuC/uZ2++7sx0Sg24hJGmuLYYOopGmQdpykxWK4
         Z1lEdQbjt44RCQ7ykt8+jxjwkrbKxt9TvZvlgUeNPxk75ymbXRcSP0AL3yN7HJQAts+I
         0GvTM32UDjZU4B5HqFmquDMLCk9KF5b/0nKvFTpUzsrTkd24coaRI8yotApMS7hzvNE7
         dxcdtZ4dZxFQJoHFSw4ig5eGb3cNww4rcmezBQFPYgyno8bEJ48a5YrWiu/LgDPOTBdV
         qdS/pyrXAfl4M8IhCBguBty/VP57HfI4kGXuccHhQzrBWgNhEbN0iGbAyH4i7w0lbd3j
         UbGw==
X-Gm-Message-State: AOAM530Qo5Qkl9cKIK2IyP19F7Q2BavVwpYbg1mPKvf1HI/ke8helX0W
        y3lqivuKFK94SHGtwTQ3S3a9CGMgrtM=
X-Google-Smtp-Source: ABdhPJxecei1syp/iGzMLtJDltbOz43kwiQi0v3hWJyGCPzfZnGwmj6kBKkcAXoGCbUPE/JmmuOGBA==
X-Received: by 2002:a1c:4e19:: with SMTP id g25mr2359021wmh.93.1610440124091;
        Tue, 12 Jan 2021 00:28:44 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:d420:a714:6def:4af7? (p200300ea8f065500d420a7146def4af7.dip0.t-ipconnect.de. [2003:ea:8f06:5500:d420:a714:6def:4af7])
        by smtp.googlemail.com with ESMTPSA id h13sm3609582wrm.28.2021.01.12.00.28.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 00:28:43 -0800 (PST)
Subject: [PATCH net-next 1/3] r8169: align rtl_wol_suspend_quirk with vendor
 driver and rename it
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
Message-ID: <f9e7121d-90bc-bfca-3987-c12e68bd9ddc@gmail.com>
Date:   Tue, 12 Jan 2021 09:28:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At least from chip version 25 the vendor driver sets these rx flags
for all chip versions if WOL is enabled. Therefore I wouldn't consider
it a quirk, so let's rename the function.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 33336098b..84f488d1c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2210,23 +2210,11 @@ static int rtl_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
+static void rtl_wol_enable_rx(struct rtl8169_private *tp)
 {
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_25:
-	case RTL_GIGA_MAC_VER_26:
-	case RTL_GIGA_MAC_VER_29:
-	case RTL_GIGA_MAC_VER_30:
-	case RTL_GIGA_MAC_VER_32:
-	case RTL_GIGA_MAC_VER_33:
-	case RTL_GIGA_MAC_VER_34:
-	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_63:
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
 		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
 			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
-		break;
-	default:
-		break;
-	}
 }
 
 static void rtl_prepare_power_down(struct rtl8169_private *tp)
@@ -2240,7 +2228,7 @@ static void rtl_prepare_power_down(struct rtl8169_private *tp)
 
 	if (device_may_wakeup(tp_to_dev(tp))) {
 		phy_speed_down(tp->phydev, false);
-		rtl_wol_suspend_quirk(tp);
+		rtl_wol_enable_rx(tp);
 	}
 }
 
@@ -4872,7 +4860,7 @@ static void rtl_shutdown(struct pci_dev *pdev)
 
 	if (system_state == SYSTEM_POWER_OFF) {
 		if (tp->saved_wolopts) {
-			rtl_wol_suspend_quirk(tp);
+			rtl_wol_enable_rx(tp);
 			rtl_wol_shutdown_quirk(tp);
 		}
 
-- 
2.30.0


