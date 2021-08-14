Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B80B3EC072
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 06:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhHNE2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 00:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbhHNE2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 00:28:41 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9F7C0613A3
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:28:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nt11so18319854pjb.2
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IlrYaC8IJcLaRLYQKz/1AeRwf49Gtn6+qZOfxmUI4I4=;
        b=rnW66HJRmhURm/KgavIhUnRBQUXD/dYUj7FXtZYOjd2ilTUbvF97q4D64HJtzc8w0H
         z7+rWya8a4XfE/WKKMb33eDc6bcM2iSkjMzmjv1uAOgOtxiOBEdISdegeYMJzGs2Ik7M
         DdW8r75v0S66OtlbyQ8LfnT1oKw+tWPt6hzQaNPFFiHyOvqGXA9O72hejr3OnZEq1iIO
         Mfb7qzaSigTLWYixcDQtTd/I1AMediP8gZNSYArpghx5qAe9/nD9konQU2YNHWjbshYY
         Qcq1dbxYaYcfVIbZv+m5EKpJ4mlk+RxAszI6Q2ZyuBKTRhhXDMxpNCurIr9gJlkWjtPI
         HUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IlrYaC8IJcLaRLYQKz/1AeRwf49Gtn6+qZOfxmUI4I4=;
        b=A5gGSkwwkREJo3nyNqPmCNoOPWiecB7HsYcGhj/9xas5VXcIfvMFbRQ7KcVvNcHA2O
         XB+yAedAtnt1/4KBpEq7CGz5vdt8W+/grtw67Ancr2SrMs9t4PNxFfURSyUJzVuRhVuZ
         J29/0LusXBlD9n/4yZoMOXKKQ13SJ/Pc89wABJZf9f6P1ZFQ45s0cobTaDdpG6ZYi4mV
         gNpkRtitPMLktluiSkNpKEq/dvmFiHuWUdP4Y1AydBhRGLtvIPotWJMnCgjFQaI9CN6k
         UD052G8AofjNT4ktTIvmVsHPOvimZitQtHxUMkDQQdJvfdSQNhRCLie21PrzIEFjp6Fh
         TRIQ==
X-Gm-Message-State: AOAM532l7yOgI7V+u0VIqNjxL7iXYWnUgB0Dy28HMm9mX97k6Q5ArFcz
        nRZMxWhB48Q8zmJBLVusB4cQ3onScGEy0Q==
X-Google-Smtp-Source: ABdhPJytdkOyz/ZKNQhjlhn3a1m0hOxcICti042QYRnX+NYONYaKpUlnCrtChMZmvdyyzED9iC6ofw==
X-Received: by 2002:a17:90a:fc87:: with SMTP id ci7mr5813366pjb.178.1628915293011;
        Fri, 13 Aug 2021 21:28:13 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id q21sm4420492pgk.71.2021.08.13.21.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 21:28:12 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 2/5] af_unix: add unix_stream_proto for sockmap
Date:   Sat, 14 Aug 2021 04:27:47 +0000
Message-Id: <20210814042754.3351268-3-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814042754.3351268-1-jiang.wang@bytedance.com>
References: <20210814042754.3351268-1-jiang.wang@bytedance.com>
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
 net/unix/af_unix.c    | 83 ++++++++++++++++++++++++++++++++------
 net/unix/unix_bpf.c   | 93 +++++++++++++++++++++++++++++++++----------
 3 files changed, 147 insertions(+), 37 deletions(-)

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

