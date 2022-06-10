Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32A7545AC7
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346217AbiFJDpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241734AbiFJDpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:45:16 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500E6387E07;
        Thu,  9 Jun 2022 20:45:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u2so22781460pfc.2;
        Thu, 09 Jun 2022 20:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xmRYglaw66fITkh+eW9IirO2k6UnuD95XRBThZBpto4=;
        b=hKOFObmaEeIarWfybCqhp+4CzQfplRZclaDupCZkvSkG5cxg2nvCe5hPyVDr2StKDE
         CMT6AuMSA19oOfxlHHQ8c8FgdlgA5GgccVJRIviPx1ru5aCTWBZUh22njUb//eARajni
         x2Iv/DV7PKQsAiHQ53YqTzpDqgzM98wCM+cmWjeDxUjxl4M/qSkYoNNMCVfuhHzgX7Yw
         M3hkb7SbSEipjBIJ/eHZGhN5SMvYFZ4GYJAJKHctl2tt5iDV2axPttiGIJm4wsqp1fWe
         Gv9+BmvPXliWX9yd3bm5qFNkIgw4jQTUrxZz+Erc/6hOtFNWTEBXmsiMa+W1EYu3rLQU
         7JFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xmRYglaw66fITkh+eW9IirO2k6UnuD95XRBThZBpto4=;
        b=YnZhU+kXUad5jadcFWh2wdewnbwfdlXahqhTVy2r9CS6iH3wwUEsV2CNJ1esiFJBed
         4He+cUBqXN0/fhcUmsoFzGQ6u45rEpDuC9EZQb9kx3zqD3mt2gPaRfo4D1ASvugvF7Ft
         UJPKNJLuIVTqsTICRCnwpKdNVNAycRnhrQznh/3LeKpH3iB1POyPUYnk1H0ZTbQkdqCT
         RK40QZMi3AkJ/NH4G2pLpTGVSqBmNKgaIYxXkMrdNL+SQxhr1w7M+Z62AIgAgDAZPRDC
         Y9vVADAQgCT0CZhzxceI1JwYzWPYlsgjw1H5O6zbDnKeXF+VazEUE6H7ewzxgP1ehgl1
         V77A==
X-Gm-Message-State: AOAM532aQmPtNMn+xw/dJCPcigv/tN5X/k6wK/yHd1bYxU+YcQogMKF5
        aSTyy2p/Izfv5mOAsxEoIJg=
X-Google-Smtp-Source: ABdhPJw7bcb/x0iNXiabnSDdv8D1sh7zZBd0tNWoQZOBtufyRDduh7yaO2s6wrNkeP0Pisy8cBFdcg==
X-Received: by 2002:a62:6144:0:b0:51b:99a7:5164 with SMTP id v65-20020a626144000000b0051b99a75164mr43126596pfb.61.1654832708807;
        Thu, 09 Jun 2022 20:45:08 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:45:08 -0700 (PDT)
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
Subject: [PATCH net-next v3 6/9] net: tcp: add skb drop reasons to tcp connect requesting
Date:   Fri, 10 Jun 2022 11:42:01 +0800
Message-Id: <20220610034204.67901-7-imagedong@tencent.com>
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
 net/ipv4/tcp_input.c               | 27 ++++++++++++++++++---------
 net/ipv4/tcp_ipv4.c                |  9 ++++++---
 net/ipv6/tcp_ipv6.c                | 12 ++++++++----
 net/mptcp/subflow.c                |  8 +++++---
 11 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index bbbf70ce207d..86e89d3022b5 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -248,6 +248,16 @@ enum skb_drop_reason {
 	 * LINUX_MIB_TCPABORTONLINGER
 	 */
 	SKB_DROP_REASON_TCP_LINGER,
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
index ea0eb2d4a743..082dd0627e2e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -445,7 +445,8 @@ void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb);
 void tcp_v4_mtu_reduced(struct sock *sk);
 void tcp_req_err(struct sock *sk, u32 seq, bool abort);
 void tcp_ld_RTO_revert(struct sock *sk, u32 seq);
-int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
+int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb,
+			enum skb_drop_reason *reason);
 struct sock *tcp_create_openreq_child(const struct sock *sk,
 				      struct request_sock *req,
 				      struct sk_buff *skb);
@@ -2036,9 +2037,9 @@ void tcp4_proc_exit(void);
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
index 4a6a93d83866..6f7dd2564b9b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6458,13 +6458,17 @@ enum skb_drop_reason tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			 */
 			rcu_read_lock();
 			local_bh_disable();
-			acceptable = icsk->icsk_af_ops->conn_request(sk, skb) >= 0;
+			reason = SKB_NOT_DROPPED_YET;
+			acceptable = icsk->icsk_af_ops->conn_request(sk, skb, &reason) >= 0;
 			local_bh_enable();
 			rcu_read_unlock();
 
 			if (!acceptable)
-				return SKB_DROP_REASON_NOT_SPECIFIED;
-			consume_skb(skb);
+				return reason ?: SKB_DROP_REASON_NOT_SPECIFIED;
+			if (reason)
+				kfree_skb_reason(skb, reason);
+			else
+				consume_skb(skb);
 			return SKB_NOT_DROPPED_YET;
 		}
 		SKB_DR_SET(reason, TCP_FLAGS);
@@ -6888,9 +6892,9 @@ u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
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
@@ -6902,6 +6906,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	bool want_cookie = false;
 	struct dst_entry *dst;
 	struct flowi fl;
+	SKB_DR(reason);
 
 	/* TW buckets are converted to open requests without
 	 * limitations, they conserve resources and peer is
@@ -6910,12 +6915,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
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
 
@@ -6971,6 +6979,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			 */
 			pr_drop_req(req, ntohs(tcp_hdr(skb)->source),
 				    rsk_ops->family);
+			SKB_DR_SET(reason, TCP_REQQFULLDROP);
 			goto drop_and_release;
 		}
 
@@ -7023,7 +7032,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		}
 	}
 	reqsk_put(req);
-	return 0;
+	return SKB_NOT_DROPPED_YET;
 
 drop_and_release:
 	dst_release(dst);
@@ -7031,6 +7040,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	__reqsk_free(req);
 drop:
 	tcp_listendrop(sk);
-	return 0;
+	return reason;
 }
 EXPORT_SYMBOL(tcp_conn_request);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7bd35ce48b01..804fc5e0203e 100644
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
index 49c640b0cea3..0d2ba9d90529 100644
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

