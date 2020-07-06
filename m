Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22D2216021
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgGFUSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgGFURb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:17:31 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D2CC08C5F4
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:17:31 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mn17so3952695pjb.4
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NeGEuOn5Gdu36cTzI1MYcONTHIqUzBGw4mjzmKjT3Is=;
        b=SSbOUsKuWYB34s3MNbXTPxWwDjmrxdOTiVzKNN9PwcZZos9cVCgzAVENg+3IjChe20
         mxj27OsN0rBRH5l7v+U2f8Hs0dve78CPW4h5TPmbN/1TCihTUzgbshVuNx6ktmE3BjaE
         nuUpib+9ykdK8Hl4LDvmIslBjLExKO1/ZtsXc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NeGEuOn5Gdu36cTzI1MYcONTHIqUzBGw4mjzmKjT3Is=;
        b=X8LYnXrYNELpzX86+7Q4HkI3Nfc+BMEQDf6SKoCDyAWiWFOqQqnmCO1x8GX8hOrZds
         IGnAHiaPoTvPN3IdAweGMoZZBlxnS1/PgM6kpSpKpIpfF9cIcCas0pRh/oIoRAfmdv+N
         CbdAn8gjTuAuI7A/hyW4p59qxOxIfypcYlbxPyhFjbbWf5Cqcw4PlqahXPodoOp8LcD2
         izVt6I0bjC56pew0FXEwLLkybvWkoDugR7xX06/fbbajb2PI2Ghsmf5LlZYqH331POni
         bK4HXbWMetbgtngwYGZzGDjuPjVAwKeWt8aYY7EqecowoAbj2BOaqqX/gXN4k4Xfvp7K
         oOqg==
X-Gm-Message-State: AOAM530xrL6kYXtwgR9PoiNHFxQpalSieUTpBR5TNJaBb8wJypy7uhoO
        2fleNcKRWG/+an8P2DvlCG9l0CX4l/U=
X-Google-Smtp-Source: ABdhPJyiCY2jcK76mlbN+Hpi7kTDr0QcAVuEepUw78HEZ0/DR7x7a8Y+uZeBWzswupNVrotFHVifWw==
X-Received: by 2002:a17:902:b212:: with SMTP id t18mr41109128plr.219.1594066650775;
        Mon, 06 Jul 2020 13:17:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u188sm17334721pfu.26.2020.07.06.13.17.27
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
Subject: [PATCH v6 3/7] fs: Add receive_fd() wrapper for __receive_fd()
Date:   Mon,  6 Jul 2020 13:17:16 -0700
Message-Id: <20200706201720.3482959-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706201720.3482959-1-keescook@chromium.org>
References: <20200706201720.3482959-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For both pidfd and seccomp, the __user pointer is not used. Update
__receive_fd() to make writing to ufd optional via a NULL check. However,
for the receive_fd_user() wrapper, ufd is NULL checked so an -EFAULT
can be returned to avoid changing the SCM_RIGHTS interface behavior. Add
new wrapper receive_fd() for pidfd and seccomp that does not use the ufd
argument. For the new helper, the allocated fd needs to be returned on
success. Update the existing callers to handle it.

Reviewed-by: Sargun Dhillon <sargun@sargun.me>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/file.c            | 23 +++++++++++++++--------
 include/linux/file.h |  7 +++++++
 net/compat.c         |  2 +-
 net/core/scm.c       |  2 +-
 4 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 3bd67233088b..0efdcf413210 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -942,12 +942,13 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
  * @o_flags: the O_* flags to apply to the new fd entry
  *
  * Installs a received file into the file descriptor table, with appropriate
- * checks and count updates. Writes the fd number to userspace.
+ * checks and count updates. Optionally writes the fd number to userspace, if
+ * @ufd is non-NULL.
  *
  * This helper handles its own reference counting of the incoming
  * struct file.
  *
- * Returns -ve on error.
+ * Returns newly install fd or -ve on error.
  */
 int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
 {
@@ -963,20 +964,26 @@ int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
 	if (new_fd < 0)
 		return new_fd;
 
-	error = put_user(new_fd, ufd);
-	if (error) {
-		put_unused_fd(new_fd);
-		return error;
+	if (ufd) {
+		error = put_user(new_fd, ufd);
+		if (error) {
+			put_unused_fd(new_fd);
+			return error;
+		}
 	}
 
-	/* Bump the usage count and install the file. */
+	/*
+	 * Bump the usage count and install the file. The resulting value of
+	 * "error" is ignored here since we only need to take action when
+	 * the file is a socket and testing "sock" for NULL is sufficient.
+	 */
 	sock = sock_from_file(file, &error);
 	if (sock) {
 		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
 		sock_update_classid(&sock->sk->sk_cgrp_data);
 	}
 	fd_install(new_fd, get_file(file));
-	return 0;
+	return new_fd;
 }
 
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
diff --git a/include/linux/file.h b/include/linux/file.h
index b14ff2ffd0bd..d9fee9f5c8da 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -9,6 +9,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/posix_types.h>
+#include <linux/errno.h>
 
 struct file;
 
@@ -96,8 +97,14 @@ extern int __receive_fd(struct file *file, int __user *ufd,
 static inline int receive_fd_user(struct file *file, int __user *ufd,
 				  unsigned int o_flags)
 {
+	if (ufd == NULL)
+		return -EFAULT;
 	return __receive_fd(file, ufd, o_flags);
 }
+static inline int receive_fd(struct file *file, unsigned int o_flags)
+{
+	return __receive_fd(file, NULL, o_flags);
+}
 
 extern void flush_delayed_fput(void);
 extern void __fput_sync(struct file *);
diff --git a/net/compat.c b/net/compat.c
index e74cd3dae8b0..dc7ddbc2b15e 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -299,7 +299,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
 
 	for (i = 0; i < fdmax; i++) {
 		err = receive_fd_user(scm->fp->fp[i], cmsg_data + i, o_flags);
-		if (err)
+		if (err < 0)
 			break;
 	}
 
diff --git a/net/core/scm.c b/net/core/scm.c
index 67c166a7820d..8156d4fb8a39 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -307,7 +307,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 
 	for (i = 0; i < fdmax; i++) {
 		err = receive_fd_user(scm->fp->fp[i], cmsg_data + i, o_flags);
-		if (err)
+		if (err < 0)
 			break;
 	}
 
-- 
2.25.1

