Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63BC54F4D6
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381553AbiFQKGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381561AbiFQKGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:06:35 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE5269CF2;
        Fri, 17 Jun 2022 03:06:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s37so3755805pfg.11;
        Fri, 17 Jun 2022 03:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=znh2PNtoibcoEX3lHKZShGCnVxaqXpJ6Xkl88GOSiI4=;
        b=VtZkGBr43CPRYhfMIU8Atai8DQstwXo8C4MuY8b+KkLTvx8xQ0rKyKMFHD0HiS8U9L
         u6xUxRRZN43yVcxkEklaQg0t2fCXqvNlqczMSL7HmSORSUkQufLN9074Gkm9UbXQEfzj
         H9mvO5s/4gn7iSfaoAvhTTFCt0OJKi8hqmMiAUudf6/PtQrLbDtx0m4uKwyUoq7Nkpps
         iTPHKju/xd1B3DeVFNgXVFA7A5xw7q/ZlsEXQiA7ZVj7BhyaBY2wMi2BbrySOjt3XKVd
         aQh7BhKhu4tmGI/ZoHX+m8uSswJ+37sYXCD14GU8YMeYZXC6uZfd9VUEZeZwsp0VLCm1
         KSkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=znh2PNtoibcoEX3lHKZShGCnVxaqXpJ6Xkl88GOSiI4=;
        b=tKfQ8hLuDpU5CKGhsae0SO3lHsu63uH3KQM+PlivroM5yaTmDrCxFUl7OYEdfaSd3s
         LmyIn+iHdhjR23lJcNr5YMi2oEPxUrw+B57b8EuXQuDzk8WNfZGsP3bk4SjaMjla/gLP
         zkfrk581QOa7HQIlx1TBzNUpCbCaz6xNB+N92RrPJI4/GABaMkKVd7Umc0PZFiOY7KNl
         vFTQ5KkEtDNzw0nPT3f/tjlPQmfUxNo8h8qwZKltYZ/L0adO4rsAoa3UkuilOA3NWCW8
         TR9l0D+LAx7WKc+UZnOuaCK4ocKquVcrsmtbVGm4HKx7VRxKPJ5/y3jcew6GbutcYnfL
         D0lQ==
X-Gm-Message-State: AJIora+Tjmf7aJ6Sw+ckLNlerEHJvnXEX+hO4kKJAdRs3nbX0ihO5Cmi
        nqiRrTBJHbVJY/b7c982Ggk=
X-Google-Smtp-Source: AGRyM1uxxtd19Tq/acnbsqEqlXzwX17JOw2no1Ng67/PSXMSIt4TN1bbN3ZsdK9jzga/9wH6NwO24Q==
X-Received: by 2002:a63:f415:0:b0:408:808b:238f with SMTP id g21-20020a63f415000000b00408808b238fmr8237583pgi.469.1655460385742;
        Fri, 17 Jun 2022 03:06:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001621ce92196sm3126210plw.86.2022.06.17.03.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:25 -0700 (PDT)
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
Subject: [PATCH net-next v4 7/8] net: tcp: add skb drop reasons to route_req()
Date:   Fri, 17 Jun 2022 18:05:13 +0800
Message-Id: <20220617100514.7230-8-imagedong@tencent.com>
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
index 90cdb7321926..d3143598125e 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -252,6 +252,8 @@ enum skb_drop_reason {
 	 * 'SYN' packet
 	 */
 	SKB_DROP_REASON_TIMEWAIT,
+	/** @SKB_DROP_REASON_LSM: dropped by LSM */
+	SKB_DROP_REASON_LSM,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1a88fabf0cce..d8895076d448 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2073,7 +2073,8 @@ struct tcp_request_sock_ops {
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
index 8617e7a8f841..ed55616bc2a0 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6945,7 +6945,7 @@ enum skb_drop_reason tcp_conn_request(struct request_sock_ops *rsk_ops,
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
 	inet_rsk(req)->ir_iif = inet_request_bound_dev_if(sk, skb);
 
-	dst = af_ops->route_req(sk, skb, &fl, req);
+	dst = af_ops->route_req(sk, skb, &fl, req, &reason);
 	if (!dst)
 		goto drop_and_free;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f2ed9763d504..8accb49f3808 100644
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
index 9aeb0a7b7c12..fbe37f4a73ee 100644
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

