Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DB854B627
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344164AbiFNQaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344232AbiFNQal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:30:41 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1F044A02
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:30:31 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d13so8149339plh.13
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6bECSe3JFxq6eJt90PO1NvfTGgvzif21tVQUALk/0nQ=;
        b=cR40t1LcQdWRDoGUt4sKNpJuBDRfk1j0DVGPE8yYLt6SH5cSqzI2p9beTHOVuYZbVG
         /qq4uqqevmd4DpkO2pDlX29/Vwi236t24/YRZBygcl+cqAn65iU1gApFs6F1NaNThOfl
         U9uJ01sZJWRM7stt+HjucNeQGfCa1M1BgqOv9CODa8kLmkYcv92kWglgARlY0pa8k4ap
         iJLM5Fn+8Ph5lvOY/HZ4nVeDSQNcTY0TRsHCHAQ/xShuWR8zWm8RsXTn5E5bfGRnlZoc
         tUj/pJQFaMbkgyanlKudoxJq4wXRSeLnez3mWwHFE9WFaCEOYq5nnGCFFdLJEPOTWd7E
         6upQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6bECSe3JFxq6eJt90PO1NvfTGgvzif21tVQUALk/0nQ=;
        b=C3WTDokfvIaD6v9B41IaCvvEx9cojZZw9krBft2sQIQQqkENS7rOmfB5IK7jj3P7S/
         N3NYUyusvLFkZTOXvqhoLA4M0+5bHSSXalv2vKeOG2aUP4v9At0Q9Mb86vQMAAay3hES
         4RHqj0BdZuAb0NenKJIS9pMyfAEI7vAK3Xy1so88FqQW1w5DTWbMFCwAPpNQV107AkgY
         pAcClEYpQvMlrmwBGp6xa1D/mCtVk87mMa/WBulXfRGh7GlHkY4EjIgCF9AQ+44hlrWo
         sIU5Qb5vZbip7xZ+Dzx3bRA5TtwRZr+uw1Isnt+yUEgbeOLh5ox0X0dS3xnkAF2SXz6F
         5yzg==
X-Gm-Message-State: AJIora9ND9JSW6xsvO6dyu/hjQN4ngRMqoF8Fk7RpIJu1MIoBZ4Pz+Km
        QEUaOgW311je084/v9PDv68=
X-Google-Smtp-Source: AGRyM1tTQ2QdaNJJgD/6ROVtmIkhMLW/6lx+UvoOEMvfZSLuUL94ElFzkOdzJg8nh7ds1uyHY4bJzA==
X-Received: by 2002:a17:902:7783:b0:167:8245:ea04 with SMTP id o3-20020a170902778300b001678245ea04mr5008419pll.95.1655224231122;
        Tue, 14 Jun 2022 09:30:31 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2dbb:8c54:2434:5ada])
        by smtp.gmail.com with ESMTPSA id p1-20020a170903248100b0016796cdd802sm7506484plw.19.2022.06.14.09.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 09:30:30 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] tcp: fix possible freeze in tx path under memory pressure
Date:   Tue, 14 Jun 2022 09:30:24 -0700
Message-Id: <20220614163024.1061106-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220614163024.1061106-1-eric.dumazet@gmail.com>
References: <20220614163024.1061106-1-eric.dumazet@gmail.com>
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

Blamed commit only dealt with applications issuing small writes.

Issue here is that we allow to force memory schedule for the sk_buff
allocation, but we have no guarantee that sendmsg() is able to
copy some payload in it.

In this patch, I make sure the socket can use up to tcp_wmem[0] bytes.

For example, if we consider tcp_wmem[0] = 4096 (default on x86),
and initial skb->truesize being 1280, tcp_sendmsg() is able to
copy up to 2816 bytes under memory pressure.

Before this patch a sendmsg() sending more than 2816 bytes
would either block forever (if persistent memory pressure),
or return -EAGAIN.

For bigger MTU networks, it is advised to increase tcp_wmem[0]
to avoid sending too small packets.

Fixes: 8e4d980ac215 ("tcp: fix behavior for epoll edge trigger")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 14ebb4ec4a51f3c55501aa53423ce897599e8637..78698a7693e4a475155e1a4237b8708b53166c1e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1334,10 +1334,24 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
 
-			if (tcp_downgrade_zcopy_pure(sk, skb) ||
-			    !sk_wmem_schedule(sk, copy))
+			if (tcp_downgrade_zcopy_pure(sk, skb))
 				goto wait_for_space;
+			if (unlikely(!sk_wmem_schedule(sk, copy))) {
+				int left;
 
+				/* We are in trouble if we have nothing queued.
+				 * Use whatever is left in sk->sk_forward_alloc
+				 * and tcp_wmem[0] to guarantee some progress.
+				 */
+				left = sock_net(sk)->ipv4.sysctl_tcp_wmem[0] -
+				       sk->sk_wmem_queued;
+				if (left > 0)
+					sk_forced_mem_schedule(sk, min(left, copy));
+
+				copy = min(copy, sk->sk_forward_alloc);
+				if (!copy)
+					goto wait_for_space;
+			}
 			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
 						       pfrag->page,
 						       pfrag->offset,
-- 
2.36.1.476.g0c4daa206d-goog

