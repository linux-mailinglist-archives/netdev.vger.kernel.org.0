Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5711754F4E2
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381549AbiFQKGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381568AbiFQKG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:06:29 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F5069B49;
        Fri, 17 Jun 2022 03:06:18 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y6so3750599pfr.13;
        Fri, 17 Jun 2022 03:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bWwL0xApFdW9J/7uAC+LHaUOfa9kdtXxTtubM/dGCJc=;
        b=qi6tIbhVzacrdhQ/G/+Z0vNCd8nGylfKWbEvipScXbrkSUsHpKs7wOvC7JqBsXSclW
         0vaby8AEz3l+5zRg6QzC/vzlfUF04rE9Ym7DekFST7lZLwL2tsdYqSsbscVEJGPF6wSU
         jTh0hW67crLHb6nQ47mFaQBT4oAu0zLj+YA6KGxP6/uauzOh6fiJqmXCbVv65xRoNn+E
         QHzKmwNHGWLKV879xPeqmQbMLz7IHn06qeBySpDdmmpyvQhmZZV+GHSuHh9PKFvCPryb
         AmYzI9SUhESbHOoHTCrFM9h9r525JKNq+yJTD6p8Ly/ECIkYwFBnCZnEd45AVtbifcaH
         zY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bWwL0xApFdW9J/7uAC+LHaUOfa9kdtXxTtubM/dGCJc=;
        b=emlvyIMX2TNyZQ2Sr3imxq7ygulWhHx12fch5UuBKjLwoZjiltT+bL7aUcurTC2tDG
         e2mE0kDex5fy3TiZtW6gK7j7yhBboq00wkeOKMAm2obX8fGDcR79G/5+y/ZJEuwUXEkL
         MXsFJNu15vmgsCLowqfKRNn7dNHgOy3OBwQs9+tCfxFwuH5GgMtZcCgogoLsCEwXB4F6
         fm8zDTEnIaqO2aCxaHJP4T3s4IlzQR7uZMDq+DOvDnnGtGBdDElCSmSg9hk3VRAoUnQ+
         3aeoBdcccazE0scDJQ2lx3q/GoYBFYxna0+Dm+W3su1MzmdDf4bBDMsG5ZINe96ugQng
         M87w==
X-Gm-Message-State: AJIora8ar2mL6SRmJlvB7hsAILmCbe9R8WlmQVlUPMjy3GuYgUktMWB6
        xNudwVozb4vS7P8rVVe9gSc=
X-Google-Smtp-Source: AGRyM1vPZxaAun2vTDvGKVE09SNfRQIfFp45aS52G15Af0Ue98ofYzWbJ6Z0ndQzMcyrVbEVHh4w8g==
X-Received: by 2002:a63:e344:0:b0:3fe:7f8:c644 with SMTP id o4-20020a63e344000000b003fe07f8c644mr8247525pgj.382.1655460377150;
        Fri, 17 Jun 2022 03:06:17 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001621ce92196sm3126210plw.86.2022.06.17.03.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:16 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v4 5/8] net: tcp: add skb drop reasons to tcp connect requesting
Date:   Fri, 17 Jun 2022 18:05:11 +0800
Message-Id: <20220617100514.7230-6-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617100514.7230-1-imagedong@tencent.com>
References: <20220617100514.7230-1-imagedong@tencent.com>
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

In order to get skb drop reasons during tcp connect requesting code path,
we have to pass the pointer of the 'reason' as a new function argument of
conn_request() in 'struct inet_connection_sock_af_ops'. As the return
value of conn_request() can be positive or negative or 0, it's not
flexible to make it return drop reasons.

As the return value of tcp_conn_request() is 0, so we can treat it as bool
and make it return the skb drop reasons.

The new drop reasons 'LISTENOVERFLOWS' and 'TCP_REQQFULLDROP' are added,
which are used for 'accept queue' and 'request queue' full.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reported-by: kernel test robot <lkp@intel.com>
--
v2:
- fix compile error reported by kernel test rebot
---
 include/net/dropreason.h           | 10 ++++++++++
 include/net/inet_connection_sock.h |  3 ++-
 include/net/tcp.h                  |  9 +++++----
 net/dccp/dccp.h                    |  3 ++-
 net/dccp/input.c                   |  3 ++-
 net/dccp/ipv4.c                    |  3 ++-
 net/dccp/ipv6.c                    |  5 +++--
 net/ipv4/tcp_input.c               | 22 ++++++++++++++--------
 net/ipv4/tcp_ipv4.c                |  9 ++++++---
 net/ipv6/tcp_ipv6.c                | 12 ++++++++----
 net/mptcp/subflow.c                |  8 +++++---
 11 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 3c6f1e299c35..74512e60ab12 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -236,6 +236,16 @@ enum skb_drop_reason {
 	 * skb in its receive or send queue are all dropped
 	 */
 	SKB_DROP_REASON_SOCKET_DESTROYED,
+	/**
+	 * @SKB_DROP_REASON_LISTENOVERFLOWS: accept queue of the listen
+	 * socket is full, corresponding to LINUX_MIB_LISTENOVERFLOWS
+	 */
+	SKB_DROP_REASON_LISTENOVERFLOWS,
+	/**
+	 * @SKB_DROP_REASON_TCP_REQQFULLDROP: request queue of the listen
+	 * socket is full, corresponding to LINUX_MIB_TCPREQQFULLDROP
+	 */
+	SKB_DROP_REASON_TCP_REQQFULLDROP,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 077cd730ce2f..7717c59ab3d7 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -37,7 +37,8 @@ struct inet_connection_sock_af_ops {
 	void	    (*send_check)(struct sock *sk, struct sk_buff *skb);
 	int	    (*rebuild_header)(struct sock *sk);
 	void	    (*sk_rx_dst_set)(struct sock *sk, const struct sk_buff *skb);
-	int	    (*conn_request)(struct sock *sk, struct sk_buff *skb);
+	int	    (*conn_request)(struct sock *sk, struct sk_buff *skb,
+				    enum skb_drop_reason *reason);
 	struct sock *(*syn_recv_sock)(const struct sock *sk, struct sk_buff *skb,
 				      struct request_sock *req,
 				      struct dst_entry *dst,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1e99f5c61f84..16da150150c3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -443,7 +443,8 @@ void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb);
 void tcp_v4_mtu_reduced(struct sock *sk);
 void tcp_req_err(struct sock *sk, u32 seq, bool abort);
 void tcp_ld_RTO_revert(struct sock *sk, u32 seq);
-int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
+int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+			enum skb_drop_reason *reason);
 struct sock *tcp_create_openreq_child(const struct sock *sk,
 				      struct request_sock *req,
 				      struct sk_buff *skb);
@@ -2034,9 +2035,9 @@ void tcp4_proc_exit(void);
 #endif
 
 int tcp_rtx_synack(const struct sock *sk, struct request_sock *req);
-int tcp_conn_request(struct request_sock_ops *rsk_ops,
-		     const struct tcp_request_sock_ops *af_ops,
-		     struct sock *sk, struct sk_buff *skb);
+enum skb_drop_reason tcp_conn_request(struct request_sock_ops *rsk_ops,
+				      const struct tcp_request_sock_ops *af_ops,
+				      struct sock *sk, struct sk_buff *skb);
 
 /* TCP af-specific functions */
 struct tcp_sock_af_ops {
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 7dfc00c9fb32..8c1241ae8449 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -255,7 +255,8 @@ void dccp_done(struct sock *sk);
 int dccp_reqsk_init(struct request_sock *rq, struct dccp_sock const *dp,
 		    struct sk_buff const *skb);
 
-int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
+int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+			 enum skb_drop_reason *reason);
 
 struct sock *dccp_create_openreq_child(const struct sock *sk,
 				       const struct request_sock *req,
diff --git a/net/dccp/input.c b/net/dccp/input.c
index 2cbb757a894f..e12baa56ca59 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -576,6 +576,7 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	const int old_state = sk->sk_state;
 	bool acceptable;
 	int queued = 0;
+	SKB_DR(reason);
 
 	/*
 	 *  Step 3: Process LISTEN state
@@ -606,7 +607,7 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 			 */
 			rcu_read_lock();
 			local_bh_disable();
-			acceptable = inet_csk(sk)->icsk_af_ops->conn_request(sk, skb) >= 0;
+			acceptable = inet_csk(sk)->icsk_af_ops->conn_request(sk, skb, &reason) >= 0;
 			local_bh_enable();
 			rcu_read_unlock();
 			if (!acceptable)
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index da6e3b20cd75..b0e8fcabf93b 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -581,7 +581,8 @@ static struct request_sock_ops dccp_request_sock_ops __read_mostly = {
 	.syn_ack_timeout = dccp_syn_ack_timeout,
 };
 
-int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
+int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+			 enum skb_drop_reason *reason)
 {
 	struct inet_request_sock *ireq;
 	struct request_sock *req;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index fd44638ec16b..f01d6a05c7bf 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -314,7 +314,8 @@ static struct request_sock_ops dccp6_request_sock_ops = {
 	.syn_ack_timeout = dccp_syn_ack_timeout,
 };
 
-static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
+static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb,
+				enum skb_drop_reason *reason)
 {
 	struct request_sock *req;
 	struct dccp_request_sock *dreq;
@@ -324,7 +325,7 @@ static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	struct dccp_skb_cb *dcb = DCCP_SKB_CB(skb);
 
 	if (skb->protocol == htons(ETH_P_IP))
-		return dccp_v4_conn_request(sk, skb);
+		return dccp_v4_conn_request(sk, skb, reason);
 
 	if (!ipv6_unicast_destination(skb))
 		return 0;	/* discard, don't send a reset here */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2e2a9ece9af2..8617e7a8f841 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6453,13 +6453,14 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			 */
 			rcu_read_lock();
 			local_bh_disable();
-			acceptable = icsk->icsk_af_ops->conn_request(sk, skb) >= 0;
+			reason = SKB_NOT_DROPPED_YET;
+			acceptable = icsk->icsk_af_ops->conn_request(sk, skb, &reason) >= 0;
 			local_bh_enable();
 			rcu_read_unlock();
 
 			if (!acceptable)
 				return 1;
-			consume_skb(skb);
+			kfree_skb_reason(skb, reason);
 			return 0;
 		}
 		SKB_DR_SET(reason, TCP_FLAGS);
@@ -6879,9 +6880,9 @@ u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
 }
 EXPORT_SYMBOL_GPL(tcp_get_syncookie_mss);
 
-int tcp_conn_request(struct request_sock_ops *rsk_ops,
-		     const struct tcp_request_sock_ops *af_ops,
-		     struct sock *sk, struct sk_buff *skb)
+enum skb_drop_reason tcp_conn_request(struct request_sock_ops *rsk_ops,
+				      const struct tcp_request_sock_ops *af_ops,
+				      struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_fastopen_cookie foc = { .len = -1 };
 	__u32 isn = TCP_SKB_CB(skb)->tcp_tw_isn;
@@ -6893,6 +6894,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	bool want_cookie = false;
 	struct dst_entry *dst;
 	struct flowi fl;
+	SKB_DR(reason);
 
 	/* TW buckets are converted to open requests without
 	 * limitations, they conserve resources and peer is
@@ -6901,12 +6903,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
 	     inet_csk_reqsk_queue_is_full(sk)) && !isn) {
 		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
-		if (!want_cookie)
+		if (!want_cookie) {
+			SKB_DR_SET(reason, TCP_REQQFULLDROP);
 			goto drop;
+		}
 	}
 
 	if (sk_acceptq_is_full(sk)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
+		SKB_DR_SET(reason, LISTENOVERFLOWS);
 		goto drop;
 	}
 
@@ -6962,6 +6967,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			 */
 			pr_drop_req(req, ntohs(tcp_hdr(skb)->source),
 				    rsk_ops->family);
+			SKB_DR_SET(reason, TCP_REQQFULLDROP);
 			goto drop_and_release;
 		}
 
@@ -7014,7 +7020,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		}
 	}
 	reqsk_put(req);
-	return 0;
+	return SKB_NOT_DROPPED_YET;
 
 drop_and_release:
 	dst_release(dst);
@@ -7022,6 +7028,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	__reqsk_free(req);
 drop:
 	tcp_listendrop(sk);
-	return 0;
+	return reason;
 }
 EXPORT_SYMBOL(tcp_conn_request);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fe8f23b95d32..e1064273062a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1458,17 +1458,20 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 	.send_synack	=	tcp_v4_send_synack,
 };
 
-int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
+int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+			enum skb_drop_reason *reason)
 {
 	/* Never answer to SYNs send to broadcast or multicast */
 	if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto drop;
 
-	return tcp_conn_request(&tcp_request_sock_ops,
-				&tcp_request_sock_ipv4_ops, sk, skb);
+	*reason = tcp_conn_request(&tcp_request_sock_ops,
+				   &tcp_request_sock_ipv4_ops, sk, skb);
+	return *reason;
 
 drop:
 	tcp_listendrop(sk);
+	*reason = SKB_DROP_REASON_IP_INADDRERRORS;
 	return 0;
 }
 EXPORT_SYMBOL(tcp_v4_conn_request);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f37dd4aa91c6..dbe356a166c5 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1148,24 +1148,28 @@ u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
 	return mss;
 }
 
-static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
+static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb,
+			       enum skb_drop_reason *reason)
 {
 	if (skb->protocol == htons(ETH_P_IP))
-		return tcp_v4_conn_request(sk, skb);
+		return tcp_v4_conn_request(sk, skb, reason);
 
 	if (!ipv6_unicast_destination(skb))
 		goto drop;
 
 	if (ipv6_addr_v4mapped(&ipv6_hdr(skb)->saddr)) {
 		__IP6_INC_STATS(sock_net(sk), NULL, IPSTATS_MIB_INHDRERRORS);
+		*reason = SKB_DROP_REASON_IP_INADDRERRORS;
 		return 0;
 	}
 
-	return tcp_conn_request(&tcp6_request_sock_ops,
-				&tcp_request_sock_ipv6_ops, sk, skb);
+	*reason = tcp_conn_request(&tcp6_request_sock_ops,
+				   &tcp_request_sock_ipv6_ops, sk, skb);
+	return *reason;
 
 drop:
 	tcp_listendrop(sk);
+	*reason = SKB_DROP_REASON_IP_INADDRERRORS;
 	return 0; /* don't send reset */
 }
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8841e8cd9ad8..5a1d05c3a1ef 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -532,7 +532,8 @@ static int subflow_v6_rebuild_header(struct sock *sk)
 struct request_sock_ops mptcp_subflow_request_sock_ops;
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
-static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
+static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+				   enum skb_drop_reason *reason)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
@@ -556,14 +557,15 @@ static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
 static struct proto tcpv6_prot_override;
 
-static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
+static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb,
+				   enum skb_drop_reason *reason)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
 	pr_debug("subflow=%p", subflow);
 
 	if (skb->protocol == htons(ETH_P_IP))
-		return subflow_v4_conn_request(sk, skb);
+		return subflow_v4_conn_request(sk, skb, reason);
 
 	if (!ipv6_unicast_destination(skb))
 		goto drop;
-- 
2.36.1

