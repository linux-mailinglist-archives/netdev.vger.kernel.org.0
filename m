Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832251AFE5D
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 23:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDSVRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 17:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725891AbgDSVRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 17:17:04 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE19C061A0F
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:17:04 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e26so8762765wmk.5
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zPffGEXKM+3wTRsKjRisELv+NQlcTraDs5zpvqFp1Uo=;
        b=MBk3RvxSsqOXfjTWwSq2tpxMP+rk45vN4OaDJWsQr3cGkMmQLkMWOu116H5wny+fOT
         pWcqNPg7exY4HwaudSm3IixaYfnOtkpXaM5DHHwsWNTrhivvGWbOh1qb0Zmqx8Q0u8EF
         SgNHrYXm6r7I7mpcRZzTBYDrBUCXw3Nh8l9XffPrb9p5UV2zc4Eh/PvxIrZUsDp2xt6V
         hzL3CX5eUAQyd3B35YTi2gS/q/Y6guyjp3n5W3Ltq1Uhd0cyb5TCAUjOjfL8oFitMs4c
         6mK1/XtMGzmaY9ZspymttGCYcVVJbjYITrOZGy5iajIC+NJrDybtZCJSYxU40TeOHIWc
         aYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zPffGEXKM+3wTRsKjRisELv+NQlcTraDs5zpvqFp1Uo=;
        b=n5uZ8/0dQXAennGbAqsawak7EEWpRVtH9AmMm+iCeKz3NBS7aoPC3b/PGtQeLiZjGl
         uZrh7y+OAaNoLpOlR4fqO46aknGhLskgl3UOwPXviLbc73j5YfWr+jlNY7o3PvmOkacx
         vYin3bHl0gBT9xYDTw+jljvJro5SYodY47Mk9xiq1qzhd26blqNcE79s65ZlJfZo8ZuV
         pwQvtmXItn2ks670KLcLV2ZaXHj//L6RDo/36qbXT8Nte/7USWOVOccfnc9W9AwVm/EB
         ABMjVcootphgdh37XlSmazWMaPOA3WjSNdSBX5NVWIH7XGRqas5LHsJDlJaHK6VsYd4v
         gn7w==
X-Gm-Message-State: AGi0PuaBV0BRiwXJIZDXPsRM84ltKHKv4DOb5nGTqU1ruUqQnsuNf7kX
        sfriphw5IkrNwlY8s5WMNP9VLjm5
X-Google-Smtp-Source: APiQypIJpfyn6lmxuNaeiGg5gJJIt/BDeYy1EuvG02bo1x+Gat5RfA/89Z3YVRHFekQz1emstSQfqQ==
X-Received: by 2002:a1c:9816:: with SMTP id a22mr1372092wme.125.1587331022776;
        Sun, 19 Apr 2020 14:17:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id d13sm16537014wmb.39.2020.04.19.14.17.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 14:17:02 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: inline rtl8169_make_unusable_by_asic
Message-ID: <d5d0e0fa-8947-88b6-5d6a-9cd7f1bf274a@gmail.com>
Date:   Sun, 19 Apr 2020 23:16:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inline rtl8169_make_unusable_by_asic() and simplify it:
- Address field doesn't need to be poisoned because descriptor is
  owned by CPU now
- desc->opts1 is set by rtl8169_mark_to_asic() and rtl8169_rx_fill(),
  therefore we don't have to preserve any field parts.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e9be6d0e2..9b9b99799 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3882,12 +3882,6 @@ static int rtl8169_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static inline void rtl8169_make_unusable_by_asic(struct RxDesc *desc)
-{
-	desc->addr = cpu_to_le64(0x0badbadbadbadbadull);
-	desc->opts1 &= ~cpu_to_le32(DescOwn | RsvdMask);
-}
-
 static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
 {
 	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
@@ -3933,7 +3927,8 @@ static void rtl8169_rx_clear(struct rtl8169_private *tp)
 			       R8169_RX_BUF_SIZE, DMA_FROM_DEVICE);
 		__free_pages(tp->Rx_databuff[i], get_order(R8169_RX_BUF_SIZE));
 		tp->Rx_databuff[i] = NULL;
-		rtl8169_make_unusable_by_asic(tp->RxDescArray + i);
+		tp->RxDescArray[i].addr = 0;
+		tp->RxDescArray[i].opts1 = 0;
 	}
 }
 
-- 
2.26.1

