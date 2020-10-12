Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C2128B016
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgJLIWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbgJLIWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:22:02 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2DAC0613D0;
        Mon, 12 Oct 2020 01:22:01 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a3so21926779ejy.11;
        Mon, 12 Oct 2020 01:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t6mBah8f7Cbtv+XC/jNYzc0qx0/PRMeIzqK4sBdTEL4=;
        b=NWkmZm41Or7oJj4yHKmspy+OrWaPXUjOO6q5yMHMUW83945lY8phOot7oyDgef2jPL
         ZbBtAIu3dD7kLzFCsvULZgsu2VKNPw1plK2qMK+jvwWxoeSO4PQhxrMbEQ4RRTMlRgZb
         Aewc1ClDWIAUAJ79cweUgfhPYwAyzRne3Bkxt9IiaOXJO41cr2qUcBBQLcSozEm0WyQi
         fZ18uGsQO89vQNLOYxYJcwdsja5ljOD2QFLwHneixm0SS1c9NcMvJO+g6o8bhwPixTic
         92kuT501ONzBuwcy5NaMYuTDDtRw6cc0yuWUB+nPQzVGZN55ZXSJlIaL83ozl7+zhMxx
         AwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t6mBah8f7Cbtv+XC/jNYzc0qx0/PRMeIzqK4sBdTEL4=;
        b=J+FE/lQF7MHkPBpP1XQcOEWsyOZhSFV0kvtzTOa8aSb2Qo2LQy1zYNWeHPr7DmAuaB
         tjTMperIc78GkhRcckhCV/vAc1O0eUUi1zZnH28ZblHlMVZ/qyoZQWjHAx8u+iYtkL9o
         5fFT2i0YDyrIBZERTI55qYqqctnyvv2kXiGpeWCriZqHMCKGdWK18fOC+7VlJ6btOs1g
         LcUOUUtFwImraPBF8pyeB6OyDBuBdsFg9IKY3nP6oBmdeezD3DN5+D5/FCorUSk1Pvzf
         kJh05wcY3nWS5etZiCkBsnKTkusmx2Re7L3AauyxYCsC/5yJvkCof1Plub4x0qyHGic7
         gA8A==
X-Gm-Message-State: AOAM531QEKZ68O6VsHoJNcIVsCUMaXAINV2GC9jONjVOqTYNxAa1R2bd
        Z+wB2gdz9OkkH0F8clZyoWM=
X-Google-Smtp-Source: ABdhPJz691gm0fYOVElrX0EBUzqGOtVHdXHSZAWWgkdG4CBDdqxmnQntiGDk+F5zgjsA4dfNBwA3Ww==
X-Received: by 2002:a17:906:935a:: with SMTP id p26mr2570633ejw.30.1602490919982;
        Mon, 12 Oct 2020 01:21:59 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id oa19sm10244356ejb.95.2020.10.12.01.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:59 -0700 (PDT)
Subject: [PATCH net-next v2 12/12] xfrm: use new function
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
Message-ID: <a6b816f4-bbf2-9db0-d59a-7e4e9cc808fe@gmail.com>
Date:   Mon, 12 Oct 2020 10:19:59 +0200
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
 net/xfrm/xfrm_interface.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 5b120936d..aa4cdcf69 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -541,27 +541,7 @@ static int xfrmi_update(struct xfrm_if *xi, struct xfrm_if_parms *p)
 static void xfrmi_get_stats64(struct net_device *dev,
 			       struct rtnl_link_stats64 *s)
 {
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct pcpu_sw_netstats *stats;
-		struct pcpu_sw_netstats tmp;
-		int start;
-
-		stats = per_cpu_ptr(dev->tstats, cpu);
-		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			tmp.rx_packets = stats->rx_packets;
-			tmp.rx_bytes   = stats->rx_bytes;
-			tmp.tx_packets = stats->tx_packets;
-			tmp.tx_bytes   = stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
-
-		s->rx_packets += tmp.rx_packets;
-		s->rx_bytes   += tmp.rx_bytes;
-		s->tx_packets += tmp.tx_packets;
-		s->tx_bytes   += tmp.tx_bytes;
-	}
+	dev_fetch_sw_netstats(s, dev->tstats);
 
 	s->rx_dropped = dev->stats.rx_dropped;
 	s->tx_dropped = dev->stats.tx_dropped;
-- 
2.28.0


