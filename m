Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A53C545AC8
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346202AbiFJDpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346225AbiFJDpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:45:17 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D693897A5;
        Thu,  9 Jun 2022 20:45:13 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r71so23675489pgr.0;
        Thu, 09 Jun 2022 20:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4yu+lozSLF1Zwo0U8QF2bjZezJ4iWg9jQApb/aMcnfA=;
        b=d3wxpxbm/sfVrq4Rwkhk5xYn8WPID+LOop3/WwBV/C8+Kls1pcVwtHUrrdVRwLd0KP
         HgT6GxM/3CR9yh3khto8ri4EjNYUJT7bonYcWNnWpAYIRSir+Hw4yle9IsdEmXNSIZTB
         +RMHKbh6xah5kVKgMbKzJXJwh7YvpwWInxF6fPWzaV47YHhwASDgB798F68Vo4sdOM8o
         PybCfEV0GNPK2l+AdtDZnk5/px5RPsq7nmaHbYnqufqeOZ2SrRJy0y2/4Y6/jGW4kh09
         Bf3lJZw8S/3gHJs4MjfKrs+JEXseq35hW4c4UdRE5hXH9aVi/ysRgElhMVqHwOfvnP34
         zyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4yu+lozSLF1Zwo0U8QF2bjZezJ4iWg9jQApb/aMcnfA=;
        b=LaEMmcWghRlLyGFXKUicjsQ5Mdr4/JdgDK4gZ7XWRhSWtFCvpEuLEIMRDe9rbWgiT4
         h6gg7hi156LyuNajP2ec0ZLbrkJbboWcfROgp4WjmFVcFwMmG2ex66DoMRiFqxbJ5/BZ
         /2He+kF1nbeoYQUlBLcZOU7NFq8/c2P6EKmwx5mZnuABYtDZnAF1p6JscGyVWqe2XYPV
         L7rQZEUc4eqQ4yN/GwbFEE+VpUKovn/y7iFhv7Icfd3PfADjvfqacB15/j7XGL0zYGgK
         YHlC8inVH3sTyY1DKg3sL1kaOijUucciLqlyDnYSFawdhAjHZcO1AWybi1F3EP6mGby1
         ftIw==
X-Gm-Message-State: AOAM533QG6nqrebenxo3VsQLJ38ZRbgIFWQgUCMS8MKpeD/OS5Fsmga5
        UtED/i+DUA+8hNriQ1nkhVI=
X-Google-Smtp-Source: ABdhPJzcn8MpsKszJ8R3aUNizJzcydnuTNpNsYiA0S5e7yMFHg/Z1tYAVxJUTB2Jo7q8LYhDFkYerQ==
X-Received: by 2002:a63:5d21:0:b0:3fa:387b:7b44 with SMTP id r33-20020a635d21000000b003fa387b7b44mr37933472pgb.48.1654832712959;
        Thu, 09 Jun 2022 20:45:12 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:45:12 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v3 7/9] net: tcp: add skb drop reasons to tcp tw code path
Date:   Fri, 10 Jun 2022 11:42:02 +0800
Message-Id: <20220610034204.67901-8-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610034204.67901-1-imagedong@tencent.com>
References: <20220610034204.67901-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In order to get the reasons of skb drops, add a function argument of
type 'enum skb_drop_reason *reason' to tcp_timewait_state_process().

In the origin code, all packets to time-wait socket are treated as
dropping with kfree_skb(), which can make users confused. Therefore,
we use consume_skb() for the skbs that are 'good'. We can check the
value of 'reason' to decide use kfree_skb() or consume_skb().

The new reason 'TIMEWAIT' is added for the case that the skb is dropped
as the socket in time-wait state.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reported-by: Eric Dumazet <edumazet@google.com>
---
v2:
- skb is not freed on TCP_TW_ACK and 'ret' is not initizalized, fix
  it (Eric Dumazet)
---
 include/net/dropreason.h |  6 ++++++
 include/net/tcp.h        |  7 ++++---
 net/ipv4/tcp_ipv4.c      |  9 ++++++++-
 net/ipv4/tcp_minisocks.c | 24 ++++++++++++++++++++----
 net/ipv6/tcp_ipv6.c      |  8 +++++++-
 5 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 86e89d3022b5..3c6f8e0f7f16 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -258,6 +258,12 @@ enum skb_drop_reason {
 	 * socket is full, corresponding to LINUX_MIB_TCPREQQFULLDROP
 	 */
 	SKB_DROP_REASON_TCP_REQQFULLDROP,
+	/**
+	 * @SKB_DROP_REASON_TIMEWAIT: socket is in time-wait state and all
+	 * packet that received will be treated as 'drop', except a good
+	 * 'SYN' packet
+	 */
+	SKB_DROP_REASON_TIMEWAIT,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 082dd0627e2e..88217b8d95ac 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -380,9 +380,10 @@ enum tcp_tw_status {
 };
 
 
-enum tcp_tw_status tcp_timewait_state_process(struct inet_timewait_sock *tw,
-					      struct sk_buff *skb,
-					      const struct tcphdr *th);
+enum tcp_tw_status
+tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
+			   const struct tcphdr *th,
+			   enum skb_drop_reason *reason);
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			   struct request_sock *req, bool fastopen,
 			   bool *lost_race);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 804fc5e0203e..e7bd2f410a4a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2134,7 +2134,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		inet_twsk_put(inet_twsk(sk));
 		goto csum_error;
 	}
-	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
+	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
+					   &drop_reason)) {
 	case TCP_TW_SYN: {
 		struct sock *sk2 = inet_lookup_listener(dev_net(skb->dev),
 							&tcp_hashinfo, skb,
@@ -2150,11 +2151,17 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			refcounted = false;
 			goto process;
 		}
+		/* TCP_FLAGS or NO_SOCKET? */
+		SKB_DR_SET(drop_reason, TCP_FLAGS);
 	}
 		/* to ACK */
 		fallthrough;
 	case TCP_TW_ACK:
 		tcp_v4_timewait_ack(sk, skb);
+		if (!drop_reason) {
+			consume_skb(skb);
+			return 0;
+		}
 		break;
 	case TCP_TW_RST:
 		tcp_v4_send_reset(sk, skb);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 1a21018f6f64..329724118b7f 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -83,13 +83,15 @@ tcp_timewait_check_oow_rate_limit(struct inet_timewait_sock *tw,
  */
 enum tcp_tw_status
 tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
-			   const struct tcphdr *th)
+			   const struct tcphdr *th,
+			   enum skb_drop_reason *reason)
 {
 	struct tcp_options_received tmp_opt;
 	struct tcp_timewait_sock *tcptw = tcp_twsk((struct sock *)tw);
 	bool paws_reject = false;
 
 	tmp_opt.saw_tstamp = 0;
+	*reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (th->doff > (sizeof(*th) >> 2) && tcptw->tw_ts_recent_stamp) {
 		tcp_parse_options(twsk_net(tw), skb, &tmp_opt, 0, NULL);
 
@@ -113,11 +115,16 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 			return tcp_timewait_check_oow_rate_limit(
 				tw, skb, LINUX_MIB_TCPACKSKIPPEDFINWAIT2);
 
-		if (th->rst)
+		if (th->rst) {
+			SKB_DR_SET(*reason, TCP_RESET);
 			goto kill;
+		}
 
-		if (th->syn && !before(TCP_SKB_CB(skb)->seq, tcptw->tw_rcv_nxt))
+		if (th->syn && !before(TCP_SKB_CB(skb)->seq,
+				       tcptw->tw_rcv_nxt)) {
+			SKB_DR_SET(*reason, TCP_FLAGS);
 			return TCP_TW_RST;
+		}
 
 		/* Dup ACK? */
 		if (!th->ack ||
@@ -143,6 +150,9 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		}
 
 		inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
+
+		/* skb should be free normally on this case. */
+		*reason = SKB_NOT_DROPPED_YET;
 		return TCP_TW_ACK;
 	}
 
@@ -174,6 +184,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 			 * protocol bug yet.
 			 */
 			if (twsk_net(tw)->ipv4.sysctl_tcp_rfc1337 == 0) {
+				SKB_DR_SET(*reason, TCP_RESET);
 kill:
 				inet_twsk_deschedule_put(tw);
 				return TCP_TW_SUCCESS;
@@ -216,11 +227,14 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		if (isn == 0)
 			isn++;
 		TCP_SKB_CB(skb)->tcp_tw_isn = isn;
+		*reason = SKB_NOT_DROPPED_YET;
 		return TCP_TW_SYN;
 	}
 
-	if (paws_reject)
+	if (paws_reject) {
+		SKB_DR_SET(*reason, TCP_RFC7323_PAWS);
 		__NET_INC_STATS(twsk_net(tw), LINUX_MIB_PAWSESTABREJECTED);
+	}
 
 	if (!th->rst) {
 		/* In this case we must reset the TIMEWAIT timer.
@@ -232,9 +246,11 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		if (paws_reject || th->ack)
 			inet_twsk_reschedule(tw, TCP_TIMEWAIT_LEN);
 
+		SKB_DR_OR(*reason, TIMEWAIT);
 		return tcp_timewait_check_oow_rate_limit(
 			tw, skb, LINUX_MIB_TCPACKSKIPPEDTIMEWAIT);
 	}
+	SKB_DR_SET(*reason, TCP_RESET);
 	inet_twsk_put(tw);
 	return TCP_TW_SUCCESS;
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0d2ba9d90529..41551a3b679b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1795,7 +1795,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto csum_error;
 	}
 
-	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th)) {
+	switch (tcp_timewait_state_process(inet_twsk(sk), skb, th,
+					   &drop_reason)) {
 	case TCP_TW_SYN:
 	{
 		struct sock *sk2;
@@ -1815,11 +1816,16 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			refcounted = false;
 			goto process;
 		}
+		SKB_DR_SET(drop_reason, TCP_FLAGS);
 	}
 		/* to ACK */
 		fallthrough;
 	case TCP_TW_ACK:
 		tcp_v6_timewait_ack(sk, skb);
+		if (!drop_reason) {
+			consume_skb(skb);
+			return 0;
+		}
 		break;
 	case TCP_TW_RST:
 		tcp_v6_send_reset(sk, skb);
-- 
2.36.1

