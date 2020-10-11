Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D539D28A9E5
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgJKTpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJKTop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:45 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787A0C0613D5;
        Sun, 11 Oct 2020 12:44:45 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g4so14768794edk.0;
        Sun, 11 Oct 2020 12:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t6mBah8f7Cbtv+XC/jNYzc0qx0/PRMeIzqK4sBdTEL4=;
        b=rPx+oLh0oDeejrIAjThcqiU01bY+NR/k9Ak/q2AE42r8Gg7pRz3M+Uy3dqcWg/5a0y
         sU6Fu8p8hMgV+DxLdyXWUXNi/WlICSn/J74p/bkR5B8QMpgSNJ7i78VvvbKZTvTWUmUO
         ssIM5hWV8fer6aBzRCJ3ILF+cF6tNEy173XU7jOQnTqZ7TmIGacbgP1mzVWthRP4ZkfF
         n6sU8bfkOVjw3SuQlW30E4i4blnq1TTgch31KKRt16pVpCDmYF4xhrum7E1h5HVGQl0k
         YF6X/p8B3lKJqZLDYJYVza3bSDkW/GBL26emjt3oHzNjoXOna1w3iNOSMd0OYAoxPq2H
         jTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t6mBah8f7Cbtv+XC/jNYzc0qx0/PRMeIzqK4sBdTEL4=;
        b=QrU48prxfFnwpIUIYlpgO9u+YHbaBNaOeIBFI9wnbhwVEg1OTQEZ9VYyqe3zRQ5s7u
         AesB9AMSjI0J1RgoRXjPlSW4SJVbyTtSRNwxJr0nkh5mmEs/S+Y4Nd1g8SiM/WPUu9Wp
         osqTtsKH+7Fxlw72qjlrOai1/PU22djKjYISb6hkr73ln4D0yW7o9vOcHVI6BJ/Dmaua
         GveX3YeHk2Db4fORzNREvg32Ngib5WUPqn9RBL71ukBLqvFiWMlQWbK6pIzX5GRDhZ6m
         6zdabCHjIw3TR40mawMopq8e5UjxuCfcWrjuY4YsT2gnX7BSr1qAnVoTAVdVqTW31r2c
         9dUA==
X-Gm-Message-State: AOAM530DkeqnO+aO3UkbXy7fMoJGuzHlq5a3mqCbQOF8nSbSC0k2rj4f
        mwOYi5cyrbj96/YPSeXHgAs=
X-Google-Smtp-Source: ABdhPJze22jzr28NBfMCWqu+FyuYjUDaaRfQd4k9/kJxDSiAjQKlgPzLiPicrGF5qB1uFU4ILMcjtw==
X-Received: by 2002:aa7:dc16:: with SMTP id b22mr10482539edu.252.1602445484162;
        Sun, 11 Oct 2020 12:44:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id s6sm9816029ejx.79.2020.10.11.12.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:43 -0700 (PDT)
Subject: [PATCH net-next 12/12] xfrm: use new function dev_fetch_sw_netstats
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
Message-ID: <b0edee7e-4594-e3b3-ea75-68b4f33509df@gmail.com>
Date:   Sun, 11 Oct 2020 21:44:02 +0200
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


