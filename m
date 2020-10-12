Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E31028B015
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgJLIWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbgJLIVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:21:53 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AC2C0613CE;
        Mon, 12 Oct 2020 01:21:52 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id c22so22023367ejx.0;
        Mon, 12 Oct 2020 01:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K5p6PQe9PHlb+DeFu3qCLN+dyNKfD6AR/iCNZWeTJCc=;
        b=u6vzQZjpjUwAoxgsdIvqGoW2wscsD+27fYStwCH0/DAdwWm40pGzmqma6NZfzR2nY4
         FraHh5xiK/XNO/MGkH2q10HSSExTebIq4cBbJ5G0a+fA1d5/0R0JL0xHn2iWHdC4cXjh
         3zcrCQJXT974X8B2at1b6ft2C7z6Wni/rrcSNWwAS16OOfclGUAxh3qlA5QQYpmDMr5+
         SBfTMY55MMCVP6q9lIzHYl9Lf8zxTCzI/ADBY5mYJYrF0q9NQxICntDL6447ROzmLpbJ
         ccZIbeOlF2Vt9eZEOvuJCUrmFAhAZZYOBEGA6EH4/cDWprQdM7QP/i/4RE/eeApna4oe
         wlwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K5p6PQe9PHlb+DeFu3qCLN+dyNKfD6AR/iCNZWeTJCc=;
        b=a+CpWMryDOscdStr5eHe0d4DCeR1BoG9ICCxBEVVGSSVqVlm4Gb+HvVRuAM9W8Pzc1
         csvb/3X+caN624L9Lxg/ICIW4f7kQyb3LcqsoktbXxisbGpdXNjyu4scFFSVPsHE1/Up
         VZOzrlcp26zjl+T2pm0vuF97LPE0/KAWInI5/a/UDXvX4Qy1K4EwknCv8rPJL697ojLT
         PZKhPrc98NrvIW1p9BdNQEx6IRP2VVR8OflQfrpPnbh642wctnTu4LxfRhQLh/UNEi95
         3xYZc53RBEHUWL15K9MrgRur4f0hj34VVdFEGsZsfebQu4OAeqzRmoheKlFqz8lPbLKg
         lQ+w==
X-Gm-Message-State: AOAM530w87t82TOBZIVbltJIlvE+WnCRPXaHn4Gnzd8CNZ//pD2cNlm2
        p2WGsjtnBg7+g0uh+xO3sysqmedW9y5B8g==
X-Google-Smtp-Source: ABdhPJzpn3UQ1NZ0j3vtYPuMV0pGk+0sppVmn15F/C759IM7WrJi58wx79UeJABZsLX6vgSyVZ/9pA==
X-Received: by 2002:a17:906:ae48:: with SMTP id lf8mr15228828ejb.345.1602490911396;
        Mon, 12 Oct 2020 01:21:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id q27sm10354699ejd.74.2020.10.12.01.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:51 -0700 (PDT)
Subject: [PATCH net-next v2 07/12] net: bridge: use new function
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
Message-ID: <d1c3ff29-5691-9d54-d164-16421905fa59@gmail.com>
Date:   Mon, 12 Oct 2020 10:15:22 +0200
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


