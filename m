Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4279E4AE6B8
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 03:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242813AbiBICkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 21:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245267AbiBICau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 21:30:50 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0BAC0613CC;
        Tue,  8 Feb 2022 18:30:48 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z35so1792122pfw.2;
        Tue, 08 Feb 2022 18:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mD1SnWz+mm28COwt82p3ZgG8djCP25vnBK0i9FocLYY=;
        b=U6XLe6hzqgsDhZgqdKyLFCHOHgRoghXVUG8AfW7ef4as6vSakuKfNbtrK5UAyqVouA
         QIgkX0ngURoZFqQnnRH1A8N8QFLMKaq2kAiYUG6ysU8TBN6cUc95WU69M2XGNw222sAQ
         i+cnC8qGhocVfiZsQDEpzKvpnICOfEg5kRmOIvWv6/CZsyXcgBQSexXAaTgiVThE9320
         lpyXNc/1OKFDpPvDBMbk4+Os1IDbUND7jzxnNgseg6XK7VaAuvysN2S99aWMBTJzIN98
         Tr9huh5CQXkzB9aavMeIvs8mcwSAmUPgMDpJ8rmMYRU2G/k4Lt+fDMX+2CUytUYepQx9
         iDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mD1SnWz+mm28COwt82p3ZgG8djCP25vnBK0i9FocLYY=;
        b=MWshEMI1MarlSvRE5oXX26AtQzUwcKG4cCfVSH2kWn1kfhyGagJ2eK1fulYqGJV1ML
         8kc6SmGDnv+IelOh50IdyMU4zsQZmO+7onBrLh2MSpHH1QtO6o3LneFXtVVhKmzyykNf
         IGIAVz3ABtuSCdln8Eod71ao7KRwBE5Dj47TszOZYnJyyD4pFCzp52Vyic6vtaoRklGP
         +SCHwvZVxSJ7pTD6AAIoCgvwlvXjjauXYEDvEYdH3o8v3dfK9GMB8+HN1idLo7wsRSeF
         n8ifX2FlnMYcXfLJ6iknKrBd0jja/Bm/WfJFQKdz9etTWAX7QNsp+rwbIQLzer5ImkIl
         ZWqw==
X-Gm-Message-State: AOAM533rKEe6B4XBYj+cUnV5ooFr9HT3Z7Ae3cmMebc90yv+cHgbj3FD
        2zOD3NloykJrCR7sVuYH3Ngzwp7AMPI=
X-Google-Smtp-Source: ABdhPJxjxCschsOyb+AC2m6H7GQ3DFR4CzWd7yRdCAPddgWkqQxPLZdb1QRM7OFvq0IIg73dHHBs+g==
X-Received: by 2002:a65:550a:: with SMTP id f10mr226800pgr.204.1644373847820;
        Tue, 08 Feb 2022 18:30:47 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:18f1:ac55:f426:b85d])
        by smtp.gmail.com with ESMTPSA id pg2sm4674302pjb.54.2022.02.08.18.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 18:30:47 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] netfilter: xt_socket: fix a typo in socket_mt_destroy()
Date:   Tue,  8 Feb 2022 18:30:43 -0800
Message-Id: <20220209023043.3469254-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
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

From: Eric Dumazet <edumazet@google.com>

Calling nf_defrag_ipv4_disable() instead of nf_defrag_ipv6_disable()
was probably not the intent.

I found this by code inspection, while chasing a possible issue in TPROXY.

Fixes: de8c12110a13 ("netfilter: disable defrag once its no longer needed")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 5e6459e1160553c0a563a38b5060815e88998b4d..662e5eb1cc39e544191b3aab388c3762674d9251 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -221,7 +221,7 @@ static void socket_mt_destroy(const struct xt_mtdtor_param *par)
 	if (par->family == NFPROTO_IPV4)
 		nf_defrag_ipv4_disable(par->net);
 	else if (par->family == NFPROTO_IPV6)
-		nf_defrag_ipv4_disable(par->net);
+		nf_defrag_ipv6_disable(par->net);
 }
 
 static struct xt_match socket_mt_reg[] __read_mostly = {
-- 
2.35.0.263.gb82422642f-goog

