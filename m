Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C078728A9F0
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbgJKTpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgJKToj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:39 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35143C0613CE;
        Sun, 11 Oct 2020 12:44:39 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e22so20353944ejr.4;
        Sun, 11 Oct 2020 12:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WQbLDoFSeSltH3nftOw/NOzLE5EP1LZ6y+xL/a85h+w=;
        b=GRfTQACPyYtR9pqybfVbLmIpJpuRl0C7wsrFoWXj0QX2wcH42Nf5udem/k1aVfah6x
         5vyHB7w2Bv/AM6CamTx3zwA3DYcGCYNGJArU2vV3132pEcwY9490f1rV9XqSsKjP2P6P
         uxm6ihfKy1Z0s9suALkvOACSWG9AS0rfoXB5Ev8q5jjvCRxdzC5SialMoEui+aiDT2OO
         Nav4/AveRUsUVI91sXydnB/YWzuq6GtOeFMFMELGgiFo2RLcSvAabyKUnJK34V7pMJII
         op63g+Mx29KT9idfNKqGYQ0Z3lXoirpktiUjywSNtNwi0K3Dd9JCFhi2raiJVTREJtBZ
         jn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WQbLDoFSeSltH3nftOw/NOzLE5EP1LZ6y+xL/a85h+w=;
        b=jZ0aWFPBXjPS2MHEao0wLymGxrcNfj8S/2IadXNfHTah75cdPNKYM2Mi7/BlyOMhi3
         n4b6uzNt52fY4QfbKZ4uKqXmP1/P00CKdaawuao6s/+B7V96xDh7oMSBVQPj0xaRGLGD
         Ba91Y/nUbj7y1FJIStXbeeZc2Vn+zlV2OWBtay65PqMeGSnhN+25oUeGivUOw916AmTI
         pPsSFo4PS5zejPUfOb/cwpwfrYWa3nhB4CN2lDVGZGUJM7hEiJFpI/Au0Y8MV/EIXl7D
         9qTyHhNW5+hxdeN0ESTcJbZPuIEFXdXxLY3FhB6NWiMn08FeQjpehBLcjLfAZh7hM68y
         uG3A==
X-Gm-Message-State: AOAM532QWdaqkDPgyH0EPpOn3B74NeRsN3a7RJm03RvVc8GyE4vF+JuP
        14IE7sndkrlhTHqxLkIhK3g=
X-Google-Smtp-Source: ABdhPJwypu1FksPcYviHGb0G07n2BgDDWUAYOGS5F17YYuqk194tB3z/pT1ejI1KbvTYlJisRN0Xdw==
X-Received: by 2002:a17:906:9702:: with SMTP id k2mr2309183ejx.494.1602445477904;
        Sun, 11 Oct 2020 12:44:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id o3sm9487479edv.63.2020.10.11.12.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:37 -0700 (PDT)
Subject: [PATCH net-next 08/12] net: dsa: use new function
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
Message-ID: <4c7b9a8d-caa2-52dd-8973-10f4e2892dd6@gmail.com>
Date:   Sun, 11 Oct 2020 21:41:27 +0200
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
 net/dsa/slave.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e7c1d62fd..3bc5ca40c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1221,28 +1221,9 @@ static void dsa_slave_get_stats64(struct net_device *dev,
 				  struct rtnl_link_stats64 *stats)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
-	struct pcpu_sw_netstats *s;
-	unsigned int start;
-	int i;
 
 	netdev_stats_to_stats64(stats, &dev->stats);
-	for_each_possible_cpu(i) {
-		u64 tx_packets, tx_bytes, rx_packets, rx_bytes;
-
-		s = per_cpu_ptr(p->stats64, i);
-		do {
-			start = u64_stats_fetch_begin_irq(&s->syncp);
-			tx_packets = s->tx_packets;
-			tx_bytes = s->tx_bytes;
-			rx_packets = s->rx_packets;
-			rx_bytes = s->rx_bytes;
-		} while (u64_stats_fetch_retry_irq(&s->syncp, start));
-
-		stats->tx_packets += tx_packets;
-		stats->tx_bytes += tx_bytes;
-		stats->rx_packets += rx_packets;
-		stats->rx_bytes += rx_bytes;
-	}
+	dev_fetch_sw_netstats(stats, p->stats64);
 }
 
 static int dsa_slave_get_rxnfc(struct net_device *dev,
-- 
2.28.0


