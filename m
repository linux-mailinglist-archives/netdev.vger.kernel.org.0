Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D00B512CFA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245441AbiD1HiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245434AbiD1HiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:38:02 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11AA9BAE6;
        Thu, 28 Apr 2022 00:34:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so3700455pjf.0;
        Thu, 28 Apr 2022 00:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PyeuYNXmzkjWDa6213Nn+RP5RRNEwW8v57e0cAbPzO8=;
        b=MKqpOMM5OpNR68G0XQ6+Jg+AKi0V5VD4npSUgiyfnEm+8O+SkNjJkQaq9OUhTP+UB1
         Jdvruq9j9LxWMB+/mfuG/qrq2EQRI8djaHKbrB6QMnIzAx+H7006ZUiWfHlGfgDXwwE7
         bOzoMZS6UjLc7RHk6sd1pcnbQ+NlUPdGdxxNe/NnzD2GYtD6j0JWKx1P/OE2qx9TEmem
         L1Mk88D9Slhj/RzUYmxhnlMSuuYGxAkVEIKUdC2OPCG84Xrg3mK17js61RLzSFlR0jtH
         29vOxlYDXx+3vjV8oedAVn8LsB1Riu0/YLVfoYltMmgjPsNqPaOtcgD5cjs/LZlnFnpK
         ZOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PyeuYNXmzkjWDa6213Nn+RP5RRNEwW8v57e0cAbPzO8=;
        b=flPfnIVC2+T8JsfErRaxU568aR/YKx4L4jBwafN/sKI31O2Kf5UQuKJs21+HVPCeAw
         5k99VNNn1SMioaqQ1l5acnLT/y10tW/lSAqXqAlU+UGKKq5b7JcyF8E0UJhd6KZcwLOu
         9HqNnbSv7l5bZQQpAAHXW54lRmudZAvjCdFexBkqNcq9tjtH7ltbhG5CARPfOdA1A3FH
         6kYsyJvLfG1K4nX5Lgnb1nOmUr6KzAOVNhbSVZ34wmcSzkTNo15ydSlTNKKCn32D4Pb8
         BiRD+ElHzFQ4MhVXNqQ7PounWPZWaKnQI+qqks6f/xP43yZUcSxy+t9uezEh0w4LnbuB
         aOgg==
X-Gm-Message-State: AOAM530rRFD/T9l51Z1F0WqB3tZQStiTliMx3N4GWk14TlB4dHkybnCk
        SbaOPIk9Tta3JybUjm+3p5Q=
X-Google-Smtp-Source: ABdhPJxOk3oChZeXXTKxJEL/zK2Yj1xBMf2uG+U1f11+mR2yVsn9peH+JTwsi95XNZfzHGZOkcIyIg==
X-Received: by 2002:a17:90b:3742:b0:1d9:5dc6:dede with SMTP id ne2-20020a17090b374200b001d95dc6dedemr24174038pjb.92.1651131288193;
        Thu, 28 Apr 2022 00:34:48 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b004fe3d6c1731sm21369511pfo.175.2022.04.28.00.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 00:34:47 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/2] net: tcp: add skb drop reasons to route_req()
Date:   Thu, 28 Apr 2022 15:33:40 +0800
Message-Id: <20220428073340.224391-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428073340.224391-1-imagedong@tencent.com>
References: <20220428073340.224391-1-imagedong@tencent.com>
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

Add skb drop reasons to the route_req() in struct tcp_request_sock_ops.
Following functions are involved:

  tcp_v4_route_req()
  tcp_v6_route_req()
  subflow_v4_route_req()
  subflow_v6_route_req()

And the new reason SKB_DROP_REASON_SECURITY is added, which is used when
skb is dropped by LSM.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  1 +
 include/net/tcp.h          |  3 ++-
 include/trace/events/skb.h |  1 +
 net/ipv4/tcp_input.c       |  2 +-
 net/ipv4/tcp_ipv4.c        | 14 +++++++++++---
 net/ipv6/tcp_ipv6.c        | 14 +++++++++++---
 net/mptcp/subflow.c        | 10 ++++++----
 7 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f33b3636bbce..5909759e1b95 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -473,6 +473,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_REQQFULLDROP, /* request queue of the listen
 					   * socket is full
 					   */
+	SKB_DROP_REASON_SECURITY,	/* dropped by LSM */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 679b1964d494..01f841611895 100644
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
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index de6c93670437..aff57cd43e85 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -82,6 +82,7 @@
 	EM(SKB_DROP_REASON_PKT_TOO_BIG, PKT_TOO_BIG)		\
 	EM(SKB_DROP_REASON_LISTENOVERFLOWS, LISTENOVERFLOWS)	\
 	EM(SKB_DROP_REASON_TCP_REQQFULLDROP, TCP_REQQFULLDROP)	\
+	EM(SKB_DROP_REASON_SECURITY, SECURITY)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 412367b7dfd6..e55340059c19 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6932,7 +6932,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
 	inet_rsk(req)->ir_iif = inet_request_bound_dev_if(sk, skb);
 
-	dst = af_ops->route_req(sk, skb, &fl, req);
+	dst = af_ops->route_req(sk, skb, &fl, req, &reason);
 	if (!dst)
 		goto drop_and_free;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6a49470d30db..0ae55c9e8428 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1424,14 +1424,22 @@ static void tcp_v4_init_req(struct request_sock *req,
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
+		SKB_DR_SET(*reason, SECURITY);
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
index 92f4a58fdc2c..d1f9266a81ed 100644
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
+		SKB_DR_SET(*reason, SECURITY);
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
index aba260f547da..03d07165cda6 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -283,7 +283,8 @@ EXPORT_SYMBOL_GPL(mptcp_subflow_init_cookie_req);
 static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 					      struct sk_buff *skb,
 					      struct flowi *fl,
-					      struct request_sock *req)
+					      struct request_sock *req,
+					      enum skb_drop_reason *reason)
 {
 	struct dst_entry *dst;
 	int err;
@@ -291,7 +292,7 @@ static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 	tcp_rsk(req)->is_mptcp = 1;
 	subflow_init_req(req, sk);
 
-	dst = tcp_request_sock_ipv4_ops.route_req(sk, skb, fl, req);
+	dst = tcp_request_sock_ipv4_ops.route_req(sk, skb, fl, req, reason);
 	if (!dst)
 		return NULL;
 
@@ -309,7 +310,8 @@ static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
 					      struct sk_buff *skb,
 					      struct flowi *fl,
-					      struct request_sock *req)
+					      struct request_sock *req,
+					      enum skb_drop_reason *reason)
 {
 	struct dst_entry *dst;
 	int err;
@@ -317,7 +319,7 @@ static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
 	tcp_rsk(req)->is_mptcp = 1;
 	subflow_init_req(req, sk);
 
-	dst = tcp_request_sock_ipv6_ops.route_req(sk, skb, fl, req);
+	dst = tcp_request_sock_ipv6_ops.route_req(sk, skb, fl, req, reason);
 	if (!dst)
 		return NULL;
 
-- 
2.36.0

