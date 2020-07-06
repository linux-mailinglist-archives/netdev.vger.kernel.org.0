Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCB62156F2
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgGFMCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgGFMCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:02:04 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A792C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:02:04 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u185so14842347pfu.1
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=0kOmIvSpsbsdomZpb4Ki09QtlhTxJVR8Wr0kBKqGeaI=;
        b=suTmGWmso3ZnyVoQxIMkHK8O7TkwGlXMcrYSal3fwCWXQ1RcyhfsH6LrVxwSAOXbDG
         peC7k07ObyLakhuTX5M2tIiZ3R0hn2XO+itN5u+fcEPHeadX8jhMT92CuqJCkNGZxKG8
         b353B4ZxBKA0IMcpG5oZN/DL30xn6kgLHGKZ5lm5gSFBjJbIwnhf2E32+/w/8Z7c3Wud
         VenESooLNf3tMSNYWWzJddqp1wSOx6znPVLJVNRNumVcG9jzlTK4sSGicK3OcpZccCAf
         PWoiHjCwTUmz/VJCQYwPQzwB6uQxHqk+qjPfgOPfaBs9L9+wBTX8Amm3abDp56PPPJJT
         0wfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=0kOmIvSpsbsdomZpb4Ki09QtlhTxJVR8Wr0kBKqGeaI=;
        b=oKj34qnmKoZQU5ahrjsO5/hNYpyJpwJ/H8FKnLXWy/zUxL92r0J83hjKAV//M8uIfO
         T/SQOWf+D14CQQ5VrcVibOZdJKzFE44vO73GJgXXy22qW9rBjF/4c4XYZqnoawZV27aQ
         577z1z6bEsEM+Xz042PM9sEHHEP8zOvBgtMVlpkWigciX113KOAQ91RZnVUPYHWc49aZ
         LKV2fxT83kBpsQx9a92injhcKIMrXoTGNiVcAXETSi3GQ4FEW3Cv314UfBUkPAIJEypU
         sy7UU+/xGq04oYz87pqlkNqxQYKUr8QO6fHBojQGJwS3/E7Xhd5eSswVtCmt2mz0aKhu
         IrZQ==
X-Gm-Message-State: AOAM532H4ov/GdVwPPJL4NYQLdkwXUwjDOYrpJ+pE7TY27uYxujPwCYK
        0L7nlUaK9s6Qy8q5BDs1Xrb+9knNZgk=
X-Google-Smtp-Source: ABdhPJx4Yq3eCCqmy7Hj/Lq8OwY011+ncBNWZc5SK8lSVs/OqbNRHKDERVUqmNbEW0GoaHxQRK8ThA==
X-Received: by 2002:a65:63c8:: with SMTP id n8mr39952356pgv.232.1594036923520;
        Mon, 06 Jul 2020 05:02:03 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id my9sm18987993pjb.44.2020.07.06.05.02.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:02:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 02/10] tunnel4: add cb_handler to struct xfrm_tunnel
Date:   Mon,  6 Jul 2020 20:01:30 +0800
Message-Id: <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
 <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to register a callback function tunnel4_rcv_cb with
is_ipip set in a xfrm_input_afinfo object for tunnel4 and tunnel64.

It will be called by xfrm_rcv_cb() from xfrm_input() when family
is AF_INET and proto is IPPROTO_IPIP or IPPROTO_IPV6.

v1->v2:
  - Fix a sparse warning caused by the missing "__rcu", as Jakub
    noticed.
  - Handle the err returned by xfrm_input_register_afinfo() in
    tunnel4_init/fini(), as Sabrina noticed.
v2->v3:
  - Add "#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)" to fix the build error
    when xfrm is disabled, reported by kbuild test robot.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/xfrm.h |  1 +
 net/ipv4/tunnel4.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 4666bc9..c1ec629 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1416,6 +1416,7 @@ struct xfrm6_protocol {
 /* XFRM tunnel handlers.  */
 struct xfrm_tunnel {
 	int (*handler)(struct sk_buff *skb);
+	int (*cb_handler)(struct sk_buff *skb, int err);
 	int (*err_handler)(struct sk_buff *skb, u32 info);
 
 	struct xfrm_tunnel __rcu *next;
diff --git a/net/ipv4/tunnel4.c b/net/ipv4/tunnel4.c
index c4b2ccb..e44aaf4 100644
--- a/net/ipv4/tunnel4.c
+++ b/net/ipv4/tunnel4.c
@@ -110,6 +110,33 @@ static int tunnel4_rcv(struct sk_buff *skb)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+static int tunnel4_rcv_cb(struct sk_buff *skb, u8 proto, int err)
+{
+	struct xfrm_tunnel __rcu *head;
+	struct xfrm_tunnel *handler;
+	int ret;
+
+	head = (proto == IPPROTO_IPIP) ? tunnel4_handlers : tunnel64_handlers;
+
+	for_each_tunnel_rcu(head, handler) {
+		if (handler->cb_handler) {
+			ret = handler->cb_handler(skb, err);
+			if (ret <= 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static const struct xfrm_input_afinfo tunnel4_input_afinfo = {
+	.family		=	AF_INET,
+	.is_ipip	=	true,
+	.callback	=	tunnel4_rcv_cb,
+};
+#endif
+
 #if IS_ENABLED(CONFIG_IPV6)
 static int tunnel64_rcv(struct sk_buff *skb)
 {
@@ -231,6 +258,18 @@ static int __init tunnel4_init(void)
 		goto err;
 	}
 #endif
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	if (xfrm_input_register_afinfo(&tunnel4_input_afinfo)) {
+		inet_del_protocol(&tunnel4_protocol, IPPROTO_IPIP);
+#if IS_ENABLED(CONFIG_IPV6)
+		inet_del_protocol(&tunnel64_protocol, IPPROTO_IPV6);
+#endif
+#if IS_ENABLED(CONFIG_MPLS)
+		inet_del_protocol(&tunnelmpls4_protocol, IPPROTO_MPLS);
+#endif
+		goto err;
+	}
+#endif
 	return 0;
 
 err:
@@ -240,6 +279,10 @@ static int __init tunnel4_init(void)
 
 static void __exit tunnel4_fini(void)
 {
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	if (xfrm_input_unregister_afinfo(&tunnel4_input_afinfo))
+		pr_err("tunnel4 close: can't remove input afinfo\n");
+#endif
 #if IS_ENABLED(CONFIG_MPLS)
 	if (inet_del_protocol(&tunnelmpls4_protocol, IPPROTO_MPLS))
 		pr_err("tunnelmpls4 close: can't remove protocol\n");
-- 
2.1.0

