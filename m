Return-Path: <netdev+bounces-6817-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA44718501
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AE241C20EEA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60CBC8FF;
	Wed, 31 May 2023 14:30:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB30D16416
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:30:35 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EB7E2;
	Wed, 31 May 2023 07:30:34 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f60b3f32b4so43475455e9.1;
        Wed, 31 May 2023 07:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685543432; x=1688135432;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iXMb98r6IAMoLlFveXFogkdJ9GH/7ktI/udKGBLpvdI=;
        b=loJE8bSOE4Sui+8Wf1M2K9m8sTcauInezSzhel9vKe1bkQJVP47rS43ydvrvKbIMKE
         ET9rcOEqSdwUNhNPi9q1h1R/RZ1wSQ0CRTUden8NVDUlLtjSrIMjGaTJBr3el2/YeGaz
         AyW/VwuCsWf73RbLCUD65tlvdHMaJjMjdlq/jQ+3vNHyRWiUJ/QLh0if9NPR6QWdQ083
         VPNczcUrL35WJVENNBScJcpK78gndyMx6+oOKkrRbAtHkrBtpqFkxVL1yZFAcdtRIQMN
         NUeWUn7vLDTjA9js3a83KiAAnCJIAjS/9Z9AGBQGr+f9ys8GbSHHVdkr1QkBGmCn7vt9
         Q9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685543432; x=1688135432;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iXMb98r6IAMoLlFveXFogkdJ9GH/7ktI/udKGBLpvdI=;
        b=LZspQdeL1np61cjb7T6EVisGUIBZTEm3kRFDXw3jn2au+xeeXVJxk3+jiY9syeoIt1
         M8XXf17jkk56MnSpZIaIv1fW0kqLAC6tyUXLlV4hcGMCFoFq4NexKyla+RVhgPBuB3ak
         T2DQhgRFuGZWfdqkkBwgezvZswz3WwflqANhqUzXON5BJTk0XZCldKWexDRaOCThn7c+
         dgBBFIMddOovvqFfBtyny+fUlr98NJJ0+2a5ZLgwym4IG1GhUIBrEM6SygxR74+gWE8j
         bdsGkTVMSjxSspGafvjwJlufV281PWlAHA8HbMjBqOrUZL+ovfETorzz13f1g5YtL4cT
         A9SQ==
X-Gm-Message-State: AC+VfDyJoPF5HmEfoR2IqpK+d49gQwlE8ehjxjwfTpKaG+T2HaHN6ZIL
	w/5qz6Yu9Mqul4FBaWlg7QM=
X-Google-Smtp-Source: ACHHUZ6eQhpz4caVqeq5jkzgCDNXBpc3r0CzTSJjI8CmcAjEzq4iPLGqKwRSjQy4ifpi29HD6BBbWQ==
X-Received: by 2002:a05:600c:283:b0:3f6:3da:1603 with SMTP id 3-20020a05600c028300b003f603da1603mr4595775wmk.26.1685543432147;
        Wed, 31 May 2023 07:30:32 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id u5-20020a05600c00c500b003f0ad8d1c69sm24483702wmm.25.2023.05.31.07.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 07:30:31 -0700 (PDT)
Date: Wed, 31 May 2023 16:30:12 +0200
From: Richard Gobert <richardbgobert@gmail.com>
To: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, lixiaoyan@google.com, alexanderduyck@fb.com,
	lucien.xin@gmail.com, linyunsheng@huawei.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] gro: decrease size of CB
Message-ID: <20230531143010.GA8221@debian>
References: <20230531141825.GA8095@debian>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531141825.GA8095@debian>
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
index 2d84165cb4f1..c6955ef9ca99 100644
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


