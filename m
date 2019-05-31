Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9531313A1
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfEaRR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:17:27 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40116 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfEaRR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:17:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so2172396wre.7
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=3uADWNEAdQpz3fj8EGD9x+Ed7yCqNkbq7KB/9b+Ha3s=;
        b=M6KN3GLcumZti64ZhBdlFg7vTEss3YKy19ntHF/xeR1AGb768adIWhp7MKuigBzT1Y
         OQvXT+cva/8WQDi8naLrpfcZLKDI/X3b97mV1ycutMaDxpx0KL7owJN8ynUc/X5Ah3sX
         +gkgWc8VKkcHXv+se5vR6s5xYlDhOn/qwral9ZmQPnmrTjDslx/tyZuZw+100y45de5P
         5K19sAJtZKoO0UP62X1yf+9lsf9h2bclAVwwlWhwXtrgK885285A8PU4TcR8ZfTRNUkQ
         Pzg9VlhV8G6sOBHkc7ydC9NPxePJZh0FhyRNaFP1+n+twwjyaWjsjJuLTGkHM4z2pGRr
         aPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=3uADWNEAdQpz3fj8EGD9x+Ed7yCqNkbq7KB/9b+Ha3s=;
        b=Q6XmiiX6mUEvF5q4T9Dbb1ZfseCcbGxmjGt+INSQW1syYzWpGA4BTskXIYGOpDPPwn
         ERSInzFMep+lsG0L+UrVJpdWWsVm+jUr+JaTh2tyOu0q5MGUqQiQV/wmdgMNwBdWmduh
         40e3TC2AvqXg0bxrCI0EVsDyZW8CeeHADZd9BQcDANprLtt2DGZBoy5AoE/GSvi9ZDaw
         VYTkUFLr/j2KNuv4XJmO1aWiIuGyKBOdizyJp4nXSnjX8rVNOAwOczuisLJQocSbF1kW
         hNqU/LTuf2hBs307+7QME1CGggy/crQ6soXkk/X1Vm5LDa7ZZENGDRysTaZU48SNdyjr
         AnDw==
X-Gm-Message-State: APjAAAV4cZ904oKVUred/MJfWb7aMbY5FYs+ZZOB4vUutLqMfbe12Hz4
        VgVY/0EBFeIzGZBo5AiXrrvYyh9W
X-Google-Smtp-Source: APXvYqzc8f/wJ0CbxzIPpRobwow0A1cf6G5qxBLZ6+doAxVt5uUr05G3tVJpkG+NvwFjvUcwuLahWw==
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr7392936wrw.0.1559323044658;
        Fri, 31 May 2019 10:17:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce? (p200300EA8BF3BD0020267A0B4D8DD1CE.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce])
        by smtp.googlemail.com with ESMTPSA id p10sm7506370wrw.6.2019.05.31.10.17.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 10:17:23 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve r8169_csum_workaround
Message-ID: <5cf7212e-fccd-9d2d-3c7a-2c6f76abbc13@gmail.com>
Date:   Fri, 31 May 2019 19:17:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use helper skb_is_gso() and simplify access to tx_dropped.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 12dab52ee..2705eb510 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5727,7 +5727,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 static void r8169_csum_workaround(struct rtl8169_private *tp,
 				  struct sk_buff *skb)
 {
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		netdev_features_t features = tp->dev->features;
 		struct sk_buff *segs, *nskb;
 
@@ -5750,11 +5750,8 @@ static void r8169_csum_workaround(struct rtl8169_private *tp,
 
 		rtl8169_start_xmit(skb, tp->dev);
 	} else {
-		struct net_device_stats *stats;
-
 drop:
-		stats = &tp->dev->stats;
-		stats->tx_dropped++;
+		tp->dev->stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
 	}
 }
-- 
2.21.0

