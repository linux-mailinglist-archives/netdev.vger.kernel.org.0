Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D3E3504B4
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhCaQfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbhCaQfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 12:35:17 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F71C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 09:35:17 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s11so8885642pfm.1
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 09:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+frtawoEjy5vWMtZfzjH9Zs/qfUusrBnfbabdSsa4XE=;
        b=VEhTIrGp/lM6EqC5PJCe5mC9cjgvGuaw4rYsyo/eMcOUcyqW4Ed6+8+ibClbTD9g+i
         7DUw5hIhopmNYUPxGgTAAEqx+4Ad6jFzZr/PzAAfMEmzIQ08yMtKerGtBsIWXRXAZW+7
         +n5e1eq8pcTdTT+r28YNiDfVLq/jiA5snlIvAajPTxX8hd8xV6jEtg+ebGsHapywvIXN
         qMZx85SLXwtEaI4yes/UsQ0k8TKBKsPhEY4yqqCG63RswWvxTOZx2/DJXQkTAAG1NoTJ
         x0G8ZuNw5882xv38uwr95Wn30MzmTl85U1sEJb9SoJ8AbTH+o8wOFNHZ01QlNYXo/qBW
         iM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+frtawoEjy5vWMtZfzjH9Zs/qfUusrBnfbabdSsa4XE=;
        b=OQgTc0qT3lKUkM15wQ4gVzftx2VO55nir81mIejFofw1CX1tm3WPIVp+kar045BvmG
         FEIePbo9fbIEYr85IzQuydsHGbGt0WygohDSKGIB5UdSlk9icCTQpcNxHqE4IoohHaYz
         ow+cEJ2d11HGnwMHSodGd8AnvzbZDy1spby9Vr4LosrN2NGkmAQjl3bwEH59lI8s9+qj
         W6gra37P7/UAdbqzDtVgwJSCgrCN9lsm9Fcl0M/AkXWiBcb4tYwzfjgpwq1GTm8a09ji
         DSNufc7Y4bycUr5vM0pBFq8lM73BLS9W2v9yMtryoadyfuX2+mB25DmOlHancE4l9j2k
         Q5Uw==
X-Gm-Message-State: AOAM533WOA4mUWcWMRAaYJ25opIPbCRdOrd0aeDq7U6Xpw8euON7ai99
        FZGoN0rQ8FE3zZJVlGdSGno=
X-Google-Smtp-Source: ABdhPJzY4fu67BZ6Mi13xZh66TAbnVFIFz9aKpQQkppj0hvNR66vIORUD8XQe8IEKVYtOAvNRynhHQ==
X-Received: by 2002:aa7:9a89:0:b029:200:1eed:1388 with SMTP id w9-20020aa79a890000b02902001eed1388mr3738089pfi.79.1617208516887;
        Wed, 31 Mar 2021 09:35:16 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id i14sm2782330pjh.17.2021.03.31.09.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 09:35:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        iuyacan <yacanliu@163.com>
Subject: [PATCH net] Revert "net: correct sk_acceptq_is_full()"
Date:   Wed, 31 Mar 2021 09:35:12 -0700
Message-Id: <20210331163512.577893-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This reverts commit f211ac154577ec9ccf07c15f18a6abf0d9bdb4ab.

We had similar attempt in the past, and we reverted it.

History:

64a146513f8f12ba204b7bf5cb7e9505594ead42 [NET]: Revert incorrect accept queue backlog changes.
8488df894d05d6fa41c2bd298c335f944bb0e401 [NET]: Fix bugs in "Whether sock accept queue is full" checking

I am adding a fat comment so that future attempts will
be much harder.

Fixes: f211ac154577 ("net: correct sk_acceptq_is_full()")
Cc: iuyacan <yacanliu@163.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3e3a5da2ce5aedbcfaca1880eb7c2e239c86b5ae..8487f58da36d21335f690edd2194986c3d4fed23 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -934,9 +934,13 @@ static inline void sk_acceptq_added(struct sock *sk)
 	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog + 1);
 }
 
+/* Note: If you think the test should be:
+ *	return READ_ONCE(sk->sk_ack_backlog) >= READ_ONCE(sk->sk_max_ack_backlog);
+ * Then please take a look at commit 64a146513f8f ("[NET]: Revert incorrect accept queue backlog changes.")
+ */
 static inline bool sk_acceptq_is_full(const struct sock *sk)
 {
-	return READ_ONCE(sk->sk_ack_backlog) >= READ_ONCE(sk->sk_max_ack_backlog);
+	return READ_ONCE(sk->sk_ack_backlog) > READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 /*
-- 
2.31.0.291.g576ba9dcdaf-goog

