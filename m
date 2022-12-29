Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EAA658A20
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 09:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiL2ICz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 03:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiL2ICx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 03:02:53 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07A2EE19
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 00:02:23 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 124so12204061pfy.0
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 00:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=YYn77ci8+oadBW76lYzJfKZ6fFNIjqBEwRX0Ww9TJ7s=;
        b=Dn6En9W1e8cvEiQoDDVWTZzEhI8jZ1ErnKGxbi6HBk4DW/AKMU1+gcswtxwjrru8kf
         8B/8zwi25Cr+1OxPpx/7zMQjEiw5ewfmX8xAhAo9u4gxjj/NLtDGgk+YprKWbhlCmeWW
         AAxgE6cdm36llA/q9WPCKI60l9jGJEWmmbk3TpkHmvrWSyMB6OkkE8MvTG+6RNIu+oU0
         R/gm9aBaQOxiJmdN70/jpopv7gVx6htBToGrpLSOyTfQIac1gBCYsYazgZ9Zw+uTsAMP
         MIF4VqjN4rr/1GTHPuC1lvhf5OdDFDjVM7chHc5oVlqaM8tc8pbn3lMGIIK3DC72THig
         T4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YYn77ci8+oadBW76lYzJfKZ6fFNIjqBEwRX0Ww9TJ7s=;
        b=RVG5K5Zo4z9GP5XkiZGud+WZXHXW5XFyO/9WEtErTBTIMr3UQCaxy4DEHlglKb7DTe
         3x1p/XIus2980enLAdFJKafqXFiqQ8em/vg7ifKx7hfCOjeRDOyBRQd0yb0CHmRjO+yX
         EubFTqqB6mE1YHJarsqyedXJ6OSwX1ZMae8JgxVMDHD0/4IKZoQuOG4L24wIW36y1KWb
         RcZDLlTstPU3ngbjivBpAFSEKsb5UCXUtF862UljbM6Bc8Nh4ITs8DT/x6/7GfF1MOR2
         /LvD/AnSGX9vW0YlwPe74JB/ETOFlTO5u4k7xtaYYtoDddDtqnkMaCdEZAmmN/1Ae49/
         jkTQ==
X-Gm-Message-State: AFqh2koVvQh8lsM9qblGhL+V7QL8jijXA2ryWMpK0AGLDXD3nxWxsirB
        Gb/sfgS+URnuuppeihaL2tJNkQ==
X-Google-Smtp-Source: AMrXdXvczbVUCzIVrbJxWzaGVw3CX97HUqqvyMnn4zkn6ZEH4k4Vjnicexgjj2tSI+5JDyoPrIq4YQ==
X-Received: by 2002:a62:648b:0:b0:57a:a199:93e7 with SMTP id y133-20020a62648b000000b0057aa19993e7mr28677722pfb.28.1672300943082;
        Thu, 29 Dec 2022 00:02:23 -0800 (PST)
Received: from PF2E59YH-BKX.inc.bytedance.com ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id k17-20020aa79d11000000b005764c8f8f15sm11485781pfp.73.2022.12.29.00.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 00:02:22 -0800 (PST)
From:   Yunhui Cui <cuiyunhui@bytedance.com>
To:     edumazet@google.com, rostedt@goodmis.org, mhiramat@kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, duanxiongchun@bytedance.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, cuiyunhui@bytedance.com
Subject: [PATCH] tcp/udp: add tracepoint for send recv length
Date:   Thu, 29 Dec 2022 16:02:07 +0800
Message-Id: <20221229080207.1029-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.37.3.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiongchun Duan <duanxiongchun@bytedance.com>

Add a tracepoint for capturing TCP segments with
a send or receive length. This makes it easy to obtain
the packet sending and receiving information of each process
in the user mode, such as the netatop tool.

Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>
---
 include/trace/events/tcp.h | 41 ++++++++++++++++++++++++++++++++++++++
 include/trace/events/udp.h | 34 +++++++++++++++++++++++++++++++
 net/ipv4/tcp.c             |  7 +++++++
 net/ipv4/udp.c             | 11 ++++++++--
 4 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 901b440238d5..d9973c8508d1 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -187,6 +187,47 @@ DEFINE_EVENT(tcp_event_sk, tcp_rcv_space_adjust,
 	TP_ARGS(sk)
 );
 
+/*
+ * tcp send/recv stream length
+ *
+ * Note: this class requires positive integer
+ */
+DECLARE_EVENT_CLASS(tcp_stream_length,
+
+	TP_PROTO(struct sock *sk, int length, int error, int flags),
+
+	TP_ARGS(sk, length, error, flags),
+
+	TP_STRUCT__entry(
+		__field(void *, sk)
+		__field(int, length)
+		__field(int, error)
+		__field(int, flags)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->length = length;
+		__entry->error = error;
+		__entry->flags = flags;
+	),
+
+	TP_printk("sk address = %p, length = %d, error = %d flags = %u ",
+		__entry->sk, __entry->length, __entry->error, __entry->flags)
+);
+
+DEFINE_EVENT(tcp_stream_length, tcp_send_length,
+	TP_PROTO(struct sock *sk, int length, int error, int flags),
+
+	TP_ARGS(sk, length, error, flags)
+);
+
+DEFINE_EVENT(tcp_stream_length, tcp_recv_length,
+	TP_PROTO(struct sock *sk, int length, int error, int flags),
+
+	TP_ARGS(sk, length, error, flags)
+);
+
 TRACE_EVENT(tcp_retransmit_synack,
 
 	TP_PROTO(const struct sock *sk, const struct request_sock *req),
diff --git a/include/trace/events/udp.h b/include/trace/events/udp.h
index 336fe272889f..22181c91c8e2 100644
--- a/include/trace/events/udp.h
+++ b/include/trace/events/udp.h
@@ -27,6 +27,40 @@ TRACE_EVENT(udp_fail_queue_rcv_skb,
 	TP_printk("rc=%d port=%hu", __entry->rc, __entry->lport)
 );
 
+DECLARE_EVENT_CLASS(udp_stream_length,
+
+	TP_PROTO(struct sock *sk, int length, int error, int flags),
+
+	TP_ARGS(sk, length, error, flags),
+
+	TP_STRUCT__entry(
+		__field(void *, sk)
+		__field(int, length)
+		__field(int, error)
+		__field(int, flags)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->length = length;
+		__entry->error = error;
+		__entry->flags = flags;
+	),
+
+	TP_printk("sk address = %p, length = %d, error=%d, flags = %u ",
+	__entry->sk, __entry->length, __entry->error, __entry->flags)
+);
+
+DEFINE_EVENT(udp_stream_length, udp_send_length,
+	TP_PROTO(struct sock *sk, int length, int error, int flags),
+	TP_ARGS(sk, length, error, flags)
+);
+
+DEFINE_EVENT(udp_stream_length, udp_recv_length,
+	TP_PROTO(struct sock *sk, int length, int error, int flags),
+	TP_ARGS(sk, length, error, flags)
+);
+
 #endif /* _TRACE_UDP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c567d5e8053e..5deb69e2d3e7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -267,6 +267,7 @@
 #include <linux/errqueue.h>
 #include <linux/static_key.h>
 #include <linux/btf.h>
+#include <trace/events/tcp.h>
 
 #include <net/icmp.h>
 #include <net/inet_common.h>
@@ -1150,6 +1151,7 @@ int tcp_sendpage(struct sock *sk, struct page *page, int offset,
 	lock_sock(sk);
 	ret = tcp_sendpage_locked(sk, page, offset, size, flags);
 	release_sock(sk);
+	trace_tcp_send_length(sk, ret > 0 ? ret : 0, ret > 0 ? 0 : ret, 0);
 
 	return ret;
 }
@@ -1482,6 +1484,7 @@ int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	lock_sock(sk);
 	ret = tcp_sendmsg_locked(sk, msg, size);
 	release_sock(sk);
+	trace_tcp_send_length(sk, ret > 0 ? ret : 0, ret > 0 ? 0 : ret, 0);
 
 	return ret;
 }
@@ -2647,6 +2650,10 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 
 	/* Clean up data we have read: This will do ACK frames. */
 	tcp_cleanup_rbuf(sk, copied);
+	trace_tcp_recv_length(sk, (copied > 0 && !(flags & MSG_PEEK)) ?
+				   copied : 0,
+			      (copied > 0 &&
+			       !(flags & MSG_PEEK)) ? 0 : copied, flags);
 	return copied;
 
 out:
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9592fe3e444a..1b336af4df6d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1300,6 +1300,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	release_sock(sk);
 
 out:
+	trace_udp_send_length(sk, err == 0 ? len : 0, err, 0);
 	ip_rt_put(rt);
 out_free:
 	if (free)
@@ -1364,8 +1365,10 @@ int udp_sendpage(struct sock *sk, struct page *page, int offset,
 			     page, offset, size, flags);
 	if (ret == -EOPNOTSUPP) {
 		release_sock(sk);
-		return sock_no_sendpage(sk->sk_socket, page, offset,
-					size, flags);
+		ret = sock_no_sendpage(sk->sk_socket, page, offset,
+				       size, flags);
+		trace_udp_send_length(sk, ret > 0 ? ret : 0, ret > 0 ? 0 : ret, 0);
+		return ret;
 	}
 	if (ret < 0) {
 		udp_flush_pending_frames(sk);
@@ -1377,6 +1380,7 @@ int udp_sendpage(struct sock *sk, struct page *page, int offset,
 		ret = udp_push_pending_frames(sk);
 	if (!ret)
 		ret = size;
+	trace_udp_send_length(sk, ret > 0 ? ret : 0, ret > 0 ? 0 : ret, 0);
 out:
 	release_sock(sk);
 	return ret;
@@ -1935,6 +1939,9 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	if (flags & MSG_TRUNC)
 		err = ulen;
 
+	trace_udp_recv_length(sk, (err > 0 && !peeking) ? err : 0,
+			      (err > 0 && !peeking) ? 0 : err, flags);
+
 	skb_consume_udp(sk, skb, peeking ? -err : err);
 	return err;
 
-- 
2.20.1

