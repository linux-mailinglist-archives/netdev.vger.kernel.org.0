Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6F72F62BF
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbhANOLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbhANOLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:11:21 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E89C061574;
        Thu, 14 Jan 2021 06:10:41 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id 22so7915261qkf.9;
        Thu, 14 Jan 2021 06:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=svRRv8J1ZfbihhGek+39S+nO2UvVDhauH0WdXML8eOo=;
        b=OCbKWrwVVBfngO5OEBCZIgHx03E7+mOrx8MAkp+np3M4D1lfuh8c5ETXK6MSwrr/3B
         3T1qp/rH/fW4OYbXW5JqtSE81aSdO+qfYAF3RB4oSZBsmPZljEk713AIJsMlODHHT/oL
         9AkDurmmeL8t2XyqS/9bTw1WtTN2FpexAXnoSK32zhurUcxN1JU3SjhuHRIvuF9zG9jP
         zi9TEJ2l4P2cnQZD5uqoSb6wC84fPr+js5+vd4vcpNzGW8JZrPhMuWDMZsukGScphkS+
         HtNw0B/qR3JHn24mqCa2Uq/oVht/niFtT/oUyjyJgn++MYWV8b3TArn1uF73JNsOWcTW
         R/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=svRRv8J1ZfbihhGek+39S+nO2UvVDhauH0WdXML8eOo=;
        b=s6fH0L8POMbPEI2H63Vc9JVKB4Ahz3xalIemobewlfjDHdA1PVqPHa3F82peDX0Obc
         9KgibSJQDnsS9nXSxxeC1kEx74pb4RA6+4NSjfgrnNyWWsuu0MbHYyRXBtTQQw/3eMhp
         HCMH0LMbtNBoF4d61YCarZW0I3TC3h792fzho0zJsvXEA3ZDMGwSIBnu+2Su8gvbE8LT
         Ip0UqxeVflbsu+bZrBYdnAjff9idbWDaN6+cHP3fA/8j6J0yv8lfp5LG8MAY2JE9TcOa
         9ikjjBhayQUdnfgmfPG9016ID3j1m0T7lYFKWGyIVkRCPjZa7dazbuYS1SAvR6nAZQAI
         hb4Q==
X-Gm-Message-State: AOAM532gazxIOJz9OjxlsKm9l0x3SB9qOsEWKgWoz7LXes1GukGz7vHq
        SaHPgk4CEmC5nffhfg8YXbdNWV1dz0OQSGyP
X-Google-Smtp-Source: ABdhPJxo9Aky/hlZYf+9u1WJ/I8TtOT3fYOeADa4i5bme7yUyO8r8rLGAaXZNqisRmw4qeDNURYgAA==
X-Received: by 2002:a05:620a:6c3:: with SMTP id 3mr7305236qky.43.1610633440235;
        Thu, 14 Jan 2021 06:10:40 -0800 (PST)
Received: from localhost (pc-145-79-45-190.cm.vtr.net. [190.45.79.145])
        by smtp.gmail.com with ESMTPSA id x134sm3014488qka.1.2021.01.14.06.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:10:39 -0800 (PST)
Date:   Thu, 14 Jan 2021 11:10:36 -0300
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andriin@fb.com, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v12 bpf-next] bpf/selftests: fold
 test_current_pid_tgid_new_ns into test_progs.
Message-ID: <20210114141033.GA17348@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
This change folds test cases into test_progs.

Changes from v11:

 - Fixed test failure is not detected.
 - Removed EXIT(3) call as it will stop test_progs execution.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 -
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 119 ++++++-------
 .../bpf/progs/test_ns_current_pid_tgid.c      |  28 +--
 .../bpf/test_current_pid_tgid_new_ns.c        | 160 ------------------
 5 files changed, 70 insertions(+), 241 deletions(-)
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
index e74dc501b27f..9113b19b821b 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -1,85 +1,86 @@
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
+	int err = -1, duration = 0;
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
+	err = 0;
 
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
+		return;
 
-	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
-		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
-		goto cleanup;
-cleanup:
-	bpf_link__destroy(link);
-	bpf_object__close(obj);
+	if (CHECK(waitpid(cpid, &wstatus, 0) == -1, "waitpid", strerror(errno)))
+		return;
+
+	if (CHECK(WEXITSTATUS(wstatus) != 0, "newns_pidtgid", "failed"))
+		return;
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

