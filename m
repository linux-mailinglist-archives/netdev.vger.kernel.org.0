Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA12328B02F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgJLIWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgJLIWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:22:00 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46018C0613D6;
        Mon, 12 Oct 2020 01:21:59 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ce10so21985713ejc.5;
        Mon, 12 Oct 2020 01:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gfr3ALYPLKmxZda8jB3ld1N0hpEXjoqgwocV8/nd3X0=;
        b=HiO2yT5UTj6vL6bTfSks3cTWpyMXE/SKZWGyx2SnXbAhSg52eznHTmoLgXMUze6Xdv
         srxTM60eheaVspO7HvDZbo75pC+4ORAhuC+aWwABK7ngrr8fcBKl0X8O6pYPBNz2GE1J
         Zv8Qcc1bJuoTMQN8M7GtgZvabx9aAGgsQTtusQky8VivWdI/lgIm96TwDznP45A4Y56U
         r8D8fJmBHuFC3fLJV+xrGLWi3x7oor1VidkpI4lZuEbnlriog+sNoEVrKwpFySEw0JD0
         GtMCUpH0z1SXDATR3ZCe+zoSWCsUQ4xn1at2vKcbIZHPLwiU2mO2sc/er1VofIR6tg2D
         fwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gfr3ALYPLKmxZda8jB3ld1N0hpEXjoqgwocV8/nd3X0=;
        b=n2uLX4KxZyFw7Js0iCNlD+bfpaaT0HylihFrM1kTAuvjp7MdBNVU19pQCCVc6+J6or
         rC3vLeWUNEZM/7FNGeuD+0ODiEiii3NIU8TCAZRPhsFSGOtFP0GWBpu78StGMF+HQaLO
         iZkcriVzsxmuU7n0k+nqhVqqZFzP4f0fKbmun2UVMDyGTB3hfFCtEERrv/vGg+1M7VUS
         ot0QsOyTMSUf0kkQnmc8Z8hRvvhtDqRdqYiCWSc20FwTQubybENCfkk+09qp3dgfmmv/
         xxqnSDzC3scTsq3d+S5v5/u45KmiQqgS/sawjVl6RCyhr9+3xEPEWjJEXyA/lL6Lb+Qf
         pToA==
X-Gm-Message-State: AOAM532O6Pk98XEjj3fdZGsOITUZ90yf9XYTFm/fcAqOmTVblT0XkKAL
        4ZFMdK2sO+tFprhR+Uj1YuI=
X-Google-Smtp-Source: ABdhPJxS7FlN03fx5BkaqnAreInjWiPKOWXxXRAr59axtAnnO3Qa/FU7KbcEV3jlPhgKS5wIpdfZKA==
X-Received: by 2002:a17:906:783:: with SMTP id l3mr27810367ejc.253.1602490917909;
        Mon, 12 Oct 2020 01:21:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id q10sm10280337ejb.117.2020.10.12.01.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:57 -0700 (PDT)
Subject: [PATCH net-next v2 11/12] net: openvswitch: use new function
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
Message-ID: <5e52dc91-97b1-82b0-214b-65d404e4a2ec@gmail.com>
Date:   Mon, 12 Oct 2020 10:19:12 +0200
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


