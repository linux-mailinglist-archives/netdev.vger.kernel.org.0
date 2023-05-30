Return-Path: <netdev+bounces-6220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 279577153BE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7D65281053
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 02:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B787FB;
	Tue, 30 May 2023 02:37:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFAF7F6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:37:55 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF379B5
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:37:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64d44b198baso2669267b3a.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685414273; x=1688006273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gs5tI1j/RC/8b7hL2YBuXr3CdTBao0NlpEjc/3wl4Dw=;
        b=aIoXcP/G0Twe5XtF4Sla4LeAsBCtT8n0Cjs5J457ji+lyDU0wmz0vyyRidIbrmKens
         a+hqrTiXlRcWmR0tb86NacPnvLZl4E2SPmXWe+cLrszK7Lqf9wEWN+5QLxpZGdKK1Ih1
         RlHZ+CDzx3Kp2RgNXhD5N74OeayMMH2NDsGBMjgMapWIWGVHCQMmTle/2Ei3ZJcsmJoy
         NGZ6pLvXk07jashDFG5AYSphTo1rFKtkZmdNF50R1u7Hr74TxiBSLw9zVuHCCKvRkS9i
         /LAiDw3c8VFxWXJT2eG/+FbKz1Jl4UYt5EU6hwVjWU6pQYY/k15micdmeYUZS847Cdwi
         NGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685414273; x=1688006273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gs5tI1j/RC/8b7hL2YBuXr3CdTBao0NlpEjc/3wl4Dw=;
        b=WnIcUboZfdqvjvUKghZQ1UNWCOblpuo2voZnKj9FF3NdQ7ndbX1HTjFoafcgvPaWpL
         1feEp03jLJYLlEXpljTTZE78UdfPAL//o7dCm8U95FDiOINIZ1KwuPzQSm0X9QZTnAfw
         B5bk6MPAHWfjxcg6sUNDlbnWmOtGFdVQM/HmK1ApZzFqHkBznDQYHfMDZftqtuUHIHMY
         YKnWOHy6CTodY0lv2Dz4z3eikADO1ob4D2ZupDwuyURQ3gnVdj/zOq44aI/ZJILk0x+W
         lGRXTj0tlQ2HZ6FnOytrXEnjdaFr4O1LV+fd9xisbq20WxPY3UuZWflzHQ3Dy1bPjilA
         pnVQ==
X-Gm-Message-State: AC+VfDxMK0LWUJkGiK2x5pH3jxz2gvesJyyMd79mR85ftCQ/Im6M8RBT
	9BzKSEySepQXtR1CmNi6Huqv5c6q7CASgA==
X-Google-Smtp-Source: ACHHUZ6ch+3uyPY1xlxn/e2KdSHeNmc84wLGVfl3hSE2hHYha8wp1R5VSsawEFs+uYi/7YD659RVrQ==
X-Received: by 2002:a05:6a00:2e17:b0:646:f971:b179 with SMTP id fc23-20020a056a002e1700b00646f971b179mr1618080pfb.16.1685414273387;
        Mon, 29 May 2023 19:37:53 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id g16-20020a62e310000000b0064d74808738sm515620pfh.214.2023.05.29.19.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 19:37:53 -0700 (PDT)
From: Jason Xing <kerneljasonxing@gmail.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	dsahern@kernel.org,
	ncardwell@google.com,
	ycheng@google.com,
	toke@toke.dk
Cc: kerneljasonxing@gmail.com,
	fuyuanli@didiglobal.com,
	netdev@vger.kernel.org,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next] tcp: handle the deferred sack compression when it should be canceled
Date: Tue, 30 May 2023 10:37:37 +0800
Message-Id: <20230530023737.584-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
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

From: Jason Xing <kernelxing@tencent.com>

In the previous commits, we have not implemented to deal with the case
where we're going to abort sending a ack triggered in the timer. So
introducing a new flag ICSK_ACK_COMP_TIMER for sack compression only
could satisify this requirement.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
Comment on this:
This patch is based on top of a commit[1]. I don't think the current
patch is fixing a bug, but more like an improvement. So I would like
to target at net-next tree.

[1]: https://patchwork.kernel.org/project/netdevbpf/patch/20230529113804.GA20300@didi-ThinkCentre-M920t-N000/
---
 include/net/inet_connection_sock.h | 3 ++-
 net/ipv4/tcp_input.c               | 6 +++++-
 net/ipv4/tcp_output.c              | 3 +++
 net/ipv4/tcp_timer.c               | 5 ++++-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c2b15f7e5516..34ff6d27471d 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -164,7 +164,8 @@ enum inet_csk_ack_state_t {
 	ICSK_ACK_TIMER  = 2,
 	ICSK_ACK_PUSHED = 4,
 	ICSK_ACK_PUSHED2 = 8,
-	ICSK_ACK_NOW = 16	/* Send the next ACK immediately (once) */
+	ICSK_ACK_NOW = 16,	/* Send the next ACK immediately (once) */
+	ICSK_ACK_COMP_TIMER  = 32	/* Used for sack compression */
 };
 
 void inet_csk_init_xmit_timers(struct sock *sk,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cc072d2cfcd8..3980f77dcdff 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4540,6 +4540,9 @@ static void tcp_sack_compress_send_ack(struct sock *sk)
 	if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) == 1)
 		__sock_put(sk);
 
+	/* It also deal with the case where the sack compression is deferred */
+	inet_csk(sk)->icsk_ack.pending &= ~ICSK_ACK_COMP_TIMER;
+
 	/* Since we have to send one ack finally,
 	 * substract one from tp->compressed_ack to keep
 	 * LINUX_MIB_TCPACKCOMPRESSED accurate.
@@ -5555,7 +5558,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 		goto send_now;
 	}
 	tp->compressed_ack++;
-	if (hrtimer_is_queued(&tp->compressed_ack_timer))
+	if (inet_csk(sk)->icsk_ack.pending & ICSK_ACK_COMP_TIMER)
 		return;
 
 	/* compress ack timer : 5 % of rtt, but no more than tcp_comp_sack_delay_ns */
@@ -5568,6 +5571,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns),
 		      rtt * (NSEC_PER_USEC >> 3)/20);
 	sock_hold(sk);
+	inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_COMP_TIMER;
 	hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(delay),
 			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns),
 			       HRTIMER_MODE_REL_PINNED_SOFT);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 02b58721ab6b..83840daad142 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -188,6 +188,9 @@ static inline void tcp_event_ack_sent(struct sock *sk, unsigned int pkts,
 		tp->compressed_ack = 0;
 		if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) == 1)
 			__sock_put(sk);
+
+		/* It also deal with the case where the sack compression is deferred */
+		inet_csk(sk)->icsk_ack.pending &= ~ICSK_ACK_COMP_TIMER;
 	}
 
 	if (unlikely(rcv_nxt != tp->rcv_nxt))
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index b3f8933b347c..a970336d1383 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -323,9 +323,12 @@ void tcp_compack_timer_handler(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
+	if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
+	    !(inet_csk(sk)->icsk_ack.pending & ICSK_ACK_COMP_TIMER))
 		return;
 
+	inet_csk(sk)->icsk_ack.pending &= ~ICSK_ACK_COMP_TIMER;
+
 	if (tp->compressed_ack) {
 		/* Since we have to send one ack finally,
 		 * subtract one from tp->compressed_ack to keep
-- 
2.37.3


