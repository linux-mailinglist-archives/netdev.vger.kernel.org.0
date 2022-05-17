Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07F5529C03
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242801AbiEQIOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242921AbiEQIN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:13:26 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9F496A7;
        Tue, 17 May 2022 01:12:27 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ev18so6059869pjb.4;
        Tue, 17 May 2022 01:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tsqLBQjRtgnyo1sQei1gpb0K6REi5TaI3JgfHkJY/jQ=;
        b=jhHbxV5PpwiIzUsl2mEJKAtp4rc/vpdVks3HnKGxskvQ81EvZZY9jc2isPtK9Ih8Kk
         YZy+55f6/VcQ7fEyOmjQBRlhPTr14K6auWTS/pBnarwEDMTgfSv4Iii5L4UDs1JOa5bq
         LUT6h05vSlMuupWQY/9Zi950i/pUqxREDexrUALt7KWbCGMmA8it7uJgO+Y2nfxFEmkd
         BJxiINsvNODG072jTl9xZYUVHOseXmKrVlTW+G3Uo18yWdKqRRmBtrINAZqyMZIjZfou
         NPrBqvIMpD3OiGzO7id/0YwU6CuWpeZhTO8wUgl7Fc8vwPaJapQJBck7L+XOM5zbZcAe
         uwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tsqLBQjRtgnyo1sQei1gpb0K6REi5TaI3JgfHkJY/jQ=;
        b=NCLNLU1ssrptsJCrGyhCEw7cq41f+eciM8GMW9AdSD6mA7whWlLXuK+hpFF7e7pL08
         VpmH+Ns/ysNhMP+fNiK1yIJnQ5WHeb8WoqhBGCMWAwZBqxpJ02hf8GomLM9seuEAUDEr
         rh+1OXozTIADKpzTt7Pcs7mfm04dIsSULJhldG2tSLEczm++5WwcZ0liXOwlScnTcyNJ
         aItHSBw8neCYq3x8SbAcwzvDeUT9U3a/dAV/MT3aYWWJTyLkk8LH8XD2TjJJTY+pHfQM
         gWPe2q6qgAV45ExCLgATapTim/8WPXWI65TT7e26KmJODTUtHmDyCvvll9U4kN8fsVVq
         JT0w==
X-Gm-Message-State: AOAM531ml0n80RzVFsroHmbbHEsYB3ZvQfUa6KoVtX+shinHdqX09urZ
        lnTVNnV4VnYN8uL7wircURw=
X-Google-Smtp-Source: ABdhPJwSXMOAdvAnBLa3qRqOZ9uiNSUIzx/t6id6EaaxALCZtKiNRYwDDxXAdmU7keITpCEDDawmNQ==
X-Received: by 2002:a17:90b:1c87:b0:1ca:f4e:4fbe with SMTP id oo7-20020a17090b1c8700b001ca0f4e4fbemr35065639pjb.159.1652775146828;
        Tue, 17 May 2022 01:12:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902c2ce00b0015e8d4eb2easm8336306pla.308.2022.05.17.01.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:12:26 -0700 (PDT)
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
Subject: [PATCH net-next v2 9/9] net: tcp: add skb drop reasons to route_req()
Date:   Tue, 17 May 2022 16:10:08 +0800
Message-Id: <20220517081008.294325-10-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517081008.294325-1-imagedong@tencent.com>
References: <20220517081008.294325-1-imagedong@tencent.com>
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
index 3c163b54b0f8..026a36f1598b 100644
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
index 132b27763229..b859adcde756 100644
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
index 58c1f056213b..db7e6cd96d44 100644
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

