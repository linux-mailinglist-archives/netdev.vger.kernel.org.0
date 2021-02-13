Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1283731AE2D
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 22:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBMVpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 16:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBMVpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 16:45:11 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E7DC061756;
        Sat, 13 Feb 2021 13:44:29 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id e5so2667220otb.11;
        Sat, 13 Feb 2021 13:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vGSzv6aW1cq38YjdUdveUIsYYlD/s+AxTe5p3NdkN2k=;
        b=q8H6hRmjq5qDd0tjiZWObLSWK8b5u1mkVSH1Zb9RTEG6q/d4cr0Yt3YgAdGV6hSSXO
         HKCs2pZYSkGBoY6TSVOVc4ewVPVIxBd8iXtblB1/defgxU5E2uSm9oubpLG/BLTbdFQn
         BK9mGy39BE06UOG//rpcFMpHkKTdv/mapqvyBjaA4McUWz9ssaeH9vvWVnOSJctJg1RZ
         5WEEt0QyEQTm+96JCpdJWXexwtZlQ4zWg+H46vcAM/3EaOvsSqeMjaWkmWHjTTkwzfMg
         Q1vie0CntwstJbR2kuQznDqGRLjkT/lYREAA5z5PMdq/rpEux8HTwaNdJjTH/7ZYXNcO
         M+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vGSzv6aW1cq38YjdUdveUIsYYlD/s+AxTe5p3NdkN2k=;
        b=JannD0uVuLvq4lTOiGWlBzE0dygjPtYqafcXFfL5EjyEQ42pE0VR9+3ATaRhE6qlbx
         caTXo6LDi+L3GOq7F4zmA8e/uAVxSH3nJ1exK/juyf3ebZfhvRtujAGHE9sH3mD6p0a0
         M8pGpe4GqaSNzn/maPxobTLc0CfgeTeS+ATqU8wbHoYuzlK3w1Hy2w+KLLvgWLupgT0R
         EzAgBFmY5IZ2nnSZ3Hqe6iSCIlkOfIEJjVT8KYx+JydzvQcyOaH6697dRu+8rBFkgG2V
         N3Bz0RxQP+ufDVkfMOGts6OQb3cuo+cI+2J1VDOIMy4CnuThn0MT7+c1BkQh+OcE//NS
         CjjQ==
X-Gm-Message-State: AOAM53098kyIbX3nRmzyK1/l6cXq/bZ6S5kpDj60Fl9Wlto6I9yc4L/f
        EKRmcNcNTjtYbz6Mjh8KM7ze6sD3OGVnJA==
X-Google-Smtp-Source: ABdhPJwCyVGAtYpnBphRARhY7PZF1rFY2QxjiEYOSVFylC5jn3gR/3ut+FpEHYmWJlBk5j+UULNjSQ==
X-Received: by 2002:a9d:5a05:: with SMTP id v5mr6696664oth.17.1613252668490;
        Sat, 13 Feb 2021 13:44:28 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:108:c15a:7f7a:df71])
        by smtp.gmail.com with ESMTPSA id c17sm2509674otp.58.2021.02.13.13.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 13:44:28 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 1/5] bpf: clean up sockmap related Kconfigs
Date:   Sat, 13 Feb 2021 13:44:17 -0800
Message-Id: <20210213214421.226357-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
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
 include/linux/bpf.h       |  20 +++---
 include/linux/bpf_types.h |   2 -
 include/linux/skmsg.h     |  22 ++++++
 include/net/tcp.h         |  13 ++--
 include/net/udp.h         |   4 +-
 init/Kconfig              |   1 +
 net/Kconfig               |   6 +-
 net/core/Makefile         |   2 +-
 net/core/skmsg.c          | 139 ++++++++++++++++++++------------------
 net/core/sock_map.c       |   2 +
 net/ipv4/Makefile         |   2 +-
 net/ipv4/tcp_bpf.c        |   2 -
 12 files changed, 117 insertions(+), 98 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cccaef1088ea..e29600f01585 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1741,6 +1741,14 @@ static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
 
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
@@ -1766,17 +1774,7 @@ static inline struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
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
@@ -1801,7 +1799,7 @@ static inline int sock_map_update_elem_sys(struct bpf_map *map, void *key, void
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
index 8edbbf5f2f93..041faef00937 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -71,7 +71,9 @@ struct sk_psock_link {
 };
 
 struct sk_psock_parser {
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 	struct strparser		strp;
+#endif
 	bool				enabled;
 	void (*saved_data_ready)(struct sock *sk);
 };
@@ -305,9 +307,29 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
 
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
 void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock);
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock);
+void sk_psock_done_strp(struct sk_psock *psock);
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
+
+static inline void sk_psock_done_strp(struct sk_psock *psock)
+{
+}
+#endif
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock);
 void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock);
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4bb42fb19711..99fdbf03aeee 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2204,23 +2204,20 @@ void tcp_update_ulp(struct sock *sk, struct proto *p,
 	__MODULE_INFO(alias, alias_userspace, name);		\
 	__MODULE_INFO(alias, alias_tcp_ulp, "tcp-ulp-" name)
 
+#ifdef CONFIG_NET_SOCK_MSG
 struct sk_msg;
 struct sk_psock;
-
-#ifdef CONFIG_BPF_STREAM_PARSER
 struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
-#else
-static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
-{
-}
-#endif /* CONFIG_BPF_STREAM_PARSER */
 
-#ifdef CONFIG_NET_SOCK_MSG
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
 			  int flags);
 int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		      struct msghdr *msg, int len, int flags);
+#else
+static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
+{
+}
 #endif /* CONFIG_NET_SOCK_MSG */
 
 #ifdef CONFIG_CGROUP_BPF
diff --git a/include/net/udp.h b/include/net/udp.h
index 877832bed471..fcc73cc50007 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -511,9 +511,9 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	return segs;
 }
 
-#ifdef CONFIG_BPF_STREAM_PARSER
+#ifdef CONFIG_NET_SOCK_MSG
 struct sk_psock;
 struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
-#endif /* BPF_STREAM_PARSER */
+#endif /* CONFIG_NET_SOCK_MSG */
 
 #endif	/* _UDP_H */
diff --git a/init/Kconfig b/init/Kconfig
index b77c60f8b963..163d76019f59 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1703,6 +1703,7 @@ config BPF_SYSCALL
 	select BPF
 	select IRQ_WORK
 	select TASKS_TRACE_RCU
+	select NET_SOCK_MSG if NET
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
index 1261512d6807..6cb5ff6f8f9c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -651,9 +651,7 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 
 	/* No sk_callback_lock since already detached. */
 
-	/* Parser has been stopped */
-	if (psock->progs.skb_parser)
-		strp_done(&psock->parser.strp);
+	sk_psock_done_strp(psock);
 
 	cancel_work_sync(&psock->work);
 
@@ -750,14 +748,6 @@ static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 	return bpf_prog_run_pin_on_cpu(prog, skb);
 }
 
-static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
-{
-	struct sk_psock_parser *parser;
-
-	parser = container_of(strp, struct sk_psock_parser, strp);
-	return container_of(parser, struct sk_psock, parser);
-}
-
 static void sk_psock_skb_redirect(struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
@@ -866,6 +856,24 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
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
@@ -897,6 +905,14 @@ static int sk_psock_strp_read_done(struct strparser *strp, int err)
 	return err;
 }
 
+static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
+{
+	struct sk_psock_parser *parser;
+
+	parser = container_of(strp, struct sk_psock_parser, strp);
+	return container_of(parser, struct sk_psock, parser);
+}
+
 static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 {
 	struct sk_psock *psock = sk_psock_from_strp(strp);
@@ -933,6 +949,52 @@ static void sk_psock_strp_data_ready(struct sock *sk)
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
+
+void sk_psock_done_strp(struct sk_psock *psock)
+{
+	/* Parser has been stopped */
+	if (psock->progs.skb_parser)
+		strp_done(&psock->parser.strp);
+}
+#endif
+
 static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 				 unsigned int offset, size_t orig_len)
 {
@@ -984,35 +1046,6 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
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
@@ -1026,32 +1059,6 @@ void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
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

