Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4592D527C86
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbiEPDrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbiEPDqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:46:44 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F47F3615F;
        Sun, 15 May 2022 20:46:15 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d17so13301491plg.0;
        Sun, 15 May 2022 20:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yeNDzboY5WK2Vw5xp0/vzfNC1+1rg+BGw/wBWCV3RIc=;
        b=OQ7Zu8wBT3qHV0GeO/0oqojuv+zgmG4SjthnMj59qDKwITg6luS+UmF8qZvFylBFeo
         KuZCMmJqIaxD7WPtM4KFJGuVvJSRqgfuN+Otv4i1BsUa9OuWJoKqZbKBty62FDjhFs4o
         d6Wz9dqNDNGlpAiHF/433g/uzayKvyYa72HEM9RpC1OWwV6F1430Z6nTxJbkE2x7hx1Y
         o0V9uic44h4DC8aYNmoG8Lg5moQUHfugcz4cCbgevMqMLnQVE6IbGVAWqBbc7YsY2Cje
         w3eaYdqhvu+LAdfxzsLYF/sIaiB9n5FOh1ct4V8yAL7nvqi6Vi9RpUVDuUQMtnZwIWDk
         FC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yeNDzboY5WK2Vw5xp0/vzfNC1+1rg+BGw/wBWCV3RIc=;
        b=EA9bZdV5GKXuPKXcBis73CSvPx6a8cOXauvlUR8W6sb8VDqAC8cp0V/1hUtVyRn96U
         aCkT+k7hJY2jPDsd8wAuzRU1g25+orSZW3WEKbB0J3LT/FV7ttgky/KCAmlVo6WQOdI4
         hLnkyjsvOp66mLSk2g3UsgcYHdz4FB/8boV4P9HUmNfwDivxgdI2IT+WxcsIZEr75Jw1
         hPRjg9Vvo+yd1lFoZb3/Bftjwo3ruQB4cgLCu9TebyIPSCpP0J1gOO0QyUauYr2uJQIA
         mvFQkTlJcM+AivRDf5HKCg4janWYmDbLS0U17WsO+cjMdZ3Kwf1BMK/EwUFVGBj20OHs
         964Q==
X-Gm-Message-State: AOAM531qOyxI7gcuIVxABc9n/TcZV9AdBrVn5WPq3QhfYCeZnw9mJoON
        3J0NqANZTbeYTZPEo0uxDU2jg6uzKY2Wzg==
X-Google-Smtp-Source: ABdhPJwRWTJ6X0JHn96f8T3fvV4L8J1S8AuTAims+2qyg/PCyysaCPVxBBqtykM6cVxd70sY7XZlgw==
X-Received: by 2002:a17:90a:930b:b0:1d5:684b:8e13 with SMTP id p11-20020a17090a930b00b001d5684b8e13mr17291531pjo.153.1652672774652;
        Sun, 15 May 2022 20:46:14 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b0050dc762819bsm5636854pfd.117.2022.05.15.20.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:46:14 -0700 (PDT)
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
Subject: [PATCH net-next 9/9] net: tcp: add skb drop reasons to route_req()
Date:   Mon, 16 May 2022 11:45:19 +0800
Message-Id: <20220516034519.184876-10-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516034519.184876-1-imagedong@tencent.com>
References: <20220516034519.184876-1-imagedong@tencent.com>
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

Add skb drop reasons to the route_req() in struct tcp_request_sock_ops.
Following functions are involved:

  tcp_v4_route_req()
  tcp_v6_route_req()
  subflow_v4_route_req()
  subflow_v6_route_req()

And the new reason SKB_DROP_REASON_LSM is added, which is used when
skb is dropped by LSM.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h |  4 ++++
 include/net/tcp.h      |  3 ++-
 net/ipv4/tcp_input.c   |  2 +-
 net/ipv4/tcp_ipv4.c    | 14 +++++++++++---
 net/ipv6/tcp_ipv6.c    | 14 +++++++++++---
 net/mptcp/subflow.c    | 10 ++++++----
 6 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8d18fc5a5af6..fdfe54dc5ae4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -564,6 +564,9 @@ struct sk_buff;
  * SKB_DROP_REASON_TIMEWAIT
  *	socket is in time-wait state and all packet that received will
  *	be treated as 'drop', except a good 'SYN' packet
+ *
+ * SKB_DROP_REASON_LSM
+ *	dropped by LSM
  */
 #define __DEFINE_SKB_DROP_REASON(FN)	\
 	FN(NOT_SPECIFIED)		\
@@ -636,6 +639,7 @@ struct sk_buff;
 	FN(LISTENOVERFLOWS)		\
 	FN(TCP_REQQFULLDROP)		\
 	FN(TIMEWAIT)			\
+	FN(LSM)				\
 	FN(MAX)
 
 /* The reason of skb drop, which is used in kfree_skb_reason().
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 88217b8d95ac..ed57c331fdeb 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2075,7 +2075,8 @@ struct tcp_request_sock_ops {
 	struct dst_entry *(*route_req)(const struct sock *sk,
 				       struct sk_buff *skb,
 				       struct flowi *fl,
-				       struct request_sock *req);
+				       struct request_sock *req,
+				       enum skb_drop_reason *reason);
 	u32 (*init_seq)(const struct sk_buff *skb);
 	u32 (*init_ts_off)(const struct net *net, const struct sk_buff *skb);
 	int (*send_synack)(const struct sock *sk, struct dst_entry *dst,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index be6275c56b59..146d22b05186 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6950,7 +6950,7 @@ enum skb_drop_reason tcp_conn_request(struct request_sock_ops *rsk_ops,
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
 	inet_rsk(req)->ir_iif = inet_request_bound_dev_if(sk, skb);
 
-	dst = af_ops->route_req(sk, skb, &fl, req);
+	dst = af_ops->route_req(sk, skb, &fl, req, &reason);
 	if (!dst)
 		goto drop_and_free;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 9174ee162633..510664ec2a06 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1423,14 +1423,22 @@ static void tcp_v4_init_req(struct request_sock *req,
 static struct dst_entry *tcp_v4_route_req(const struct sock *sk,
 					  struct sk_buff *skb,
 					  struct flowi *fl,
-					  struct request_sock *req)
+					  struct request_sock *req,
+					  enum skb_drop_reason *reason)
 {
+	struct dst_entry *dst;
+
 	tcp_v4_init_req(req, sk, skb);
 
-	if (security_inet_conn_request(sk, skb, req))
+	if (security_inet_conn_request(sk, skb, req)) {
+		SKB_DR_SET(*reason, LSM);
 		return NULL;
+	}
 
-	return inet_csk_route_req(sk, &fl->u.ip4, req);
+	dst = inet_csk_route_req(sk, &fl->u.ip4, req);
+	if (!dst)
+		SKB_DR_SET(*reason, IP_OUTNOROUTES);
+	return dst;
 }
 
 struct request_sock_ops tcp_request_sock_ops __read_mostly = {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5c777006de3d..7292f60e668a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -802,14 +802,22 @@ static void tcp_v6_init_req(struct request_sock *req,
 static struct dst_entry *tcp_v6_route_req(const struct sock *sk,
 					  struct sk_buff *skb,
 					  struct flowi *fl,
-					  struct request_sock *req)
+					  struct request_sock *req,
+					  enum skb_drop_reason *reason)
 {
+	struct dst_entry *dst;
+
 	tcp_v6_init_req(req, sk, skb);
 
-	if (security_inet_conn_request(sk, skb, req))
+	if (security_inet_conn_request(sk, skb, req)) {
+		SKB_DR_SET(*reason, LSM);
 		return NULL;
+	}
 
-	return inet6_csk_route_req(sk, &fl->u.ip6, req, IPPROTO_TCP);
+	dst = inet6_csk_route_req(sk, &fl->u.ip6, req, IPPROTO_TCP);
+	if (!dst)
+		SKB_DR_SET(*reason, IP_OUTNOROUTES);
+	return dst;
 }
 
 struct request_sock_ops tcp6_request_sock_ops __read_mostly = {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 267f4e47236a..8661d314ec12 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -285,7 +285,8 @@ EXPORT_SYMBOL_GPL(mptcp_subflow_init_cookie_req);
 static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 					      struct sk_buff *skb,
 					      struct flowi *fl,
-					      struct request_sock *req)
+					      struct request_sock *req,
+					      enum skb_drop_reason *reason)
 {
 	struct dst_entry *dst;
 	int err;
@@ -293,7 +294,7 @@ static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 	tcp_rsk(req)->is_mptcp = 1;
 	subflow_init_req(req, sk);
 
-	dst = tcp_request_sock_ipv4_ops.route_req(sk, skb, fl, req);
+	dst = tcp_request_sock_ipv4_ops.route_req(sk, skb, fl, req, reason);
 	if (!dst)
 		return NULL;
 
@@ -311,7 +312,8 @@ static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
 					      struct sk_buff *skb,
 					      struct flowi *fl,
-					      struct request_sock *req)
+					      struct request_sock *req,
+					      enum skb_drop_reason *reason)
 {
 	struct dst_entry *dst;
 	int err;
@@ -319,7 +321,7 @@ static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
 	tcp_rsk(req)->is_mptcp = 1;
 	subflow_init_req(req, sk);
 
-	dst = tcp_request_sock_ipv6_ops.route_req(sk, skb, fl, req);
+	dst = tcp_request_sock_ipv6_ops.route_req(sk, skb, fl, req, reason);
 	if (!dst)
 		return NULL;
 
-- 
2.36.1

