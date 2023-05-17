Return-Path: <netdev+bounces-3349-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 637C070686F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18D622816EA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878AB209BF;
	Wed, 17 May 2023 12:42:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7777618B0B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:42:18 +0000 (UTC)
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CEE269F;
	Wed, 17 May 2023 05:42:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-64359d9c531so517302b3a.3;
        Wed, 17 May 2023 05:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684327336; x=1686919336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pX2hrFRMTsVQF1+5JbeKRRhV3fvCd61M3POL1LFhKAA=;
        b=kDUlcJaW77qv2uceQP01whPf+y603pZWGnpjr3X5VKoYFKVAN6D0NRY4f6T6MCq2rh
         ep/rW4c+eeXIXZULnUI0ht//PM48uzBnwnViUcXEz9K7VDB807FyPRXi1fNsoPggsXhd
         Qw8zXKiP7ZUxHg0BWtYyH1OLe/YZM6iJEATdlO9UYbuQSlR1sTtScm/Efj5kkySgeJuf
         ++nVpAlRG9lPVPbSUyMgroB+NqvhtDflxtk8H28X45+vJeK4a+5WX2MyIFmT0M2cVebq
         USEmEd9DtH9c0sXzZwfDPQng5207kUEhHH/8MrLEDwE2kcbzX6wxedShDdA+5EHLTf26
         2/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684327336; x=1686919336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pX2hrFRMTsVQF1+5JbeKRRhV3fvCd61M3POL1LFhKAA=;
        b=LTqlPHajUDQuypc7t+90ZqnZ3eSAWlzSUwYo9PG7dJXuEJboAQAIsdJv8qQOYjpi5X
         9Zr8Q9jHwfFbeARrq0MEvpps71wSsDDLhwNoX+iC3ar3hFNV3jbORx5NaezZsk8OSdMX
         Wvhng7Ki3KEQu/bpvVC6PAaRxWRuSdXBuY1fP070twpsWcxbceHU4hMbTOPKgF0We0WP
         lNex2DuMcuCGsCurrB/YlCqrUVjLK1tJcq0ncOHBHOYpZQfl6CJkL6rhjP1LnNT+BBAE
         Udcq1r0oaZdjppoAid68ixw6i+Y61BxFn1cp26FxnU1zhC8iyQSo/Mblwre9GfDNYzsu
         On1g==
X-Gm-Message-State: AC+VfDzlVA+jNuracUQWRCDBGBzhKwEwQ21bJbGDp79VAjulY116tXNw
	KoahN2E3PniXkKBfO1bLCNw=
X-Google-Smtp-Source: ACHHUZ6oGWTq7fjcLMhSu3MHrZzpF6gpIFARGwmwve7ipGe3wMAWwd4V6JtnhedYmomBUE50HgvGxw==
X-Received: by 2002:a05:6a20:54a8:b0:104:6432:270 with SMTP id i40-20020a056a2054a800b0010464320270mr24929219pzk.46.1684327336317;
        Wed, 17 May 2023 05:42:16 -0700 (PDT)
Received: from localhost.localdomain ([81.70.217.19])
        by smtp.gmail.com with ESMTPSA id u23-20020aa78497000000b0064aea45b040sm9244224pfn.168.2023.05.17.05.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 05:42:16 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: kuba@kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	dsahern@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next 3/3] net: tcp: handle window shrink properly
Date: Wed, 17 May 2023 20:42:01 +0800
Message-Id: <20230517124201.441634-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517124201.441634-1-imagedong@tencent.com>
References: <20230517124201.441634-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Window shrink is not allowed and also not handled for now, but it's
needed in some case.

In the origin logic, 0 probe is triggered only when there is no any
data in the retrans queue and the receive window can't hold the data
of the 1th packet in the send queue.

Now, let's change it and trigger the 0 probe in such cases:

- if the retrans queue has data and the 1th packet in it is not within
the receive window
- no data in the retrans queue and the 1th packet in the send queue is
out of the end of the receive window

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/tcp.h     | 21 +++++++++++++++++++++
 net/ipv4/tcp_input.c  | 41 +++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_output.c |  3 +--
 net/ipv4/tcp_timer.c  |  4 +---
 4 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a6cf6d823e34..9625d0bf00e1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1910,6 +1910,27 @@ static inline void tcp_add_write_queue_tail(struct sock *sk, struct sk_buff *skb
 		tcp_chrono_start(sk, TCP_CHRONO_BUSY);
 }
 
+static inline bool tcp_rtx_overflow(const struct sock *sk)
+{
+	struct sk_buff *rtx_head = tcp_rtx_queue_head(sk);
+
+	return rtx_head && after(TCP_SKB_CB(rtx_head)->end_seq,
+				 tcp_wnd_end(tcp_sk(sk)));
+}
+
+static inline bool tcp_probe0_needed(const struct sock *sk)
+{
+	/* for the normal case */
+	if (!tcp_sk(sk)->packets_out && !tcp_write_queue_empty(sk))
+		return true;
+
+	if (!sysctl_tcp_wnd_shrink)
+		return false;
+
+	/* for the window shrink case */
+	return tcp_rtx_overflow(sk);
+}
+
 /* Insert new before skb on the write queue of sk.  */
 static inline void tcp_insert_write_queue_before(struct sk_buff *new,
 						  struct sk_buff *skb,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 56e395cb4554..a9ac295502ee 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3188,6 +3188,14 @@ void tcp_rearm_rto(struct sock *sk)
 /* Try to schedule a loss probe; if that doesn't work, then schedule an RTO. */
 static void tcp_set_xmit_timer(struct sock *sk)
 {
+	/* Check if we are already in probe0 state, which means it's
+	 * not needed to schedule the RTO. The normal probe0 can't reach
+	 * here, so it must be window-shrink probe0 case here.
+	 */
+	if (unlikely(inet_csk(sk)->icsk_pending == ICSK_TIME_PROBE0) &&
+	    sysctl_tcp_wnd_shrink)
+		return;
+
 	if (!tcp_schedule_loss_probe(sk, true))
 		tcp_rearm_rto(sk);
 }
@@ -3465,6 +3473,38 @@ static void tcp_ack_probe(struct sock *sk)
 	}
 }
 
+/**
+ * This function is called only when there are packets in the rtx queue,
+ * which means that the packets out is not 0.
+ *
+ * NOTE: we only handle window shrink case in this part.
+ */
+static void tcp_ack_probe_shrink(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	unsigned long when;
+
+	if (!sysctl_tcp_wnd_shrink)
+		return;
+
+	if (tcp_rtx_overflow(sk)) {
+		when = tcp_probe0_when(sk, TCP_RTO_MAX);
+
+		when = tcp_clamp_probe0_to_user_timeout(sk, when);
+		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, when, TCP_RTO_MAX);
+	} else {
+		/* check if recover from window shrink */
+		if (icsk->icsk_pending != ICSK_TIME_PROBE0)
+			return;
+
+		icsk->icsk_backoff = 0;
+		icsk->icsk_probes_tstamp = 0;
+		inet_csk_clear_xmit_timer(sk, ICSK_TIME_PROBE0);
+		if (!tcp_rtx_queue_empty(sk))
+			tcp_retransmit_timer(sk);
+	}
+}
+
 static inline bool tcp_ack_is_dubious(const struct sock *sk, const int flag)
 {
 	return !(flag & FLAG_NOT_DUP) || (flag & FLAG_CA_ALERT) ||
@@ -3908,6 +3948,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP))
 		sk_dst_confirm(sk);
 
+	tcp_ack_probe_shrink(sk);
 	delivered = tcp_newly_delivered(sk, delivered, flag);
 	lost = tp->lost - lost;			/* freshly marked lost */
 	rs.is_ack_delayed = !!(flag & FLAG_ACK_MAYBE_DELAYED);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 21dc4f7e0a12..eac0532edb61 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4089,14 +4089,13 @@ int tcp_write_wakeup(struct sock *sk, int mib)
 void tcp_send_probe0(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	unsigned long timeout;
 	int err;
 
 	err = tcp_write_wakeup(sk, LINUX_MIB_TCPWINPROBE);
 
-	if (tp->packets_out || tcp_write_queue_empty(sk)) {
+	if (!tcp_probe0_needed(sk)) {
 		/* Cancel probe timer, if it is not required. */
 		icsk->icsk_probes_out = 0;
 		icsk->icsk_backoff = 0;
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index b839c2f91292..a28606291b7e 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -350,11 +350,9 @@ static void tcp_delack_timer(struct timer_list *t)
 static void tcp_probe_timer(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct sk_buff *skb = tcp_send_head(sk);
-	struct tcp_sock *tp = tcp_sk(sk);
 	int max_probes;
 
-	if (tp->packets_out || !skb) {
+	if (!tcp_probe0_needed(sk)) {
 		icsk->icsk_probes_out = 0;
 		icsk->icsk_probes_tstamp = 0;
 		return;
-- 
2.40.1


