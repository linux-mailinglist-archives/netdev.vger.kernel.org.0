Return-Path: <netdev+bounces-8114-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DABD9722C53
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93798281342
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137032260A;
	Mon,  5 Jun 2023 16:16:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08168DF54
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:16:52 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747AACD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:16:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-565a33c35b1so74762067b3.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 09:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685981808; x=1688573808;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m1HzTmHu7OiMOSvYpAxyjAUzkmTs3IsZFnSOjhMlyfA=;
        b=Crrrt+s2UzNVz7CwOp3SwQ4wrsqUIu8G2S3XcNYBrooSxLPlXuOKX4zcd+5kuuVwu9
         K+66GF8T9qVgNEKMhGSop4WtDfFsgeCuO6ZBYxuOw69vg36t1DD+iyI2QKODQEPpGqqe
         XlbaBwVAWc2OX2neVC+CkXrTbFUos0FmYfkpCwRyNL1iBlLKrzqlQplBi37b4Fz5KiST
         7foKYV0CG52hyn76do3dTPoSCMmPs3QBQ19by77ppuDty317uXRimpL6ZUkhuyXoknOz
         OYFB8/acEY603wdLYuDxTmwnjeF1aTXGBHLRlLzglsL/1q1I29gegBET7ka1YpbnGoSR
         MuGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685981808; x=1688573808;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m1HzTmHu7OiMOSvYpAxyjAUzkmTs3IsZFnSOjhMlyfA=;
        b=EvieLgrIW/LKCA+8kfW9WFhIwBmcvVD7UQcC+2gxb76R8CuJ64VQrhQQl9Cn2K8hN8
         scFGHXRzif1oZjIuuZGz9oQwtxVV0rSqZ7dOwMeTyteBQrl1ToLpPTQUwvglLw0zFIsI
         uJjhANi5Pa5ncqKK1tQEiWM4Lurogph+ruWZyp8x05g/D7zXhQwOI+g5EpADiVouu8S+
         VLM8tRI3897zt6wKhZKBMSzPped47dDHIg0nqzdzH/pAlWCFgrtMgf/b2yUr3H9rs8V7
         +XL50Ps8eMPKxMgHQQ6bvBHkAUmGP7YfUytf1nJjqos0OkzgldF+SloRS8T2VEY587yp
         wgww==
X-Gm-Message-State: AC+VfDx2MJHLmCg3Z08e9dDvth6YSLvr4gS1/TpLiGdIC9LHD2s6jdor
	q0vO+YP/o05cDzDax58ojMTkZDLdMfIYnQ==
X-Google-Smtp-Source: ACHHUZ747G4lcsl48KSrxPDvoKJP7muGWZD2dp6RQAE9vFRxmcB3qawBg0xL92J0ZK+yTyiDPfz+YWzDz9ZIyg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:c5c8:0:b0:ba8:2e79:c193 with SMTP id
 v191-20020a25c5c8000000b00ba82e79c193mr3673636ybe.12.1685981808723; Mon, 05
 Jun 2023 09:16:48 -0700 (PDT)
Date: Mon,  5 Jun 2023 16:16:47 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230605161647.3624428-1-edumazet@google.com>
Subject: [PATCH v2 net] tcp: gso: really support BIG TCP
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We missed that tcp_gso_segment() was assuming skb->len was smaller than 65535 :

oldlen = (u16)~skb->len;

This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW GSO problems.")

This leads to wrong TCP checksum.

Adapt the code to accept arbitrary packet length.

v2:
  - use two csum_add() instead of csum_fold() (Alexander Duyck)
  - Change delta type to __wsum to reduce casts (Alexander Duyck)

Fixes: 09f3d1a3a52c ("ipv6/gso: remove temporary HBH/jumbo header")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/ipv4/tcp_offload.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 45dda788938704c3f762256266d9ea29b6ded4a5..4851211aa60d6eaf7d1c5e4f90bbcf621ee4c69b 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -60,12 +60,12 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	struct tcphdr *th;
 	unsigned int thlen;
 	unsigned int seq;
-	__be32 delta;
 	unsigned int oldlen;
 	unsigned int mss;
 	struct sk_buff *gso_skb = skb;
 	__sum16 newcheck;
 	bool ooo_okay, copy_destructor;
+	__wsum delta;
 
 	th = tcp_hdr(skb);
 	thlen = th->doff * 4;
@@ -75,7 +75,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, thlen))
 		goto out;
 
-	oldlen = (u16)~skb->len;
+	oldlen = ~skb->len;
 	__skb_pull(skb, thlen);
 
 	mss = skb_shinfo(skb)->gso_size;
@@ -110,7 +110,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (skb_is_gso(segs))
 		mss *= skb_shinfo(segs)->gso_segs;
 
-	delta = htonl(oldlen + (thlen + mss));
+	delta = (__force __wsum)htonl(oldlen + thlen + mss);
 
 	skb = segs;
 	th = tcp_hdr(skb);
@@ -119,8 +119,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (unlikely(skb_shinfo(gso_skb)->tx_flags & SKBTX_SW_TSTAMP))
 		tcp_gso_tstamp(segs, skb_shinfo(gso_skb)->tskey, seq, mss);
 
-	newcheck = ~csum_fold((__force __wsum)((__force u32)th->check +
-					       (__force u32)delta));
+	newcheck = ~csum_fold(csum_add(csum_unfold(th->check), delta));
 
 	while (skb->next) {
 		th->fin = th->psh = 0;
@@ -165,11 +164,11 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 			WARN_ON_ONCE(refcount_sub_and_test(-delta, &skb->sk->sk_wmem_alloc));
 	}
 
-	delta = htonl(oldlen + (skb_tail_pointer(skb) -
-				skb_transport_header(skb)) +
-		      skb->data_len);
-	th->check = ~csum_fold((__force __wsum)((__force u32)th->check +
-				(__force u32)delta));
+	delta = (__force __wsum)htonl(oldlen +
+				      (skb_tail_pointer(skb) -
+				       skb_transport_header(skb)) +
+				      skb->data_len);
+	th->check = ~csum_fold(csum_add(csum_unfold(th->check), delta));
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		gso_reset_checksum(skb, ~th->check);
 	else
-- 
2.41.0.rc0.172.g3f132b7071-goog


