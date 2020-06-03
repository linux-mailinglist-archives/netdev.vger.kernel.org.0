Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B91ED370
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 17:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgFCPco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 11:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgFCPco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 11:32:44 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1423C08C5C0;
        Wed,  3 Jun 2020 08:32:43 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id w9so2392165qtv.3;
        Wed, 03 Jun 2020 08:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cfzZchf2CkT3aKB4UcrAmgD05hxKKEX8h+moVIiqmNE=;
        b=iSKn1lWtW39C5pfERpNNiDkwpnJMhVEPVmv9QTimrp2dQp9HeY5FHQNyQC+NiabuFG
         R25KNFp+Aoe2hjcegUgE08N/wA9KdVuxxoaRBAVfXu2hjPnTqTXHJHu6Z65iA62Hu3qh
         VkzLofcFKKWNqOZtna1gMxQLL/mrbBwvGguhMzIF98XKYuKfJ05D3Fwn/5uYcmhlLFLl
         ZzzdIhFsrr4nKievYnZh+ZaEKHKMAWLflCj1uKWdWtu2UrLu8f1p2IshH2jbKDGr+4t2
         kn+9lSg7tiEN5p3hcxcg+YiX+DcAb7Kq1Z5zd0kMPG2EqQpKKp2o5zytyZZXtVOpbQBr
         PgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cfzZchf2CkT3aKB4UcrAmgD05hxKKEX8h+moVIiqmNE=;
        b=rXIiu4ll4qyOqsVazGE2tKEM9DfrFrG7Ymkp3s/WvJhr2x30WAA4cSUEp/fTZJ0JVi
         xEOxP0MamSwTb+tYSnjYN9QlToFd1HVdWzXVFOF0PMPxyWxiYtnKj92ZNzpy0iteUuNa
         mpIvhI9GdvQ1LBQbwU2A2EehWidDrvilHiF6JYiEetFTkR7S9a3vaG3WgqddCJa9uBzG
         y3XEJrhHD4R2rGSteUuV/s7L2R1xchzeo80s2S4AXNmMX4tkuNC6w4c+MAD+7yc/tKV3
         LmdXdA9VK2kMs3S193zXArLzMu6TzRxvDZzf116P0av30AvU6D+cNCuyOQ4/uvpiqKAw
         /M8g==
X-Gm-Message-State: AOAM533u5kl1JLe/SSf22psKK86a5Mz9TJLFA0ARrPLOZRq6aVanV+x1
        fVRjsQKIMZ6cvKaTdVurzIdsmeBdez5zeQ==
X-Google-Smtp-Source: ABdhPJx4ClkUixhYGpdw+brKt6w3yi9UxVbKBN7GW18cZH3oweOAeO/nggb+Tw9TQrJnie3G6ijS+w==
X-Received: by 2002:aed:3b54:: with SMTP id q20mr33745820qte.362.1591198362494;
        Wed, 03 Jun 2020 08:32:42 -0700 (PDT)
Received: from localhost.localdomain (pc-4-149-45-190.cm.vtr.net. [190.45.149.4])
        by smtp.googlemail.com with ESMTPSA id q32sm2328418qtf.36.2020.06.03.08.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 08:32:41 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v2] [PATCH v2 bpf-next] fold test_current_pid_tgid_new_ns into into test_progs
Date:   Wed,  3 Jun 2020 11:32:28 -0400
Message-Id: <20200603153228.8017-1-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

folds tests from test_current_pid_tgid_new_ns into test_progs.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 112 +++++++++++-
 .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
 3 files changed, 112 insertions(+), 162 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 22aaec74ea0a..7b2ea7adccb0 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -36,8 +36,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
-	test_progs-no_alu32 \
-	test_current_pid_tgid_new_ns
+	test_progs-no_alu32
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index e74dc501b27f..f1b6e093f175 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -1,10 +1,15 @@
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
+#include <sys/fcntl.h>
 
 struct bss {
 	__u64 dev;
@@ -13,7 +18,7 @@ struct bss {
 	__u64 user_pid_tgid;
 };
 
-void test_ns_current_pid_tgid(void)
+static void test_ns_current_pid_tgid_global_ns(void)
 {
 	const char *probe_name = "raw_tracepoint/sys_enter";
 	const char *file = "test_ns_current_pid_tgid.o";
@@ -83,3 +88,108 @@ void test_ns_current_pid_tgid(void)
 	bpf_link__destroy(link);
 	bpf_object__close(obj);
 }
+
+static void test_ns_current_pid_tgid_new_ns(void)
+{
+	pid_t ppid = getpid();
+	int duration = 0;
+	int pidns_fd = 0;
+	char nspath[64];
+	pid_t pid;
+
+	snprintf(nspath, sizeof(nspath) - 1, "/proc/%d/ns/pid", ppid);
+	pidns_fd = open(nspath, O_RDONLY);
+
+	if (CHECK(unshare(CLONE_NEWPID),
+		"unshare CLONE_NEWPID",
+		"error: %s\n", strerror(errno)))
+		return;
+
+	pid = vfork();
+	if (CHECK(pid < 0, "ns_current_pid_tgid_new_ns", "vfork error: %s\n",
+	    strerror(errno))) {
+		return;
+	}
+	if (pid > 0) {
+	printf("waiting pid is %u\n", pid);
+		usleep(5);
+		wait(NULL);
+		return;
+	} else {
+		const char *probe_name = "raw_tracepoint/sys_enter";
+		const char *file = "test_ns_current_pid_tgid.o";
+		int err, key = 0, duration = 0;
+		struct bpf_link *link = NULL;
+		struct bpf_program *prog;
+		struct bpf_map *bss_map;
+		struct bpf_object *obj;
+		struct bss bss;
+		struct stat st;
+		__u64 id;
+
+		obj = bpf_object__open_file(file, NULL);
+		if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
+			return;
+
+		err = bpf_object__load(obj);
+		if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
+			goto cleanup;
+
+		bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
+		if (CHECK(!bss_map, "find_bss_map", "failed\n"))
+			goto cleanup;
+
+		prog = bpf_object__find_program_by_title(obj, probe_name);
+		if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
+					probe_name))
+			goto cleanup;
+
+		memset(&bss, 0, sizeof(bss));
+		pid_t tid = syscall(SYS_gettid);
+		pid_t pid = getpid();
+
+		id = (__u64) tid << 32 | pid;
+		bss.user_pid_tgid = id;
+		if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
+			perror("Failed to stat /proc/self/ns/pid");
+			goto cleanup;
+		}
+
+		bss.dev = st.st_dev;
+		bss.ino = st.st_ino;
+
+		err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
+		if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
+			goto cleanup;
+
+		link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+		if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
+					PTR_ERR(link))) {
+			link = NULL;
+			goto cleanup;
+		}
+
+		/* trigger some syscalls */
+		usleep(1);
+
+		err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
+		if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
+			goto cleanup;
+
+		if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs bpf pid/tgid",
+			"User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
+			goto cleanup;
+cleanup:
+		setns(pidns_fd, CLONE_NEWPID);
+		bpf_link__destroy(link);
+		bpf_object__close(obj);
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

