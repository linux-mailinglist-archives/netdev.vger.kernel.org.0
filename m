Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CE8583DCE
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbiG1Ll2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbiG1LlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:41:06 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D404D67C8C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:40:57 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v5so829455wmj.0
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=1f0Glap5wbhCCkj0KkuuiTZQicIbpkwBRzHenJl/7yo=;
        b=h2DdiM1wyYwkkfh6Riki6N8bnVvDZlDnHopp9oGlGGotUOu+PBBhNgvDXrqbk+5fkx
         o3VUTKVFrQ9A3c4lTXIk3wfzqdxNMNW+jOgyGDftZcaygf+L3OmEPunsQ0+NyNSsePc9
         CD/9IfSVPo8ObI/94Pp6PoL17/Ojqkg3Qvh6bK+TqjgDKgkFMTwdP3dYOOj6He2Xgrw/
         zWYOqDB53+U/HN+MelQ3bdm5C/2XqfoZP8vG9mTnW70yTXqelZzjbCHZkuE6ErT4TIh2
         w6MarnufAWHPb0IzaHv6FDLe3ooLz5o1qQD/B3uvG7Sx6ofpJvo46PgTsFtII7x3Sv6f
         FdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=1f0Glap5wbhCCkj0KkuuiTZQicIbpkwBRzHenJl/7yo=;
        b=dPddJMe7QVx4PRgbl2c0ac4fK/UDtKWWEzOTwSv/bHZ5S1WGoihiYBjVS0ISnzTERq
         pt2bK4C0yjft+/4kIENVHObdjONjI9sdpvcC5qySvzbo/S2wJMdYrOZTy2XW/1nOcV/3
         6knvtH0yyGebqNceRcatwhgDazXeLtg4GzDfFU/rsjgVw+X3rpkmBZfnQYiIwJVe2wDG
         +MuKS08wsOoNP8xqpqgUFrp+JRzPECxyOROrBMyyL0+3rjGLvwrvfZ8zzoA7qSJfBdWg
         L7zazSVq6yfCN2OVR0ZboK0evCTkXkS4xvpEnI8rjdo3Tdku0zaU0QJVfsYOPxQVTTU7
         6Jow==
X-Gm-Message-State: AJIora9Prk3di5yeF2RqBr75MVRvJHsE2uG0vG697VfjOWvFV+lvKhu7
        /fB21YAd3luc2rTdv+2tURc=
X-Google-Smtp-Source: AGRyM1txT4oTOFONTHTPtZGndspq1yj8abU1wSTabcUm2K7EwxDDQD2lVpfGYOGAtlbnTyN+lK10Tg==
X-Received: by 2002:a05:600c:601b:b0:3a3:21a2:8bcd with SMTP id az27-20020a05600c601b00b003a321a28bcdmr6447499wmb.80.1659008456153;
        Thu, 28 Jul 2022 04:40:56 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id h1-20020a05600c2ca100b003a3253b706esm5840312wmc.34.2022.07.28.04.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 04:40:55 -0700 (PDT)
Date:   Thu, 28 Jul 2022 13:39:00 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, xeb@mail.ru,
        edumazet@google.com, iwienand@redhat.com, arnd@arndb.de,
        netdev@vger.kernel.org
Subject: [PATCH] net: gro: skb_gro_header_try_fast helper function
Message-ID: <20220728113844.GA53749@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Introduce a simple helper function to replace a common pattern.
When accessing the GRO header, we fetch the pointer from frag0,
then test its validity and fetch it from the skb when necessary.

This leads to the pattern
skb_gro_header_fast -> skb_gro_header_hard -> skb_gro_header_slow
recurring many times throughout the GRO code.

This patch replaces these patterns with a single inlined function
call, improving code readability.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 include/net/gro.h      | 33 ++++++++++++++++++---------------
 net/ethernet/eth.c     |  9 +++------
 net/ipv4/af_inet.c     |  9 +++------
 net/ipv4/gre_offload.c |  9 +++------
 net/ipv4/tcp_offload.c |  9 +++------
 5 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index 867656b0739c..c37c5d6f8c02 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -160,6 +160,17 @@ static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
 	return skb->data + offset;
 }
 
+static inline void *skb_gro_header_try_fast(struct sk_buff *skb,
+					unsigned int hlen, unsigned int offset)
+{
+	void *ptr;
+
+	ptr = skb_gro_header_fast(skb, offset);
+	if (skb_gro_header_hard(skb, hlen))
+		ptr = skb_gro_header_slow(skb, hlen, offset);
+	return ptr;
+}
+
 static inline void *skb_gro_network_header(struct sk_buff *skb)
 {
 	return (NAPI_GRO_CB(skb)->frag0 ?: skb->data) +
@@ -301,12 +312,9 @@ static inline void *skb_gro_remcsum_process(struct sk_buff *skb, void *ptr,
 		return ptr;
 	}
 
-	ptr = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, off + plen)) {
-		ptr = skb_gro_header_slow(skb, off + plen, off);
-		if (!ptr)
-			return NULL;
-	}
+	ptr = skb_gro_header_try_fast(skb, off + plen, off);
+	if (!ptr)
+		return NULL;
 
 	delta = remcsum_adjust(ptr + hdrlen, NAPI_GRO_CB(skb)->csum,
 			       start, offset);
@@ -329,12 +337,9 @@ static inline void skb_gro_remcsum_cleanup(struct sk_buff *skb,
 	if (!grc->delta)
 		return;
 
-	ptr = skb_gro_header_fast(skb, grc->offset);
-	if (skb_gro_header_hard(skb, grc->offset + sizeof(u16))) {
-		ptr = skb_gro_header_slow(skb, plen, grc->offset);
-		if (!ptr)
-			return;
-	}
+	ptr = skb_gro_header_try_fast(skb, plen, grc->offset);
+	if (!ptr)
+		return;
 
 	remcsum_unadjust((__sum16 *)ptr, grc->delta);
 }
@@ -405,9 +410,7 @@ static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
 
 	off  = skb_gro_offset(skb);
 	hlen = off + sizeof(*uh);
-	uh   = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen))
-		uh = skb_gro_header_slow(skb, hlen, off);
+	uh   = skb_gro_header_try_fast(skb, hlen, off);
 
 	return uh;
 }
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 62b89d6f54fd..3e74a3ce4984 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -414,12 +414,9 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	off_eth = skb_gro_offset(skb);
 	hlen = off_eth + sizeof(*eh);
-	eh = skb_gro_header_fast(skb, off_eth);
-	if (skb_gro_header_hard(skb, hlen)) {
-		eh = skb_gro_header_slow(skb, hlen, off_eth);
-		if (unlikely(!eh))
-			goto out;
-	}
+	eh = skb_gro_header_try_fast(skb, hlen, off_eth);
+	if (unlikely(!eh))
+		goto out;
 
 	flush = 0;
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 93da9f783bec..4591c1e1a8e1 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1447,12 +1447,9 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	off = skb_gro_offset(skb);
 	hlen = off + sizeof(*iph);
-	iph = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen)) {
-		iph = skb_gro_header_slow(skb, hlen, off);
-		if (unlikely(!iph))
-			goto out;
-	}
+	iph = skb_gro_header_try_fast(skb, hlen, off);
+	if (unlikely(!iph))
+		goto out;
 
 	proto = iph->protocol;
 
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 07073fa35205..a97ed708b47a 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -137,12 +137,9 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 
 	off = skb_gro_offset(skb);
 	hlen = off + sizeof(*greh);
-	greh = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen)) {
-		greh = skb_gro_header_slow(skb, hlen, off);
-		if (unlikely(!greh))
-			goto out;
-	}
+	greh = skb_gro_header_try_fast(skb, hlen, off);
+	if (unlikely(!greh))
+		goto out;
 
 	/* Only support version 0 and K (key), C (csum) flags. Note that
 	 * although the support for the S (seq#) flag can be added easily
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 30abde86db45..a1229253d558 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -195,12 +195,9 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	off = skb_gro_offset(skb);
 	hlen = off + sizeof(*th);
-	th = skb_gro_header_fast(skb, off);
-	if (skb_gro_header_hard(skb, hlen)) {
-		th = skb_gro_header_slow(skb, hlen, off);
-		if (unlikely(!th))
-			goto out;
-	}
+	th = skb_gro_header_try_fast(skb, hlen, off);
+	if (unlikely(!th))
+		goto out;
 
 	thlen = th->doff * 4;
 	if (thlen < sizeof(*th))
-- 
2.36.1

