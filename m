Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D6E2B95C0
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgKSPGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgKSPGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 10:06:46 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619C7C0613CF;
        Thu, 19 Nov 2020 07:06:45 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id u2so3071092pls.10;
        Thu, 19 Nov 2020 07:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qXzyHl2UKHL9BRwjscN/3wujqc6R2rNgY3Fb/NFAbvQ=;
        b=lMHVJ6ErAfA7DdK4FwHcZunRrjonfkm+AcHUT1xtOD7Aae0hnntXoVomqd/SzTGtGf
         IHOPUHWTAouBEJAaca42fOZNuWOLxUQpFyBj5WrpflEutfL6be73HXxf9Ddy3ixZtYgW
         72HlGYveHWIrlZEuz9vPVQNTiwV2lCRvvbaaG2tGiODOKm7eF/bfp9fYNWchj0azZ0fF
         F9NTEYSQcVBcTScRbC+A5j453gzwTqG5t0sMaB3bzB2sZgwFSUWFuBwAjf27FZKeUuSq
         fArotw7BY8mwbaKfj7N7hL1dx+heQqkoInyl7lEFUVKw86Ti+PhWrTrBPWAt7JdIJDU1
         D7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qXzyHl2UKHL9BRwjscN/3wujqc6R2rNgY3Fb/NFAbvQ=;
        b=Zek3Npz8t/tiGzYR/HVpui84PxoG1qtIGxFXwPapc55NRGfIxcyGbouRWWtdJMHDsL
         7CERYHgDRAWyusEs3mQSfe/PXPuvQnI+WqF3oA/X7YYk3FKUcqC9Vz5J+iGY0sHo+3k3
         8wfQNWUH9M1MGBcUlq5nLk3Sy/1ChvOHkuNwA5is8ltwNNn+xXufQ2Koz92iU4CgATcO
         a2Nxu6x+wgeA2zfS9oGjCi9HI10ZB21mo9v+4H/Pj9FcqTDnH6c2ihCYcQrO77WXk2mv
         xJW7CSRyhESGlfZSzCVDozuAoMShd08qFwdVBbHZWruj6ndRqNuhpM0qoqQEWNIC1DBc
         6M5g==
X-Gm-Message-State: AOAM531OVUDqbBxsopFq37Hotvr0zSDRpvz15wQ1wpnSwFq7U3ZY5NZK
        7LWPOSvasehQMOae6HzrGQ==
X-Google-Smtp-Source: ABdhPJwXfUqJmIBfhGlaGrP41GesX4+sWoKoeXkW04Q0Rr8DgSURsb7Ci8b1z0w0bAc9HFy3YW9b7g==
X-Received: by 2002:a17:902:144:b029:d7:dbfc:beee with SMTP id 62-20020a1709020144b02900d7dbfcbeeemr9589790plb.32.1605798404629;
        Thu, 19 Nov 2020 07:06:44 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id b80sm77783pfb.40.2020.11.19.07.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 07:06:44 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v2 3/7] samples: bpf: refactor task_fd_query program with libbpf
Date:   Thu, 19 Nov 2020 15:06:13 +0000
Message-Id: <20201119150617.92010-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119150617.92010-1-danieltimlee@gmail.com>
References: <20201119150617.92010-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit refactors the existing kprobe program with libbpf bpf
loader. To attach bpf program, this uses generic bpf_program__attach()
approach rather than using bpf_load's load_bpf_file().

To attach bpf to perf_event, instead of using previous ioctl method,
this commit uses bpf_program__attach_perf_event since it manages the
enable of perf_event and attach of BPF programs to it, which is much
more intuitive way to achieve.

Also, explicit close(fd) has been removed since event will be closed
inside bpf_link__destroy() automatically.

Furthermore, to prevent conflict of same named uprobe events, O_TRUNC
flag has been used to clear 'uprobe_events' interface.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes in v2:
 - add static at global variable and drop {}
 - fix return error code on exit
 - restore DEBUGFS macro to absolute string path

 samples/bpf/Makefile             |   2 +-
 samples/bpf/task_fd_query_user.c | 101 ++++++++++++++++++++++---------
 2 files changed, 75 insertions(+), 28 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index d31e082c369e..3bffd42e1482 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -107,7 +107,7 @@ xdp_adjust_tail-objs := xdp_adjust_tail_user.o
 xdpsock-objs := xdpsock_user.o
 xsk_fwd-objs := xsk_fwd.o
 xdp_fwd-objs := xdp_fwd_user.o
-task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
+task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := hbm.o $(CGROUP_HELPERS)
diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
index b68bd2f8fdc9..f6b772faa348 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -15,12 +15,15 @@
 #include <sys/stat.h>
 #include <linux/perf_event.h>
 
+#include <bpf/bpf.h>
 #include <bpf/libbpf.h>
-#include "bpf_load.h"
 #include "bpf_util.h"
 #include "perf-sys.h"
 #include "trace_helpers.h"
 
+static struct bpf_program *progs[2];
+static struct bpf_link *links[2];
+
 #define CHECK_PERROR_RET(condition) ({			\
 	int __ret = !!(condition);			\
 	if (__ret) {					\
@@ -86,21 +89,22 @@ static int bpf_get_retprobe_bit(const char *event_type)
 	return ret;
 }
 
-static int test_debug_fs_kprobe(int prog_fd_idx, const char *fn_name,
+static int test_debug_fs_kprobe(int link_idx, const char *fn_name,
 				__u32 expected_fd_type)
 {
 	__u64 probe_offset, probe_addr;
 	__u32 len, prog_id, fd_type;
+	int err, event_fd;
 	char buf[256];
-	int err;
 
 	len = sizeof(buf);
-	err = bpf_task_fd_query(getpid(), event_fd[prog_fd_idx], 0, buf, &len,
+	event_fd = bpf_link__fd(links[link_idx]);
+	err = bpf_task_fd_query(getpid(), event_fd, 0, buf, &len,
 				&prog_id, &fd_type, &probe_offset,
 				&probe_addr);
 	if (err < 0) {
 		printf("FAIL: %s, for event_fd idx %d, fn_name %s\n",
-		       __func__, prog_fd_idx, fn_name);
+		       __func__, link_idx, fn_name);
 		perror("    :");
 		return -1;
 	}
@@ -108,7 +112,7 @@ static int test_debug_fs_kprobe(int prog_fd_idx, const char *fn_name,
 	    fd_type != expected_fd_type ||
 	    probe_offset != 0x0 || probe_addr != 0x0) {
 		printf("FAIL: bpf_trace_event_query(event_fd[%d]):\n",
-		       prog_fd_idx);
+		       link_idx);
 		printf("buf: %s, fd_type: %u, probe_offset: 0x%llx,"
 		       " probe_addr: 0x%llx\n",
 		       buf, fd_type, probe_offset, probe_addr);
@@ -125,12 +129,13 @@ static int test_nondebug_fs_kuprobe_common(const char *event_type,
 	int is_return_bit = bpf_get_retprobe_bit(event_type);
 	int type = bpf_find_probe_type(event_type);
 	struct perf_event_attr attr = {};
-	int fd;
+	struct bpf_link *link;
+	int fd, err = -1;
 
 	if (type < 0 || is_return_bit < 0) {
 		printf("FAIL: %s incorrect type (%d) or is_return_bit (%d)\n",
 			__func__, type, is_return_bit);
-		return -1;
+		return err;
 	}
 
 	attr.sample_period = 1;
@@ -149,14 +154,21 @@ static int test_nondebug_fs_kuprobe_common(const char *event_type,
 	attr.type = type;
 
 	fd = sys_perf_event_open(&attr, -1, 0, -1, 0);
-	CHECK_PERROR_RET(fd < 0);
+	link = bpf_program__attach_perf_event(progs[0], fd);
+	if (libbpf_get_error(link)) {
+		printf("ERROR: bpf_program__attach_perf_event failed\n");
+		link = NULL;
+		close(fd);
+		goto cleanup;
+	}
 
-	CHECK_PERROR_RET(ioctl(fd, PERF_EVENT_IOC_ENABLE, 0) < 0);
-	CHECK_PERROR_RET(ioctl(fd, PERF_EVENT_IOC_SET_BPF, prog_fd[0]) < 0);
 	CHECK_PERROR_RET(bpf_task_fd_query(getpid(), fd, 0, buf, buf_len,
 			 prog_id, fd_type, probe_offset, probe_addr) < 0);
+	err = 0;
 
-	return 0;
+cleanup:
+	bpf_link__destroy(link);
+	return err;
 }
 
 static int test_nondebug_fs_probe(const char *event_type, const char *name,
@@ -215,17 +227,18 @@ static int test_nondebug_fs_probe(const char *event_type, const char *name,
 
 static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
 {
+	char buf[256], event_alias[sizeof("test_1234567890")];
 	const char *event_type = "uprobe";
 	struct perf_event_attr attr = {};
-	char buf[256], event_alias[sizeof("test_1234567890")];
 	__u64 probe_offset, probe_addr;
 	__u32 len, prog_id, fd_type;
-	int err, res, kfd, efd;
+	int err = -1, res, kfd, efd;
+	struct bpf_link *link;
 	ssize_t bytes;
 
 	snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/%s_events",
 		 event_type);
-	kfd = open(buf, O_WRONLY | O_APPEND, 0);
+	kfd = open(buf, O_WRONLY | O_TRUNC, 0);
 	CHECK_PERROR_RET(kfd < 0);
 
 	res = snprintf(event_alias, sizeof(event_alias), "test_%d", getpid());
@@ -254,10 +267,15 @@ static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
 	attr.type = PERF_TYPE_TRACEPOINT;
 	attr.sample_period = 1;
 	attr.wakeup_events = 1;
+
 	kfd = sys_perf_event_open(&attr, -1, 0, -1, PERF_FLAG_FD_CLOEXEC);
-	CHECK_PERROR_RET(kfd < 0);
-	CHECK_PERROR_RET(ioctl(kfd, PERF_EVENT_IOC_SET_BPF, prog_fd[0]) < 0);
-	CHECK_PERROR_RET(ioctl(kfd, PERF_EVENT_IOC_ENABLE, 0) < 0);
+	link = bpf_program__attach_perf_event(progs[0], kfd);
+	if (libbpf_get_error(link)) {
+		printf("ERROR: bpf_program__attach_perf_event failed\n");
+		link = NULL;
+		close(kfd);
+		goto cleanup;
+	}
 
 	len = sizeof(buf);
 	err = bpf_task_fd_query(getpid(), kfd, 0, buf, &len,
@@ -283,9 +301,11 @@ static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
 		       probe_offset);
 		return -1;
 	}
+	err = 0;
 
-	close(kfd);
-	return 0;
+cleanup:
+	bpf_link__destroy(link);
+	return err;
 }
 
 int main(int argc, char **argv)
@@ -294,21 +314,42 @@ int main(int argc, char **argv)
 	extern char __executable_start;
 	char filename[256], buf[256];
 	__u64 uprobe_file_offset;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int i = 0, err = -1;
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
 		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
+		return err;
 	}
 
 	if (load_kallsyms()) {
 		printf("failed to process /proc/kallsyms\n");
-		return 1;
+		return err;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		return err;
 	}
 
-	if (load_bpf_file(filename)) {
-		printf("%s", bpf_log_buf);
-		return 1;
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		progs[i] = prog;
+		links[i] = bpf_program__attach(progs[i]);
+		if (libbpf_get_error(links[i])) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[i] = NULL;
+			goto cleanup;
+		}
+		i++;
 	}
 
 	/* test two functions in the corresponding *_kern.c file */
@@ -378,6 +419,12 @@ int main(int argc, char **argv)
 					   false));
 	CHECK_AND_RET(test_debug_fs_uprobe((char *)argv[0], uprobe_file_offset,
 					   true));
+	err = 0;
 
-	return 0;
+cleanup:
+	for (i--; i >= 0; i--)
+		bpf_link__destroy(links[i]);
+
+	bpf_object__close(obj);
+	return err;
 }
-- 
2.25.1

