Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE01930D26F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhBCERs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbhBCERg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:17:36 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CFEC06174A;
        Tue,  2 Feb 2021 20:16:56 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id k25so25379454oik.13;
        Tue, 02 Feb 2021 20:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5HRWSbLtPDag7SiNqYpgFvHK80P7pmdpmcgHM2bBEUw=;
        b=fs0M2UAX9+eW3VgxKgpghsMg3kB6UpHz0gUcL+wzjrAeKgj0pfNXi/ZryWb39mWE2i
         md4OGSsXyNXFryTstkF06LoXrSPmQ2qgCTYQTa6HL36wptCJq9EYuVbVUih8ZUrfOLBm
         b82nYl/9BLdqmIWPAXa3m8M/n48ZAdDH3/Zv61lzX27J/LyPd7EOAAbpRatFfFuqz7Rt
         3UhGVXPCFWKjqj5Rykk3z//Q3sESHyRNxK1dPTjPr6JUqKZTrx1OjKTQlA2QcCStBeEB
         gp0czW4cIf1S1WKU5gKrHMfnIRhjDPnGTU8ubrEus+zSxB4ZnTLI3kBXZlIXg+HzevTj
         tAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5HRWSbLtPDag7SiNqYpgFvHK80P7pmdpmcgHM2bBEUw=;
        b=cdndaVmSEAK7r3uoYmhZ0fzAh6fpJ0FDje0Wv1q6B+pe7mfSWxanKuRDdveM9/A+Tk
         mckRRoaK0ki+I+IUUrGn+b4Un713ahWOrkxwZtZuDmRU83M7UyGbImqosfzaSIA14CcB
         N2URshoTPtWNw13KAfXEjKsDoYJQukdLNE+pbZEvF3RLTUNPDcBCL8MsgA/9nZo0qRnM
         YEFGb24jqgJsm0Sxh+cwqf6YuaTLGNRWDRhh5ndi0GXf1Cj6kGInzQTtbHJQtv6zvWQN
         SLYthlrjmXkgf0Z1soa97WKxl3UGwe+rnQt/A5LdlzbbdEn0Z+mgbLnIEBSSFQ5Ceb6e
         5VHA==
X-Gm-Message-State: AOAM530ZuYFisg3YPMsJ6FGH2488YUym0Ahrz89qh6n8lVARCZT33bA+
        c2N/vtLbgaEuk2ne1rFfWljEfnfA6F1UOA==
X-Google-Smtp-Source: ABdhPJz2XhEJ8vp4kK1mKNUekKl0O/HIqh5Ksh/ptQpUwh5FRKJLQOnsQ0VOv+kZ+8rLvTd1T8K7/w==
X-Received: by 2002:aca:de06:: with SMTP id v6mr831034oig.60.1612325815153;
        Tue, 02 Feb 2021 20:16:55 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:16:54 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 01/19] bpf: rename BPF_STREAM_PARSER to BPF_SOCK_MAP
Date:   Tue,  2 Feb 2021 20:16:18 -0800
Message-Id: <20210203041636.38555-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Before we add non-TCP support, it is necessary to rename
BPF_STREAM_PARSER as it will be no longer specific to TCP,
and it does not have to be a parser either.

This patch renames BPF_STREAM_PARSER to BPF_SOCK_MAP, so
that sock_map.c hopefully would be protocol-independent.

Also, improve its Kconfig description to avoid confusion.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h       |  4 ++--
 include/linux/bpf_types.h |  2 +-
 include/net/tcp.h         |  4 ++--
 include/net/udp.h         |  4 ++--
 net/Kconfig               | 13 ++++++-------
 net/core/Makefile         |  2 +-
 net/ipv4/Makefile         |  2 +-
 net/ipv4/tcp_bpf.c        |  4 ++--
 8 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 321966fc35db..b5af6a4e9927 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1771,7 +1771,7 @@ static inline void bpf_map_offload_map_free(struct bpf_map *map)
 }
 #endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
 
-#if defined(CONFIG_BPF_STREAM_PARSER)
+#if defined(CONFIG_BPF_SOCK_MAP)
 int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 			 struct bpf_prog *old, u32 which);
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
@@ -1804,7 +1804,7 @@ static inline int sock_map_update_elem_sys(struct bpf_map *map, void *key, void
 {
 	return -EOPNOTSUPP;
 }
-#endif /* CONFIG_BPF_STREAM_PARSER */
+#endif /* CONFIG_BPF_SOCK_MAP */
 
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
 void bpf_sk_reuseport_detach(struct sock *sk);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 99f7fd657d87..6e27726ae578 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -103,7 +103,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
-#if defined(CONFIG_BPF_STREAM_PARSER)
+#if defined(CONFIG_BPF_SOCK_MAP)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKMAP, sock_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKHASH, sock_hash_ops)
 #endif
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4bb42fb19711..be66571ad122 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2207,14 +2207,14 @@ void tcp_update_ulp(struct sock *sk, struct proto *p,
 struct sk_msg;
 struct sk_psock;
 
-#ifdef CONFIG_BPF_STREAM_PARSER
+#ifdef CONFIG_BPF_SOCK_MAP
 struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #else
 static inline void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 {
 }
-#endif /* CONFIG_BPF_STREAM_PARSER */
+#endif /* CONFIG_BPF_SOCK_MAP */
 
 #ifdef CONFIG_NET_SOCK_MSG
 int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
diff --git a/include/net/udp.h b/include/net/udp.h
index 877832bed471..0ff921e6b866 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -511,9 +511,9 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	return segs;
 }
 
-#ifdef CONFIG_BPF_STREAM_PARSER
+#ifdef CONFIG_BPF_SOCK_MAP
 struct sk_psock;
 struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
-#endif /* BPF_STREAM_PARSER */
+#endif /* CONFIG_BPF_SOCK_MAP */
 
 #endif	/* _UDP_H */
diff --git a/net/Kconfig b/net/Kconfig
index f4c32d982af6..0cc0805a8127 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -305,20 +305,19 @@ config BPF_JIT
 	  /proc/sys/net/core/bpf_jit_harden   (optional)
 	  /proc/sys/net/core/bpf_jit_kallsyms (optional)
 
-config BPF_STREAM_PARSER
-	bool "enable BPF STREAM_PARSER"
+config BPF_SOCK_MAP
+	bool "enable BPF socket maps"
 	depends on INET
 	depends on BPF_SYSCALL
 	depends on CGROUP_BPF
 	select STREAM_PARSER
 	select NET_SOCK_MSG
 	help
-	  Enabling this allows a stream parser to be used with
-	  BPF_MAP_TYPE_SOCKMAP.
+	  Enabling this allows skb parser and verdict to be used with
+	  BPF_MAP_TYPE_SOCKMAP or BPF_MAP_TYPE_SOCKHASH.
 
-	  BPF_MAP_TYPE_SOCKMAP provides a map type to use with network sockets.
-	  It can be used to enforce socket policy, implement socket redirects,
-	  etc.
+	  This provides a BPF map type to use with network sockets. It can
+	  be used to enforce socket policy, implement socket redirects, etc.
 
 config NET_FLOW_LIMIT
 	bool
diff --git a/net/core/Makefile b/net/core/Makefile
index 3e2c378e5f31..e7c1bdaadefd 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_CGROUP_NET_PRIO) += netprio_cgroup.o
 obj-$(CONFIG_CGROUP_NET_CLASSID) += netclassid_cgroup.o
 obj-$(CONFIG_LWTUNNEL) += lwtunnel.o
 obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
-obj-$(CONFIG_BPF_STREAM_PARSER) += sock_map.o
+obj-$(CONFIG_BPF_SOCK_MAP) += sock_map.o
 obj-$(CONFIG_DST_CACHE) += dst_cache.o
 obj-$(CONFIG_HWBM) += hwbm.o
 obj-$(CONFIG_NET_DEVLINK) += devlink.o
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 5b77a46885b9..f72f84d1b982 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -62,7 +62,7 @@ obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
-obj-$(CONFIG_BPF_STREAM_PARSER) += udp_bpf.o
+obj-$(CONFIG_BPF_SOCK_MAP) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index bc7d2a586e18..2252f1d90676 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -229,7 +229,7 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 }
 EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 
-#ifdef CONFIG_BPF_STREAM_PARSER
+#ifdef CONFIG_BPF_SOCK_MAP
 static bool tcp_bpf_stream_read(const struct sock *sk)
 {
 	struct sk_psock *psock;
@@ -629,4 +629,4 @@ void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
 	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
 		newsk->sk_prot = sk->sk_prot_creator;
 }
-#endif /* CONFIG_BPF_STREAM_PARSER */
+#endif /* CONFIG_BPF_SOCK_MAP */
-- 
2.25.1

