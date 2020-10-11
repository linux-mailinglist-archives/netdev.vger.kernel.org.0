Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE4328A9DE
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgJKTof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgJKToc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:44:32 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B128DC0613D0;
        Sun, 11 Oct 2020 12:44:31 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id x1so14743138eds.1;
        Sun, 11 Oct 2020 12:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sVZWFKmWX+WTmfjlAyUC3V6edudq39GypRePR5bJKiI=;
        b=C8xvNbM+J7NKyEsbDZKiT8wqKhDzG1DFSSWlnrqPaai0Klv4u9p1zLokAKzvkxFwWp
         zO2dkU1AsYfjQWsCvKmHA/Umrz4lQuwDVoZbNLIM1uc/OHlpSqGR2avkysv2IPZbmtFY
         EUoeHDUxGsRKq3XKvExP6ZRH3KjwfwPI3+L0y2ABlu4NYIkjCozJ32JDRRjFMGYQul+K
         1Ia8AZLZdMeNkGuLeSe1XbRtZ9YRMCbBdorm/KGI7i3sHpoJq6w2Ym7s4Vmv5IjHykPT
         NFqvGj3F79yfbFktAU8x/oRbKmOI4pHJUFSlHJLA8YqOAoJbM4xIjkxlLZT5J9M7bkUG
         PQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sVZWFKmWX+WTmfjlAyUC3V6edudq39GypRePR5bJKiI=;
        b=CBb9KIuu4B5kYCxqh9CbykE7fZYjJsaS3pY4onPbpKDpxf32YJ0m/RCSSQNxpMtvk8
         jjoQu2AwfQyuCKyfzafVy+AIkUi2/X8vgIAPgPLkFF5U6KwOPmauuhreH+lMWFRpc5y/
         0IYGqawYuY4s5ifEVdDOrdCl1aGvAs+uPj9yw21mgHJJ5GlHfQIxr36ScKmU1dHHqH6D
         I4/MqYQTw3WdK+kK4oMgWtMtXK/CPFaSJs7IewktIsk51UcHqKp9a8VRXqqJUJHy+bvo
         w3P/a0FL7bwdHL0SZmIPFsErl+97OtyB1qHBFfs/d5TqLPEcJJVMCMmKhh4VW/d8bmnM
         uKKQ==
X-Gm-Message-State: AOAM530GwWIohamaECElnwOOCTYIbCV6QLznVG3uRzkfQDtWC4IfBwfL
        AH1sc7wagR7FspjjcO2VHxk=
X-Google-Smtp-Source: ABdhPJzZJhkP+n3UkxYwLmk7JgckORy+47i3n3MoP9Tt1H2VvGYHQ/kfQZo17UJuOkKtwIFsZaczLg==
X-Received: by 2002:a50:bb0d:: with SMTP id y13mr11033369ede.317.1602445470380;
        Sun, 11 Oct 2020 12:44:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id p3sm9442717edp.28.2020.10.11.12.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:44:29 -0700 (PDT)
Subject: [PATCH net-next 03/12] net: macsec: use new function
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
Message-ID: <26abd317-928e-3e52-698c-6b5feca2072f@gmail.com>
Date:   Sun, 11 Oct 2020 21:38:05 +0200
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
 drivers/net/macsec.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 2b0c8f01d..e74483279 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3647,30 +3647,7 @@ static int macsec_change_mtu(struct net_device *dev, int new_mtu)
 static void macsec_get_stats64(struct net_device *dev,
 			       struct rtnl_link_stats64 *s)
 {
-	int cpu;
-
-	if (!dev->tstats)
-		return;
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


