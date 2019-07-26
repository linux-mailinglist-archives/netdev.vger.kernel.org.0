Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0326C77269
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfGZTv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:51:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52957 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfGZTv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:51:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so48905005wms.2
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J5JNtTWBW023hmRQnc9IfBZszZUlrUyjmx/SlOqkm2g=;
        b=f4kJL14TOIxFgx6ROOAhRuPwJSQnkwi7UNTNgVFi1ZkJG2D3XgnpguZ+NeY77Bu344
         unIm4jYS9LIXZXQkTchttkTOqriNPA+G26ymP5n7WIJqS03+9Udfk6Ln9T8qvxuv9/nW
         NUv488VMI7avtySto9Pn/GL9DcmdINzoX2YQ89ExDh4TDZmjKS0FIQYyKdPWG0v66MZM
         IB8XaBmR0IjixFho5ksd96uFRdsSUZTeX3n+MnyAF80O/j7PY6hhJncHQGyaE4gdaQNe
         lw6vPCjQgR3UqfAWwFHdhh7vIry+w1dWlreuaNPKoJD54YDrajYEtysZp33H9PuFAUIl
         Us+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J5JNtTWBW023hmRQnc9IfBZszZUlrUyjmx/SlOqkm2g=;
        b=Fs/9Wi3oCJ4kIFrXRRXvMg/VCuiNA6L88NI6dG52wuz/5BTrsS7jzxP8SVT+YXKs2u
         TgrAlvKYduc/xjdAWhjCxKKhwJHv+Sgd+5/Hg/X7hOcWfTPE/3l3cOqFRXQNusLdWKfz
         BUiyqT9/3mBnQOY7Org8l5jUWWkfNxf5SfG3YaC3ouML4UfJgWbaJBhMFsWuoLUPAegp
         BeaY7l8IAynrZb5JC3aMIZHNB5DZdmmjT5tRTm/lWVnjTQjalrOlbKnGEJ/JQPCgv+7d
         yaiio4MATYMXxC4bbnkfcOHid2/EvvjE0RKuvTFHq2xZYuHyK9ngDmaAe4p0Z14iTJd+
         F7Mg==
X-Gm-Message-State: APjAAAXi/cAMbZcRkqf/xWETmTv4XV98P52mFQPukD2P8+IP6fQfwOMb
        FGyAefO88mNRczEdduBnh3k8gduY
X-Google-Smtp-Source: APXvYqx4GnpF6nh3SL+tMx90Rw6RDbm1wCyTdV/NsaTscBhag9cuRrbX9QWvCS5ULpt3MeMfne5EDw==
X-Received: by 2002:a1c:6641:: with SMTP id a62mr83236500wmc.175.1564170715183;
        Fri, 26 Jul 2019 12:51:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:55f1:e404:698f:358? (p200300EA8F43420055F1E404698F0358.dip0.t-ipconnect.de. [2003:ea:8f43:4200:55f1:e404:698f:358])
        by smtp.googlemail.com with ESMTPSA id o7sm44654658wmc.36.2019.07.26.12.51.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 12:51:54 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: remove r8169_csum_workaround
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
Message-ID: <e4acfc01-a8d3-c8bc-5c70-3e1fdabbb068@gmail.com>
Date:   Fri, 26 Jul 2019 21:50:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The loop in r8169_csum_workaround is called only if in
msdn_giant_send_check a copy of the skb header needs to be made and
we don't have enough memory. Let's simply drop the packet in that case
so that we can remove r8169_csum_workaround.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 39 ++---------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7e1b68b19..f77159540 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5508,39 +5508,6 @@ static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp, struct sk_buff *skb)
 	return skb->len < ETH_ZLEN && tp->mac_version == RTL_GIGA_MAC_VER_34;
 }
 
-static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
-				      struct net_device *dev);
-/* r8169_csum_workaround()
- * The hw limites the value the transport offset. When the offset is out of the
- * range, calculate the checksum by sw.
- */
-static void r8169_csum_workaround(struct rtl8169_private *tp,
-				  struct sk_buff *skb)
-{
-	if (skb_is_gso(skb)) {
-		netdev_features_t features = tp->dev->features;
-		struct sk_buff *segs, *nskb;
-
-		features &= ~(NETIF_F_SG | NETIF_F_IPV6_CSUM | NETIF_F_TSO6);
-		segs = skb_gso_segment(skb, features);
-		if (IS_ERR(segs) || !segs)
-			goto drop;
-
-		do {
-			nskb = segs;
-			segs = segs->next;
-			nskb->next = NULL;
-			rtl8169_start_xmit(nskb, tp->dev);
-		} while (segs);
-
-		dev_consume_skb_any(skb);
-	} else {
-drop:
-		tp->dev->stats.tx_dropped++;
-		dev_kfree_skb_any(skb);
-	}
-}
-
 /* msdn_giant_send_check()
  * According to the document of microsoft, the TCP Pseudo Header excludes the
  * packet length for IPv6 TCP large packets.
@@ -5688,10 +5655,8 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	opts[0] = DescOwn;
 
 	if (rtl_chip_supports_csum_v2(tp)) {
-		if (!rtl8169_tso_csum_v2(tp, skb, opts)) {
-			r8169_csum_workaround(tp, skb);
-			return NETDEV_TX_OK;
-		}
+		if (!rtl8169_tso_csum_v2(tp, skb, opts))
+			goto err_dma_0;
 	} else {
 		rtl8169_tso_csum_v1(skb, opts);
 	}
-- 
2.22.0


