Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF8A41D054
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347840AbhI3ABd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347798AbhI3ABV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADEBC061775;
        Wed, 29 Sep 2021 16:59:39 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so715982pjb.1;
        Wed, 29 Sep 2021 16:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ssICET/lDHEv1vW14GdFwvRIVJmMGQGayHUK8Pb4RP4=;
        b=Vjz3NYOT/OGJcgpP7WZnEUUu4nEJIKBVP4fct3q2hSxHI1ciYKUp1hAishcq0qHeZn
         4ISiLoTU4573u8yeZKcEZkltLguojDY+8+S3twpvknZL7pQuXbWWKnriC1YIq35r7rBI
         6BESw0M/eaKZ++UgvrO48cxhedJVIbCc1imv2aCaNLlNNe4Q3lAN2i4DG//5agNdqVnE
         nswlvak/uUaCrA4ioLgOX01cQMeGjduRk3ouwh6sEnJqvt67AaaWJzjYx7IeUG0xuqSW
         V2vqtW1McRDpoYwEkWz1mLVWbykGPPZGUM4oM4yRtvoVjuTfZKx3X6bD90wmNtNj9xjB
         1yRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ssICET/lDHEv1vW14GdFwvRIVJmMGQGayHUK8Pb4RP4=;
        b=cgaCrK5fAgqsBt02s1ilpXEuyONyeTVntHFi4Tm5WyWho829PquifWYtyoQATtSg/G
         BMcwmKRF4z7VJmCJ2feLsmPGmhfoJ3cNQvwD/+oLBZnOxkY1wZDgH+X7lSnIgGjR2ubQ
         zgT6WShJAlFdTt8Wo8o0pngxRNwCZs+7LtYvegzvudZl/kCrkW4EEfHjVVtaDez1SovH
         OqeWsQAkFWuV94gZdgYOntFmpI58Jwe5coY9EFjuuC+ETYP/EM5bgKCL7Ua2X+H8KOEP
         Gph8BCXqu4vnLZ5c6Ni24RxIK+8CSDwoc2sFV5upUuOJmq54iWX2LqIMv9Mp6IgEHLPA
         iBOg==
X-Gm-Message-State: AOAM532dMCqwrZQRZOm7brgeQaeNJUjPs425gNcL9a0G12x/oaBbllyi
        3EjSEaw9b/0eB8DdOFEEFj69plENmcHS
X-Google-Smtp-Source: ABdhPJyYHeDXsZDGPTe/Xyqw537aoW7K6fSjfXPH8zltx5aSZMGfk0xPnlfiZVMWy/IRanNcu6775A==
X-Received: by 2002:a17:90a:1942:: with SMTP id 2mr9471911pjh.195.1632959978920;
        Wed, 29 Sep 2021 16:59:38 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:38 -0700 (PDT)
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
Subject: [RFC PATCH v2 12/13] bpf: Add selftests for map tracing
Date:   Wed, 29 Sep 2021 23:59:09 +0000
Message-Id: <20210929235910.1765396-13-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add selftests for intended usage and infinite loop detection.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 .../selftests/bpf/prog_tests/bpf_map_trace.c  | 144 ++++++++++++++++++
 .../bpf/progs/bpf_map_trace_delete_elem.c     |  49 ++++++
 .../selftests/bpf/progs/bpf_map_trace_loop0.c |  26 ++++
 .../selftests/bpf/progs/bpf_map_trace_loop1.c |  43 ++++++
 .../bpf/progs/bpf_map_trace_update_elem.c     |  51 +++++++
 .../selftests/bpf/verifier/map_trace.c        |  40 +++++
 6 files changed, 353 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_delete_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_loop0.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_loop1.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_update_elem.c
 create mode 100644 tools/testing/selftests/bpf/verifier/map_trace.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_map_trace.c b/tools/testing/selftests/bpf/prog_tests/bpf_map_trace.c
new file mode 100644
index 000000000000..89bae9a83339
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_map_trace.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#include <test_progs.h>
+
+#include <assert.h>
+#include <asm/unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <linux/bpf.h>
+#include <sys/stat.h>
+#include <sys/mount.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "bpf_map_trace_delete_elem.skel.h"
+#include "bpf_map_trace_loop0.skel.h"
+#include "bpf_map_trace_loop1.skel.h"
+#include "bpf_map_trace_update_elem.skel.h"
+
+uint32_t collatz(uint32_t x)
+{
+	return x % 2 ? x * 3 + 1 : x / 2;
+}
+
+void update_elem__basic(void)
+{
+	const uint32_t tracer_value = collatz(0xdeadbeef);
+	struct bpf_map_trace_update_elem *skel;
+	const uint32_t tracer_key = 0x5;
+	uint32_t value;
+	int rc;
+
+	skel = bpf_map_trace_update_elem__open_and_load();
+	if (!ASSERT_NEQ(skel, NULL, "open/load skeleton failure"))
+		return;
+	rc = bpf_map_trace_update_elem__attach(skel);
+	if (!ASSERT_EQ(rc, 0, "attach skeleton failure")) {
+		fprintf(stderr, "Failed to attach skeleton: %d\n", errno);
+		goto out;
+	}
+
+	/* The kprobe will place (0x5, 0xdeadbeef) in its map. The tracer will
+	 * place (0x5, collatz(0xdeadbeef)) in its map. This map lookup will
+	 * trigger the kprobe.
+	 */
+	rc = bpf_map_lookup_elem(bpf_map__fd(skel->maps.tracer_map),
+				 &tracer_key, &value);
+	if (!ASSERT_EQ(rc, 0, "map lookup failure")) {
+		fprintf(stderr, "Failed to lookup tracer map: %s\n",
+			strerror(errno));
+		goto out;
+	}
+	if (!ASSERT_EQ(value, tracer_value, "map lookup mismatch"))
+		goto out;
+
+out:
+	bpf_map_trace_update_elem__destroy(skel);
+}
+
+void delete_elem__basic(void)
+{
+	const uint32_t tracer_key = collatz(0x5);
+	struct bpf_map_trace_delete_elem *skel;
+	uint32_t value = 0;
+	int rc;
+
+	skel = bpf_map_trace_delete_elem__open_and_load();
+	if (!ASSERT_NEQ(skel, NULL, "open/load skeleton failure"))
+		return;
+	rc = bpf_map_trace_delete_elem__attach(skel);
+	if (!ASSERT_EQ(rc, 0, "attach skeleton failure")) {
+		fprintf(stderr, "Failed to attach skeleton: %d\n", errno);
+		goto out;
+	}
+
+	/* The kprobe will delete (0x5) from its map. The tracer will
+	 * place (collatz(0x5), pid) in its map. This map lookup will trigger
+	 * the kprobe.
+	 */
+	rc = bpf_map_lookup_elem(bpf_map__fd(skel->maps.tracer_map),
+				 &tracer_key, &value);
+	if (!ASSERT_EQ(rc, 0, "map lookup failure")) {
+		fprintf(stderr, "Failed to lookup tracer map: %s\n",
+			strerror(errno));
+		goto out;
+	}
+	if (!ASSERT_EQ(value, getpid(), "map lookup mismatch"))
+		goto out;
+
+out:
+	bpf_map_trace_delete_elem__destroy(skel);
+}
+
+void infinite_loop__direct(void)
+{
+	struct bpf_map_trace_loop0 *skel;
+	struct bpf_link *tracer_link;
+
+	skel = bpf_map_trace_loop0__open_and_load();
+	if (!ASSERT_NEQ(skel, NULL, "open/load skeleton failure"))
+		goto out;
+	tracer_link = bpf_program__attach(skel->progs.tracer);
+	if (!ASSERT_ERR_PTR(tracer_link, "link creation success"))
+		goto out;
+
+out:
+	bpf_map_trace_loop0__destroy(skel);
+}
+
+void infinite_loop__indirect(void)
+{
+	struct bpf_map_trace_loop1 *skel;
+	struct bpf_link *tracer_link;
+
+	skel = bpf_map_trace_loop1__open_and_load();
+	if (!ASSERT_NEQ(skel, NULL, "open/load skeleton failure"))
+		return;
+	tracer_link = bpf_program__attach(skel->progs.tracer0);
+	if (!ASSERT_OK_PTR(tracer_link, "link creation failure"))
+		goto out;
+	tracer_link = bpf_program__attach(skel->progs.tracer1);
+	if (!ASSERT_ERR_PTR(tracer_link, "link creation success"))
+		goto out;
+
+out:
+	bpf_map_trace_loop1__destroy(skel);
+}
+
+void test_bpf_map_trace(void)
+{
+	if (test__start_subtest("update_elem__basic"))
+		update_elem__basic();
+	if (test__start_subtest("delete_elem__basic"))
+		delete_elem__basic();
+	if (test__start_subtest("infinite_loop__direct"))
+		infinite_loop__direct();
+	if (test__start_subtest("infinite_loop__indirect"))
+		infinite_loop__indirect();
+}
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace_delete_elem.c b/tools/testing/selftests/bpf/progs/bpf_map_trace_delete_elem.c
new file mode 100644
index 000000000000..4e47c13489ea
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_delete_elem.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+struct bpf_map_def SEC("maps") traced_map = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(uint32_t),
+	.value_size = sizeof(uint32_t),
+	.max_entries = 64,
+};
+
+struct bpf_map_def SEC("maps") tracer_map = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(uint32_t),
+	.value_size = sizeof(uint32_t),
+	.max_entries = 64,
+};
+
+SEC("kprobe/__sys_bpf")
+int traced(struct pt_regs *regs)
+{
+	uint32_t key = 0x5;
+
+	bpf_map_delete_elem(&traced_map, &key);
+	return 0;
+}
+
+uint32_t collatz(uint32_t x)
+{
+	return x % 2 ? x * 3 + 1 : x / 2;
+}
+
+SEC("map_trace/traced_map/DELETE_ELEM")
+int tracer(struct bpf_map_trace_ctx__delete_elem *ctx)
+{
+	uint32_t key = 0, val = 0;
+
+	if (bpf_probe_read(&key, sizeof(key), ctx->key))
+		return 1;
+	key = collatz(key);
+	val = (bpf_get_current_pid_tgid() >> 32);
+	bpf_map_update_elem(&tracer_map, &key, &val, /*flags=*/0);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace_loop0.c b/tools/testing/selftests/bpf/progs/bpf_map_trace_loop0.c
new file mode 100644
index 000000000000..7205e8914380
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_loop0.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+struct bpf_map_def SEC("maps") traced_map = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(uint32_t),
+	.value_size = sizeof(uint32_t),
+	.max_entries = 64,
+};
+
+/* This traces traced_map and updates it, creating an (invalid) infinite loop.
+ */
+SEC("map_trace/traced_map/UPDATE_ELEM")
+int tracer(struct bpf_map_trace_ctx__update_elem *ctx)
+{
+	uint32_t key = 0, val = 0;
+
+	bpf_map_update_elem(&traced_map, &key, &val, /*flags=*/0);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace_loop1.c b/tools/testing/selftests/bpf/progs/bpf_map_trace_loop1.c
new file mode 100644
index 000000000000..10e39f05c7c8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_loop1.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+struct bpf_map_def SEC("maps") map0 = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(uint32_t),
+	.value_size = sizeof(uint32_t),
+	.max_entries = 64,
+};
+
+struct bpf_map_def SEC("maps") map1 = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(uint32_t),
+	.value_size = sizeof(uint32_t),
+	.max_entries = 64,
+};
+
+SEC("map_trace/map0/UPDATE_ELEM")
+int tracer0(struct bpf_map_trace_ctx__update_elem *ctx)
+{
+	uint32_t key = 0, val = 0;
+
+	bpf_map_update_elem(&map1, &key, &val, /*flags=*/0);
+	return 0;
+}
+
+/* Since this traces map1 and updates map0, it forms an infinite loop with
+ * tracer0.
+ */
+SEC("map_trace/map1/UPDATE_ELEM")
+int tracer1(struct bpf_map_trace_ctx__update_elem *ctx)
+{
+	uint32_t key = 0, val = 0;
+
+	bpf_map_update_elem(&map0, &key, &val, /*flags=*/0);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+
diff --git a/tools/testing/selftests/bpf/progs/bpf_map_trace_update_elem.c b/tools/testing/selftests/bpf/progs/bpf_map_trace_update_elem.c
new file mode 100644
index 000000000000..35a6026a90f9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_map_trace_update_elem.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Google */
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+struct bpf_map_def SEC("maps") traced_map = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(uint32_t),
+	.value_size = sizeof(uint32_t),
+	.max_entries = 64,
+};
+
+struct bpf_map_def SEC("maps") tracer_map = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(uint32_t),
+	.value_size = sizeof(uint32_t),
+	.max_entries = 64,
+};
+
+SEC("kprobe/__sys_bpf")
+int traced(struct pt_regs *regs)
+{
+	uint32_t key = 0x5;
+	uint32_t val = 0xdeadbeef;
+
+	bpf_map_update_elem(&traced_map, &key, &val, /*flags=*/0);
+	return 0;
+}
+
+uint32_t collatz(uint32_t x)
+{
+	return x % 2 ? x * 3 + 1 : x / 2;
+}
+
+SEC("map_trace/traced_map/UPDATE_ELEM")
+int tracer(struct bpf_map_trace_ctx__update_elem *ctx)
+{
+	uint32_t key = 0, val = 0;
+
+	if (bpf_probe_read(&key, sizeof(key), ctx->key))
+		return 1;
+	if (bpf_probe_read(&val, sizeof(val), ctx->value))
+		return 1;
+	val = collatz(val);
+	bpf_map_update_elem(&tracer_map, &key, &val, /*flags=*/0);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+
diff --git a/tools/testing/selftests/bpf/verifier/map_trace.c b/tools/testing/selftests/bpf/verifier/map_trace.c
new file mode 100644
index 000000000000..a48b6448454e
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/map_trace.c
@@ -0,0 +1,40 @@
+{
+	"map tracing: full stack is accepted",
+	.insns = {
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -512, 0),
+		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -512),
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
+		BPF_MOV64_IMM(BPF_REG_4, 0),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_map_update_elem),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_8b = { 3 },
+	.result_unpriv = ACCEPT,
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
+{
+	"map tracing: overfull stack is not accepted",
+	.insns = {
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -520, 0),
+		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -520),
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
+		BPF_MOV64_IMM(BPF_REG_4, 0),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+			     BPF_FUNC_map_update_elem),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_8b = { 3 },
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "invalid write to stack R10 off=-520 size=8",
+	.errstr_unpriv = "invalid write to stack R10 off=-520 size=8",
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
-- 
2.33.0.685.g46640cef36-goog

