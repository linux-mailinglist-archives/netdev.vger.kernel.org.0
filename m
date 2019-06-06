Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E571C370C9
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfFFJta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:49:30 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41242 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbfFFJt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:49:29 -0400
Received: by mail-yw1-f68.google.com with SMTP id y185so612040ywy.8
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=47m1H3EuepvbQK2m+zDZ9pUCMtgY68lOLwItt3MbINs=;
        b=gbXe5dANC/ooesQVH0bLzdoZjk4bHc3tFLLqQwrOAN/KMtJfx0fQVn5jB20VVXx51a
         hmVDi67UlCJgXfhLbskmbtiVMbwcoRiVcDZ68n0Qle8lbXNranWgIqGu298dTd173tpM
         sVxLrfcHhS6+cB8KzGy21IKw3WNGXZgUV+TfP5PhEcZLGTOaTpnWsu5TIIwvCAZ96iYd
         YMSUBxZzHiouVwTqGU0ojjsFxHbwgxnVIwZrLqBwa71BzhF31IKHj0IT21zcKcrNlt1H
         8n06llVWlWI/PzKuaORyPpZgoc4WNmMJxYNB2jIrJWmHJWDowF9jekW3P7vrvAurblt0
         XEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=47m1H3EuepvbQK2m+zDZ9pUCMtgY68lOLwItt3MbINs=;
        b=AnY0hzB5HRehnoh8Un2EGMh4t2Hu+fLZ7qo0gdrv2gBTOeUBByLRXRX5HeoqppUEmZ
         0EW+t8+ZoKHouPtYgvJa3xzWXpqmNBoNkckcsNafha/FjX1CPSmqiumAClf+nYAKW+ku
         Qr7JFsL4kLScBLk/3h/hWc007cS9NxE86h6B8p59jiqgABbHFmOEnd6kdRMVOlxpS8j+
         7YaSS24FYTYro88hYuqPQnGh4V6OBFSKMa0DCGQyHEDg5sZfoAcdyZQrDnzt0xBYj+Fl
         D4/yPhWnZ3ASj8nwWT425xKnWt4DhLJTcuEafxghOdoe5r6LNDA2NIg8YyufKi3B0Ijg
         Ojhw==
X-Gm-Message-State: APjAAAX463YBarN8GIDGI5Y+5LKYvi207r/tcE6t5UJkpM+uRJ64V0gM
        z2vbX3sEmnLvjUZBtGeT8RE6hQ==
X-Google-Smtp-Source: APXvYqxF66t0a3Nwp/jN91+wnnrMt+0mAqvqhOPB7ajpZqA8x0HukrlYNJF0SkjJURJdWP+0s+9yTQ==
X-Received: by 2002:a81:3cf:: with SMTP id 198mr14774020ywd.219.1559814568701;
        Thu, 06 Jun 2019 02:49:28 -0700 (PDT)
Received: from localhost.localdomain (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id 85sm357652ywm.64.2019.06.06.02.49.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 02:49:28 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v2 3/4] perf augmented_raw_syscalls: Support arm64 raw syscalls
Date:   Thu,  6 Jun 2019 17:48:44 +0800
Message-Id: <20190606094845.4800-4-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606094845.4800-1-leo.yan@linaro.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for arm64 raw syscall numbers so that we can use
it on arm64 platform.

After applied this patch, we need to specify macro -D__aarch64__ or
-D__x86_64__ in compilation option so Clang can use the corresponding
syscall numbers for arm64 or x86_64 respectively, other architectures
will report failure when compilation.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 .../examples/bpf/augmented_raw_syscalls.c     | 81 +++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/tools/perf/examples/bpf/augmented_raw_syscalls.c b/tools/perf/examples/bpf/augmented_raw_syscalls.c
index 5c4a4e715ae6..a3701a4daf2e 100644
--- a/tools/perf/examples/bpf/augmented_raw_syscalls.c
+++ b/tools/perf/examples/bpf/augmented_raw_syscalls.c
@@ -45,6 +45,83 @@ struct augmented_filename {
 	char		value[PATH_MAX];
 };
 
+#if defined(__aarch64__)
+
+/* syscalls where the first arg is a string */
+#define SYS_OPEN               1024
+#define SYS_STAT               1038
+#define SYS_LSTAT              1039
+#define SYS_ACCESS             1033
+#define SYS_EXECVE              221
+#define SYS_TRUNCATE             45
+#define SYS_CHDIR                49
+#define SYS_RENAME             1034
+#define SYS_MKDIR              1030
+#define SYS_RMDIR              1031
+#define SYS_CREAT              1064
+#define SYS_LINK               1025
+#define SYS_UNLINK             1026
+#define SYS_SYMLINK            1036
+#define SYS_READLINK           1035
+#define SYS_CHMOD              1028
+#define SYS_CHOWN              1029
+#define SYS_LCHOWN             1032
+#define SYS_MKNOD              1027
+#define SYS_STATFS             1056
+#define SYS_PIVOT_ROOT           41
+#define SYS_CHROOT               51
+#define SYS_ACCT                 89
+#define SYS_SWAPON              224
+#define SYS_SWAPOFF             225
+#define SYS_DELETE_MODULE       106
+#define SYS_SETXATTR              5
+#define SYS_LSETXATTR             6
+#define SYS_GETXATTR              8
+#define SYS_LGETXATTR             9
+#define SYS_LISTXATTR            11
+#define SYS_LLISTXATTR           12
+#define SYS_REMOVEXATTR          14
+#define SYS_LREMOVEXATTR         15
+#define SYS_MQ_OPEN             180
+#define SYS_MQ_UNLINK           181
+#define SYS_ADD_KEY             217
+#define SYS_REQUEST_KEY         218
+#define SYS_SYMLINKAT            36
+#define SYS_MEMFD_CREATE        279
+
+/* syscalls where the second arg is a string */
+#define SYS_PWRITE64             68
+#define SYS_RENAME             1034
+#define SYS_QUOTACTL             60
+#define SYS_FSETXATTR             7
+#define SYS_FGETXATTR            10
+#define SYS_FREMOVEXATTR         16
+#define SYS_MQ_TIMEDSEND        182
+#define SYS_REQUEST_KEY         218
+#define SYS_INOTIFY_ADD_WATCH    27
+#define SYS_OPENAT               56
+#define SYS_MKDIRAT              34
+#define SYS_MKNODAT              33
+#define SYS_FCHOWNAT             54
+#define SYS_FUTIMESAT          1066
+#define SYS_NEWFSTATAT         1054
+#define SYS_UNLINKAT             35
+#define SYS_RENAMEAT             38
+#define SYS_LINKAT               37
+#define SYS_READLINKAT           78
+#define SYS_FCHMODAT             53
+#define SYS_FACCESSAT            48
+#define SYS_UTIMENSAT            88
+#define SYS_NAME_TO_HANDLE_AT   264
+#define SYS_FINIT_MODULE        273
+#define SYS_RENAMEAT2           276
+#define SYS_EXECVEAT            281
+#define SYS_STATX               291
+#define SYS_MOVE_MOUNT          429
+#define SYS_FSPICK              433
+
+#elif defined(__x86_64__)
+
 /* syscalls where the first arg is a string */
 #define SYS_OPEN                 2
 #define SYS_STAT                 4
@@ -119,6 +196,10 @@ struct augmented_filename {
 #define SYS_MOVE_MOUNT         429
 #define SYS_FSPICK             433
 
+#else
+#error "unsupported architecture"
+#endif
+
 pid_filter(pids_filtered);
 
 struct augmented_args_filename {
-- 
2.17.1

