Return-Path: <netdev+bounces-3807-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5AC708EA3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FCE0281B4A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573E863E;
	Fri, 19 May 2023 04:07:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459FD566C;
	Fri, 19 May 2023 04:07:17 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA77E72;
	Thu, 18 May 2023 21:07:15 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d2a613ec4so694366b3a.1;
        Thu, 18 May 2023 21:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684469235; x=1687061235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKVXOAHKFA789J7ho2XD1RIAcfngnJV04ADcLg/bfiw=;
        b=LLFPI+8KzgGRbUMcwk5A6wP8ZXh942zGWTTTHT0IggZSR7HeHyJb2DAJk8Ucc1bS8i
         +FdSBmUY7DNhGb6hrCSiiNMdxehfMbOcY3bNHxnxRbyBPNIWtkbpnDQHXXv7cCvk7rBn
         4hheE/wN+MnnXQpgrd7lyay7TAzg9Z4SOsluMylC5L7cI2RuGjz/J4Pc6C+6bIqKDpoX
         lyBnY2MfeqYch5X380lnT5G9IV8P6cJ+5zeFS2ScEGruikBUOqpmbvbOgwr/vYbgo5R/
         rD1uWVKQCbvudeSfnz4E4PJ5gHTJEzukZONRDdIviDwJqwkeYV+VT+2uxmunBHWnpd6h
         Sdqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684469235; x=1687061235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PKVXOAHKFA789J7ho2XD1RIAcfngnJV04ADcLg/bfiw=;
        b=jj4ER7gu0corRGtbe/597Rk6YCrvids1/DD63+HUdXIVkea0ME0mK7d8DfPrHctPbR
         PoIh10f2EMPqrP/Fm09Ck9WxBGLpzSk/pXKocnhdi5oAw2DzEP7UHaj2dVtgLOyr/JAF
         aVBMyT6P+NoqNKvFmjch070VRE2RcqeQsMCGj2H/9skyWnhDQtFot35uo3S54JYq+DXU
         Qcvy0aFkyhUxX5Ucs6nYmLC9LiXBJq0/Xnbfz9EaYyx9bTv+phbznSPGvtskD8C4D8mX
         XPe3wtEwRex4VUeqCdyKvQPEhNYTeA3vaUTXaqgvz/AbaWupLoLnFSIWkfQbMpYycl2k
         ptdQ==
X-Gm-Message-State: AC+VfDztIrX8MoyxiBjYGXkdgN0vpeQMA9Q615byaso0o6bEEKoiHZp+
	gIqtLIZtqfsd8D60cihgIhk=
X-Google-Smtp-Source: ACHHUZ4hPtngrGHlu65fSeE9RU+PtsMjTgDp6L/LLEumU8sLVC35i/jUvtocSUqlVvnVJHW1gX3qtQ==
X-Received: by 2002:a05:6a00:99c:b0:63d:5de3:b3f2 with SMTP id u28-20020a056a00099c00b0063d5de3b3f2mr1659168pfg.18.1684469235188;
        Thu, 18 May 2023 21:07:15 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:706:628a:e6ce:c8a9])
        by smtp.gmail.com with ESMTPSA id x11-20020aa784cb000000b00625d84a0194sm434833pfn.107.2023.05.18.21.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 21:07:14 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v9 08/14] bpf: sockmap, incorrectly handling copied_seq
Date: Thu, 18 May 2023 21:06:53 -0700
Message-Id: <20230519040659.670644-9-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230519040659.670644-1-john.fastabend@gmail.com>
References: <20230519040659.670644-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The read_skb() logic is incrementing the tcp->copied_seq which is used for
among other things calculating how many outstanding bytes can be read by
the application. This results in application errors, if the application
does an ioctl(FIONREAD) we return zero because this is calculated from
the copied_seq value.

To fix this we move tcp->copied_seq accounting into the recv handler so
that we update these when the recvmsg() hook is called and data is in
fact copied into user buffers. This gives an accurate FIONREAD value
as expected and improves ACK handling. Before we were calling the
tcp_rcv_space_adjust() which would update 'number of bytes copied to
user in last RTT' which is wrong for programs returning SK_PASS. The
bytes are only copied to the user when recvmsg is handled.

Doing the fix for recvmsg is straightforward, but fixing redirect and
SK_DROP pkts is a bit tricker. Build a tcp_psock_eat() helper and then
call this from skmsg handlers. This fixes another issue where a broken
socket with a BPF program doing a resubmit could hang the receiver. This
happened because although read_skb() consumed the skb through sock_drop()
it did not update the copied_seq. Now if a single reccv socket is
redirecting to many sockets (for example for lb) the receiver sk will be
hung even though we might expect it to continue. The hang comes from
not updating the copied_seq numbers and memory pressure resulting from
that.

We have a slight layer problem of calling tcp_eat_skb even if its not
a TCP socket. To fix we could refactor and create per type receiver
handlers. I decided this is more work than we want in the fix and we
already have some small tweaks depending on caller that use the
helper skb_bpf_strparser(). So we extend that a bit and always set
the strparser bit when it is in use and then we can gate the
seq_copied updates on this.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/tcp.h  | 10 ++++++++++
 net/core/skmsg.c   | 15 +++++++--------
 net/ipv4/tcp.c     | 10 +---------
 net/ipv4/tcp_bpf.c | 28 +++++++++++++++++++++++++++-
 4 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 04a31643cda3..18a038d16434 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1470,6 +1470,8 @@ static inline void tcp_adjust_rcv_ssthresh(struct sock *sk)
 }
 
 void tcp_cleanup_rbuf(struct sock *sk, int copied);
+void __tcp_cleanup_rbuf(struct sock *sk, int copied);
+
 
 /* We provision sk_rcvbuf around 200% of sk_rcvlowat.
  * If 87.5 % (7/8) of the space has been consumed, we want to override
@@ -2326,6 +2328,14 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #endif /* CONFIG_BPF_SYSCALL */
 
+#ifdef CONFIG_INET
+void tcp_eat_skb(struct sock *sk, struct sk_buff *skb);
+#else
+static inline void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
+{
+}
+#endif
+
 int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
 			  struct sk_msg *msg, u32 bytes, int flags);
 #endif /* CONFIG_NET_SOCK_MSG */
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 08be5f409fb8..a9060e1f0e43 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -979,10 +979,8 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		err = -EIO;
 		sk_other = psock->sk;
 		if (sock_flag(sk_other, SOCK_DEAD) ||
-		    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
-			skb_bpf_redirect_clear(skb);
+		    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
 			goto out_free;
-		}
 
 		skb_bpf_set_ingress(skb);
 
@@ -1011,18 +1009,19 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 				err = 0;
 			}
 			spin_unlock_bh(&psock->ingress_lock);
-			if (err < 0) {
-				skb_bpf_redirect_clear(skb);
+			if (err < 0)
 				goto out_free;
-			}
 		}
 		break;
 	case __SK_REDIRECT:
+		tcp_eat_skb(psock->sk, skb);
 		err = sk_psock_skb_redirect(psock, skb);
 		break;
 	case __SK_DROP:
 	default:
 out_free:
+		skb_bpf_redirect_clear(skb);
+		tcp_eat_skb(psock->sk, skb);
 		sock_drop(psock->sk, skb);
 	}
 
@@ -1067,8 +1066,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
-		if (ret == SK_PASS)
-			skb_bpf_set_strparser(skb);
+		skb_bpf_set_strparser(skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
@@ -1176,6 +1174,7 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
 		len = 0;
+		tcp_eat_skb(sk, skb);
 		sock_drop(sk, skb);
 		goto out;
 	}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e914e3446377..a60f6f4e7cd9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1571,7 +1571,7 @@ static int tcp_peek_sndq(struct sock *sk, struct msghdr *msg, int len)
  * calculation of whether or not we must ACK for the sake of
  * a window update.
  */
-static void __tcp_cleanup_rbuf(struct sock *sk, int copied)
+void __tcp_cleanup_rbuf(struct sock *sk, int copied)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool time_to_ack = false;
@@ -1786,14 +1786,6 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 			break;
 		}
 	}
-	WRITE_ONCE(tp->copied_seq, seq);
-
-	tcp_rcv_space_adjust(sk);
-
-	/* Clean up data we have read: This will do ACK frames. */
-	if (copied > 0)
-		__tcp_cleanup_rbuf(sk, copied);
-
 	return copied;
 }
 EXPORT_SYMBOL(tcp_read_skb);
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 01dd76be1a58..5f93918c063c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -11,6 +11,24 @@
 #include <net/inet_common.h>
 #include <net/tls.h>
 
+void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
+{
+	struct tcp_sock *tcp;
+	int copied;
+
+	if (!skb || !skb->len || !sk_is_tcp(sk))
+		return;
+
+	if (skb_bpf_strparser(skb))
+		return;
+
+	tcp = tcp_sk(sk);
+	copied = tcp->copied_seq + skb->len;
+	WRITE_ONCE(tcp->copied_seq, copied);
+	tcp_rcv_space_adjust(sk);
+	__tcp_cleanup_rbuf(sk, skb->len);
+}
+
 static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 			   struct sk_msg *msg, u32 apply_bytes, int flags)
 {
@@ -198,8 +216,10 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 				  int flags,
 				  int *addr_len)
 {
+	struct tcp_sock *tcp = tcp_sk(sk);
+	u32 seq = tcp->copied_seq;
 	struct sk_psock *psock;
-	int copied;
+	int copied = 0;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
@@ -244,9 +264,11 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 
 		if (is_fin) {
 			copied = 0;
+			seq++;
 			goto out;
 		}
 	}
+	seq += copied;
 	if (!copied) {
 		long timeo;
 		int data;
@@ -284,6 +306,10 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		copied = -EAGAIN;
 	}
 out:
+	WRITE_ONCE(tcp->copied_seq, seq);
+	tcp_rcv_space_adjust(sk);
+	if (copied > 0)
+		__tcp_cleanup_rbuf(sk, copied);
 	release_sock(sk);
 	sk_psock_put(sk, psock);
 	return copied;
-- 
2.33.0


