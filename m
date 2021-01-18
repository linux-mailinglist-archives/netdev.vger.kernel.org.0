Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F892FA372
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404860AbhAROle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393085AbhAROkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:40:46 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E95C0613C1;
        Mon, 18 Jan 2021 06:40:06 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id md11so9657553pjb.0;
        Mon, 18 Jan 2021 06:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lFmA9TnP9NE8OaeHmI0MhXoMypeEzomf+Eb9FD+FhuU=;
        b=pLU/aVXPocVbCZ0riNNXLjJBUe7Zv03l79sxJ6FkYxvDI3Aj074kVQpt8AxRNAHC9E
         Q1p/VVi9DcFV1/MZiHr9iM6oT5Xcnb2yo8LTeVRKJTalf3CJInFfHxKyn8Vbh4H+kjLz
         gNmlfnBqlYi/jM/T+d/rq5lTXx3ZiFDhcR7N1jciBW2b5GgaSc0rYPgAgme3VA0gjnrL
         b2pg1MLIzu3Zjhbtd4oPCHhbHqOzJb6yPePfsrWR3yeFeEcWXBJ2NhpJ8ZWC5EZRrWDe
         utcMfkNfNSW8VjxAgxI9jfVKCjippXZ7wsuTB5ZasfXfg6mSSKdyefEXk/bJ/uPNbijE
         Vc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lFmA9TnP9NE8OaeHmI0MhXoMypeEzomf+Eb9FD+FhuU=;
        b=FKOcS64i5LjRkMIqtWnHOzAe9ybmrReEGLKfNj628mcnZIpGjijKANvtM7QnilkD5p
         j7PevwhJNgUrKh6t5MT6XYw81wZB8zhmETrAF5VPAXqMaulWw+k9SU7m5DERdf8hI9qZ
         x8g5s39DCHUhCg6hVt5t/txsbr9zBGoSqUIfSHGT8c+1Pdb3t+t6803uVvhfmnNPhQ8W
         KnJicQ4VhcATJ9hDEPel+KCxubavhp4STSGwAXMUdNbXsFgfD2wc7AMvFa+LnY3hoClY
         AUlqVkpBpuoI20gYSttU9kydr92SuEeiE/XLtxB9jAecr1/nGp43I4IasRo6FPdJESTU
         Lylw==
X-Gm-Message-State: AOAM5300ufX5LTp8NfeMSIIWjrwvEQomuQCt/frIHitR3UPlVrNj3Blo
        f6BDYzHMHY8Y0RhrYjWa1f0=
X-Google-Smtp-Source: ABdhPJy+buD3uEUWJFMyhCWmvswVpc7p0czFqcV7apnWeiqJoxWb4PuP1M9/49UH4vGGJQA9ICdnBQ==
X-Received: by 2002:a17:902:ed11:b029:de:2f19:4db1 with SMTP id b17-20020a170902ed11b02900de2f194db1mr27088125pld.20.1610980805726;
        Mon, 18 Jan 2021 06:40:05 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id b12sm17324051pgr.9.2021.01.18.06.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 06:40:05 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org, christian.brauner@ubuntu.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dong.menglong@zte.com.cn, daniel@iogearbox.net, gnault@redhat.com,
        ast@kernel.org, nicolas.dichtel@6wind.com, ap420073@gmail.com,
        edumazet@google.com, pabeni@redhat.com, jakub@cloudflare.com,
        bjorn.topel@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, rdna@fb.com, maheshb@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: core: Namespace-ify sysctl_rmem_max and sysctl_wmem_max
Date:   Mon, 18 Jan 2021 22:39:32 +0800
Message-Id: <20210118143932.56069-4-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118143932.56069-1-dong.menglong@zte.com.cn>
References: <20210118143932.56069-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

For now, sysctl_wmem_max and sysctl_rmem_max are globally unified.
It's not convenient in some case. For example, when we use docker
and try to control the default udp socket receive buffer for each
container.

For that reason, make sysctl_wmem_max and sysctl_rmem_max
per-namespace.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 include/net/netns/core.h        |  2 ++
 include/net/sock.h              |  3 ---
 net/core/filter.c               |  4 ++--
 net/core/net_namespace.c        |  2 ++
 net/core/sock.c                 | 12 ++++--------
 net/core/sysctl_net_core.c      | 32 ++++++++++++++++----------------
 net/ipv4/tcp_output.c           |  2 +-
 net/netfilter/ipvs/ip_vs_sync.c |  4 ++--
 8 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/include/net/netns/core.h b/include/net/netns/core.h
index 317b47df6d08..b4aecac6e8ce 100644
--- a/include/net/netns/core.h
+++ b/include/net/netns/core.h
@@ -11,6 +11,8 @@ struct netns_core {
 
 	int sysctl_wmem_default;
 	int sysctl_rmem_default;
+	int sysctl_wmem_max;
+	int sysctl_rmem_max;
 	int	sysctl_somaxconn;
 
 #ifdef CONFIG_PROC_FS
diff --git a/include/net/sock.h b/include/net/sock.h
index b846a6d24459..f6b0f2c482ad 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2647,9 +2647,6 @@ void sk_get_meminfo(const struct sock *sk, u32 *meminfo);
 #define SK_WMEM_MAX		(_SK_MEM_OVERHEAD * _SK_MEM_PACKETS)
 #define SK_RMEM_MAX		(_SK_MEM_OVERHEAD * _SK_MEM_PACKETS)
 
-extern __u32 sysctl_wmem_max;
-extern __u32 sysctl_rmem_max;
-
 extern int sysctl_tstamp_allow_data;
 extern int sysctl_optmem_max;
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 255aeee72402..3dca58f6c40c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4717,13 +4717,13 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		/* Only some socketops are supported */
 		switch (optname) {
 		case SO_RCVBUF:
-			val = min_t(u32, val, sysctl_rmem_max);
+			val = min_t(u32, val, sock_net(sk)->core.sysctl_rmem_max);
 			sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 			WRITE_ONCE(sk->sk_rcvbuf,
 				   max_t(int, val * 2, SOCK_MIN_RCVBUF));
 			break;
 		case SO_SNDBUF:
-			val = min_t(u32, val, sysctl_wmem_max);
+			val = min_t(u32, val, sock_net(sk)->core.sysctl_wmem_max);
 			sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 			WRITE_ONCE(sk->sk_sndbuf,
 				   max_t(int, val * 2, SOCK_MIN_SNDBUF));
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index eb4ea99131d6..552e3c5b2a41 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -376,6 +376,8 @@ static int __net_init net_defaults_init_net(struct net *net)
 {
 	net->core.sysctl_rmem_default = SK_RMEM_MAX;
 	net->core.sysctl_wmem_default = SK_WMEM_MAX;
+	net->core.sysctl_rmem_max = SK_RMEM_MAX;
+	net->core.sysctl_wmem_max = SK_WMEM_MAX;
 	net->core.sysctl_somaxconn = SOMAXCONN;
 	return 0;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index 2421e4ea1915..eb7eaaa840ce 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -265,12 +265,6 @@ static struct lock_class_key af_wlock_keys[AF_MAX];
 static struct lock_class_key af_elock_keys[AF_MAX];
 static struct lock_class_key af_kern_callback_keys[AF_MAX];
 
-/* Run time adjustable parameters. */
-__u32 sysctl_wmem_max __read_mostly = SK_WMEM_MAX;
-EXPORT_SYMBOL(sysctl_wmem_max);
-__u32 sysctl_rmem_max __read_mostly = SK_RMEM_MAX;
-EXPORT_SYMBOL(sysctl_rmem_max);
-
 /* Maximal space eaten by iovec or ancillary data plus some space */
 int sysctl_optmem_max __read_mostly = sizeof(unsigned long)*(2*UIO_MAXIOV+512);
 EXPORT_SYMBOL(sysctl_optmem_max);
@@ -877,7 +871,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
 		 * are treated in BSD as hints
 		 */
-		val = min_t(u32, val, sysctl_wmem_max);
+		val = min_t(u32, val, sock_net(sk)->core.sysctl_wmem_max);
 set_sndbuf:
 		/* Ensure val * 2 fits into an int, to prevent max_t()
 		 * from treating it as a negative value.
@@ -909,7 +903,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
 		 * are treated in BSD as hints
 		 */
-		__sock_set_rcvbuf(sk, min_t(u32, val, sysctl_rmem_max));
+		__sock_set_rcvbuf(sk,
+				  min_t(u32, val,
+					sock_net(sk)->core.sysctl_rmem_max));
 		break;
 
 	case SO_RCVBUFFORCE:
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 5c1c75e42a09..30a8e3a324ec 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -310,22 +310,6 @@ proc_dolongvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 
 static struct ctl_table net_core_table[] = {
 #ifdef CONFIG_NET
-	{
-		.procname	= "wmem_max",
-		.data		= &sysctl_wmem_max,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_sndbuf,
-	},
-	{
-		.procname	= "rmem_max",
-		.data		= &sysctl_rmem_max,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_rcvbuf,
-	},
 	{
 		.procname	= "dev_weight",
 		.data		= &weight_p,
@@ -584,6 +568,22 @@ static struct ctl_table netns_core_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_rcvbuf,
 	},
+	{
+		.procname	= "wmem_max",
+		.data		= &init_net.core.sysctl_wmem_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_sndbuf,
+	},
+	{
+		.procname	= "rmem_max",
+		.data		= &init_net.core.sysctl_rmem_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_rcvbuf,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f322e798a351..8c1b2b0e6211 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -241,7 +241,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	if (wscale_ok) {
 		/* Set window scaling on max possible window */
 		space = max_t(u32, space, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
-		space = max_t(u32, space, sysctl_rmem_max);
+		space = max_t(u32, space, sock_net(sk)->core.sysctl_rmem_max);
 		space = min_t(u32, space, *window_clamp);
 		*rcv_wscale = clamp_t(int, ilog2(space) - 15,
 				      0, TCP_MAX_WSCALE);
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 9d43277b8b4f..2e7e10b76c36 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1280,12 +1280,12 @@ static void set_sock_size(struct sock *sk, int mode, int val)
 	lock_sock(sk);
 	if (mode) {
 		val = clamp_t(int, val, (SOCK_MIN_SNDBUF + 1) / 2,
-			      sysctl_wmem_max);
+			      sock_net(sk)->core.sysctl_wmem_max);
 		sk->sk_sndbuf = val * 2;
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 	} else {
 		val = clamp_t(int, val, (SOCK_MIN_RCVBUF + 1) / 2,
-			      sysctl_rmem_max);
+			      sock_net(sk)->core.sysctl_rmem_max);
 		sk->sk_rcvbuf = val * 2;
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 	}
-- 
2.30.0

