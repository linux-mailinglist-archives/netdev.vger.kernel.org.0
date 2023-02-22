Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCB269F762
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjBVPIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjBVPII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:08:08 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEB422000;
        Wed, 22 Feb 2023 07:08:06 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p18-20020a05600c359200b003dc57ea0dfeso6616107wmq.0;
        Wed, 22 Feb 2023 07:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PcYQsUm0jjlmo43M4POJwhiWEz4azA7qERkEfeTiNBY=;
        b=GFd/yPlmEDKU2ReV92ojhaqy0DRjsyWU17pkSCG0+yFl9/s3DORhMU/7nKbRy0ONJQ
         4w/F1oOS/6xkXXrk1KZ/+uh2ZAAn0l3Y3Q387A1ogrvxTFlEGDASc3sNcyJUae4fo/sQ
         gHrkV3eFE8vuVGHxMo1Ia2gbMSD+qOMr/NQJiLletOk96d3yc9xaTv0iZaQPJk1ccTiL
         qNpt+2/LcsKoD9lp6d28ZaSssoElxl03W7HT4mCryYHWMkOGUfGyaAPpkMH/z8Pjvh8O
         feoVjkC0LuFCkyR/NI6JrBGCLHiYQ15AzI+HIw7ETj+R/RiajPJFHcQfYMPLHCYUP3No
         Di+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PcYQsUm0jjlmo43M4POJwhiWEz4azA7qERkEfeTiNBY=;
        b=2nVz37mAGLDob4XiUnAtu4/JOjkc7TvK0J5Rhae/zcyFxb/G5BvwWLHEEBY8leQ6U4
         RqN6lp+yGKLNgsA5uStW8GPvj7yX5F1PgXtiOwjvajNo74fyJ0IRTP2465FvKe4mBfdM
         XCZ1k9uPAvG2QwJOK3zPHiUEPVFzeS8HqITsce7wNuJjJy1DqK7mBkJ0gMDZyfhFhpbG
         F42VbD8r2tudpnZZLbv8Gd8c3s99yonsOhnadW6Y5Ew0I5jGH8Oyt1GB5fjv32gq8iaj
         zYE6qIc0aiYFoxy2dYn4RLgWdI0FC+jy3sfmjDs0EwTNrfANaAoZzqh+WBMFnTY0hSyF
         pCfA==
X-Gm-Message-State: AO0yUKUVf6egOJklnQf5fQkWSPe4bWNGAOv1FUmqPANvPiTLuQ/+bBsc
        U+xMp6X3BVvwPZmgKwj5t4U=
X-Google-Smtp-Source: AK7set8xZt8HmKinoaOj52X9CzRKGvAOKexkdJ9PszV5Puj0NvY55bTc003yHat2p28C85xwvfUWJQ==
X-Received: by 2002:a05:600c:2b0f:b0:3df:dc29:d69 with SMTP id y15-20020a05600c2b0f00b003dfdc290d69mr1519216wme.36.1677078484850;
        Wed, 22 Feb 2023 07:08:04 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id a22-20020a05600c225600b003e2058a7109sm8439747wmm.14.2023.02.22.07.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 07:08:04 -0800 (PST)
Date:   Wed, 22 Feb 2023 16:07:42 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, alexanderduyck@fb.com,
        lixiaoyan@google.com, steffen.klassert@secunet.com,
        lucien.xin@gmail.com, ye.xingchen@zte.com.cn, iwienand@redhat.com,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] gro: decrease size of CB
Message-ID: <20230222150740.GA12658@debian>
References: <20230222145917.GA12590@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222145917.GA12590@debian>
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
commit reduces its size by putting two groups of fields that are used only at
different times into a union.

Specifically, the fields frag0 and frag0_len are the fields that make up the
frag0 optimisation mechanism, which is used during the initial parsing of the
SKB.

The fields last and age are used after the initial parsing, while the SKB is
stored in the GRO list, waiting for other packets to arrive.

There was one location in dev_gro_receive that modified the frag0 fields after
setting last and age. I changed this accordingly without altering the code
behaviour.

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

