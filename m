Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A064C28B023
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgJLIWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgJLIV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:21:57 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8138AC0613D5;
        Mon, 12 Oct 2020 01:21:57 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so15989107eds.6;
        Mon, 12 Oct 2020 01:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m4bUmyI+LcL2kRpVckxE5LM+etyYjhNnBeXZhGHIk4E=;
        b=lDYtJfWe8/DHmjC4qnf5MwRbdeN5hvaFN8hfqDPHJ+0ZfSsAgJJ/eXIwbH/bAiyviA
         aryMIMTmub/a4wvpBSrINDW0mgGtW14oQkcmg7cHioMBNYxSeFVJEVppU4CZN/z3pgYi
         yCFSGrnv7HyvCgvGS3/K6wNcJVNLfuuY8v8uzjSvqKU8yTWDfejU2Bd9+zFdG60zZczq
         jBuK8KZCwLWlL18mrCzoRXzYxMqfYb9GBbaRMEFJXupAYO/QmQVPMGU2VtefsbCISeUd
         mBdf8EcSNS2NDXdJN9FOMUgC0woGLf6i+BjyF8u1bEQoHHPT7PqN5ajYLcMBnPcAUc/e
         zu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m4bUmyI+LcL2kRpVckxE5LM+etyYjhNnBeXZhGHIk4E=;
        b=UTRTkAomygHoW5iGH9Vkd4NTYLYV1V/qtn02REzoV94KyPuyPwGxMEl5F0HiKPhCK8
         jB9icw74/Mmb8K9v7ppg/L0ZuGDFxxXhhK/PYOxpb8Bjp/jOvv91BbrTtiRVMmCc1cBU
         65uWztXjlIYlbg4s7/m/qFG1THfv17kAfh0yrqjsGKVn5KGWozO/AP54w17rESIJR2jG
         Zz4eNvpW+MP5RoK5PP1ZpIjeusUbB6VW8lsA7v5nApV9kvyzT8LxJZBhi0+6ecxE+2EJ
         DUcIBTW6PSx9TIFZAfO8I8bxwBaGnIDFIavIMOeAxPy/4MxuQcwLvNMZytheD1MEKbab
         //pw==
X-Gm-Message-State: AOAM530utoZPqvE81PtfuIH1o3svWQFjX77RNfbLmrMGTvLwJ9IrYMko
        hhgvlgZ+5SFe5qPwPAI7CBA=
X-Google-Smtp-Source: ABdhPJyxfMf7VORSSp5HyoFFzEneyPhPzS9WR/V/e17Yl+s28XgNVuSnVMDboRtDH0wsx5sophUXpw==
X-Received: by 2002:a50:c05b:: with SMTP id u27mr12607356edd.290.1602490916179;
        Mon, 12 Oct 2020 01:21:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id j10sm10013041edy.97.2020.10.12.01.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:55 -0700 (PDT)
Subject: [PATCH net-next v2 10/12] mac80211: use new function
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
Message-ID: <93dda477-70ae-0ccf-71b4-bfebb66c9beb@gmail.com>
Date:   Mon, 12 Oct 2020 10:18:19 +0200
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
 net/mac80211/iface.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 240862a74..1be775979 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -709,28 +709,7 @@ static u16 ieee80211_netdev_select_queue(struct net_device *dev,
 static void
 ieee80211_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
-	int i;
-
-	for_each_possible_cpu(i) {
-		const struct pcpu_sw_netstats *tstats;
-		u64 rx_packets, rx_bytes, tx_packets, tx_bytes;
-		unsigned int start;
-
-		tstats = per_cpu_ptr(dev->tstats, i);
-
-		do {
-			start = u64_stats_fetch_begin_irq(&tstats->syncp);
-			rx_packets = tstats->rx_packets;
-			tx_packets = tstats->tx_packets;
-			rx_bytes = tstats->rx_bytes;
-			tx_bytes = tstats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&tstats->syncp, start));
-
-		stats->rx_packets += rx_packets;
-		stats->tx_packets += tx_packets;
-		stats->rx_bytes   += rx_bytes;
-		stats->tx_bytes   += tx_bytes;
-	}
+	dev_fetch_sw_netstats(stats, dev->tstats);
 }
 
 static const struct net_device_ops ieee80211_dataif_ops = {
-- 
2.28.0


