Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221CF5F8DA7
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 21:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJITNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 15:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiJITNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 15:13:12 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA351CFF8
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 12:13:11 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so5288740wmq.1
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 12:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fN3XoJB9/R6f3Ds4hy7r+Nf0Nve4TLYxsq9pKAg+BLI=;
        b=T15jCd3mLgyW4sgEKDRGj1V3b2jPxS00CgJhu5JL7YOrQPP+64VAyWPnST7DWrgKjy
         3xY7NwAFrRAMjchX+LXqeYECF6EaOzgcfOhNudUII5wmGhqjQKKWlrvf493IJ4bn2GuK
         m9yJBupqfRiqfIvxVXAfDd3lleVd1u1bRB9igDm0WHwCOM5gk48s09iuQsAIRy2m6hag
         0WiPol1EbQxQZuJPDof7gDxG8xXITAflygf+0xAzb3OYr4lf11rK28qZSgJg96tVvROR
         v+3qp4xwGwcfmsZbVZEA/jU/TK8ZcDWjc/s4/ELtCh01lYZngGIutFehEes+pcIedn/0
         uN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fN3XoJB9/R6f3Ds4hy7r+Nf0Nve4TLYxsq9pKAg+BLI=;
        b=pC5mHM3qsai7LOuh84G0ByGWPkIIgqqDGWa5c2MALzFeQZjfnIJsm4g0Y7qfw2auur
         FEykcJiWKuak2A92UwCu6TQCiPW/k3UJb2ByKdDRt2yjcQTa263JAWZ2agYCLtvjKCCr
         6+0A4GtIP/RHU41GAEhzf/VhiB2rHeQLRrRlNfXLlbOpNaMgKdMa4kzTYEFzFdNd6ouz
         oQmYOJHGoPLq86wTjkZbzV1wlqqtlQgjDPzUQ3dLCHJ7NaInZrE3n0uzd8x6EmFi0qqR
         bAwPd9wstmufKLX6nbRytTMpYME3da8rKEbn7IOokOa5KGL2kPqXGxK1WeEiLKU/1rbJ
         bkSQ==
X-Gm-Message-State: ACrzQf2doY5opUesc+zU9cUGY3WoryDQbn8UdA6b18HOx6IwkZA9eZIY
        mqWFft2hqCtR5GNoouVHTUE=
X-Google-Smtp-Source: AMsMyM4YjqTPh3qv9AlBEqkMkhffgGLtKHHDNOnFWi6m9/oN0doQ+t4/MBC1AebSWaXSBG027e0X9g==
X-Received: by 2002:a05:600c:2754:b0:3c6:aba7:5c93 with SMTP id 20-20020a05600c275400b003c6aba75c93mr1222567wmw.177.1665342789950;
        Sun, 09 Oct 2022 12:13:09 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id bh11-20020a05600c3d0b00b003b49ab8ff53sm8574150wmb.8.2022.10.09.12.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Oct 2022 12:13:09 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, monil191989@gmail.com,
        nicolas.dichtel@6wind.com, stephen@networkplumber.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec] xfrm: fix "disable_policy" on ipv4 early demux
Date:   Sun,  9 Oct 2022 22:12:53 +0300
Message-Id: <20221009191253.292197-1-eyal.birger@gmail.com>
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
---
 net/ipv4/ip_input.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 1b512390b3cf..6d033eeb3d9c 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -366,6 +366,11 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 					   iph->tos, dev);
 		if (unlikely(err))
 			goto drop_error;
+	} else {
+		struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
+
+		if (in_dev && IN_DEV_ORCONF(in_dev, NOPOLICY))
+			IPCB(skb)->flags |= IPSKB_NOPOLICY;
 	}
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
-- 
2.34.1

