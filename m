Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A34514A2
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348494AbhKOULU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345792AbhKOT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:21 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123CEC0BC9A6
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:09 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so647361pjb.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o1Omkca/LYbQN9TgKjlnuoa43OtoyGHQvu/csyGiDLk=;
        b=ohUBpNZrwSr6dQNPTk8CkukK1KDYsNvWnwPBfCFhOQr715h1LbN0Ue0pUchowMsS4o
         1mamjWyLI06MTy6RMDHfBsZlaXVg2qalwcSU5apYcMaRb5UdPKXqFpDB9gc7Yj3OtBbt
         p6afeqUPFNID7q7RK5i0WJ5VyM25mWOD6b7PbjlWagvprOkmv5mj/+7h+v7lW2Y9uLtg
         erVx4hlMOKCsHYuK/c1q7ZwMEyc3gsdzM4DeMJcR/LvDYHGjc03oSmCrCeOItP+D7yt2
         QkXl9d8eUbadnIVBbaf0AwEVaL9LnBqq0YrsdqKwceS0b00upyy8LODnN6/HO1QyuwkH
         WG5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o1Omkca/LYbQN9TgKjlnuoa43OtoyGHQvu/csyGiDLk=;
        b=7w71B/cX7sfwu/z5P2UxOK4H4xOkIxNz3XALDvNdKUqlrnIdnPd8xCLPbiLUaZ0DKB
         QSzepzhpHCac+jFSWhthoRvRUre94xHYmJ4KOi7xnHOEYI43eidwc/9zYbsj+JDBc9iD
         n4bW0cx3fK/C/iN/TLgd/Bn2Ae1siSQS53d8TqCmfkNNdPu6aQRukyis9ZCMsTt5xYgN
         VnxFnFxJPR3JjseVQNU/+uBWd9zGLMRk2GIXGluGY6M888egufrEcFxVRgA9Cr6OXLxi
         MQHLV4EpwPPb3YyONaDNRpfu442OIa6o/uGApIfQZRlXzMB4cj1rgBrzGabAKMjX442O
         VERg==
X-Gm-Message-State: AOAM533lFWRN19Ys7s74PZ5DoFhwF4jKX+okv6+S3jAoC519zUKZ+oeb
        C7ZsiV/V14gtM4lSnXsvolM=
X-Google-Smtp-Source: ABdhPJwwu6UrSLTbgrPCSYGlPZ1n0dQlFyk0Z9yBWNTP8Mc/8pihofTHctraS7QTzU7GoA8tXxY0Nw==
X-Received: by 2002:a17:90b:4a0e:: with SMTP id kk14mr67199117pjb.42.1637002988500;
        Mon, 15 Nov 2021 11:03:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 06/20] net: remove sk_route_nocaps
Date:   Mon, 15 Nov 2021 11:02:35 -0800
Message-Id: <20211115190249.3936899-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Instead of using a full netdev_features_t, we can use a single bit,
as sk_route_nocaps is only used to remove NETIF_F_GSO_MASK from
sk->sk_route_cap.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h    | 11 +++++------
 net/core/sock.c       |  3 ++-
 net/ipv4/tcp_ipv4.c   |  4 ++--
 net/ipv4/tcp_output.c |  2 +-
 net/ipv6/ip6_output.c |  2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ebad629dd9eda4bcec6f621cf2d4f783f293b7b7..985ddcd335048068b78a0525500734ef96be44a0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -284,7 +284,7 @@ struct bpf_local_storage;
   *	@sk_no_check_tx: %SO_NO_CHECK setting, set checksum in TX packets
   *	@sk_no_check_rx: allow zero checksum in RX packets
   *	@sk_route_caps: route capabilities (e.g. %NETIF_F_TSO)
-  *	@sk_route_nocaps: forbidden route capabilities (e.g NETIF_F_GSO_MASK)
+  *	@sk_gso_disabled: if set, NETIF_F_GSO_MASK is forbidden.
   *	@sk_gso_type: GSO type (e.g. %SKB_GSO_TCPV4)
   *	@sk_gso_max_size: Maximum GSO segment size to build
   *	@sk_gso_max_segs: Maximum number of GSO segments
@@ -458,7 +458,6 @@ struct sock {
 	unsigned long		sk_max_pacing_rate;
 	struct page_frag	sk_frag;
 	netdev_features_t	sk_route_caps;
-	netdev_features_t	sk_route_nocaps;
 	int			sk_gso_type;
 	unsigned int		sk_gso_max_size;
 	gfp_t			sk_allocation;
@@ -468,7 +467,7 @@ struct sock {
 	 * Because of non atomicity rules, all
 	 * changes are protected by socket lock.
 	 */
-	u8			sk_padding : 1,
+	u8			sk_gso_disabled : 1,
 				sk_kern_sock : 1,
 				sk_no_check_tx : 1,
 				sk_no_check_rx : 1,
@@ -2121,10 +2120,10 @@ static inline bool sk_can_gso(const struct sock *sk)
 
 void sk_setup_caps(struct sock *sk, struct dst_entry *dst);
 
-static inline void sk_nocaps_add(struct sock *sk, netdev_features_t flags)
+static inline void sk_gso_disable(struct sock *sk)
 {
-	sk->sk_route_nocaps |= flags;
-	sk->sk_route_caps &= ~flags;
+	sk->sk_gso_disabled = 1;
+	sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 }
 
 static inline int skb_do_copy_data_nocache(struct sock *sk, struct sk_buff *skb,
diff --git a/net/core/sock.c b/net/core/sock.c
index 257b5fa604804ea671c0dbede4455ade8d65ede8..99738e14224c44e5aa4b88857620fb162e9c265f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2249,7 +2249,8 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 		sk->sk_route_caps |= NETIF_F_GSO;
 	if (sk->sk_route_caps & NETIF_F_GSO)
 		sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
-	sk->sk_route_caps &= ~sk->sk_route_nocaps;
+	if (unlikely(sk->sk_gso_disabled))
+		sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 	if (sk_can_gso(sk)) {
 		if (dst->header_len && !xfrm_dst_offload_ok(dst)) {
 			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 82a9e1b75405f1488d6bc5d56c11f9bc597ddb07..5ad81bfb27b2f8d9a3cfe11141160b48092cfa3a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1182,7 +1182,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		if (!md5sig)
 			return -ENOMEM;
 
-		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+		sk_gso_disable(sk);
 		INIT_HLIST_HEAD(&md5sig->head);
 		rcu_assign_pointer(tp->md5sig_info, md5sig);
 	}
@@ -1620,7 +1620,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		 */
 		tcp_md5_do_add(newsk, addr, AF_INET, 32, l3index, key->flags,
 			       key->key, key->keylen, GFP_ATOMIC);
-		sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
+		sk_gso_disable(newsk);
 	}
 #endif
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2e6e5a70168ebd037661dcee51595183b91f36f6..5079832af5c1090917a8fd5dfb1a3025e2d85ae0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1359,7 +1359,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 #ifdef CONFIG_TCP_MD5SIG
 	/* Calculate the MD5 hash, as we have all we need now */
 	if (md5) {
-		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+		sk_gso_disable(sk);
 		tp->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, sk, skb);
 	}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2f044a49afa8cf3586c36607c34073edecafc69c..007e433d4d4de7321e25db2a5fff83768dd8723a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -977,7 +977,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 fail_toobig:
 	if (skb->sk && dst_allfrag(skb_dst(skb)))
-		sk_nocaps_add(skb->sk, NETIF_F_GSO_MASK);
+		sk_gso_disable(skb->sk);
 
 	icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 	err = -EMSGSIZE;
-- 
2.34.0.rc1.387.gb447b232ab-goog

