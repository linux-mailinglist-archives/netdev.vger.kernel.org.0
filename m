Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB228A9ED
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgJKTpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgJKToo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:44 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF903C0613D2;
        Sun, 11 Oct 2020 12:44:43 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a3so20268705ejy.11;
        Sun, 11 Oct 2020 12:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gfr3ALYPLKmxZda8jB3ld1N0hpEXjoqgwocV8/nd3X0=;
        b=UbL1GtjqXIjEGis5eM/8DwyMsHni206CGfZbq8bJ4Cq/dPqLWTpDUaxfFfzUN/NQ0R
         WNmYW3qdxh0pnWXQaoDe1nChSTIh6UTJ1SUMKcaQwRu7tQHbnHMJYc9b60vNWy4nh2aR
         39ZLS52ZJ30L2HF+21PL5XB8xlAqyxKt0lsCWZO9rcVudZySuROSZS34XHNWL3VL6POI
         W9VRr+t4S9PS8gPdJ6DjdYR+h3OE9rx1F5wr5xgIPwYgalHlaXejI9sL//flzgCHykQy
         G2u1erqZ9fsK4FIHDpNBHaAuHIFP5hkKTLCqnvVJlEoUoVZHPXw9YfD1SP1dRKmk2vw8
         oFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gfr3ALYPLKmxZda8jB3ld1N0hpEXjoqgwocV8/nd3X0=;
        b=MPS8gWxuoWD0lAHGlDXclV+YC03sstt2YKZCeFV8O2dkaFeZvDZhYf+w2n0P/o7UzT
         seZmKvwm65yOlLlIDeesn6niKkypnEmcFZoKAiiF/rD59QyaqwySIBK+0BwLdZuGu0eO
         kbco1S2FXMnHECukeSS0NGDJvhGYdNsqeLpre+5t2uNmJhANj+OrdWysHxkGeVFGnvy6
         kPEdA5U1OAnTz23ijGx6K3ulhPfirCrpJB3uIWnlrb0yl0aWwMJM4kfSydFxcQEDfHbK
         p/jK2jCxKYpDZf7kIWh1CUaeKDEzx28f915SsAjThtm5RYKCka79SgX9jgXHbZf1wKIz
         sH+w==
X-Gm-Message-State: AOAM531HnnsYQ+4PZWwdq2ZgDI2SMzB+lVQ5H5j7+XQjb25OxqhVRgok
        kNrBkeCY+h9H96NJOY1Kw2I=
X-Google-Smtp-Source: ABdhPJxJzVcxYYhChoisYAA0WC0eftqGze9+lsho48XfvKPZgGEASN1Fa9S6xPslx35aOFc2I6gM5Q==
X-Received: by 2002:a17:906:3b91:: with SMTP id u17mr24104083ejf.504.1602445482592;
        Sun, 11 Oct 2020 12:44:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id x2sm9504409edr.65.2020.10.11.12.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:42 -0700 (PDT)
Subject: [PATCH net-next 11/12] net: openvswitch: use new function
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
Message-ID: <7debf7e5-ea7f-6fec-4f58-7dd6c8f28b7b@gmail.com>
Date:   Sun, 11 Oct 2020 21:43:18 +0200
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
 net/openvswitch/vport-internal_dev.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index d8fe66eea..1e30d8df3 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -86,31 +86,13 @@ static void internal_dev_destructor(struct net_device *dev)
 static void
 internal_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
-	int i;
-
 	memset(stats, 0, sizeof(*stats));
 	stats->rx_errors  = dev->stats.rx_errors;
 	stats->tx_errors  = dev->stats.tx_errors;
 	stats->tx_dropped = dev->stats.tx_dropped;
 	stats->rx_dropped = dev->stats.rx_dropped;
 
-	for_each_possible_cpu(i) {
-		const struct pcpu_sw_netstats *percpu_stats;
-		struct pcpu_sw_netstats local_stats;
-		unsigned int start;
-
-		percpu_stats = per_cpu_ptr(dev->tstats, i);
-
-		do {
-			start = u64_stats_fetch_begin_irq(&percpu_stats->syncp);
-			local_stats = *percpu_stats;
-		} while (u64_stats_fetch_retry_irq(&percpu_stats->syncp, start));
-
-		stats->rx_bytes         += local_stats.rx_bytes;
-		stats->rx_packets       += local_stats.rx_packets;
-		stats->tx_bytes         += local_stats.tx_bytes;
-		stats->tx_packets       += local_stats.tx_packets;
-	}
+	dev_fetch_sw_netstats(stats, dev->tstats);
 }
 
 static const struct net_device_ops internal_dev_netdev_ops = {
-- 
2.28.0


