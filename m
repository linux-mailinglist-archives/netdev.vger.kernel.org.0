Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAA5545AC5
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346227AbiFJDpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346202AbiFJDpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:45:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE73385599;
        Thu,  9 Jun 2022 20:45:05 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gd1so23022592pjb.2;
        Thu, 09 Jun 2022 20:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QlWloB9CNb/H1xwLNxfTRraOPX2zqmW3Ul7Xa9j9Pvw=;
        b=Du6ZyKS0rnP70RcsCd/VDNCqjAYNe0ggVxYLvO64jXCUcecKDQqreHxvSrrw2j1wVb
         2ADcOv8tbT9YS3El5EaGazcEPpWmcS9Hts6CT+dgauEbZ7TcLD+WKNZpSEINxekRaumy
         qWp7iq7+75TmcDLdubQhkwkOCLk8rSQdcg2I9SGsygZXf2ypWVqHJb2NaFi1t00rMTec
         GUSR8Vk6cuyrhLGl9cF79LIViE+miYdC4RRjO3sqVjYqRQ/WgJ+Q1ZLpcRbLUITNR4lo
         dydEsIH8FwkzsIe68OD5VGy0/FmrZOGs6ngZdNu3mA83mWfIxVU0H0u+jj9acta2EeYS
         bKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QlWloB9CNb/H1xwLNxfTRraOPX2zqmW3Ul7Xa9j9Pvw=;
        b=XGK2O+uwgJISiNmNdnBsrISIxnLPaqC6qDQHXzkBF9WJHg3A5k0nIgQVkw9PQmwWpN
         +wysIzM+PSrM3MT2xrgi8WWu0g+a/hzGHkYVKbR0OhBj2JQRrn4WFCnlCLOLeEIejL/B
         9r6J4fiNQubZH5PXuWebI/ccGJLXNR918S6goF3qIYpwBAp21bfaPdV8kChhTzhyBM+x
         Et1zVtjvsole0Qsm9Jbbqc9OGe3kWWo3P8G4h4fNCCMaGjTb8kkfnFZ7KVHEwcUpg0RM
         E2sjrqblJhbbe2lyk2KL8NPrLDaaX/T62LCn6M8TiQoVx4LMwcP7uEDR6/oFHkVAfgk4
         G2Mw==
X-Gm-Message-State: AOAM530OUtKPcmMgO39PjSGAsNUpE+lq8eW2/ymffSn18qe8w7ATDE1x
        i0tA/gIS9SdwHVgmerY82ccZjblRmxw=
X-Google-Smtp-Source: ABdhPJxpI6TpNBCDSoQfGG3DCT+m2mRfoTM9v4luI3pSI3EQhYb2siK/abuBc6DQ4foTchcPxS7m9w==
X-Received: by 2002:a17:90a:1150:b0:1e3:2d6b:7a8e with SMTP id d16-20020a17090a115000b001e32d6b7a8emr6632897pje.188.1654832704502;
        Thu, 09 Jun 2022 20:45:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:45:04 -0700 (PDT)
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
Subject: [PATCH net-next v3 5/9] net: tcp: make tcp_rcv_state_process() return drop reason
Date:   Fri, 10 Jun 2022 11:42:00 +0800
Message-Id: <20220610034204.67901-6-imagedong@tencent.com>
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

For now, the return value of tcp_rcv_state_process() is treated as bool.
Therefore, we can make it return the reasons of the skb drops.

Meanwhile, the return value of tcp_child_process() comes from
tcp_rcv_state_process(), make it drop reasons by the way.

The new drop reason SKB_DROP_REASON_TCP_LINGER is added for skb dropping
out of TCP linger.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
v3:
- instead SKB_DROP_REASON_TCP_ABORTONDATA with SKB_DROP_REASON_TCP_LINGER
---
 include/net/dropreason.h |  6 ++++++
 include/net/tcp.h        |  8 +++++---
 net/ipv4/tcp_input.c     | 36 ++++++++++++++++++++----------------
 net/ipv4/tcp_ipv4.c      | 20 +++++++++++++-------
 net/ipv4/tcp_minisocks.c | 11 ++++++-----
 net/ipv6/tcp_ipv6.c      | 19 ++++++++++++-------
 6 files changed, 62 insertions(+), 38 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index c60913aba0e9..bbbf70ce207d 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -242,6 +242,12 @@ enum skb_drop_reason {
 	 * LINUX_MIB_PAWSACTIVEREJECTED
 	 */
 	SKB_DROP_REASON_TCP_PAWSACTIVEREJECTED,
+	/**
+	 * @SKB_DROP_REASON_TCP_LINGER: dropped because of the setting of
+	 * TCP socket option TCP_LINGER2, corresponding to
+	 * LINUX_MIB_TCPABORTONLINGER
+	 */
+	SKB_DROP_REASON_TCP_LINGER,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1e99f5c61f84..ea0eb2d4a743 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -339,7 +339,8 @@ void tcp_wfree(struct sk_buff *skb);
 void tcp_write_timer_handler(struct sock *sk);
 void tcp_delack_timer_handler(struct sock *sk);
 int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg);
-int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb);
+enum skb_drop_reason tcp_rcv_state_process(struct sock *sk,
+					   struct sk_buff *skb);
 void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
 void tcp_rcv_space_adjust(struct sock *sk);
 int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp);
@@ -385,8 +386,9 @@ enum tcp_tw_status tcp_timewait_state_process(struct inet_timewait_sock *tw,
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			   struct request_sock *req, bool fastopen,
 			   bool *lost_race);
-int tcp_child_process(struct sock *parent, struct sock *child,
-		      struct sk_buff *skb);
+enum skb_drop_reason tcp_child_process(struct sock *parent,
+				       struct sock *child,
+				       struct sk_buff *skb);
 void tcp_enter_loss(struct sock *sk);
 void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int newly_lost, int flag);
 void tcp_clear_retrans(struct tcp_sock *tp);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9254f14def43..4a6a93d83866 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6425,13 +6425,13 @@ static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
  *	address independent.
  */
 
-int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
+enum skb_drop_reason tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct request_sock *req;
-	int queued = 0;
+	int queued = 0, ret;
 	bool acceptable;
 	SKB_DR(reason);
 
@@ -6442,7 +6442,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	case TCP_LISTEN:
 		if (th->ack)
-			return 1;
+			return SKB_DROP_REASON_TCP_FLAGS;
 
 		if (th->rst) {
 			SKB_DR_SET(reason, TCP_RESET);
@@ -6463,9 +6463,9 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			rcu_read_unlock();
 
 			if (!acceptable)
-				return 1;
+				return SKB_DROP_REASON_NOT_SPECIFIED;
 			consume_skb(skb);
-			return 0;
+			return SKB_NOT_DROPPED_YET;
 		}
 		SKB_DR_SET(reason, TCP_FLAGS);
 		goto discard;
@@ -6475,13 +6475,13 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		tcp_mstamp_refresh(tp);
 		queued = tcp_rcv_synsent_state_process(sk, skb, th);
 		if (queued >= 0)
-			return queued;
+			return (enum skb_drop_reason)queued;
 
 		/* Do step6 onward by hand. */
 		tcp_urg(sk, skb, th);
 		__kfree_skb(skb);
 		tcp_data_snd_check(sk);
-		return 0;
+		return SKB_NOT_DROPPED_YET;
 	}
 
 	tcp_mstamp_refresh(tp);
@@ -6508,15 +6508,19 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		return 0;
 
 	/* step 5: check the ACK field */
-	acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH |
-				      FLAG_UPDATE_TS_RECENT |
-				      FLAG_NO_CHALLENGE_ACK) > 0;
+	ret = tcp_ack(sk, skb, FLAG_SLOWPATH |
+			       FLAG_UPDATE_TS_RECENT |
+			       FLAG_NO_CHALLENGE_ACK);
+	acceptable = ret > 0;
 
 	if (!acceptable) {
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
 		tcp_send_challenge_ack(sk);
-		SKB_DR_SET(reason, TCP_OLD_ACK);
+		if (ret == 0)
+			SKB_DR_SET(reason, TCP_OLD_ACK);
+		else
+			reason = -ret;
 		goto discard;
 	}
 	switch (sk->sk_state) {
@@ -6585,7 +6589,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (tp->linger2 < 0) {
 			tcp_done(sk);
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
-			return 1;
+			return SKB_DROP_REASON_TCP_LINGER;
 		}
 		if (TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq &&
 		    after(TCP_SKB_CB(skb)->end_seq - th->fin, tp->rcv_nxt)) {
@@ -6594,7 +6598,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 				tcp_fastopen_active_disable(sk);
 			tcp_done(sk);
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
-			return 1;
+			return SKB_DROP_REASON_TCP_INVALID_SEQUENCE;
 		}
 
 		tmo = tcp_fin_time(sk);
@@ -6659,7 +6663,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			    after(TCP_SKB_CB(skb)->end_seq - th->fin, tp->rcv_nxt)) {
 				NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
 				tcp_reset(sk, skb);
-				return 1;
+				return SKB_DROP_REASON_TCP_INVALID_SEQUENCE;
 			}
 		}
 		fallthrough;
@@ -6679,11 +6683,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 discard:
 		tcp_drop_reason(sk, skb, reason);
 	}
-	return 0;
+	return SKB_NOT_DROPPED_YET;
 
 consume:
 	__kfree_skb(skb);
-	return 0;
+	return SKB_NOT_DROPPED_YET;
 }
 EXPORT_SYMBOL(tcp_rcv_state_process);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fe8f23b95d32..7bd35ce48b01 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1670,7 +1670,8 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		if (!nsk)
 			goto discard;
 		if (nsk != sk) {
-			if (tcp_child_process(sk, nsk, skb)) {
+			reason = tcp_child_process(sk, nsk, skb);
+			if (reason) {
 				rsk = nsk;
 				goto reset;
 			}
@@ -1679,7 +1680,8 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 	} else
 		sock_rps_save_rxhash(sk, skb);
 
-	if (tcp_rcv_state_process(sk, skb)) {
+	reason = tcp_rcv_state_process(sk, skb);
+	if (reason) {
 		rsk = sk;
 		goto reset;
 	}
@@ -1688,6 +1690,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 reset:
 	tcp_v4_send_reset(rsk, skb);
 discard:
+	SKB_DR_OR(reason, NOT_SPECIFIED);
 	kfree_skb_reason(skb, reason);
 	/* Be careful here. If this function gets more complicated and
 	 * gcc suffers from register pressure on the x86, sk (in %ebx)
@@ -2019,12 +2022,15 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v4_restore_cb(skb);
-		} else if (tcp_child_process(sk, nsk, skb)) {
-			tcp_v4_send_reset(nsk, skb);
-			goto discard_and_relse;
 		} else {
-			sock_put(sk);
-			return 0;
+			drop_reason = tcp_child_process(sk, nsk, skb);
+			if (drop_reason) {
+				tcp_v4_send_reset(nsk, skb);
+				goto discard_and_relse;
+			} else {
+				sock_put(sk);
+				return 0;
+			}
 		}
 	}
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 6854bb1fb32b..1a21018f6f64 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -821,11 +821,12 @@ EXPORT_SYMBOL(tcp_check_req);
  * be created.
  */
 
-int tcp_child_process(struct sock *parent, struct sock *child,
-		      struct sk_buff *skb)
+enum skb_drop_reason tcp_child_process(struct sock *parent,
+				       struct sock *child,
+				       struct sk_buff *skb)
 	__releases(&((child)->sk_lock.slock))
 {
-	int ret = 0;
+	enum skb_drop_reason reason = SKB_NOT_DROPPED_YET;
 	int state = child->sk_state;
 
 	/* record sk_napi_id and sk_rx_queue_mapping of child. */
@@ -833,7 +834,7 @@ int tcp_child_process(struct sock *parent, struct sock *child,
 
 	tcp_segs_in(tcp_sk(child), skb);
 	if (!sock_owned_by_user(child)) {
-		ret = tcp_rcv_state_process(child, skb);
+		reason = tcp_rcv_state_process(child, skb);
 		/* Wakeup parent, send SIGIO */
 		if (state == TCP_SYN_RECV && child->sk_state != state)
 			parent->sk_data_ready(parent);
@@ -847,6 +848,6 @@ int tcp_child_process(struct sock *parent, struct sock *child,
 
 	bh_unlock_sock(child);
 	sock_put(child);
-	return ret;
+	return reason;
 }
 EXPORT_SYMBOL(tcp_child_process);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f37dd4aa91c6..49c640b0cea3 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1489,7 +1489,8 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 			goto discard;
 
 		if (nsk != sk) {
-			if (tcp_child_process(sk, nsk, skb))
+			reason = tcp_child_process(sk, nsk, skb);
+			if (reason)
 				goto reset;
 			if (opt_skb)
 				__kfree_skb(opt_skb);
@@ -1498,7 +1499,8 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	} else
 		sock_rps_save_rxhash(sk, skb);
 
-	if (tcp_rcv_state_process(sk, skb))
+	reason = tcp_rcv_state_process(sk, skb);
+	if (reason)
 		goto reset;
 	if (opt_skb)
 		goto ipv6_pktoptions;
@@ -1684,12 +1686,15 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v6_restore_cb(skb);
-		} else if (tcp_child_process(sk, nsk, skb)) {
-			tcp_v6_send_reset(nsk, skb);
-			goto discard_and_relse;
 		} else {
-			sock_put(sk);
-			return 0;
+			drop_reason = tcp_child_process(sk, nsk, skb);
+			if (drop_reason) {
+				tcp_v6_send_reset(nsk, skb);
+				goto discard_and_relse;
+			} else {
+				sock_put(sk);
+				return 0;
+			}
 		}
 	}
 
-- 
2.36.1

