Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD354B6AEC
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbiBOLcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:32:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbiBOLbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:31:49 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D72D13FA6;
        Tue, 15 Feb 2022 03:31:40 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id c3so12874836pls.5;
        Tue, 15 Feb 2022 03:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jm4al03lAH79/G+oGH4NcNIm4l9YhtzHtSA+ICE0UDY=;
        b=qqSisgsZiuPaxe0IZ7smpeOMw4sf+xkumP0JqI1jJyvHbKW99CH/yNlQlljfLrPKS9
         yYBuQwYTgbF8Y5otVaVkKa7ze0Ko5pjwtOW/bTmrGAtNpPhNBT+mtw01EFQvyuBPQKCQ
         ZHoMNNkmCzSRpZng+LWsmoGsBmH7x28xGR0Nk1Qhc16rIX6tB37sWUV1efJ5vPCAVtPi
         hjTk9LeoC5K/LV7k12HqqbKWNomtNdShjUBY3dJ0u5ohtxPuoJGzHPodWGKn2aokdeCS
         5lMdYcBF8b+tvECpa+cG43gS0KV0DORloujSX0UgRybOHkqsoERWTBzeLTxZkpWs1Dbj
         ZE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jm4al03lAH79/G+oGH4NcNIm4l9YhtzHtSA+ICE0UDY=;
        b=scYPM2LCfp6bdVohP/Nd9arz0u1dQ+pRrkTnRhf5ug9MZU1yjKGa7O04x/Q4NjJArY
         a/3tieBTe/0WvsBQPaTuobiq4+G2b/xUsOw6T4CtiIiH8Uigk1JBE33xgkmYfbGzITda
         LKmCaZcvY0AzrN3HMhZXt9rhVwRBkVAfHEUkMvIu5rsAiZrNeCt6ZnTpd6DIxEo1N1nA
         c+5inJEJ/Ul67qy94FLlEwC4ioSofI8SxD51cySx40sZior06/Bo+OoXkQro0n1fZ9f/
         yYFHLvRxsfx78R9/LkwGHzwEwhApq8HjcmjkIe0+M9LmIJrYQ0Kf8RnwGPUsn4pVFcKw
         YfjA==
X-Gm-Message-State: AOAM531O7i/uTT/VBRUl/U0qW91hJ9znLcjoJmg3Zx+IMc5zhL25VipQ
        XrUi1Ras5MfH5q29BHmHmxU=
X-Google-Smtp-Source: ABdhPJzqGz9YL/5X21FB+JkGHkSvsavSWcXQgryZn/mcDY+E6HMsAKxW5ugIBuCkPP6iHRYGaGR9Ug==
X-Received: by 2002:a17:90a:5204:: with SMTP id v4mr3923199pjh.47.1644924699867;
        Tue, 15 Feb 2022 03:31:39 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:31:39 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next 08/19] net: tcp: use tcp_drop_reason() for tcp_data_queue()
Date:   Tue, 15 Feb 2022 19:28:01 +0800
Message-Id: <20220215112812.2093852-9-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
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

Replace tcp_drop() used in tcp_data_queue() with tcp_drop_reason().
Following drop reasons are introduced:

SKB_DROP_REASON_TCP_ZEROWINDOW
SKB_DROP_REASON_TCP_OLD_DATA
SKB_DROP_REASON_TCP_OVERWINDOW

SKB_DROP_REASON_TCP_OLD_DATA is used for the case that end_seq of skb
less than the left edges of receive window. (Maybe there is a better
name?)

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 13 +++++++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/tcp_input.c       | 13 +++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dcf9d8bd0079..62a0d7d78f6f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -358,6 +358,19 @@ enum skb_drop_reason {
 					 * LINUX_MIB_TCPBACKLOGDROP)
 					 */
 	SKB_DROP_REASON_TCP_FLAGS,	/* TCP flags invalid */
+	SKB_DROP_REASON_TCP_ZEROWINDOW,	/* TCP receive window size is zero,
+					 * see LINUX_MIB_TCPZEROWINDOWDROP
+					 */
+	SKB_DROP_REASON_TCP_OLD_DATA,	/* the TCP data reveived is already
+					 * received before (spurious retrans
+					 * may happened), see
+					 * LINUX_MIB_DELAYEDACKLOST
+					 */
+	SKB_DROP_REASON_TCP_OVERWINDOW,	/* the TCP data is out of window,
+					 * the seq of the first byte exceed
+					 * the right edges of receive
+					 * window
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index d332e7313a61..cc1c8f7eaf72 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -33,6 +33,9 @@
 	EM(SKB_DROP_REASON_TCP_MD5FAILURE, TCP_MD5FAILURE)	\
 	EM(SKB_DROP_REASON_SOCKET_BACKLOG, SOCKET_BACKLOG)	\
 	EM(SKB_DROP_REASON_TCP_FLAGS, TCP_FLAGS)		\
+	EM(SKB_DROP_REASON_TCP_ZEROWINDOW, TCP_ZEROWINDOW)	\
+	EM(SKB_DROP_REASON_TCP_OLD_DATA, TCP_OLD_DATA)		\
+	EM(SKB_DROP_REASON_TCP_OVERWINDOW, TCP_OVERWINDOW)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8cb0ea34aa49..c042711fb5a2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4991,6 +4991,7 @@ void tcp_data_ready(struct sock *sk)
 static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
+	enum skb_drop_reason reason;
 	bool fragstolen;
 	int eaten;
 
@@ -5009,6 +5010,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	skb_dst_drop(skb);
 	__skb_pull(skb, tcp_hdr(skb)->doff * 4);
 
+	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	tp->rx_opt.dsack = 0;
 
 	/*  Queue data for delivery to the user.
@@ -5017,6 +5019,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	 */
 	if (TCP_SKB_CB(skb)->seq == tp->rcv_nxt) {
 		if (tcp_receive_window(tp) == 0) {
+			reason = SKB_DROP_REASON_TCP_ZEROWINDOW;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPZEROWINDOWDROP);
 			goto out_of_window;
 		}
@@ -5026,6 +5029,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		if (skb_queue_len(&sk->sk_receive_queue) == 0)
 			sk_forced_mem_schedule(sk, skb->truesize);
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
+			reason = SKB_DROP_REASON_PROTO_MEM;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
 			sk->sk_data_ready(sk);
 			goto drop;
@@ -5062,6 +5066,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	if (!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt)) {
 		tcp_rcv_spurious_retrans(sk, skb);
 		/* A retransmit, 2nd most common case.  Force an immediate ack. */
+		reason = SKB_DROP_REASON_TCP_OLD_DATA;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOST);
 		tcp_dsack_set(sk, TCP_SKB_CB(skb)->seq, TCP_SKB_CB(skb)->end_seq);
 
@@ -5069,13 +5074,16 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 		inet_csk_schedule_ack(sk);
 drop:
-		tcp_drop(sk, skb);
+		tcp_drop_reason(sk, skb, reason);
 		return;
 	}
 
 	/* Out of window. F.e. zero window probe. */
-	if (!before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt + tcp_receive_window(tp)))
+	if (!before(TCP_SKB_CB(skb)->seq,
+		    tp->rcv_nxt + tcp_receive_window(tp))) {
+		reason = SKB_DROP_REASON_TCP_OVERWINDOW;
 		goto out_of_window;
+	}
 
 	if (before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt)) {
 		/* Partial packet, seq < rcv_next < end_seq */
@@ -5085,6 +5093,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		 * remembering D-SACK for its head made in previous line.
 		 */
 		if (!tcp_receive_window(tp)) {
+			reason = SKB_DROP_REASON_TCP_ZEROWINDOW;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPZEROWINDOWDROP);
 			goto out_of_window;
 		}
-- 
2.34.1

