Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815FE28A9E8
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbgJKTpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgJKTom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:42 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68809C0613D1;
        Sun, 11 Oct 2020 12:44:42 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id c22so20364789ejx.0;
        Sun, 11 Oct 2020 12:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m4bUmyI+LcL2kRpVckxE5LM+etyYjhNnBeXZhGHIk4E=;
        b=JUFyhhlZn+ptpsepXb1APxQLXmKc+A0UsqSaItDHceRBS1uFfQtykf8t35FDOfwehx
         BjY3ka/KZKHhmzb3hJq4RTqP9Vf7yO1TZtFwKQJZOp5365c7oUF9WlXHLeLPsyeWW1Y1
         Il2+Koe5lEP4rCOvaECTtv7h1u2kkfEaong9M1gEfRlHvDeNQ6fFbuG2jN6t0SmAm1iY
         MZtLjBE3JtV6R6gckMWLqd4awrHduTa63Nvyy3I1zvyEIsQYxghczsg8OkUKJ/wHv1+Z
         PzNWuc0OB7oUfG7q7TILqqsQVaXhCtVC/dEbI3JyGy+Wj2kM0dS3BhArtpvOxozdV45q
         OgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m4bUmyI+LcL2kRpVckxE5LM+etyYjhNnBeXZhGHIk4E=;
        b=gKaH/AgO0eEGnDLsMFV8/2uhcUKee7lfXS9EXNa5MHaFdf+rWNfsdKgDJO+quLBaa0
         vlkUkhxHN61E4HG0CPeZVLiIlu0IDOPh7hOSfhSNQfS9MWoYRdJeONr/l90KEZH0Ypat
         67ON97QjBgc5nvgomfPo0yoeK2s16kKYmQWngFTsny/p0pYzwi/L6TSRhJ5dn3rrID/Q
         zNdLh1Ycf+++o3ZrD161ft5lD8fPov+n2NAwCHRhbS09FXR+LD22MX2wlcuda5t+Jt7g
         cVIC3Gn9eTzTDqzBmyuMBewIcvKz+AFKIgmI4eVkvLYgbYgTciY90zF+uXE+YyDxl0kr
         9kcA==
X-Gm-Message-State: AOAM5319IFh4SF61tF7wDhzRSwOxJIdXNG2kDwTl6WslOUyqegM8HkbC
        QgVJMN8BSyIRbU1Y1Lmee3c=
X-Google-Smtp-Source: ABdhPJw3QQE9NOsliPu3kGa6iur37agafRxYe0O7p7sWZj+QCIGjIvsQqYnuphiMVdJoNhrsCd5yaA==
X-Received: by 2002:a17:906:82d5:: with SMTP id a21mr24499463ejy.548.1602445481119;
        Sun, 11 Oct 2020 12:44:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id j24sm2070303ejf.21.2020.10.11.12.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:40 -0700 (PDT)
Subject: [PATCH net-next 10/12] mac80211: use new function
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
Message-ID: <3b4e5d1f-16b3-dfa9-2f43-7061edbf9b1e@gmail.com>
Date:   Sun, 11 Oct 2020 21:42:43 +0200
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
 net/mac80211/iface.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 240862a74..1be775979 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -709,28 +709,7 @@ static u16 ieee80211_netdev_select_queue(struct net_device *dev,
 static void
 ieee80211_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
-	int i;
-
-	for_each_possible_cpu(i) {
-		const struct pcpu_sw_netstats *tstats;
-		u64 rx_packets, rx_bytes, tx_packets, tx_bytes;
-		unsigned int start;
-
-		tstats = per_cpu_ptr(dev->tstats, i);
-
-		do {
-			start = u64_stats_fetch_begin_irq(&tstats->syncp);
-			rx_packets = tstats->rx_packets;
-			tx_packets = tstats->tx_packets;
-			rx_bytes = tstats->rx_bytes;
-			tx_bytes = tstats->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&tstats->syncp, start));
-
-		stats->rx_packets += rx_packets;
-		stats->tx_packets += tx_packets;
-		stats->rx_bytes   += rx_bytes;
-		stats->tx_bytes   += tx_bytes;
-	}
+	dev_fetch_sw_netstats(stats, dev->tstats);
 }
 
 static const struct net_device_ops ieee80211_dataif_ops = {
-- 
2.28.0


