Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481FF41F8BE
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 02:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhJBAi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 20:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhJBAi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 20:38:58 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73756C061775;
        Fri,  1 Oct 2021 17:37:13 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c26-20020a056830349a00b0054d96d25c1eso13551088otu.9;
        Fri, 01 Oct 2021 17:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aHjaWe3dU3pXryFM2XHmAMssDHt8Ijuz3XxnckN8eKE=;
        b=EYSfCWH2hM3TW/03jdJ0oewnIskYPkZjC6IU9O8olCVT0nGp68oPyKz0vuLbAGt/uh
         xmjsg/XlKn0sqYuxtCQ4lFW0AINfVU5Z9YuUWshA2NfZGx7Bcnxr/MXbARtsi4IPu22P
         fOvkL9hEpdCCAWEHTtJfoiB8cZF9qQLuq88s9Kp3fu2NKyWlGtOSGhnQtOOV3PJAKjgi
         lJgEO+x0HJwkir7Uucv0vBRVbqJrSlYH1Ye2tg6npGgK8r00JoQ4HimbLTRrtARa8GSK
         JimOuzdtNY8nLuFEFtx58zpNgo/4F8/8VsZCcWycGcqpptUscIFjcZtyMb7Pr2jALncC
         SrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aHjaWe3dU3pXryFM2XHmAMssDHt8Ijuz3XxnckN8eKE=;
        b=zWG71zSWmuRd47xizKa5/XO+KbWocC2xne/mDmLJdPOrRXOoTDJOR3pApiZIAMSaXf
         lW1Z9+VnR6ri4gQye7d8qrkRujP6/UOlJy5IhlvlxzQqBFZBCyihMsjKW4odJs+x7THN
         C1ImgqbLYPPaPDaMd/h++k9KRaCANc/qpsFsxZT9u3onyCyL5o9Pj0v9qkI4GuZsFH3L
         eA6w227skkcvY/TbETG3TS5R3KYmdAbTk5AAM5r7SU/WpuiAQGhDe1KXNTeloEQ15rdP
         VmnorBJXciF/uJnUhilEFcOCvollq14WElIRQjFXu6rNyMt5wet+UezvR0Df0pZA56W+
         fyJA==
X-Gm-Message-State: AOAM530WktitC+hQkhKqjM+n4BE0RiFUtbRfSzcs/oM5eUKFbnX1xTpg
        IhHZXmPSuoOm1GF5+Jdm0xDjYMt5AF4=
X-Google-Smtp-Source: ABdhPJyoL/9T95A1XwmmUgetekw85wi7y2o50HbnH0TN0z9/NB15eT1QlEWJWrFuYdqhblYp587pYQ==
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr617568ots.185.1633135032774;
        Fri, 01 Oct 2021 17:37:12 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a62e:a53d:c4bc:b137])
        by smtp.gmail.com with ESMTPSA id p18sm1545017otk.7.2021.10.01.17.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 17:37:12 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 1/4] net: rename ->stream_memory_read to ->sock_is_readable
Date:   Fri,  1 Oct 2021 17:37:03 -0700
Message-Id: <20211002003706.11237-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
References: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

The proto ops ->stream_memory_read() is currently only used
by TCP to check whether psock queue is empty or not. We need
to rename it before reusing it for non-TCP protocols, and
adjust the exsiting users accordingly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/sock.h | 8 +++++++-
 include/net/tls.h  | 2 +-
 net/ipv4/tcp.c     | 5 +----
 net/ipv4/tcp_bpf.c | 4 ++--
 net/tls/tls_main.c | 4 ++--
 net/tls/tls_sw.c   | 2 +-
 6 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c005c3c750e8..88395943f7b9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1205,7 +1205,7 @@ struct proto {
 #endif
 
 	bool			(*stream_memory_free)(const struct sock *sk, int wake);
-	bool			(*stream_memory_read)(const struct sock *sk);
+	bool			(*sock_is_readable)(struct sock *sk);
 	/* Memory pressure */
 	void			(*enter_memory_pressure)(struct sock *sk);
 	void			(*leave_memory_pressure)(struct sock *sk);
@@ -2788,4 +2788,10 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
 int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
 
+static inline bool sk_is_readable(struct sock *sk)
+{
+	if (sk->sk_prot->sock_is_readable)
+		return sk->sk_prot->sock_is_readable(sk);
+	return false;
+}
 #endif	/* _SOCK_H */
diff --git a/include/net/tls.h b/include/net/tls.h
index be4b3e1cac46..01d2e3744393 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -375,7 +375,7 @@ void tls_sw_release_resources_rx(struct sock *sk);
 void tls_sw_free_ctx_rx(struct tls_context *tls_ctx);
 int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		   int nonblock, int flags, int *addr_len);
-bool tls_sw_stream_read(const struct sock *sk);
+bool tls_sw_sock_is_readable(struct sock *sk);
 ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
 			   struct pipe_inode_info *pipe,
 			   size_t len, unsigned int flags);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8b48df73c85..f5c336f8b0c8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -486,10 +486,7 @@ static bool tcp_stream_is_readable(struct sock *sk, int target)
 {
 	if (tcp_epollin_ready(sk, target))
 		return true;
-
-	if (sk->sk_prot->stream_memory_read)
-		return sk->sk_prot->stream_memory_read(sk);
-	return false;
+	return sk_is_readable(sk);
 }
 
 /*
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index d3e9386b493e..0175dbcb7722 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -150,7 +150,7 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 
 #ifdef CONFIG_BPF_SYSCALL
-static bool tcp_bpf_stream_read(const struct sock *sk)
+static bool tcp_bpf_sock_is_readable(struct sock *sk)
 {
 	struct sk_psock *psock;
 	bool empty = true;
@@ -479,7 +479,7 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 	prot[TCP_BPF_BASE].unhash		= sock_map_unhash;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
-	prot[TCP_BPF_BASE].stream_memory_read	= tcp_bpf_stream_read;
+	prot[TCP_BPF_BASE].sock_is_readable	= tcp_bpf_sock_is_readable;
 
 	prot[TCP_BPF_TX]			= prot[TCP_BPF_BASE];
 	prot[TCP_BPF_TX].sendmsg		= tcp_bpf_sendmsg;
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index fde56ff49163..9ab81db8a654 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -681,12 +681,12 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 
 	prot[TLS_BASE][TLS_SW] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_BASE][TLS_SW].recvmsg		  = tls_sw_recvmsg;
-	prot[TLS_BASE][TLS_SW].stream_memory_read = tls_sw_stream_read;
+	prot[TLS_BASE][TLS_SW].sock_is_readable   = tls_sw_sock_is_readable;
 	prot[TLS_BASE][TLS_SW].close		  = tls_sk_proto_close;
 
 	prot[TLS_SW][TLS_SW] = prot[TLS_SW][TLS_BASE];
 	prot[TLS_SW][TLS_SW].recvmsg		= tls_sw_recvmsg;
-	prot[TLS_SW][TLS_SW].stream_memory_read	= tls_sw_stream_read;
+	prot[TLS_SW][TLS_SW].sock_is_readable   = tls_sw_sock_is_readable;
 	prot[TLS_SW][TLS_SW].close		= tls_sk_proto_close;
 
 #ifdef CONFIG_TLS_DEVICE
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 4feb95e34b64..d5d09bd817b7 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2026,7 +2026,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	return copied ? : err;
 }
 
-bool tls_sw_stream_read(const struct sock *sk)
+bool tls_sw_sock_is_readable(struct sock *sk)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
-- 
2.30.2

