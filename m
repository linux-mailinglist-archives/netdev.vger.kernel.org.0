Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357706C1CFA
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjCTQ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbjCTQzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:55:38 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DA2CC3A;
        Mon, 20 Mar 2023 09:47:47 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso7945492wmo.0;
        Mon, 20 Mar 2023 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679330811;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9X3QPPdNt9KZl3qCzvO2M08cblxCOdnyoFX6Dj2Rdpc=;
        b=TDKEg0EkdUCVEInS+b88HB3e/+VvGVSE4wlzGsS9I4GGjxyt21MwiFs9YjJcBAhbHV
         xUo6Yf32NTtko/6UV5BCvLDn8W6hZS5DviryZRz9hQ6MChH5LT3pkaqntY69vCX+Ramx
         ilyka2vRGhhTu/LCt7ZdUqEEc7hAiq9lhBxAIpVre3h/+kKh0/ZeiU7Hxs1y2njmCFv4
         BExmkeSyCferAgj2xpMbdi0+/MUkBX8eJ1gfXpenqL5F/1cdk7zfWN+fHiz2m4TtGomI
         XqHFGU/KqWDWsBSmyBABIlgCYAz1biv3rMHffO6YHcZWdMId3Iz6JC4jb4lxUS9suf32
         RxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679330811;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9X3QPPdNt9KZl3qCzvO2M08cblxCOdnyoFX6Dj2Rdpc=;
        b=Gnm2Kpqxx4lI60Ip+x5Q0FGrowG9QErnF/hSz+kcDNxtRKFPBinrxTyxDHs9kwGHLK
         EdE3YIg5FtxQ8zLNSESJol9gNkD0Pz1oj18Oqw6j39kzfUwPylIa+Acpvpk3vjATsZR6
         5ok2COpPPs2smiM2ZL7c2hmRP+UQwE3+S048rTxu0gb9r5yN5t9KgIF+o9r7yA9MfPl2
         k1kwetuLsdaCKapudrKrHQeP5vk7NLoKlgfvh8AfQNlTBfkuFxD7JsDkjVmRxVpAPmMa
         XDUZ6AB7udsR3DHBPDYkV1Oe13GrYy0WnZtR/G0Hd6XYCzAGoj4tAepyVVitkSyoyktj
         kFFw==
X-Gm-Message-State: AO0yUKVyc8BvjMuRgZX9HSDlbYUE9KSSpVDfIjMCrjVRj/JNs5ltW2/h
        9U7F3CZ42eDr3zobQlnxotk=
X-Google-Smtp-Source: AK7set/8HZDtMFRe59y01FPXFgdSQtwiyW0+pBD7B6e/jNowGAoD14djx7AbjSWHfokK6euldApEgg==
X-Received: by 2002:a1c:7c17:0:b0:3ed:a5a2:145 with SMTP id x23-20020a1c7c17000000b003eda5a20145mr150175wmc.6.1679330811227;
        Mon, 20 Mar 2023 09:46:51 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id bi6-20020a05600c3d8600b003ede178dc52sm4854966wmb.40.2023.03.20.09.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 09:46:50 -0700 (PDT)
Date:   Mon, 20 Mar 2023 17:46:37 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, alexanderduyck@fb.com,
        lucien.xin@gmail.com, lixiaoyan@google.com, iwienand@redhat.com,
        leon@kernel.org, ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] gro: decrease size of CB
Message-ID: <20230320164635.GA27796@debian>
References: <20230320163703.GA27712@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320163703.GA27712@debian>
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
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
