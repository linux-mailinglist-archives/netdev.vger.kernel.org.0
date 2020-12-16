Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC672DC205
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 15:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgLPOSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 09:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgLPOSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 09:18:54 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D3CC0617A6;
        Wed, 16 Dec 2020 06:18:14 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id h4so17700846qkk.4;
        Wed, 16 Dec 2020 06:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=1Bbtu8WjVNUZf2rMt0PlMmA4Dx0rAmlXEef7QZqXV9E=;
        b=ruzAmabXOYtYcU9BnQgPFSNMfFqgvcWycbj6ZQ3qmAlrLWanCIKDGeIaJ1Axrcb0wP
         0liBG02WHhGEyeJFxTThmJ68uaQbiYyvMi9N0CF0uIdmQCzKZp08U//a83sY64OqtuLx
         +odB19bjcL4DmPhKp3CrJniahem1bHiFIUHgTs18DRHpR6RTYXnM+fYhDMdFzWiWWoA/
         AvanrWo5+o8VNvr/DPMt5oB+Q4RKHIZE4vwYaxa8BwfmlRYEiEjNfdSUwhfc5h8RwExX
         BpmFvxKtRrKIyuu6jlHEVTxXSAwpMHaPtKDf0w14n6vdo2drI8hs908vx+dyUHAGqQi8
         vbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=1Bbtu8WjVNUZf2rMt0PlMmA4Dx0rAmlXEef7QZqXV9E=;
        b=efYn3i31Dh1JMrbuBo08tYs09AWonTH/nSFwA1ed9nFzArVK38O9VnJ1scPVfK6r45
         nRCRhb5BhaShZxHw+FYSFLuYF51A4N1EhcSnss9Gxj67J8AmzPwuFUdlFs13W2VZAlZL
         R+0rUw5dZ+Vxh+6Ot1oXCFswqsyUVmYCt+Mfr+FCE2LAUR1aqnMSb05RrbUdpW6zo8/3
         li4ERxhVbK91ne8/unBO/7nfaQLxmAuBgaVTSK1u3Uw2zSsJ+waqS+zmqlP94gHiip2T
         kxjdNcz43GdmXEwrejBAksUbOrrbnNO+fVP3PoPPl6UqPBzkmNQEsdP0QMmmduE8V/6x
         Xtbw==
X-Gm-Message-State: AOAM5330hlyzNu2DAuG4WimAEywdLF8Y7lc2+5rS3eFU3vYDIKC8KirW
        NEN/z2N4pVNuUnFe2RQvqrr8Ohp4vuIgk4Wo+4o=
X-Google-Smtp-Source: ABdhPJyoCvyKIrBas9bcsXa8dcS8PuofO7Eva5iFpC+3L64VEkfOnRdrRUe6Y7LCVsN89ZjJ5MUezA==
X-Received: by 2002:a05:620a:21d3:: with SMTP id h19mr43237549qka.341.1608128292975;
        Wed, 16 Dec 2020 06:18:12 -0800 (PST)
Received: from localhost (pc-145-79-45-190.cm.vtr.net. [190.45.79.145])
        by smtp.gmail.com with ESMTPSA id l20sm1105030qtu.25.2020.12.16.06.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 06:18:12 -0800 (PST)
Date:   Wed, 16 Dec 2020 11:18:08 -0300
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andriin@fb.com, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org, andrii.nakryiko@gmail.com,
        cneirabustos@gmail.com
Subject: [PATCH v9 bpf-next] bpf/selftests: fold test_current_pid_tgid_new_ns
 into test_progs.
Message-ID: <20201216141806.GA21694@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
This change folds test cases into test_progs.

Changes from v8:

 - Fixed code style
 - Fixed CHECK macro usage
 - Removed root namespace sub-test
 - Split pid_tgid variable

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 -
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 115 ++++++-------
 .../bpf/progs/test_ns_current_pid_tgid.c      |  27 +--
 .../bpf/test_current_pid_tgid_new_ns.c        | 160 ------------------
 5 files changed, 68 insertions(+), 238 deletions(-)
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
index e74dc501b27f..038195704f2d 100644
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
+static int newns_pid_tgid(void *arg)
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
+	int err = -1, duration = 0;
+	struct test_ns_current_pid_tgid *skel;
+	pid_t pid, tid;
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
+	tid = syscall(SYS_gettid);
+	pid = getpid();
 
-	prog = bpf_object__find_program_by_title(obj, probe_name);
-	if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
-		  probe_name))
+	err = stat("/proc/self/ns/pid", &st);
+	if (CHECK(err, "stat", "failed /proc/self/ns/pid: %d", err))
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
 
-	err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
-	if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
+	if (CHECK((pid_t)bss->user_pid != pid, "pid", "got %d != exp %d\n",
+	 (pid_t)bss->user_pid, pid))
 		goto cleanup;
 
-	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
-	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
-		  PTR_ERR(link))) {
-		link = NULL;
+	if (CHECK((pid_t)bss->user_tgid != tid, "tgid", "got %d != exp %d\n",
+	 (pid_t)bss->user_tgid, tid))
 		goto cleanup;
-	}
 
-	/* trigger some syscalls */
-	usleep(1);
+cleanup:
+	if (skel)
+		test_ns_current_pid_tgid__destroy(skel);
 
-	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
-	if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
-		goto cleanup;
+	return err;
+}
 
-	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
-		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
-		goto cleanup;
-cleanup:
-	bpf_link__destroy(link);
-	bpf_object__close(obj);
+void test_ns_current_pid_tgid(void)
+{
+	int wstatus, duration = 0;
+	pid_t cpid;
+
+	cpid = clone(newns_pid_tgid,
+	  child_stack + STACK_SIZE,
+	  CLONE_NEWPID | SIGCHLD, NULL);
+
+	if (CHECK(cpid == -1, "clone", strerror(errno)))
+		exit(EXIT_FAILURE);
+
+	if (CHECK(waitpid(cpid, &wstatus, 0) == -1, "waitpid",
+	 strerror(errno)))
+		exit(EXIT_FAILURE);
+
+
+	if (CHECK(WEXITSTATUS(wstatus) != 0, "newns_pidtgid",
+	 "failed"))
+		exit(EXIT_FAILURE);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
index 1dca70a6de2f..805ceef9103a 100644
--- a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
@@ -5,31 +5,22 @@
 #include <stdint.h>
 #include <bpf/bpf_helpers.h>
 
-static volatile struct {
-	__u64 dev;
-	__u64 ino;
-	__u64 pid_tgid;
-	__u64 user_pid_tgid;
-} res;
+__u32 user_pid = 0;
+__u32 user_tgid = 0;
+__u64 dev = 0;
+__u64 ino = 0;
 
 SEC("raw_tracepoint/sys_enter")
-int trace(void *ctx)
+int handler(const void *ctx)
 {
-	__u64  ns_pid_tgid, expected_pid;
 	struct bpf_pidns_info nsdata;
-	__u32 key = 0;
 
-	if (bpf_get_ns_current_pid_tgid(res.dev, res.ino, &nsdata,
-		   sizeof(struct bpf_pidns_info)))
+	if (bpf_get_ns_current_pid_tgid(dev, ino, &nsdata,
+		sizeof(struct bpf_pidns_info)))
 		return 0;
 
-	ns_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
-	expected_pid = res.user_pid_tgid;
-
-	if (expected_pid != ns_pid_tgid)
-		return 0;
-
-	res.pid_tgid = ns_pid_tgid;
+	user_pid =  nsdata.pid;
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

