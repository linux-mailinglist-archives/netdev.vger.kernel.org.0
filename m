Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734C86BD3EC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjCPPg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbjCPPgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:36:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6561BDFB55
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:38 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-540e3b152a3so19221677b3.2
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678980725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UqGnzTxmIPwMDD+PUT4PXFbcmNCfHD78TIJgPZ2Ft50=;
        b=pdd+qx7nz1X43hBo1hnfS752bKWJr2m5WDhu4Vl8GbIFOTrOwTQcuKu+IRObExCW+r
         NhKbrDuJfkFMrzEZC54lfBO93g+8TSiG5DnKZdLmxhIt2YMrtQrIXvxtc7duvstse6C3
         LXZds1yI9HuRy4rtf4KSv9djdxUSaSAxzu/ODT9AttdzYLJjMDhfxNN4n7Pul7yW49PT
         j09IDA4Gwaf142hUmYn2kHJTMoGRJjN5NrFf3Fj7BD1jzws9+bNvpA8pdJnM+MW9Lvy2
         sgd99/mVc0swHPH5Jd6vWHrmww08lhqUpqLOZZoDXPqnRkgYcnqhR2E3URc+xzk5cKXx
         oSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UqGnzTxmIPwMDD+PUT4PXFbcmNCfHD78TIJgPZ2Ft50=;
        b=upMa9FkOGNO2+NOSxT6gZTZXJNtNG7LyTtxkiAdqOHv19+D+RlvU6R0JMM+uOLRfJI
         Aar7r0KYBrZ/AB1CDrfzdG4mglGKFK3DrXCz5P1bER0cui33SGJKwQeeBOcztW3Q+V+N
         Ij3Mv8aUQTYfKzidj6GXTi4oCeHrfdLca+l8qkY3DyF2arU/peC39tLwm3q2lIm4e6Lq
         MtgoELJ5mqf074lYsSc3omHX02099RnZkX+gBfxJOS45fUN5LR5m9gR8rPcDzxaElFAV
         iF9kchXrycREdBgDMuEgek1oxQSHkdgFCqpTfoFu+HmNkIgXd6BiwRKKbs2Emrxnwl1N
         4EiA==
X-Gm-Message-State: AO0yUKWD6vPtUdNiy/sozSaesPQ2sdvLTUKRaHPL7uknmI7SYbV5NTqK
        pc8Ui1YzkJPohJH7ubRgw7LJfgLvVnGoGw==
X-Google-Smtp-Source: AK7set+RaoUKTBggU/XkpfVmwYP46XS/ugSpauzChkg6RV5oXjatVn88/RgpI4ZQcqYLzrBXZnOK+B6e86Mahg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1141:b0:b54:ba46:6131 with SMTP
 id p1-20020a056902114100b00b54ba466131mr3069852ybu.11.1678980725613; Thu, 16
 Mar 2023 08:32:05 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:31:55 +0000
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316153202.1354692-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316153202.1354692-2-edumazet@google.com>
Subject: [PATCH v2 net-next 1/8] inet: preserve const qualifier in inet_sk()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can change inet_sk() to propagate const qualifier of its argument.

This should avoid some potential errors caused by accidental
(const -> not_const) promotion.

Other helpers like tcp_sk(), udp_sk(), raw_sk() will be handled
in separate patch series.

v2: use container_of_const() as advised by Jakub and Linus

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/20230315142841.3a2ac99a@kernel.org/
Link: https://lore.kernel.org/netdev/CAHk-=wiOf12nrYEF2vJMcucKjWPN-Ns_SW9fA7LwST_2Dzp7rw@mail.gmail.com/
---
 include/net/inet_sock.h     | 5 +----
 include/trace/events/sock.h | 4 ++--
 include/trace/events/tcp.h  | 2 +-
 net/ipv4/ip_output.c        | 5 +++--
 net/ipv6/ping.c             | 2 +-
 net/ipv6/udp.c              | 2 +-
 net/mptcp/sockopt.c         | 2 +-
 security/lsm_audit.c        | 4 ++--
 8 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 51857117ac0995cee20c1e62752c470d2a473fa8..caa20a9055310f5ef108f9b1bb43214a3d598b9e 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -305,10 +305,7 @@ static inline struct sock *skb_to_full_sk(const struct sk_buff *skb)
 	return sk_to_full_sk(skb->sk);
 }
 
-static inline struct inet_sock *inet_sk(const struct sock *sk)
-{
-	return (struct inet_sock *)sk;
-}
+#define inet_sk(ptr) container_of_const(ptr, struct inet_sock, sk)
 
 static inline void __inet_sk_copy_descendant(struct sock *sk_to,
 					     const struct sock *sk_from,
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 03d19fc562f872d68cfb2349797f0924cfba718b..fd206a6ab5b85a8eb50fc9303abc28d74c50ea07 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -158,7 +158,7 @@ TRACE_EVENT(inet_sock_set_state,
 	),
 
 	TP_fast_assign(
-		struct inet_sock *inet = inet_sk(sk);
+		const struct inet_sock *inet = inet_sk(sk);
 		struct in6_addr *pin6;
 		__be32 *p32;
 
@@ -222,7 +222,7 @@ TRACE_EVENT(inet_sk_error_report,
 	),
 
 	TP_fast_assign(
-		struct inet_sock *inet = inet_sk(sk);
+		const struct inet_sock *inet = inet_sk(sk);
 		struct in6_addr *pin6;
 		__be32 *p32;
 
diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 901b440238d5fc203b78cff1081b4b7e1e2eb4bd..bf06db8d2046c4a7f59070b724ce6fc7762f9d4b 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -67,7 +67,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 	),
 
 	TP_fast_assign(
-		struct inet_sock *inet = inet_sk(sk);
+		const struct inet_sock *inet = inet_sk(sk);
 		__be32 *p32;
 
 		__entry->skbaddr = skb;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index e7bef36ce26f5b5e5503eaf14319b2465b779598..cb04dbad9ea474fcaa4b5ba31c4a37299c4e1a8d 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -129,7 +129,8 @@ int ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(ip_local_out);
 
-static inline int ip_select_ttl(struct inet_sock *inet, struct dst_entry *dst)
+static inline int ip_select_ttl(const struct inet_sock *inet,
+				const struct dst_entry *dst)
 {
 	int ttl = inet->uc_ttl;
 
@@ -146,7 +147,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 			  __be32 saddr, __be32 daddr, struct ip_options_rcu *opt,
 			  u8 tos)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 	struct rtable *rt = skb_rtable(skb);
 	struct net *net = sock_net(sk);
 	struct iphdr *iph;
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 808983bc2ec9f92be7d13237fb7d52b6423ccf23..c4835dbdfcff7912465713cdac9914b0f5585972 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -237,7 +237,7 @@ static int ping_v6_seq_show(struct seq_file *seq, void *v)
 		seq_puts(seq, IPV6_SEQ_DGRAM_HEADER);
 	} else {
 		int bucket = ((struct ping_iter_state *) seq->private)->bucket;
-		struct inet_sock *inet = inet_sk(v);
+		struct inet_sock *inet = inet_sk((struct sock *)v);
 		__u16 srcp = ntohs(inet->inet_sport);
 		__u16 destp = ntohs(inet->inet_dport);
 		ip6_dgram_sock_seq_show(seq, v, srcp, destp, bucket);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9fb2f33ee3a76a09bbe15a9aaf1371a804f91ee2..ab4ae886235ac9557219c901c5041adfa8b026ef 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1708,7 +1708,7 @@ int udp6_seq_show(struct seq_file *seq, void *v)
 		seq_puts(seq, IPV6_SEQ_DGRAM_HEADER);
 	} else {
 		int bucket = ((struct udp_iter_state *)seq->private)->bucket;
-		struct inet_sock *inet = inet_sk(v);
+		const struct inet_sock *inet = inet_sk((const struct sock *)v);
 		__u16 srcp = ntohs(inet->inet_sport);
 		__u16 destp = ntohs(inet->inet_dport);
 		__ip6_dgram_sock_seq_show(seq, v, srcp, destp,
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 8a9656248b0f09e78ebf3d6d787449f33505b81f..5cef4d3d21ac824ab6d3a5ee8be3bd00cce63925 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1046,7 +1046,7 @@ static int mptcp_getsockopt_tcpinfo(struct mptcp_sock *msk, char __user *optval,
 
 static void mptcp_get_sub_addrs(const struct sock *sk, struct mptcp_subflow_addrs *a)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 
 	memset(a, 0, sizeof(*a));
 
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index a7355b4b9bb86d173f94e43109148bc0ea27d1b3..00d3bdd386e294ecd562bfa8ce502bf179ad32d9 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -317,7 +317,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 
 			switch (sk->sk_family) {
 			case AF_INET: {
-				struct inet_sock *inet = inet_sk(sk);
+				const struct inet_sock *inet = inet_sk(sk);
 
 				print_ipv4_addr(ab, inet->inet_rcv_saddr,
 						inet->inet_sport,
@@ -329,7 +329,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 			}
 #if IS_ENABLED(CONFIG_IPV6)
 			case AF_INET6: {
-				struct inet_sock *inet = inet_sk(sk);
+				const struct inet_sock *inet = inet_sk(sk);
 
 				print_ipv6_addr(ab, &sk->sk_v6_rcv_saddr,
 						inet->inet_sport,
-- 
2.40.0.rc2.332.ga46443480c-goog

