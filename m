Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFF31227E6
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLQJrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:47:36 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37485 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfLQJrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 04:47:35 -0500
Received: by mail-pg1-f195.google.com with SMTP id q127so5374194pga.4;
        Tue, 17 Dec 2019 01:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Zgz8lGycvuOlZydtGR4nj5yt0vvWD8mSSZRbtN4Vh3M=;
        b=LHHqkDBMS/pC9wWp5ZMLaDtyJozOh4IbLdG/qgiTkcYXCNzGzdy4bYbSM5eBE3ClMr
         Kq1A8Ubhlt5GOmvXzyPHzfRKfjsMnPoQglVbzEIaGujWcqUk79CPcm0dUlM0gt4gZTOo
         WCnyAQCAaYuWz++9+fDrwLdjjeT/deld6bQETVH8Vdqa/jNVG3LXB8J1e+M/EPaAwiB0
         yyluRLj3ZCOFUKwDpAvFHr/Wl+n/iFNntqnhovkGicl6IWtcQWQf0SI+eqafCzLK/mNl
         eZMDWIV04EZOIjDKOd+BIjd7nA4pW0S25G7jerYOTZqzeDh0akAj/K5ywMHEWPfOwZMp
         hEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Zgz8lGycvuOlZydtGR4nj5yt0vvWD8mSSZRbtN4Vh3M=;
        b=l1BQtihf2LEPIqtvobZl8io7NuXL9Rfzxpz2pqpSaun0OvBrPb0FQMRz5M0FloipcP
         6+F65soSMM4/kqwhTVqGImeW9xcCTPE4lJLCVuC0AhY/r1QdpQ6If6girRnseMofSRwq
         5yocHyWmu48D9/3JKRo/gNKyDwVA95YVW24RsD5WvjY1x92P4Q+oN414BFibqNfzMdiS
         NJyutRUqhC78dIacbGKvWoe0DjxN1mQP6OFEFikQ62RJpvOYmjTeCHwIGRbyNCUTvSmX
         7oKeDJzP1SrlWfJwJ3TKTPGLDG4kaJDjofh6wluelOHWyAATqhsHiCYVEhbg/+2Z0WXG
         TQAg==
X-Gm-Message-State: APjAAAXBEL2XlaxKMSkeUTlGSFGnvOIkGGp7X4WzC0XVafn0URqQZD+/
        PCfEu9He+0m4zIALWi5J9czms5Qwo4KTkQ==
X-Google-Smtp-Source: APXvYqznAhol0fwPzWlNmEP8t2XgtGHI64hKxTBuxPpKkLmtIEz+d4ZnqkmV1lK/ABMz6JGRef9T7g==
X-Received: by 2002:a62:8602:: with SMTP id x2mr21508190pfd.39.1576576053988;
        Tue, 17 Dec 2019 01:47:33 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id o8sm2595978pjo.7.2019.12.17.01.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 01:47:33 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        bgregg@netflix.com, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v13 2/2] selftests/bpf: test for bpf_get_fd_path() from tracepoint
Date:   Tue, 17 Dec 2019 04:47:17 -0500
Message-Id: <56f0db8d7556bf84ccb3705b58d4e88ead04c894.1576575253.git.ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1576575253.git.ethercflow@gmail.com>
References: <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
 <cover.1576575253.git.ethercflow@gmail.com>
In-Reply-To: <cover.1576575253.git.ethercflow@gmail.com>
References: <cover.1576575253.git.ethercflow@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trace fstat events by tracepoint syscalls/sys_enter_newfstat, and handle
events only produced by test_file_fd_path, which call fstat on several
different types of files to test bpf_fd_file_path's feature.

v5->v6: addressed Gregg and Yonghong's feedback
- rename to get_fd_path
- change sys_enter_newfstat_args's fd type to long to fix issue on
big-endian machines

v4->v5: addressed Andrii's feedback
- pass NULL for opts as bpf_object__open_file's PARAM2, as not really
using any
- modify patch subject to keep up with test code
- as this test is single-threaded, so use getpid instead of SYS_gettid
- remove unnecessary parens around check which after if (i < 3)
- in kern use bpf_get_current_pid_tgid() >> 32 to fit getpid() in
userspace part
- with the patch adding helper as one patch series

v3->v4: addressed Andrii's feedback
- use a set of fd instead of fds array
- use global variables instead of maps (in v3, I mistakenly thought that
the bpf maps are global variables.)
- remove uncessary global variable path_info_index
- remove fd compare as the fstat's order is fixed

v2->v3: addressed Andrii's feedback
- use global data instead of perf_buffer to simplified code

v1->v2: addressed Daniel's feedback
- rename bpf_fd2path to bpf_get_file_path to be consistent with other
helper's names

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 .../selftests/bpf/prog_tests/get_fd_path.c    | 171 ++++++++++++++++++
 .../selftests/bpf/progs/test_get_fd_path.c    |  43 +++++
 2 files changed, 214 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_fd_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_fd_path.c

diff --git a/tools/testing/selftests/bpf/prog_tests/get_fd_path.c b/tools/testing/selftests/bpf/prog_tests/get_fd_path.c
new file mode 100644
index 000000000000..5cf58028a8d2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/get_fd_path.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <sys/stat.h>
+#include <linux/sched.h>
+#include <sys/syscall.h>
+
+#define MAX_PATH_LEN		128
+#define MAX_FDS			7
+#define MAX_EVENT_NUM		16
+
+static struct fd_path_test_data {
+	pid_t pid;
+	__u32 cnt;
+	__u32 fds[MAX_EVENT_NUM];
+	char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
+} src, dst;
+
+static int set_pathname(int fd)
+{
+	char buf[MAX_PATH_LEN];
+
+	snprintf(buf, MAX_PATH_LEN, "/proc/%d/fd/%d", src.pid, fd);
+	src.fds[src.cnt] = fd;
+	return readlink(buf, src.paths[src.cnt++], MAX_PATH_LEN);
+}
+
+static int trigger_fstat_events(pid_t pid)
+{
+	int pipefd[2] = { -1, -1 };
+	int sockfd = -1, procfd = -1, devfd = -1;
+	int localfd = -1, indicatorfd = -1;
+	struct stat fileStat;
+	int ret = -1;
+
+	/* unmountable pseudo-filesystems */
+	if (CHECK_FAIL(pipe(pipefd) < 0))
+		return ret;
+	/* unmountable pseudo-filesystems */
+	sockfd = socket(AF_INET, SOCK_STREAM, 0);
+	if (CHECK_FAIL(sockfd < 0))
+		goto out_close;
+	/* mountable pseudo-filesystems */
+	procfd = open("/proc/self/comm", O_RDONLY);
+	if (CHECK_FAIL(procfd < 0))
+		goto out_close;
+	devfd = open("/dev/urandom", O_RDONLY);
+	if (CHECK_FAIL(devfd < 0))
+		goto out_close;
+	localfd = open("/tmp/fd2path_loadgen.txt", O_CREAT | O_RDONLY);
+	if (CHECK_FAIL(localfd < 0))
+		goto out_close;
+	/* bpf_get_fd_path will return path with (deleted) */
+	remove("/tmp/fd2path_loadgen.txt");
+	indicatorfd = open("/tmp/", O_PATH);
+	if (CHECK_FAIL(indicatorfd < 0))
+		goto out_close;
+
+	src.pid = pid;
+
+	ret = set_pathname(pipefd[0]);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(pipefd[1]);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(sockfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(procfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(devfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(localfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+	ret = set_pathname(indicatorfd);
+	if (CHECK_FAIL(ret < 0))
+		goto out_close;
+
+	fstat(pipefd[0], &fileStat);
+	fstat(pipefd[1], &fileStat);
+	fstat(sockfd, &fileStat);
+	fstat(procfd, &fileStat);
+	fstat(devfd, &fileStat);
+	fstat(localfd, &fileStat);
+	fstat(indicatorfd, &fileStat);
+
+out_close:
+	close(indicatorfd);
+	close(localfd);
+	close(devfd);
+	close(procfd);
+	close(sockfd);
+	close(pipefd[1]);
+	close(pipefd[0]);
+
+	return ret;
+}
+
+void test_get_fd_path(void)
+{
+	const char *prog_name = "tracepoint/syscalls/sys_enter_newfstat";
+	const char *obj_file = "test_get_fd_path.o";
+	int err, results_map_fd, duration = 0;
+	struct bpf_program *tp_prog = NULL;
+	struct bpf_link *tp_link = NULL;
+	struct bpf_object *obj = NULL;
+	const int zero = 0;
+
+	obj = bpf_object__open_file(obj_file, NULL);
+	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+		return;
+
+	tp_prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!tp_prog, "find_tp",
+		  "prog '%s' not found\n", prog_name))
+		goto cleanup;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto cleanup;
+
+	results_map_fd = bpf_find_map(__func__, obj, "test_get.bss");
+	if (CHECK(results_map_fd < 0, "find_bss_map",
+		  "err %d\n", results_map_fd))
+		goto cleanup;
+
+	tp_link = bpf_program__attach_tracepoint(tp_prog, "syscalls",
+						 "sys_enter_newfstat");
+	if (CHECK(IS_ERR(tp_link), "attach_tp",
+		  "err %ld\n", PTR_ERR(tp_link))) {
+		tp_link = NULL;
+		goto cleanup;
+	}
+
+	dst.pid = getpid();
+	err = bpf_map_update_elem(results_map_fd, &zero, &dst, 0);
+	if (CHECK(err, "update_elem",
+		  "failed to set pid filter: %d\n", err))
+		goto cleanup;
+
+	err = trigger_fstat_events(dst.pid);
+	if (CHECK_FAIL(err < 0))
+		goto cleanup;
+
+	err = bpf_map_lookup_elem(results_map_fd, &zero, &dst);
+	if (CHECK(err, "get_results",
+		  "failed to get results: %d\n", err))
+		goto cleanup;
+
+	for (int i = 0; i < MAX_FDS; i++) {
+		if (i < 3)
+			CHECK((dst.paths[i][0] != '0'), "get_fd_path",
+			      "failed to filter fs [%d]: %u(%s) vs %u(%s)\n",
+			      i, src.fds[i], src.paths[i], dst.fds[i],
+			      dst.paths[i]);
+		else
+			CHECK(strncmp(src.paths[i], dst.paths[i], MAX_PATH_LEN),
+			      "get_fd_path",
+			      "failed to get path[%d]: %u(%s) vs %u(%s)\n",
+			      i, src.fds[i], src.paths[i], dst.fds[i],
+			      dst.paths[i]);
+	}
+
+cleanup:
+	bpf_link__destroy(tp_link);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_get_fd_path.c b/tools/testing/selftests/bpf/progs/test_get_fd_path.c
new file mode 100644
index 000000000000..8bb58f87755e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_get_fd_path.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/ptrace.h>
+#include <string.h>
+#include <unistd.h>
+#include "bpf_helpers.h"
+#include "bpf_tracing.h"
+
+#define MAX_PATH_LEN		128
+#define MAX_EVENT_NUM		16
+
+static struct fd_path_test_data {
+	pid_t pid;
+	__u32 cnt;
+	__u32 fds[MAX_EVENT_NUM];
+	char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
+} data;
+
+struct sys_enter_newfstat_args {
+	unsigned long long pad1;
+	unsigned long long pad2;
+	unsigned long fd;
+};
+
+SEC("tracepoint/syscalls/sys_enter_newfstat")
+int bpf_prog(struct sys_enter_newfstat_args *args)
+{
+	pid_t pid = bpf_get_current_pid_tgid() >> 32;
+
+	if (pid != data.pid)
+		return 0;
+	if (data.cnt >= MAX_EVENT_NUM)
+		return 0;
+
+	data.fds[data.cnt] = args->fd;
+	bpf_get_fd_path(data.paths[data.cnt], MAX_PATH_LEN, args->fd);
+	data.cnt++;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

