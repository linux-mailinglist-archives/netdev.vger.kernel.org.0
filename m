Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2479A21A6D7
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGIS1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgGIS06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:26:58 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984BEC08E763
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 11:26:56 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l63so1314329pge.12
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YWZ2OuQizQzGzF3RDi6D4WkV24kF9MLp4QDJR72dZB4=;
        b=OsdMigTS1TZ7gryM952/sdzg/vSp6wtxWibgkJLGvPmqDjrer0WjNiB9L1FmFTWcjY
         khB3DYkskNmWM5wLgPkOjeEqFw/hR2hADFK4jSXvi+4ma/PbCm/zjwKQdZdHwu293kEV
         LdaIQ1GAEa/5HEugszrzpwpASI/+Dbp0095aY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YWZ2OuQizQzGzF3RDi6D4WkV24kF9MLp4QDJR72dZB4=;
        b=k5uufKatqhphVD5NLQNuvqT2vv0B0nTBeco70e/Y9WSCYPOfYUlW44Zog0Q4ZwshAS
         Kraas6UUxkqxldmM7pWl159dFU3MC+gxef4dOm8YDIMnkMs+qAPK+WznOhoTaKb0o6wC
         h4E0eEwrz72Pphgq8JscnnWjYnRSuqQolZ2JAi/YdLEwkKsy0BNScwkDhuQHG22h5HOQ
         qD8zgyDbhaYC8tUyNSMJc5q6Fw5FBlngPuuj6pXKv6MV4dUlxcIr5p4hXXlhi/3UCjTL
         LFkGWIohhM4jfMuOSKNHXS0VOkiF5YkmS7gtgjfnf53D1oDjk63S10BLSlLygLV3ohGw
         mtqA==
X-Gm-Message-State: AOAM5309hpVYJQVQbQECrW7afpY5ODKy5UB4HU7svzeWXfXR+slWTNFZ
        CqB/7f2kGNenIDFtjITcZEZuEQ==
X-Google-Smtp-Source: ABdhPJyqxSVtupX3puECtbZi+bMBfwoIQ/EspFx3WlAJYTyT81T+rTNfAyy7jAcXryqqfjECtHDV+Q==
X-Received: by 2002:aa7:8edc:: with SMTP id b28mr48226035pfr.230.1594319216060;
        Thu, 09 Jul 2020 11:26:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d9sm3571541pgv.45.2020.07.09.11.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:26:52 -0700 (PDT)
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
Subject: [PATCH v7 9/9] selftests/seccomp: Test SECCOMP_IOCTL_NOTIF_ADDFD
Date:   Thu,  9 Jul 2020 11:26:42 -0700
Message-Id: <20200709182642.1773477-10-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709182642.1773477-1-keescook@chromium.org>
References: <20200709182642.1773477-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

Test whether we can add file descriptors in response to notifications.
This injects the file descriptors via notifications, and then uses kcmp
to determine whether or not it has been successful.

It also includes some basic sanity checking for arguments.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Link: https://lore.kernel.org/r/20200603011044.7972-5-sargun@sargun.me
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 229 ++++++++++++++++++
 1 file changed, 229 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 4662a25bc9e8..3f41b32b9165 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -45,6 +45,7 @@
 #include <sys/socket.h>
 #include <sys/ioctl.h>
 #include <linux/kcmp.h>
+#include <sys/resource.h>
 
 #include <unistd.h>
 #include <sys/syscall.h>
@@ -168,7 +169,9 @@ struct seccomp_metadata {
 
 #ifndef SECCOMP_FILTER_FLAG_NEW_LISTENER
 #define SECCOMP_FILTER_FLAG_NEW_LISTENER	(1UL << 3)
+#endif
 
+#ifndef SECCOMP_RET_USER_NOTIF
 #define SECCOMP_RET_USER_NOTIF 0x7fc00000U
 
 #define SECCOMP_IOC_MAGIC		'!'
@@ -204,6 +207,39 @@ struct seccomp_notif_sizes {
 };
 #endif
 
+#ifndef SECCOMP_IOCTL_NOTIF_ADDFD
+/* On success, the return value is the remote process's added fd number */
+#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOW(3,	\
+						struct seccomp_notif_addfd)
+
+/* valid flags for seccomp_notif_addfd */
+#define SECCOMP_ADDFD_FLAG_SETFD	(1UL << 0) /* Specify remote fd */
+
+struct seccomp_notif_addfd {
+	__u64 id;
+	__u32 flags;
+	__u32 srcfd;
+	__u32 newfd;
+	__u32 newfd_flags;
+};
+#endif
+
+struct seccomp_notif_addfd_small {
+	__u64 id;
+	char weird[4];
+};
+#define SECCOMP_IOCTL_NOTIF_ADDFD_SMALL	\
+	SECCOMP_IOW(3, struct seccomp_notif_addfd_small)
+
+struct seccomp_notif_addfd_big {
+	union {
+		struct seccomp_notif_addfd addfd;
+		char buf[sizeof(struct seccomp_notif_addfd) + 8];
+	};
+};
+#define SECCOMP_IOCTL_NOTIF_ADDFD_BIG	\
+	SECCOMP_IOWR(3, struct seccomp_notif_addfd_big)
+
 #ifndef PTRACE_EVENTMSG_SYSCALL_ENTRY
 #define PTRACE_EVENTMSG_SYSCALL_ENTRY	1
 #define PTRACE_EVENTMSG_SYSCALL_EXIT	2
@@ -3740,6 +3776,199 @@ TEST(user_notification_filter_empty_threaded)
 	EXPECT_GT((pollfd.revents & POLLHUP) ?: 0, 0);
 }
 
+TEST(user_notification_addfd)
+{
+	pid_t pid;
+	long ret;
+	int status, listener, memfd, fd;
+	struct seccomp_notif_addfd addfd = {};
+	struct seccomp_notif_addfd_small small = {};
+	struct seccomp_notif_addfd_big big = {};
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+	/* 100 ms */
+	struct timespec delay = { .tv_nsec = 100000000 };
+
+	memfd = memfd_create("test", 0);
+	ASSERT_GE(memfd, 0);
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	/* Check that the basic notification machinery works */
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (syscall(__NR_getppid) != USER_NOTIF_MAGIC)
+			exit(1);
+		exit(syscall(__NR_getppid) != USER_NOTIF_MAGIC);
+	}
+
+	ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+
+	addfd.srcfd = memfd;
+	addfd.newfd = 0;
+	addfd.id = req.id;
+	addfd.flags = 0x0;
+
+	/* Verify bad newfd_flags cannot be set */
+	addfd.newfd_flags = ~O_CLOEXEC;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EINVAL);
+	addfd.newfd_flags = O_CLOEXEC;
+
+	/* Verify bad flags cannot be set */
+	addfd.flags = 0xff;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EINVAL);
+	addfd.flags = 0;
+
+	/* Verify that remote_fd cannot be set without setting flags */
+	addfd.newfd = 1;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EINVAL);
+	addfd.newfd = 0;
+
+	/* Verify small size cannot be set */
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD_SMALL, &small), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	/* Verify we can't send bits filled in unknown buffer area */
+	memset(&big, 0xAA, sizeof(big));
+	big.addfd = addfd;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD_BIG, &big), -1);
+	EXPECT_EQ(errno, E2BIG);
+
+
+	/* Verify we can set an arbitrary remote fd */
+	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd);
+	/*
+	 * The child has fds 0(stdin), 1(stdout), 2(stderr), 3(memfd),
+	 * 4(listener), so the newly allocated fd should be 5.
+	 */
+	EXPECT_EQ(fd, 5);
+	EXPECT_EQ(filecmp(getpid(), pid, memfd, fd), 0);
+
+	/* Verify we can set an arbitrary remote fd with large size */
+	memset(&big, 0x0, sizeof(big));
+	big.addfd = addfd;
+	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD_BIG, &big);
+	EXPECT_EQ(fd, 6);
+
+	/* Verify we can set a specific remote fd */
+	addfd.newfd = 42;
+	addfd.flags = SECCOMP_ADDFD_FLAG_SETFD;
+	fd = ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd);
+	EXPECT_EQ(fd, 42);
+	EXPECT_EQ(filecmp(getpid(), pid, memfd, fd), 0);
+
+	/* Resume syscall */
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
+
+	/*
+	 * This sets the ID of the ADD FD to the last request plus 1. The
+	 * notification ID increments 1 per notification.
+	 */
+	addfd.id = req.id + 1;
+
+	/* This spins until the underlying notification is generated */
+	while (ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd) != -1 &&
+	       errno != -EINPROGRESS)
+		nanosleep(&delay, NULL);
+
+	memset(&req, 0, sizeof(req));
+	ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+	ASSERT_EQ(addfd.id, req.id);
+
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
+
+	/* Wait for child to finish. */
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	close(memfd);
+}
+
+TEST(user_notification_addfd_rlimit)
+{
+	pid_t pid;
+	long ret;
+	int status, listener, memfd;
+	struct seccomp_notif_addfd addfd = {};
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+	const struct rlimit lim = {
+		.rlim_cur	= 0,
+		.rlim_max	= 0,
+	};
+
+	memfd = memfd_create("test", 0);
+	ASSERT_GE(memfd, 0);
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	/* Check that the basic notification machinery works */
+	listener = user_notif_syscall(__NR_getppid,
+				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	ASSERT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0)
+		exit(syscall(__NR_getppid) != USER_NOTIF_MAGIC);
+
+
+	ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+
+	ASSERT_EQ(prlimit(pid, RLIMIT_NOFILE, &lim, NULL), 0);
+
+	addfd.srcfd = memfd;
+	addfd.newfd_flags = O_CLOEXEC;
+	addfd.newfd = 0;
+	addfd.id = req.id;
+	addfd.flags = 0;
+
+	/* Should probably spot check /proc/sys/fs/file-nr */
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EMFILE);
+
+	addfd.newfd = 100;
+	addfd.flags = SECCOMP_ADDFD_FLAG_SETFD;
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ADDFD, &addfd), -1);
+	EXPECT_EQ(errno, EBADF);
+
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+
+	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
+
+	/* Wait for child to finish. */
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	close(memfd);
+}
+
 /*
  * TODO:
  * - expand NNP testing
-- 
2.25.1

