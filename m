Return-Path: <netdev+bounces-9080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65FBF7270A6
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 211662815A0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 130E83B8B6;
	Wed,  7 Jun 2023 21:41:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023D03AE7F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:41:17 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181D01BF9
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:41:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb3855c34deso4177370276.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 14:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686174075; x=1688766075;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FHk40y/zBOQU71kLbZonwMTr0ZjqRJZDnZJAsGqPwPw=;
        b=DudGYa6a7oqiNngPkm40MK1gP/1VPuM9TheEELaVDefrw/BjoSJq4xQTOWOWV5RrvU
         t8cdESGGRXZFi76+GKa41coR3eyBj1VU1kuobHtBRTJdEPYnyv+MDLgTnKa9wKaSrEgn
         BjPLlEnXtIVu8czH5oMPR/vs62zNLkOmgR1TAWijWRVPvi2bnI+0eL2z7lLu1q+X4jdO
         i6Vl9txbvvBMa8IMg36RB1N+7ZENuEeq1OJxjBHPPyUFjWCXNMdF8unhhIRqCzduRCpK
         ZAJ6tzxBFfGEe2fQEkCcd/ygwSkrujA/tIRx01Pn7kFdyMmeVVqNiC1eSGsjFZWz/9wP
         9ijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686174075; x=1688766075;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FHk40y/zBOQU71kLbZonwMTr0ZjqRJZDnZJAsGqPwPw=;
        b=jG85JcL5mTe0Jp4Yw3TkRjtY581b9pdEKOomALG5T1GQxl6ftMyX9A0CE7SgyEr3bb
         3OdWOEpDNfaO2yyyq+N67Wg9kWL3/NnnqbgsGKGGcqgq0elDRz3zb1WFtadQOlofzYu7
         cKR+AhG9qR2ymyP2R4KtZ7yDfIWgY6I1fCwB56At+Kk5Ohe8Xq9PASrKRaPz1dJqjQjx
         92jz4Kbim4A2+6VWEABgw7kaPW7R6OlqRQr6KRp8DFyrD0x4NsJWNQDYQnlQBrt7GNCM
         vRn2bfxC0n7oZyoFdJqbTx9oYdc7r3z8OrB5HfUHVRzGKcVnPBFBlpdg46F/Ckz3ZzYs
         ZSVg==
X-Gm-Message-State: AC+VfDxjEyDGgJ8RdKuiAzPw2IiF3ZCgzW8Bj9btqVsR5pbYjcjA4uZK
	vCazoDvvT93DSitVUcxGhTR2uJE+2cs4Fw==
X-Google-Smtp-Source: ACHHUZ6UJUnsR9ghhnIzoY6QQBQ49zj55WAznYW4TzOpeEacPqUd8CdPuiFbtJmLAhOXKE+rDzUV/i1xSXWwwQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:686:0:b0:bad:99d:f089 with SMTP id
 128-20020a250686000000b00bad099df089mr3765051ybg.8.1686174075332; Wed, 07 Jun
 2023 14:41:15 -0700 (PDT)
Date: Wed,  7 Jun 2023 21:41:13 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607214113.1992947-1-edumazet@google.com>
Subject: [PATCH net-next] tcp: let tcp_mtu_probe() build headless packets
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tcp_mtu_probe() is still copying payload from skbs in the write queue,
using skb_copy_bits(), ignoring potential errors.

Modern TCP stack wants to only deal with payload found in page frags,
as this is a prereq for TCPDirect (host stack might not have access
to the payload)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 60 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cfe128b81a010339b486dd6a40b077cee9570d08..f8ce77ce7c3ef783717e60cce03d70aa10a4b9a8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2319,6 +2319,57 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
 	return true;
 }
 
+static int tcp_clone_payload(struct sock *sk, struct sk_buff *to,
+			     int probe_size)
+{
+	skb_frag_t *lastfrag = NULL, *fragto = skb_shinfo(to)->frags;
+	int i, todo, len = 0, nr_frags = 0;
+	const struct sk_buff *skb;
+
+	if (!sk_wmem_schedule(sk, to->truesize + probe_size))
+		return -ENOMEM;
+
+	skb_queue_walk(&sk->sk_write_queue, skb) {
+		const skb_frag_t *fragfrom = skb_shinfo(skb)->frags;
+
+		if (skb_headlen(skb))
+			return -EINVAL;
+
+		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++, fragfrom++) {
+			if (len >= probe_size)
+				goto commit;
+			todo = min_t(int, skb_frag_size(fragfrom),
+				     probe_size - len);
+			len += todo;
+			if (lastfrag &&
+			    skb_frag_page(fragfrom) == skb_frag_page(lastfrag) &&
+			    skb_frag_off(fragfrom) == skb_frag_off(lastfrag) +
+						      skb_frag_size(lastfrag)) {
+				skb_frag_size_add(lastfrag, todo);
+				continue;
+			}
+			if (unlikely(nr_frags == MAX_SKB_FRAGS))
+				return -E2BIG;
+			skb_frag_page_copy(fragto, fragfrom);
+			skb_frag_off_copy(fragto, fragfrom);
+			skb_frag_size_set(fragto, todo);
+			nr_frags++;
+			lastfrag = fragto++;
+		}
+	}
+commit:
+	WARN_ON_ONCE(len != probe_size);
+	for (i = 0; i < nr_frags; i++)
+		skb_frag_ref(to, i);
+
+	skb_shinfo(to)->nr_frags = nr_frags;
+	to->truesize += probe_size;
+	to->len += probe_size;
+	to->data_len += probe_size;
+	__skb_header_release(to);
+	return 0;
+}
+
 /* Create a new MTU probe if we are ready.
  * MTU probe is regularly attempting to increase the path MTU by
  * deliberately sending larger packets.  This discovers routing
@@ -2395,9 +2446,15 @@ static int tcp_mtu_probe(struct sock *sk)
 		return -1;
 
 	/* We're allowed to probe.  Build it now. */
-	nskb = tcp_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
+	nskb = tcp_stream_alloc_skb(sk, 0, GFP_ATOMIC, false);
 	if (!nskb)
 		return -1;
+
+	/* build the payload, and be prepared to abort if this fails. */
+	if (tcp_clone_payload(sk, nskb, probe_size)) {
+		consume_skb(nskb);
+		return -1;
+	}
 	sk_wmem_queued_add(sk, nskb->truesize);
 	sk_mem_charge(sk, nskb->truesize);
 
@@ -2415,7 +2472,6 @@ static int tcp_mtu_probe(struct sock *sk)
 	len = 0;
 	tcp_for_write_queue_from_safe(skb, next, sk) {
 		copy = min_t(int, skb->len, probe_size - len);
-		skb_copy_bits(skb, 0, skb_put(nskb, copy), copy);
 
 		if (skb->len <= copy) {
 			/* We've eaten all the data from this skb.
-- 
2.41.0.rc0.172.g3f132b7071-goog


