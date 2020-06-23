Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A5220677E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388576AbgFWWrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388295AbgFWWr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:47:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413D0C061798
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s9so144819ybj.18
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8w8h1TJxiIsNRoOFAc2ZCILf+Sofq5BkxItU8zu0EY0=;
        b=vYWKCe/km0g8jn9mlGwf8qpR+4Zazkh1oWWYoPzPcbqPsb08at1/tee85awUr4toOg
         sLJ00Kut9FoNcYiNqWTaGyzsp6oR0WmgdSt9kFhuFOSEM3q3gqECbDpq8F9MeP+CgrHa
         mHXDnurxETtymPLGdEL2fV0N5ze4sICL9jViz2vPxIpwqMo7NYk4E8+SiFNWD6M0S0s+
         DCH5SlknlA31obzF8XXBWztdmuiBZGQhy7ZwJm/lTVHK50pcHLmvLfytEeytZ9eXKyLP
         dVm9e+Kr/i5JArive0R58adkMckiBrleR4l6huar/2heiMNRK3hyb3E7g0ls3AZUnHJR
         BQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8w8h1TJxiIsNRoOFAc2ZCILf+Sofq5BkxItU8zu0EY0=;
        b=nM9nObNjSIy2zdDIM9UFFSNhnr1R2V/Yv2YDkx99jM3W5EB733hJQKKzNx6RQSf9l0
         MvBGdBGTMhbWAUz2O7j71wK0+QE+KvNQbO02eAj+5XMXd6ZxTDEEmyYPV9fXtCfuvtZz
         wyJw1GvKPeIHpeML5LCnJlNpsdCE5pg/ZQythgWkXBlLLwM/VPIepDxLHeaTFvsXyFUG
         5WVs39KAlEyPVE+QwYiCedl5OOuyu9t1LpLVWY1W5m4eyuZm0hnyjI2tOMMEo6U9OMwO
         ky+6K55tYiXb9hd6a0uuF2WubP30tu/qSg7/WI2AWAdO3JJ7BByZIz2BQG0GKCP2bPwl
         uIFA==
X-Gm-Message-State: AOAM53290NqcOUI2gaE/q7gu/X2aCp9eltaCgVejwFQFtUrujk1gNKiH
        wNe8zt/+nsUsjtOM48ZDxIv2t1UZh6Nhag==
X-Google-Smtp-Source: ABdhPJw0bz8F6XB3g6hpVDFXqfjWzkdKvZvmNx0+pTzV5/B5Y1m8g6Rnn/+sNq6axL4tkYVLBG095fjp3B45TQ==
X-Received: by 2002:a25:98c7:: with SMTP id m7mr36459663ybo.369.1592951483515;
 Tue, 23 Jun 2020 15:31:23 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:31:12 -0700
In-Reply-To: <20200623223115.152832-1-edumazet@google.com>
Message-Id: <20200623223115.152832-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200623223115.152832-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 2/5] tcp: move ipv6_specific declaration to remove a warning
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

ipv6_specific should be declared in tcp include files,
not mptcp.

This removes the following warning :
  CHECK   net/ipv6/tcp_ipv6.c
net/ipv6/tcp_ipv6.c:78:42: warning: symbol 'ipv6_specific' was not declared. Should it be static?

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h    | 2 ++
 net/mptcp/protocol.h | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a8c36fa886a48bb3a242d0360a581b2aba49756b..e6920ae0765cc54570059d0a1aa43dba4e74c511 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -933,6 +933,8 @@ static inline int tcp_v6_sdif(const struct sk_buff *skb)
 	return 0;
 }
 
+extern const struct inet_connection_sock_af_ops ipv6_specific;
+
 INDIRECT_CALLABLE_DECLARE(void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb));
 INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *skb));
 INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *skb));
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index db56535dfc29c7011d94ac5c2cede985b8fc063c..d4294b6d23e4de3ac5551f8b9ec781cf07c8081d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -355,9 +355,6 @@ static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 }
 
 extern const struct inet_connection_sock_af_ops ipv4_specific;
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-extern const struct inet_connection_sock_af_ops ipv6_specific;
-#endif
 
 void mptcp_proto_init(void);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-- 
2.27.0.111.gc72c7da667-goog

