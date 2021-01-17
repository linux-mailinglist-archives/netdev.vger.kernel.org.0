Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB372F91C6
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 11:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbhAQKuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 05:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbhAQKtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 05:49:55 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE792C061573;
        Sun, 17 Jan 2021 02:49:14 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id r4so7018232pls.11;
        Sun, 17 Jan 2021 02:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lFmA9TnP9NE8OaeHmI0MhXoMypeEzomf+Eb9FD+FhuU=;
        b=JBPUh/HNioXYB+CsuwdxQs6HxhQlsKBzzagiIqwamz9zjKM1Q1O/GdDtkODXamjJUR
         E1A6XyvNQspXOQc7AyhHinAI3U45FvhunEYuiTxiDiSmqzp2fsOTuFX2p7vrX0a7v1H+
         MnktAfvxV6xMcu8kh6iZEjPyc/n3MH3LdhDfaE1eqn8Ocb1v71/KmiuNLCMTFTT3intY
         xxUne0NLi68n6SYoMoxEkWddWxshnYkkCK34IciZHnDkwF/SkXCpeUMDqakO/nC5ClGZ
         OQflH1spTIjxv1P4Td4oxoizlRC7DxcPwDYoFm8KsQCwU1Vm/VP89ihg1P2KKj6/t97B
         P9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lFmA9TnP9NE8OaeHmI0MhXoMypeEzomf+Eb9FD+FhuU=;
        b=iFBTOcvRpCYWqH81xQEmgQGAHpH5EN1it88OmugyQLLHcq1qKfLbvecYONmaLiowo4
         mtCfJb3Tg9gC4nBsZyOwt5FG7gghT6YihOMqh1qAfSRMlhLfHm9UKf2SaXCJOcJbWsMv
         qqE+v0YevngYDydATJwYVYQ6VK9jCKgxMJl/ucY182QbZaIlJk49mN8o+DRFRKBRprr5
         Sr6Xd1dB2qixPAZs9HN4lyO9OB+qjEUw6GqMhqq/IMNq3jxaCr8z+9LlknIw8Cr6HW3o
         wSe4bQLRGGJzGAGC4JsQDxbGa1WPYN2x78P9UPXq78NR2Rc6suJ/PRYG8gtSYHFCl+TC
         LtnA==
X-Gm-Message-State: AOAM533nt3S4JTfEFHDXsw5wp94KfOcsNWjykCXw7oE87lhdlCtrJkPl
        lA7hyKhYkz6IpPHAj7hAy4FU8r8ztRY=
X-Google-Smtp-Source: ABdhPJxFEkubh99EOrcZQtyFNKy3kILhFvy3PXh2wxrGGhS5wRCpr94ePASFqT3HGxwcaACu+HtDzw==
X-Received: by 2002:a17:90a:f998:: with SMTP id cq24mr3565901pjb.6.1610880554101;
        Sun, 17 Jan 2021 02:49:14 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id g75sm12853926pfb.2.2021.01.17.02.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 02:49:13 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, edumazet@google.com,
        yoshfuji@linux-ipv6.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dong.menglong@zte.com.cn, christian.brauner@ubuntu.com,
        gnault@redhat.com, ap420073@gmail.com, willemb@google.com,
        jakub@cloudflare.com, bjorn.topel@intel.com, linmiaohe@huawei.com,
        pabeni@redhat.com, keescook@chromium.org, viro@zeniv.linux.org.uk,
        rdna@fb.com, maheshb@google.com, nicolas.dichtel@6wind.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: core: Namespace-ify sysctl_rmem_max and sysctl_wmem_max
Date:   Sun, 17 Jan 2021 18:47:43 +0800
Message-Id: <20210117104743.217194-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
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

