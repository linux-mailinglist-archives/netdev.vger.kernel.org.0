Return-Path: <netdev+bounces-1748-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E59446FF0AC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD7371C20EE8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F3119BBF;
	Thu, 11 May 2023 11:47:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD73365B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:47:52 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681718A52
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:47:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9dcfade347so15378552276.2
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683805670; x=1686397670;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cla7gPoGlUWeIeI/k3kq+qC+ZyHr3vzZKZvbFPnGSQk=;
        b=mshOMkHOwsl3JcMJN/HhCGwxABR35rmyY6Tb9CMIZwSTNcQxZ6TvDxrtKlcXIqUd2H
         srZcmF9OGQ8AjvAS92fnnuMzk8NINbZaySRETzQec+sySAkJEgXUT5kDekda2/L903bm
         H5yf4aFw2eoKNJjcwhyHJ6s0Tsm4eHaI3lxnynXd17OZvGw5k/CCmZ03GC1xBSWoL8kU
         SpGBnyxRlNato6Knu77VXhuYOmO7x3ARigqf1CD46q8/87VcmLX5Js8NHa2whWPNKvWe
         5IXqL3Zzj3VPDc4EUOpZJnxUgdgVssBmN6Fsxe7XvZQrJUO/dPvAxoMPw40+zkneY9or
         HIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683805670; x=1686397670;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cla7gPoGlUWeIeI/k3kq+qC+ZyHr3vzZKZvbFPnGSQk=;
        b=QFpDMX9oWjPEVdrL6k91B/KrBKZKtz20m+jbAMyx3QGrjROEcC6Wmt5mMBHcNF99+/
         H1P/urUSe1de9XDaNzPxjL3thUdaVSsAGibvhsritZqEtd7y+3kdMIGKD3LI9rW59ZIZ
         Z+8rZUu8HAVHgGYPiBSedCxr3s0r6Bii49JQHfo2tAkDg8xJpvrUJFjpdZo+ZEvEL8IV
         zWY8H5gKV4bYfpolYcD+AKQ9homQ+J40mEEHFlTEeFvyyiZ3jgJ5SgkCBr/7eJGNibmI
         PhrAR7hfYxAuSjT+jIzglpuIs2oy6LIah1T9EAWBUGJuIN0lUNFFgKU2O+cup1WNxnfg
         TFbQ==
X-Gm-Message-State: AC+VfDz5bxLGumcFlgl49MjRPu63ZmfXnNGf0plC3EIWQAG/YXYj82jO
	N7iaUeL/7IprssToO/M4tzbP4buxO9KfHA==
X-Google-Smtp-Source: ACHHUZ4mto7JWaEuVMcS5+ImFzYvn/M9Z6MMrn5FxMfaHQHyeUxh6tijJ07YPPzmgw6NQdqMEJnyqjRv8p6j/w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:161a:b0:b8f:485d:9fcc with SMTP
 id bw26-20020a056902161a00b00b8f485d9fccmr9573286ybb.4.1683805670685; Thu, 11
 May 2023 04:47:50 -0700 (PDT)
Date: Thu, 11 May 2023 11:47:49 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230511114749.712611-1-edumazet@google.com>
Subject: [PATCH net] tcp: fix possible sk_priority leak in tcp_v4_send_reset()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, Antoine Tenart <atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When tcp_v4_send_reset() is called with @sk == NULL,
we do not change ctl_sk->sk_priority, which could have been
set from a prior invocation.

Change tcp_v4_send_reset() to set sk_priority and sk_mark
fields before calling ip_send_unicast_reply().

This means tcp_v4_send_reset() and tcp_v4_send_ack()
no longer have to clear ctl_sk->sk_mark after
their call to ip_send_unicast_reply().

Fixes: f6c0f5d209fa ("tcp: honor SO_PRIORITY in TIME_WAIT state")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 39bda2b1066e1d607a59fb79c6305d0ca30cb28d..06d2573685ca993a3a0a89807f09d7b5c153cc72 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -829,6 +829,9 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
 		xfrm_sk_clone_policy(ctl_sk, sk);
+	} else {
+		ctl_sk->sk_mark = 0;
+		ctl_sk->sk_priority = 0;
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
@@ -836,7 +839,6 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      &arg, arg.iov[0].iov_len,
 			      transmit_time);
 
-	ctl_sk->sk_mark = 0;
 	xfrm_sk_free_policy(ctl_sk);
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
@@ -935,7 +937,6 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			      &arg, arg.iov[0].iov_len,
 			      transmit_time);
 
-	ctl_sk->sk_mark = 0;
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	local_bh_enable();
-- 
2.40.1.521.gf1e218fcd8-goog


