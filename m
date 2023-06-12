Return-Path: <netdev+bounces-9956-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CAC72B5A8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 05:05:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08B7628108E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 03:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277B4187F;
	Mon, 12 Jun 2023 03:05:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E5CEC3
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 03:05:47 +0000 (UTC)
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C30E5A
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 20:05:36 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-56cfce8862aso16985127b3.1
        for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 20:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1686539135; x=1689131135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xIouLx9anJS3FIuj2th5v9b9/FLYvYZMkzIY6jNuzlg=;
        b=iwSzr+6csY0WNiyTfMZ5KOLfK/pEqZM8Diz366nir4wSi+J7SaoQJ1rE5RN0+2lV2i
         9TD65l8ZS91XZgXlOMe9NpU2vxF5ShOmoK0ZlC3InHkTjxmWANVKwTCP/8MGx9QJmOOu
         Si3zH3RbonGrgvjMvNWWQ/rNXoMiOccPyrvsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686539135; x=1689131135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xIouLx9anJS3FIuj2th5v9b9/FLYvYZMkzIY6jNuzlg=;
        b=L+gegWvCKTcxZrKUtUbveDdUMYXxHXR0Cqvj5BuvqNL8ZTjlhvsPaEsklqcWhZHJPY
         F/XO4Z06hh6Y+A8hbUoCHUFJE0Wa6KehFTaFVHC7Q9W+pNYunJULYtwnTyadI/Po36G7
         Cn7nVHh81ntBFZPfjj+TIRXtkrkDZqUtUzyhyD/LVw4bn9nhIPsw9agnUuRCSE3lU5up
         XUmiKXbXQKek2QJSanubPRnImrsNg5nhsqhvUM2bKHghev/okM/YeE+umQwufF8vpgQT
         E/s9mMHKLTz/gbfjstUOUZf8VLi8Jj5gu7qwWpbCmqLXPRRm7uJIBaUlvQouN5ARTN1G
         ACgg==
X-Gm-Message-State: AC+VfDyuuAl3k3sR+JKPtHgJeaIZ7/PToGkrp5M+8FddbO7vOPLhARvg
	QN7RcvkM6Vb4LExjgPm38EhBYNH4h6zDmRqrHtPmpA==
X-Google-Smtp-Source: ACHHUZ5c54pMai2g5o8WKmI6rFbr9F6gTOUBemJg9W20ADz+Lk5kD1b4b4QCUGbcwpYtgoo8rqDQpA==
X-Received: by 2002:a0d:d542:0:b0:561:18c6:528c with SMTP id x63-20020a0dd542000000b0056118c6528cmr8492508ywd.30.1686539135139;
        Sun, 11 Jun 2023 20:05:35 -0700 (PDT)
Received: from mfreemon-cf-laptop.. ([169.197.147.212])
        by smtp.gmail.com with ESMTPSA id y202-20020a0dd6d3000000b00568938ca41bsm347531ywd.53.2023.06.11.20.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 20:05:34 -0700 (PDT)
From: Mike Freemon <mfreemon@cloudflare.com>
To: netdev@vger.kernel.org
Cc: kernel-team@cloudflare.com,
	edumazet@google.com,
	ncardwell@google.com,
	mfreemon@cloudflare.com
Subject: [PATCH net-next v5] tcp: enforce receive buffer memory limits by allowing the tcp window to shrink
Date: Sun, 11 Jun 2023 22:05:24 -0500
Message-Id: <20230612030524.60537-1-mfreemon@cloudflare.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>

Under certain circumstances, the tcp receive buffer memory limit
set by autotuning (sk_rcvbuf) is increased due to incoming data
packets as a result of the window not closing when it should be.
This can result in the receive buffer growing all the way up to
tcp_rmem[2], even for tcp sessions with a low BDP.

To reproduce:  Connect a TCP session with the receiver doing
nothing and the sender sending small packets (an infinite loop
of socket send() with 4 bytes of payload with a sleep of 1 ms
in between each send()).  This will cause the tcp receive buffer
to grow all the way up to tcp_rmem[2].

As a result, a host can have individual tcp sessions with receive
buffers of size tcp_rmem[2], and the host itself can reach tcp_mem
limits, causing the host to go into tcp memory pressure mode.

The fundamental issue is the relationship between the granularity
of the window scaling factor and the number of byte ACKed back
to the sender.  This problem has previously been identified in
RFC 7323, appendix F [1].

The Linux kernel currently adheres to never shrinking the window.

In addition to the overallocation of memory mentioned above, the
current behavior is functionally incorrect, because once tcp_rmem[2]
is reached when no remediations remain (i.e. tcp collapse fails to
free up any more memory and there are no packets to prune from the
out-of-order queue), the receiver will drop in-window packets
resulting in retransmissions and an eventual timeout of the tcp
session.  A receive buffer full condition should instead result
in a zero window and an indefinite wait.

In practice, this problem is largely hidden for most flows.  It
is not applicable to mice flows.  Elephant flows can send data
fast enough to "overrun" the sk_rcvbuf limit (in a single ACK),
triggering a zero window.

But this problem does show up for other types of flows.  Examples
are websockets and other type of flows that send small amounts of
data spaced apart slightly in time.  In these cases, we directly
encounter the problem described in [1].

RFC 7323, section 2.4 [2], says there are instances when a retracted
window can be offered, and that TCP implementations MUST ensure
that they handle a shrinking window, as specified in RFC 1122,
section 4.2.2.16 [3].  All prior RFCs on the topic of tcp window
management have made clear that sender must accept a shrunk window
from the receiver, including RFC 793 [4] and RFC 1323 [5].

This patch implements the functionality to shrink the tcp window
when necessary to keep the right edge within the memory limit by
autotuning (sk_rcvbuf).  This new functionality is enabled with
the new sysctl: net.ipv4.tcp_shrink_window

Additional information can be found at:
https://blog.cloudflare.com/unbounded-memory-usage-by-tcp-for-receive-buffers-and-how-we-fixed-it/

[1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
[2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
[3] https://www.rfc-editor.org/rfc/rfc1122#page-91
[4] https://www.rfc-editor.org/rfc/rfc793
[5] https://www.rfc-editor.org/rfc/rfc1323

Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
---
 Documentation/networking/ip-sysctl.rst | 15 +++++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  9 ++++
 net/ipv4/tcp_ipv4.c                    |  2 +
 net/ipv4/tcp_output.c                  | 60 ++++++++++++++++++++++----
 5 files changed, 78 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 366e2a5097d9..4a010a7cde7f 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -981,6 +981,21 @@ tcp_tw_reuse - INTEGER
 tcp_window_scaling - BOOLEAN
 	Enable window scaling as defined in RFC1323.
 
+tcp_shrink_window - BOOLEAN
+	This changes how the TCP receive window is calculated.
+
+	RFC 7323, section 2.4, says there are instances when a retracted
+	window can be offered, and that TCP implementations MUST ensure
+	that they handle a shrinking window, as specified in RFC 1122.
+
+	- 0 - Disabled.	The window is never shrunk.
+	- 1 - Enabled.	The window is shrunk when necessary to remain within
+			the memory limit set by autotuning (sk_rcvbuf).
+			This only occurs if a non-zero receive window
+			scaling factor is also in effect.
+
+	Default: 0
+
 tcp_wmem - vector of 3 INTEGERs: min, default, max
 	min: Amount of memory reserved for send buffers for TCP sockets.
 	Each TCP socket has rights to use it due to fact of its birth.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index a4efb7a2796c..f00374718159 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -65,6 +65,7 @@ struct netns_ipv4 {
 #endif
 	bool			fib_has_custom_local_routes;
 	bool			fib_offload_disabled;
+	u8			sysctl_tcp_shrink_window;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	atomic_t		fib_num_tclassid_users;
 #endif
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 356afe54951c..2afb0870648b 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1480,6 +1480,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &tcp_syn_linear_timeouts_max,
 	},
+	{
+		.procname	= "tcp_shrink_window",
+		.data		= &init_net.ipv4.sysctl_tcp_shrink_window,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 84a5d557dc1a..9213804b034f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3281,6 +3281,8 @@ static int __net_init tcp_sk_init(struct net *net)
 		net->ipv4.tcp_congestion_control = &tcp_reno;
 
 	net->ipv4.sysctl_tcp_syn_linear_timeouts = 4;
+	net->ipv4.sysctl_tcp_shrink_window = 0;
+
 	return 0;
 }
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f8ce77ce7c3e..5784f8a99381 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -260,8 +260,8 @@ static u16 tcp_select_window(struct sock *sk)
 	u32 old_win = tp->rcv_wnd;
 	u32 cur_win = tcp_receive_window(tp);
 	u32 new_win = __tcp_select_window(sk);
+	struct net *net = sock_net(sk);
 
-	/* Never shrink the offered window */
 	if (new_win < cur_win) {
 		/* Danger Will Robinson!
 		 * Don't update rcv_wup/rcv_wnd here or else
@@ -270,11 +270,14 @@ static u16 tcp_select_window(struct sock *sk)
 		 *
 		 * Relax Will Robinson.
 		 */
-		if (new_win == 0)
-			NET_INC_STATS(sock_net(sk),
-				      LINUX_MIB_TCPWANTZEROWINDOWADV);
-		new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_shrink_window) || !tp->rx_opt.rcv_wscale) {
+			/* Never shrink the offered window */
+			if (new_win == 0)
+				NET_INC_STATS(net, LINUX_MIB_TCPWANTZEROWINDOWADV);
+			new_win = ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
+		}
 	}
+
 	tp->rcv_wnd = new_win;
 	tp->rcv_wup = tp->rcv_nxt;
 
@@ -282,7 +285,7 @@ static u16 tcp_select_window(struct sock *sk)
 	 * scaled window.
 	 */
 	if (!tp->rx_opt.rcv_wscale &&
-	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows))
+	    READ_ONCE(net->ipv4.sysctl_tcp_workaround_signed_windows))
 		new_win = min(new_win, MAX_TCP_WINDOW);
 	else
 		new_win = min(new_win, (65535U << tp->rx_opt.rcv_wscale));
@@ -294,10 +297,9 @@ static u16 tcp_select_window(struct sock *sk)
 	if (new_win == 0) {
 		tp->pred_flags = 0;
 		if (old_win)
-			NET_INC_STATS(sock_net(sk),
-				      LINUX_MIB_TCPTOZEROWINDOWADV);
+			NET_INC_STATS(net, LINUX_MIB_TCPTOZEROWINDOWADV);
 	} else if (old_win == 0) {
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPFROMZEROWINDOWADV);
+		NET_INC_STATS(net, LINUX_MIB_TCPFROMZEROWINDOWADV);
 	}
 
 	return new_win;
@@ -3003,6 +3005,7 @@ u32 __tcp_select_window(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
+	struct net *net = sock_net(sk);
 	/* MSS for the peer's data.  Previous versions used mss_clamp
 	 * here.  I don't know if the value based on our guesses
 	 * of peer's MSS is better for the performance.  It's more correct
@@ -3024,6 +3027,15 @@ u32 __tcp_select_window(struct sock *sk)
 		if (mss <= 0)
 			return 0;
 	}
+
+	/* Only allow window shrink if the sysctl is enabled and we have
+	 * a non-zero scaling factor in effect.
+	 */
+	if (READ_ONCE(net->ipv4.sysctl_tcp_shrink_window) && tp->rx_opt.rcv_wscale)
+		goto shrink_window_allowed;
+
+	/* do not allow window to shrink */
+
 	if (free_space < (full_space >> 1)) {
 		icsk->icsk_ack.quick = 0;
 
@@ -3078,6 +3090,36 @@ u32 __tcp_select_window(struct sock *sk)
 	}
 
 	return window;
+
+shrink_window_allowed:
+	/* new window should always be an exact multiple of scaling factor */
+	free_space = round_down(free_space, 1 << tp->rx_opt.rcv_wscale);
+
+	if (free_space < (full_space >> 1)) {
+		icsk->icsk_ack.quick = 0;
+
+		if (tcp_under_memory_pressure(sk))
+			tcp_adjust_rcv_ssthresh(sk);
+
+		/* if free space is too low, return a zero window */
+		if (free_space < (allowed_space >> 4) || free_space < mss ||
+			free_space < (1 << tp->rx_opt.rcv_wscale))
+			return 0;
+	}
+
+	if (free_space > tp->rcv_ssthresh) {
+		free_space = tp->rcv_ssthresh;
+		/* new window should always be an exact multiple of scaling factor
+		 *
+		 * For this case, we ALIGN "up" (increase free_space) because
+		 * we know free_space is not zero here, it has been reduced from
+		 * the memory-based limit, and rcv_ssthresh is not a hard limit
+		 * (unlike sk_rcvbuf).
+		 */
+		free_space = ALIGN(free_space, (1 << tp->rx_opt.rcv_wscale));
+	}
+
+	return free_space;
 }
 
 void tcp_skb_collapse_tstamp(struct sk_buff *skb,
-- 
2.40.1


