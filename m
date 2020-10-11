Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC528A9DA
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgJKTou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgJKToh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:37 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF7CC0613CE;
        Sun, 11 Oct 2020 12:44:36 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g4so14768457edk.0;
        Sun, 11 Oct 2020 12:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HcgZso4dlrbNJuP0fFxlU7lkmi2zmfh379PdA4iECrc=;
        b=QY4mcdUm4pOsXKuF8fPkL2a9wiqaVDmyjAXCWkd343lchJ1AGlmk23Ku3QohtqXRSY
         gYveZNpvVXpGKsy9mIhgSIssPBHZz8bN3VkKwEVEkFMyH2q2UXxISQgZVCL7TgWLhS4Y
         5SSoaAuPWUpibQT10V8O6530abeLX72cFOf1hYrs7jG+3bwYkJFvUXdSZ7DlPaJ6iQUk
         2JvYjgIhOzxl82dwwTIqTqSkfluHOoAwz/+d2jDYQ2YnplEmZVUhkXixCn68btqAx4lE
         P3SfPjXNfEFLWyohoaU0E7FNHggtTNHhqlLMd4anSnZzIIb9pNutyLyAKpTbahH+rn1Z
         8aHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HcgZso4dlrbNJuP0fFxlU7lkmi2zmfh379PdA4iECrc=;
        b=EmUU2JKhE0QdNtyjDyKau3lqOzSR/Vtv1T/Qxx5HTnCIjuxFAMxvm9F/2ASzk9n01E
         LRSBDyrs0FqzTY3fK5PDEDl8GmucFMH1ohMmU/JxAmOLznDM4v0Gzq+ofelSXj+6sJOP
         XKUu5qAklZPwNTewdPzb15S0elIPeXeZ3eUme0l0c1Ek/MD/QnvQevYm7b03PwWS4xEb
         FmuBhPJywG+BuClYvHuAxroPzHPmY6ItjhvgUMSFJ4vG+iJ+ZdpB6aU2ortxGnMGvorV
         4i/TyD1Z/CjEd9+yTCcTV9Qh+tOaJcH/qlEsWqdPrS60FMD7b3kAoma2guxqV+k5H5ql
         3kRA==
X-Gm-Message-State: AOAM530Eta8KHcV6YDYho1uMUnR1lgA41br3yz18UVBeEUQCdLPqyJ8l
        0Ah2CeaRQGZq84Z/aO/ur3Y=
X-Google-Smtp-Source: ABdhPJzG5QywNit+P8d8Uluj4OvMnvqXvNL7PFD8bzCEkoG7VRaC2GxtiI9QRmC/zoabKFb+FRsSVA==
X-Received: by 2002:a05:6402:3c1:: with SMTP id t1mr10191553edw.231.1602445474908;
        Sun, 11 Oct 2020 12:44:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id q1sm9747574ejy.37.2020.10.11.12.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:34 -0700 (PDT)
Subject: [PATCH net-next 06/12] qtnfmac: use new function
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
Message-ID: <a4fa20e9-23bc-4f2f-cbe9-16d801ce3b20@gmail.com>
Date:   Sun, 11 Oct 2020 21:40:10 +0200
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
 drivers/net/wireless/quantenna/qtnfmac/core.c | 27 +------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 374074dc7..7f66cf608 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -139,34 +139,9 @@ static void qtnf_netdev_get_stats64(struct net_device *ndev,
 				    struct rtnl_link_stats64 *stats)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
-	unsigned int start;
-	int cpu;
 
 	netdev_stats_to_stats64(stats, &ndev->stats);
-
-	if (!vif->stats64)
-		return;
-
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


