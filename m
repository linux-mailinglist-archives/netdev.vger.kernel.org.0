Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFEF21A6EF
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGIS0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgGIS0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:26:50 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F2CC08E81E
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 11:26:50 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k5so1478949pjg.3
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gBY5M3TNmTDqA1bjL3Jjd2nDvBr+rR1mQXBFsWn1CQs=;
        b=Z/SBBrai2x+BBSEUc6N28u3SdpQIVYQvqvzxgZa++Q+lxnUT3SQS6C93G+gyNmDJyp
         G9NKXhnct9cCfT8hHvBPH034zHim5LwRyp/AVC+53x6uR5vefh90fzKhwuPFhy87LK/W
         bhuamtkXjM0DqKh3bzbohWkiK158TXa8btjoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gBY5M3TNmTDqA1bjL3Jjd2nDvBr+rR1mQXBFsWn1CQs=;
        b=PkGfzmyosa6Gqq9ir7t2MQXTJCXFBfbVz+rsynfvuIgDtkqSZ4UM/hADVLIh66wpjg
         WS5mHVemMmQVrCaKSQQ9v+uIFE0aDY43LGnUryahe+Gl7tonJ3X8HZ+XppbUhth+Gu2c
         t7PetG8mY9CzGFAjLk+BOHgLUaJ8sjKgT3/1txsWOhxXvjLVLnmP7G8qQdqltZHTHMy0
         AmI1OxchbX97F7AvFE39b7ZYV8L9kUM0pvblNjKYcNZMP7GWI7x+80Rh+LBvnyeAHmT1
         S4D/KZQg0lT3yJrn9FpUrxXUOfmA0IrnmqGz0A2o4YMucsfGOKkcK5rKdwGKdnbeUBrs
         elzA==
X-Gm-Message-State: AOAM531SwJJiYDLYqaUowDMosfTv6dKM7QxEGHhVsXlbj2zNPRNlH/X/
        WkflWDVH7rGPWhh7PgmMX4cfiw==
X-Google-Smtp-Source: ABdhPJx4h/+lsPEnqV3d2BF+grHojn5a/CNAZlzUT8KQsoJV3wNBqQhfg3tjN57T9DNZlJUXNEMcpw==
X-Received: by 2002:a17:902:bcc1:: with SMTP id o1mr54297569pls.246.1594319209945;
        Thu, 09 Jul 2020 11:26:49 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d190sm3351764pfd.199.2020.07.09.11.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:26:47 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
Subject: [PATCH v7 3/9] net/scm: Regularize compat handling of scm_detach_fds()
Date:   Thu,  9 Jul 2020 11:26:36 -0700
Message-Id: <20200709182642.1773477-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709182642.1773477-1-keescook@chromium.org>
References: <20200709182642.1773477-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Duplicate the cleanups from commit 2618d530dd8b ("net/scm: cleanup
scm_detach_fds") into the compat code.

Replace open-coded __receive_sock() with a call to the helper.

Move the check added in commit 1f466e1f15cf ("net: cleanly handle kernel
vs user buffers for ->msg_control") to before the compat call, even
though it should be impossible for an in-kernel call to also be compat.

Correct the int "flags" argument to unsigned int to match fd_install()
and similar APIs.

Regularize any remaining differences, including a whitespace issue,
a checkpatch warning, and add the check from commit 6900317f5eff ("net,
scm: fix PaX detected msg_controllen overflow in scm_detach_fds") which
fixed an overflow unique to 64-bit. To avoid confusion when comparing
the compat handler to the native handler, just include the same check
in the compat handler.

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/scm.h |  1 +
 net/compat.c      | 56 +++++++++++++++++++++--------------------------
 net/core/scm.c    | 27 ++++++++++-------------
 3 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index 1ce365f4c256..581a94d6c613 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -37,6 +37,7 @@ struct scm_cookie {
 #endif
 };
 
+int __scm_install_fd(struct file *file, int __user *ufd, unsigned int o_flags);
 void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
 void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
 int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm);
diff --git a/net/compat.c b/net/compat.c
index 2937b816107d..27d477fdcaa0 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -281,40 +281,31 @@ int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *dat
 	return 0;
 }
 
-void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
+static int scm_max_fds_compat(struct msghdr *msg)
 {
-	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control;
-	int fdmax = (kmsg->msg_controllen - sizeof(struct compat_cmsghdr)) / sizeof(int);
-	int fdnum = scm->fp->count;
-	struct file **fp = scm->fp->fp;
-	int __user *cmfptr;
-	int err = 0, i;
+	if (msg->msg_controllen <= sizeof(struct compat_cmsghdr))
+		return 0;
+	return (msg->msg_controllen - sizeof(struct compat_cmsghdr)) / sizeof(int);
+}
 
-	if (fdnum < fdmax)
-		fdmax = fdnum;
+void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
+{
+	struct compat_cmsghdr __user *cm =
+		(struct compat_cmsghdr __user *)msg->msg_control;
+	unsigned int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
+	int fdmax = min_t(int, scm_max_fds_compat(msg), scm->fp->count);
+	int __user *cmsg_data = CMSG_USER_DATA(cm);
+	int err = 0, i;
 
-	for (i = 0, cmfptr = (int __user *) CMSG_COMPAT_DATA(cm); i < fdmax; i++, cmfptr++) {
-		int new_fd;
-		err = security_file_receive(fp[i]);
+	for (i = 0; i < fdmax; i++) {
+		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
 			break;
-		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & kmsg->msg_flags
-					  ? O_CLOEXEC : 0);
-		if (err < 0)
-			break;
-		new_fd = err;
-		err = put_user(new_fd, cmfptr);
-		if (err) {
-			put_unused_fd(new_fd);
-			break;
-		}
-		/* Bump the usage count and install the file. */
-		__receive_sock(fp[i]);
-		fd_install(new_fd, get_file(fp[i]));
 	}
 
 	if (i > 0) {
 		int cmlen = CMSG_COMPAT_LEN(i * sizeof(int));
+
 		err = put_user(SOL_SOCKET, &cm->cmsg_level);
 		if (!err)
 			err = put_user(SCM_RIGHTS, &cm->cmsg_type);
@@ -322,16 +313,19 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 			err = put_user(cmlen, &cm->cmsg_len);
 		if (!err) {
 			cmlen = CMSG_COMPAT_SPACE(i * sizeof(int));
-			kmsg->msg_control += cmlen;
-			kmsg->msg_controllen -= cmlen;
+			if (msg->msg_controllen < cmlen)
+				cmlen = msg->msg_controllen;
+			msg->msg_control += cmlen;
+			msg->msg_controllen -= cmlen;
 		}
 	}
-	if (i < fdnum)
-		kmsg->msg_flags |= MSG_CTRUNC;
+
+	if (i < scm->fp->count || (scm->fp->count && fdmax <= 0))
+		msg->msg_flags |= MSG_CTRUNC;
 
 	/*
-	 * All of the files that fit in the message have had their
-	 * usage counts incremented, so we just free the list.
+	 * All of the files that fit in the message have had their usage counts
+	 * incremented, so we just free the list.
 	 */
 	__scm_destroy(scm);
 }
diff --git a/net/core/scm.c b/net/core/scm.c
index 875df1c2989d..44f03213dcab 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -280,9 +280,8 @@ void put_cmsg_scm_timestamping(struct msghdr *msg, struct scm_timestamping_inter
 }
 EXPORT_SYMBOL(put_cmsg_scm_timestamping);
 
-static int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
+int __scm_install_fd(struct file *file, int __user *ufd, unsigned int o_flags)
 {
-	struct socket *sock;
 	int new_fd;
 	int error;
 
@@ -300,12 +299,8 @@ static int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
 		return error;
 	}
 
-	/* Bump the usage count and install the file. */
-	sock = sock_from_file(file, &error);
-	if (sock) {
-		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
-		sock_update_classid(&sock->sk->sk_cgrp_data);
-	}
+	/* Bump the sock usage counts, if any. */
+	__receive_sock(file);
 	fd_install(new_fd, get_file(file));
 	return 0;
 }
@@ -319,29 +314,29 @@ static int scm_max_fds(struct msghdr *msg)
 
 void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 {
-	struct cmsghdr __user *cm
-		= (__force struct cmsghdr __user*)msg->msg_control;
-	int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
+	struct cmsghdr __user *cm =
+		(__force struct cmsghdr __user *)msg->msg_control;
+	unsigned int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
 	int fdmax = min_t(int, scm_max_fds(msg), scm->fp->count);
 	int __user *cmsg_data = CMSG_USER_DATA(cm);
 	int err = 0, i;
 
+	/* no use for FD passing from kernel space callers */
+	if (WARN_ON_ONCE(!msg->msg_control_is_user))
+		return;
+
 	if (msg->msg_flags & MSG_CMSG_COMPAT) {
 		scm_detach_fds_compat(msg, scm);
 		return;
 	}
 
-	/* no use for FD passing from kernel space callers */
-	if (WARN_ON_ONCE(!msg->msg_control_is_user))
-		return;
-
 	for (i = 0; i < fdmax; i++) {
 		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
 		if (err)
 			break;
 	}
 
-	if (i > 0)  {
+	if (i > 0) {
 		int cmlen = CMSG_LEN(i * sizeof(int));
 
 		err = put_user(SOL_SOCKET, &cm->cmsg_level);
-- 
2.25.1

