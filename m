Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6F117C89E
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 23:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgCFW7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 17:59:18 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45407 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCFW7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 17:59:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id v2so4163620wrp.12
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 14:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N+DMGlWCMv0Ipzx2fhL5HIAhrMhMw20ncP7sjYlFs0k=;
        b=J7OzAuhhnEvZarTAQUumDQ1KT546m8oizxrIUm6kNOWjINWCbmj03lh4CSCYSTj09o
         7T3CedXfVqRxdgtlOftJDB8LMcNp4Ymm9TNvIg9KBijwDDDZDDCPHfKX+89UncVU+Pai
         vFiMhBupYfrZ+uOOA2766OV0ZFWklamE+D3HCdSUVvkXzvQ17I3ivif8EJk5ky9k/r6/
         /K+Rp0dn0zh9ul2TA3EkprMDAEdyok7l//QibII8uwdYWYGguUsA7VlJxIow/rtg8/Li
         hMLnWUwiNGZDe7ccRvHwu1uMPKxWVndbgS0SCj3mbLFpB1lRdTt8cMklhYW6BPPTLH2n
         HbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N+DMGlWCMv0Ipzx2fhL5HIAhrMhMw20ncP7sjYlFs0k=;
        b=ZaZGxzrJ30+97JhKMSplmgJLnV5/AkQlSrkzsyn/FhOd0CUQ2xlTD/mgjQaVy7u9xO
         n/0lVF6VyckX7n0+m9K/SW2vPQZYXCso082/thX7lIep8ayyMzyZafIxzqNtpj49uST0
         YhO59c47oBtv0UOlsS5TPmA6Dtsw3nKjFKxyvr1Mx6SAz1ut9mb1SgVAJe7PT9dEr8NL
         fK6k1PkfiFTFHVu3e/SQZ2KLKqObQhjoLDrj3JQS7MFCrZM+slsuLTjMZFUxUveZIzN6
         BsYfB1LFUHF7X6UUJxhGaTgNpOUf984LEAXe2b5MEhEZdowP5VjBWooIS3+iOC+y/rBk
         RH8Q==
X-Gm-Message-State: ANhLgQ0y/HG6j3/8RflLJxvY7En2FR+AE1cNY8+6wRqRHdLixo7ho6OH
        d9ycKfp/hWlRo5RfSgAvHZXGBU2g
X-Google-Smtp-Source: ADFU+vuaMCJ5GUV5CbScdtoct6+P4HfreABV1lLV3SXmTQEHmqG3xSrRqO8h/QeaUuyA1T34jDvtZw==
X-Received: by 2002:adf:b19d:: with SMTP id q29mr6017910wra.211.1583535554961;
        Fri, 06 Mar 2020 14:59:14 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1447:bded:797c:45a5? (p200300EA8F2960001447BDED797C45A5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1447:bded:797c:45a5])
        by smtp.googlemail.com with ESMTPSA id z11sm15191150wmd.47.2020.03.06.14.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 14:59:14 -0800 (PST)
Subject: [PATCH net-next 4/4] r8169: remove now unneeded barrier in rtl_tx
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
Message-ID: <855fccd1-86d4-7f02-b202-a7e0240e677e@gmail.com>
Date:   Fri, 6 Mar 2020 23:58:50 +0100
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

Until ae84bc187337 ("r8169: don't use bit LastFrag in tx descriptor
after send") we used to access another bit in the descriptor, therefore
it seems the barrier was needed. Since this commit DescOwn is the
only bit we're interested in, so the barrier isn't needed any longer.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8a707d67c..181b35b78 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4397,12 +4397,6 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		if (status & DescOwn)
 			break;
 
-		/* This barrier is needed to keep us from reading
-		 * any other fields out of the Tx descriptor until
-		 * we know the status of DescOwn
-		 */
-		dma_rmb();
-
 		rtl8169_unmap_tx_skb(tp, entry);
 
 		if (skb) {
-- 
2.25.1


