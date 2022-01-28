Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF5C49F46E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346863AbiA1HeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346864AbiA1HeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:34:21 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5131DC061714;
        Thu, 27 Jan 2022 23:34:21 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id p125so4520899pga.2;
        Thu, 27 Jan 2022 23:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QEz/fR/kaAPRecC/ASB8IHjUXrfH/nHr4967v0vTry4=;
        b=bVawaxhlDmF7c5DXcKiqKXJwHskxaWW7d3rf1xBobbidvTqNQvbo/bOwcXzETjx3Yg
         cD4+RcKE8vE0BdYFQ/vc9dePLLnLhzdUOStNfk00qj1huE/Fy2ra9NCOvvIGPGtO8QZb
         Cwx0+gW+VXczlD3tnDXgPdy74IBSVPJirvHR18CcebSAOBG6UKYA3Lazuon0aethEjAX
         GuPn0g9T+GAmt+Fyj6ORpRdEoERIdQ6pWNEviRc7pw6Z2haLkUU2HimOR89Qe3yv7A3I
         Gdk+nv9p5wCHu0Uf66hVyP6ZnJNvwKekMH/wWrkJvhePo8bLvhp62XmKYGQBhGTecYQ9
         g+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QEz/fR/kaAPRecC/ASB8IHjUXrfH/nHr4967v0vTry4=;
        b=uQciThMf4JzR7jRlONUJ4wYBAdXSHxAUPpTJ0oSG2yO8/GUskHi0grGZMwA6n4IkHi
         KjIJQ0MP/69MlSbG3Jkjw1OsAFl8g6bs+2IYGbJBZNYFceio1HKd6GchP+kROQqRir4N
         u0qxzZK0/woiax5zfANVf32t54THmldA8HAB30rg8l7LsBYf9kl3nRtNcFKpzI1Ztge3
         czBk6gcSXjYahNUlHnOXMx/kW4w3MxjGJor1J+jvWcmKikxJOe27k8VgOWjw46sA5MaD
         G2z9bnO4mwPaNCFyWX937KsusaYko2LzaoWmEG0NMW2NX0DP0m/KWKwqDh1c8o3tMY6H
         MBIw==
X-Gm-Message-State: AOAM531qpgIBE3IgSjdNsIyJy8/AH6Nhebq1reBB4CpL4rh70gP7t8M/
        Ojo3c6OIrnQnamK+cjWoWqM=
X-Google-Smtp-Source: ABdhPJypfmnJSTGgY9+fR+xJEIZx5K/DVOCyEwhRg88ClziyvjdGXoAIH8S9kNYYlQCq1iLIKL/yBA==
X-Received: by 2002:a65:4584:: with SMTP id o4mr5698621pgq.38.1643355260871;
        Thu, 27 Jan 2022 23:34:20 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id q17sm8548846pfu.160.2022.01.27.23.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 23:34:20 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v3 net-next 6/7] net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
Date:   Fri, 28 Jan 2022 15:33:18 +0800
Message-Id: <20220128073319.1017084-7-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128073319.1017084-1-imagedong@tencent.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in udp_queue_rcv_one_skb().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- use SKB_DROP_REASON_SOCKET_FILTER instead of
  SKB_DROP_REASON_UDP_FILTER
---
 net/ipv4/udp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 464590ea922e..9e28e76e95b8 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2120,14 +2120,17 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
  */
 static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 {
+	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct udp_sock *up = udp_sk(sk);
 	int is_udplite = IS_UDPLITE(sk);
 
 	/*
 	 *	Charge it to the socket, dropping if the queue is full.
 	 */
-	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto drop;
+	}
 	nf_reset_ct(skb);
 
 	if (static_branch_unlikely(&udp_encap_needed_key) && up->encap_type) {
@@ -2204,8 +2207,10 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	    udp_lib_checksum_complete(skb))
 			goto csum_error;
 
-	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr)))
+	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr))) {
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto drop;
+	}
 
 	udp_csum_pull_header(skb);
 
@@ -2213,11 +2218,12 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	return __udp_queue_rcv_skb(sk, skb);
 
 csum_error:
+	drop_reason = SKB_DROP_REASON_UDP_CSUM;
 	__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
 drop:
 	__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
 	atomic_inc(&sk->sk_drops);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return -1;
 }
 
-- 
2.34.1

