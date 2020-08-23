Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E593B24EC47
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgHWIyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgHWIx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:53:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17315C061574;
        Sun, 23 Aug 2020 01:53:56 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mt12so2681795pjb.4;
        Sun, 23 Aug 2020 01:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+3iO2tp9GVwgxosV3vPWrTVwbdJhn8yHdSO0jPUdF94=;
        b=OJqTq3GR7+O9UWPy55Xf+57JTraJWsk83q59WsTM2uWU2Simj0hVEUSUiaKPQtR7+a
         qncG9j9Lk5TYiVcB2hc3GL8g3mZADnE35KLaZJWEYrtJNuaDb5n6F86qocrgQeJqAiij
         KKPUMzxYOf8YR3QUOIQWEwEjJlEVUCq/CS9WRB0lPYDTV1eVVdx+TGhexqYaDWKLDvZE
         n5RsAZ7qBR5GUlhLnlj+p8sT4PghX91DykFIJYPACcdkQjF55QqV9ReL3rPcjyt61R8A
         nG6tDpQNrgSX3YgtUgNvxG+cebMHa6E1OL95MgmfNUJMnmGxANd7YKL6Iw0OX+q4wpl/
         cfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+3iO2tp9GVwgxosV3vPWrTVwbdJhn8yHdSO0jPUdF94=;
        b=lPqfb1rNZ98+d9GFXrHwilaTtzlgoSAvM0E3FjI1o3Hpg2fsCPevECG9RokELcV4GP
         V8dMHTiHDqNk8xr95Kop61snkJh+vidGTejzjSKQ7SbY6+QhQ2ELqy0o+3gJBILIfryd
         724LByMfSlLD2l2rS3Nv1s20ywxVInUAPhcfcomByVWchhP7OSqqurxIr8LHKggT9YgO
         pNljU4EgtjAbUpYUwq26Hr6ZAvGKBqI3y29v+9VvFTAOOavMf2G46HsIzmRPlUPvAHFM
         woDNZcFd1gtx/c/C7KJe4f5qI9aZhfHKIeiwdbdUr4iG31u1P731jI1/+9wZaDaNAMPS
         T0Rg==
X-Gm-Message-State: AOAM533eSkQXWdzeGUozwn4J0SlkGo+pW7tPIlwd4LuYyjJQt75t39oH
        Nc2eh2DCdGifTNPgyDkEyA==
X-Google-Smtp-Source: ABdhPJwZG7CWagMH6l65J6zUZhfsu1o/Flf+Y1hYLGMCJvWILT/lmrhog8yZtInSGaOZKs5kE9u2hw==
X-Received: by 2002:a17:902:ba98:: with SMTP id k24mr385846pls.277.1598172834214;
        Sun, 23 Aug 2020 01:53:54 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id b15sm6128446pgk.14.2020.08.23.01.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 01:53:53 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 3/3] samples: bpf: Refactor tracepoint tracing programs with libbpf
Date:   Sun, 23 Aug 2020 17:53:34 +0900
Message-Id: <20200823085334.9413-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200823085334.9413-1-danieltimlee@gmail.com>
References: <20200823085334.9413-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the problem of increasing fragmentation of the bpf loader programs,
instead of using bpf_loader.o, which is used in samples/bpf, this
commit refactors the existing tracepoint tracing programs with libbbpf
bpf loader.

    - Adding a tracepoint event and attaching a bpf program to it was done
    through bpf_program_attach().
    - Instead of using the existing BPF MAP definition, MAP definition
    has been refactored with the new BTF-defined MAP format.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile           |  6 ++--
 samples/bpf/cpustat_kern.c     | 36 +++++++++----------
 samples/bpf/cpustat_user.c     | 47 ++++++++++++++++++++----
 samples/bpf/offwaketime_kern.c | 52 +++++++++++++--------------
 samples/bpf/offwaketime_user.c | 66 ++++++++++++++++++++++++++--------
 samples/bpf/syscall_tp_kern.c  | 24 ++++++-------
 samples/bpf/syscall_tp_user.c  | 54 +++++++++++++++++++++-------
 7 files changed, 192 insertions(+), 93 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index c74d477474e2..a6d3646b3818 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -74,7 +74,7 @@ tracex7-objs := tracex7_user.o
 test_probe_write_user-objs := test_probe_write_user_user.o
 trace_output-objs := trace_output_user.o $(TRACE_HELPERS)
 lathist-objs := lathist_user.o
-offwaketime-objs := bpf_load.o offwaketime_user.o $(TRACE_HELPERS)
+offwaketime-objs := offwaketime_user.o $(TRACE_HELPERS)
 spintest-objs := spintest_user.o $(TRACE_HELPERS)
 map_perf_test-objs := map_perf_test_user.o
 test_overhead-objs := bpf_load.o test_overhead_user.o
@@ -100,8 +100,8 @@ xdp_redirect_map-objs := xdp_redirect_map_user.o
 xdp_redirect_cpu-objs := bpf_load.o xdp_redirect_cpu_user.o
 xdp_monitor-objs := bpf_load.o xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
-syscall_tp-objs := bpf_load.o syscall_tp_user.o
-cpustat-objs := bpf_load.o cpustat_user.o
+syscall_tp-objs := syscall_tp_user.o
+cpustat-objs := cpustat_user.o
 xdp_adjust_tail-objs := xdp_adjust_tail_user.o
 xdpsock-objs := xdpsock_user.o
 xdp_fwd-objs := xdp_fwd_user.o
diff --git a/samples/bpf/cpustat_kern.c b/samples/bpf/cpustat_kern.c
index a86a19d5f033..5aefd19cdfa1 100644
--- a/samples/bpf/cpustat_kern.c
+++ b/samples/bpf/cpustat_kern.c
@@ -51,28 +51,28 @@ static int cpu_opps[] = { 208000, 432000, 729000, 960000, 1200000 };
 #define MAP_OFF_PSTATE_IDX	3
 #define MAP_OFF_NUM		4
 
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u64),
-	.max_entries = MAX_CPU * MAP_OFF_NUM,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, MAX_CPU * MAP_OFF_NUM);
+} my_map SEC(".maps");
 
 /* cstate_duration records duration time for every idle state per CPU */
-struct bpf_map_def SEC("maps") cstate_duration = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u64),
-	.max_entries = MAX_CPU * MAX_CSTATE_ENTRIES,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, MAX_CPU * MAX_CSTATE_ENTRIES);
+} cstate_duration SEC(".maps");
 
 /* pstate_duration records duration time for every operating point per CPU */
-struct bpf_map_def SEC("maps") pstate_duration = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u64),
-	.max_entries = MAX_CPU * MAX_PSTATE_ENTRIES,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, MAX_CPU * MAX_PSTATE_ENTRIES);
+} pstate_duration SEC(".maps");
 
 /*
  * The trace events for cpu_idle and cpu_frequency are taken from:
diff --git a/samples/bpf/cpustat_user.c b/samples/bpf/cpustat_user.c
index 869a99406dbf..96675985e9e0 100644
--- a/samples/bpf/cpustat_user.c
+++ b/samples/bpf/cpustat_user.c
@@ -9,7 +9,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <fcntl.h>
-#include <linux/bpf.h>
 #include <locale.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -18,7 +17,9 @@
 #include <sys/wait.h>
 
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
+
+static int cstate_map_fd, pstate_map_fd;
 
 #define MAX_CPU			8
 #define MAX_PSTATE_ENTRIES	5
@@ -181,21 +182,50 @@ static void int_exit(int sig)
 {
 	cpu_stat_inject_cpu_idle_event();
 	cpu_stat_inject_cpu_frequency_event();
-	cpu_stat_update(map_fd[1], map_fd[2]);
+	cpu_stat_update(cstate_map_fd, pstate_map_fd);
 	cpu_stat_print();
 	exit(0);
 }
 
 int main(int argc, char **argv)
 {
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	char filename[256];
 	int ret;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return 0;
+	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
+	if (!prog) {
+		printf("finding a prog in obj file failed\n");
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	cstate_map_fd = bpf_object__find_map_fd_by_name(obj, "cstate_duration");
+	pstate_map_fd = bpf_object__find_map_fd_by_name(obj, "pstate_duration");
+	if (cstate_map_fd < 0 || pstate_map_fd < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	link = bpf_program__attach(prog);
+	if (libbpf_get_error(link)) {
+		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+		link = NULL;
+		goto cleanup;
 	}
 
 	ret = cpu_stat_inject_cpu_idle_event();
@@ -210,10 +240,13 @@ int main(int argc, char **argv)
 	signal(SIGTERM, int_exit);
 
 	while (1) {
-		cpu_stat_update(map_fd[1], map_fd[2]);
+		cpu_stat_update(cstate_map_fd, pstate_map_fd);
 		cpu_stat_print();
 		sleep(5);
 	}
 
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_kern.c
index e74ee1cd4b9c..14b792915a9c 100644
--- a/samples/bpf/offwaketime_kern.c
+++ b/samples/bpf/offwaketime_kern.c
@@ -28,38 +28,38 @@ struct key_t {
 	u32 tret;
 };
 
-struct bpf_map_def SEC("maps") counts = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct key_t),
-	.value_size = sizeof(u64),
-	.max_entries = 10000,
-};
-
-struct bpf_map_def SEC("maps") start = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u64),
-	.max_entries = 10000,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct key_t);
+	__type(value, u64);
+	__uint(max_entries, 10000);
+} counts SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, 10000);
+} start SEC(".maps");
 
 struct wokeby_t {
 	char name[TASK_COMM_LEN];
 	u32 ret;
 };
 
-struct bpf_map_def SEC("maps") wokeby = {
-	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(struct wokeby_t),
-	.max_entries = 10000,
-};
-
-struct bpf_map_def SEC("maps") stackmap = {
-	.type = BPF_MAP_TYPE_STACK_TRACE,
-	.key_size = sizeof(u32),
-	.value_size = PERF_MAX_STACK_DEPTH * sizeof(u64),
-	.max_entries = 10000,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, u32);
+	__type(value, struct wokeby_t);
+	__uint(max_entries, 10000);
+} wokeby SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_STACK_TRACE);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, PERF_MAX_STACK_DEPTH * sizeof(u64));
+	__uint(max_entries, 10000);
+} stackmap SEC(".maps");
 
 #define STACKID_FLAGS (0 | BPF_F_FAST_STACK_CMP)
 
diff --git a/samples/bpf/offwaketime_user.c b/samples/bpf/offwaketime_user.c
index 51c7da5341cc..5734cfdaaacb 100644
--- a/samples/bpf/offwaketime_user.c
+++ b/samples/bpf/offwaketime_user.c
@@ -5,19 +5,19 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <signal.h>
-#include <linux/bpf.h>
-#include <string.h>
 #include <linux/perf_event.h>
 #include <errno.h>
-#include <assert.h>
 #include <stdbool.h>
 #include <sys/resource.h>
 #include <bpf/libbpf.h>
-#include "bpf_load.h"
+#include <bpf/bpf.h>
 #include "trace_helpers.h"
 
 #define PRINT_RAW_ADDR 0
 
+/* counts, stackmap */
+static int map_fd[2];
+
 static void print_ksym(__u64 addr)
 {
 	struct ksym *sym;
@@ -52,14 +52,14 @@ static void print_stack(struct key_t *key, __u64 count)
 	int i;
 
 	printf("%s;", key->target);
-	if (bpf_map_lookup_elem(map_fd[3], &key->tret, ip) != 0) {
+	if (bpf_map_lookup_elem(map_fd[1], &key->tret, ip) != 0) {
 		printf("---;");
 	} else {
 		for (i = PERF_MAX_STACK_DEPTH - 1; i >= 0; i--)
 			print_ksym(ip[i]);
 	}
 	printf("-;");
-	if (bpf_map_lookup_elem(map_fd[3], &key->wret, ip) != 0) {
+	if (bpf_map_lookup_elem(map_fd[1], &key->wret, ip) != 0) {
 		printf("---;");
 	} else {
 		for (i = 0; i < PERF_MAX_STACK_DEPTH; i++)
@@ -96,23 +96,54 @@ static void int_exit(int sig)
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_object *obj = NULL;
+	struct bpf_link *links[2];
+	struct bpf_program *prog;
+	int delay = 1, i = 0;
 	char filename[256];
-	int delay = 1;
-
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	setrlimit(RLIMIT_MEMLOCK, &r);
 
-	signal(SIGINT, int_exit);
-	signal(SIGTERM, int_exit);
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
 
 	if (load_kallsyms()) {
 		printf("failed to process /proc/kallsyms\n");
 		return 2;
 	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "counts");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "stackmap");
+	if (map_fd[0] < 0 || map_fd[1] < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	bpf_object__for_each_program(prog, obj) {
+		links[i] = bpf_program__attach(prog);
+		if (libbpf_get_error(links[i])) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[i] = NULL;
+			goto cleanup;
+		}
+		i++;
 	}
 
 	if (argc > 1)
@@ -120,5 +151,10 @@ int main(int argc, char **argv)
 	sleep(delay);
 	print_stacks(map_fd[0]);
 
+cleanup:
+	for (i--; i >= 0; i--)
+		bpf_link__destroy(links[i]);
+
+	bpf_object__close(obj);
 	return 0;
 }
diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
index 5a62b03b1f88..50231c2eff9c 100644
--- a/samples/bpf/syscall_tp_kern.c
+++ b/samples/bpf/syscall_tp_kern.c
@@ -18,19 +18,19 @@ struct syscalls_exit_open_args {
 	long ret;
 };
 
-struct bpf_map_def SEC("maps") enter_open_map = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u32),
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u32);
+	__uint(max_entries, 1);
+} enter_open_map SEC(".maps");
 
-struct bpf_map_def SEC("maps") exit_open_map = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u32),
-	.max_entries = 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u32);
+	__uint(max_entries, 1);
+} exit_open_map SEC(".maps");
 
 static __always_inline void count(void *map)
 {
diff --git a/samples/bpf/syscall_tp_user.c b/samples/bpf/syscall_tp_user.c
index 57014bab7cbe..76a1d00128fb 100644
--- a/samples/bpf/syscall_tp_user.c
+++ b/samples/bpf/syscall_tp_user.c
@@ -5,16 +5,12 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <stdlib.h>
-#include <signal.h>
-#include <linux/bpf.h>
 #include <string.h>
 #include <linux/perf_event.h>
 #include <errno.h>
-#include <assert.h>
-#include <stdbool.h>
 #include <sys/resource.h>
+#include <bpf/libbpf.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
 
 /* This program verifies bpf attachment to tracepoint sys_enter_* and sys_exit_*.
  * This requires kernel CONFIG_FTRACE_SYSCALLS to be set.
@@ -49,16 +45,44 @@ static void verify_map(int map_id)
 
 static int test(char *filename, int num_progs)
 {
-	int i, fd, map0_fds[num_progs], map1_fds[num_progs];
+	int map0_fds[num_progs], map1_fds[num_progs], fd, i, j = 0;
+	struct bpf_link *links[num_progs * 4];
+	struct bpf_object *objs[num_progs];
+	struct bpf_program *prog;
 
 	for (i = 0; i < num_progs; i++) {
-		if (load_bpf_file(filename)) {
-			fprintf(stderr, "%s", bpf_log_buf);
-			return 1;
+		objs[i] = bpf_object__open_file(filename, NULL);
+		if (libbpf_get_error(objs[i])) {
+			fprintf(stderr, "opening BPF object file failed\n");
+			objs[i] = NULL;
+			goto cleanup;
 		}
-		printf("prog #%d: map ids %d %d\n", i, map_fd[0], map_fd[1]);
-		map0_fds[i] = map_fd[0];
-		map1_fds[i] = map_fd[1];
+
+		/* load BPF program */
+		if (bpf_object__load(objs[i])) {
+			fprintf(stderr, "loading BPF object file failed\n");
+			goto cleanup;
+		}
+
+		map0_fds[i] = bpf_object__find_map_fd_by_name(objs[i],
+							      "enter_open_map");
+		map1_fds[i] = bpf_object__find_map_fd_by_name(objs[i],
+							      "exit_open_map");
+		if (map0_fds[i] < 0 || map1_fds[i] < 0) {
+			fprintf(stderr, "finding a map in obj file failed\n");
+			goto cleanup;
+		}
+
+		bpf_object__for_each_program(prog, objs[i]) {
+			links[j] = bpf_program__attach(prog);
+			if (libbpf_get_error(links[j])) {
+				fprintf(stderr, "bpf_program__attach failed\n");
+				links[j] = NULL;
+				goto cleanup;
+			}
+			j++;
+		}
+		printf("prog #%d: map ids %d %d\n", i, map0_fds[i], map1_fds[i]);
 	}
 
 	/* current load_bpf_file has perf_event_open default pid = -1
@@ -80,6 +104,12 @@ static int test(char *filename, int num_progs)
 		verify_map(map1_fds[i]);
 	}
 
+cleanup:
+	for (j--; j >= 0; j--)
+		bpf_link__destroy(links[j]);
+
+	for (i--; i >= 0; i--)
+		bpf_object__close(objs[i]);
 	return 0;
 }
 
-- 
2.25.1

