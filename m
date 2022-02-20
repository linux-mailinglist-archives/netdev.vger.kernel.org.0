Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408574BCCFB
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243516AbiBTHJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:09:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243523AbiBTHJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:09:04 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60BB4D9C8;
        Sat, 19 Feb 2022 23:08:39 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 4so1819864pll.6;
        Sat, 19 Feb 2022 23:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tLcjqdaR2l8lmDXCX6gb5BhKcZZd39bYSYKHEtq/KYM=;
        b=i1c3fTsgGE+FHDZjqHZ+5YOn3UjgNNdWfzxqx/aDCj1QNxRR1H1RfMOQmJu8Vyrw+i
         VtH4KcJxqA4NcBx2F4HPFzhdqGyrnDvJeXODSLm2xqNSrQrRNAkFNqN3ppko/iKwQQWO
         V5/Keh+Uu4dRy0YaFiOIE2D9+dpfdqxHXRvPhZ6+R87IL5s4ZapNzJWBDZlNF4WgHTC6
         FwgACyvHqHOMyUDMgb0Q4UeIzfAy6GBiFtRsbRQg+VA1g6uG8Aod//dZQlWEtZQJgQDv
         9cbXFNe6Fevi0Ck5Dgd3VvqXpUQsXs8Hiw3puxaIlACHyjAatxUSXAJlqMvTYgThPVAM
         wKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tLcjqdaR2l8lmDXCX6gb5BhKcZZd39bYSYKHEtq/KYM=;
        b=0kfVNmxe5KH3ol5aEX2QLl+wvV39GpIN5Wjs/H0I1vPWzOM3Tp3Bz0DUuEZpxUDF+g
         4/l4JmLEmF4bXcJStV9X6oVnYieJG8MK0AXhjUzIaWXDwYSwY1IuUDpiEoIKRSuu5bIR
         WFiBLu6wFYArQSpC5W95b5PQfKwBS5aXIESAG65CKPKKRCxTjF5W2dp123agaNOjThJh
         CKrZ0YJHzpBzUo/1pABtRqUXW6P8LK7gHZJjNNmx3C0m8xYOwO1DwrxrjTdgoaa3F3v3
         woBooylBtkD4fcOq7oKI+Cw7mEq/nHniUOOb6TqXIMGxaFyepATEoARNNyw6dfCpZaLw
         R7qQ==
X-Gm-Message-State: AOAM53054fmch95l3nvUbEH9yiV4Bsmd6I6MdTD5GnurKGn5AkjKjUqr
        hITYgp+paqU8DkXYFC/u+pw=
X-Google-Smtp-Source: ABdhPJy5DPP0HqKijpnbg5EQ1LoX0/Mgyq17VwxwCJr5wAFEylc26pXW3i0CLyuaPeniSi1zpsmowg==
X-Received: by 2002:a17:90a:12c9:b0:1bc:1b9e:ea37 with SMTP id b9-20020a17090a12c900b001bc1b9eea37mr2938352pjg.65.1645340919112;
        Sat, 19 Feb 2022 23:08:39 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:08:38 -0800 (PST)
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        flyingpeng@tencent.com, mengensun@tencent.com
Subject: [PATCH net-next v3 8/9] net: tcp: use tcp_drop_reason() for tcp_data_queue()
Date:   Sun, 20 Feb 2022 15:06:36 +0800
Message-Id: <20220220070637.162720-9-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220070637.162720-1-imagedong@tencent.com>
References: <20220220070637.162720-1-imagedong@tencent.com>
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

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h     | 13 +++++++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/tcp_input.c       | 13 +++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 671db9f49efe..554ef2c848ee 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -363,6 +363,19 @@ enum skb_drop_reason {
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
index 1899388e384a..4da636aa9282 100644
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
2.35.1

