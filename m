Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5561F1632BD
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgBRUQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:14 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38617 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgBRUQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:13 -0500
Received: by mail-wm1-f66.google.com with SMTP id a9so4329980wmj.3;
        Tue, 18 Feb 2020 12:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JbsLBIjey08BbMjYFR6nJwXmiiRgfHCLvVuuHl3uFUI=;
        b=Rinj2lVTWNz7/BNm1zAxBIspri2k1m14YWUmAPlw7jt/8CCHBQSR5Dbk/02hp8P6X9
         tgJ2kdvS8tG8qqlB0ZjvaayEFISKmKclWsZQkds47pEc4+bKJkZzeeN706uNtH4B03Oe
         WHJX3/eYAM7VavLRXdpNBS025IBlEkiQVDNQPqD7BAdl2wbNqGpukdIp60clYjW/ugAU
         Ktq36jx1SiM+3w5TGg3ycKXe+992MGlCeU38o/CP/1ShA4FzOQl0wGxfaOpCN1ZwEs5O
         LTXU6ytVHGc01+vr7xEX+6UySWu+C1PIyFHJ5Ncj/mtljJMXbyg8py8Rw3G8d7X+yZiS
         D3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JbsLBIjey08BbMjYFR6nJwXmiiRgfHCLvVuuHl3uFUI=;
        b=GB5zp7M4NB9kR1Lizs29dWVTxla+yOPXt5U+RRw6Rp2GVmSnZyKg7vB4/4sDvIbJIP
         Q+chRS8KR+FdKrELGnpXrrxSDk0Pgf2HIGs9T35+6exVvpnvquG17hB5Fgu4OOtqpJ2f
         bdXIj+NGVFa16bYY08yC+tQrsNyCckdQb3396TzgBaRSsQBIzT5fAhZB2DN8Jhtcndlo
         eF9Px0J+O87rb66PzDImz06VKt5rt0zIGAzbmJ89SQHkT79oO5C+FRu/evPFq+P4DWMk
         1EYaAKX/p2vZHzRv20lTh9ew0MwZaIwu0WwJvwSrXIcRnFTqAGBmtLS2+zpnJEylO96Q
         Ky9g==
X-Gm-Message-State: APjAAAX85m8ujm75fgRt8rn8MX5CCOOSOkn8BFVgHdX7OSw5GHZFXGFk
        F2qtFC1Eq5ub6cAqiiVdO5uelPg9
X-Google-Smtp-Source: APXvYqxI/VJcYjsYm7gpnuCDb5HwGwkesJn3QsGVBgmcDSCjVOiM3MpKgLzznSNQvZjj5YglEYytpw==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr4906128wme.90.1582056971147;
        Tue, 18 Feb 2020 12:16:11 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id f8sm7651895wru.12.2020.02.18.12.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:10 -0800 (PST)
Subject: [PATCH net-next v2 03/13] net: atheros: use new helper
 tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <45c910c2-36ed-2557-ac35-cb978e44cbf4@gmail.com>
Date:   Tue, 18 Feb 2020 20:59:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/atheros/alx/main.c         | 5 +----
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 1dcbc486e..b9b4edb91 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1416,10 +1416,7 @@ static int alx_tso(struct sk_buff *skb, struct alx_txd *first)
 							 0, IPPROTO_TCP, 0);
 		first->word1 |= 1 << TPD_IPV4_SHIFT;
 	} else if (skb_is_gso_v6(skb)) {
-		ipv6_hdr(skb)->payload_len = 0;
-		tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						       &ipv6_hdr(skb)->daddr,
-						       0, IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb);
 		/* LSOv2: the first TPD only provides the packet length */
 		first->adrl.l.pkt_len = skb->len;
 		first->word1 |= 1 << TPD_LSO_V2_SHIFT;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 4c0b1f855..0d67b951c 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2025,10 +2025,8 @@ static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 						"IPV6 tso with zero data??\n");
 				goto check_sum;
 			} else
-				tcp_hdr(skb)->check = ~csum_ipv6_magic(
-						&ipv6_hdr(skb)->saddr,
-						&ipv6_hdr(skb)->daddr,
-						0, IPPROTO_TCP, 0);
+				tcp_v6_gso_csum_prep(skb);
+
 			etpd->word1 |= 1 << TPD_LSO_EN_SHIFT;
 			etpd->word1 |= 1 << TPD_LSO_VER_SHIFT;
 			etpd->pkt_len = cpu_to_le32(skb->len);
-- 
2.25.1


