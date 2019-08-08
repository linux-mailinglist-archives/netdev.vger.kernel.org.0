Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841CF86CE9
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 00:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390463AbfHHWC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 18:02:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34465 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732601AbfHHWC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 18:02:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id e8so4602875wme.1
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 15:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=rzTlI3Vrd1ZuYLtt2BuCT/oY18K8WfhODL+CGXWzREs=;
        b=J9kWoIo9j579k7TirqnaZSy+i6+9+GWnEUXY8GdjovDQWN1fF9mTfFNI5I/2bbu4eJ
         oCIfvssQNnNfNnvFITwbV8qo2C14Hxt3FGivMJPmEOP2EWxVHC3cbnpCLEiN4wYz0UUt
         ndMmtT/h8Lhu4RxCEEdHzE3NvtCWF7njSxYMvIYoC2i1vamfmXODym6pQjJdJtUJoSX3
         uxWjbyijowe7UjluDPq34UqEoR+qAH4ZMNBMH4hHi7MGsVJKRoCVQehTQs4rp3ubWhLD
         2jQtE6Y2K44Tx1zsd2ZeON5nRkcqsKLLVe+iHwtxxlTL4tII9WjBsqts9pyNLGo4M8k/
         tD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=rzTlI3Vrd1ZuYLtt2BuCT/oY18K8WfhODL+CGXWzREs=;
        b=ArwwLHpC0t74BmND8WH7mHb/j67tk/toJUqygoSiWFQSzghtVq/JrG0Q3i01esHgDu
         UOnfuSGNHbWbNFWfMaqVwB1RYlzDFvRXGYFnppaUWvEn6nwQJtt4Ow9/VDzI/YlSqA+Y
         RflGRMpoV4MAndVyVNHATteG6Vwcf1ZIrd47s5prcDcgIP6l2VrdTbB6YbX6tLw/dEZH
         /jsY4zK3RrD2uVXR0QUVYg8gB3QV0EyWQzG/p5IJR0R08D10D8xAU25/xA/U37JeRRXM
         msrFCBDeKs8HD3/w1Rl9e0KkLKhsUQxJHBu7ipvtoheX+WYBK6wcqDt+ag85eFyc+kAN
         Whag==
X-Gm-Message-State: APjAAAVmuweuYWp/nz3Ans5kZqkHIEqG0pGWb8kLQ/oU/0KN7s+KxE0x
        EaGcBsgTAw8ylB2cV+PhHVGW+Fkw
X-Google-Smtp-Source: APXvYqzB9ES+sMFQWBiXTDW2BiWbRle4q4NtSTV3iod0MA5pGdv5BgVKaPrkXhxAAaQz/9ky9V+J2Q==
X-Received: by 2002:a1c:a6cd:: with SMTP id p196mr6702400wme.111.1565301774854;
        Thu, 08 Aug 2019 15:02:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:6862:4959:200d:42a? (p200300EA8F2F320068624959200D042A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:6862:4959:200d:42a])
        by smtp.googlemail.com with ESMTPSA id q20sm20417974wrc.79.2019.08.08.15.02.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 15:02:54 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: fix performance issue on RTL8168evl
Message-ID: <596f91ee-d5bf-52e9-94b6-011c707a15fb@gmail.com>
Date:   Fri, 9 Aug 2019 00:02:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Holger Hoffstätte <holger@applied-asynchrony.com>
Disabling TSO but leaving SG active results is a significant
performance drop. Therefore disable also SG on RTL8168evl.
This restores the original performance.

Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b2a275d85..912bd41ea 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6898,9 +6898,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* RTL8168e-vl has a HW issue with TSO */
 	if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
-		dev->vlan_features &= ~NETIF_F_ALL_TSO;
-		dev->hw_features &= ~NETIF_F_ALL_TSO;
-		dev->features &= ~NETIF_F_ALL_TSO;
+		dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
+		dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
+		dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
 	}
 
 	dev->hw_features |= NETIF_F_RXALL;
-- 
2.22.0

