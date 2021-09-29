Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B836941D053
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347436AbhI3ABa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347803AbhI3ABW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:22 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6BCC06161C;
        Wed, 29 Sep 2021 16:59:39 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 17so4417945pgp.4;
        Wed, 29 Sep 2021 16:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SeW9IyjC8FDrN2b97FwSq6NgPOwaqfr8OViG/D/wOaY=;
        b=fFNMKOyaHiFWb/xovK4KpSkMzWc8CtTRx03snz/8/ZjxR4F2CgqHd6xy207iZFtUFZ
         0oTMtyp/Og23p1J+36i2IznZ8Jkwf6PscgjxFNi7SN/u+ovqc1jazJSBg9I8SsLZMSu9
         Qt/Dm6yUhapoyiTRgcEBdKtE7LijMW/g3GjS0Zh9FjbdNs8rt3a4QxjRHqEUHf56IMdX
         ivpBzCGwj7kP0BmawkX8qD7n07E3Iu3M87vwNXJc7Zeq/3Hpf+r5FxFQHYFofWTX4qK9
         QpIn4TvRq3kMbAZuBMqhfW8IsY0gWJGbfO6UxgrGn5egY++TdAbOrllL4lw8ctz/Hh8w
         1aXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeW9IyjC8FDrN2b97FwSq6NgPOwaqfr8OViG/D/wOaY=;
        b=3n/fwsZeMfYO3uJtFh8ZZi2vIWgAyRjKeDes3TJPVenqTZb9T68QzwSisNzLCZ57D/
         b9rUl1LBj2x2pzQ46iYDQCKUN4jnOlQWjE4VuTAlnxqIUdmYfkJo1tq0nTF9NVCmnnmP
         dh+L8jDO1+lGyvnw3xar6bjuBR+J3AazkxvQOZte0WJYvQwe5tvPZlRDPhpDPa1hmMwK
         9nWwV8smg+AGrDJUTNwRFcaOzjP9n4GquZnPloXiWGKAQEabLa8jB561c9GfF+jpAbDk
         DDJJ2rjKuCXaLqPyBFizUvnyeNIYEjge2CLyWyo2dCKQqvBUwHl5nkxqYTY0UeS1w5l0
         teEg==
X-Gm-Message-State: AOAM533YWBom/7RXboQsreSV7QPMSZcsu5Fxx+h489s4G0PH91A/2IGU
        HmHX1otISovZn1hMFNti7A==
X-Google-Smtp-Source: ABdhPJy0DN2IGWpeLMMIf+hsWEAGdrbBtHv5POkeNA8pdKRDMCEIrCBjW4JGRSHzsuuzelNJtDdpCQ==
X-Received: by 2002:a63:258:: with SMTP id 85mr2280037pgc.11.1632959979331;
        Wed, 29 Sep 2021 16:59:39 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:39 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 13/13] bpf: Add real world example for map tracing
Date:   Wed, 29 Sep 2021 23:59:10 +0000
Message-Id: <20210929235910.1765396-14-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add an example that demonstrates how map tracing helps us avoid race
conditions while upgrading stateful program.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 .../selftests/bpf/prog_tests/bpf_map_trace.c  | 257 ++++++++++++++++++
 .../progs/bpf_map_trace_real_world_common.h   | 125 +++++++++
 .../bpf_map_trace_real_world_migration.c      |  96 +++++++
 .../bpf/progs/bpf_map_trace_real_world_new.c  |   4 +
 .../bpf/progs/bpf_map_trace_real_world_old.c  |   5 +
 5 files changed, 487 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_migration.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_new.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_old.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_map_trace.c b/tools/testing/selftests/bpf/prog_tests/bpf_map_trace.c
index 89bae9a83339..cd60a0c78202 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_map_trace.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_map_trace.c
@@ -19,6 +19,9 @@
 #include "bpf_map_trace_delete_elem.skel.h"
 #include "bpf_map_trace_loop0.skel.h"
 #include "bpf_map_trace_loop1.skel.h"
+#include "bpf_map_trace_real_world_migration.skel.h"
+#include "bpf_map_trace_real_world_new.skel.h"
+#include "bpf_map_trace_real_world_old.skel.h"
 #include "bpf_map_trace_update_elem.skel.h"
 
 uint32_t collatz(uint32_t x)
@@ -130,8 +133,262 @@ void infinite_loop__indirect(void)
 	bpf_map_trace_loop1__destroy(skel);
 }
 
+int real_world_example__attach_migration(
+		struct bpf_map_trace_real_world_migration *migration_skel,
+		struct bpf_link **iter_link,
+		struct bpf_link **map_trace_link_update,
+		struct bpf_link **map_trace_link_delete)
+{
+	union bpf_iter_link_info iter_link_info;
+	struct bpf_iter_attach_opts iter_opts;
+	int64_t error;
+
+	*map_trace_link_update = bpf_program__attach(
+			migration_skel->progs.copy_on_write__update);
+	error = libbpf_get_error(map_trace_link_update);
+	if (!ASSERT_EQ(error, 0,
+		       "copy_on_write update bpf_program__attach failure"))
+		return 1;
+
+	*map_trace_link_delete = bpf_program__attach(
+			migration_skel->progs.copy_on_write__delete);
+	error = libbpf_get_error(map_trace_link_delete);
+	if (!ASSERT_EQ(error, 0,
+		       "copy_on_write update bpf_program__delete failure"))
+		return 1;
+
+	memset(&iter_link_info, 0, sizeof(iter_link_info));
+	iter_link_info.map.map_fd = bpf_map__fd(migration_skel->maps.old_map);
+
+	memset(&iter_opts, 0, sizeof(iter_opts));
+	iter_opts.sz = sizeof(iter_opts);
+	iter_opts.link_info = &iter_link_info;
+	iter_opts.link_info_len = sizeof(iter_link_info);
+	*iter_link = bpf_program__attach_iter(
+			migration_skel->progs.bulk_migration, &iter_opts);
+	error = libbpf_get_error(iter_link);
+	if (!ASSERT_EQ(error, 0, "bpf_program__attach_iter failure"))
+		return 1;
+
+	return 0;
+}
+
+int open_and_write_files(const char *path, size_t num_files)
+{
+	int *fds = malloc(sizeof(int) * num_files);
+	ssize_t bytes_written;
+	const char buf = 'a';
+	size_t i, j;
+	int ret = 0;
+
+	if (fds == NULL)
+		return 1;
+
+	for (i = 0; i < num_files; i++) {
+		fds[i] = open(path, O_WRONLY | O_CREAT);
+
+		if (fds[i] < 0) {
+			ret = 2;
+			break;
+		}
+		bytes_written = write(fds[i], &buf, sizeof(buf));
+		if (bytes_written != sizeof(buf)) {
+			ret = 3;
+			break;
+		}
+	}
+	for (j = 0; j < i; j++)
+		close(fds[j]);
+	return ret;
+}
+
+void real_world_example(void)
+{
+	struct bpf_map_trace_real_world_migration *migration_skel = NULL;
+	int file_fd_should_write = -1, file_fd_should_not_write = -1;
+	struct bpf_map_trace_real_world_new *new_skel = NULL;
+	struct bpf_map_trace_real_world_old *old_skel = NULL;
+	struct bpf_link *map_trace_link_update = NULL;
+	struct bpf_link *map_trace_link_delete = NULL;
+	struct bpf_link *iter_link = NULL;
+	const bool enable_filtering = 1;
+	const uint32_t pid = getpid();
+	uint32_t max_open_files;
+	char file_buf = 'a';
+	int iter_fd = -1;
+	char iter_buf[1];
+	int rc;
+
+	/*
+	 * Begin by loading and attaching the old version of our program.
+	 */
+	old_skel = bpf_map_trace_real_world_old__open_and_load();
+	if (!ASSERT_NEQ(old_skel, NULL, "open/load old skeleton"))
+		return;
+	rc = bpf_map_trace_real_world_old__attach(old_skel);
+	if (!ASSERT_EQ(rc, 0, "attach old skeleton")) {
+		fprintf(stderr, "Failed to attach skeleton: %d\n", errno);
+		goto out;
+	}
+	rc = bpf_map_update_elem(bpf_map__fd(old_skel->maps.filtered_pids),
+				 &pid, &enable_filtering, /*flags=*/0);
+	if (!ASSERT_EQ(rc, 0, "configure process to be filtered"))
+		return;
+	if (!ASSERT_EQ(open_and_write_files("/tmp/tst_file", 1), 0,
+		       "program allows writing a single new file"))
+		goto out;
+	max_open_files = bpf_map__max_entries(old_skel->maps.allow_reads);
+	if (!ASSERT_NEQ(open_and_write_files("/tmp/tst_file",
+					     max_open_files + 1), 0,
+		       "program blocks writing too many new files"))
+		goto out;
+
+	/*
+	 * Then load the new version of the program.
+	 */
+	new_skel = bpf_map_trace_real_world_new__open_and_load();
+	if (!ASSERT_NEQ(new_skel, NULL, "open/load new skeleton"))
+		goto out;
+
+	/*
+	 * Hook up the migration programs. This gives the old map
+	 * copy-on-write semantics.
+	 */
+	migration_skel = bpf_map_trace_real_world_migration__open();
+	if (!ASSERT_NEQ(migration_skel, NULL, "open migration skeleton"))
+		goto out;
+	rc = bpf_map__reuse_fd(migration_skel->maps.old_map,
+			       bpf_map__fd(old_skel->maps.allow_reads));
+	if (!ASSERT_EQ(rc, 0, "reuse old map fd"))
+		goto out;
+	rc = bpf_map__reuse_fd(migration_skel->maps.new_map,
+			       bpf_map__fd(new_skel->maps.allow_reads));
+	if (!ASSERT_EQ(rc, 0, "reuse new map fd"))
+		goto out;
+	rc = bpf_map_trace_real_world_migration__load(migration_skel);
+	if (!ASSERT_EQ(rc, 0, "load migration skeleton"))
+		goto out;
+	rc = real_world_example__attach_migration(migration_skel,
+						  &iter_link,
+						  &map_trace_link_update,
+						  &map_trace_link_delete);
+	if (!ASSERT_EQ(rc, 0, "attach migration programs"))
+		goto out;
+
+	/*
+	 * Simulated race condition type 1: An application opens an fd before
+	 * bulk transfer and closes it after.
+	 */
+	file_fd_should_not_write = open("/tmp/tst_file", O_WRONLY | O_CREAT);
+	if (!ASSERT_GE(file_fd_should_not_write, 0,
+		       "open file before bulk migration"))
+		goto out;
+
+	/*
+	 * Perform bulk transfer.
+	 */
+	iter_fd = bpf_iter_create(bpf_link__fd(iter_link));
+	if (!ASSERT_GE(iter_fd, 0, "create iterator"))
+		goto out;
+	rc = read(iter_fd, &iter_buf, sizeof(iter_buf));
+	if (!ASSERT_EQ(rc, 0, "execute map iterator"))
+		goto out;
+	rc = bpf_map_update_elem(bpf_map__fd(new_skel->maps.filtered_pids),
+				 &pid, &enable_filtering, /*flags=*/0);
+	if (!ASSERT_EQ(rc, 0, "configure process to be filtered"))
+		goto out;
+
+	/*
+	 * Simulated race condition type 1 (continued). This close() does not
+	 * propagate to the new map without copy-on-write semantics, so it
+	 * would occupy a spot in the map until our app happens to close an fd
+	 * with the same number. This would subtly degrade the contract with
+	 * the application.
+	 */
+	close(file_fd_should_not_write);
+	file_fd_should_not_write = -1;
+
+	/*
+	 * Simulated race condition type 2: An application opens a file
+	 * descriptor after bulk transfer. This openat() does not propagate to
+	 * the new map without copy-on-write, so our app would not be able to
+	 * write to it.
+	 */
+	file_fd_should_write = open("/tmp/tst_file", O_WRONLY | O_CREAT);
+	if (!ASSERT_GE(file_fd_should_write, 0,
+		       "open file after bulk migration"))
+		goto out;
+
+	/*
+	 * State is migrated. Load new programs.
+	 */
+	rc = bpf_map_trace_real_world_new__attach(new_skel);
+	if (!ASSERT_EQ(rc, 0, "failed to attach new programs"))
+		goto out;
+
+	/*
+	 * Unload migration progs.
+	 */
+	close(iter_fd);
+	iter_fd = -1;
+	bpf_link__destroy(map_trace_link_update);
+	map_trace_link_update = NULL;
+	bpf_link__destroy(map_trace_link_delete);
+	map_trace_link_delete = NULL;
+	bpf_link__destroy(iter_link);
+	iter_link = NULL;
+	bpf_map_trace_real_world_migration__destroy(migration_skel);
+	migration_skel = NULL;
+
+	/*
+	 * Unload old programs.
+	 */
+	bpf_map_trace_real_world_old__destroy(old_skel);
+	old_skel = NULL;
+
+	if (!ASSERT_EQ(open_and_write_files("/tmp/tst_file", 1), 0,
+		       "program allows writing a single new file"))
+		goto out;
+	max_open_files = bpf_map__max_entries(new_skel->maps.allow_reads);
+	if (!ASSERT_NEQ(open_and_write_files("/tmp/tst_file",
+					     max_open_files + 1), 0,
+		       "program blocks writing too many new files"))
+		goto out;
+	/*
+	 * Simulated race condition type 2 (continued): If we didn't do
+	 * copy-on-write, this would be expected to fail, since the FD would
+	 * not be in the new map.
+	 */
+	rc = write(file_fd_should_write, &file_buf, sizeof(file_buf));
+	if (!ASSERT_EQ(rc, sizeof(file_buf),
+		       "migrated program allows writing to file opened before migration"))
+		goto out;
+
+out:
+	if (old_skel)
+		bpf_map_trace_real_world_old__destroy(old_skel);
+	if (new_skel)
+		bpf_map_trace_real_world_new__destroy(new_skel);
+	if (migration_skel)
+		bpf_map_trace_real_world_migration__destroy(migration_skel);
+	if (map_trace_link_update)
+		bpf_link__destroy(map_trace_link_update);
+	if (map_trace_link_delete)
+		bpf_link__destroy(map_trace_link_delete);
+	if (iter_link)
+		bpf_link__destroy(iter_link);
+	if (iter_fd > -1)
+		close(iter_fd);
+	if (file_fd_should_write > -1)
+		close(file_fd_should_write);
+	if (file_fd_should_not_write > -1)
+		close(file_fd_should_not_write);
+}
+
 void test_bpf_map_trace(void)
 {
+	if (test__start_subtest("real_world_example"))
+		real_world_example();
 	if (test__start_subtest("update_elem__basic"))
 		update_elem__basic();
 	if (test__start_subtest("delete_elem__basic"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_common.h b/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_common.h
new file mode 100644
index 000000000000..230610e1b5d5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_common.h
@@ -0,0 +1,125 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021 Google */
+#pragma once
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+#include <string.h>
+
+/*
+ * Mock "real world" application.
+ *
+ * Blocks all writes from a set of applications. A limited number of newly
+ * openat()ed file descriptors file descriptors may be written to. Writes to
+ * already-open file descriptors are blocked.
+ *
+ * The affected processes are selected by populating filtered_pid.
+ *
+ * It is intended as an example of a stateful policy-enforcement application
+ * which benefits from map tracing. It is not intended to be useful.
+ */
+
+/*
+ * This is the only difference between the old and new application. Since we're
+ * enforcing a policy based on this data, we want to migrate it. Since the
+ * application can modify the data in parallel, we need to give this map
+ * copy-on-write semantics so that those changes propagate.
+ */
+#if defined(OLD_VERSION)
+struct allow_reads_key {
+	uint32_t pid;
+	int fd;
+};
+#else
+struct allow_reads_key {
+	int fd;
+	uint32_t pid;
+};
+#endif
+struct allow_reads_value {
+	bool do_allow;
+};
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 16);
+	__type(key, struct allow_reads_key);
+	__type(value, struct allow_reads_value);
+} allow_reads SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 16);
+	__type(key, uint32_t);
+	__type(value, bool);
+} filtered_pids SEC(".maps");
+
+
+SEC("kretprobe/__x64_sys_openat")
+int BPF_KRETPROBE(kretprobe__x64_sys_openat, int ret)
+{
+	struct allow_reads_key key;
+	struct allow_reads_value val;
+	uint32_t pid;
+	char *pid_is_filtered;
+
+	pid = (bpf_get_current_pid_tgid() >> 32) & 0xFFFFFFFF;
+	memset(&key, 0, sizeof(key));
+	key.pid = pid;
+	key.fd = ret;
+	val.do_allow = true;
+
+	if (ret < 0)
+		return 0;
+
+	pid_is_filtered = bpf_map_lookup_elem(&filtered_pids, &pid);
+	if (!pid_is_filtered)
+		return 0;
+
+	if (!*pid_is_filtered)
+		return 0;
+
+	/*
+	 * Ignore errors. Failing to insert has the effect of blocking writes
+	 * on that file descriptor.
+	 */
+	bpf_map_update_elem(&allow_reads, &key, &val, /*flags=*/0);
+	return 0;
+}
+
+SEC("fmod_ret/__x64_sys_write")
+int BPF_PROG(fmod_ret__x64_sys_write, struct pt_regs *regs, int ret)
+{
+	int fd = PT_REGS_PARM1(regs);
+	struct allow_reads_value *val;
+	struct allow_reads_key key;
+
+	memset(&key, 0, sizeof(key));
+	key.pid = (bpf_get_current_pid_tgid() >> 32) & 0xFFFFFFFF;
+	key.fd = fd;
+	val = bpf_map_lookup_elem(&allow_reads, &key);
+	if (!val)
+		return -EPERM;
+	return val->do_allow ? 0 : -EPERM;
+}
+
+SEC("fmod_ret/__x64_sys_close")
+int BPF_PROG(fmod_ret__x64_sys_close, struct pt_regs *regs, int ret)
+{
+	int fd = PT_REGS_PARM1(regs);
+	struct allow_reads_key key;
+	struct allow_reads_value val;
+
+	memset(&key, 0, sizeof(key));
+	key.pid = (bpf_get_current_pid_tgid() >> 32) & 0xFFFFFFFF;
+	key.fd = fd;
+	val.do_allow = true;
+
+	bpf_map_delete_elem(&allow_reads, &key);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_migration.c b/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_migration.c
new file mode 100644
index 000000000000..d0a37ae1be26
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_migration.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+/* In the "real" real world, we would use BTF to generate a program which knows
+ * about the old and new map ABI. To keep things simple we'll just use a
+ * statically defined program which knows about them.
+ */
+struct allow_reads_key__old {
+	uint32_t pid;
+	int fd;
+};
+struct allow_reads_key__new {
+	int fd;
+	uint32_t pid;
+};
+struct allow_reads_value__old {
+	bool do_drop;
+};
+struct allow_reads_value__new {
+	bool do_drop;
+};
+
+/* Likewise, in the "real" real world we would simply generate a program
+ * containing the fd of this map. For libbpf to generate a skeleton for us we
+ * need to dupicate this definition.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 100);
+	__type(key, struct allow_reads_key__old);
+	__type(value, struct allow_reads_value__old);
+} old_map SEC(".maps");
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 100);
+	__type(key, struct allow_reads_key__new);
+	__type(value, struct allow_reads_value__new);
+} new_map SEC(".maps");
+
+static inline void read_migrate_write(void *key, void *value)
+{
+	struct allow_reads_key__old old_key = {};
+	struct allow_reads_key__new new_key = {};
+	char old_value = 0;
+
+	if (bpf_probe_read(&old_key, sizeof(old_key), key))
+		return; /* Could write to a map here */
+	if (bpf_probe_read(&old_value, sizeof(old_value), value))
+		return; /* Could write to a map here */
+
+	new_key.pid = old_key.pid;
+	new_key.fd = old_key.fd;
+
+	bpf_map_update_elem(&new_map, &new_key, &old_value, /*flags=*/0);
+}
+
+SEC("map_trace/old_map/UPDATE_ELEM")
+int copy_on_write__update(struct bpf_map_trace_ctx__update_elem *ctx)
+{
+	read_migrate_write(ctx->key, ctx->value);
+	return 0;
+}
+
+static inline void read_migrate_delete(void *key)
+{
+	struct allow_reads_key__old old_key = {};
+	struct allow_reads_key__new new_key = {};
+
+	if (bpf_probe_read(&old_key, sizeof(old_key), key))
+		return; /* Could write to a map here */
+
+	new_key.pid = old_key.pid;
+	new_key.fd = old_key.fd;
+
+	bpf_map_delete_elem(&new_map, &new_key);
+}
+
+SEC("map_trace/old_map/DELETE_ELEM")
+int copy_on_write__delete(struct bpf_map_trace_ctx__delete_elem *ctx)
+{
+	read_migrate_delete(ctx->key);
+	return 0;
+}
+
+SEC("iter/bpf_map_elem")
+int bulk_migration(struct bpf_iter__bpf_map_elem *ctx)
+{
+	read_migrate_write(ctx->key, ctx->value);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_new.c b/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_new.c
new file mode 100644
index 000000000000..9b7c4ca1deed
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_new.c
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#include "bpf_map_trace_real_world_common.h"
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_old.c b/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_old.c
new file mode 100644
index 000000000000..9f0bdd7baf71
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_old.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#define OLD_VERSION
+#include "bpf_map_trace_real_world_common.h"
+
-- 
2.33.0.685.g46640cef36-goog

