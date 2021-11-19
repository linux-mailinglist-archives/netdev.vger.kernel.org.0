Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A20456780
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbhKSBlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhKSBlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:41:02 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157B6C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 17:38:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x7so6717269pjn.0
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 17:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=njYkUS+P4saQ7417VNxfBIKK+pR6stB+0QNcG4YfrjA=;
        b=l9FThtURkIUmx7G7epCImCw8rzdVcfUt+DOiAxD+BJF1zCQXF5H06Wo7ez6Y/NCrTY
         G2W5dWl3Ksxg6Llsm6HjzXYoULn5EVRPbMh27sYyHmEDG9CB2NNaOKpv5CJ235PUN0O6
         F+rTbiG2wyYj5Jf4yiD5tb4XCIxi7l3sZJJAJhVPsdTbcz7LCFOK6827ubjI47ErLclS
         Gh92vEDTuqKMC8zCAQ504SJIaAgUIlxFEyDnBAzE4JJMly3AXQeIM/w027wg42LRRo74
         NQNbaZ9s25iDz/KVTGTLSF3Umoe75uMFHYQWEpvhIJh9aiS7UcqW5CmM6MYGMdQx8Sbm
         W2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=njYkUS+P4saQ7417VNxfBIKK+pR6stB+0QNcG4YfrjA=;
        b=Plj3rItvLlSQ/ZOdVc5i0cX0LkPMY3dQIZ2OBDnZ44amuOSXS/OPImEVxlOYIWzKtt
         kzF5dirQ9PntxwUJwCqhSdoa8ZkWWDDKJNBjr+6W8DAr1Q2OkA89TqMlk6bEagoTdooO
         TmjGTWCeSD92iKuKFB6kl58GuedjiCk2ZIsnh+LbkX8eD6iSnrm37RBkMrEIbvsEvLxd
         UVzBPkJhS6pdMz46/aGIXG/aH6P4l4xnOmR62v97l/DM2HR4Buesoq0P7Z7Fq5pNicaI
         Y3HHCt9ziWTvJNhQJiWlIvot2OgZfro4YE6u19qiTQTKo2xmvx9mjR8JhNU1Pd8QVf46
         CBsA==
X-Gm-Message-State: AOAM533fKl3V3XMMLJFpUMCiQkR/4Vrn/iqsamCWIHcF2DffxvW7schY
        1/j07xi4sXzWzYZewkWfIkU=
X-Google-Smtp-Source: ABdhPJzHcx/8WCeH78JKQkIb75wmYeU575emJ+cLEzaaMi9gHLSD5x9ompFsA6LOwyrprTG7f61FPg==
X-Received: by 2002:a17:90b:4f42:: with SMTP id pj2mr8044pjb.7.1637285881702;
        Thu, 18 Nov 2021 17:38:01 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:fc03:ed5a:3e05:8b5e])
        by smtp.gmail.com with ESMTPSA id u32sm826473pfg.220.2021.11.18.17.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:38:01 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tobias Brunner <tobias@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net] ipv6: fix typos in __ip6_finish_output()
Date:   Thu, 18 Nov 2021 17:37:58 -0800
Message-Id: <20211119013758.2740195-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We deal with IPv6 packets, so we need to use IP6CB(skb)->flags and
IP6SKB_REROUTED, instead of IPCB(skb)->flags and IPSKB_REROUTED

Found by code inspection, please double check that fixing this bug
does not surface other bugs.

Fixes: 09ee9dba9611 ("ipv6: Reinject IPv6 packets if IPsec policy matches after SNAT")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tobias Brunner <tobias@strongswan.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: David Ahern <dsahern@kernel.org>
---
 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2f044a49afa8cf3586c36607c34073edecafc69c..ff4e83e2a5068322bb93391c7c5e2a8cb932730b 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -174,7 +174,7 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
 #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
 	/* Policy lookup after SNAT yielded a new policy */
 	if (skb_dst(skb)->xfrm) {
-		IPCB(skb)->flags |= IPSKB_REROUTED;
+		IP6CB(skb)->flags |= IP6SKB_REROUTED;
 		return dst_output(net, sk, skb);
 	}
 #endif
-- 
2.34.0.rc2.393.gf8c9666880-goog

