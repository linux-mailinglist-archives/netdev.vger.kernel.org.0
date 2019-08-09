Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0B288455
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfHIU7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:59:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35689 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfHIU7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:59:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id k2so13543349wrq.2
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 13:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=yo998kb5Ra1n4Wwcy/TOsxrtGjO7A7kU/VrPCxH9lOg=;
        b=n+4DQKXOclkHc1O1gbhjpzkHRN/O1H+yGIUsteq6gn4TmxiPpuvCp9la7WvO4o2NTD
         Y376+BLAVh/rwp/bSPFBMJuzXeJ8bPKVO+mSWesIy9f31D+qwTEMrJEgmejQCnfP7UJQ
         70vybUgiHf7qHm+VRzyqEfkUvthdYGWGXErGwbH3i++KAB4nT8lCGNKlQfj0Cu5h8SYf
         EqkfssCKQJuGWGHDf4f+vcg0H5Ij2A1xk99KVXKeFA90gyQTcyFg2zIxq2AQkj32x8zB
         hbkR0WQlF7qdzETMsDe0+8lEVWovmvX09S8Tk52MSrdWMOS7FpCWooPVvJdTpfh5b6UG
         8+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=yo998kb5Ra1n4Wwcy/TOsxrtGjO7A7kU/VrPCxH9lOg=;
        b=j0AmWm0U5+0yhiX86Xk1tun6Iq0lNrItR6DeVmUiv6nmecmVs/JYqpSOuojJ8v5IYD
         fYEt4zhvdYXJkSJQPawT/1ECJkQz1PrHFy+su/KRzYJ7S98NuY3LG8KXSRCnH/caq87i
         L7gXzLUSFauHPqGRU6pVxsNOZ8dUJ/bE+ccAfkmrknbhf/CX0D51upHTDMfDsSAsf5Of
         gRdNyUmIT0EqfZEqw1oGvi9GDnlmpHiOWQmraGPrhc9Lc2KqNxrwPdMurU4LL5bquLxT
         THgGTV4nPkL57RggnhrKW5Y1Vv4uP9TP+sCbqJXLyf0xor3tNRUcKAY1MtrvRcAe6BpP
         MOkg==
X-Gm-Message-State: APjAAAXitrknHEXoNr4t3tRsIo0UoFJuqzbcqeansdDTulltiMhxWruC
        jYTBfNlUIe77Lp+k5FRnpEfx5rfW
X-Google-Smtp-Source: APXvYqztE8zvqnT6Mv5fwBnTfqaKEdLmrmBVJbbWFy+QQtvxKK1o3fGSZAdLTTwVDZzVo2MISbe9mg==
X-Received: by 2002:a5d:60c5:: with SMTP id x5mr26075634wrt.253.1565384357962;
        Fri, 09 Aug 2019 13:59:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id i30sm5415424wmb.20.2019.08.09.13.59.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 13:59:17 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: inline rtl8169_free_rx_databuff
Message-ID: <e0902cae-4557-dcda-9c96-ad19b3c05993@gmail.com>
Date:   Fri, 9 Aug 2019 22:59:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8169_free_rx_databuff is used in only one place, so let's inline it.
We can improve the loop because rtl8169_init_ring zero's RX_databuff
before calling rtl8169_rx_fill, and rtl8169_rx_fill fills
Rx_databuff starting from index 0.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 24 +++++++----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b2a275d85..641a34942 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5260,18 +5260,6 @@ static inline void rtl8169_make_unusable_by_asic(struct RxDesc *desc)
 	desc->opts1 &= ~cpu_to_le32(DescOwn | RsvdMask);
 }
 
-static void rtl8169_free_rx_databuff(struct rtl8169_private *tp,
-				     struct page **data_buff,
-				     struct RxDesc *desc)
-{
-	dma_unmap_page(tp_to_dev(tp), le64_to_cpu(desc->addr),
-		       R8169_RX_BUF_SIZE, DMA_FROM_DEVICE);
-
-	__free_pages(*data_buff, get_order(R8169_RX_BUF_SIZE));
-	*data_buff = NULL;
-	rtl8169_make_unusable_by_asic(desc);
-}
-
 static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
 {
 	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
@@ -5312,11 +5300,13 @@ static void rtl8169_rx_clear(struct rtl8169_private *tp)
 {
 	unsigned int i;
 
-	for (i = 0; i < NUM_RX_DESC; i++) {
-		if (tp->Rx_databuff[i]) {
-			rtl8169_free_rx_databuff(tp, tp->Rx_databuff + i,
-					    tp->RxDescArray + i);
-		}
+	for (i = 0; i < NUM_RX_DESC && tp->Rx_databuff[i]; i++) {
+		dma_unmap_page(tp_to_dev(tp),
+			       le64_to_cpu(tp->RxDescArray[i].addr),
+			       R8169_RX_BUF_SIZE, DMA_FROM_DEVICE);
+		__free_pages(tp->Rx_databuff[i], get_order(R8169_RX_BUF_SIZE));
+		tp->Rx_databuff[i] = NULL;
+		rtl8169_make_unusable_by_asic(tp->RxDescArray + i);
 	}
 }
 
-- 
2.22.0

