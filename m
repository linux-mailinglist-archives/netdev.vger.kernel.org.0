Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B68248FAC
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgHRUnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgHRUnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:43:47 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAB8C061389;
        Tue, 18 Aug 2020 13:43:44 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id t6so10270428qvw.1;
        Tue, 18 Aug 2020 13:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zoC64zQFv0u25NGOHgqCnOzW2tYOeeYcnO6xQHAtM/8=;
        b=gJS3jjWKZ8yWCa8boIYnPmZVzY9ZzkXwpc4WjSHNW64R3OSuToait7COuKY3Rz2+Ng
         rmj3+kUh3lbMFgQyJi6yy9TBKvEV0EYefX2s+YUZIVK89+PnoFAFX3v3+2fSDuFVDGLs
         6TkHd69ramSt4/q+MBGvnhuCyDH747H/Gt8ulAfowmeFaBHPOvZxrEmsRslTy6iDbWYK
         5DYDd23zqDARQvmF/BDF/2erEFf/fJYTJTvOSKPyQDQ9J0Ve8hIuuZ/i47CKfeSB+B2L
         s0ecIT2yBEXJegoEgc/gQBQqcLUcZ6TvPBpIcfviNFkOWGAfmpb4qkP1fCFDkF1MyLjb
         rFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zoC64zQFv0u25NGOHgqCnOzW2tYOeeYcnO6xQHAtM/8=;
        b=ZnpvKXTz3lArndz1BHqPcDDxAFealcF31+CzVKmwby4n/7404zO7t6XhSbkKo+HcrR
         ry/2xfZjRSJb8Qq1VD4HVkzOiTu5sprIpiZZOZwKusKWIz7xWIPGjoSaj18GLJFr47nx
         wXsZ5xCdm9DNGc7Kw3GYKRxZYLoebO+GzZCUwMvlhW3Uj3DkDz+jnTn3HoboxtEVqsXY
         OuvYKsDlpWzpURN/TJK27bS6ZNMQxWfcHapltcGRfrHdT9FreaJsnwZu/Cm08HJenjsm
         29gAx7zlczWm8OEmHvIwNOVwb5FRSJ1FWqE4LeoGfi2CsF68BXfLIMCVFhVI1sAF+TGq
         cs/Q==
X-Gm-Message-State: AOAM533GSd8BMXY+ZywozSNB1ie7LcfjRECIkUgSC9pR4oyzq6IsKJnD
        oIEQr5rPCr2iHP2Lf/2QWzrnxiqYXR9Atym2FbM=
X-Google-Smtp-Source: ABdhPJznIsZDsN6UfZkr0recA/9RwkBPYiooEYSYRvgAA++at6bqDaeETh2U6LHtPJkVCyqECd+AQg==
X-Received: by 2002:a0c:e102:: with SMTP id w2mr20874450qvk.51.1597783421379;
        Tue, 18 Aug 2020 13:43:41 -0700 (PDT)
Received: from localhost.localdomain (pc-199-79-45-190.cm.vtr.net. [190.45.79.199])
        by smtp.googlemail.com with ESMTPSA id t1sm22045152qkt.119.2020.08.18.13.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 13:43:40 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v5] bpf/selftests: fold test_current_pid_tgid_new_ns into  test_progs.
Date:   Tue, 18 Aug 2020 16:43:25 -0400
Message-Id: <20200818204325.26228-1-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
This change folds a test case into test_progs.

Changes from V4:
 - Added accidentally removed blank space in Makefile.
 - Added () around bit-shift operations.
 - Fixed not valid C89 standard-compliant code.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore        |   2 +-
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../bpf/prog_tests/ns_current_pid_tgid.c      |  85 ----------
 .../bpf/prog_tests/ns_current_pidtgid.c       |  55 ++++++
 .../bpf/progs/test_ns_current_pid_tgid.c      |  37 ----
 .../bpf/progs/test_ns_current_pidtgid.c       |  25 +++
 .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
 .../bpf/test_ns_current_pidtgid_newns.c       |  91 ++++++++++
 8 files changed, 173 insertions(+), 283 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
 delete mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
 delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
 create mode 100644 tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 1bb204cee853..022055f23592 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -30,8 +30,8 @@ test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
 test_sysctl
-test_current_pid_tgid_new_ns
 xdping
+test_ns_current_pidtgid_newns
 test_cpp
 *.skel.h
 /no_alu32
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e7a8cf83ba48..e308cc7c8598 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -37,7 +37,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
 	test_progs-no_alu32 \
-	test_current_pid_tgid_new_ns
+	test_ns_current_pidtgid_newns
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
deleted file mode 100644
index e74dc501b27f..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ /dev/null
@@ -1,85 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
-#include <test_progs.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <unistd.h>
-#include <sys/syscall.h>
-
-struct bss {
-	__u64 dev;
-	__u64 ino;
-	__u64 pid_tgid;
-	__u64 user_pid_tgid;
-};
-
-void test_ns_current_pid_tgid(void)
-{
-	const char *probe_name = "raw_tracepoint/sys_enter";
-	const char *file = "test_ns_current_pid_tgid.o";
-	int err, key = 0, duration = 0;
-	struct bpf_link *link = NULL;
-	struct bpf_program *prog;
-	struct bpf_map *bss_map;
-	struct bpf_object *obj;
-	struct bss bss;
-	struct stat st;
-	__u64 id;
-
-	obj = bpf_object__open_file(file, NULL);
-	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
-		return;
-
-	err = bpf_object__load(obj);
-	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
-		goto cleanup;
-
-	bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
-	if (CHECK(!bss_map, "find_bss_map", "failed\n"))
-		goto cleanup;
-
-	prog = bpf_object__find_program_by_title(obj, probe_name);
-	if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
-		  probe_name))
-		goto cleanup;
-
-	memset(&bss, 0, sizeof(bss));
-	pid_t tid = syscall(SYS_gettid);
-	pid_t pid = getpid();
-
-	id = (__u64) tid << 32 | pid;
-	bss.user_pid_tgid = id;
-
-	if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
-		perror("Failed to stat /proc/self/ns/pid");
-		goto cleanup;
-	}
-
-	bss.dev = st.st_dev;
-	bss.ino = st.st_ino;
-
-	err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
-	if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
-		goto cleanup;
-
-	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
-	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
-		  PTR_ERR(link))) {
-		link = NULL;
-		goto cleanup;
-	}
-
-	/* trigger some syscalls */
-	usleep(1);
-
-	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
-	if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
-		goto cleanup;
-
-	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
-		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
-		goto cleanup;
-cleanup:
-	bpf_link__destroy(link);
-	bpf_object__close(obj);
-}
diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
new file mode 100644
index 000000000000..b11284eec0ee
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include "test_ns_current_pidtgid.skel.h"
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sched.h>
+#include <sys/wait.h>
+#include <sys/mount.h>
+#include <sys/fcntl.h>
+
+void test_ns_current_pidtgid(void)
+{
+	struct test_ns_current_pidtgid__bss  *bss;
+	struct test_ns_current_pidtgid *skel;
+	int err, duration = 0;
+	struct stat st;
+	pid_t tid, pid;
+	__u64 id;
+
+	skel = test_ns_current_pidtgid__open_and_load();
+	CHECK(!skel, "skel_open_load", "failed to load skeleton\n");
+		goto cleanup;
+
+	tid = syscall(SYS_gettid);
+	pid = getpid();
+
+	id = ((__u64)tid << 32) | pid;
+
+	err = stat("/proc/self/ns/pid", &st);
+	if (CHECK(err, "stat", "failed /proc/self/ns/pid: %d", err))
+		goto cleanup;
+
+	bss = skel->bss;
+	bss->dev = st.st_dev;
+	bss->ino = st.st_ino;
+	bss->user_pid_tgid = 0;
+
+	err = test_ns_current_pidtgid__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	CHECK(bss->user_pid_tgid != id, "pid/tgid", "got %llu != exp %llu\n",
+		bss->user_pid_tgid, id);
+cleanup:
+	test_ns_current_pidtgid__destroy(skel);
+
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
deleted file mode 100644
index 1dca70a6de2f..000000000000
--- a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
+++ /dev/null
@@ -1,37 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
-
-#include <linux/bpf.h>
-#include <stdint.h>
-#include <bpf/bpf_helpers.h>
-
-static volatile struct {
-	__u64 dev;
-	__u64 ino;
-	__u64 pid_tgid;
-	__u64 user_pid_tgid;
-} res;
-
-SEC("raw_tracepoint/sys_enter")
-int trace(void *ctx)
-{
-	__u64  ns_pid_tgid, expected_pid;
-	struct bpf_pidns_info nsdata;
-	__u32 key = 0;
-
-	if (bpf_get_ns_current_pid_tgid(res.dev, res.ino, &nsdata,
-		   sizeof(struct bpf_pidns_info)))
-		return 0;
-
-	ns_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
-	expected_pid = res.user_pid_tgid;
-
-	if (expected_pid != ns_pid_tgid)
-		return 0;
-
-	res.pid_tgid = ns_pid_tgid;
-
-	return 0;
-}
-
-char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
new file mode 100644
index 000000000000..1685ff3f9170
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+
+__u64 user_pid_tgid = 0;
+__u64 dev = 0;
+__u64 ino = 0;
+
+SEC("raw_tracepoint/sys_enter")
+int handler(const void *ctx)
+{
+	struct bpf_pidns_info nsdata;
+
+	if (bpf_get_ns_current_pid_tgid(dev, ino, &nsdata,
+		   sizeof(struct bpf_pidns_info)))
+		return 0;
+	user_pid_tgid = ((__u64)nsdata.tgid << 32) | nsdata.pid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c b/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
deleted file mode 100644
index ed253f252cd0..000000000000
--- a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
+++ /dev/null
@@ -1,159 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
-#define _GNU_SOURCE
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <unistd.h>
-#include <sys/syscall.h>
-#include <sched.h>
-#include <sys/wait.h>
-#include <sys/mount.h>
-#include "test_progs.h"
-
-#define CHECK_NEWNS(condition, tag, format...) ({		\
-	int __ret = !!(condition);			\
-	if (__ret) {					\
-		printf("%s:FAIL:%s ", __func__, tag);	\
-		printf(format);				\
-	} else {					\
-		printf("%s:PASS:%s\n", __func__, tag);	\
-	}						\
-	__ret;						\
-})
-
-struct bss {
-	__u64 dev;
-	__u64 ino;
-	__u64 pid_tgid;
-	__u64 user_pid_tgid;
-};
-
-int main(int argc, char **argv)
-{
-	pid_t pid;
-	int exit_code = 1;
-	struct stat st;
-
-	printf("Testing bpf_get_ns_current_pid_tgid helper in new ns\n");
-
-	if (stat("/proc/self/ns/pid", &st)) {
-		perror("stat failed on /proc/self/ns/pid ns\n");
-		printf("%s:FAILED\n", argv[0]);
-		return exit_code;
-	}
-
-	if (CHECK_NEWNS(unshare(CLONE_NEWPID | CLONE_NEWNS),
-			"unshare CLONE_NEWPID | CLONE_NEWNS", "error errno=%d\n", errno))
-		return exit_code;
-
-	pid = fork();
-	if (pid == -1) {
-		perror("Fork() failed\n");
-		printf("%s:FAILED\n", argv[0]);
-		return exit_code;
-	}
-
-	if (pid > 0) {
-		int status;
-
-		usleep(5);
-		waitpid(pid, &status, 0);
-		return 0;
-	} else {
-
-		pid = fork();
-		if (pid == -1) {
-			perror("Fork() failed\n");
-			printf("%s:FAILED\n", argv[0]);
-			return exit_code;
-		}
-
-		if (pid > 0) {
-			int status;
-			waitpid(pid, &status, 0);
-			return 0;
-		} else {
-			if (CHECK_NEWNS(mount("none", "/proc", NULL, MS_PRIVATE|MS_REC, NULL),
-				"Unmounting proc", "Cannot umount proc! errno=%d\n", errno))
-				return exit_code;
-
-			if (CHECK_NEWNS(mount("proc", "/proc", "proc", MS_NOSUID|MS_NOEXEC|MS_NODEV, NULL),
-				"Mounting proc", "Cannot mount proc! errno=%d\n", errno))
-				return exit_code;
-
-			const char *probe_name = "raw_tracepoint/sys_enter";
-			const char *file = "test_ns_current_pid_tgid.o";
-			struct bpf_link *link = NULL;
-			struct bpf_program *prog;
-			struct bpf_map *bss_map;
-			struct bpf_object *obj;
-			int exit_code = 1;
-			int err, key = 0;
-			struct bss bss;
-			struct stat st;
-			__u64 id;
-
-			obj = bpf_object__open_file(file, NULL);
-			if (CHECK_NEWNS(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
-				return exit_code;
-
-			err = bpf_object__load(obj);
-			if (CHECK_NEWNS(err, "obj_load", "err %d errno %d\n", err, errno))
-				goto cleanup;
-
-			bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
-			if (CHECK_NEWNS(!bss_map, "find_bss_map", "failed\n"))
-				goto cleanup;
-
-			prog = bpf_object__find_program_by_title(obj, probe_name);
-			if (CHECK_NEWNS(!prog, "find_prog", "prog '%s' not found\n",
-						probe_name))
-				goto cleanup;
-
-			memset(&bss, 0, sizeof(bss));
-			pid_t tid = syscall(SYS_gettid);
-			pid_t pid = getpid();
-
-			id = (__u64) tid << 32 | pid;
-			bss.user_pid_tgid = id;
-
-			if (CHECK_NEWNS(stat("/proc/self/ns/pid", &st),
-				"stat new ns", "Failed to stat /proc/self/ns/pid errno=%d\n", errno))
-				goto cleanup;
-
-			bss.dev = st.st_dev;
-			bss.ino = st.st_ino;
-
-			err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
-			if (CHECK_NEWNS(err, "setting_bss", "failed to set bss : %d\n", err))
-				goto cleanup;
-
-			link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
-			if (CHECK_NEWNS(IS_ERR(link), "attach_raw_tp", "err %ld\n",
-						PTR_ERR(link))) {
-				link = NULL;
-				goto cleanup;
-			}
-
-			/* trigger some syscalls */
-			usleep(1);
-
-			err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
-			if (CHECK_NEWNS(err, "set_bss", "failed to get bss : %d\n", err))
-				goto cleanup;
-
-			if (CHECK_NEWNS(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
-						"User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
-				goto cleanup;
-
-			exit_code = 0;
-			printf("%s:PASS\n", argv[0]);
-cleanup:
-			if (!link) {
-				bpf_link__destroy(link);
-				link = NULL;
-			}
-			bpf_object__close(obj);
-		}
-	}
-}
diff --git a/tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c b/tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
new file mode 100644
index 000000000000..34e3f05efd94
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include "test_ns_current_pidtgid.skel.h"
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sched.h>
+#include <sys/wait.h>
+#include <sys/mount.h>
+#include <sys/fcntl.h>
+
+#define STACK_SIZE (1024 * 1024)
+static char child_stack[STACK_SIZE];
+
+static int newns_pidtgid(void *arg)
+{
+	struct test_ns_current_pidtgid__bss  *bss;
+	struct test_ns_current_pidtgid *skel;
+	int pidns_fd = 0, err = 0;
+	pid_t pid, tid;
+	struct stat st;
+	__u64 id;
+
+	skel = test_ns_current_pidtgid__open_and_load();
+	if (!skel) {
+		perror("Failed to load skeleton");
+		goto cleanup;
+	}
+
+	tid = syscall(SYS_gettid);
+	pid = getpid();
+	id = ((__u64) tid << 32) | pid;
+
+	if (stat("/proc/self/ns/pid", &st)) {
+		printf("Failed to stat /proc/self/ns/pid: %s\n",
+			strerror(errno));
+		goto cleanup;
+	}
+
+	bss = skel->bss;
+	bss->dev = st.st_dev;
+	bss->ino = st.st_ino;
+	bss->user_pid_tgid = 0;
+
+	err = test_ns_current_pidtgid__attach(skel);
+	if (err) {
+		printf("Failed to attach: %s err: %d\n", strerror(errno), err);
+		goto cleanup;
+	}
+	/* trigger tracepoint */
+	usleep(1);
+
+	if (bss->user_pid_tgid != id) {
+		printf("test_ns_current_pidtgid_newns:FAIL\n");
+		err = EXIT_FAILURE;
+	} else {
+		printf("test_ns_current_pidtgid_newns:PASS\n");
+		err = EXIT_SUCCESS;
+	}
+
+cleanup:
+	setns(pidns_fd, CLONE_NEWPID);
+	test_ns_current_pidtgid__destroy(skel);
+
+	return err;
+}
+
+int main(int argc, char **argv)
+{
+	pid_t cpid;
+	int wstatus;
+
+	cpid = clone(newns_pidtgid,
+			child_stack + STACK_SIZE,
+			CLONE_NEWPID | SIGCHLD, NULL);
+	if (cpid == -1) {
+		printf("test_ns_current_pidtgid_newns:Failed on CLONE: %s\n",
+			 strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+	if (waitpid(cpid, &wstatus, 0) == -1) {
+		printf("test_ns_current_pidtgid_newns:Failed on waitpid: %s\n",
+			strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+	return WEXITSTATUS(wstatus);
+}
-- 
2.20.1

