Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAFF28B014
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgJLIWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgJLIVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:21:51 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2914EC0613D0;
        Mon, 12 Oct 2020 01:21:51 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p15so21971920ejm.7;
        Mon, 12 Oct 2020 01:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QgEFAZvIGUs9d79dSBvM16GKW6VzPnxLl+Fxh+U3V5E=;
        b=smMjqkLUc83TdlNXcDcI3M3/ULwnTf55iu2dvwq3DZB3ijaghGEg1QucVM48Q59Xei
         PhCJRKNkGb6mEr/MRzSqyVNV4fflsAxkglH2EZ7WsMPP0qYCAMMKkJfrlb0Te3v932Kj
         u04qGb9yhQ1k2CE2QwduucTZPxyUTXc6f7vZLCvLmEUzn/FDxBGxmAIpH705hS2LrQ/+
         +SOYOqNpqZrunAzwqopXYlPOD0/GDk4BgwqEYxQYMykZ+qxKMd/llLUBmr2yahu1s5mQ
         T/ll3jwrsNZlgaP76L6IGirBg7GpdPamcuyboxa4oE4J03+nQ3j2KUDK6SR2oN8ZurC5
         kFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QgEFAZvIGUs9d79dSBvM16GKW6VzPnxLl+Fxh+U3V5E=;
        b=jvsQO+bCRycEugMQ7gPDYNqZXlnjLP1T1TMwhWDwxWtKcTresq5f86KiL7BEjKijo8
         LKmkiiQp903+aF08ZRqqWU435vsmqO3HEWBcminolpODrImgacWDz0qoDJi2ADMUSfrR
         rd8PKjd+TkTMMrGm6W1SUOpLw69/8aIq9ThmvsxcrmtQdRFlE9XPMAZe/2NH5cZGgCa3
         TJvCZrHsK8Op1z2kunkRG7yVG1dfF21j5MdrrI7GUDQWzON1gTDrA6KOOzHpdYPWp9mn
         HVXFq4EaJtZBXuArXY0+MYYlgeAwHBlzuPgdXUyfcDY+otUQrrEZ471foCoqm6wJEQYE
         er7w==
X-Gm-Message-State: AOAM532/ALYxLVzAqhDtbErsXOcYNX4OJy4mrqHCbQd2fyJ3TyNvUw7n
        gJw05run25BZA4l8bBB67lk=
X-Google-Smtp-Source: ABdhPJyLRdlG9ykmhX1eEdrQT1Otm/9oE2nWPUWVssRBAX1UfhecwcY5LXaqbq8XeUhyDJxeQhtshg==
X-Received: by 2002:a17:906:82d7:: with SMTP id a23mr27024407ejy.66.1602490909845;
        Mon, 12 Oct 2020 01:21:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id v6sm10439545ejj.112.2020.10.12.01.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:49 -0700 (PDT)
Subject: [PATCH net-next v2 06/12] qtnfmac: use new function
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
Message-ID: <166259f2-084c-45d7-e610-2de2a0bdae06@gmail.com>
Date:   Mon, 12 Oct 2020 10:14:08 +0200
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
Acked-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/quantenna/qtnfmac/core.c | 23 +------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 374074dc7..bf6dbeb61 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -139,34 +139,13 @@ static void qtnf_netdev_get_stats64(struct net_device *ndev,
 				    struct rtnl_link_stats64 *stats)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
-	unsigned int start;
-	int cpu;
 
 	netdev_stats_to_stats64(stats, &ndev->stats);
 
 	if (!vif->stats64)
 		return;
 
-	for_each_possible_cpu(cpu) {
-		struct pcpu_sw_netstats *stats64;
-		u64 rx_packets, rx_bytes;
-		u64 tx_packets, tx_bytes;
-
-		stats64 = per_cpu_ptr(vif->stats64, cpu);
-
-		do {
-			start = u64_stats_fetch_begin_irq(&stats64->syncp);
-			rx_packets = stats64->rx_packets;
-			rx_bytes = stats64->rx_bytes;
-			tx_packets = stats64->tx_packets;
-			tx_bytes = stats64->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&stats64->syncp, start));
-
-		stats->rx_packets += rx_packets;
-		stats->rx_bytes += rx_bytes;
-		stats->tx_packets += tx_packets;
-		stats->tx_bytes += tx_bytes;
-	}
+	dev_fetch_sw_netstats(stats, vif->stats64);
 }
 
 /* Netdev handler for transmission timeout.
-- 
2.28.0


