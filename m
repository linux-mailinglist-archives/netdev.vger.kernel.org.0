Return-Path: <netdev+bounces-1240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 784666FCD3A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E52D28137A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC63219503;
	Tue,  9 May 2023 18:06:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF01EF9C9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:06:15 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E5C4499
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:06:13 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1aaf0bc8a07so13079135ad.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 11:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683655573; x=1686247573;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ByEsTzRxnJ3Rk7qjNN5DL5lt+Ahn3lmBcFN2uhP4cw4=;
        b=ORtLBlIIJLqykc1FEGPRrFFlyzl42dgGf4d1xCFAwzqFxO1OXgdyTtyeASAe4abyOT
         P1JslseKciKf5mssGwstWzjIp6EYU/+wcd9CLBAfdG52AIWLDC/MoBjp5HQkW6h9/j3w
         63mEWbSIGj62tbUa3TQUMN8XQTvh32TMkj+Ma23S9HT0e/MvBAvnQHdIfuQzl0e+mK7W
         4rWY4jxUKrmPJnXTdALGcbpv8GV43NBTDW993Wnd4BeYg/GJnUM9dfxMXDnHv8jTI9Hy
         5u2DQzJ2zYO0ZIOtmA/is1da2M7cyTwiCmVzawiGSbCxSyeX9biEQwBqwo1AWAMBI21f
         Qh8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683655573; x=1686247573;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ByEsTzRxnJ3Rk7qjNN5DL5lt+Ahn3lmBcFN2uhP4cw4=;
        b=Myl2VXlftXTAbe02xnGFLk6yRrQ6ptUWv7ty17yYHz7P1p45CDJqi+kJmWDyQ0k0eU
         0dN8dpRVZkvZj/TGRzP4zvBFJxi3YQH08a1Em9+u+T9uO4AT8hA0GicRGi+3N3Wxyeze
         t+QYVl92ljcqBIMNeoKwHcglnGeKx3LZk3peLvnpKCFsGqf2jRm7Xscp37lkYFuLp+vJ
         7d4oWbDoM48dyaoIY5udvPGQnin74hkjK9+Tns/lHLcbTGUiRoiUgwWxNcSncl6zIO5o
         GETmVSpztEKLeMn/Tg8xS29XTK1Ua33ezzDxjN1KXLOJWNVBRLjs/7fs8qoMP/0KCBj4
         5K5Q==
X-Gm-Message-State: AC+VfDyurUfh0Jb7zlxAIPkI20Nny7H71Q86QN4en1gfsd8I6VTvkYtD
	Hxny6uSufebEv/2RK5j7hc8=
X-Google-Smtp-Source: ACHHUZ4lSvtM4jEYQ9shZJUcxPOhGZ1xjd0UePDg0wruPr8TiMDXZjW3Scs06xqGki/f0A2+mH+2Vg==
X-Received: by 2002:a17:902:d4c4:b0:1ac:40f7:8b5a with SMTP id o4-20020a170902d4c400b001ac40f78b5amr17795583plg.3.1683655573165;
        Tue, 09 May 2023 11:06:13 -0700 (PDT)
Received: from dmoe.c.googlers.com.com (25.11.145.34.bc.googleusercontent.com. [34.145.11.25])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902e9c400b001a673210cf4sm1918705plk.74.2023.05.09.11.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 11:06:12 -0700 (PDT)
From: David Morley <morleyd.kernel@gmail.com>
To: David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org,
	David Morley <morleyd@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next] tcp: make the first N SYN RTO backoffs linear
Date: Tue,  9 May 2023 18:05:58 +0000
Message-ID: <20230509180558.2541885-1-morleyd.kernel@gmail.com>
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: David Morley <morleyd@google.com>

Currently the SYN RTO schedule follows an exponential backoff
scheme, which can be unnecessarily conservative in cases where
there are link failures. In such cases, it's better to
aggressively try to retransmit packets, so it takes routers
less time to find a repath with a working link.

We chose a default value for this sysctl of 4, to follow
the macOS and IOS backoff scheme of 1,1,1,1,1,2,4,8, ...
MacOS and IOS have used this backoff schedule for over
a decade, since before this 2009 IETF presentation
discussed the behavior:
https://www.ietf.org/proceedings/75/slides/tcpm-1.pdf

This commit makes the SYN RTO schedule start with a number of
linear backoffs given by the following sysctl:
* tcp_syn_linear_timeouts

This changes the SYN RTO scheme to be: init_rto_val for
tcp_syn_linear_timeouts, exp backoff starting at init_rto_val

For example if init_rto_val = 1 and tcp_syn_linear_timeouts = 2, our
backoff scheme would be: 1, 1, 1, 2, 4, 8, 16, ...

Signed-off-by: David Morley <morleyd@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Tested-by: David Morley <morleyd@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 Documentation/networking/ip-sysctl.rst | 17 ++++++++++++++---
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             | 10 ++++++++++
 net/ipv4/tcp_ipv4.c                    |  1 +
 net/ipv4/tcp_timer.c                   | 17 +++++++++++++----
 5 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 6ec06a33688a..3f6d3d5f5626 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -881,9 +881,10 @@ tcp_fastopen_key - list of comma separated 32-digit hexadecimal INTEGERs
 tcp_syn_retries - INTEGER
 	Number of times initial SYNs for an active TCP connection attempt
 	will be retransmitted. Should not be higher than 127. Default value
-	is 6, which corresponds to 63seconds till the last retransmission
-	with the current initial RTO of 1second. With this the final timeout
-	for an active TCP connection attempt will happen after 127seconds.
+	is 6, which corresponds to 67seconds (with tcp_syn_linear_timeouts = 4)
+	till the last retransmission with the current initial RTO of 1second.
+	With this the final timeout for an active TCP connection attempt
+	will happen after 131seconds.
 
 tcp_timestamps - INTEGER
 	Enable timestamps as defined in RFC1323.
@@ -946,6 +947,16 @@ tcp_pacing_ca_ratio - INTEGER
 
 	Default: 120
 
+tcp_syn_linear_timeouts - INTEGER
+	The number of times for an active TCP connection to retransmit SYNs with
+	a linear backoff timeout before defaulting to an exponential backoff
+	timeout. This has no effect on SYNACK at the passive TCP side.
+
+	With an initial RTO of 1 and tcp_syn_linear_timeouts = 4 we would
+	expect SYN RTOs to be: 1, 1, 1, 1, 1, 2, 4, ... (4 linear timeouts,
+	and the first exponential backoff using 2^0 * initial_RTO).
+	Default: 4
+
 tcp_tso_win_divisor - INTEGER
 	This allows control over what percentage of the congestion window
 	can be consumed by a single TSO frame.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index db762e35aca9..a4efb7a2796c 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -194,6 +194,7 @@ struct netns_ipv4 {
 	int sysctl_udp_rmem_min;
 
 	u8 sysctl_fib_notify_on_flag_change;
+	u8 sysctl_tcp_syn_linear_timeouts;
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	u8 sysctl_udp_l3mdev_accept;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 40fe70fc2015..6ae3345a3bdf 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -34,6 +34,7 @@ static int ip_ttl_min = 1;
 static int ip_ttl_max = 255;
 static int tcp_syn_retries_min = 1;
 static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
+static int tcp_syn_linear_timeouts_max = MAX_TCP_SYNCNT;
 static int ip_ping_group_range_min[] = { 0, 0 };
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
@@ -1470,6 +1471,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = &tcp_plb_max_cong_thresh,
 	},
+	{
+		.procname = "tcp_syn_linear_timeouts",
+		.data = &init_net.ipv4.sysctl_tcp_syn_linear_timeouts,
+		.maxlen = sizeof(u8),
+		.mode = 0644,
+		.proc_handler = proc_dou8vec_minmax,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = &tcp_syn_linear_timeouts_max,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 39bda2b1066e..db24ed8f8509 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3275,6 +3275,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	else
 		net->ipv4.tcp_congestion_control = &tcp_reno;
 
+	net->ipv4.sysctl_tcp_syn_linear_timeouts = 4;
 	return 0;
 }
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index b839c2f91292..0d93a2573807 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -234,14 +234,19 @@ static int tcp_write_timeout(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	bool expired = false, do_reset;
-	int retry_until;
+	int retry_until, max_retransmits;
 
 	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
 		if (icsk->icsk_retransmits)
 			__dst_negative_advice(sk);
 		retry_until = icsk->icsk_syn_retries ? :
 			READ_ONCE(net->ipv4.sysctl_tcp_syn_retries);
-		expired = icsk->icsk_retransmits >= retry_until;
+
+		max_retransmits = retry_until;
+		if (sk->sk_state == TCP_SYN_SENT)
+			max_retransmits += READ_ONCE(net->ipv4.sysctl_tcp_syn_linear_timeouts);
+
+		expired = icsk->icsk_retransmits >= max_retransmits;
 	} else {
 		if (retransmits_timed_out(sk, READ_ONCE(net->ipv4.sysctl_tcp_retries1), 0)) {
 			/* Black hole detection */
@@ -577,8 +582,12 @@ void tcp_retransmit_timer(struct sock *sk)
 	    icsk->icsk_retransmits <= TCP_THIN_LINEAR_RETRIES) {
 		icsk->icsk_backoff = 0;
 		icsk->icsk_rto = min(__tcp_set_rto(tp), TCP_RTO_MAX);
-	} else {
-		/* Use normal (exponential) backoff */
+	} else if (sk->sk_state != TCP_SYN_SENT ||
+		   icsk->icsk_backoff >
+		   READ_ONCE(net->ipv4.sysctl_tcp_syn_linear_timeouts)) {
+		/* Use normal (exponential) backoff unless linear timeouts are
+		 * activated.
+		 */
 		icsk->icsk_rto = min(icsk->icsk_rto << 1, TCP_RTO_MAX);
 	}
 	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
-- 
2.40.1.521.gf1e218fcd8-goog


