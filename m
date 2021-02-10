Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72DE315D30
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhBJCZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbhBJCWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 21:22:44 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FC0C06174A;
        Tue,  9 Feb 2021 18:21:57 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id l3so431857oii.2;
        Tue, 09 Feb 2021 18:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KeZhs2zEcflbxP+B5W8XyBm5zkrRjIqJq/LYFXgAr+M=;
        b=DCnzkwCUFRfAPX4J9r50EPTkk2gx/n9bELleIIDnzJ/Bl13MCJd3BS2PwW1pNY4IZ4
         9CQRDYCMXN8m7wQsJfekoTPcodHBe6ggiHU3/XlRXpSgiYhoZnHSRFToModCZVz5acPR
         8xeIlCVKE6DPGSz6FVWIbHpq5EsfHQ+7lhXj+nxTn18hkRWbs4N9A4tzA1KgiWSsN+VL
         vSGTA2MzDj2+DLdRrE4xgURPzWwSwxjKZm71vvrurx83w6N4sNDFMJ1DvjYiqj3CYeFW
         X2whogsFD8QeIVnzlDpCu6hJ6rYCcuZw1NXoDBv3BU3MQPNW3moZqsWoJoJkzYbVSDu6
         F4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KeZhs2zEcflbxP+B5W8XyBm5zkrRjIqJq/LYFXgAr+M=;
        b=jggSu6dII2CfEhVJtmQQcPYmy3UJQJo4QSeJDtCS0e5PWtIi41B6euqJXsmlVvEqIk
         K1CHEFPeZATKrJkbAiFKKc2jyaTlKH2OfXfxCayTsPavFjFlc9iI5sQvNGephg+tJSO8
         3JylU6yM/oXjV8hcfUXBmdsWzm2x24uwKlZ1EBzruj3NNV7k4QVLBIHz+5SKynlaoORL
         AUHhIDiWYiNf8DvnzZbVMH43AQKtBgTW/tGy3dAiijau8oSh6uY+gQ7h//6JMfj46dKh
         0Vte/hzB37lPJlDpnA8mFILVqDcwkfbqf0Cn8/2O9bdKCnIJyYpcjFJK/EAj3HfWVK8H
         oSdA==
X-Gm-Message-State: AOAM533UjKFpN7GYhgdaUlwhMTc9AFATpmWUF7d0l9rUbVXh+fPfYaL7
        czH3mjWYhq/fx993aZnJK+C8pIjqxivv1Q==
X-Google-Smtp-Source: ABdhPJxiKVdbJOiiAKCQUnHnnikB2AzwR2gtUhdPWKnvFjnCGpXNbOI8R525zsOwK5uDvMVM/6Doaw==
X-Received: by 2002:aca:db03:: with SMTP id s3mr587869oig.48.1612923717176;
        Tue, 09 Feb 2021 18:21:57 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:58b0:eb39:33aa:5355])
        by smtp.gmail.com with ESMTPSA id z20sm101051oth.55.2021.02.09.18.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 18:21:56 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 1/5] bpf: clean up sockmap related Kconfigs
Date:   Tue,  9 Feb 2021 18:21:32 -0800
Message-Id: <20210210022136.146528-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
References: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

As suggested by John, clean up sockmap related Kconfigs:

Reduce the scope of CONFIG_BPF_STREAM_PARSER down to TCP stream
parser, to reflect its name.

Make the rest sockmap code simply depend on CONFIG_BPF_SYSCALL.
And leave CONFIG_NET_SOCK_MSG untouched, as it is used by
non-sockmap cases.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h       |  20 +++----
 include/linux/bpf_types.h |   2 -
 include/linux/skmsg.h     |  15 +++++
 include/net/tcp.h         |   4 +-
 include/net/udp.h         |   4 +-
 init/Kconfig              |   1 +
 net/Kconfig               |   6 +-
 net/core/Makefile         |   2 +-
 net/core/skmsg.c          | 112 +++++++++++++++++++-------------------
 net/core/sock_map.c       |   2 +
 net/ipv4/Makefile         |   2 +-
 net/ipv4/tcp_bpf.c        |   2 -
 12 files changed, 91 insertions(+), 81 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 321966fc35db..21277ad84b03 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1744,6 +1744,14 @@ static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
 
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr);
 void bpf_map_offload_map_free(struct bpf_map *map);
+
+int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
+			 struct bpf_prog *old, u32 which);
+int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
+int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
+int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
+void sock_map_unhash(struct sock *sk);
+void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 					union bpf_attr *attr)
@@ -1769,17 +1777,7 @@ static inline struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 static inline void bpf_map_offload_map_free(struct bpf_map *map)
 {
 }
-#endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
 
-#if defined(CONFIG_BPF_STREAM_PARSER)
-int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
-			 struct bpf_prog *old, u32 which);
-int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
-int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
-int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
-void sock_map_unhash(struct sock *sk);
-void sock_map_close(struct sock *sk, long timeout);
-#else
 static inline int sock_map_prog_update(struct bpf_map *map,
 				       struct bpf_prog *prog,
 				       struct bpf_prog *old, u32 which)
@@ -1804,7 +1802,7 @@ static inline int sock_map_update_elem_sys(struct bpf_map *map, void *key, void
 {
 	return -EOPNOTSUPP;
 }
-#endif /* CONFIG_BPF_STREAM_PARSER */
+#endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
 
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
 void bpf_sk_reuseport_detach(struct sock *sk);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 99f7fd657d87..d6b4a657c885 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -103,10 +103,8 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
-#if defined(CONFIG_BPF_STREAM_PARSER)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKMAP, sock_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKHASH, sock_hash_ops)
-#endif
 #ifdef CONFIG_BPF_LSM
 BPF_MAP_TYPE(BPF_MAP_TYPE_INODE_STORAGE, inode_storage_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_TASK_STORAGE, task_storage_map_ops)
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 8edbbf5f2f93..f0e72dca9bfd 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -305,9 +305,24 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
 
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
 void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock);
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock);
+#else
+static inline int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
+{
+}
+
+static inline void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
+{
+}
+#endif
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock);
 void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock);
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4bb42fb19711..dfb20d51bf3d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2207,14 +2207,14 @@ void tcp_update_ulp(struct sock *sk, struct proto *p,
 struct sk_msg;
 struct sk_psock;
 
-#ifdef CONFIG_BPF_STREAM_PARSER
+#ifdef CONFIG_BPF
 struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #else
 static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 {
 }
-#endif /* CONFIG_BPF_STREAM_PARSER */
+#endif /* CONFIG_BPF */
 
 #ifdef CONFIG_NET_SOCK_MSG
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
diff --git a/include/net/udp.h b/include/net/udp.h
index 877832bed471..c279af05fd8d 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -511,9 +511,9 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	return segs;
 }
 
-#ifdef CONFIG_BPF_STREAM_PARSER
+#ifdef CONFIG_BPF
 struct sk_psock;
 struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
-#endif /* BPF_STREAM_PARSER */
+#endif /* CONFIG_BPF */
 
 #endif	/* _UDP_H */
diff --git a/init/Kconfig b/init/Kconfig
index b77c60f8b963..55d730811873 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1703,6 +1703,7 @@ config BPF_SYSCALL
 	select BPF
 	select IRQ_WORK
 	select TASKS_TRACE_RCU
+	select NET_SOCK_MSG
 	default n
 	help
 	  Enable the bpf() system call that allows to manipulate eBPF
diff --git a/net/Kconfig b/net/Kconfig
index f4c32d982af6..a4f60d0c630f 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -313,13 +313,9 @@ config BPF_STREAM_PARSER
 	select STREAM_PARSER
 	select NET_SOCK_MSG
 	help
-	  Enabling this allows a stream parser to be used with
+	  Enabling this allows a TCP stream parser to be used with
 	  BPF_MAP_TYPE_SOCKMAP.
 
-	  BPF_MAP_TYPE_SOCKMAP provides a map type to use with network sockets.
-	  It can be used to enforce socket policy, implement socket redirects,
-	  etc.
-
 config NET_FLOW_LIMIT
 	bool
 	depends on RPS
diff --git a/net/core/Makefile b/net/core/Makefile
index 3e2c378e5f31..05733689d050 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -28,10 +28,10 @@ obj-$(CONFIG_CGROUP_NET_PRIO) += netprio_cgroup.o
 obj-$(CONFIG_CGROUP_NET_CLASSID) += netclassid_cgroup.o
 obj-$(CONFIG_LWTUNNEL) += lwtunnel.o
 obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
-obj-$(CONFIG_BPF_STREAM_PARSER) += sock_map.o
 obj-$(CONFIG_DST_CACHE) += dst_cache.o
 obj-$(CONFIG_HWBM) += hwbm.o
 obj-$(CONFIG_NET_DEVLINK) += devlink.o
 obj-$(CONFIG_GRO_CELLS) += gro_cells.o
 obj-$(CONFIG_FAILOVER) += failover.o
+obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1261512d6807..47c8891bb5b4 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -866,6 +866,24 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 	}
 }
 
+static void sk_psock_write_space(struct sock *sk)
+{
+	struct sk_psock *psock;
+	void (*write_space)(struct sock *sk) = NULL;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (likely(psock)) {
+		if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
+			schedule_work(&psock->work);
+		write_space = psock->saved_write_space;
+	}
+	rcu_read_unlock();
+	if (write_space)
+		write_space(sk);
+}
+
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 {
 	struct sk_psock *psock;
@@ -933,6 +951,45 @@ static void sk_psock_strp_data_ready(struct sock *sk)
 	rcu_read_unlock();
 }
 
+int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
+{
+	static const struct strp_callbacks cb = {
+		.rcv_msg	= sk_psock_strp_read,
+		.read_sock_done	= sk_psock_strp_read_done,
+		.parse_msg	= sk_psock_strp_parse,
+	};
+
+	psock->parser.enabled = false;
+	return strp_init(&psock->parser.strp, sk, &cb);
+}
+
+void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
+{
+	struct sk_psock_parser *parser = &psock->parser;
+
+	if (parser->enabled)
+		return;
+
+	parser->saved_data_ready = sk->sk_data_ready;
+	sk->sk_data_ready = sk_psock_strp_data_ready;
+	sk->sk_write_space = sk_psock_write_space;
+	parser->enabled = true;
+}
+
+void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
+{
+	struct sk_psock_parser *parser = &psock->parser;
+
+	if (!parser->enabled)
+		return;
+
+	sk->sk_data_ready = parser->saved_data_ready;
+	parser->saved_data_ready = NULL;
+	strp_stop(&parser->strp);
+	parser->enabled = false;
+}
+#endif
+
 static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 				 unsigned int offset, size_t orig_len)
 {
@@ -984,35 +1041,6 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
 	sock->ops->read_sock(sk, &desc, sk_psock_verdict_recv);
 }
 
-static void sk_psock_write_space(struct sock *sk)
-{
-	struct sk_psock *psock;
-	void (*write_space)(struct sock *sk) = NULL;
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (likely(psock)) {
-		if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
-			schedule_work(&psock->work);
-		write_space = psock->saved_write_space;
-	}
-	rcu_read_unlock();
-	if (write_space)
-		write_space(sk);
-}
-
-int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
-{
-	static const struct strp_callbacks cb = {
-		.rcv_msg	= sk_psock_strp_read,
-		.read_sock_done	= sk_psock_strp_read_done,
-		.parse_msg	= sk_psock_strp_parse,
-	};
-
-	psock->parser.enabled = false;
-	return strp_init(&psock->parser.strp, sk, &cb);
-}
-
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
 {
 	struct sk_psock_parser *parser = &psock->parser;
@@ -1026,32 +1054,6 @@ void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
 	parser->enabled = true;
 }
 
-void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
-{
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (parser->enabled)
-		return;
-
-	parser->saved_data_ready = sk->sk_data_ready;
-	sk->sk_data_ready = sk_psock_strp_data_ready;
-	sk->sk_write_space = sk_psock_write_space;
-	parser->enabled = true;
-}
-
-void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
-{
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (!parser->enabled)
-		return;
-
-	sk->sk_data_ready = parser->saved_data_ready;
-	parser->saved_data_ready = NULL;
-	strp_stop(&parser->strp);
-	parser->enabled = false;
-}
-
 void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
 {
 	struct sk_psock_parser *parser = &psock->parser;
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index d758fb83c884..ee3334dd3a38 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1461,9 +1461,11 @@ int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 	case BPF_SK_MSG_VERDICT:
 		pprog = &progs->msg_parser;
 		break;
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 	case BPF_SK_SKB_STREAM_PARSER:
 		pprog = &progs->skb_parser;
 		break;
+#endif
 	case BPF_SK_SKB_STREAM_VERDICT:
 		pprog = &progs->skb_verdict;
 		break;
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 5b77a46885b9..49debfefcc62 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -62,7 +62,7 @@ obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
-obj-$(CONFIG_BPF_STREAM_PARSER) += udp_bpf.o
+obj-$(CONFIG_NET_SOCK_MSG) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index bc7d2a586e18..1de5b62d8d09 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -229,7 +229,6 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 }
 EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 
-#ifdef CONFIG_BPF_STREAM_PARSER
 static bool tcp_bpf_stream_read(const struct sock *sk)
 {
 	struct sk_psock *psock;
@@ -629,4 +628,3 @@ void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
 		newsk->sk_prot = sk->sk_prot_creator;
 }
-#endif /* CONFIG_BPF_STREAM_PARSER */
-- 
2.25.1

