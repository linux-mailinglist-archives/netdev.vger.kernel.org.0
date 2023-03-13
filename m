Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4676B7D94
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCMQbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCMQbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:31:39 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B1B29152;
        Mon, 13 Mar 2023 09:31:10 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso11378746wmb.0;
        Mon, 13 Mar 2023 09:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678725037;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ow5ddn/QIqSEjhFdfrsof6If8oZqPbR/1miA6Uf+y4s=;
        b=hXUJ8G8u99JemF+XggUGaKU8N5ufna6rkuxsR1qr1ojG3YHxaw2zCNyD6XHKqhWj8a
         Rfy9vY55sJQgtD/zTMbrHjLOS9H6qgh67ahYEPG44r7BYkppe0BCzrDzmDHm/7b7xtWP
         KbPpAu+NQG9w1vWwdVZndrC+E0udy27kBF31YaSVWYIuTC05/CUxh2nPcqrIQW1bc7XB
         M9+A+WAUEwGGaSI8YHmat4eVhFWT8tdS4Y1TLvC3PMDIcv2FZQ4NMT6YbdJdbV9a+T2Q
         /Ex9ZAusj0OlQ2zsfbdss6AGly0rnGOjYqCGZMtmosbQKoIZffwCikhP/FWFtd6i0Zyw
         G7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678725037;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ow5ddn/QIqSEjhFdfrsof6If8oZqPbR/1miA6Uf+y4s=;
        b=bhKrgc3iHNo5dktWM3mL0V0w2N5vE3tKSeUJEV6QpprPOaWm3Pms/qhMsBbqy9VHYu
         npPBBLdhoLVGhl8JhtczbEmcUiUThxOMp5XL8AFWkJMs7YmHtZEvm1l9zteUCMS9p4ww
         eWr16D069snEkYS7Arhw1NOJ0nJ4zIL+A4gQSnVBkcCgWgBa3HSxuZ183LuIh3F3XjQw
         cvhuC+p3R3wGtySGEdevut4/gq3nu//9e2cpt/pRw2rR0rk+P58JS3ZR3cSen7J5Av6a
         rMHdq5D0ITVE4h0g+RqNe3J3NyIi8qwOKPsDTFLYYhVVZTo5mqaEINV9kYpgwCfxj25S
         dsnA==
X-Gm-Message-State: AO0yUKXG4RWWMn6PAMDFxAlW/ANPkE0QEegctP25vL+v10gHW4XBUYY/
        J5w5/6W0wInBLYLONSq8Y1k=
X-Google-Smtp-Source: AK7set+uN+/BQvRb1liJQqw+zu4o8XunYhXXwk8r79WdJXX3CcAtAph6IBIOFlGhk7U781UZgYYyWw==
X-Received: by 2002:a05:600c:6008:b0:3ea:f883:180 with SMTP id az8-20020a05600c600800b003eaf8830180mr11487218wmb.7.1678725037448;
        Mon, 13 Mar 2023 09:30:37 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id q17-20020a05600c46d100b003dc1d668866sm255701wmo.10.2023.03.13.09.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:30:37 -0700 (PDT)
Date:   Mon, 13 Mar 2023 17:30:01 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, alexanderduyck@fb.com,
        lucien.xin@gmail.com, lixiaoyan@google.com, iwienand@redhat.com,
        leon@kernel.org, ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] gro: decrease size of CB
Message-ID: <20230313162956.GA17242@debian>
References: <20230313162520.GA17199@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313162520.GA17199@debian>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GRO control block (NAPI_GRO_CB) is currently at its maximum size.  This
commit reduces its size by putting two groups of fields that are used only
at different times into a union.

Specifically, the fields frag0 and frag0_len are the fields that make up
the frag0 optimisation mechanism, which is used during the initial parsing
of the SKB.

The fields last and age are used after the initial parsing, while the SKB
is stored in the GRO list, waiting for other packets to arrive.

There was one location in dev_gro_receive that modified the frag0 fields
after setting last and age. I changed this accordingly without altering the
code behaviour.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 include/net/gro.h | 26 ++++++++++++++++----------
 net/core/gro.c    | 18 +++++++++++-------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index a4fab706240d..7b47dd6ce94f 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -11,11 +11,23 @@
 #include <net/udp.h>
 
 struct napi_gro_cb {
-	/* Virtual address of skb_shinfo(skb)->frags[0].page + offset. */
-	void	*frag0;
+	union {
+		struct {
+			/* Virtual address of skb_shinfo(skb)->frags[0].page + offset. */
+			void	*frag0;
 
-	/* Length of frag0. */
-	unsigned int frag0_len;
+			/* Length of frag0. */
+			unsigned int frag0_len;
+		};
+
+		struct {
+			/* used in skb_gro_receive() slow path */
+			struct sk_buff *last;
+
+			/* jiffies when first packet was created/queued */
+			unsigned long age;
+		};
+	};
 
 	/* This indicates where we are processing relative to skb->data. */
 	int	data_offset;
@@ -32,9 +44,6 @@ struct napi_gro_cb {
 	/* Used in ipv6_gro_receive() and foo-over-udp */
 	u16	proto;
 
-	/* jiffies when first packet was created/queued */
-	unsigned long age;
-
 /* Used in napi_gro_cb::free */
 #define NAPI_GRO_FREE             1
 #define NAPI_GRO_FREE_STOLEN_HEAD 2
@@ -77,9 +86,6 @@ struct napi_gro_cb {
 
 	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
 	__wsum	csum;
-
-	/* used in skb_gro_receive() slow path */
-	struct sk_buff *last;
 };
 
 #define NAPI_GRO_CB(skb) ((struct napi_gro_cb *)(skb)->cb)
diff --git a/net/core/gro.c b/net/core/gro.c
index a606705a0859..b1fdabd414a5 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -460,6 +460,14 @@ static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
 	}
 }
 
+static inline void gro_try_pull_from_frag0(struct sk_buff *skb)
+{
+	int grow = skb_gro_offset(skb) - skb_headlen(skb);
+
+	if (grow > 0)
+		gro_pull_from_frag0(skb, grow);
+}
+
 static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
 {
 	struct sk_buff *oldest;
@@ -489,7 +497,6 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	struct sk_buff *pp = NULL;
 	enum gro_result ret;
 	int same_flow;
-	int grow;
 
 	if (netif_elide_gro(skb->dev))
 		goto normal;
@@ -564,17 +571,13 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	else
 		gro_list->count++;
 
+	gro_try_pull_from_frag0(skb);
 	NAPI_GRO_CB(skb)->age = jiffies;
 	NAPI_GRO_CB(skb)->last = skb;
 	if (!skb_is_gso(skb))
 		skb_shinfo(skb)->gso_size = skb_gro_len(skb);
 	list_add(&skb->list, &gro_list->list);
 	ret = GRO_HELD;
-
-pull:
-	grow = skb_gro_offset(skb) - skb_headlen(skb);
-	if (grow > 0)
-		gro_pull_from_frag0(skb, grow);
 ok:
 	if (gro_list->count) {
 		if (!test_bit(bucket, &napi->gro_bitmask))
@@ -587,7 +590,8 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 normal:
 	ret = GRO_NORMAL;
-	goto pull;
+	gro_try_pull_from_frag0(skb);
+	goto ok;
 }
 
 struct packet_offload *gro_find_receive_by_type(__be16 type)
-- 
2.36.1
