Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396B821A6D5
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGIS06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgGIS04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:26:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1BFC08E81E
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 11:26:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u185so1379464pfu.1
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+53mZlohnLFeA12kWmHRKQ2qA700g8Iuk3r7CE3ooh4=;
        b=hCxa4Z8HrAEFROWvjdski3/jn3L0Bs6yprS9zVKhG8mGZD9BX4XRlwmpuFxy58kTXO
         ri3EwDEXMOYc0A1ufiyF9BClWUcuTG12OuFAl4cBUgGdIaVLEc5YR3zfeUVzaqsaoHKU
         Sb8VI46PUy7bJWD8NN7LS0meQJsKCymALNmOQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+53mZlohnLFeA12kWmHRKQ2qA700g8Iuk3r7CE3ooh4=;
        b=oeN8VKtsbP3uVxswc9GxVoxjxRTReWFfua6w3SwzqsXfwnAXhF0hEedsDvarGNMVeX
         Xd9hYfbNW0pWE/ULGPEkbqAOOG8uxyuo1XnxxFVky7S9A1nm6Su/GCiGtkDohom6CG4J
         P1MuZaXZCBc2Iz4QsekU+U1ZSN+NMRsaGBQ2xtXGGFXeHDycckU+nfk3tqbfbPOaLmH5
         H6uTwnhJ4/qezs3BvuQ9u5UeKlPlIEfm1UEXdFYzox7k5+ltIlxWrNWcDJZKhmQ9ZVEz
         +x/SSGS+qwngOKNyAEQ27roWJ7Ht9P/RjzBzdfpu0+k1W4Jv0SgYzYCZHQq6QwWJ7E4O
         afqg==
X-Gm-Message-State: AOAM530eWZWRpBVTkEDREHCqHzWN3B6Qxnn3Q684aiP8y7LVmV3NUI9H
        JsMWzo74p0XpfMn5fy11JA0HkQ==
X-Google-Smtp-Source: ABdhPJxgZOOXm65vrc9zJ7scmr2sWJOctkJc2K6CkPSas/AQFs+nrx4b3TRHfxyqp6k9Ygg4LkGuNQ==
X-Received: by 2002:aa7:9abc:: with SMTP id x28mr34283064pfi.145.1594319213944;
        Thu, 09 Jul 2020 11:26:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t29sm3540656pfq.50.2020.07.09.11.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:26:51 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
Subject: [PATCH v7 5/9] fs: Add receive_fd() wrapper for __receive_fd()
Date:   Thu,  9 Jul 2020 11:26:38 -0700
Message-Id: <20200709182642.1773477-6-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709182642.1773477-1-keescook@chromium.org>
References: <20200709182642.1773477-1-keescook@chromium.org>
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
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/file.c            | 17 ++++++++++-------
 include/linux/file.h |  7 +++++++
 net/compat.c         |  2 +-
 net/core/scm.c       |  2 +-
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 6220bf440809..87954bab9306 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -940,12 +940,13 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
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
@@ -960,16 +961,18 @@ int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
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
 
 	/* Bump the sock usage counts, if any. */
 	__receive_sock(file);
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

