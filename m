Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8033A2F87
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 17:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhFJPmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 11:42:23 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:40794 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbhFJPmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 11:42:20 -0400
Received: by mail-pj1-f42.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso3962601pjb.5;
        Thu, 10 Jun 2021 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K/k5CLOePGEq4ALoOuLfOb/BkxtInR8bR4U+kAjjuQQ=;
        b=XpxSjuw8JtsYCP1TPKyX6Ix2eRNFOP8AB1xCWZ7HDdVOP9QGu4Y4EEnNL/IUxVE9N7
         hfzEEYVPcNQ9RY1y5kJGc+nDM/4DmmZtjtLyYNNm7SSYi0hMIio4PQCvDNh1iSwGru+m
         rMAm78S/ZtKOAFLCvtZbd2RAxjxjwtLyON9veD9ocPjTcYR+fgTt1aVR97R0Tl9TEpaQ
         XU5wr8MEumLZds98j2TGCnEosXj5vUkzwje+vku6bu5GuM8dXpveP+G+MMqIFwCUN4iH
         Gz6CANft3Odcux5UmEgS77YJxDHqWd6UU3X7Q5jTQa4lJd861GEyQwyPNEBcImCibrF5
         3tuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K/k5CLOePGEq4ALoOuLfOb/BkxtInR8bR4U+kAjjuQQ=;
        b=kfhQSh4dbY8gR6gWJa9ACsKIywJp0oy3kyZiD4FoX27hHCVlMiVyDaUc5qClueK8fu
         mQPUPcg7tpFg+RaREht+D/OWAHrQuGBBOn3/omM5f3bCDa2i5PEFt8hiXkOxHHNzqP6c
         uqfeQT0uMRqSiMRaBTWZ3uPlTTYQxM9m8Ctlnar4HezOlGShkP2QD4abon/AiHOQIlBq
         jj9XECGDaZ5dhX0o5EHDY2JDvQBmokPtXDuBnwIM1tPH/Gcr/lptu1B7LyNSrb67cwp9
         eEOf9rHScHSOXEnGpCTjGEzGQeFEi29JAZxnoxUiiRP1JgLRyxexiOZAkD8y9Y9MgL7L
         s1EA==
X-Gm-Message-State: AOAM530eDoNnrHUUMNC9anny83nH0o0x6ObANOpceMIeI1KiKQJcmiB2
        AvMtj7Yd9BNpbqMBQrcdJnY=
X-Google-Smtp-Source: ABdhPJzTe77hC6bd/zlNCUFDIMKL1TVQbtL4RxRofNzpdiYBSrZnHdltINXesc/xg1kMF9FaaFHMRA==
X-Received: by 2002:a17:90a:de07:: with SMTP id m7mr3999831pjv.100.1623339550713;
        Thu, 10 Jun 2021 08:39:10 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id s4sm2835948pjn.31.2021.06.10.08.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 08:39:10 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jakub Kici nski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>
Subject: [PATCH] net: make get_net_ns_by_fd inline if NET_NS is disabled
Date:   Thu, 10 Jun 2021 23:38:58 +0800
Message-Id: <20210610153858.118822-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function get_net_ns_by_fd() could be inlined when NET_NS is not
enabled.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
---
 include/net/net_namespace.h | 8 +++++++-
 net/core/net_namespace.c    | 8 +-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index fa5887143f0d..0a25f95691d9 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -184,6 +184,8 @@ struct net *copy_net_ns(unsigned long flags, struct user_namespace *user_ns,
 void net_ns_get_ownership(const struct net *net, kuid_t *uid, kgid_t *gid);
 
 void net_ns_barrier(void);
+
+struct net *get_net_ns_by_fd(int fd);
 #else /* CONFIG_NET_NS */
 #include <linux/sched.h>
 #include <linux/nsproxy.h>
@@ -203,13 +205,17 @@ static inline void net_ns_get_ownership(const struct net *net,
 }
 
 static inline void net_ns_barrier(void) {}
+
+static inline struct net *get_net_ns_by_fd(int fd)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif /* CONFIG_NET_NS */
 
 
 extern struct list_head net_namespace_list;
 
 struct net *get_net_ns_by_pid(pid_t pid);
-struct net *get_net_ns_by_fd(int fd);
 
 #ifdef CONFIG_SYSCTL
 void ipx_register_sysctl(void);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 43b6ac4c4439..6a0d9583d69c 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -660,14 +660,8 @@ struct net *get_net_ns_by_fd(int fd)
 	fput(file);
 	return net;
 }
-
-#else
-struct net *get_net_ns_by_fd(int fd)
-{
-	return ERR_PTR(-EINVAL);
-}
-#endif
 EXPORT_SYMBOL_GPL(get_net_ns_by_fd);
+#endif
 
 struct net *get_net_ns_by_pid(pid_t pid)
 {
-- 
2.30.2

