Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A6C58CF0
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfF0VTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:19:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44781 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0VTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:19:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so2200952wrl.11
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xXwbqPtAUV8XG7gSXXdUsJHPvafbrH1QdkybiAj21KA=;
        b=UZA954xigMGohW8+FH7fpCxzV4g83VIrb/W6E/tsK4jiaL4Imkibbj2y7WeyWpPuG2
         XH0205BkdeW1gfiXpo9YgzgIz8kub/LSXegLnkR/a9UuiZCufJzp9j50KKkHuZs7VMPt
         3R62pNo3UBYQNZ0ZsjJTTibWklJSSLbt6SSoulRaFVmXqNHbfFaKgOBdQKgpuOzYKvLc
         R2vlLlspxT9AYt6cZVNG7tJTpSqyYMOn4sBz/W3r3OU/lefifYtKF7zjRWGjxfGWjelb
         Nv+2wxEyhk4/YPixOvVK98Z6LlghLKC4UqbNqWwnu9qO9g60pB5XegVQDwYf9Wp5iLiY
         V1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xXwbqPtAUV8XG7gSXXdUsJHPvafbrH1QdkybiAj21KA=;
        b=p+4gk0lW3f2+6VXap06hZcfrpAEK0H9BreRYFJaf9n+rNJ/pA3KVTvPfhBJVeV90Pa
         b+XBCrypIwdAUC9+POsM7fVKXfJHuQVTa1eOoiF72BHV4kzUm87CUrKXBsOkwlYHhOOj
         StTFf5wa0Mc0BTpxT3e+uEZ6G4Z4I5Nr/a1okirS2JT/r7yaMvjjezoWi7lLCSFx5vPr
         BJtND3/pXb5uzWW2wJtRCy6Cc1CAlZLgKeV9dzg8AIvCOB2Gr+tFG7m+oQub+4trrxMi
         caVaS2/mtR97CZDscwI4ysZHqLjH/brXZnQ8hfW8A/9/NImIKugsAZ57MNaAQnauLh5l
         MB5g==
X-Gm-Message-State: APjAAAWRt9IGzyeSO5xVxzTJQZ7nQRSvMoUOM6LgssptRFquR3sjb0bO
        ppsb74xU7U80qbAsEibjSjwYNsBi
X-Google-Smtp-Source: APXvYqxAY751TX1FUrLmK4e54lOXyJriHYLVD/VsilFNkAsmyvJ8BdfFEnTOlkpcvegjutQjxeS76w==
X-Received: by 2002:a5d:4001:: with SMTP id n1mr4826471wrp.293.1561670359716;
        Thu, 27 Jun 2019 14:19:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:3d9e:1690:cd42:495c? (p200300EA8BF3BD003D9E1690CD42495C.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:3d9e:1690:cd42:495c])
        by smtp.googlemail.com with ESMTPSA id y133sm348139wmg.5.2019.06.27.14.19.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 14:19:19 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove not needed call to
 dma_sync_single_for_device
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <8377f1a6-787a-7eea-17be-0d70cb9911d3@gmail.com>
Date:   Thu, 27 Jun 2019 23:19:09 +0200
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

DMA_API_HOWTO.txt includes an example explaining when
dma_sync_single_for_device() is not needed, and that example matches
our use case. The buffer isn't changed by the CPU and direction is
DMA_FROM_DEVICE, so we can remove the call to
dma_sync_single_for_device().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1b5f125e1..a73f25321 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5785,7 +5785,6 @@ static struct sk_buff *rtl8169_try_rx_copy(void *data,
 	skb = napi_alloc_skb(&tp->napi, pkt_size);
 	if (skb)
 		skb_copy_to_linear_data(skb, data, pkt_size);
-	dma_sync_single_for_device(d, addr, pkt_size, DMA_FROM_DEVICE);
 
 	return skb;
 }
-- 
2.22.0


