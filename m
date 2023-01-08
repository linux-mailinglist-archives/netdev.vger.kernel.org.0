Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D20661347
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 03:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjAHC4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 21:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbjAHC4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 21:56:22 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B4A33F
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 18:55:58 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id bj3so2197297pjb.0
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 18:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dXg+vv59QSuw+Uy/EXAO3ekbxtavTAVYFpKKeLjSexE=;
        b=H0T10m7Yj1DxhRaZz4cjXDWIQ9dtTl1WGS09KN1maA2YIInqbK4dLDuAErGtKL/zA4
         WgfynpXHEzn+VKGpI3WbNA1/bbqB75BJzWM3ce5XN0Dz7fhJ/3w6sHBEM4iJGaSA+NkK
         /cA5Or+YTnLKbHR0ud9CFOrAi1djgQS/dzeNGOR9+DjGvSIQrOSgeu9AVDG5agc6FLh3
         /008AQgqbqP+Y/64dkz554F90RAcM+y6BG7ZrrNRjrcD/vqCpJj+ljXTITIq7fSSBPeZ
         vr+PcdEnK2hvkhKmY131DE8AmTZp8nKnJr3/89L0skt3qVcmouBIqSl8XXxHYn48pcF7
         VzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dXg+vv59QSuw+Uy/EXAO3ekbxtavTAVYFpKKeLjSexE=;
        b=LVWYwhCWrGQwQy8QYTO1kHmbMSeZFz6HX5Tzr4tRo1FkU8btGkvdzP0NzPucS8zBRP
         vwfYpZWsLp3vtHZTODhg8wlMn2VBgFS3dEVkF6AfEjq/cYcI4fDwae61gIi6/EzvYAca
         29jOUb25ruVbhUFxwgO0wuK0/rrJIjwxfbHRQF1RNXE+CNT7AnfXTI6bHdslJsytE/8x
         CRpIlU8okSd4PztryyDK43+w+3FDfjVdmV58zsVDJS5hWEtVDLT/CAzBkEe9ScNTYFsi
         YXB4FPNEbpQt5eXO64B1jwg/+QkFIOZ2OvkP4FToLypvRGTn7XilEU5wDEurMlGLAs0p
         Ti2A==
X-Gm-Message-State: AFqh2kpBELt6640seKgydEZQteG3MTdMOvlrJ80qZxD/t8DPnXu7hXZ6
        u7fjFIASxQgEFQmu2P6tH8Te6Q==
X-Google-Smtp-Source: AMrXdXsrPjfKLb/sg7286G4XaW4ngFzjaMNzzk0ZlbFN2v6BiFrNT6+ts/EbJos2brW9joBPq8A2og==
X-Received: by 2002:a17:902:a40b:b0:193:234:443a with SMTP id p11-20020a170902a40b00b001930234443amr9523482plq.45.1673146558331;
        Sat, 07 Jan 2023 18:55:58 -0800 (PST)
Received: from PF2E59YH-BKX.inc.bytedance.com ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id u14-20020a170902e5ce00b00189371b5971sm3392859plf.220.2023.01.07.18.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 18:55:57 -0800 (PST)
From:   Yunhui Cui <cuiyunhui@bytedance.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, cuiyunhui@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4] sock: add tracepoint for send recv length
Date:   Sun,  8 Jan 2023 10:55:45 +0800
Message-Id: <20230108025545.338-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.37.3.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 2 tracepoints to monitor the tcp/udp traffic
of per process and per cgroup.

Regarding monitoring the tcp/udp traffic of each process, there are two
existing solutions, the first one is https://www.atoptool.nl/netatop.php.
The second is via kprobe/kretprobe.

Netatop solution is implemented by registering the hook function at the
hook point provided by the netfilter framework.

These hook functions may be in the soft interrupt context and cannot
directly obtain the pid. Some data structures are added to bind packets
and processes. For example, struct taskinfobucket, struct taskinfo ...

Every time the process sends and receives packets it needs multiple
hashmaps,resulting in low performance and it has the problem fo inaccurate
tcp/udp traffic statistics(for example: multiple threads share sockets).

We can obtain the information with kretprobe, but as we know, kprobe gets
the result by trappig in an exception, which loses performance compared
to tracepoint.

We compared the performance of tracepoints with the above two methods, and
the results are as follows:

ab -n 1000000 -c 1000 -r http://127.0.0.1/index.html
without trace:
Time per request: 39.660 [ms] (mean)
Time per request: 0.040 [ms] (mean, across all concurrent requests)

netatop:
Time per request: 50.717 [ms] (mean)
Time per request: 0.051 [ms] (mean, across all concurrent requests)

kr:
Time per request: 43.168 [ms] (mean)
Time per request: 0.043 [ms] (mean, across all concurrent requests)

tracepoint:
Time per request: 41.004 [ms] (mean)
Time per request: 0.041 [ms] (mean, across all concurrent requests

It can be seen that tracepoint has better performance.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>
---
 include/trace/events/sock.h | 48 +++++++++++++++++++++++++++++++++++++
 net/socket.c                | 23 ++++++++++++++----
 2 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 777ee6cbe933..d00a5b272404 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -263,6 +263,54 @@ TRACE_EVENT(inet_sk_error_report,
 		  __entry->error)
 );
 
+/*
+ * sock send/recv msg length
+ */
+DECLARE_EVENT_CLASS(sock_msg_length,
+
+	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
+		 int flags),
+
+	TP_ARGS(sk, family, protocol, ret, flags),
+
+	TP_STRUCT__entry(
+		__field(void *, sk)
+		__field(__u16, family)
+		__field(__u16, protocol)
+		__field(int, length)
+		__field(int, error)
+		__field(int, flags)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->family = sk->sk_family;
+		__entry->protocol = sk->sk_protocol;
+		__entry->length = ret > 0 ? ret : 0;
+		__entry->error = ret < 0 ? ret : 0;
+		__entry->flags = flags;
+	),
+
+	TP_printk("sk address = %p, family = %s protocol = %s, length = %d, error = %d, flags = 0x%x",
+		  __entry->sk, show_family_name(__entry->family),
+		  show_inet_protocol_name(__entry->protocol),
+		  __entry->length,
+		  __entry->error, __entry->flags)
+);
+
+DEFINE_EVENT(sock_msg_length, sock_send_length,
+	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
+		 int flags),
+
+	TP_ARGS(sk, family, protocol, ret, flags)
+);
+
+DEFINE_EVENT(sock_msg_length, sock_recv_length,
+	TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
+		 int flags),
+
+	TP_ARGS(sk, family, protocol, ret, flags)
+);
 #endif /* _TRACE_SOCK_H */
 
 /* This part must be outside protection */
diff --git a/net/socket.c b/net/socket.c
index 888cd618a968..60a1ff95b4b1 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -106,6 +106,7 @@
 #include <net/busy_poll.h>
 #include <linux/errqueue.h>
 #include <linux/ptp_clock_kernel.h>
+#include <trace/events/sock.h>
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 unsigned int sysctl_net_busy_read __read_mostly;
@@ -715,6 +716,9 @@ static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
 				     inet_sendmsg, sock, msg,
 				     msg_data_left(msg));
 	BUG_ON(ret == -EIOCBQUEUED);
+
+	trace_sock_send_length(sock->sk, sock->sk->sk_family,
+			       sock->sk->sk_protocol, ret, 0);
 	return ret;
 }
 
@@ -992,9 +996,15 @@ INDIRECT_CALLABLE_DECLARE(int inet6_recvmsg(struct socket *, struct msghdr *,
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
 				     int flags)
 {
-	return INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
-				  inet_recvmsg, sock, msg, msg_data_left(msg),
-				  flags);
+	int ret = INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
+				     inet_recvmsg, sock, msg,
+				     msg_data_left(msg), flags);
+
+	trace_sock_recv_length(sock->sk, sock->sk->sk_family,
+			       sock->sk->sk_protocol,
+			       !(flags & MSG_PEEK) ? ret :
+			       (ret < 0 ? ret : 0), flags);
+	return ret;
 }
 
 /**
@@ -1044,6 +1054,7 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 {
 	struct socket *sock;
 	int flags;
+	int ret;
 
 	sock = file->private_data;
 
@@ -1051,7 +1062,11 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 	/* more is a combination of MSG_MORE and MSG_SENDPAGE_NOTLAST */
 	flags |= more;
 
-	return kernel_sendpage(sock, page, offset, size, flags);
+	ret = kernel_sendpage(sock, page, offset, size, flags);
+
+	trace_sock_send_length(sock->sk, sock->sk->sk_family,
+			       sock->sk->sk_protocol, ret, 0);
+	return ret;
 }
 
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
-- 
2.20.1

