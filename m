Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0917528B026
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgJLIWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbgJLIV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:21:56 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36A9C0613D2;
        Mon, 12 Oct 2020 01:21:55 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g4so16032414edk.0;
        Mon, 12 Oct 2020 01:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/FTD4WRUg6u2eGbYzuvRNRJ/sh1gmUaaKBFsN/NH+4I=;
        b=C3113bStM70NZuGM7RyowckACfab14LKWg7wWfVF/LN3gVgq92KWQoexxkqcaYsQXm
         S9+IQrNBQJWcncQPRDFnK9QzobnWFz6/JtU8SocMw+7dSpE6I4f0nVub/xf9cfsowJaT
         lE7n6ZQ9/gd82nLWmrQ3oIVm6iIFDGr3OMzdAgFx1XMuMONCdTGsKH53SxyEiTGbgnl5
         krmJtopY25J74lQSe8f4R3ihHlk5EuspuSF+G0TSkKhlCCRf8804X1ysZI4h47N94G5q
         vi6K7T1jrBWYfgWxCeNxF9ui1SbrovpET6KJdVeSH4Sb0Dyj3pF8LO/mrTrIKzKbH/cb
         S6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/FTD4WRUg6u2eGbYzuvRNRJ/sh1gmUaaKBFsN/NH+4I=;
        b=cJhTHNQmfmrvsQX20KXM0s6RLEtQe5m5KcFt6Lz+yzfHVhljZD8ixXwxqalNQgigBh
         m2CkjdBACPMHTUtptresV/eRr2mVfz4xc0bX9aR3dbkHwNsCCKkvffUcX2cFp4OauH/E
         nLEaW5ILU16VRyfpHXePZPXOQQgRe1nz3RTNodPiBzaXtSHDiMVv9NNNqRXwodrMomFv
         J++JsjgrlCnFksPuRgkfuwtjrSahyrFjoPDarhhXS5/kU+BMNLVe0N8SWrJNYWpg8/Lx
         EdwBw2uZfmaUhngv/RDtCD6rwQ4T8bi6mlvHWZ4N3i9lEkeJsIO/ATnbCxvz7jQMXbC1
         rnYw==
X-Gm-Message-State: AOAM531S0jgMS+dcVUI9RXMJoyE5rm6myCWaNhMt+XK3znOTX7ElifSh
        NifBq3k4fKbp9A3gDFJzerRkkbefZZJPyA==
X-Google-Smtp-Source: ABdhPJyr91gOF2uqDYP3d2BgCowxK/xZ/ClenuzL/KGhJVInWE0z0tAUMA3MaJ4QILJikb+ZTAQeVg==
X-Received: by 2002:a50:8745:: with SMTP id 5mr12629496edv.49.1602490914611;
        Mon, 12 Oct 2020 01:21:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id do22sm9778504ejc.16.2020.10.12.01.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:54 -0700 (PDT)
Subject: [PATCH net-next v2 09/12] iptunnel: use new function
 dev_fetch_sw_netstats
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
Message-ID: <050f9a83-b195-a3d6-edbd-91a59040be21@gmail.com>
Date:   Mon, 12 Oct 2020 10:17:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code by using new function dev_fetch_sw_netstats().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index b2ea1a8c5..25f1caf5a 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -433,29 +433,8 @@ EXPORT_SYMBOL(skb_tunnel_check_pmtu);
 void ip_tunnel_get_stats64(struct net_device *dev,
 			   struct rtnl_link_stats64 *tot)
 {
-	int i;
-
 	netdev_stats_to_stats64(tot, &dev->stats);
-
-	for_each_possible_cpu(i) {
-		const struct pcpu_sw_netstats *tstats =
-						   per_cpu_ptr(dev->tstats, i);
-		u64 rx_packets, rx_bytes, tx_packets, tx_bytes;
-		unsigned int start;
-
-		do {
-			start = u64_stats_fetch_begin_irq(&tstats->syncp);
-			rx_packets = tstats->rx_packets;
-			tx_packets = tstats->tx_packets;
-			rx_bytes = tstats->rx_bytes;
-			tx_bytes = tstats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&tstats->syncp, start));
-
-		tot->rx_packets += rx_packets;
-		tot->tx_packets += tx_packets;
-		tot->rx_bytes   += rx_bytes;
-		tot->tx_bytes   += tx_bytes;
-	}
+	dev_fetch_sw_netstats(tot, dev->tstats);
 }
 EXPORT_SYMBOL_GPL(ip_tunnel_get_stats64);
 
-- 
2.28.0


