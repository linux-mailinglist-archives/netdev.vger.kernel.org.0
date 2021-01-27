Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3737E306715
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 23:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbhA0WP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 17:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhA0WPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 17:15:52 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E62C061573;
        Wed, 27 Jan 2021 14:15:12 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id d18so3931771oic.3;
        Wed, 27 Jan 2021 14:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pv2pcU/+/UIa6eojcj2SR6nsmXZahv+O06YIs/Kzafk=;
        b=lQs4oaiEkF3onn+fDji1VHB0t5ZOhEJld6GYA3N6l6DVUQE5y1YPVZT6CRY9mwIx1N
         +XzrgNmiqJepvbbwiczkwqhPcsPKqrUsHXaPV61j0eqqTs4GQv5ed8yo6bjUbYWWRWoS
         Ey9KAZsp9ZML+tjY2ZfyWOyjVY5naE8bWpSYfji9bsrD6XNiIPKfhOtdg2Nupn6ZDau6
         5qBpus6DhYuPJqMWRgrP7s16cb44J4Sy+DJ6F7JSwtSjDw3FH2QaRnASL+/dC9YOd7M+
         S7kvjfheCbRYXz2GXVgf7XYsKxTBQNak5RohUmkOkGdRZO3yw3kd9UzctiV9AVARhT7M
         L2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pv2pcU/+/UIa6eojcj2SR6nsmXZahv+O06YIs/Kzafk=;
        b=tqTbvn9fmjo+CI7Zy1CMxYCLF/r74ESHfrK4r3SXkyvCeLLbY7n6RRj79KP+wI+/Qg
         ShA1AwtAK3IgEliOsIWULEwW7RfNaw9/nWFEOX+y9pVQvjZFHJoSaIX/7IzXI8u1NcsY
         YEVXkupK6/gV5jNmJ/ojD9q8QARUyidCz783k5OLRVBe2Geu+ZjRNsl/mBanVRNsMGK9
         7Otvgt+oEn73kDr71iaOpetfKPXpqDr4gOInUBiUF9jFKn+d46puOhObFAk+BuhbUvpu
         Dhh0BmiXEE7EN7EqwSaZF7ZzSRxByCRpSwicNlg0Kc3lUILU3e2Bxk3kPnecIcIdWunl
         fL2w==
X-Gm-Message-State: AOAM533LaAI+WAe4NT84cMh+M4zs/QUcxBTh5EOaA2mRwR0YGSdRye8O
        MG9kTaJy8KI2Mgs1y1uMU8Ea+fQ1FDPgaQ==
X-Google-Smtp-Source: ABdhPJw9jpL3BiJk1P35bs+zaa3mHhY7lmPeubEjJZ7pUpA0sEmD/ElYDaZTiki8M+1OedbTKBXC3g==
X-Received: by 2002:aca:5b46:: with SMTP id p67mr4771520oib.179.1611785711399;
        Wed, 27 Jan 2021 14:15:11 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:b17d:dead:8ea2:9775])
        by smtp.gmail.com with ESMTPSA id w11sm610114otg.58.2021.01.27.14.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 14:15:10 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next] skmsg: make sk_psock_destroy() static
Date:   Wed, 27 Jan 2021 14:15:01 -0800
Message-Id: <20210127221501.46866-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

sk_psock_destroy() is a RCU callback, I can't see any reason why
it could be used outside.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 1 -
 net/core/skmsg.c      | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index fec0c5ac1c4f..8edbbf5f2f93 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -390,7 +390,6 @@ static inline struct sk_psock *sk_psock_get(struct sock *sk)
 }
 
 void sk_psock_stop(struct sock *sk, struct sk_psock *psock);
-void sk_psock_destroy(struct rcu_head *rcu);
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock);
 
 static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 25cdbb20f3a0..1261512d6807 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -669,14 +669,13 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 	kfree(psock);
 }
 
-void sk_psock_destroy(struct rcu_head *rcu)
+static void sk_psock_destroy(struct rcu_head *rcu)
 {
 	struct sk_psock *psock = container_of(rcu, struct sk_psock, rcu);
 
 	INIT_WORK(&psock->gc, sk_psock_destroy_deferred);
 	schedule_work(&psock->gc);
 }
-EXPORT_SYMBOL_GPL(sk_psock_destroy);
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-- 
2.25.1

