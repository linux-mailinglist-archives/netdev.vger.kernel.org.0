Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCBE545ACE
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243434AbiFJDpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242784AbiFJDpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:45:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C873855AF;
        Thu,  9 Jun 2022 20:45:17 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 15so22785363pfy.3;
        Thu, 09 Jun 2022 20:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pRW3FoHzxLV8iUKBg+b4ZvgQlcZOw3/hF/44ndmTPhg=;
        b=p8bilP2t5OfGnS9KPCoQGUQzjUcLlKrIXTYWkpkq1A+YZZhPcUB1BOHAUinwoOPEWK
         K9Il89qxcxl0Sds6dvpGFgZttjeNkIPvPM2zeSgErJ4DGCbe7jLQWw+BsLwjSo1kpE3D
         9CHVTnlRkUm8Ewip2E1M9kYUV0L0W/adOVBI8/fnxrcqVdnn/0/k88TfggygRFxAl55w
         49P1XYTGCteXyAbyYy01EKBoQypk7pq/JzRZdQ2pXQq8q9xmx1U/01YWfTlI/BWfS8cN
         iTieFkUrZAcyXaCo8iMI55Xp0Idx+bx5lO/LpN7ewoMv2bODnOYtg8W5wtpPyqL6HC1f
         cUZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pRW3FoHzxLV8iUKBg+b4ZvgQlcZOw3/hF/44ndmTPhg=;
        b=29SRViQKssMQlsvuFd+hNWXK8841MAMcxSQhjAoFhbM45VTcNk2i3bGHamts9Hl2Hp
         +fPeFK61imkC3nILVPNXTWPnt4tBJerznRJX/C7O4vb8MBNcvhdLxRKN4oDHDZ/f2ggA
         8vB01warxLdBV6IV7uOBi0+B5FEGVDdwVAimbMtOaWCgdzo2eOnvG+bJ2ZANKS7AFy4U
         XInBc1hT45Ij505WPVi3bnSY2B0fiMo4bUAq2F314togrV9EXg85PQrpZWWwhj27EGHa
         s3+qxSslGuC/gHMWdgpWpD5bSiLarBoOBvT+LBmm+uZU6mR8MO8/pLTPQlFsUDoTdpEP
         YeQQ==
X-Gm-Message-State: AOAM532YdUpYdG/MvtkZ3RZYO5zfc5L36xUOQrVQe6zLLSks9t7HB5nC
        AgSz8w2T/kzPHLyKRr5t4JY=
X-Google-Smtp-Source: ABdhPJyXD/B8ma0QjaCZbDnxbwwybO5N9u0bRbQmdHFXvdb7neZwjymTGxa2+aOzAqi8rT3vS1+Akw==
X-Received: by 2002:a63:6806:0:b0:3fc:3b43:52d5 with SMTP id d6-20020a636806000000b003fc3b4352d5mr37802325pgc.319.1654832717101;
        Thu, 09 Jun 2022 20:45:17 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:45:16 -0700 (PDT)
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
Subject: [PATCH net-next v3 8/9] net: tcp: add skb drop reasons to route_req()
Date:   Fri, 10 Jun 2022 11:42:03 +0800
Message-Id: <20220610034204.67901-9-imagedong@tencent.com>
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
 include/net/dropreason.h |  2 ++
 include/net/tcp.h        |  3 ++-
 net/ipv4/tcp_input.c     |  2 +-
 net/ipv4/tcp_ipv4.c      | 14 +++++++++++---
 net/ipv6/tcp_ipv6.c      | 14 +++++++++++---
 net/mptcp/subflow.c      | 10 ++++++----
 6 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 3c6f8e0f7f16..22e9299e4bfe 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -264,6 +264,8 @@ enum skb_drop_reason {
 	 * 'SYN' packet
 	 */
 	SKB_DROP_REASON_TIMEWAIT,
+	/** @SKB_DROP_REASON_LSM: dropped by LSM */
+	SKB_DROP_REASON_LSM,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
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
index 6f7dd2564b9b..9b9247b34a6c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6957,7 +6957,7 @@ enum skb_drop_reason tcp_conn_request(struct request_sock_ops *rsk_ops,
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
 	inet_rsk(req)->ir_iif = inet_request_bound_dev_if(sk, skb);
 
-	dst = af_ops->route_req(sk, skb, &fl, req);
+	dst = af_ops->route_req(sk, skb, &fl, req, &reason);
 	if (!dst)
 		goto drop_and_free;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e7bd2f410a4a..dcaf2bac4f55 100644
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
index 41551a3b679b..6e2d67238e11 100644
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
index 5a1d05c3a1ef..654cc602ff2c 100644
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

