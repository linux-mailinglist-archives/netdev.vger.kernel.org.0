Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8271817C89B
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 23:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgCFW7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 17:59:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42564 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgCFW7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 17:59:13 -0500
Received: by mail-wr1-f68.google.com with SMTP id v11so4170385wrm.9
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 14:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pvw0hXL8WaZ1fs8oj0rrpDhVpTtZCr7I8Chl+KEQDEk=;
        b=n+r1xzpYbo90uXjrWGJZkFUVTc0Uq66bSkKwHsD7uNPiPe2TM+FlU6EPP3YAuJW4sU
         fbnRTDvp4JawwRihATj6FmiNggdHt3Vw8zu5E0TmhRx0jH50nwc81Cc5lWOi+ZTYL7xQ
         UaZiTStvFM89yWv60oC31bbJ1Mmk+Y8mPk8u7u+rAE711Dssu4EXN86qqXXNcemP9PF6
         KRQWxj11fLl+JVxfFqIjNnQ4tvB2ahft50WKted6UOJV9lu+QArjaKgpWGV1Fw9ho6Dw
         n5NADubailQmDDaxkAMudcX+xLg1U97GU3NxKhp4BMrlbkkpyg4NfUew4f98APCZM7W3
         lORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pvw0hXL8WaZ1fs8oj0rrpDhVpTtZCr7I8Chl+KEQDEk=;
        b=PLjGTBRHiElsgx8aY7eApUtU87yuM6jXkplSakFr4SgUdvOHDT7Mzr4vrQXi4LLHf6
         EybWosQR5EkTYZ9R0u/Z59d/H/eJR8Y4YzQTcijugBv7wo8+y2S53o9hQJ2pjR4NzkcK
         P7vgTrA84pM607n/GHugeXKsDfMdRNrYxvKmXn6rrjVMc1t90npwy4qHy9QfJnuIEGzz
         YcUm6SQ61SAe0LxZNyhn0p6ie4vtTECEdJ7OIX49dtA7hcQB4/ydxydMwiwYRAZIE4UY
         RqI4lDMlxOZiUsCSs7jCSgOup1SdVUlxsee+oaMlSW6gjsEdEkz7vBQGMwoI3ZwkAkos
         x5rg==
X-Gm-Message-State: ANhLgQ1hDWaxBpMV0HwqqmxcZ6t8UoavOYjTpf25zv2z8S6g78hKOk6g
        tPrV8Lxg990iu+2oGQ4qbfTNBX5w
X-Google-Smtp-Source: ADFU+vuYel+woegYY4mANgX9Pz/XlNnSMWYXmOdbFKNNerCFCWRfPSQOXags6J0Wdw5Ukk61PnIfPw==
X-Received: by 2002:adf:fe89:: with SMTP id l9mr5934427wrr.373.1583535551866;
        Fri, 06 Mar 2020 14:59:11 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1447:bded:797c:45a5? (p200300EA8F2960001447BDED797C45A5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1447:bded:797c:45a5])
        by smtp.googlemail.com with ESMTPSA id n14sm6639412wrs.97.2020.03.06.14.59.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 14:59:11 -0800 (PST)
Subject: [PATCH net-next 1/4] r8169: convert while to for loop in rtl_tx
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
Message-ID: <9d9d812a-5d21-42de-04e8-adbae25ef194@gmail.com>
Date:   Fri, 6 Mar 2020 23:54:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slightly improve the code by converting this while to a for loop.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4495a3cf9..c0999efa0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4392,9 +4392,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 	dirty_tx = tp->dirty_tx;
 	smp_rmb();
-	tx_left = tp->cur_tx - dirty_tx;
 
-	while (tx_left > 0) {
+	for (tx_left = tp->cur_tx - dirty_tx; tx_left > 0; tx_left--) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		struct ring_info *tx_skb = tp->tx_skb + entry;
 		u32 status;
@@ -4418,7 +4417,6 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 			tx_skb->skb = NULL;
 		}
 		dirty_tx++;
-		tx_left--;
 	}
 
 	if (tp->dirty_tx != dirty_tx) {
-- 
2.25.1


