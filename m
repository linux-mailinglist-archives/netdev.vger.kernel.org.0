Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A132E63F1
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 16:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632734AbgL1Pp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 10:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504296AbgL1PpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 10:45:25 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B997BC061796;
        Mon, 28 Dec 2020 07:44:44 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id c7so9116826qke.1;
        Mon, 28 Dec 2020 07:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=m/vIPI/exk1gUlD0hLcE3ctLkKf2mxwJdOzNwjKIkL0=;
        b=a1TreTGj5mVwaDxgCMMPQAP8Usex6YfESKAJSaN6geeVrAnGqOZGEBd/6XJt8eVr9L
         UJQNJ0ihOGUuuSeuiuM8AD5xT6KoyWuAuH+ihccAOmTx666QbWoChEYx5crHUnttJzAN
         7CKuHkp5bCwsJPwyLbg0MjFa5IpaimZUCGd3N6iUHkJTZzlO0BAd3dA6dOfdcDjsEuHt
         O00U+7Uj+cdmUug5b88/1KIQmDDzygcgcIdKHsqHOc9tJLJmSJiD15Olq+q8zwUVSp7t
         LcOWiLCxVW6F/QYiAVrXEqhUMUzAPgEN92oyx9Fhar0jczB0hCZnkM+B4LjI+AqKvAYg
         6J+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=m/vIPI/exk1gUlD0hLcE3ctLkKf2mxwJdOzNwjKIkL0=;
        b=gnES8kHTyuZRZc7FZWydysQGxCVu1NnZAg2c4gzdbIAfofqgWWQ11uHYlCSIFAkP4R
         CqRCbTKylHnW/l+zpwAdlINAcXMU/D+uJA6dmgEy63rh5zUaQupY2D7qLsQ2rCYvFn7z
         suYmZRbIOHF2rrRXOkeeBU7QJN+u/Bz7BTcSQ8odBltTIsyotAZuBJEgj/wOnjv3hLha
         avEawnl9QLuxJ6OOP1kWOQu/V58x/h+dNKlJ5ccqHlG3Rc3lW7EsDeGO5RuIkmx0UIvP
         ZFeo2FpCxV5cUy82ZfRiiMh/r/R080l6tvmZAc7l6e8ZVOvh2nq4oDqtN9wCBet00n1r
         bEyw==
X-Gm-Message-State: AOAM532Xhd2bb0CQlYZELW904A5fTXId0v6NaFyQPKBYjgfWCQD4Efm+
        fotW6BjHGmpyQG1c8Sf6YleRzRsY3L+hbjXBLnU=
X-Google-Smtp-Source: ABdhPJxgjP/3gkDaq9B25F/lq+9Mr98bVvLbF0Fr4nuBjpB2g8vDb4juWlu1Tn38oleKSaCHfRrqxA==
X-Received: by 2002:a37:78c4:: with SMTP id t187mr1837125qkc.139.1609170283669;
        Mon, 28 Dec 2020 07:44:43 -0800 (PST)
Received: from localhost (pc-145-79-45-190.cm.vtr.net. [190.45.79.145])
        by smtp.gmail.com with ESMTPSA id g28sm23383939qtm.91.2020.12.28.07.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 07:44:43 -0800 (PST)
Date:   Mon, 28 Dec 2020 12:44:39 -0300
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andriin@fb.com, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v11 bpf-next] bpf/selftests: fold
 test_current_pid_tgid_new_ns into test_progs.
Message-ID: <20201228154437.GA18684@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
This change folds test cases into test_progs.

Changes from v10:

 - Code style fixes.
 - Remove redundant code.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 -
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 118 ++++++-------
 .../bpf/progs/test_ns_current_pid_tgid.c      |  28 +--
 .../bpf/test_current_pid_tgid_new_ns.c        | 160 ------------------
 5 files changed, 69 insertions(+), 241 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index f5b7ef93618c..9abca0616ec0 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -26,7 +26,6 @@ test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
 test_sysctl
-test_current_pid_tgid_new_ns
 xdping
 test_cpp
 *.skel.h
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 8c33e999319a..886577bc2bb6 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -35,8 +35,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sysctl \
-	test_progs-no_alu32 \
-	test_current_pid_tgid_new_ns
+	test_progs-no_alu32
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index e74dc501b27f..d3af9285d4d4 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -1,85 +1,85 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+
+#define _GNU_SOURCE
 #include <test_progs.h>
+#include "test_ns_current_pid_tgid.skel.h"
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <unistd.h>
 #include <sys/syscall.h>
+#include <sched.h>
+#include <sys/wait.h>
+#include <sys/mount.h>
+#include <sys/fcntl.h>
 
-struct bss {
-	__u64 dev;
-	__u64 ino;
-	__u64 pid_tgid;
-	__u64 user_pid_tgid;
-};
+#define STACK_SIZE (1024 * 1024)
+static char child_stack[STACK_SIZE];
 
-void test_ns_current_pid_tgid(void)
+static int test_current_pid_tgid(void *args)
 {
-	const char *probe_name = "raw_tracepoint/sys_enter";
-	const char *file = "test_ns_current_pid_tgid.o";
-	int err, key = 0, duration = 0;
-	struct bpf_link *link = NULL;
-	struct bpf_program *prog;
-	struct bpf_map *bss_map;
-	struct bpf_object *obj;
-	struct bss bss;
+	struct test_ns_current_pid_tgid__bss  *bss;
+	struct test_ns_current_pid_tgid *skel;
+	int err = 0, duration = 0;
+	pid_t tgid, pid;
 	struct stat st;
-	__u64 id;
-
-	obj = bpf_object__open_file(file, NULL);
-	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
-		return;
 
-	err = bpf_object__load(obj);
-	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
+	skel = test_ns_current_pid_tgid__open_and_load();
+	if (CHECK(!skel, "skel_open_load", "failed to load skeleton\n"))
 		goto cleanup;
 
-	bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
-	if (CHECK(!bss_map, "find_bss_map", "failed\n"))
-		goto cleanup;
+	pid = syscall(SYS_gettid);
+	tgid = getpid();
 
-	prog = bpf_object__find_program_by_title(obj, probe_name);
-	if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
-		  probe_name))
+	err = stat("/proc/self/ns/pid", &st);
+	if (CHECK(err, "stat", "failed /proc/self/ns/pid: %d\n", err))
 		goto cleanup;
 
-	memset(&bss, 0, sizeof(bss));
-	pid_t tid = syscall(SYS_gettid);
-	pid_t pid = getpid();
-
-	id = (__u64) tid << 32 | pid;
-	bss.user_pid_tgid = id;
+	bss = skel->bss;
+	bss->dev = st.st_dev;
+	bss->ino = st.st_ino;
+	bss->user_pid = 0;
+	bss->user_tgid = 0;
 
-	if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
-		perror("Failed to stat /proc/self/ns/pid");
+	err = test_ns_current_pid_tgid__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
 		goto cleanup;
-	}
 
-	bss.dev = st.st_dev;
-	bss.ino = st.st_ino;
+	/* trigger tracepoint */
+	usleep(1);
+	ASSERT_EQ(bss->user_pid, pid, "pid");
+	ASSERT_EQ(bss->user_tgid, tgid, "tgid");
 
-	err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
-	if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
-		goto cleanup;
+cleanup:
+	 test_ns_current_pid_tgid__destroy(skel);
 
-	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
-	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
-		  PTR_ERR(link))) {
-		link = NULL;
-		goto cleanup;
-	}
+	return err;
+}
 
-	/* trigger some syscalls */
-	usleep(1);
+static void test_ns_current_pid_tgid_new_ns(void)
+{
+	int wstatus, duration = 0;
+	pid_t cpid;
+	/* Create a process in a new namespace, this process
+	 * will be the init process of this new namespace hence will be pid 1.
+	 */
+	cpid = clone(test_current_pid_tgid, child_stack + STACK_SIZE, CLONE_NEWPID |
+			SIGCHLD, NULL);
 
-	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
-	if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
-		goto cleanup;
+	if (CHECK(cpid == -1, "clone", strerror(errno)))
+		exit(EXIT_FAILURE);
 
-	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
-		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
-		goto cleanup;
-cleanup:
-	bpf_link__destroy(link);
-	bpf_object__close(obj);
+	if (CHECK(waitpid(cpid, &wstatus, 0) == -1, "waitpid", strerror(errno)))
+		exit(EXIT_FAILURE);
+
+	if (CHECK(WEXITSTATUS(wstatus) != 0, "newns_pidtgid", "failed"))
+		exit(EXIT_FAILURE);
+}
+
+void test_ns_current_pid_tgid(void)
+{
+	if (test__start_subtest("ns_current_pid_tgid_root_ns"))
+		test_current_pid_tgid(NULL);
+	if (test__start_subtest("ns_current_pid_tgid_new_ns"))
+		test_ns_current_pid_tgid_new_ns();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
index 1dca70a6de2f..0763d49f9c42 100644
--- a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
@@ -5,31 +5,21 @@
 #include <stdint.h>
 #include <bpf/bpf_helpers.h>
 
-static volatile struct {
-	__u64 dev;
-	__u64 ino;
-	__u64 pid_tgid;
-	__u64 user_pid_tgid;
-} res;
+__u64 user_pid = 0;
+__u64 user_tgid = 0;
+__u64 dev = 0;
+__u64 ino = 0;
 
-SEC("raw_tracepoint/sys_enter")
-int trace(void *ctx)
+SEC("tracepoint/syscalls/sys_enter_nanosleep")
+int handler(const void *ctx)
 {
-	__u64  ns_pid_tgid, expected_pid;
 	struct bpf_pidns_info nsdata;
-	__u32 key = 0;
 
-	if (bpf_get_ns_current_pid_tgid(res.dev, res.ino, &nsdata,
-		   sizeof(struct bpf_pidns_info)))
+	if (bpf_get_ns_current_pid_tgid(dev, ino, &nsdata, sizeof(struct bpf_pidns_info)))
 		return 0;
 
-	ns_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
-	expected_pid = res.user_pid_tgid;
-
-	if (expected_pid != ns_pid_tgid)
-		return 0;
-
-	res.pid_tgid = ns_pid_tgid;
+	user_pid = nsdata.pid;
+	user_tgid = nsdata.tgid;
 
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c b/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
deleted file mode 100644
index ec53b1ef90d2..000000000000
--- a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
+++ /dev/null
@@ -1,160 +0,0 @@
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
-	return 0;
-}
-- 
2.20.1

