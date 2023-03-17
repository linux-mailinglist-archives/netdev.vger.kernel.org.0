Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EA86BED70
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjCQP4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjCQPz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:55:58 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAF2D5A64
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-544d2dc2649so5077937b3.15
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=frW+YtgkbUT1EDOBzFr367nCrSEoGgXXQPUi+ytLe5k=;
        b=oTVzi9supt7cBSOk5zvarGLCUGogER8ZvemDKakQr2zIxN3ciK7UdCsYRXe2vo9b0r
         q02TPeh+3WCr8XvhNbPS71EBRI/JeNqnFr6o9jOLRMYY3UyCB+sxuyEbRHzuGjplH8Sn
         iYhSfelyREuY98UZ2a2yDOsA7Ksfix9yJJMoxSU7GhkZ5NVO9rCxocJPSb8wVnh41h76
         CusZPPnaegHWiWl5dIp9BCeSdE5xuOsDB+x6bzsqh/WfMc7HwMUZtJC78y5HFpkgwufi
         avakD+1zrKK4xBKAebIOjeP31rSnUtDX05zjO+8d6txLzQNprVxiUv7tdB+zYoJ4jg1/
         PFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=frW+YtgkbUT1EDOBzFr367nCrSEoGgXXQPUi+ytLe5k=;
        b=euPkujjwNxTxMBGTfKyYabkBdmNcs1+pCnzFNtsv+J7VI4Jwp1etX+n/yaSrHKAre9
         pgi1iQR2oN6Yc6S6Z/ThBob3acK8l2gMFe8rwy78RKZo7wUmhQp7t26OBZwPmz6sXagW
         qlf2DpvqR8Thun2vSxxTQUnfqxA3trwD8KJyuzL3NXotsGNckcPjWBpgfkZ+xPNXXIaE
         qcqIfyuGla+X2uXXu9KO1j0ASIks9Vx9F6yHa2354P3rmvIZTEcreU4IQPOeABB0kQh5
         ridyoj/cRd9DbCQKh+lIQa1HchnpCZjC+TyC4ffd9O8cJ+9CLbXQ243N+onR6wDOQ4eE
         89vQ==
X-Gm-Message-State: AO0yUKVTLqVWTnHnV70BFtfJQRP2XzdOHAYHNjfbh7ORt8jI1xcA2thY
        Hv4YeiOT8zQIM8tqPDuAyvq1nLa+pYM8Mw==
X-Google-Smtp-Source: AK7set/t+RE89LC44fEXLvbvUcNQgILPK3oj6/BHSvi9Wx4XFF1g5gNOuHJsmTIzrR/K75PVv8Hh9m3BKSSmFw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:511:b0:b2e:f387:b428 with SMTP
 id x17-20020a056902051100b00b2ef387b428mr56527ybs.5.1679068552330; Fri, 17
 Mar 2023 08:55:52 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:36 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-8-edumazet@google.com>
Subject: [PATCH net-next 07/10] smc: preserve const qualifier in smc_sk()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>
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

We can change smc_sk() to propagate its argument const qualifier,
thanks to container_of_const().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Jan Karcher <jaka@linux.ibm.com>
---
 net/smc/smc.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index 5ed765ea0c731a7f0095cd6a99a0e42d227eaca9..2eeea4cdc7187eed2a3b12888d8f647382f6f2ac 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -283,10 +283,7 @@ struct smc_sock {				/* smc sock container */
 						 * */
 };
 
-static inline struct smc_sock *smc_sk(const struct sock *sk)
-{
-	return (struct smc_sock *)sk;
-}
+#define smc_sk(ptr) container_of_const(ptr, struct smc_sock, sk)
 
 static inline void smc_init_saved_callbacks(struct smc_sock *smc)
 {
-- 
2.40.0.rc2.332.ga46443480c-goog

