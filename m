Return-Path: <netdev+bounces-7143-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D9171EE6E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D69D28167E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611EA4078A;
	Thu,  1 Jun 2023 16:14:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C22822D77
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:14:29 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B24BE4;
	Thu,  1 Jun 2023 09:14:27 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-30ad458f085so1903923f8f.0;
        Thu, 01 Jun 2023 09:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685636066; x=1688228066;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E16yr1i22oXCsD5aURpquO4ePT9VmEDNhq4WbZpVAao=;
        b=R6XJAjXATXTdbT0KnjmT3UXxhDFcFbK+Xtp4peaXI9vBWroQ50v3n4ypvmQaKLzHpk
         LMwkUHpxcsWTIhRSj14aNBGRLUueXNJYnXATYAm449B1rZIBCFc8tybuesCK1Ihn1c8Q
         bu1W4SDhGDjPOefp9r1qCohm4cNBy5R2Gg+KT/gaKiWLlB9EyOR16kZduyZ2Z8V5EoO+
         SULsvWmu6SFoBaK2seW+YZ6T1NYWZEjZZ671MQvSuGl4XnPdPQ7XhfzJ8VrXvtGcxCKY
         DvWTAqUoT+utqU6xH9bMm11KKBy2KoHXek93CTqFJAmXisE+4FJ6MtKYeBMjSYxNEqF2
         omIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685636066; x=1688228066;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E16yr1i22oXCsD5aURpquO4ePT9VmEDNhq4WbZpVAao=;
        b=RvxZMuyGDSmLdyc0dmC5mPmsyrtRx/aVbMaHoiNTuZ9zVb0PnO4G6n4NP8QzIFunUk
         jYhXynr9oAp29rBtTbAMymKZAuyq6AYMACMgVeZWh8UiVFPGeEkz9BJdPd8MP5Skp3lS
         xBUAwG/wcrcKy85XHKi+pHXfDmh5AOyhy6kO/wCGqIWmtTIdlN9lPfRKRyqaSzkNJKiw
         K8Pi6D0TuOPj18QAYCmNmuS+jbZqd9SLK4gFUQirIh7qNXFY/ty79Ppl2BTJLvNIt++l
         VrljQqjz/nuYkoia06aZZwxQHJUJS6sVDUm1tgZ/fEa6hkUbVxjv7rCN6sxJkfPFMlQL
         h/1w==
X-Gm-Message-State: AC+VfDw/HlpvjRZyePxOVRzx+dRHwqLpX93W/otQCog9lSjpERDiadxS
	kLAMDEsn1XHggjuhhXtA3SU=
X-Google-Smtp-Source: ACHHUZ4V03JJA8OupHmdf0HNEVGpE9hwzND/Wc/0EPXGGEwSh8FgmLDB+GbuZI3ldRnc0FBRtJXyyw==
X-Received: by 2002:a5d:6307:0:b0:30a:8999:3b9 with SMTP id i7-20020a5d6307000000b0030a899903b9mr2307123wru.28.1685636065412;
        Thu, 01 Jun 2023 09:14:25 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id k5-20020adff5c5000000b0030af1d87342sm10940382wrp.6.2023.06.01.09.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 09:14:25 -0700 (PDT)
Date: Thu, 1 Jun 2023 18:14:09 +0200
From: Richard Gobert <richardbgobert@gmail.com>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, aleksander.lobakin@intel.com,
	lixiaoyan@google.com, lucien.xin@gmail.com, alexanderduyck@fb.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/1] gro: decrease size of CB
Message-ID: <20230601161407.GA9253@debian>
References: <20230601160924.GA9194@debian>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601160924.GA9194@debian>
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
 net/core/gro.c    | 19 ++++++++++++-------
 2 files changed, 28 insertions(+), 17 deletions(-)

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
index 2d84165cb4f1..a709155994ad 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -460,6 +460,14 @@ static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
 	}
 }
 
+static void gro_try_pull_from_frag0(struct sk_buff *skb)
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
@@ -564,17 +571,14 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	else
 		gro_list->count++;
 
+	/* Must be called before setting NAPI_GRO_CB(skb)->{age|last} */
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
@@ -587,7 +591,8 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 normal:
 	ret = GRO_NORMAL;
-	goto pull;
+	gro_try_pull_from_frag0(skb);
+	goto ok;
 }
 
 struct packet_offload *gro_find_receive_by_type(__be16 type)
-- 
2.36.1


