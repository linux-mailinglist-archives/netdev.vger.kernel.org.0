Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C7128A9D6
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgJKToh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgJKTod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:33 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9D3C0613D1;
        Sun, 11 Oct 2020 12:44:33 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id lw21so20328975ejb.6;
        Sun, 11 Oct 2020 12:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GOIK3Hq+WKcGwLhTgVcjjfr06Gc4T0D1ld9TN3UCVLk=;
        b=ak9qyYGUS/U3E7+fqKubKrZLUjAKvhb5C7ccuV+XENvdJ6qznvZ2FmEuZsE04zT+Bb
         pgBBsU8+QXgI9zw+6dsTfR75KDCqVtJ2MvmuKgSpfqiX0nbQ+bRrtJiPhhwkKtzSybdY
         wcNaUW5gH5oQ84Jhoynwt0AwviYe/rMjqcytLiAPOJxWrH6wYYUIsM1Rfu/taPd1XF7h
         TbJbIjw8Z68xZLGS2UMDeCLXLamJ1VM2Earj8w6IyiwrZLdut+ATAyuT5b1o7Bujm4SK
         y5nPoaZLubDDb3DBoa+bkCTReCWgmr38aSNg7Y3PXXcBjvcNlqgn4aTnDgYoSJ19F2S4
         hwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GOIK3Hq+WKcGwLhTgVcjjfr06Gc4T0D1ld9TN3UCVLk=;
        b=hg5QOnenK3p5QqTC3HFs506VdEe8bMMaAnc37RaIV1N9tTQgkuasfsV0tB8WwF5gO3
         FpcEuSfxNSJm6TsB98HGliXnqrF9Z33HLgG5G5bsgGdsvmWoN24AOFecU7ewNIHOh1no
         7CQdRSR92tW5POSEDFq0B9P37aYwATz7ke4Ca+i5D06bfwJoJVNiB3MedRbYdCl7B7GG
         B+dfx7oX7eDGtEECNStNNqL4BIzuRENEiNfDe/9o6RinY13pDKGQLDHD3K4KW0xdECsl
         yTrEOIOSMaD1pHez1raV6uaJEbiuGmvbHoJ5YRYRVJlPf04kyC7502qq09B2tTooLxBw
         5PXw==
X-Gm-Message-State: AOAM532J7s5KEFVnQO6Vuy90UsGANSu4C67peGn/erLp/ueh/xikDbAx
        v1fQWX2GUTnoAXPqaUCK5os=
X-Google-Smtp-Source: ABdhPJyAzc9Sk1A8caGl+hCGaIAJ01fKrSLPSH3KAJAeZ/TISr185eyHMYYLC4sIDCTQCQp5NYVRNA==
X-Received: by 2002:a17:906:cd14:: with SMTP id oz20mr7328506ejb.7.1602445471848;
        Sun, 11 Oct 2020 12:44:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id e4sm9728173edk.38.2020.10.11.12.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:31 -0700 (PDT)
Subject: [PATCH net-next 04/12] net: usb: qmi_wwan: use new function
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
Message-ID: <9cde03fe-d032-521d-2d34-34429d6d1a1c@gmail.com>
Date:   Sun, 11 Oct 2020 21:38:44 +0200
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
 drivers/net/usb/qmi_wwan.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 5ca1356b8..a322f5187 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -126,31 +126,9 @@ static void qmimux_get_stats64(struct net_device *net,
 			       struct rtnl_link_stats64 *stats)
 {
 	struct qmimux_priv *priv = netdev_priv(net);
-	unsigned int start;
-	int cpu;
 
 	netdev_stats_to_stats64(stats, &net->stats);
-
-	for_each_possible_cpu(cpu) {
-		struct pcpu_sw_netstats *stats64;
-		u64 rx_packets, rx_bytes;
-		u64 tx_packets, tx_bytes;
-
-		stats64 = per_cpu_ptr(priv->stats64, cpu);
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
+	dev_fetch_sw_netstats(stats, priv->stats64);
 }
 
 static const struct net_device_ops qmimux_netdev_ops = {
-- 
2.28.0


