Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606AC28A9E7
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgJKTpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgJKTol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:41 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03A9C0613D0;
        Sun, 11 Oct 2020 12:44:40 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id t25so20264810ejd.13;
        Sun, 11 Oct 2020 12:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/FTD4WRUg6u2eGbYzuvRNRJ/sh1gmUaaKBFsN/NH+4I=;
        b=PyzuGbgQ/T5WAYNOiE7/Fc7mim7ijDf/I6hDizxzEYTF8/HfbbmzP42R+dk/Tf7t3L
         r3rTgfmciTFkPugJUIfFan4lA3UxjLBGZrSeWGa98iK7WgUsSZZMK6jaqsVusLDc7OKt
         ducIl5gXoe3bagOoU/aBG55E0qjsy2CDzRWixI5g8O4pMkDRMn10OM/pJEYXJUbxUdg8
         wEvIdZn0WeXfx8o6AOtjUbp/WHumX4LdXSa/3HL4Zw5+KaHHYXBaDEvDAy4vYOU/JTen
         aN8KJ1n70tBEf2n56k0U7kdOle+7frjcbMwxo8f8NSK4m1RYQZEu24MxYsLGh4P3It+e
         TvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/FTD4WRUg6u2eGbYzuvRNRJ/sh1gmUaaKBFsN/NH+4I=;
        b=ORE7QyDHLQUSovfqdxuzwCp+XDh0z1dV1aK+rW/mRb6C/W4vZlC/LOOHDWNjNrBIjU
         Dl7Ko8TqvZ/S9YR7zIaGRDAakaBgsx7hkLhp4No3CK83E/LHR3RlkaN8VL7VIGwcKchR
         CCEGgJkdizEKr+PbsxpVkQNYi4LE+ZDYrktubx4POQtnVYGuB4Hu/bMQUQ391HKe1POU
         7m/bpX1wFH31HPZP5XGlSLIjxAt5MmOEGtm1FeT9auhp152/pSc2GRJ+ZLKXNCSMaFiM
         TeYnmood8F5sT0yoSM1gkx4VIPsPrbxVtBJUxNAhpxXMsuutIHGY15yqB3EkE3K2MkyH
         l+sA==
X-Gm-Message-State: AOAM533kUTkN5M7yqozY5Tqx3AeZYomForsG3BeEV5v7ehKjHYw9igsr
        bxZwosquJI+ZJey9GNi+UZ0=
X-Google-Smtp-Source: ABdhPJy0/HhFKnErdQJ5STzec8NAN01r56idFqQy377HiXCcfEQXhV1+jYC24f9CwpMFGSMhidBnXQ==
X-Received: by 2002:a17:906:f8ca:: with SMTP id lh10mr3843209ejb.528.1602445479587;
        Sun, 11 Oct 2020 12:44:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id qq10sm9621759ejb.31.2020.10.11.12.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:39 -0700 (PDT)
Subject: [PATCH net-next 09/12] iptunnel: use new function
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
References: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
Message-ID: <3b1116c4-4cc4-2aac-fd66-7ffd2d3705bc@gmail.com>
Date:   Sun, 11 Oct 2020 21:42:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
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


