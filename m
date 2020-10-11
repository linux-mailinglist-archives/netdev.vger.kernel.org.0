Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF7528A9D2
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgJKTon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJKToi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:38 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1C3C0613CE;
        Sun, 11 Oct 2020 12:44:37 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id c22so20364610ejx.0;
        Sun, 11 Oct 2020 12:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K5p6PQe9PHlb+DeFu3qCLN+dyNKfD6AR/iCNZWeTJCc=;
        b=HbRt6adGAkstImkM+FvDPUdRIwYLplfIyHr6lQj8N62eXViV/hea+3jch0P7j1QSAB
         XH0QnWYdoc68vK6BV4c2a/MGZmQhESAuaiw3nH6jaKZRtxReSo7CS4db24I/dCvBpJgx
         oZlNuBNZ2nX9TCEHVyKXJ9X9aB05foRI21NPRbCNHx6TqX7JIcFFDRlwbdkxHn4/hjGD
         npHaKOYfY4UL/Z0mRqf4t4/RPQ0n/iSlqNOx8vAXXwj8WPWYA8hK8o9AmRlXbHEVnL2l
         3QmDQzkyFXpVlEMSLnXneAVyxrUcvFdZJG4gNH/1j/i31cFkBdsNYAUwx5CGGew38com
         vupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K5p6PQe9PHlb+DeFu3qCLN+dyNKfD6AR/iCNZWeTJCc=;
        b=IHh3A0PBAG2CaHrN61XMjol4PZyY7VUaco8PgLEKBb9+EIXJRgNc4bkUfYZnawF1P7
         mIOqvNlJHANkmoOOhbYquFwJO/07ofX35AK5hNPNFJZG7uVAC3l2uFxJAa3Moq8Vu86E
         Dov3B7oVXmu/DVw9PegGMQ9fC+pWr/+bNWVc7JBXRBo9zT5S3oac/W28F2nJcCAsp+/8
         jVlM1vAmf3MiiqOKfOcJBOWSB8ZuF3IqqwKpq4QLUgWfayepHdqslAaBSVKehjaUGeXq
         gaQG9Edk7bRTwpsMTQECioQqXxAYIO+nMm26xSwMYa6g0crnNCcl+RsbI5M9OwUV3EqH
         IiPg==
X-Gm-Message-State: AOAM531Tf35tPaDBa0SyZNU9okCcnLfTbD7HXLqRzrmMVyEcDjWWrhtC
        xSmetIaedYUoSbzk+rB0+mM=
X-Google-Smtp-Source: ABdhPJzZ5j1LdDWA5dmv+e3w9peo+dUGtcw1j3sEyVi1uLGsEplo4M1SATqelgZk1ZYsssDnPQiyAA==
X-Received: by 2002:a17:906:1b15:: with SMTP id o21mr25308968ejg.19.1602445476379;
        Sun, 11 Oct 2020 12:44:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id q27sm9766916ejd.74.2020.10.11.12.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:36 -0700 (PDT)
Subject: [PATCH net-next 07/12] net: bridge: use new function
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
Message-ID: <ce91ffd8-f17f-613b-5d25-955348cfd9a1@gmail.com>
Date:   Sun, 11 Oct 2020 21:40:50 +0200
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
 net/bridge/br_device.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 9a2fb4aa1..6f742fee8 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -206,27 +206,8 @@ static void br_get_stats64(struct net_device *dev,
 			   struct rtnl_link_stats64 *stats)
 {
 	struct net_bridge *br = netdev_priv(dev);
-	struct pcpu_sw_netstats tmp, sum = { 0 };
-	unsigned int cpu;
-
-	for_each_possible_cpu(cpu) {
-		unsigned int start;
-		const struct pcpu_sw_netstats *bstats
-			= per_cpu_ptr(br->stats, cpu);
-		do {
-			start = u64_stats_fetch_begin_irq(&bstats->syncp);
-			memcpy(&tmp, bstats, sizeof(tmp));
-		} while (u64_stats_fetch_retry_irq(&bstats->syncp, start));
-		sum.tx_bytes   += tmp.tx_bytes;
-		sum.tx_packets += tmp.tx_packets;
-		sum.rx_bytes   += tmp.rx_bytes;
-		sum.rx_packets += tmp.rx_packets;
-	}
 
-	stats->tx_bytes   = sum.tx_bytes;
-	stats->tx_packets = sum.tx_packets;
-	stats->rx_bytes   = sum.rx_bytes;
-	stats->rx_packets = sum.rx_packets;
+	dev_fetch_sw_netstats(stats, br->stats);
 }
 
 static int br_change_mtu(struct net_device *dev, int new_mtu)
-- 
2.28.0


