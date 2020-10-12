Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CED028B007
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgJLIVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgJLIVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:21:46 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32564C0613CE;
        Mon, 12 Oct 2020 01:21:46 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id o18so16000578edq.4;
        Mon, 12 Oct 2020 01:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KFsZNGzDx3aV9CBTy2OuwyFykIUFu3usYnhhVM1hRRA=;
        b=Xmk4y4x522mXEH+Dhh4RrFypK4roS1v/xIOaX0lr0EZq27TaCNE5OZORYclY3v3o2r
         eP3NMqn+4pUQLmpYKg7wehIGmg24sF+V8wC2AYunxZvEsdHiPwZgjNakCons7Yvfss53
         NIxxAZ2kDrjvgpXioN4FIN/07nmPdNNRsCr5/fLGLNriL9DJvJaHtmHcDvpsyN6OCpF3
         g3qvkvaYv+zFlMlI0+trdkTAyYVsOfNQsNYLpPStxXPd4IVqAyUOgOJQi4iACnIndZGZ
         1EJ/k1a3TGNlZxxSlUmVxfqfwo03c6W4uDKplq+kdP0W6/DQ6qrzLOM3ljaQ62jwmr/S
         W8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KFsZNGzDx3aV9CBTy2OuwyFykIUFu3usYnhhVM1hRRA=;
        b=hB1nfURggvS65u4+qS+7kZTrlmBSjapDndW1xo1ig/LVmSeDT1s1br/MHodikFOK6E
         Urhh954OrpwM0YukZ8dYCaIwyNIwClgTSBanoRi21YaMgjrNnTAcVsvFxWKMew5IVrBV
         jVgQOZhsYp/N49C6+6LZmceAdXsMvjJ5zNi/yakZ9J9enObj7/6MPU4wMUyNf/4HaQu4
         MHacgXVq+AFlnjPOc/b4asKTe9hThNHMM21ATwV7fW4df07EaVSOuiLLNrbZyf7KTUab
         lC1R25kgdHGHxfbrRyt4d9eYq0jH3mteAPVQwPrTiK+oLIomRfc9mFB6JS9udasSiAiJ
         X59A==
X-Gm-Message-State: AOAM531TaV39MPjWhCOjGve9ch1VWrfXxY/JRJifB1D1Nxz7YBIhaFcR
        PC+f7GahuCJZa8Eh58JXGkw=
X-Google-Smtp-Source: ABdhPJykp+lxaaGcdX82HGw6i6U1SxsR+4RCLYM9xJ2P7D+cDQN9lVoCdoC8oc8SfhJ4/15Hw0r1ZQ==
X-Received: by 2002:a50:88c6:: with SMTP id d64mr13155125edd.141.1602490904884;
        Mon, 12 Oct 2020 01:21:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id q3sm10177923edv.17.2020.10.12.01.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:44 -0700 (PDT)
Subject: [PATCH net-next v2 03/12] net: macsec: use new function
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
Message-ID: <0d81e0f7-7784-42df-8e10-d0b77ca5b7ee@gmail.com>
Date:   Mon, 12 Oct 2020 10:04:11 +0200
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
 drivers/net/macsec.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 2b0c8f01d..11ca5fa90 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3647,30 +3647,10 @@ static int macsec_change_mtu(struct net_device *dev, int new_mtu)
 static void macsec_get_stats64(struct net_device *dev,
 			       struct rtnl_link_stats64 *s)
 {
-	int cpu;
-
 	if (!dev->tstats)
 		return;
 
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


