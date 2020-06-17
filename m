Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988A41FD83C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgFQWES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 18:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgFQWDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 18:03:35 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3FCC061797
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 15:03:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e18so1940265pgn.7
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 15:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eJ8w8RlGTgKwSve8kq67XCo8awUqV+HYghFRfD7mOnw=;
        b=khHJTxzOcpg3WW5hLAFpnEq6H4kaSxxC0QdAupbyEi/SkYZXIQpq4Sx73NWNUwfQR+
         CTqRAET0tfT3MoL8TzGYvwdrDxJ2aCWf+oE63mVvjr8urvd89xQ/N378XJsE04oMtIMi
         Z2ZYnkIEBKX39kTeCgm+TQ/it/TFwFS4bbTV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJ8w8RlGTgKwSve8kq67XCo8awUqV+HYghFRfD7mOnw=;
        b=tN8JNwy5qZlciEk0VafogDI+gfXlx3Tsj1l2Ob5nYuAwJY6KzoGo6DIDkZSNhRMJkk
         gXzWwPsjnG9acHY3gET3LjAVmlhXTNS7mpH0qQLqnYxFJzRQFnBoo84OcRwFrEto1wWh
         sR4bk/TUvKRrHt+rsvtga9Pzjoz///hkpvCNG3F2sAK7y8qaQo6eTxO5Qt+lXKr2V6FV
         oHWV3afOSJw5BkePO/OxmzsHNSNran6r9M2oiJDP0ej+QNQqfbU9n+K/pI+VZA1d5LUx
         RMnvm1z6BIwvoBfwe24z0mssLry3ebus9U0MUMp48k/KitIiu2aRjHsgVVw9rz+In8BN
         nKqg==
X-Gm-Message-State: AOAM530c6bXzxo7KswlayqUWMXIc9J02yGMmBKODT4jsuSRWi4+/Cthl
        u+b+jYPAeFb7wnBlC6ssHKYPzg==
X-Google-Smtp-Source: ABdhPJzfVk7O7EvLgEU3fkwifOsBFdREevvolrDbGInAARblPmWxv5XpCBmdblaIrL4B0RjyWF9I0g==
X-Received: by 2002:a65:6916:: with SMTP id s22mr816271pgq.128.1592431412861;
        Wed, 17 Jun 2020 15:03:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 9sm759447pfu.181.2020.06.17.15.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 15:03:30 -0700 (PDT)
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
Subject: [PATCH v5 2/7] fs: Move __scm_install_fd() to __fd_install_received()
Date:   Wed, 17 Jun 2020 15:03:22 -0700
Message-Id: <20200617220327.3731559-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200617220327.3731559-1-keescook@chromium.org>
References: <20200617220327.3731559-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for users of the "install a received file" logic outside
of net/ (pidfd and seccomp), relocate and rename __scm_install_fd() from
net/core/scm.c to __fd_install_received() in fs/file.c, and provide a
wrapper named fd_install_received_user(), as future patches will change
the interface to __fd_install_received().

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/file.c            | 45 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/file.h |  8 ++++++++
 include/net/scm.h    |  1 -
 net/compat.c         |  2 +-
 net/core/scm.c       | 32 +------------------------------
 5 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index abb8b7081d7a..f2167d6feec6 100644
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
@@ -931,6 +934,48 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
 	return err;
 }
 
+/**
+ * __fd_install_received() - Install received file into file descriptor table
+ *
+ * @file: struct file that was received from another process
+ * @ufd: __user pointer to write new fd number to
+ * @o_flags: the O_* flags to apply to the new fd entry
+ *
+ * Installs a received file into the file descriptor table, with appropriate
+ * checks and count updates. Writes the fd number to userspace.
+ *
+ * Returns -ve on error.
+ */
+int __fd_install_received(struct file *file, int __user *ufd, unsigned int o_flags)
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
index 122f80084a3e..fe18a1a0d555 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -91,6 +91,14 @@ extern void put_unused_fd(unsigned int fd);
 
 extern void fd_install(unsigned int fd, struct file *file);
 
+extern int __fd_install_received(struct file *file, int __user *ufd,
+				 unsigned int o_flags);
+static inline int fd_install_received_user(struct file *file, int __user *ufd,
+					   unsigned int o_flags)
+{
+	return __fd_install_received(file, ufd, o_flags);
+}
+
 extern void flush_delayed_fput(void);
 extern void __fput_sync(struct file *);
 
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
index 27d477fdcaa0..94f288e8dac5 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -298,7 +298,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
 	int err = 0, i;
 
 	for (i = 0; i < fdmax; i++) {
-		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
+		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
 			break;
 	}
diff --git a/net/core/scm.c b/net/core/scm.c
index 6151678c73ed..df190f1fdd28 100644
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
+		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
 			break;
 	}
-- 
2.25.1

