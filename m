Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A717F5F8DAD
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 21:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiJITRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 15:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJITRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 15:17:05 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BB823179
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 12:17:04 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id e10-20020a05600c4e4a00b003b4eff4ab2cso7369057wmq.4
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 12:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yzai4QVJ3GUgs63J6wE715M728/JeqEdzrClPYvk1wg=;
        b=WwUxkjpC1C0b02dQiNJW85YAp9e1Gi7t3oy9Pcl5aYRlZ/DuWQenZN/p+ZuXab/zW+
         xPf2vW4E3kbtG3S+FVvgDeoZzI0bk8/Bfubpf5JpvSPxD6D+zLIkeuJHNeq11t4B/jIv
         KzF7RK1hsWtzD24Ya2Xi88OtaXW4pbpFJStlKzGcp675IhhMtHkT33Ae+aSNw3XPaPsZ
         Ll2V5Zztop9lE3Q6JabD8wBfR+vzvYGJNgd1i7V8UgykUraCo7NDg2MOz+il6kuHI0Lw
         ByZhWGPuRAHSowA7KG6wPgchxticPlqKcbZoePP1WGVME2mjGC6H5eE+19wCGI2EiEZd
         kSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yzai4QVJ3GUgs63J6wE715M728/JeqEdzrClPYvk1wg=;
        b=025Iy+NgxsjO2/6ewQIhoMKcxMcvSfFKiF0Til2SuMBaYs3PluZRk2cy0cECaw6ORv
         t3AdwGzwK0UVtqzhJ8LdJRHdfAmn8YN6IunnWOZcuaH5Wf+/FoIU5/4StjdN21KneOGZ
         aHT3QPRKuyXxcCEX+I7B1l5kfMTqxndcVTqusK6kO855ktTBBwOY8c6AUauLft5qFBiF
         +GsJcK46SVSQGHIGfNrB0yWLt912iGDNt+/AbNxiCPmZPEbdRV0rJHalGO5TT+QJaibC
         MoAP1yUTh+fQlDdai54IdN6RFMxJzxrqA7rufOpyqOJlhNR9vmSuIyE6h7nwlCzmu+zE
         fEEg==
X-Gm-Message-State: ACrzQf1AKZcUxAk976YyA8nGpO5TPVJIHK0AMf9AdC7mZ3VQ3SE3Me9F
        lJEF0HVqo+3yfp8xuaCZB1Hc09vRjmUfPQ==
X-Google-Smtp-Source: AMsMyM6/fNIAUzXQY+0u9tf9I92UfWAmwM7jvwYYpKbmJ2zOK9yrc9529X5UgAdQxStZbMPvctAl6w==
X-Received: by 2002:a1c:6a08:0:b0:3c4:a83b:bc4 with SMTP id f8-20020a1c6a08000000b003c4a83b0bc4mr5458659wmc.115.1665343022363;
        Sun, 09 Oct 2022 12:17:02 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id c13-20020a5d4f0d000000b0022cd96b3ba6sm8852620wru.90.2022.10.09.12.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Oct 2022 12:17:02 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, monil191989@gmail.com,
        nicolas.dichtel@6wind.com, stephen@networkplumber.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec,v2] xfrm: fix "disable_policy" on ipv4 early demux
Date:   Sun,  9 Oct 2022 22:16:43 +0300
Message-Id: <20221009191643.297623-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit in the "Fixes" tag tried to avoid a case where policy check
is ignored due to dst caching in next hops.

However, when the traffic is locally consumed, the dst may be cached
in a local TCP or UDP socket as part of early demux. In this case the
"disable_policy" flag is not checked as ip_route_input_noref() was only
called before caching, and thus, packets after the initial packet in a
flow will be dropped if not matching policies.

Fix by checking the "disable_policy" flag also when a valid dst is
already available.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216557
Reported-by: Monil Patel <monil191989@gmail.com>
Fixes: e6175a2ed1f1 ("xfrm: fix "disable_policy" flag use when arriving from different devices")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

----

v2: use dev instead of skb->dev
---
 net/ipv4/ip_input.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 1b512390b3cf..e880ce77322a 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -366,6 +366,11 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 					   iph->tos, dev);
 		if (unlikely(err))
 			goto drop_error;
+	} else {
+		struct in_device *in_dev = __in_dev_get_rcu(dev);
+
+		if (in_dev && IN_DEV_ORCONF(in_dev, NOPOLICY))
+			IPCB(skb)->flags |= IPSKB_NOPOLICY;
 	}
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
-- 
2.34.1

