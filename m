Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B49728A9D3
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgJKToj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgJKToa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:30 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CB8C0613CE;
        Sun, 11 Oct 2020 12:44:30 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g4so14768226edk.0;
        Sun, 11 Oct 2020 12:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EZ+IbzJK89SwFCG1NFlS+aDcNGqO/ZCcv8sBQgOTnbQ=;
        b=Q5lnieRyCQZ5zd2SF0Mk3WmIFGDyUVUssOdeCD8lc3yUbDMmQSfIceUIZDJD1ziTid
         UpdveLcfluozFcho52hX0WGEcaEWmht89BDElLcj+INusCxDIn2Hi+5O6wD9d9+9TIP/
         UHyu9yRinC5Drnjr6IXrCJs2aWVdbE25MyTxaf1Ix8mpwK+FWjqVyljpzTOnRIXq5fnm
         6orjO3HjwdCHFmSUftqjvZ79fMoVK8qan/oR6kSI4oppGq6v+wOpTCceAL8xANG9k7sy
         jr+R89DabS/rK67qjxd/DP7Oim1OIOLONfuTd9J0yeqRvpjAa1AfDnwSk1xYXZ6/R3WS
         4CaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EZ+IbzJK89SwFCG1NFlS+aDcNGqO/ZCcv8sBQgOTnbQ=;
        b=aeiz70dD/PR3/eDzo2RSaDF45C+LAsIv/lz7qj3AuvyWdu4smkG6Zm6pUo3vknLWnr
         AX7QAF5FpX/EtGILnmhWAbTwRjtQaTJBj8Zl6iTeUsQy6sGgK4UWnkzjf4Q0DW9/vGaM
         83c8rH0Q++GbWvQDh8QcfxsCggUsDnlJqM2Vn+ZA2w6u5nOnnz9bZ36JlViovDJvT8BS
         +4PB4CN6zdUWYB9a3faBRcHAmQkNcGP6s5UhJ7wADo0vXMkLnHkpkHT8tb2Q0VoLgSDZ
         suy9pMFrZZR/v4bie1PjOxSrEolhhM6FNrYeBSasibXKxs5I1GiFcQgIlYUBWmdKkOF8
         TU+A==
X-Gm-Message-State: AOAM532/Cm6ZJi85TmSWhBZuhHrbNnx802T5mvX3J0y9OGOFS5AmtNK5
        7h6L8p4CM9me5Z7C7yNsGQI=
X-Google-Smtp-Source: ABdhPJywQ+R+H1rk9eh41GmJjhl4nVCXD+sXnrNDIy47ZFPHuQj6lo4yAA1QYX1bBk6TeUjRVsZwpg==
X-Received: by 2002:aa7:c683:: with SMTP id n3mr10332705edq.146.1602445468817;
        Sun, 11 Oct 2020 12:44:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id k18sm9421345ejk.42.2020.10.11.12.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:28 -0700 (PDT)
Subject: [PATCH net-next 02/12] IB/hfi1: use new function
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
Message-ID: <b87c6e8c-13f9-831f-a65b-0fc7707e658e@gmail.com>
Date:   Sun, 11 Oct 2020 21:37:27 +0200
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
 drivers/infiniband/hw/hfi1/ipoib_main.c | 34 +------------------------
 1 file changed, 1 insertion(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ipoib_main.c b/drivers/infiniband/hw/hfi1/ipoib_main.c
index 014351ebb..9f71b9d70 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_main.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_main.c
@@ -97,41 +97,9 @@ static void hfi1_ipoib_dev_get_stats64(struct net_device *dev,
 				       struct rtnl_link_stats64 *storage)
 {
 	struct hfi1_ipoib_dev_priv *priv = hfi1_ipoib_priv(dev);
-	u64 rx_packets = 0ull;
-	u64 rx_bytes = 0ull;
-	u64 tx_packets = 0ull;
-	u64 tx_bytes = 0ull;
-	int i;
 
 	netdev_stats_to_stats64(storage, &dev->stats);
-
-	for_each_possible_cpu(i) {
-		const struct pcpu_sw_netstats *stats;
-		unsigned int start;
-		u64 trx_packets;
-		u64 trx_bytes;
-		u64 ttx_packets;
-		u64 ttx_bytes;
-
-		stats = per_cpu_ptr(priv->netstats, i);
-		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			trx_packets = stats->rx_packets;
-			trx_bytes = stats->rx_bytes;
-			ttx_packets = stats->tx_packets;
-			ttx_bytes = stats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
-
-		rx_packets += trx_packets;
-		rx_bytes += trx_bytes;
-		tx_packets += ttx_packets;
-		tx_bytes += ttx_bytes;
-	}
-
-	storage->rx_packets += rx_packets;
-	storage->rx_bytes += rx_bytes;
-	storage->tx_packets += tx_packets;
-	storage->tx_bytes += tx_bytes;
+	dev_fetch_sw_netstats(storage, priv->netstats);
 }
 
 static const struct net_device_ops hfi1_ipoib_netdev_ops = {
-- 
2.28.0


