Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56CE23F849
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgHHRHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 13:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHRHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 13:07:01 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECEFC061756;
        Sat,  8 Aug 2020 10:07:00 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id e5so3709842qth.5;
        Sat, 08 Aug 2020 10:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=sxTuf0IwgAfwzDYXePIrkVVlcrBM8hU9HVtBsgATuy8=;
        b=dhTy8dLQSMXrCeaq0dZX4wB66oJi9+P+V5oHbuB3Tg1+SD5/ewJt5zV5lQ7VvOTJqM
         MUt3C+GP+rTpb96vlDVxJrCXtwRHUYi6zTbx3ej0ZullUbRgtY+rTfmBUo/YKq4SZmAG
         y1990eSK4iBV3WB5m7d9SJV+En7CehL4hv47nSvz3rAUfBZeVTcIxQFTk/EZ50xvivGX
         h4M+9Wm14nQQ7ZtOgZwMoIuOx7XCjs4DVq5TdOyCsdvVElPR0U703fu2mUsmRQCfS4Hn
         EjM2hOOTjeFDvnM46Nj3VsfrjnYIjql6EHdnAyWbyR87r09Vxs3UWGlozt21wssQamZr
         lt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=sxTuf0IwgAfwzDYXePIrkVVlcrBM8hU9HVtBsgATuy8=;
        b=P7QZ+zhCo6iH2AYxYWL75pOjCiXo0SdQHnnBmPl0c3fDe9e06MxEW6n10C3E1hNOkz
         oLcx6NwMd6tpLUPg8SwqbZI0g1BeSmGhGz2vXS9f4gFQYL88xH1nxexztvwbONYfnxBX
         iitfO1j7tEoeO5YhM4oLqLUWZrRxRvqjIMnYqtZReSK3VTxMI0IR7aKdC+a+HQN5qZHP
         qGY8/LTUOzx3nzFMw+JRQV8qCpDIzhfGBZfQWnnb0mv//Cyt2pT6pqei6SJySwMtGqrR
         +FkBE9gNM5xLECWodVlT7+yB7pkcvGoqeQmFmBTBJZBFziJ+AM162rB4ZaS5cZeY2kD7
         NgQg==
X-Gm-Message-State: AOAM532xbaCjMlE1BhC94cab/sSAvEKLJ41IzFg3ucLGkaNEa3SuaBlF
        JiMiiU7prkHSDv91Pvhu64y/nywEXyOJJQ==
X-Google-Smtp-Source: ABdhPJz04tCjTQ3wjSouE8zvu0D3XAlfiBx7eCMJnMnfqVrr0+Q0wLVX+FHOt3hAOcrJff0FeF/O/A==
X-Received: by 2002:ac8:7455:: with SMTP id h21mr19833129qtr.201.1596906420079;
        Sat, 08 Aug 2020 10:07:00 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:d81:1efe:2043:bb12])
        by smtp.googlemail.com with ESMTPSA id m15sm11432122qta.6.2020.08.08.10.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 10:06:59 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, Shaohua Li <shli@fb.com>,
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/ipv6] ip6_output: Add ipv6_pinfo null check
Date:   Sat,  8 Aug 2020 13:06:52 -0400
Message-Id: <20200808170653.8515-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728021348.4116-1-gaurav1086@gmail.com>
References: <20200728021348.4116-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This PR fixes a possible segmentation violation.

In function: ip6_xmit(), we have
const struct ipv6_pinfo *np = inet6_sk(sk); which returns NULL
unconditionally (regardless sk being  NULL or not).

In include/linux/ipv6.h:

static inline struct ipv6_pinfo * inet6_sk(const struct sock *__sk)
{
    return NULL;
}

Further down the function, there's a check:
if (np) hlimit = hp->htop_limit

Thereafter, we have a call
ip6_flow_hdr(hdr, tclass, ip6_make_flowlabel(net, skb, fl6->flowlabel,
ip6_autoflowlabel(net, np), fl6));

Hence np = NULL gets passed in
the function ip6_autoflowlabel() that accesses np without check which
may cause a segment violation.

Fixes: 513674b5a2c9c ("net: reevalulate autoflowlabel setting after sysctl setting")

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ipv6/ip6_output.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8a8c2d0cfcc8..94a07c9bd925 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -181,10 +181,10 @@ int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 bool ip6_autoflowlabel(struct net *net, const struct ipv6_pinfo *np)
 {
-	if (!np->autoflowlabel_set)
-		return ip6_default_np_autolabel(net);
-	else
+	if (np && np->autoflowlabel_set)
 		return np->autoflowlabel;
+	else
+		return ip6_default_np_autolabel(net);
 }
 
 /*
-- 
2.17.1

