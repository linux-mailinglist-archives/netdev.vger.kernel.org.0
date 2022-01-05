Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E7F484CA3
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbiAEDDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbiAEDDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:03:53 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B259C061785;
        Tue,  4 Jan 2022 19:03:53 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r5so34329150pgi.6;
        Tue, 04 Jan 2022 19:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YdqEdPYyId8S8WE+4fF4hSJObgeCrnl91l7Jm9e9Irc=;
        b=b0mBbZCabkSQl6rFSEXQhq6Lt8uVrpvWoDYZ96sODeaiuPmnpVF7loiYvsluLwtUiP
         o1MFlynhNDbm8LeMb1QtX24yftD8p4KGpn25vwkApTkQkDGq1YWACN9JHqJNaXYZlYmY
         qXe0OCwyWf00dgPGL4QaMGDddSmrShylD05zFeYGZSoOuHLXI0eB0/SsiwvYHc6PJtfr
         d9uCQS7Z4fNfxNEDTsaB6Bx3a+q1QqFLiK4FKaMywurPON+VI0/PTv1SqABNWYs/2ibH
         dKmH0Nl2YI87cmI8f8lIhFaHNYjwuuiP0z9J7kIIk/sn2wSv8AoMosETOAY3K51g0xbR
         bd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YdqEdPYyId8S8WE+4fF4hSJObgeCrnl91l7Jm9e9Irc=;
        b=vMN/uAAnW9SHMN9xADS0a78EmsL1uDQxl0KQJpD/vnWkS8rh9KAqe7Aos/Y2EU4QgK
         nDION8HB/lFOFnBtUIuVNbWtCySMi5i08qCyX3Ika/23nuABHj2/ikUCIs38q4d0BGrJ
         CsX8et9tknm1XNJTh22do41EoCLkZsocoeXRWAuHmF/dnY8wuUUalEaoM3USjZspTNyl
         +hsQQxzsZXZrJK7704ZH7ypEXAfYfpSrhPwjPq/50Koud6F2sPJjOb3wVm2aPVKKemOD
         orulhc50KkNW1A0IWsIjzrL24daqmU/KCoBXc14gwptr6A8s+GEph5bIY0kYEpijMHlr
         Cofg==
X-Gm-Message-State: AOAM532uiP5gtn0GHGJGm1ilA3JOtzGHKjCL6bageknidbvc7cnviMxH
        EN0AExcBvcIV5oKePqQmrQ==
X-Google-Smtp-Source: ABdhPJxY7QNwnsv8z2qW6FxY03NnBfljgrU5/2UedNDdWbCJfuWUp0Vr1hgjlwhHEq81PSjkQEwxTQ==
X-Received: by 2002:a63:6845:: with SMTP id d66mr1517631pgc.199.1641351832567;
        Tue, 04 Jan 2022 19:03:52 -0800 (PST)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i9sm34280818pgc.27.2022.01.04.19.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:03:52 -0800 (PST)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ppenkov@google.com,
        sdf@google.com, haoluo@google.com
Cc:     Joe Burton <jevburton@google.com>
Subject: [PATCH bpf-next v4 2/3] bpf: Add selftests
Date:   Wed,  5 Jan 2022 03:03:44 +0000
Message-Id: <20220105030345.3255846-3-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
In-Reply-To: <20220105030345.3255846-1-jevburton.kernel@gmail.com>
References: <20220105030345.3255846-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add selftests verifying that each supported map type is traced.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 .../selftests/bpf/prog_tests/map_trace.c      | 171 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_map_trace.c       |  95 ++++++++++
 .../bpf/progs/bpf_map_trace_common.h          |  12 ++
 3 files changed, 278 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_common.h

diff --git a/tools/testing/selftests/bpf/prog_tests/map_trace.c b/tools/testing/selftests/bpf/prog_tests/map_trace.c
new file mode 100644
index 000000000000..a622bbedd99d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/map_trace.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Google */
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
+	/*
+	 * Trampoline programs are only supported on x86.
+	 */
+#if defined(__x86_64__)
+	map_trace_test();
+#endif
+}
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace.c b/tools/testing/selftests/bpf/progs/bpf_map_trace.c
new file mode 100644
index 000000000000..90d4d435fe59
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Google */
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
index 000000000000..8986e6286350
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_common.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2022 Google */
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
2.34.1.448.ga2b2bfdf31-goog

