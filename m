Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4C94B7F04
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245504AbiBPD4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:56:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245738AbiBPD4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:56:05 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA42F47D2;
        Tue, 15 Feb 2022 19:55:53 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id i10so1029350plr.2;
        Tue, 15 Feb 2022 19:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Igd5WmRzlfBkM7QudgasudwGUSnfgQe6ubQS3rivJ9o=;
        b=EGAcxrqWnPxkhekrnbSeeyVpChoXg63+bQSizt6L6IiwZDcQYHmE91p2cNLXQFB9vR
         PQKtJWDc4Q8+VaHLYV4KJ7und/jATXRDLN7gulOwBSHaWwsARkOZL3ZcmWWnyu+j5BfW
         /VA93rDc+FXC5OghRhAFDb+tUlXI21hizYC50RsJVXWrhZ26dqlGY4Kc14//qSvaAays
         po5YZfivOjYmOlqpM0/rX9f6D7p+Qqlrpcsw+9udIWJovwj8S/0sjH7qV4g3ZXW/Xy7Z
         4KMYE5pVkIkBfcglVWMF7a2T2YXveLHLjFNws8EcWkG7vmyM97tiwkh2qoCzKk+f0EwH
         /Vig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Igd5WmRzlfBkM7QudgasudwGUSnfgQe6ubQS3rivJ9o=;
        b=Su51g1WKt/xgV4TtR1yyub3OdYH/pyv/Htj3hsEE5ldEqGddoBC5/KwX0dBVccx+2V
         IO/28ZhOFVyiXV2QwhmLWvay6t0EAdOjp+qv0aVGBUIcpr7cD+UI22XqYycWo/bi9ZOK
         4dY+vkh0K2nR+wxli51NCkPVsESCgjB4UKcxPpI0pR/kQ4H7FrSsEPj9kBDFRBF4EEvN
         E9MTQg4NUtAt4JtIs3XnTyQi7Ygh2s9ilv/ltMOokRdlWJuCD7rJxANbB9FeUPTxEZam
         c9vEf5jrBkNTd3sVqcEfQ2c3XdSoqu0ul3UcG1+i/PBosRt4EcSf0XjwjgnaUjCFAxiP
         bpLg==
X-Gm-Message-State: AOAM533KVGYHI76t8HAwWyttInbC0CoblnvOXZKGbsME17KSDzCIyDfa
        wFuBc6uiSZ8aQaVF3n0XuJzHhPNAX2c=
X-Google-Smtp-Source: ABdhPJxcb2aSMf+fZCMQX+nVvm6YiWqC8rEz23edP+K15bZ24/vBrYsLE0OHDez1kJT06ducgUUzpQ==
X-Received: by 2002:a17:90a:13c3:b0:1b8:d015:66d2 with SMTP id s3-20020a17090a13c300b001b8d01566d2mr8114321pjf.96.1644983753164;
        Tue, 15 Feb 2022 19:55:53 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:55:52 -0800 (PST)
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
Subject: [PATCH net-next 8/9] net: tcp: use tcp_drop_reason() for tcp_data_queue()
Date:   Wed, 16 Feb 2022 11:54:25 +0800
Message-Id: <20220216035426.2233808-9-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216035426.2233808-1-imagedong@tencent.com>
References: <20220216035426.2233808-1-imagedong@tencent.com>
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
index 16ee1127e25d..0a4ca818d580 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4988,6 +4988,7 @@ void tcp_data_ready(struct sock *sk)
 static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
+	enum skb_drop_reason reason;
 	bool fragstolen;
 	int eaten;
 
@@ -5006,6 +5007,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	skb_dst_drop(skb);
 	__skb_pull(skb, tcp_hdr(skb)->doff * 4);
 
+	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	tp->rx_opt.dsack = 0;
 
 	/*  Queue data for delivery to the user.
@@ -5014,6 +5016,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	 */
 	if (TCP_SKB_CB(skb)->seq == tp->rcv_nxt) {
 		if (tcp_receive_window(tp) == 0) {
+			reason = SKB_DROP_REASON_TCP_ZEROWINDOW;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPZEROWINDOWDROP);
 			goto out_of_window;
 		}
@@ -5023,6 +5026,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		if (skb_queue_len(&sk->sk_receive_queue) == 0)
 			sk_forced_mem_schedule(sk, skb->truesize);
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
+			reason = SKB_DROP_REASON_PROTO_MEM;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
 			sk->sk_data_ready(sk);
 			goto drop;
@@ -5059,6 +5063,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	if (!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt)) {
 		tcp_rcv_spurious_retrans(sk, skb);
 		/* A retransmit, 2nd most common case.  Force an immediate ack. */
+		reason = SKB_DROP_REASON_TCP_OLD_DATA;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOST);
 		tcp_dsack_set(sk, TCP_SKB_CB(skb)->seq, TCP_SKB_CB(skb)->end_seq);
 
@@ -5066,13 +5071,16 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
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
@@ -5082,6 +5090,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		 * remembering D-SACK for its head made in previous line.
 		 */
 		if (!tcp_receive_window(tp)) {
+			reason = SKB_DROP_REASON_TCP_ZEROWINDOW;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPZEROWINDOWDROP);
 			goto out_of_window;
 		}
-- 
2.34.1

