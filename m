Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CAD216022
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgGFUSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbgGFURa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:17:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C4CC08C5E0
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:17:30 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s14so15764201plq.6
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/dNt1Keysj5w5kx1U0usPx6ojSMc5N235avotfWU6YA=;
        b=W8rJffRYV71y4N1apDYv9u45f0tSvbpHvKDwpm3nssfAoWdK64ZKg/PADQdM4tRYqo
         Cs+q5w6evwHdXX1R6zixFHGzbp9nBvPINOJhow6CcGgxW+j9E5b1+tXX3jUlRY+GiTnR
         feczKLgjJo7aJsIwkClch82wtfTgLfPFP8pPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/dNt1Keysj5w5kx1U0usPx6ojSMc5N235avotfWU6YA=;
        b=SzJ1s1ktUq6zHo8LvlwjVzIqV/McdqkHiH0/LEbe6Sb0snXO2ZgeyritDd7uJwaxx1
         Cf/QSEjK9D0nmigIZTJ7XUF6IRWA4hiBlz9Mz56wJWButUhC1tofQPiwWX9EYhAsQyjX
         v7MvbRZW8EFO1IDYbz+U164u3UHc3QQ9lRWP9C5iaoQQZPAaUvpYP1il0ngT8TMFlo8H
         Co2VlBJOJdz2jPA29AjdFC0LhDnixqfQ322aC3CaUrCRn9nqh3HpqOAvsMxu5ZJ8qLxP
         jVfx+C0CcWYqzxAov8oUs5hj8hajKlnD9wWP+FDSW+XpbK4kVUIF4ss4MKCE/5XWrtAs
         gF8A==
X-Gm-Message-State: AOAM531bTGJld9R8XrB4kfJyHMydmFG30iS/TiMa1EC/wrVaSEaq1oj4
        v1h5EVlGpO0piOb62sePfxUPkw==
X-Google-Smtp-Source: ABdhPJy3Ao0DEeKsGJVVvU+PG/XtihYJiA8BmHPtNrfQogfOXnNhe+XFMak8iwZiEShs2SILySeh4w==
X-Received: by 2002:a17:90a:eac7:: with SMTP id ev7mr768418pjb.21.1594066649958;
        Mon, 06 Jul 2020 13:17:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j13sm296124pjz.8.2020.07.06.13.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:17:27 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v6 2/7] fs: Move __scm_install_fd() to __receive_fd()
Date:   Mon,  6 Jul 2020 13:17:15 -0700
Message-Id: <20200706201720.3482959-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706201720.3482959-1-keescook@chromium.org>
References: <20200706201720.3482959-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for users of the "install a received file" logic outside
of net/ (pidfd and seccomp), relocate and rename __scm_install_fd() from
net/core/scm.c to __receive_fd() in fs/file.c, and provide a wrapper
named receive_fd_user(), as future patches will change the interface
to __receive_fd().

Reviewed-by: Sargun Dhillon <sargun@sargun.me>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/file.c            | 48 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/file.h |  8 ++++++++
 include/linux/net.h  |  9 +++++++++
 include/net/scm.h    |  1 -
 net/compat.c         |  2 +-
 net/core/scm.c       | 32 +----------------------------
 6 files changed, 67 insertions(+), 33 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index abb8b7081d7a..3bd67233088b 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/net.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/file.h>
@@ -18,6 +19,8 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
+#include <net/cls_cgroup.h>
+#include <net/netprio_cgroup.h>
 
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
 unsigned int sysctl_nr_open_min = BITS_PER_LONG;
@@ -931,6 +934,51 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
 	return err;
 }
 
+/**
+ * __receive_fd() - Install received file into file descriptor table
+ *
+ * @file: struct file that was received from another process
+ * @ufd: __user pointer to write new fd number to
+ * @o_flags: the O_* flags to apply to the new fd entry
+ *
+ * Installs a received file into the file descriptor table, with appropriate
+ * checks and count updates. Writes the fd number to userspace.
+ *
+ * This helper handles its own reference counting of the incoming
+ * struct file.
+ *
+ * Returns -ve on error.
+ */
+int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
+{
+	struct socket *sock;
+	int new_fd;
+	int error;
+
+	error = security_file_receive(file);
+	if (error)
+		return error;
+
+	new_fd = get_unused_fd_flags(o_flags);
+	if (new_fd < 0)
+		return new_fd;
+
+	error = put_user(new_fd, ufd);
+	if (error) {
+		put_unused_fd(new_fd);
+		return error;
+	}
+
+	/* Bump the usage count and install the file. */
+	sock = sock_from_file(file, &error);
+	if (sock) {
+		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
+		sock_update_classid(&sock->sk->sk_cgrp_data);
+	}
+	fd_install(new_fd, get_file(file));
+	return 0;
+}
+
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
diff --git a/include/linux/file.h b/include/linux/file.h
index 122f80084a3e..b14ff2ffd0bd 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -91,6 +91,14 @@ extern void put_unused_fd(unsigned int fd);
 
 extern void fd_install(unsigned int fd, struct file *file);
 
+extern int __receive_fd(struct file *file, int __user *ufd,
+			unsigned int o_flags);
+static inline int receive_fd_user(struct file *file, int __user *ufd,
+				  unsigned int o_flags)
+{
+	return __receive_fd(file, ufd, o_flags);
+}
+
 extern void flush_delayed_fput(void);
 extern void __fput_sync(struct file *);
 
diff --git a/include/linux/net.h b/include/linux/net.h
index 016a9c5faa34..0ca550d0f6a6 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -240,7 +240,16 @@ int sock_sendmsg(struct socket *sock, struct msghdr *msg);
 int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags);
 struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname);
 struct socket *sockfd_lookup(int fd, int *err);
+
+#ifdef CONFIG_NET
 struct socket *sock_from_file(struct file *file, int *err);
+#else
+static inline struct socket *sock_from_file(struct file *file, int *err)
+{
+	return NULL;
+}
+#endif
+
 #define		     sockfd_put(sock) fput(sock->file)
 int net_ratelimit(void);
 
diff --git a/include/net/scm.h b/include/net/scm.h
index 581a94d6c613..1ce365f4c256 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -37,7 +37,6 @@ struct scm_cookie {
 #endif
 };
 
-int __scm_install_fd(struct file *file, int __user *ufd, unsigned int o_flags);
 void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
 void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
 int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm);
diff --git a/net/compat.c b/net/compat.c
index 27d477fdcaa0..e74cd3dae8b0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -298,7 +298,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
 	int err = 0, i;
 
 	for (i = 0; i < fdmax; i++) {
-		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
+		err = receive_fd_user(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
 			break;
 	}
diff --git a/net/core/scm.c b/net/core/scm.c
index 6151678c73ed..67c166a7820d 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -280,36 +280,6 @@ void put_cmsg_scm_timestamping(struct msghdr *msg, struct scm_timestamping_inter
 }
 EXPORT_SYMBOL(put_cmsg_scm_timestamping);
 
-int __scm_install_fd(struct file *file, int __user *ufd, unsigned int o_flags)
-{
-	struct socket *sock;
-	int new_fd;
-	int error;
-
-	error = security_file_receive(file);
-	if (error)
-		return error;
-
-	new_fd = get_unused_fd_flags(o_flags);
-	if (new_fd < 0)
-		return new_fd;
-
-	error = put_user(new_fd, ufd);
-	if (error) {
-		put_unused_fd(new_fd);
-		return error;
-	}
-
-	/* Bump the usage count and install the file. */
-	sock = sock_from_file(file, &error);
-	if (sock) {
-		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
-		sock_update_classid(&sock->sk->sk_cgrp_data);
-	}
-	fd_install(new_fd, get_file(file));
-	return 0;
-}
-
 static int scm_max_fds(struct msghdr *msg)
 {
 	if (msg->msg_controllen <= sizeof(struct cmsghdr))
@@ -336,7 +306,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 	}
 
 	for (i = 0; i < fdmax; i++) {
-		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
+		err = receive_fd_user(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
 			break;
 	}
-- 
2.25.1

