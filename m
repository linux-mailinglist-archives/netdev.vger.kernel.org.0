Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3967193739
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 05:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgCZEBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 00:01:19 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41397 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgCZEBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 00:01:19 -0400
Received: by mail-qk1-f196.google.com with SMTP id q188so5149967qke.8;
        Wed, 25 Mar 2020 21:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X9lM4owEmTpuos0AqtQw9EJft8Fa1CHA/b8aSewtgf8=;
        b=S5DE85h3u+yktZSWWA16OP3mb01FWlGHNHUVMdwc0OWpvz+e8gqDlCWGSPM9uL4Pnd
         SN8JKguHC6P9wWW9jDkBY5M5edDW3ErOYCjTByc2PEzt8vIiTwiLvVOs3tUVUssQ/YpT
         nzER/l6LnU+vrD12l5x45idh/X48+ycSUvmgRG03mrDXZvGFeDG8zNkPFWIbtyUXEKr3
         ZoLI9SLrWXN15zl2twjPhSRcxTXDWHkMAiaD+I3IdtaRXG+eRfNv54XlVjygHB7wOGMK
         JbaGQuyMDGsvQ4siikFKyCl0ffjVO6A3oNAv/gNI1MNeFS3uQOeu3S9o548mstd8ug55
         lKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X9lM4owEmTpuos0AqtQw9EJft8Fa1CHA/b8aSewtgf8=;
        b=S0xyINE3fnonYcZ7XInDywyF/3frmoNYhXbxxae9SecwXLk2OSwBWYKgoX33RnM/aW
         p0n/gMMI2IS9zRugA2FH9kXT4BXlLWyC0A8ncatMvq2vnna66uSpyoqgYk22F7jR+AjN
         eHlf8kuP+dTB1ubYs17UvgIk55qWU3oTIl0ZdaRZViJEtqU7r0DRRk6FsZOKkq6oZOOE
         VOlTSrBJj8e4/XLspcSQIYFj5SPTNJK+MkR5K1ApTboGmOrMKMyA8V0rt4z7XQGMYrTW
         EiPI+fAk/zwrhT7M8Ju7b6mPpO3dSlHQOykaYIZPLXzjwGOY19iy7pWHnk/iJtkvXGI8
         PQ8Q==
X-Gm-Message-State: ANhLgQ1TAVeBZJv+iEDpIq9mp1tFjAJA5tgIODg2BRavOvYU9y0Urlbv
        Ny8Fh0nFx/AgrL5LUW8AiWKwvnRTDJgckw==
X-Google-Smtp-Source: ADFU+vt5QEqbyWCOrK/BIXJ7qsT+x38Reg/vuxL/1M4D4czxHtxHefcKls4rqnVwQbR7n38+i/97Jg==
X-Received: by 2002:a37:98c4:: with SMTP id a187mr6116089qke.132.1585195276536;
        Wed, 25 Mar 2020 21:01:16 -0700 (PDT)
Received: from localhost.localdomain (pc-215-101-46-190.cm.vtr.net. [190.46.101.215])
        by smtp.googlemail.com with ESMTPSA id d73sm658373qkg.113.2020.03.25.21.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 21:01:15 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, quentin@isovalent.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [Fixes ebpf-selftests]: Fold test_current_pid_tgid_new_ns into test_progs
Date:   Thu, 26 Mar 2020 01:01:05 -0300
Message-Id: <20200326040105.24297-1-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move tests from test_current_pid_tgid_new_ns into test_progs.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 134 ++++++++++++++-
 .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
 3 files changed, 134 insertions(+), 162 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 7729892e0b04..f04617382b7b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -33,8 +33,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_progs-no_alu32 \
-	test_current_pid_tgid_new_ns
+	test_progs-no_alu32
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index 542240e16564..2fb76c014ae2 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -1,10 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <unistd.h>
 #include <sys/syscall.h>
+#include <sched.h>
+#include <sys/wait.h>
+#include <sys/mount.h>
 
 struct bss {
 	__u64 dev;
@@ -13,7 +17,7 @@ struct bss {
 	__u64 user_pid_tgid;
 };
 
-void test_ns_current_pid_tgid(void)
+static void test_ns_current_pid_tgid_global_ns(void)
 {
 	const char *probe_name = "raw_tracepoint/sys_enter";
 	const char *file = "test_ns_current_pid_tgid.o";
@@ -86,3 +90,131 @@ void test_ns_current_pid_tgid(void)
 	}
 	bpf_object__close(obj);
 }
+
+static void test_ns_current_pid_tgid_new_ns(void)
+{
+	pid_t pid;
+	int duration = 0;
+
+	if (CHECK(unshare(CLONE_NEWPID | CLONE_NEWNS),
+				"unshare CLONE_NEWPID | CLONE_NEWNS",
+				"error errno=%d\n", errno))
+		return;
+
+	pid = fork();
+	if (pid == -1) {
+		perror("Fork() failed\n");
+		return;
+	}
+
+	if (pid > 0) {
+		int status;
+
+		usleep(5);
+		waitpid(pid, &status, 0);
+		return;
+	} else {
+
+		pid = fork();
+		if (pid == -1) {
+			perror("Fork() failed\n");
+			return;
+		}
+
+		if (pid > 0) {
+			int status;
+
+			waitpid(pid, &status, 0);
+			return;
+		} else {
+			if (CHECK(mount("none", "/proc", NULL, MS_PRIVATE|MS_REC, NULL),
+					"Unmounting proc", "Cannot umount proc! errno=%d\n", errno))
+				return;
+
+			if (CHECK(mount("proc", "/proc", "proc", MS_NOSUID|MS_NOEXEC|MS_NODEV, NULL),
+					"Mounting proc", "Cannot mount proc! errno=%d\n", errno))
+				return;
+
+
+			const char *probe_name = "raw_tracepoint/sys_enter";
+			const char *file = "test_ns_current_pid_tgid.o";
+			int err, key = 0, duration = 0;
+			struct bpf_link *link = NULL;
+			struct bpf_program *prog;
+			struct bpf_map *bss_map;
+			struct bpf_object *obj;
+			struct bss bss;
+			struct stat st;
+			__u64 id;
+
+
+			obj = bpf_object__open_file(file, NULL);
+			if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
+				return;
+
+			err = bpf_object__load(obj);
+			if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
+				goto cleanup;
+
+			bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
+			if (CHECK(!bss_map, "find_bss_map", "failed\n"))
+				goto cleanup;
+
+			prog = bpf_object__find_program_by_title(obj, probe_name);
+			if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
+						probe_name))
+				goto cleanup;
+
+			memset(&bss, 0, sizeof(bss));
+			pid_t tid = syscall(SYS_gettid);
+			pid_t pid = getpid();
+
+			id = (__u64) tid << 32 | pid;
+			bss.user_pid_tgid = id;
+
+			if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
+				perror("Failed to stat /proc/self/ns/pid");
+				goto cleanup;
+			}
+
+			bss.dev = st.st_dev;
+			bss.ino = st.st_ino;
+
+			err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
+			if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
+				goto cleanup;
+
+			link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+			if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
+						PTR_ERR(link))) {
+				link = NULL;
+				goto cleanup;
+			}
+
+			/* trigger some syscalls */
+			usleep(1);
+
+			err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
+			if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
+				goto cleanup;
+
+			if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
+						"User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
+				goto cleanup;
+cleanup:
+			if (!link) {
+				bpf_link__destroy(link);
+				link = NULL;
+			}
+			bpf_object__close(obj);
+		}
+	}
+}
+
+void test_ns_current_pid_tgid(void)
+{
+	if (test__start_subtest("ns_current_pid_tgid_global_ns"))
+		test_ns_current_pid_tgid_global_ns();
+	if (test__start_subtest("ns_current_pid_tgid_new_ns"))
+		test_ns_current_pid_tgid_new_ns();
+}
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
-- 
2.20.1

