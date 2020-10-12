Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D4828B008
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgJLIVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbgJLIVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:21:50 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81021C0613CE;
        Mon, 12 Oct 2020 01:21:49 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id u21so22000520eja.2;
        Mon, 12 Oct 2020 01:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pinXyNbLzNVPX/bjvrXpQvjJmZP5stTSjNwoOuOjf58=;
        b=YIWmvaXj7toieBiR6u74axTiOYjNawVWVtnHUyzNWXykWBn89aGaVyvF2haYTaAskF
         jjgPJIg550NZ0VDgYrXna3lBgTWA8Z6sK/nB4o9vWcDFD/u02S1ilD8dorfma/JoyyYB
         mMYHDCKYtOpROJbMbPzz3JLo74hKj1Iy0uOE4Hcjp6O/K0iTauIgpVp6CQyCBwpJVjlY
         0LHrbQIbAeJx7vxB9Oap2QLNBhXOyobXyaYc4zVE5ZbL1P+7UwIgIS/1P26x7gUndJng
         3ENBnQVP+YMBJ9+uqKlnKlRD1E8LYrMZypcQp2lhUydsh1gi7Grpu3WO831Lx14+H3WH
         KB4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pinXyNbLzNVPX/bjvrXpQvjJmZP5stTSjNwoOuOjf58=;
        b=JAphHkob91B6DQE695/v2YEHY7+L5M8h4l/86tEhAo0TedkvZqHx+dHQ9gr0iJTO7p
         VHPnqaFVv4RkELS8npz9LMF3cuImD6LXvXpnCKkMIqoyy1lX8Eg3CHTWonMry/U3FSof
         2mAjsOiquaDh2ac+Xn7lU6Xv+svAJbF0m3mmrHKoPw1Wbc+ki5Sc5XSyUN3BTtpYyPwe
         qmb8DAkUR9r0DenuMFBbE7twbR9TRJ10WulLZBABoqjWXvHkXra8fh7/hRC7MICQwmO5
         cAxgMlxOOMCW4O1+EuNt/8tu5WYX1M++JiJVcYxQoh800uC+KKY04cjOK1zH/9p6Uf/h
         PnYg==
X-Gm-Message-State: AOAM533Eq3Et9WpulZfv8RCEXDgjKjG/YlfYk4+E9VoPHffdSA9L8guW
        QpZ60JSVmvRGO4ISmOXi3+A=
X-Google-Smtp-Source: ABdhPJw2bnUJbtCuziDVxBntmS/1DOzHEWat6ryyl6+Lnf71IgL4kFsQqFK6oNkIj97r+IUGer37lg==
X-Received: by 2002:a17:906:8519:: with SMTP id i25mr26774698ejx.76.1602490908123;
        Mon, 12 Oct 2020 01:21:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id h22sm10232665ejc.80.2020.10.12.01.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:47 -0700 (PDT)
Subject: [PATCH net-next v2 05/12] net: usbnet: use new function
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
Message-ID: <70ad3e33-8ea6-e12e-31de-5fec7a3c4f6e@gmail.com>
Date:   Mon, 12 Oct 2020 10:07:33 +0200
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
 drivers/net/usb/usbnet.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 963d260d1..6062dc278 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -983,31 +983,9 @@ EXPORT_SYMBOL_GPL(usbnet_set_link_ksettings);
 void usbnet_get_stats64(struct net_device *net, struct rtnl_link_stats64 *stats)
 {
 	struct usbnet *dev = netdev_priv(net);
-	unsigned int start;
-	int cpu;
 
 	netdev_stats_to_stats64(stats, &net->stats);
-
-	for_each_possible_cpu(cpu) {
-		struct pcpu_sw_netstats *stats64;
-		u64 rx_packets, rx_bytes;
-		u64 tx_packets, tx_bytes;
-
-		stats64 = per_cpu_ptr(dev->stats64, cpu);
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
+	dev_fetch_sw_netstats(stats, dev->stats64);
 }
 EXPORT_SYMBOL_GPL(usbnet_get_stats64);
 
-- 
2.28.0


