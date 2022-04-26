Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E20B50F362
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344456AbiDZIKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiDZIKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:10:48 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2F747AF2;
        Tue, 26 Apr 2022 01:07:41 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so1558543pjb.5;
        Tue, 26 Apr 2022 01:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dd4CplGAbksfC5dSDV3nqHK5N6BzoTPgvkV6PlzyYHU=;
        b=nwyYhMG/Np7gtkQJrKyMEC0oOoHlEi32qb2InZhCnKj6GDzINXvMz5gcu7DzO3T7mo
         bI5yL2w3+Wu1WFADum/TFh/9qonyIhmM1zFyXeLimIRANIk5A80Wj0gwc1h9a3sA5LZP
         6fGluRVsv9DnqXniVjOVN0pStP+87PH8byCG3Q7RJIx9oLVkHAQoyYwKDmxrRGAO9YMN
         Xk1qkqoZqurLXgh4mV3LmiIWSSIRezGfK/UGQooQVp4m9iSkX+g1zYHFRoxBEZj8qvWn
         y6BDS3BlUiekRUa7Mp1uWJuEQoPY6EKWXdDba3NNxRxkQFpBiaG7CdgLtgDkbNzmS+Ft
         j3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dd4CplGAbksfC5dSDV3nqHK5N6BzoTPgvkV6PlzyYHU=;
        b=jYUpysBZ0T9u9nvJzfvjXw+eJ5FUrZ8/afDFLXt1FWi/GBneDQVzQrnnRumyu8BDZo
         GB7XCcQKUKQ51yBiR0TjexyGzMbLsK0W5erw2vMjzszJt9UIPuyNV4q57YIDZ4BjokGF
         crz8fknPq8mk6DJ15lrCKnYyxEL0we3zvUtTMeMcAlgM+Z7hsJ+j0/oinjMjdG5va6wq
         Q3iOCX/4ruNebvOs2EoHVBjAVe17RGeGKUHwFFTboRTMi/7ETdmqLN6ARCCpA8OuJeSa
         UjSBLdhUDtqnlstp6Y0Skyjoo0ohgNgMm7sezYRGOeAEVmgLWHk498MsVOWjuo1UD0mn
         sqIg==
X-Gm-Message-State: AOAM533BUzTJ57IeTexnGkr7jNs0OiDWyX59vDgzvB2XGd8w/RoiFZOo
        8QJ7T/PCz6iXjQr8otuDi3rgvCxIbt4=
X-Google-Smtp-Source: ABdhPJyt27IvCxS9J0SslONRIGiqY/kWa3aEY1EWyEQQ/mNhOyId4wwuKZ4P0SVnD7cy5ALW/MsOaA==
X-Received: by 2002:a17:902:d58a:b0:15d:1da8:81fb with SMTP id k10-20020a170902d58a00b0015d1da881fbmr7822396plh.133.1650960461428;
        Tue, 26 Apr 2022 01:07:41 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l4-20020a056a0016c400b004f79504ef9csm15134951pfc.3.2022.04.26.01.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 01:07:40 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: add skb drop reasons to inet connect request
Date:   Tue, 26 Apr 2022 16:07:08 +0800
Message-Id: <20220426080709.6504-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426080709.6504-1-imagedong@tencent.com>
References: <20220426080709.6504-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The 'conn_request()' in struct inet_connection_sock_af_ops is used to
process connection requesting for TCP/DCCP. Take TCP for example, it
is just 'tcp_v4_conn_request()'.

When non-zero value is returned by 'tcp_v4_conn_request()', the skb
will be freed by kfree_skb() and a 'reset' packet will be send.
Otherwise, it will be freed normally.

In this code path, 'consume_skb()' is used in many abnormal cases, such
as the accept queue of the listen socket full, which should be
'kfree_skb()'.

Therefore, we make a little change to the 'conn_request()' interface.
When 0 is returned, we call 'consume_skb()' as usual; when negative is
returned, we call 'kfree_skb()' and send a 'reset' as usual; when
positive is returned, which has not happened yet, we do nothing, and
skb will be freed in 'conn_request()'. Then, we can use drop reasons
in 'conn_request()'.

Following new drop reasons are added:

  SKB_DROP_REASON_LISTENOVERFLOWS
  SKB_DROP_REASON_TCP_REQQFULLDROP

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  4 ++++
 include/trace/events/skb.h |  2 ++
 net/dccp/input.c           | 12 +++++-------
 net/ipv4/tcp_input.c       | 21 +++++++++++++--------
 net/ipv4/tcp_ipv4.c        |  3 ++-
 5 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 84d78df60453..f33b3636bbce 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -469,6 +469,10 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_PKT_TOO_BIG,	/* packet size is too big (maybe exceed
 					 * the MTU)
 					 */
+	SKB_DROP_REASON_LISTENOVERFLOWS, /* accept queue of the listen socket is full */
+	SKB_DROP_REASON_TCP_REQQFULLDROP, /* request queue of the listen
+					   * socket is full
+					   */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a477bf907498..de6c93670437 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -80,6 +80,8 @@
 	EM(SKB_DROP_REASON_IP_INADDRERRORS, IP_INADDRERRORS)	\
 	EM(SKB_DROP_REASON_IP_INNOROUTES, IP_INNOROUTES)	\
 	EM(SKB_DROP_REASON_PKT_TOO_BIG, PKT_TOO_BIG)		\
+	EM(SKB_DROP_REASON_LISTENOVERFLOWS, LISTENOVERFLOWS)	\
+	EM(SKB_DROP_REASON_TCP_REQQFULLDROP, TCP_REQQFULLDROP)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/dccp/input.c b/net/dccp/input.c
index 2cbb757a894f..ed20dfe83f66 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -574,8 +574,7 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	struct dccp_sock *dp = dccp_sk(sk);
 	struct dccp_skb_cb *dcb = DCCP_SKB_CB(skb);
 	const int old_state = sk->sk_state;
-	bool acceptable;
-	int queued = 0;
+	int err, queued = 0;
 
 	/*
 	 *  Step 3: Process LISTEN state
@@ -606,13 +605,12 @@ int dccp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 			 */
 			rcu_read_lock();
 			local_bh_disable();
-			acceptable = inet_csk(sk)->icsk_af_ops->conn_request(sk, skb) >= 0;
+			err = inet_csk(sk)->icsk_af_ops->conn_request(sk, skb);
 			local_bh_enable();
 			rcu_read_unlock();
-			if (!acceptable)
-				return 1;
-			consume_skb(skb);
-			return 0;
+			if (!err)
+				consume_skb(skb);
+			return err < 0;
 		}
 		if (dh->dccph_type == DCCP_PKT_RESET)
 			goto discard;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index daff631b9486..e0bbbd624246 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6411,7 +6411,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct request_sock *req;
-	int queued = 0;
+	int err, queued = 0;
 	bool acceptable;
 	SKB_DR(reason);
 
@@ -6438,14 +6438,13 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			 */
 			rcu_read_lock();
 			local_bh_disable();
-			acceptable = icsk->icsk_af_ops->conn_request(sk, skb) >= 0;
+			err = icsk->icsk_af_ops->conn_request(sk, skb);
 			local_bh_enable();
 			rcu_read_unlock();
 
-			if (!acceptable)
-				return 1;
-			consume_skb(skb);
-			return 0;
+			if (!err)
+				consume_skb(skb);
+			return err < 0;
 		}
 		SKB_DR_SET(reason, TCP_FLAGS);
 		goto discard;
@@ -6878,6 +6877,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	bool want_cookie = false;
 	struct dst_entry *dst;
 	struct flowi fl;
+	SKB_DR(reason);
 
 	/* TW buckets are converted to open requests without
 	 * limitations, they conserve resources and peer is
@@ -6886,12 +6886,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
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
 
@@ -6947,6 +6950,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			 */
 			pr_drop_req(req, ntohs(tcp_hdr(skb)->source),
 				    rsk_ops->family);
+			SKB_DR_SET(reason, TCP_REQQFULLDROP);
 			goto drop_and_release;
 		}
 
@@ -7006,7 +7010,8 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 drop_and_free:
 	__reqsk_free(req);
 drop:
+	kfree_skb_reason(skb, reason);
 	tcp_listendrop(sk);
-	return 0;
+	return 1;
 }
 EXPORT_SYMBOL(tcp_conn_request);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 157265aecbed..b8daf49f54a5 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1470,7 +1470,8 @@ int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 
 drop:
 	tcp_listendrop(sk);
-	return 0;
+	kfree_skb_reason(skb, SKB_DROP_REASON_IP_INADDRERRORS);
+	return 1;
 }
 EXPORT_SYMBOL(tcp_v4_conn_request);
 
-- 
2.36.0

