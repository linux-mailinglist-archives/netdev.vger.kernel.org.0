Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4641A50F364
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344482AbiDZILD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344467AbiDZILB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:11:01 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6861748E50;
        Tue, 26 Apr 2022 01:07:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d15so15063231plh.2;
        Tue, 26 Apr 2022 01:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=to+ZeGhLxQcAid0Ufscg8bv/YvTBm1/R7BRG+txDPzM=;
        b=SxQSXbCWPSYBlG3D1ymX4EnX3akJzKF1gfr3UwRqJCQSH5xVMvHQUVX/8ar5HI4N2B
         7g92iGNC6M7i/l8cKOpoPrEDSSc8O058UCKivXYCWWWuwPO6F7Tm2Yjr+e75A6lQfx8c
         2b3V8DWUaY4oqyT/Vyd2Jjz/m/BvBoOGOpKtYGJPeoscac686fvSOyUaMhkBDS8Q/YAY
         Az66+HrcTzCLdPZB7yJXXlcmG+olgHvSRbTRaB/5qg6WXI5PJqGdv+xqfgo3WOSCgAua
         un1QKL9xJ02q9NZ3W0rqgYDYonhaaBCNXTqqpcpg/SIG65qhrQGr0y7H0jj6ZV2emcUw
         Uivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=to+ZeGhLxQcAid0Ufscg8bv/YvTBm1/R7BRG+txDPzM=;
        b=5ckMHO6Hn+bgk/2OpOJZ1OAcR9pdmW7xoSEeXzMMkQNuzJuQJUhxwvc/ZRJEZrjkAO
         +VP3EE/cF6SJGJ4WHAC5NiL7K9LvEW7O7S98LIIrDoFNtVS7RhwVB5YlOSk2KW2JZyRP
         +4CIM9ahsjWxuw3v50RTgO/lb45AJyhZqzs4NDrNfs7kq2dnDg0aC6DS+ttPEqvXDgD0
         v+JukmjrI9Gjtf31E1pKWMbqhZg3pZya18lEhtuaHnBXXyHWVJsBcZ4oFbQDbAddomhX
         oY9L8R6xBMkp4TVr8No+A6tjRQNB8GXj0jVaMru3YWQ6WI/QutogbGJeO7xIGGJGdktc
         g4MQ==
X-Gm-Message-State: AOAM530cdKLL9D4PvTDIiwjF9XEU2gK9M4Dqe+w+hZvgaQeAt6kX84cG
        j2+JxsZEmJVqAQGnUaihA28=
X-Google-Smtp-Source: ABdhPJwE5FdzKKcQmRuv2uacm4y/xT6q2GjcUORzi1wkxmdqNmAR0tZSEAI/JZRZ+qYtuUmtMtXA7w==
X-Received: by 2002:a17:902:9696:b0:158:f809:310e with SMTP id n22-20020a170902969600b00158f809310emr22626342plp.16.1650960465953;
        Tue, 26 Apr 2022 01:07:45 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l4-20020a056a0016c400b004f79504ef9csm15134951pfc.3.2022.04.26.01.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 01:07:45 -0700 (PDT)
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
Subject: [PATCH net-next 2/2] net: tcp: add skb drop reasons to route_req()
Date:   Tue, 26 Apr 2022 16:07:09 +0800
Message-Id: <20220426080709.6504-3-imagedong@tencent.com>
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
index e0bbbd624246..2c158593dc37 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6928,7 +6928,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
 	inet_rsk(req)->ir_iif = inet_request_bound_dev_if(sk, skb);
 
-	dst = af_ops->route_req(sk, skb, &fl, req);
+	dst = af_ops->route_req(sk, skb, &fl, req, &reason);
 	if (!dst)
 		goto drop_and_free;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b8daf49f54a5..12acf4823488 100644
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
index 782df529ff69..d69fef0e0892 100644
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

