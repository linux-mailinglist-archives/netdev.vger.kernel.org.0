Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08BF7680E75
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbjA3NFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbjA3NFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:05:43 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F39713D71;
        Mon, 30 Jan 2023 05:05:42 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id q8so7937524wmo.5;
        Mon, 30 Jan 2023 05:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7qD/pdat3Z43T3M0lNL9fDEciQ6LrvxQWEvx14VXeP8=;
        b=gjRaS84ZPKdBQsHb/ICv8kEYXFYmEjHkHmXCeve3hgG9v/Iqk8bmRpfaOFBCxKiYeo
         UO5tY1sgl/oO12Ix51KZjkcKCgsXaGOKH63W9/uKq/slY94spZJdiUVhn+gTwou5LitP
         wzSZimVl4Gn+6VT+lg4YkjW/rNdFq5pUUYXM8nRW103X/kukDppxTuvPKIPGchwbvd8p
         KoVUaFSmpr5LnktCFgQyipILZOiK4vODHdi/8FhsYiYczs6LTW69Ad5/Pjn5PppJa6db
         MmF/x0SOvnaADXNg76j41LCKwNRM8GfVNiaBfY3WFTmiI8YraP9ajB2wQs3YXsU7mX9+
         EFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7qD/pdat3Z43T3M0lNL9fDEciQ6LrvxQWEvx14VXeP8=;
        b=Ubo5WXw5qG4ajRFcygwMCTZCu/zpdZRIL7tMZQZPKVfCW5YJXC/nKLobqgHhJiEutj
         nXx7R2TcPktnJtPzNY2zHOW2IpvXY54hIlwxcXNlGyChNYPtmmdLNm7co8hIum+/utT0
         L+dqVEEB6HfGcWH93QaqTO8UMA+l5xLvI56X8tBkMzE3PHvWiZAVpbApMyspU6vfymoJ
         5uEBo68JNQe+odhptgtZLUVqkrP03lM45eWsQLVkMmrnn8tUPf8T/IHz9PxTlAV9eKhF
         HQa6+OuWde4dEUZv8nMGk7hEB1q+/Cb/GJa7uDKqhU9wDxh4M3NsDWjCaySX6+bCFZZN
         B4RA==
X-Gm-Message-State: AO0yUKXrY12mPmetyViWqvLy5CixOTIuGfhmttIF5lgntmf7BJocVhkv
        v5wjgoMWQQpm2Iyf7sBl2/Y=
X-Google-Smtp-Source: AK7set8M0nolg+58fdwYoXjuZbZphOzYytqNq4z7jpZnZAViEEs+St5afR9bzdAvMMNfZXJufBsOJw==
X-Received: by 2002:a05:600c:4e89:b0:3dc:198c:dde with SMTP id f9-20020a05600c4e8900b003dc198c0ddemr20188150wmq.41.1675083940520;
        Mon, 30 Jan 2023 05:05:40 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id g8-20020adfe408000000b002bdda9856b5sm11991793wrm.50.2023.01.30.05.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 05:05:40 -0800 (PST)
Date:   Mon, 30 Jan 2023 14:05:11 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        steffen.klassert@secunet.com, lixiaoyan@google.com,
        alexanderduyck@fb.com, leon@kernel.org, ye.xingchen@zte.com.cn,
        iwienand@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] gro: decrease size of CB
Message-ID: <20230130130509.GA7974@debian>
References: <20230130130047.GA7913@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130130047.GA7913@debian>
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

The GRO control block (NAPI_GRO_CB) is currently at its maximum size.
This commit reduces its size by putting two groups of fields that are
used only at different times into a union.

Specifically, the fields frag0 and frag0_len are the fields that make up
the frag0 optimisation mechanism, which is used during the initial
parsing of the SKB.

The fields last and age are used after the initial parsing, while the
SKB is stored in the GRO list, waiting for other packets to arrive.

There was one location in dev_gro_receive that modified the frag0 fields
after setting last and age. I changed this accordingly without altering
the code behaviour.

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
index 506f83d715f8..869823d9e8bc 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -449,6 +449,14 @@ static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
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
@@ -478,7 +486,6 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	struct sk_buff *pp = NULL;
 	enum gro_result ret;
 	int same_flow;
-	int grow;
 
 	if (netif_elide_gro(skb->dev))
 		goto normal;
@@ -553,17 +560,13 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
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
@@ -576,7 +579,8 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 normal:
 	ret = GRO_NORMAL;
-	goto pull;
+	gro_try_pull_from_frag0(skb);
+	goto ok;
 }
 
 struct packet_offload *gro_find_receive_by_type(__be16 type)
-- 
2.36.1

