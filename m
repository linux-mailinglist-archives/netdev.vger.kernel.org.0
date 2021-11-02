Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8C0442580
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 03:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhKBCRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 22:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhKBCRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 22:17:24 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D07EC061714;
        Mon,  1 Nov 2021 19:14:50 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p18so10309858plf.13;
        Mon, 01 Nov 2021 19:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7m4qvg/KmWRogURZVeoJWaji5c98J68mkI0Sglgv//U=;
        b=WgY33ytjLb87b27YOg8pYK7mQKjrzU+NkNtfuL97vfTeUfiPiLaSQbQuxpV/UiC7f9
         bDeuq/jnAmbQqLvQOgNQr++ZvGcnVSTbMIQ/ZmDdgdae4GnIyh5Rj22PzWph4nwJyosa
         R2Db+N09wsoxZNUF2z4W7sO0sOEyj6vpqCGGAuKV/fDpm5xPWDgZZ2un96nb5Fq+qGj8
         03PKnIh/bnhOQETKiaADREJhadP2nv0TePgb8I2lCt+WNdKVwqOR3p1b5fmyRFI57r8O
         nTt/UceTXR82GYnUp2F7RyqlDVEUvLfEWctrhcyUIJOnAF5vQqyuQHP1KhNEWjesmUgx
         wR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7m4qvg/KmWRogURZVeoJWaji5c98J68mkI0Sglgv//U=;
        b=e9qAOMrA4rpCZ2x4SfYg9yyV5+LoWe/xs9BHv5N+0x2r0q4iBZooLkXjk1xIkiHkZg
         rwC9X9KqCJvUXqE9052NqokqcaE6V+pAjBIWizfsp9ABVY5wWed1CtDtwXq7WhVMd6Nm
         RVzzxXgtLakkmw00Y9VWknuH8Kam+5MFC3n9gX0Qy4ellqxqteiZ39yDFHrxSF77uqAK
         IJt66BUZvp41MR0KZst4sIneykRp9YJoipySaSvR8WCrVWMEca2IhVgyV+G3pfa659DX
         0KnSh/GHFtmaaYTBhFDXHHKwH1Pr+YprI+Iy8+kem1RoHi2JguuSdBan0JygDb5cNaXv
         63rg==
X-Gm-Message-State: AOAM533T8hsZQ0bdbsd4LQIDqJfvui413dInSiBsvb1ZHGBDeQCWqNF6
        4tJACsORbKJbcbyae/r3DQ==
X-Google-Smtp-Source: ABdhPJzr9VZqcMqoVEPpDjWanNECw5jO7FsrcxKEikAfJWYPbsnuSva+fKJ7bgJaRmois39+OVp2sQ==
X-Received: by 2002:a17:90b:4a89:: with SMTP id lp9mr3175444pjb.6.1635819289648;
        Mon, 01 Nov 2021 19:14:49 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm14051446pgf.60.2021.11.01.19.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 19:14:49 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v3 2/3] bpf: Add selftests
Date:   Tue,  2 Nov 2021 02:14:31 +0000
Message-Id: <20211102021432.2807760-3-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
In-Reply-To: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add selftests verifying that each supported map type is traced.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 .../selftests/bpf/prog_tests/map_trace.c      | 166 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_map_trace.c       |  95 ++++++++++
 .../bpf/progs/bpf_map_trace_common.h          |  12 ++
 3 files changed, 273 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_common.h

diff --git a/tools/testing/selftests/bpf/prog_tests/map_trace.c b/tools/testing/selftests/bpf/prog_tests/map_trace.c
new file mode 100644
index 000000000000..4b54a8e3769a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/map_trace.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#include <test_progs.h>
+
+#include "bpf_map_trace.skel.h"
+#include "progs/bpf_map_trace_common.h"
+
+#include <sys/mount.h>
+#include <sys/stat.h>
+
+enum BoolOrErr {
+	TRUE = 0,
+	FALSE = 1,
+	ERROR = 2,
+};
+
+enum BoolOrErr percpu_key_is_set(struct bpf_map *map, uint32_t map_key)
+{
+	int num_cpus = libbpf_num_possible_cpus();
+	uint64_t *percpu_map_val = NULL;
+	int map_fd = bpf_map__fd(map);
+	enum BoolOrErr ret = ERROR;
+	int err;
+	int i;
+
+	if (!ASSERT_GE(num_cpus, 1, "get number of cpus"))
+		goto out;
+
+	percpu_map_val = malloc(sizeof(*percpu_map_val) * num_cpus);
+	if (!ASSERT_NEQ(percpu_map_val, NULL, "allocate percpu map array"))
+		goto out;
+
+	err = bpf_map_lookup_elem(map_fd, &map_key, percpu_map_val);
+	if (!ASSERT_EQ(err, 0, "map lookup update_elem"))
+		goto out;
+
+	ret = FALSE;
+	for (i = 0; i < num_cpus; i++)
+		if (percpu_map_val[i] != 0)
+			ret = TRUE;
+
+out:
+	if (percpu_map_val != NULL)
+		free(percpu_map_val);
+
+	return ret;
+}
+
+enum BoolOrErr key_is_set(struct bpf_map *map, uint32_t map_key)
+{
+	int map_fd = bpf_map__fd(map);
+	uint32_t map_val;
+	int rc;
+
+	rc = bpf_map_lookup_elem(map_fd, &map_key, &map_val);
+	if (!ASSERT_EQ(rc, 0, "array map lookup update_elem"))
+		return ERROR;
+
+	return (map_val == 0 ? FALSE : TRUE);
+}
+
+void verify_map_contents(struct bpf_map_trace *skel)
+{
+	enum BoolOrErr rc_or_err;
+	struct bpf_map *map;
+
+	map = skel->maps.array_map;
+	rc_or_err = key_is_set(map, ACCESS_LOC__TRACE_UPDATE);
+	if (!ASSERT_EQ(rc_or_err, TRUE, "array map updates are traced"))
+		return;
+	rc_or_err = key_is_set(map, ACCESS_LOC__TRACE_DELETE);
+	if (!ASSERT_EQ(rc_or_err, FALSE, "array map deletions are not traced"))
+		return;
+
+	map = skel->maps.percpu_array_map;
+	rc_or_err = percpu_key_is_set(map, ACCESS_LOC__TRACE_UPDATE);
+	if (!ASSERT_EQ(rc_or_err, TRUE, "percpu array map updates are traced"))
+		return;
+	rc_or_err = percpu_key_is_set(map, ACCESS_LOC__TRACE_DELETE);
+	if (!ASSERT_EQ(rc_or_err, FALSE,
+		       "percpu array map deletions are not traced"))
+		return;
+
+	map = skel->maps.hash_map;
+	rc_or_err = key_is_set(map, ACCESS_LOC__TRACE_UPDATE);
+	if (!ASSERT_EQ(rc_or_err, TRUE, "hash map updates are traced"))
+		return;
+	rc_or_err = key_is_set(map, ACCESS_LOC__TRACE_DELETE);
+	if (!ASSERT_EQ(rc_or_err, TRUE, "hash map deletions are traced"))
+		return;
+
+	map = skel->maps.percpu_hash_map;
+	rc_or_err = percpu_key_is_set(map, ACCESS_LOC__TRACE_UPDATE);
+	if (!ASSERT_EQ(rc_or_err, TRUE, "percpu hash map updates are traced"))
+		return;
+	rc_or_err = percpu_key_is_set(map, ACCESS_LOC__TRACE_DELETE);
+	if (!ASSERT_EQ(rc_or_err, TRUE,
+		       "percpu hash map deletions are traced"))
+		return;
+
+	map = skel->maps.lru_hash_map;
+	rc_or_err = key_is_set(map, ACCESS_LOC__TRACE_UPDATE);
+	if (!ASSERT_EQ(rc_or_err, TRUE, "lru_hash map updates are traced"))
+		return;
+	rc_or_err = key_is_set(map, ACCESS_LOC__TRACE_DELETE);
+	if (!ASSERT_EQ(rc_or_err, TRUE, "lru_hash map deletions are traced"))
+		return;
+
+	map = skel->maps.percpu_lru_hash_map;
+	rc_or_err = percpu_key_is_set(map, ACCESS_LOC__TRACE_UPDATE);
+	if (!ASSERT_EQ(rc_or_err, TRUE,
+		       "percpu lru hash map updates are traced"))
+		return;
+	rc_or_err = percpu_key_is_set(map, ACCESS_LOC__TRACE_DELETE);
+	if (!ASSERT_EQ(rc_or_err, TRUE,
+		       "percpu lru hash map deletions are traced"))
+		return;
+}
+
+void map_trace_test(void)
+{
+	struct bpf_map_trace *skel;
+	ssize_t bytes_written;
+	char write_buf = 'a';
+	int write_fd = -1;
+	int rc;
+
+	/*
+	 * Load and attach programs.
+	 */
+	skel = bpf_map_trace__open_and_load();
+	if (!ASSERT_NEQ(skel, NULL, "open/load skeleton"))
+		return;
+
+	rc = bpf_map_trace__attach(skel);
+	if (!ASSERT_EQ(rc, 0, "attach skeleton"))
+		goto out;
+
+	/*
+	 * Invoke core BPF program.
+	 */
+	write_fd = open("/tmp/map_trace_test_file", O_CREAT | O_WRONLY);
+	if (!ASSERT_GE(rc, 0, "open tmp file for writing"))
+		goto out;
+
+	bytes_written = write(write_fd, &write_buf, sizeof(write_buf));
+	if (!ASSERT_EQ(bytes_written, sizeof(write_buf), "write to tmp file"))
+		return;
+
+	/*
+	 * Verify that tracing programs were invoked as expected.
+	 */
+	verify_map_contents(skel);
+
+out:
+	if (skel)
+		bpf_map_trace__destroy(skel);
+	if (write_fd != -1)
+		close(write_fd);
+}
+
+void test_map_trace(void)
+{
+	map_trace_test();
+}
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace.c b/tools/testing/selftests/bpf/progs/bpf_map_trace.c
new file mode 100644
index 000000000000..6135cd86b521
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+#include <string.h>
+
+#include "bpf_map_trace_common.h"
+
+#define DECLARE_MAP(name, map_type) \
+		struct { \
+			__uint(type, map_type); \
+			__uint(max_entries, __ACCESS_LOC__MAX); \
+			__type(key, u32); \
+			__type(value, u32); \
+		} name SEC(".maps")
+
+DECLARE_MAP(array_map, BPF_MAP_TYPE_ARRAY);
+DECLARE_MAP(percpu_array_map, BPF_MAP_TYPE_PERCPU_ARRAY);
+DECLARE_MAP(hash_map, BPF_MAP_TYPE_HASH);
+DECLARE_MAP(percpu_hash_map, BPF_MAP_TYPE_PERCPU_HASH);
+DECLARE_MAP(lru_hash_map, BPF_MAP_TYPE_LRU_HASH);
+DECLARE_MAP(percpu_lru_hash_map, BPF_MAP_TYPE_LRU_PERCPU_HASH);
+
+static inline void __log_location(void *map,
+				  enum MapAccessLocations location)
+{
+	u32 key = location;
+	u32 val = 1;
+
+	bpf_map_update_elem(map, &key, &val, /*flags=*/0);
+}
+
+static inline void log_location(struct bpf_map *map,
+				enum MapAccessLocations location)
+{
+	if (map == &array_map)
+		__log_location(&array_map, location);
+	if (map == &percpu_array_map)
+		__log_location(&percpu_array_map, location);
+	if (map == &hash_map)
+		__log_location(&hash_map, location);
+	if (map == &percpu_hash_map)
+		__log_location(&percpu_hash_map, location);
+	if (map == &lru_hash_map)
+		__log_location(&lru_hash_map, location);
+	if (map == &percpu_lru_hash_map)
+		__log_location(&percpu_lru_hash_map, location);
+}
+
+SEC("fentry/bpf_map_trace_update_elem")
+int BPF_PROG(fentry__bpf_map_trace_update_elem,
+	     struct bpf_map *map, void *key,
+	     void *value, u64 map_flags)
+{
+	log_location(map, ACCESS_LOC__TRACE_UPDATE);
+	return 0;
+}
+
+SEC("fentry/bpf_map_trace_delete_elem")
+int BPF_PROG(fentry__bpf_map_trace_delete_elem,
+	     struct bpf_map *map, void *key)
+{
+	log_location(map, ACCESS_LOC__TRACE_DELETE);
+	return 0;
+}
+
+static inline void do_map_accesses(void *map)
+{
+	u32 key = ACCESS_LOC__APP;
+	u32 val = 1;
+
+	bpf_map_update_elem(map, &key, &val, /*flags=*/0);
+	bpf_map_delete_elem(map, &key);
+}
+
+SEC("fentry/__x64_sys_write")
+int BPF_PROG(fentry__x64_sys_write, struct pt_regs *regs, int ret)
+{
+	/*
+	 * Trigger an update and a delete for every map type under test.
+	 * We want to verify that bpf_map_trace_{update,delete}_elem() fire
+	 * for each map type.
+	 */
+	do_map_accesses(&array_map);
+	do_map_accesses(&percpu_array_map);
+	do_map_accesses(&hash_map);
+	do_map_accesses(&percpu_hash_map);
+	do_map_accesses(&lru_hash_map);
+	do_map_accesses(&percpu_lru_hash_map);
+	return 0;
+}
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace_common.h b/tools/testing/selftests/bpf/progs/bpf_map_trace_common.h
new file mode 100644
index 000000000000..3aac75953508
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_common.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#pragma once
+
+enum MapAccessLocations {
+	ACCESS_LOC__APP,
+	ACCESS_LOC__TRACE_UPDATE,
+	ACCESS_LOC__TRACE_DELETE,
+
+	__ACCESS_LOC__MAX,
+};
+
-- 
2.33.1.1089.g2158813163f-goog

