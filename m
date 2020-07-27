Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855C922E47E
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgG0DiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgG0DiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 23:38:18 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AFDC0619D2;
        Sun, 26 Jul 2020 20:38:17 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so14113762qkg.5;
        Sun, 26 Jul 2020 20:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=etLf3Qn1GJEodKzGEq3nxMs1IMFUoiG9sg8M9d7JnV4=;
        b=CkvS5gu/Lr8B83R0V8/zwVhIzLRJrowpw7HuoZugZsPcASH7CkE4mMqHwQWnE0Qx5S
         fkOSpJAOiA8nGaw+2wImo259XKiFIqtCwzUF6CgDzeNx+VAiHgAzFoNVpMhXCp+V46yX
         VFBiHpibs3xPNiaAKK8qWgWsIcDNFFRpaM2u40FnKJISIbMgeknCb74fdRfCzbLHACBl
         KxwPrsl4dxW/eDr/YW7XBjKP/SiCFT3wEhjHvfwVfMCDFSK11WAi9vY3wvEEPoYW1ZMa
         B/YyjEWDesl9JXSCsIJA2ErwD0R2YvHX7rEOrQmy/a0UhkSU27WHHm+vJt2ziH4pEFhD
         vexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=etLf3Qn1GJEodKzGEq3nxMs1IMFUoiG9sg8M9d7JnV4=;
        b=IYb6fel7gzmI+FVhho0UFKk/HT/SzFWpuYLpZAF3kbMOIlqFQ6DqwsSaZ/uaC9h1Kl
         dHUSc+SBZwitUjxCy0MqHpNmmn0xHXHpQk5W9xZkoKVbuywTJaLM7tRX/3cDy46Ibdnt
         hLe2ecL+z13GwbvUd3MpgUh9g0z26TBIAwvgAiNiXHZWia9m1THxKOe6z4kxl7i8RO6b
         Rx78lVEMdOlQwTsQEGkaTFuLMbZKs6M0Q/GnRiDhCu6P944mL5OuZCVYB5B0ITyZZXXc
         MUKqUMRP/RD/q7l3CSomthA+ih3F/3vonados6FeeLaLIPIAXrqu4Mn1RquuLlXMQE9X
         ftew==
X-Gm-Message-State: AOAM531C1ErASMXt4l1PGYnuVmQy29EHDY2H8LNP4pNaaBeirQZ6G87O
        Ck3gp4gTxtXh1oZZsi27UCM=
X-Google-Smtp-Source: ABdhPJwF7tlwpUsrbb25Ev2QYqbgMSuJJ0ZzpDVymTzyaNoJaB6JocZQfp7ZU/TAY714eh0ABAwJvw==
X-Received: by 2002:a05:620a:5f8:: with SMTP id z24mr16106585qkg.372.1595821096969;
        Sun, 26 Jul 2020 20:38:16 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:9cb8:60da:6bf0:c998])
        by smtp.googlemail.com with ESMTPSA id x29sm13677370qtx.74.2020.07.26.20.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 20:38:16 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/ipv6] ip6_output: Add ipv6_pinfo null check
Date:   Sun, 26 Jul 2020 23:38:10 -0400
Message-Id: <20200727033810.28883-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv6_pinfo is initlialized by inet6_sk() which returns NULL. 
Hence it can cause segmentation fault. Fix this by adding a 
NULL check.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ipv6/ip6_output.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8a8c2d0cfcc8..7c077a6847e4 100644
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
+		ip6_default_np_autolabel(net);
 }
 
 /*
-- 
2.17.1

