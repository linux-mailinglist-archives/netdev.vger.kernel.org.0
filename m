Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485613A2F82
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 17:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhFJPmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 11:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhFJPmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 11:42:08 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2381FC061574;
        Thu, 10 Jun 2021 08:39:58 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g24so3886874pji.4;
        Thu, 10 Jun 2021 08:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kc4pXr5gVNJ0GV4/7ScD/COeGEHHNK7iRy2xX2e12DI=;
        b=IyHkDvw7B+4DLlhCIY1ijXU4xhYagkAothzqzrFunFLKuLnEVOqkdR2K4sb+G4yX4u
         6tM4ZgYCPl6sy7KEg4m4SLIebhn6p+6GQAP2L6UVjjnnc5UXmpDqdIe+Y0FiEM8UhSe8
         mkzSBptJ3N80xbNZshoFQReZ2hLe5viMlsmrAmcvh+9o7RlhVVlIGyYhy02LUBEF4an1
         4+N1CKRID8/C2PcAORbife1Ix0eibaTSni68Ulr2YbI+Mzm1AxXZCKyVBBbU1i7if2hY
         oQ/aoy0YCI39Whwwr5XipCmfiPViR1OaZ7oyXtfNyYZTCdnrxE6f5taifFDN4QQwKdzq
         +Q0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kc4pXr5gVNJ0GV4/7ScD/COeGEHHNK7iRy2xX2e12DI=;
        b=dhnMFblOrHYLA22AiRbqWq57yBEMA9E63IO+oXxwiOmv/beHnYDsiVBaMyJUaxiX37
         IO6nYKhQCqsZIMNR4W+7Ov+G8YDZf0K2n4fSSfpo7IhkG/XlLoLzhgMSz2swfCMPXYpi
         jEtkPwjUXKQAz15DiDGZa0LodyQGyIAA2GqKdws68rKVVhfukdHBTeTleLhq0Y45PUDw
         lq9tmVBWuAJ+r6JL5i4d+zjpBCoK7+o7T/3u7zfrpA6+Crp69ohv4cka3IBQEy7dhp6+
         IiYzqAW8eLC4vs4vvCr9AFmoolGzQK8NClWwrznQNnJjxQCqBOzvN+/FtOTVQfzurvPS
         p8cg==
X-Gm-Message-State: AOAM532Tfq7r8hQAjp6tEqL8wjAaMHCIKAKUTI8bUA6MIGuoQY0o+/er
        Yh04W6zYvjerLcvIkpg9v5A=
X-Google-Smtp-Source: ABdhPJy1+X7uMGr8zSTlJxnbngnw425lzx3UTys1Mj/5qiNq30fMS492iOZMLFe6EE7yv4rXyxMmcw==
X-Received: by 2002:a17:902:728d:b029:113:23:c65f with SMTP id d13-20020a170902728db02901130023c65fmr5425981pll.23.1623339597692;
        Thu, 10 Jun 2021 08:39:57 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id o20sm2864553pjq.4.2021.06.10.08.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 08:39:57 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jakub Kici nski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v3] net: make get_net_ns return error if NET_NS is disabled
Date:   Thu, 10 Jun 2021 23:39:41 +0800
Message-Id: <20210610153941.118945-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a panic in socket ioctl cmd SIOCGSKNS when NET_NS is not enabled.
The reason is that nsfs tries to access ns->ops but the proc_ns_operations
is not implemented in this case.

[7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[7.670268] pgd = 32b54000
[7.670544] [00000010] *pgd=00000000
[7.671861] Internal error: Oops: 5 [#1] SMP ARM
[7.672315] Modules linked in:
[7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
[7.673309] Hardware name: Generic DT based system
[7.673642] PC is at nsfs_evict+0x24/0x30
[7.674486] LR is at clear_inode+0x20/0x9c

The same to tun SIOCGSKNS command.

To fix this problem, we make get_net_ns() return -EINVAL when NET_NS is
disabled. Meanwhile move it to right place net/core/net_namespace.c.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>

---
Patch "net: make get_net_ns_by_fd inline if NET_NS is disabled" must be
applied first.
---
 include/linux/socket.h      |  2 --
 include/net/net_namespace.h |  6 ++++++
 net/core/net_namespace.c    | 12 ++++++++++++
 net/socket.c                | 13 -------------
 4 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index b8fc5c53ba6f..0d8e3dcb7f88 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -438,6 +438,4 @@ extern int __sys_socketpair(int family, int type, int protocol,
 			    int __user *usockvec);
 extern int __sys_shutdown_sock(struct socket *sock, int how);
 extern int __sys_shutdown(int fd, int how);
-
-extern struct ns_common *get_net_ns(struct ns_common *ns);
 #endif /* _LINUX_SOCKET_H */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 0a25f95691d9..bdc0459a595e 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -185,6 +185,7 @@ void net_ns_get_ownership(const struct net *net, kuid_t *uid, kgid_t *gid);
 
 void net_ns_barrier(void);
 
+struct ns_common *get_net_ns(struct ns_common *ns);
 struct net *get_net_ns_by_fd(int fd);
 #else /* CONFIG_NET_NS */
 #include <linux/sched.h>
@@ -206,6 +207,11 @@ static inline void net_ns_get_ownership(const struct net *net,
 
 static inline void net_ns_barrier(void) {}
 
+static inline struct ns_common *get_net_ns(struct ns_common *ns)
+{
+	return ERR_PTR(-EINVAL);
+}
+
 static inline struct net *get_net_ns_by_fd(int fd)
 {
 	return ERR_PTR(-EINVAL);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 6a0d9583d69c..9b5a767eddd5 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -641,6 +641,18 @@ void __put_net(struct net *net)
 }
 EXPORT_SYMBOL_GPL(__put_net);
 
+/**
+ * get_net_ns - increment the refcount of the network namespace
+ * @ns: common namespace (net)
+ *
+ * Returns the net's common namespace.
+ */
+struct ns_common *get_net_ns(struct ns_common *ns)
+{
+	return &get_net(container_of(ns, struct net, ns))->ns;
+}
+EXPORT_SYMBOL_GPL(get_net_ns);
+
 struct net *get_net_ns_by_fd(int fd)
 {
 	struct file *file;
diff --git a/net/socket.c b/net/socket.c
index 27e3e7d53f8e..4f2c6d2795d0 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1072,19 +1072,6 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
  *	what to do with it - that's up to the protocol still.
  */
 
-/**
- *	get_net_ns - increment the refcount of the network namespace
- *	@ns: common namespace (net)
- *
- *	Returns the net's common namespace.
- */
-
-struct ns_common *get_net_ns(struct ns_common *ns)
-{
-	return &get_net(container_of(ns, struct net, ns))->ns;
-}
-EXPORT_SYMBOL_GPL(get_net_ns);
-
 static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
 	struct socket *sock;
-- 
2.30.2

