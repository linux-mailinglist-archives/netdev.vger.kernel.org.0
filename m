Return-Path: <netdev+bounces-6137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B41714DF4
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10152280F12
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59EF3A934;
	Mon, 29 May 2023 16:13:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7148F71
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:13:03 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF27A0;
	Mon, 29 May 2023 09:13:01 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f6ffc2b314so9010075e9.0;
        Mon, 29 May 2023 09:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685376780; x=1687968780;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lmt1DO4BDFemx1g/90o2KUfvjpypOOLRqOoGdWC/rEY=;
        b=Uyv5LUD2AUAejN7H7ZhsgQTRk9NPT7CSQDzrj0uPseEpbtZp8XuFNglKAQ372rEWYi
         3CL5sv5iwwY1c5Lwz1zMEO0mU6AQBhAGBFrCdxBSf2e1h1NrW1f9W0smI4mtPqgXrw+h
         42bMsUh/G5PSIzDSH9y3tEXaqMhbQ6sbO3/JLvMkRLdyGjChL9nisZD9o3wrGn6Ukb8R
         6eARZTwaLxgmnHg4cbFiywc3+vUVltsLftb70Rxpjc4ML0FpJo/18Y+yMRlP7RrrJz94
         sTP0oykcQLpnjvasQWJWaNvE+hIBQ6SDGDWNpSGcrnkISCXhC6B90Cdr/wD5LFTdkavU
         +IFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685376780; x=1687968780;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lmt1DO4BDFemx1g/90o2KUfvjpypOOLRqOoGdWC/rEY=;
        b=YUhbdKrODivfGe32g6iBRODQRy/vkTH4F8KhJCAtBAseWv89RxjFsji14ibtGAQaP2
         UrJEpdPHVSWBJb2x7CqEcijpqbBbG0oWCMExKHQV7OVG0gcsw9OOyN/tBnLQNS7709I2
         FLwDASjTBuNOMEzgqB4xRWlcsATtNsHzyHaoMIn1pQjiRKmIzOb7nng+Bh/oG4R1tZhF
         551Dl8hIBcmc5oEYeqD5aGbn2diRh4EiQ5sZv4nPwRMiAAOV58/VfAFO0CLvoE0eKp8t
         03FA2dWHy8M/nuYMKjVmwsMTY11P7eKJjtG8nJYAuthrmhy8/vB31JsHUFiVIY1Skwbm
         Fv+w==
X-Gm-Message-State: AC+VfDwZUbFl5sVBTthSdeY1QNdkp5bob9yRuOFcba4MKDwlhAjnLoWR
	Qe9IEuFxwmX0m+pz0snNqy4=
X-Google-Smtp-Source: ACHHUZ6CJSWDfYfN7cgqr2lLNJllEBexqjagzgutYaffWOgHO4ReMIU6cneayLIv5AhoIrQfQbaK+A==
X-Received: by 2002:a1c:7303:0:b0:3f4:fe7f:3d18 with SMTP id d3-20020a1c7303000000b003f4fe7f3d18mr6872577wmb.2.1685376780012;
        Mon, 29 May 2023 09:13:00 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id k15-20020a05600c0b4f00b003f611b2aedesm14734431wmr.38.2023.05.29.09.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:12:59 -0700 (PDT)
Date: Mon, 29 May 2023 18:12:42 +0200
From: Richard Gobert <richardbgobert@gmail.com>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, lixiaoyan@google.com, alexanderduyck@fb.com,
	linyunsheng@huawei.com, lucien.xin@gmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] gro: decrease size of CB
Message-ID: <20230529161240.GA3958@debian>
References: <20230529160503.GA3884@debian>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529160503.GA3884@debian>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
index 2d84165cb4f1..91454176a6d8 100644
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


