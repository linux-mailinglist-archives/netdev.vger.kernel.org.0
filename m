Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31DD41A428
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbhI1AYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbhI1AYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 20:24:09 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78272C061575;
        Mon, 27 Sep 2021 17:22:31 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id a13so12365430qvo.9;
        Mon, 27 Sep 2021 17:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SR1tPyzvAclFOM4BUlkMqlddOFBl3ZYcmIme4gahL5M=;
        b=iCDXeSWReWmwWB6oGTJ5anUUpOb7K/eyaN2q7DyAUniVKzXMG5LJutwQZ/8rcw3BB+
         FZ3SCJGJG1t6Dlmgh+2ve6XVcmCgcEBlOjQeP1ZUapL7vvmi2uUOGpjyNIn/ige/UxdD
         JisjHthEdz//kxpgRYejYxjotkgrrLkAVlvv6COKzq+sZPIKpclU4ikGlWI1VI8Hb6uX
         iD2JWpEyoBk2r/NBTLASbcuDeFmX2TZJa+X566wVspmD2o6oCxDNUeC8h2/QbDnsqkT+
         mUJEmMwrxn8tANtyZQgereklI30FHJSlUuSbpE+8cKZr5yc2VFAue5FKz+FNI+QSx3d9
         gdyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SR1tPyzvAclFOM4BUlkMqlddOFBl3ZYcmIme4gahL5M=;
        b=Dpxi42yb/Iz4q7k/FMmyBlIKFazI4jIlXPObpmsUsozIiadsEaWCMp1DHQPlN3KVYQ
         J1vIdutQTUOftNMJzE3OGPHE2rcMUYKxPS58MO/vWUtWIYpwAFuVO+zfmgSHUOX8UqsR
         NBsYid8KSJAclrOcGRMOCf42FA6rVk1Eifiiy8N9VRt3aX2aqWCjUG1LQKLR37Ski4f8
         7ciezgtkc3kowt5HXG0L+2DTB24hft5QZ4jxJQV5acvAOpM1EuglB1cIlXDae0PLweyd
         HIzY5oYCjGpbIDZZGEA1MenM10X4xPAnU8MJhfGcSUVstQJam6wFT86MskL5V7opzs7d
         4WQw==
X-Gm-Message-State: AOAM5327Unmtp9iqjovF9U/4iZV+daCQEHVma52ya4XbGEtVy+3QdiZO
        1UCOWD2JDRm5rlqgoAkDRiqCgVeDy6c=
X-Google-Smtp-Source: ABdhPJz/jhv/wsvj6eRvwSxCUIrI8WBrrK+eEbNXbTTxdQwIbSrh4yPIqjc9tpi6S3FHFPCQgqjv+w==
X-Received: by 2002:ad4:44e4:: with SMTP id p4mr2601724qvt.40.1632788550604;
        Mon, 27 Sep 2021 17:22:30 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1ce2:35c5:917e:20d7])
        by smtp.gmail.com with ESMTPSA id 31sm5672308qtb.85.2021.09.27.17.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:22:30 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v2 2/4] net: rename ->stream_memory_read to ->sock_is_readable
Date:   Mon, 27 Sep 2021 17:22:10 -0700
Message-Id: <20210928002212.14498-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
References: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

The proto ops ->stream_memory_read is currently only used
by TCP to check whether psock queue is empty or not. We need
to rename it before reusing it for non-TCP
protocols, and adjust the exsiting TCP functions accordingly.

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
index 66a9a90f9558..5c1dcc4a2284 100644
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
@@ -2787,4 +2787,10 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
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

