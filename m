Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECCC5C3B6
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 21:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfGATfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 15:35:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53246 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfGATfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 15:35:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so659674wms.2
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 12:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vDeAxGzEs4/X5RIYjZzZpTnMqHHKkVms3oUY/s4YrB0=;
        b=Di+Ye0iBUr8epx4FHEsUiBf7LvMDOPG/VBlOQ2cR+klmzbOeu8/DG+C3jn970Htn+N
         rqRlil+mDcbwhCxPKaklc/IB0Rpbbm4aCpA10RgSFFVnIGEJZMvKOHuzYQOaQ22hapQ2
         8PQ3Osj2yJllqB9dMxwNfMAbqQvGTeuRXl19mXdYWzizaQ0DCgA+hSRUCSEbD71pf+u6
         /RVNJwNyOZ12h6E67oBcRcpqyQ/cYBmni63vULrwAAOyn2X+alm214W2vXbT1o11Hg7s
         JM+aVAXDX1Udg6zrG4MynPU4sI3FjR6bLDW1q53SjaY3GWicfyGrk25Q6GYmACedbZc1
         pfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vDeAxGzEs4/X5RIYjZzZpTnMqHHKkVms3oUY/s4YrB0=;
        b=Vrojl/O6lzFYUL/WMliG1Z157ng7YD/CWzNN2UW+NIk+JlMG3zzqTVv3N8HOLdqv6/
         eoKC/LmHoTQKRuwywxfD8PHWQXpo80Hwi8hc2u0h4UzyESxJiuMJ5/CjFiPukJqfkOZa
         mLviMlP2hBr093hxPrDXUjjkarpQoeps/NaM8K1upAQ8jJ/KTSHFfe39+5UxCRJVKOzT
         z4nqjJ1NXw+/y0HjEF2sY6r+H4cDn8si0rRDlEJp4lSJji3Tkh+ULXC2kZ5KaFJlbevW
         igXKFNiRMl9ip6gOcP9RWBjeqBPkxAp/UzAnxhyjkl5B6KIRdL4POLUuOt8wfy/J96mf
         6yhg==
X-Gm-Message-State: APjAAAW4y2ibkTWqVGAUDN1dEoaOIm3F/yAeSevRMt+ot9sNHFS/6YCW
        GHvScHNDY1Uk9pdoW9k75tBB2KKA
X-Google-Smtp-Source: APXvYqz18dEy/DbEEPSFVSYja4TE6YVvMCUoCYDcYWbZAKOb5btvV3y8GIudfjcictwOvkJFqRO9WQ==
X-Received: by 2002:a7b:cc97:: with SMTP id p23mr538029wma.120.1562009737196;
        Mon, 01 Jul 2019 12:35:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc? (p200300EA8BD60C008DAC9AD2A34C33BC.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc])
        by smtp.googlemail.com with ESMTPSA id x4sm13120319wrw.14.2019.07.01.12.35.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 12:35:36 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: fix ntohs/htons sparse warnings
Message-ID: <1d1f9dba-1ade-7782-6cc0-3151a7086a4b@gmail.com>
Date:   Mon, 1 Jul 2019 21:35:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse complains about casting to/from restricted __be16. Fix this.

Fixes: 759d09574172 ("r8169: improve handling VLAN tag")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a73f25321..450c74dc1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1528,7 +1528,7 @@ static int rtl8169_set_features(struct net_device *dev,
 static inline u32 rtl8169_tx_vlan_tag(struct sk_buff *skb)
 {
 	return (skb_vlan_tag_present(skb)) ?
-		TxVlanTag | htons(skb_vlan_tag_get(skb)) : 0x00;
+		TxVlanTag | (__force u16)htons(skb_vlan_tag_get(skb)) : 0x00;
 }
 
 static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
@@ -1537,7 +1537,7 @@ static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
 
 	if (opts2 & RxVlanTag)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-				       ntohs(opts2 & 0xffff));
+				       ntohs((__force __be16)(opts2 & 0xffff)));
 }
 
 static void rtl8169_get_regs(struct net_device *dev, struct ethtool_regs *regs,
-- 
2.22.0

