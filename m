Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664A420BE0C
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 06:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgF0EGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 00:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgF0EGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 00:06:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2CBC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:06:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e82so12012952ybh.12
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2e2unW1qDyqvth7RC+EnWk87g6+5SgUhOPF73R4c6C0=;
        b=onh2GWLYi/VDAh36uSspfL7itzoTsdnxBBzcKSujP/fJq6MQZa3Nf43qWZbLJy/JEM
         VNQlZvwOxN4AbVpg94JZHsYpHz8cvfniHLKySN6VWOEM2Im2I8jLzVymUzpDR8gcr7Xv
         NRsY+DZxWNwuN2PNM7C6M++hQozU12hfONUT9DXm4whaqY5TvfZDCErq8PWyZN1LwfUa
         +0sFD96RkD6/902xmZHZD9yKf+uSIDh25d25EuubmnRxJ3jl46Me8MW8t/aB/l/1fgvf
         yS5hC1dEMmxZvI7+j9XpQhIL7UN+XzcJOZ+J0WiJRqJNoi3e4qmkSchp65fCP4mj8qUi
         7VOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2e2unW1qDyqvth7RC+EnWk87g6+5SgUhOPF73R4c6C0=;
        b=RHvgetSiJRa3BnEdIkRqU7v0B9S8VaSs1LAotpCp/WUE8Crnx728MtjLReJW8udF3d
         C7HiHB5sHhPyN0a0a3tMChjYq7/VT7zhTvd3xYbnUOXgTUXveu7+lG32Mx/Ld2QF93DL
         TJmc7P3Jhey/n0xAtrKGg5cacNlWUj5dFCQPa0bAXu+xUGrqHXgF1alQ8YCUrjQgPbBF
         1wSc/Vl6+IYdcMPOLYkicIrE26O9J1PIZJIga686bsGUtYU7FGEWwky/tVbRRYoZ8PoJ
         sjLd/xqH0SZ5agVe2pUKTwT9KtmFx0YQGWaMuF21KtYww8gii19e11n+jhjUhq1eExM2
         Y3CQ==
X-Gm-Message-State: AOAM530b+DEJ2aTok5fLTWPSOjBnzH2y71235T4+m5KjXQyaDUuOd1Rm
        nbBGmJj9edvdtSOTRptlBP+btE/YpcwG
X-Google-Smtp-Source: ABdhPJxQBC1gMKY3fjreR/8th/DyxzGKB/ONKaJbY9a+3xYaB0QM3HgvftaQrinwu+HVBtzYs+g//hn/J7OO
X-Received: by 2002:a5b:986:: with SMTP id c6mr10393201ybq.397.1593230760828;
 Fri, 26 Jun 2020 21:06:00 -0700 (PDT)
Date:   Fri, 26 Jun 2020 21:05:35 -0700
In-Reply-To: <20200627040535.858564-1-ysseung@google.com>
Message-Id: <20200627040535.858564-5-ysseung@google.com>
Mime-Version: 1.0
References: <20200627040535.858564-1-ysseung@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net-next 4/4] tcp: update delivered_ce with delivered
From:   Yousuk Seung <ysseung@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yousuk Seung <ysseung@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tp->delivered is updated in various places in tcp_ack() but
tp->delivered_ce is updated once at the end. As a result two counts in
OPT_STATS of SCM_TSTAMP_ACK timestamps generated in tcp_ack() may not be
in sync. This patch updates both counts at the same in tcp_ack().

Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp_input.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index db61ea597e39..8479b84f0a7f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -962,6 +962,15 @@ void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb)
 	}
 }
 
+/* Updates the delivered and delivered_ce counts */
+static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
+				bool ece_ack)
+{
+	tp->delivered += delivered;
+	if (ece_ack)
+		tp->delivered_ce += delivered;
+}
+
 /* This procedure tags the retransmission queue when SACKs arrive.
  *
  * We have three tag bits: SACKED(S), RETRANS(R) and LOST(L).
@@ -1259,7 +1268,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
 		sacked |= TCPCB_SACKED_ACKED;
 		state->flag |= FLAG_DATA_SACKED;
 		tp->sacked_out += pcount;
-		tp->delivered += pcount;  /* Out-of-order packets delivered */
+		/* Out-of-order packets delivered */
 		state->sack_delivered += pcount;
 
 		/* Lost marker hint past SACKed? Tweak RFC3517 cnt */
@@ -1686,7 +1695,7 @@ tcp_sacktag_write_queue(struct sock *sk, const struct sk_buff *ack_skb,
 					 num_sacks, prior_snd_una);
 	if (found_dup_sack) {
 		state->flag |= FLAG_DSACKING_ACK;
-		tp->delivered++; /* A spurious retransmission is delivered */
+		/* A spurious retransmission is delivered */
 		state->sack_delivered++;
 	}
 
@@ -1907,7 +1916,7 @@ static void tcp_add_reno_sack(struct sock *sk, int num_dupack, bool ece_ack)
 		tcp_check_reno_reordering(sk, 0);
 		delivered = tp->sacked_out - prior_sacked;
 		if (delivered > 0)
-			tp->delivered += delivered;
+			tcp_count_delivered(tp, delivered, ece_ack);
 		tcp_verify_left_out(tp);
 	}
 }
@@ -1920,7 +1929,8 @@ static void tcp_remove_reno_sacks(struct sock *sk, int acked, bool ece_ack)
 
 	if (acked > 0) {
 		/* One ACK acked hole. The rest eat duplicate ACKs. */
-		tp->delivered += max_t(int, acked - tp->sacked_out, 1);
+		tcp_count_delivered(tp, max_t(int, acked - tp->sacked_out, 1),
+				    ece_ack);
 		if (acked - 1 >= tp->sacked_out)
 			tp->sacked_out = 0;
 		else
@@ -3116,7 +3126,7 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 		if (sacked & TCPCB_SACKED_ACKED) {
 			tp->sacked_out -= acked_pcount;
 		} else if (tcp_is_sack(tp)) {
-			tp->delivered += acked_pcount;
+			tcp_count_delivered(tp, acked_pcount, ece_ack);
 			if (!tcp_skb_spurious_retrans(tp, skb))
 				tcp_rack_advance(tp, sacked, scb->end_seq,
 						 tcp_skb_timestamp_us(skb));
@@ -3562,10 +3572,9 @@ static u32 tcp_newly_delivered(struct sock *sk, u32 prior_delivered, int flag)
 
 	delivered = tp->delivered - prior_delivered;
 	NET_ADD_STATS(net, LINUX_MIB_TCPDELIVERED, delivered);
-	if (flag & FLAG_ECE) {
-		tp->delivered_ce += delivered;
+	if (flag & FLAG_ECE)
 		NET_ADD_STATS(net, LINUX_MIB_TCPDELIVEREDCE, delivered);
-	}
+
 	return delivered;
 }
 
@@ -3665,6 +3674,10 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 			ack_ev_flags |= CA_ACK_ECE;
 		}
 
+		if (sack_state.sack_delivered)
+			tcp_count_delivered(tp, sack_state.sack_delivered,
+					    flag & FLAG_ECE);
+
 		if (flag & FLAG_WIN_UPDATE)
 			ack_ev_flags |= CA_ACK_WIN_UPDATE;
 
-- 
2.27.0.212.ge8ba1cc988-goog

