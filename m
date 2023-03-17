Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE266BED6F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjCQPz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjCQPz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:55:56 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EB4CC33F
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54463468d06so50367557b3.7
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C6D2OFfChRhykP3xx5GEXvzGCPaa1aTwYASPq37Pek8=;
        b=sVd/Uu3f7XK24piuUpG5FOI8euHvOD8V1i7BahxFKmfajqhb5WHkOWU/T4ML4GSVgF
         QsPa3b3u9TxI3abUKxZjCqaQ7s7RuSM2XHXyJBQl11PRJus/isuFSxFuUuZlRUQhCLvB
         v67bmZ7i0nAIFVWWghUpdgA66kJRbah7E7J8Le8LKiPFcEPqpb2f8VdQIRjnisCIhdGB
         IiOPwMq7d+P+MdO6KudL0AeKYXjrasu2QHuxpvqlWUW6yesL6sUP+iraE84ZJxP94quF
         0aMvSPfmZ2SDnaYeMsP3GXBV65/uTAR0VVhew2kvPxMOHVVpIlrlz68LVCTKI67tQbbs
         R/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C6D2OFfChRhykP3xx5GEXvzGCPaa1aTwYASPq37Pek8=;
        b=tAB89HhNoA9AS4FlK5vr7IFbjuDNtmo6wvJB4OWCO8E24aMmXrAG0B7pNCcBoyY6t/
         b3Xixa0lPPqsxLRlBmbPrbHJWkAGdOcQ//zoIfzkywshUPvNC039Gs1w6c1iVCklQtND
         r83/afSpvrrR1ktiYb3lTumk/OvWBSR3Aj50E3I2hCW4/LhPa3XH5iXvbGL6dnvBiTEt
         vb7qSodhu7KE8n77Rz7od10pRGUJoriByNI9yZMPneSG5cfOnKHi08M/hE2CZG+Obcyd
         68YQdSXRIKIuGI7n1YYTVkosDyArQtyaBD7ygrQ/78bnRonv0OFVWLHeJpPd/L9ujNG5
         t77Q==
X-Gm-Message-State: AO0yUKVwh4iWutsE6l9lmI+wTTggKdpbGnUm5yNBGYnZPuWAf1cpdOG8
        2e2+FO81SNoeTYEuSrMFbMOg1/QV2kudmQ==
X-Google-Smtp-Source: AK7set/iwMWR1/Cq9ihGHWmn17VvEzLnGYpbvsW4+b1EoX+/fvUtdRFjF6Jh3ArkLYMTg3fWyqvx1kPehhMpSQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:4cc:b0:a67:c976:c910 with SMTP
 id v12-20020a05690204cc00b00a67c976c910mr46932ybs.7.1679068546293; Fri, 17
 Mar 2023 08:55:46 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:32 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-4-edumazet@google.com>
Subject: [PATCH net-next 03/10] raw: preserve const qualifier in raw_sk()
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

We can change raw_sk() to propagate const qualifier of its argument,
thanks to container_of_const()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/raw.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 7ad15830cf38460f1fae3a187986d74faef6dd1d..c215af02f7589ee5e77a7c3f89cb216fab638c4c 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -83,10 +83,7 @@ struct raw_sock {
 	u32		   ipmr_table;
 };
 
-static inline struct raw_sock *raw_sk(const struct sock *sk)
-{
-	return (struct raw_sock *)sk;
-}
+#define raw_sk(ptr) container_of_const(ptr, struct raw_sock, inet.sk)
 
 static inline bool raw_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 				       int dif, int sdif)
-- 
2.40.0.rc2.332.ga46443480c-goog

