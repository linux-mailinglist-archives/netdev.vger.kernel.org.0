Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68216BED6A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjCQP4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjCQPz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:55:56 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B72AD515F
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:45 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54352648c1eso49931207b3.9
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7WDb4WFB6ufGyo+7uDzqFEl2Sw8/skYpQIfnfoJl7vU=;
        b=Ap60NmqglDibcNInqR8M4GTr8wvM5sBfadl22E77ddVz5kg1e+akyPkf/txn/8Q667
         An1LN7kaScjimWcdiVqlDs0ALyuqk5pFLVMTDdRKwXY+jiPvyaCyINYkG1JbtxHm0yn8
         zd3+70W0I4fAopZTp4d2WWfjgjjye18Ou5yf51eD4cyhCm/6LxSL/IeZlH0Ca0QOS0HH
         2FCj1NU97Mv37yZPu4uzDsyfYJQNxbKBCG1Kv89dJg9qA3iEiKBTvfIS6Gpzzvt6PKCI
         oLU0KEF9ncwvjC1mmouBvJpYhDohxSct4ylOxPbz37/oMY464gVpMTy6Qn8ffr8x1/nW
         y87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7WDb4WFB6ufGyo+7uDzqFEl2Sw8/skYpQIfnfoJl7vU=;
        b=fyC52CHHV2W/1W1XVzkn3mVs/1UgeDbS8xItFgZp/EQEF02UQ3nfn//jXQAUn0njPA
         JNw3o/FdYYExzE+0jVpr/Z9QhsUhmddF5V9ZHwMmC6UXXiJk04Vrlu1rbGamNM6p4T7N
         Bt+cz98ibfZt5e4lfqmOs8elyDxZRacXX8I6wB34xyodfPp7M7uPNoBaz/3r9hd2tW81
         stVtsqHlQyHhHgOmvCdGMIeSYDFSpsRnW2urEhMIz+yW6bWLxbkFqQG6hRr7km70snaq
         YQmjG++1Gb/Ml4qk4o1yF/5xoZxKTUTmZrOSojo/hebBOqJ8JEiLw0AlCYkEq/ggI4RU
         ysNQ==
X-Gm-Message-State: AO0yUKVlWcFt2tupoRqulnqG39P6HCf/YWWnyFg7WlMkqvsoK7lGFe++
        swmJbcDVc1dQLI8V4MErf94ICWpS2PzxhQ==
X-Google-Smtp-Source: AK7set+a8okPYk/5x9Fjk1/H8Udc9H1/k/TRYtAVhRkipEjnw6aGYcHD0QVXHBKitAE56Myjx7WhFVCNrrnFJA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:4d4:b0:9f1:6c48:f95f with SMTP
 id v20-20020a05690204d400b009f16c48f95fmr52456ybs.5.1679068544522; Fri, 17
 Mar 2023 08:55:44 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:31 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-3-edumazet@google.com>
Subject: [PATCH net-next 02/10] af_packet: preserve const qualifier in pkt_sk()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can change pkt_sk() to propagate const qualifier of its argument,
thanks to container_of_const()

This should avoid some potential errors caused by accidental
(const -> not_const) promotion.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/packet/internal.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/packet/internal.h b/net/packet/internal.h
index 680703dbce5e04fc26d0fdeab1c1c911b71a8729..e793e99646f1c60f61a8dc5e765f8f544de83972 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -133,10 +133,7 @@ struct packet_sock {
 	atomic_t		tp_drops ____cacheline_aligned_in_smp;
 };
 
-static inline struct packet_sock *pkt_sk(struct sock *sk)
-{
-	return (struct packet_sock *)sk;
-}
+#define pkt_sk(ptr) container_of_const(ptr, struct packet_sock, sk)
 
 enum packet_sock_flags {
 	PACKET_SOCK_ORIGDEV,
-- 
2.40.0.rc2.332.ga46443480c-goog

