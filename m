Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2CE3CD07F
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbhGSIjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbhGSIjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:39:52 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41220C061574
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 01:21:36 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o8so9253690plg.11
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 02:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zsc47IEYHfdME7/9KkKKuFj95sc38YQvBEM0lSOu6ZI=;
        b=bUQ6uujbC5PPTmJgFiJOixShQQKlmenw+Qr69NQkwBWThQs7Zgu9jlKn5boybnvcYR
         K9iL1HiNaYeehWNPcdhygzeLNeO47t7d8kMQNbOOSymnu+0kgFSCdZxOcOapWKAwUNRi
         soVdbRG3RPW668OK0MYLQKV9Ht/FLKcG7wsGnW+L5msQ0MBxyG9BQ4J1YgG9SKU1Tg6+
         ODzOqEng9zJuGPdiZQcQo3dDfe/CSHbuF7l8LvGQDuDp2cdkzufIRkPjzlJVTIqhWYXB
         AxTqBduQFJZB8IPvIhXHlub1e7mcnCINFLlZZ+kQZTQxfWuREJlqsMOhB9g8oLj6QDUu
         K5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zsc47IEYHfdME7/9KkKKuFj95sc38YQvBEM0lSOu6ZI=;
        b=dJ70l6wDcxidxfHOTsyqkok0hLhOLxOja5k12ZkdsRd3QKT4vp8MwrwSKX+oqp0/Dq
         nZ+MXRibhLMA7xcnzS9ls3nUVaA8BWA8BMeaKT/7PYUkjgftmHPBr5LdQB69dS7AyMn1
         Pum2yrCWdteeAgud5ywOwYg2H4O+D9nZNUbsCJj6qXhfb/XV3C45qKtgEr8WKh0RlJ+y
         +J4Bx2EeDUblfduISV7XSeb+pEtdGZr2rFTDOGjFYTUZTUspJt3A6GNsfvOhy16n3Hbp
         QF9lGlupCDhqwD1zyz5W8oj5jdfA7YzpmkO9oWIhsVe2+t9dJOvbLjNgSh6cXxs5lT6p
         0Pcg==
X-Gm-Message-State: AOAM532DWavDLYJ1vRqq3H+3j7hJ5F3+WU8oQr8IC5qJ8hMN/fzSP55D
        ZJegwrwOEkHIBgYMqZ2NwoE=
X-Google-Smtp-Source: ABdhPJxpZtKjIbZ8F/GbKqzZ125TXTdHt6fFYnbFYTiNJgCmt5RATMVi9c18ythmTkjo3OX/Op5hFQ==
X-Received: by 2002:a17:90a:9f91:: with SMTP id o17mr29288244pjp.29.1626686432066;
        Mon, 19 Jul 2021 02:20:32 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d265:ee2c:6429:76fd])
        by smtp.gmail.com with ESMTPSA id h20sm19389721pfn.173.2021.07.19.02.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 02:20:31 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Wei Wang <weiwan@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net] net/tcp_fastopen: remove obsolete extern
Date:   Mon, 19 Jul 2021 02:20:28 -0700
Message-Id: <20210719092028.3016745-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

After cited commit, sysctl_tcp_fastopen_blackhole_timeout is no longer
a global variable.

Fixes: 3733be14a32b ("ipv4: Namespaceify tcp_fastopen_blackhole_timeout knob")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 include/net/tcp.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 17df9b047ee46dabed8797246f99e1a2fd39c243..784d5c3ef1c5be0b54194711ff7f306d271d95c3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1709,7 +1709,6 @@ struct tcp_fastopen_context {
 	struct rcu_head	rcu;
 };
 
-extern unsigned int sysctl_tcp_fastopen_blackhole_timeout;
 void tcp_fastopen_active_disable(struct sock *sk);
 bool tcp_fastopen_active_should_disable(struct sock *sk);
 void tcp_fastopen_active_disable_ofo_check(struct sock *sk);
-- 
2.32.0.402.g57bb445576-goog

