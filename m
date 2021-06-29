Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F573B7381
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 15:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhF2Nyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 09:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhF2Nyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 09:54:45 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2960AC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 06:52:18 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y17so6276819pgf.12
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 06:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rEANJ6ZYXzAbzUCFX9DpA/6cGg1pyPGuwHqrG52x8oI=;
        b=HGV5+hGsO4tG9zTtWUb+SXYuwLHobEFsyxhcALqTDgO52uvjgETEBE4TTT9sMfkCdf
         WtefeL7QQzD+OZJHA0JXCpryuXUv/zaDHjbEX9hK86SmI+uoNrHTTLeEtiKNAmN5da1l
         Lcvs+cWviRKKEaLMl75fGfkc0qmgq2xrHuv6SHmRk/Wjfof5tSG3eJxl/jyR0FNM+IAU
         1aX3eE4u5XwzSLjE7xkOILjkb8dfJzml52fWamqhzkm8vhaA9BdgI76DUxTiSux2lOGR
         1Q7NlPbQJWpZRaxH0NvhMgwI5B3pc9UP12OyAc4JekU/1C+GzHYtSUt4+1OoTymMAlED
         QdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rEANJ6ZYXzAbzUCFX9DpA/6cGg1pyPGuwHqrG52x8oI=;
        b=N2iNA8/LgmplDT0yH4lKMkW6CZqe2FvmJjxMECoL2dHlPFN3+stZIjr5Q4hqgjRkgg
         mLZx2OO9RYgpMCGXI8d3O8aUuEviGDCBrOw+HA1bTnFXQfhG38FL5RDhlcbbs2aGOkMa
         7ayJqsX7T5H6eZQCdqPXR5CYH237GLAlx4/sSqo+fE+mWP+Oq27t3VYLjI54c/iINlxz
         Ga+0WbMqEPIx4us2JRKwZXn0ASYN/4gOLZz0mbojMlnDOi2PfgpI9xnyJB281FOSq+4g
         JEE9aBK6MYG9SHSVDBzCFFY+EkWs2fPbHjkvY73aYQaVnpRtiAzHjuBxK9s4FddG4poY
         HBtg==
X-Gm-Message-State: AOAM532YRaEyhdP3ldzuoxGYHSy5pYwEJDmSBDrM4XqzH3A1+RRLmbCa
        plw/r+vPh7Xt/jdKbW6Vg2WOUvJUGXc=
X-Google-Smtp-Source: ABdhPJzdZ5OdFnSJwRlxRq8bFpiAHP1PqT9Vfr9UHsIzcgYz/+l7bDbJX4qbKOYvpFY5L9P4H4Q/7A==
X-Received: by 2002:a65:4389:: with SMTP id m9mr4204651pgp.184.1624974737731;
        Tue, 29 Jun 2021 06:52:17 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6838:b492:569f:2a9a])
        by smtp.gmail.com with ESMTPSA id 7sm18744447pfu.24.2021.06.29.06.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 06:52:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] tcp_yeah: check struct yeah size at compile time
Date:   Tue, 29 Jun 2021 06:52:13 -0700
Message-Id: <20210629135213.1070529-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Compiler can perform the sanity check instead of waiting
to load the module and crash the host.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_yeah.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_yeah.c b/net/ipv4/tcp_yeah.c
index 3bb448761ca38ab169ebac02c5f39020e7469ba9..07c4c93b9fdb65a513d99532ed7c066cec7d89f4 100644
--- a/net/ipv4/tcp_yeah.c
+++ b/net/ipv4/tcp_yeah.c
@@ -221,7 +221,7 @@ static struct tcp_congestion_ops tcp_yeah __read_mostly = {
 
 static int __init tcp_yeah_register(void)
 {
-	BUG_ON(sizeof(struct yeah) > ICSK_CA_PRIV_SIZE);
+	BUILD_BUG_ON(sizeof(struct yeah) > ICSK_CA_PRIV_SIZE);
 	tcp_register_congestion_control(&tcp_yeah);
 	return 0;
 }
-- 
2.32.0.93.g670b81a890-goog

