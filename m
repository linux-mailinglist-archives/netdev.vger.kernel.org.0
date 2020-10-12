Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039C728B028
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgJLIWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbgJLIVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:21:54 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5354CC0613D1;
        Mon, 12 Oct 2020 01:21:54 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lw21so21988225ejb.6;
        Mon, 12 Oct 2020 01:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kQY13u/J7Fp4HN8JNyMiTiNVGyBR7+vKMY2CDxSIOpA=;
        b=LoWNdkgQEg6j2t7jglG4pZY5cy520+KElxP+XTQdibuLKMJQ17qaQKrgNKcZWMBhwd
         fh4tfgP9JMDppbFJLafJC7AKRl2W9Pmnrke1fkqaKB5xIOTDxiQLFWJXbIPBgnyW0byC
         b8zTIxJwYdtYF/lEL0uGz/AVe1CufR7arN5LYOBTY4JbKxwlmSu+tekilqKbSCodZKrZ
         ojSi1s6kcnwT0o91vuspcWEklTsDCI3HXvTwhb4qSDKLIf2Pjhw0XtgMyBzOSQiTDZHv
         ZyTjpn1tXvfeOALJnWiNgDYpht2jRdGu5C1L+qfeMJFU+ChxAf27lipacYpUWzI45E3X
         pPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kQY13u/J7Fp4HN8JNyMiTiNVGyBR7+vKMY2CDxSIOpA=;
        b=Xyf2oRqBnADMje0NC258LBWrwNrzLqns3nsIKN4ypzhT66iK0MWAyoBW4+3fNNckH8
         LORC2KUPvgPVRaz2pwZnbhyHlcffX0bGvVmspSbsYrfudt7Iz7qV3v1czvqXEJscNfSd
         4h3yA48aJfh2TJolLFvIMmV/2KYcATfhPA+QetYdGH3QGzu3SuyYCsm7zdt6M0OC9Yrx
         jJFyx6UijanH+9opTzYEJauFMMlMEnBNa4//TTZKbXZM217jOeM5oM29hJOg1/JlyBUg
         aWac+pT0rtlkejX8soTRtPCWnMgE+uAScTlzcJ3pHaZsejDX6Dv0Qbe/iX0r5ZbkF/7K
         Kw+w==
X-Gm-Message-State: AOAM533epL3GlP1fWQj8IdZn+4pUws8Ht9GXvDq9RQN+AtoUtmNIaiHz
        ZPW71umKgGi2es9QUDVv6h4=
X-Google-Smtp-Source: ABdhPJxZjb6wWOhCJS0wl42e7OPCO1VSso+NFMpWMst/0+/wbjV+Z98wJGkpbVoqTuh2/EBZga8S5g==
X-Received: by 2002:a17:906:f8ca:: with SMTP id lh10mr5845312ejb.528.1602490912970;
        Mon, 12 Oct 2020 01:21:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id k9sm9480801ejv.113.2020.10.12.01.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:52 -0700 (PDT)
Subject: [PATCH net-next v2 08/12] net: dsa: use new function
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
Message-ID: <b6047017-8226-6b7e-a3cd-064e69fdfa27@gmail.com>
Date:   Mon, 12 Oct 2020 10:16:18 +0200
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
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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


