Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05833EDD9A
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 21:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhHPTGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 15:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhHPTES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 15:04:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2FDC061796
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 12:03:46 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso728076pjb.1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 12:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V36QPSB78BUP0JvLxXDHPbB+JzHEybvXTTUlAkVfNoc=;
        b=mrg+08PPeSG27e1OQLtgiEdfjDTLdmS3gH16WIqBMO6rtQCIH1tqSXVBOHc7e1YY3j
         fzazLvJ1mceigbNoAwmYkWhyeqVoyxh6e9qhO1d3Z05yreleoqqLUlxGDBZK9OeFmGZp
         YT9UdvoCgcj+IO+Zw9w6+4wQiLrF7AM+3+D8NKOEVUkPaH7DvLBJVYWUQlVlPy92bEOy
         lvF8w7gUXSWCTbmH3vRsGBwlxnPCOH1QBRNeXW5jpnFPuQglUcfh5/1VCsUm556SLEtn
         7Gu5cfkj4wK/v/cPyuBekeVU0ByIeg1LfyDkCVVz19pi7XCiKBS4t5Jdw+BYUylpMqqA
         1CyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V36QPSB78BUP0JvLxXDHPbB+JzHEybvXTTUlAkVfNoc=;
        b=qgPBVQcdCsIVTSS2P+sOckmfi5qSVi3MbmfUVcm8RnRkjlyZb0q7Rv3IRG82WDqVlr
         /yRA51gYfEFDMr/UTHl8cT5lD+vo9DWsQilPPEuw/3HiWp/FxB5fU968594kDFhL/GO7
         yh0s2cje/CDovU8urN9h97StoWQFl8npF4+QgRLAMqifHckFLWKBke/hlewPalGFliqa
         15ipKgViyoKgRCcsxRkpR0gAs8A3acNJs/iNKNlD7jY6Cpnil3WwVqU0ETfMQ8s1uV1o
         X+3fIc31y8v0yNMqXNaUxpOyt9nW1RVMZ7iKp6f+BMfvfmEkwBaOpmu1bDCx2loXG1D1
         uRfQ==
X-Gm-Message-State: AOAM532WPRRrB/iZiFpUayfQMskEaOTb2DfKEGsPY5nwwTqyQptQwaC7
        5DQcCRnMF+vp+JhA2EVslli/egkYQMTjfg==
X-Google-Smtp-Source: ABdhPJy54aE3klzmp8mUUziYDqnzol/9oH+dtx0ZWZbfjc5xDn2ng+T5DBHIQziZ5c1QKmtBi2M4vg==
X-Received: by 2002:a17:902:e803:b0:12d:7f02:f782 with SMTP id u3-20020a170902e80300b0012d7f02f782mr300939plg.19.1629140626245;
        Mon, 16 Aug 2021 12:03:46 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id t30sm175845pgl.47.2021.08.16.12.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 12:03:45 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Rao Shoaib <rao.shoaib@oracle.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v7 2/5] af_unix: add unix_stream_proto for sockmap
Date:   Mon, 16 Aug 2021 19:03:21 +0000
Message-Id: <20210816190327.2739291-3-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210816190327.2739291-1-jiang.wang@bytedance.com>
References: <20210816190327.2739291-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, sockmap for AF_UNIX protocol only supports
dgram type. This patch add unix stream type support, which
is similar to unix_dgram_proto. To support sockmap, dgram
and stream cannot share the same unix_proto anymore, because
they have different implementations, such as unhash for stream
type (which will remove closed or disconnected sockets from the map),
so rename unix_proto to unix_dgram_proto and add a new
unix_stream_proto.

Also implement stream related sockmap functions.
And add dgram key words to those dgram specific functions.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/af_unix.h |  8 +++-
 net/core/sock_map.c   |  1 +
 net/unix/af_unix.c    | 83 ++++++++++++++++++++++++++++++++------
 net/unix/unix_bpf.c   | 93 +++++++++++++++++++++++++++++++++----------
 4 files changed, 148 insertions(+), 37 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 4757d7f53f13..7d142e8a0550 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -87,6 +87,8 @@ long unix_outq_len(struct sock *sk);
 
 int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
 			 int flags);
+int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
+			  int flags);
 #ifdef CONFIG_SYSCTL
 int unix_sysctl_register(struct net *net);
 void unix_sysctl_unregister(struct net *net);
@@ -96,9 +98,11 @@ static inline void unix_sysctl_unregister(struct net *net) {}
 #endif
 
 #ifdef CONFIG_BPF_SYSCALL
-extern struct proto unix_proto;
+extern struct proto unix_dgram_proto;
+extern struct proto unix_stream_proto;
 
-int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
+int unix_dgram_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
+int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void __init unix_bpf_build_proto(void);
 #else
 static inline void __init unix_bpf_build_proto(void)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index ae5fa4338d9c..e252b8ec2b85 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1494,6 +1494,7 @@ void sock_map_unhash(struct sock *sk)
 	rcu_read_unlock();
 	saved_unhash(sk);
 }
+EXPORT_SYMBOL_GPL(sock_map_unhash);
 
 void sock_map_close(struct sock *sk, long timeout)
 {
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 31061304ccf2..e7da96c80c71 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -797,17 +797,35 @@ static void unix_close(struct sock *sk, long timeout)
 	 */
 }
 
-struct proto unix_proto = {
-	.name			= "UNIX",
+static void unix_unhash(struct sock *sk)
+{
+	/* Nothing to do here, unix socket does not need a ->unhash().
+	 * This is merely for sockmap.
+	 */
+}
+
+struct proto unix_dgram_proto = {
+	.name			= "UNIX-DGRAM",
+	.owner			= THIS_MODULE,
+	.obj_size		= sizeof(struct unix_sock),
+	.close			= unix_close,
+#ifdef CONFIG_BPF_SYSCALL
+	.psock_update_sk_prot	= unix_dgram_bpf_update_proto,
+#endif
+};
+
+struct proto unix_stream_proto = {
+	.name			= "UNIX-STREAM",
 	.owner			= THIS_MODULE,
 	.obj_size		= sizeof(struct unix_sock),
 	.close			= unix_close,
+	.unhash			= unix_unhash,
 #ifdef CONFIG_BPF_SYSCALL
-	.psock_update_sk_prot	= unix_bpf_update_proto,
+	.psock_update_sk_prot	= unix_stream_bpf_update_proto,
 #endif
 };
 
-static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
+static struct sock *unix_create1(struct net *net, struct socket *sock, int kern, int type)
 {
 	struct sock *sk = NULL;
 	struct unix_sock *u;
@@ -816,7 +834,11 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
 	if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
 		goto out;
 
-	sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto, kern);
+	if (type == SOCK_STREAM)
+		sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_stream_proto, kern);
+	else /*dgram and  seqpacket */
+		sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_dgram_proto, kern);
+
 	if (!sk)
 		goto out;
 
@@ -878,7 +900,7 @@ static int unix_create(struct net *net, struct socket *sock, int protocol,
 		return -ESOCKTNOSUPPORT;
 	}
 
-	return unix_create1(net, sock, kern) ? 0 : -ENOMEM;
+	return unix_create1(net, sock, kern, sock->type) ? 0 : -ENOMEM;
 }
 
 static int unix_release(struct socket *sock)
@@ -1292,7 +1314,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	err = -ENOMEM;
 
 	/* create new sock for complete connection */
-	newsk = unix_create1(sock_net(sk), NULL, 0);
+	newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
 	if (newsk == NULL)
 		goto out;
 
@@ -2322,8 +2344,10 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
 	struct sock *sk = sock->sk;
 
 #ifdef CONFIG_BPF_SYSCALL
-	if (sk->sk_prot != &unix_proto)
-		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+
+	if (prot != &unix_dgram_proto)
+		return prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
 					    flags & ~MSG_DONTWAIT, NULL);
 #endif
 	return __unix_dgram_recvmsg(sk, msg, size, flags);
@@ -2727,6 +2751,20 @@ static int unix_stream_read_actor(struct sk_buff *skb,
 	return ret ?: chunk;
 }
 
+int __unix_stream_recvmsg(struct sock *sk, struct msghdr *msg,
+			  size_t size, int flags)
+{
+	struct unix_stream_read_state state = {
+		.recv_actor = unix_stream_read_actor,
+		.socket = sk->sk_socket,
+		.msg = msg,
+		.size = size,
+		.flags = flags
+	};
+
+	return unix_stream_read_generic(&state, true);
+}
+
 static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
 			       size_t size, int flags)
 {
@@ -2738,6 +2776,14 @@ static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
 		.flags = flags
 	};
 
+#ifdef CONFIG_BPF_SYSCALL
+	struct sock *sk = sock->sk;
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+
+	if (prot != &unix_stream_proto)
+		return prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+					    flags & ~MSG_DONTWAIT, NULL);
+#endif
 	return unix_stream_read_generic(&state, true);
 }
 
@@ -2798,7 +2844,9 @@ static int unix_shutdown(struct socket *sock, int mode)
 		(sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)) {
 
 		int peer_mode = 0;
+		const struct proto *prot = READ_ONCE(other->sk_prot);
 
+		prot->unhash(other);
 		if (mode&RCV_SHUTDOWN)
 			peer_mode |= SEND_SHUTDOWN;
 		if (mode&SEND_SHUTDOWN)
@@ -2807,10 +2855,12 @@ static int unix_shutdown(struct socket *sock, int mode)
 		other->sk_shutdown |= peer_mode;
 		unix_state_unlock(other);
 		other->sk_state_change(other);
-		if (peer_mode == SHUTDOWN_MASK)
+		if (peer_mode == SHUTDOWN_MASK) {
 			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_HUP);
-		else if (peer_mode & RCV_SHUTDOWN)
+			other->sk_state = TCP_CLOSE;
+		} else if (peer_mode & RCV_SHUTDOWN) {
 			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_IN);
+		}
 	}
 	if (other)
 		sock_put(other);
@@ -3201,7 +3251,13 @@ static int __init af_unix_init(void)
 
 	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
 
-	rc = proto_register(&unix_proto, 1);
+	rc = proto_register(&unix_dgram_proto, 1);
+	if (rc != 0) {
+		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
+		goto out;
+	}
+
+	rc = proto_register(&unix_stream_proto, 1);
 	if (rc != 0) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
 		goto out;
@@ -3217,7 +3273,8 @@ static int __init af_unix_init(void)
 static void __exit af_unix_exit(void)
 {
 	sock_unregister(PF_UNIX);
-	proto_unregister(&unix_proto);
+	proto_unregister(&unix_dgram_proto);
+	proto_unregister(&unix_stream_proto);
 	unregister_pernet_subsys(&unix_net_ops);
 }
 
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 20f53575b5c9..b927e2baae50 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -38,9 +38,18 @@ static int unix_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 	return ret;
 }
 
-static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
-				  size_t len, int nonblock, int flags,
-				  int *addr_len)
+static int __unix_recvmsg(struct sock *sk, struct msghdr *msg,
+			  size_t len, int flags)
+{
+	if (sk->sk_type == SOCK_DGRAM)
+		return __unix_dgram_recvmsg(sk, msg, len, flags);
+	else
+		return __unix_stream_recvmsg(sk, msg, len, flags);
+}
+
+static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
+			    size_t len, int nonblock, int flags,
+			    int *addr_len)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_psock *psock;
@@ -48,14 +57,14 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
-		return __unix_dgram_recvmsg(sk, msg, len, flags);
+		return __unix_recvmsg(sk, msg, len, flags);
 
 	mutex_lock(&u->iolock);
 	if (!skb_queue_empty(&sk->sk_receive_queue) &&
 	    sk_psock_queue_empty(psock)) {
 		mutex_unlock(&u->iolock);
 		sk_psock_put(sk, psock);
-		return __unix_dgram_recvmsg(sk, msg, len, flags);
+		return __unix_recvmsg(sk, msg, len, flags);
 	}
 
 msg_bytes_ready:
@@ -71,7 +80,7 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 				goto msg_bytes_ready;
 			mutex_unlock(&u->iolock);
 			sk_psock_put(sk, psock);
-			return __unix_dgram_recvmsg(sk, msg, len, flags);
+			return __unix_recvmsg(sk, msg, len, flags);
 		}
 		copied = -EAGAIN;
 	}
@@ -80,30 +89,55 @@ static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	return copied;
 }
 
-static struct proto *unix_prot_saved __read_mostly;
-static DEFINE_SPINLOCK(unix_prot_lock);
-static struct proto unix_bpf_prot;
+static struct proto *unix_dgram_prot_saved __read_mostly;
+static DEFINE_SPINLOCK(unix_dgram_prot_lock);
+static struct proto unix_dgram_bpf_prot;
+
+static struct proto *unix_stream_prot_saved __read_mostly;
+static DEFINE_SPINLOCK(unix_stream_prot_lock);
+static struct proto unix_stream_bpf_prot;
 
-static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
+static void unix_dgram_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 {
 	*prot        = *base;
 	prot->close  = sock_map_close;
-	prot->recvmsg = unix_dgram_bpf_recvmsg;
+	prot->recvmsg = unix_bpf_recvmsg;
+}
+
+static void unix_stream_bpf_rebuild_protos(struct proto *prot,
+					   const struct proto *base)
+{
+	*prot        = *base;
+	prot->close  = sock_map_close;
+	prot->recvmsg = unix_bpf_recvmsg;
+	prot->unhash  = sock_map_unhash;
+}
+
+static void unix_dgram_bpf_check_needs_rebuild(struct proto *ops)
+{
+	if (unlikely(ops != smp_load_acquire(&unix_dgram_prot_saved))) {
+		spin_lock_bh(&unix_dgram_prot_lock);
+		if (likely(ops != unix_dgram_prot_saved)) {
+			unix_dgram_bpf_rebuild_protos(&unix_dgram_bpf_prot, ops);
+			smp_store_release(&unix_dgram_prot_saved, ops);
+		}
+		spin_unlock_bh(&unix_dgram_prot_lock);
+	}
 }
 
-static void unix_bpf_check_needs_rebuild(struct proto *ops)
+static void unix_stream_bpf_check_needs_rebuild(struct proto *ops)
 {
-	if (unlikely(ops != smp_load_acquire(&unix_prot_saved))) {
-		spin_lock_bh(&unix_prot_lock);
-		if (likely(ops != unix_prot_saved)) {
-			unix_bpf_rebuild_protos(&unix_bpf_prot, ops);
-			smp_store_release(&unix_prot_saved, ops);
+	if (unlikely(ops != smp_load_acquire(&unix_stream_prot_saved))) {
+		spin_lock_bh(&unix_stream_prot_lock);
+		if (likely(ops != unix_stream_prot_saved)) {
+			unix_stream_bpf_rebuild_protos(&unix_stream_bpf_prot, ops);
+			smp_store_release(&unix_stream_prot_saved, ops);
 		}
-		spin_unlock_bh(&unix_prot_lock);
+		spin_unlock_bh(&unix_stream_prot_lock);
 	}
 }
 
-int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
+int unix_dgram_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
 	if (sk->sk_type != SOCK_DGRAM)
 		return -EOPNOTSUPP;
@@ -114,12 +148,27 @@ int unix_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 		return 0;
 	}
 
-	unix_bpf_check_needs_rebuild(psock->sk_proto);
-	WRITE_ONCE(sk->sk_prot, &unix_bpf_prot);
+	unix_dgram_bpf_check_needs_rebuild(psock->sk_proto);
+	WRITE_ONCE(sk->sk_prot, &unix_dgram_bpf_prot);
+	return 0;
+}
+
+int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
+{
+	if (restore) {
+		sk->sk_write_space = psock->saved_write_space;
+		WRITE_ONCE(sk->sk_prot, psock->sk_proto);
+		return 0;
+	}
+
+	unix_stream_bpf_check_needs_rebuild(psock->sk_proto);
+	WRITE_ONCE(sk->sk_prot, &unix_stream_bpf_prot);
 	return 0;
 }
 
 void __init unix_bpf_build_proto(void)
 {
-	unix_bpf_rebuild_protos(&unix_bpf_prot, &unix_proto);
+	unix_dgram_bpf_rebuild_protos(&unix_dgram_bpf_prot, &unix_dgram_proto);
+	unix_stream_bpf_rebuild_protos(&unix_stream_bpf_prot, &unix_stream_proto);
+
 }
-- 
2.20.1

