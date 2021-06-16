Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA403A91B2
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhFPGIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhFPGIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:08:23 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3F9C06175F
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 23:06:16 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o21so568815pll.6
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 23:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C+5mGngji0N9N8b5lRIJDDKg882pt9u4nyoigNZv7nA=;
        b=c65inbWJ3nxQidfCSdX05U+vLzkqdrNP6vPGfPlNDut8aXqj5/1YDIXKWyG1nDkXNY
         xDbxy66nY+eq1VBMJTfy+9kUFtG69BOFjjv50zVh9cVdZRhTL9xp/L/+xHdRHYfY5PmC
         O7J7/bqudOS+rqfDSMgTuyXCkz2N2q1lrYwDeXLmSfx9w8kyRZQXaAPGLBUE4YivIVYh
         n3+qIIbL5+Z4nSVgTAgTv6R4bbUhaR/PhKeNbbedy2sj9sLcerxjDzbVgBvUMxuNF5f4
         5wH7yKsQ1YP8wZyJg4doT3zJCYcrkup2GUZB04mB1vWVY7TU3HH/QcCZcOwn4v9TtWmW
         ovmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C+5mGngji0N9N8b5lRIJDDKg882pt9u4nyoigNZv7nA=;
        b=FkbLwhnul+q1cpy9yLVjQx/sGaihdH9HfIGD0FEThsbO77yJb74PYQdyRaILbfarEQ
         ecJR3RbWWdxDnZpszQYlb7aeNYMdHmq7tSpSNWAApIlzusAFyXC8B7IzHnX8jNgzvfD6
         q+QqeVJLUlk71QQsLBiWwbVeEeYAMiK6J6qQxM5j08fU5syRePHRGur3O9PZHteZZuB6
         076iaxIBXjOKqjSilvC09bZFvBz5p9gY49tRQOd02RELRvlGzf6g9szU7qbaN1IGyOp2
         8r0syTDIWNbX0cnOQn88reJS0eJqhC5+XdsnfrEBXQf6C+BO5RiEEJJupML8Z+LtY1Ib
         8rTg==
X-Gm-Message-State: AOAM5325n329k09Z0QxtMObhf/RCAdC5ndEd9W0v+twHi+fhb5kizcoZ
        jsQv3eeaVYnHhHaPuVaF4DM=
X-Google-Smtp-Source: ABdhPJwGobKGzmn8iGy5iruWGAa00D1ntpsLasjigOwqips3F9Znr2tMVHsLlf5/ik3JcLepjRubJg==
X-Received: by 2002:a17:90a:f16:: with SMTP id 22mr8930657pjy.38.1623823576236;
        Tue, 15 Jun 2021 23:06:16 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:26ac:32c5:5579:7d13])
        by smtp.gmail.com with ESMTPSA id s24sm895974pfh.104.2021.06.15.23.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 23:06:15 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        "David S . Miller " <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jon Maxwell <jmaxwell37@gmail.com>
Subject: [PATCH] inet_diag: add support for tw_mark
Date:   Tue, 15 Jun 2021 23:06:04 -0700
Message-Id: <20210616060604.3639340-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Timewait sockets have included mark since approx 4.18.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Jon Maxwell <jmaxwell37@gmail.com>
Fixes: 00483690552c ("tcp: Add mark for TIMEWAIT sockets")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv4/inet_diag.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 93474b1bea4e..e65f4ef024a4 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -416,7 +416,7 @@ EXPORT_SYMBOL_GPL(inet_sk_diag_fill);
 static int inet_twsk_diag_fill(struct sock *sk,
 			       struct sk_buff *skb,
 			       struct netlink_callback *cb,
-			       u16 nlmsg_flags)
+			       u16 nlmsg_flags, bool net_admin)
 {
 	struct inet_timewait_sock *tw = inet_twsk(sk);
 	struct inet_diag_msg *r;
@@ -444,6 +444,12 @@ static int inet_twsk_diag_fill(struct sock *sk,
 	r->idiag_uid	      = 0;
 	r->idiag_inode	      = 0;
 
+	if (net_admin && nla_put_u32(skb, INET_DIAG_MARK,
+				     tw->tw_mark)) {
+		nlmsg_cancel(skb, nlh);
+		return -EMSGSIZE;
+	}
+
 	nlmsg_end(skb, nlh);
 	return 0;
 }
@@ -494,7 +500,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 			u16 nlmsg_flags, bool net_admin)
 {
 	if (sk->sk_state == TCP_TIME_WAIT)
-		return inet_twsk_diag_fill(sk, skb, cb, nlmsg_flags);
+		return inet_twsk_diag_fill(sk, skb, cb, nlmsg_flags, net_admin);
 
 	if (sk->sk_state == TCP_NEW_SYN_RECV)
 		return inet_req_diag_fill(sk, skb, cb, nlmsg_flags, net_admin);
@@ -801,6 +807,8 @@ int inet_diag_bc_sk(const struct nlattr *bc, struct sock *sk)
 		entry.mark = sk->sk_mark;
 	else if (sk->sk_state == TCP_NEW_SYN_RECV)
 		entry.mark = inet_rsk(inet_reqsk(sk))->ir_mark;
+	else if (sk->sk_state == TCP_TIME_WAIT)
+		entry.mark = inet_twsk(sk)->tw_mark;
 	else
 		entry.mark = 0;
 #ifdef CONFIG_SOCK_CGROUP_DATA
-- 
2.32.0.272.g935e593368-goog

