Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3F31D8914
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgERUWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgERUWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:22:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0545EC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 13:22:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h17so13319183wrc.8
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 13:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=N5fj+6WnQjALg/MListk7E4v5qcQEXyRBDCOGUUogNc=;
        b=Jjjo9XEobITCraYba+IWfvbwcW67uOZmAs4ruGi3ulx51yY1HXdBKtixadw1xZ03ll
         OIwEDSOWj16cz42lZmNVTDY5HyM3ftB29zZvidLJdx/A5iAbpnbzVAPH1/t3mmo7dKcM
         zghOffJPZ6aGSUxQRps8MLOSUwOsZkXzXHPjf1xLijUcX9J6SW3FVs11p1FeLbWhK5bi
         E8B09IxE7DCgvgOrktyfp5duJa/B8m9ov5y9VCO9D8t08xAW7eOjHrniGOh4MROol/o8
         6K3RjT/GeoZwBcYE0wIZOughg7t4ZM/+zZB8Q3rbieylZZpX9hP6rdn6ifzYFqaJJVZ3
         WzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=N5fj+6WnQjALg/MListk7E4v5qcQEXyRBDCOGUUogNc=;
        b=BuHBOSNRYXcgciVVUhpSwR/QMrZJd+KT1gJRo0retgsFiRuzmmcujotGM6wZ0Y1tnu
         catyj6QAYY6ElcC4/rZhiT/xHrMPnQZqcOu10MftcHAflmlWY1jrikuwNGeIyT5L2S8R
         D0vXv9+kB7IFY+9EbBWfiZ7ewkF3/YvMbzesoyYOsHuKCGvjUpaQBDOBQZukBqh8zhm7
         ITUL5hlCBUkwnYQQFf7A20E8ba+AAJ2sc4ZPnx9maesE7XoHBU8+oP7zSBPSeQHpJT9h
         Bf37sZuxOuB/OyeTyHut1JznC9+gQeLcaBzD2/vXsAA/H1vdFXdQNrk9zCdPzfcDZQOr
         3G5Q==
X-Gm-Message-State: AOAM531OePJiHfe4vW4Y41/OqQJPvjhcbWEyxE9cK4oujmvr1O95fZw0
        BZKyKaFjhXvAHyF0o+cKnWjzV+nW
X-Google-Smtp-Source: ABdhPJyAgWbVs8//zGF6VtGxf4I0vuNrg+ulNx4Scn4hn9gp0AoBayDM5O2r3zwFycqKD0Hcq3BI3g==
X-Received: by 2002:adf:82b6:: with SMTP id 51mr21773409wrc.102.1589833343402;
        Mon, 18 May 2020 13:22:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:9de0:f30c:fd06:315c? (p200300ea8f2852009de0f30cfd06315c.dip0.t-ipconnect.de. [2003:ea:8f28:5200:9de0:f30c:fd06:315c])
        by smtp.googlemail.com with ESMTPSA id f127sm881399wmf.17.2020.05.18.13.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 13:22:22 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve rtl8169_mark_to_asic
Message-ID: <25184433-dca6-f43f-ccc5-daf0ed0f17ee@gmail.com>
Date:   Mon, 18 May 2020 22:22:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the compiler decide about inlining, and as confirmed by Eric it's
better to use WRITE_ONCE here to ensure that the descriptor ownership
is transferred to NIC immediately.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e887ee1e3..23f150092 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3824,15 +3824,14 @@ static int rtl8169_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
+static void rtl8169_mark_to_asic(struct RxDesc *desc)
 {
 	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
 
 	desc->opts2 = 0;
 	/* Force memory writes to complete before releasing descriptor */
 	dma_wmb();
-
-	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
+	WRITE_ONCE(desc->opts1, cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE));
 }
 
 static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
-- 
2.26.2

