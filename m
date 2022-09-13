Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2145B7A3A
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbiIMSzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbiIMSyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:54:47 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E3274DD7;
        Tue, 13 Sep 2022 11:41:22 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id r20so8682200qtn.12;
        Tue, 13 Sep 2022 11:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=q6mWS2mVh30QjKkoz/4UDkfwFpGdpELj6dClBpT88uU=;
        b=V9MJDYSTGLHy8pWGnlj/98kswftkCFAxo/+YESuXhnh8gsGVMcWFLU/L+Uxb9x8QgY
         M7gzXt69zZuyxrEYdsUxLc/ulPFPLz+R5l9/4uuqE0aO9DYBytLyRqeYDrat04qv6i/0
         O3PLcA6KAu8e6R/50+hZeZBVuzWEMSQ/dFxUxonAZnGksUDw4dkFn0Hqk0gR0fVQJ2hB
         /qciUX/Wdk87NHwNS+SZFr1i0nsr5iTEvr+X8twRTdUawHTaCF+e0t/Sbayy2KffU0xh
         W9F1vdnYKeSUCICp66g5gIfj0IBttPGCb4gQjVEaApuO6es9AYMGwXpzTRkBUbVvHxza
         LQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=q6mWS2mVh30QjKkoz/4UDkfwFpGdpELj6dClBpT88uU=;
        b=GjUPvLe8OcbjuAGogT3zi3WWElaLFEAcscydRAzRcpeF92CUyhoR7WVzy7JGAZBAzS
         Uuz1JVIQ6JdV4FxKxNEBRtUHNgCa0o27vrdEp19urAw3GB6HvxG+O38pEEGv5kBEQWLL
         jjvO7rd83+v9IE7+wMOISZbxMZoMMvN/muRJAZJPNtmLp+bDUZlQZt7muWR6sjby6NW3
         +th8/Q6GG/G4OjMWMLT++5CmJckZ92Q+J5JbjZ8lMIrOTpVrNY4g9TIcMvHfSmJ88Eee
         hqVkthIVtj/82bEC46Smo2lJ+DAP/2IUFyCWIFNeHR/MdLfhmL6R+BpE9mKOLRZRh3r1
         Q4Cw==
X-Gm-Message-State: ACgBeo0k9H24/hYOKGFVcTlZ+qsAlTE9EgbYyw/eZjCw6PWFx4ndiftV
        /PYrCdX1mKzw4JsUuWtBOQ==
X-Google-Smtp-Source: AA6agR5xWM33OGgTf5SlET3gASKaosyr9debaheJ/Scd9rmE962/Sn/aNgSfWxZVDRfTDfLPJYCL8A==
X-Received: by 2002:ac8:5c82:0:b0:343:5983:a25b with SMTP id r2-20020ac85c82000000b003435983a25bmr30151626qta.552.1663094481172;
        Tue, 13 Sep 2022 11:41:21 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a454c00b006aedb35d8a1sm90136qkp.74.2022.09.13.11.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 11:41:20 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net v2] net: Use WARN_ON_ONCE() in {tcp,udp}_read_skb()
Date:   Tue, 13 Sep 2022 11:40:16 -0700
Message-Id: <20220913184016.16095-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908231523.8977-1-yepeilin.cs@gmail.com>
References: <20220908231523.8977-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Prevent tcp_read_skb() and udp_read_skb() from flooding the syslog.

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
change since v1:
  - do the same to udp_read_skb() (Cong Wang)

Cong's tcp_read_skb() fix [1] depends on this patch.

[1] https://lore.kernel.org/netdev/20220912173553.235838-1-xiyou.wangcong@gmail.com/

Thanks,
Peilin Ye

 net/ipv4/tcp.c | 2 +-
 net/ipv4/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8230be00ecca..9251c99d3cfd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1766,7 +1766,7 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		return 0;
 
 	__skb_unlink(skb, &sk->sk_receive_queue);
-	WARN_ON(!skb_set_owner_sk_safe(skb, sk));
+	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
 	copied = recv_actor(sk, skb);
 	if (copied >= 0) {
 		seq += copied;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cd72158e953a..560d9eadeaa5 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1821,7 +1821,7 @@ int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 			continue;
 		}
 
-		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
+		WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
 		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
-- 
2.20.1

