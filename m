Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C224F09B0
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358692AbiDCNL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358750AbiDCNLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:11:11 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C30627172
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:45 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r11-20020a1c440b000000b0038ccb70e239so484149wma.3
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZv4QnAyNuMdX6ZYSNFz/+Z4cnf7iFtgX+JqxbuLIGo=;
        b=mlyaVkKN2gHHASZQdwWb6MNLgWsxWJOygWcoew6k+SUw9E1O1YTw5fP1Vg0DVDHjnK
         lyG9+epOBOjT7YCsXwQ3RDJfS8VZyBwtf/bVlYAYcpOogx/YuKiAQAa9b/79hlhqj5bZ
         433gtkbVgKRGuz29buB9xYj2SWWa7EpEifCruep5QTIkleaA0dSPJlqpVF6g8k2U7aT5
         wS4YhCushzMjxtiTVkvZ8agp5vbWcaWB6KyT1FIr/FMeRPvKeORyIZKC1cbbLwVP6lOD
         zDc5kB7vGXpvNmTXuiZ6GHxsQCWkAWIPvgLcNA+Dt14gbuaqMOo94gL3p2Jjw8LkJ9rW
         mKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZv4QnAyNuMdX6ZYSNFz/+Z4cnf7iFtgX+JqxbuLIGo=;
        b=zY6cgNVi2O0+mg23ipUkI5du9YwiGp9gY/Vxwan8Fl9d3/47kmmj5yl5lPO2GUrqcp
         uqnIVjaBq5WwXa/rNXUeUhIVySPTwMveHTihBL28JucrJtNDJxX3tyxgnJfxaYFMkzKw
         e+pp9YqTjcYfYxaI0zDZNSwwSmcV8NyJc4q/ZkXf1mXTvbxSvvHNV525ea5V4iz5GAd/
         BW41auqoQ4DuFTn5jvjUoklTnKNC/rUofkwkgcM80G5jPQlmkwcJPPy9L4+Hpdhzu+Xj
         zMI+VyFzrfpG13cspYP5NLjqHE00Qdfa9bmjgDsd08uNDKlIkhXGNoJJgwDyOM8LqEK1
         mGlA==
X-Gm-Message-State: AOAM5303SGYToIyiV04FxbQFwmVKXQ9FKsCEYJGJmKPNKQzQ7e0hieW0
        uodMFwVTvNdd8KxoPK6rhX92Z6Trau0=
X-Google-Smtp-Source: ABdhPJwnaAn1hzoNSaTw7b8GZS81qqQ6Lm8uZKSM6VD36PDNv1WpRfXZqsFKOITomwKwcRs7U19jUQ==
X-Received: by 2002:a1c:7308:0:b0:38c:7b63:e385 with SMTP id d8-20020a1c7308000000b0038c7b63e385mr15647276wmb.116.1648991323587;
        Sun, 03 Apr 2022 06:08:43 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 26/27] ipv6: improve opt-less __ip6_make_skb()
Date:   Sun,  3 Apr 2022 14:06:38 +0100
Message-Id: <dd7d8a73db3ba0276a164ef5a4d9f898bff52b0f.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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

We do a bit of a network header pointer shuffling in __ip6_make_skb()
expecting that ipv6_push_*frag_opts() might change the layout. Avoid it
with associated overhead when there are no opts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 3c37b07cbfae..f7c092af64f5 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1882,22 +1882,20 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
 	/* Allow local fragmentation. */
 	skb->ignore_df = ip6_sk_ignore_df(sk);
-	__skb_pull(skb, skb_network_header_len(skb));
-
 	final_dst = &fl6->daddr;
 	if (v6_cork->opt) {
 		struct ipv6_txoptions *opt = v6_cork->opt;
 
+		__skb_pull(skb, skb_network_header_len(skb));
 		if (opt->opt_flen)
 			ipv6_push_frag_opts(skb, opt, &proto);
 		if (opt->opt_nflen)
 			ipv6_push_nfrag_opts(skb, opt, &proto, &final_dst, &fl6->saddr);
+		skb_push(skb, sizeof(struct ipv6hdr));
+		skb_reset_network_header(skb);
 	}
 
-	skb_push(skb, sizeof(struct ipv6hdr));
-	skb_reset_network_header(skb);
 	hdr = ipv6_hdr(skb);
-
 	ip6_flow_hdr(hdr, v6_cork->tclass,
 		     ip6_make_flowlabel(net, skb, fl6->flowlabel,
 					ip6_autoflowlabel(net, np), fl6));
-- 
2.35.1

