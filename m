Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78607206777
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388516AbgFWWrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388399AbgFWWr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:47:29 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99E7C061799
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:26 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c22so135480qtp.9
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mS3P8oogzGzuqTIC//NqhKoHSkw3I2A8gL4z/i5B+Tg=;
        b=QqwnwuvI6Dh+rk2wequdKD+hs59KmAo5E5ozcMlkF0y9Xp2uwGLWQv6dpguWZcgK5C
         Y1RR17Ec314eKn4bFczu4oXMwDlxrdA0O3O4hZFPdtfCcsLLDpI3dwKFESk7f+m3BeUt
         PD7ytbuL/GWX3IXIp/b/e1IZzleDFO63YSQY2glpsvSGE2E7PsIRbMxV/zCjnKEmt65P
         BQiKXOP3qB/Lklw4DjpXgb/FxuSrSh2TWoz7s3iHUoND4BTY+q2kb7KWJ2Oi8HsMj0aK
         hCSFSchsW41kN3escWpYdH6C2Cj8PzpNrCX8Cq7b3xYO3qt/jd0St9eLR9EfvUpKpQLQ
         Fzfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mS3P8oogzGzuqTIC//NqhKoHSkw3I2A8gL4z/i5B+Tg=;
        b=mYy6RSipvl82c3p528h47GAEIqK2OZdA3J9MclgTihV8b2lxYdFozMT9y7+YfDmU9J
         ExexRgIDwNS+I5T8aU4Phj2Bs4AG83oxDpJ70DMKLjPzMTRm5BiHPvOn9T7cRLoHKCqZ
         ZWkrFWarSTIcxjfbN82smqfOHwfI8GPA0plCqCQA98YQQvwN1W3ToxhMD7Kyv0i40A94
         17L3MHeZE1qmYWh7MoL57df6iY7YVQRzC/BmtKfEwvHvR7uPPV3VN9kgYTNY2vD7D3Vo
         jcAZxEP+1JVUZLcYXfCm9+XrorupffntmlcWuKshMd0vW693vATL4HikjyoNSJmPLZkY
         mNjQ==
X-Gm-Message-State: AOAM530cASXsuZVbRdxtFWF+o0XMAepczHG4FloDsK970hL9WXAp/Hok
        pY5KenCJQjPLfowFGtz7yWOXfnNLAVrW0g==
X-Google-Smtp-Source: ABdhPJxyCtMjlGLkXrYKefL/I+aIHwu8cO+qw4HcQggofxLusBBIVuosWRgognvF6OM4XayemeYJlDxyWwmZtg==
X-Received: by 2002:a0c:ed2b:: with SMTP id u11mr10688104qvq.45.1592951485935;
 Tue, 23 Jun 2020 15:31:25 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:31:13 -0700
In-Reply-To: <20200623223115.152832-1-edumazet@google.com>
Message-Id: <20200623223115.152832-4-edumazet@google.com>
Mime-Version: 1.0
References: <20200623223115.152832-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 3/5] tcp: move ipv4_specific to tcp include file
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Declare ipv4_specific once, in tcp.h were it belongs.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h       | 2 ++
 include/net/transp_v6.h | 3 ---
 net/mptcp/protocol.h    | 2 --
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e6920ae0765cc54570059d0a1aa43dba4e74c511..b0f0f93c681c1744560fd229569b59edb1eb20ee 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -907,6 +907,8 @@ static inline void tcp_skb_bpf_redirect_clear(struct sk_buff *skb)
 	TCP_SKB_CB(skb)->bpf.sk_redir = NULL;
 }
 
+extern const struct inet_connection_sock_af_ops ipv4_specific;
+
 #if IS_ENABLED(CONFIG_IPV6)
 /* This is the variant of inet6_iif() that must be used by TCP,
  * as TCP moves IP6CB into a different location in skb->cb[]
diff --git a/include/net/transp_v6.h b/include/net/transp_v6.h
index a8f6020f1196edc9940cbb6c605a06279db4fd36..da06613c9603a215902a3057ff327b878c1fe953 100644
--- a/include/net/transp_v6.h
+++ b/include/net/transp_v6.h
@@ -56,9 +56,6 @@ ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp, __u16 srcp,
 
 #define LOOPBACK4_IPV6 cpu_to_be32(0x7f000006)
 
-/* address family specific functions */
-extern const struct inet_connection_sock_af_ops ipv4_specific;
-
 void inet6_destroy_sock(struct sock *sk);
 
 #define IPV6_SEQ_DGRAM_HEADER					       \
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d4294b6d23e4de3ac5551f8b9ec781cf07c8081d..06661781c9afbecce7a19f08afeb8bed8e4ff453 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -354,8 +354,6 @@ static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 	inet_csk(sk)->icsk_af_ops = ctx->icsk_af_ops;
 }
 
-extern const struct inet_connection_sock_af_ops ipv4_specific;
-
 void mptcp_proto_init(void);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 int mptcp_proto_v6_init(void);
-- 
2.27.0.111.gc72c7da667-goog

