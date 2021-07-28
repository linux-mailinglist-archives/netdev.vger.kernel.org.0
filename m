Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F183D9197
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 17:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhG1PO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 11:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235546AbhG1POZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 11:14:25 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E870CC061764
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 08:14:22 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id x12-20020a05620a14acb02903b8f9d28c19so1756975qkj.23
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 08:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xfZZ3ta3RJs39O7zEmblbC+9ILKgix6dlFzx9fhcN9A=;
        b=DOykGsXbmCRZXB989DixJCtWtu4w+mCBGQLBPdIxOHUWwehn6GCCY2DqZDUvOEGk6h
         y7xzPtCY/jTnUMRM1aFHYWcmdQVAvL2RLq4ksl/n8wwdugJs+IchFpUOyEcxvrwbt2iN
         tgITLgZt9QClGRjc4ZAru2lkqVUaEqbEY3EuWCfsBrF+iuICaig08fcvSsH0vnU8kmC0
         sXW/Y86dq0crJhhpj52DhTyXqsjAlUsE3daQnoKTAD+qlYm9tZS8axiyRQV5rM+QiG80
         YS6tZKuk6tBK6uoUUENH+uEPw0aWUG2iBCV5HZV40bkqwZ3+RZjlsIn1Pmn54SohDG85
         ACRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xfZZ3ta3RJs39O7zEmblbC+9ILKgix6dlFzx9fhcN9A=;
        b=rn4ffgGga+LwMRVwIucoGMWObKiXiWzs6I2XYLc3nvRxW0IEwN3Lmw3UAiKx1Lxcz9
         CCKCKxM4qdRhhQ3445SVgXKSdoX8txkNy0/h/NZj2KmGh9Kwi9LQRVOBh/+4wNMXHd3T
         qzY9L74VEsPm5DiT57ZlOdzZI8Mllig/ywCa2ca9TeJFuY7dn06C0FdJC8bBCuTbUyBs
         f8exh5RBN5SN70dk7ztkjSPNBV/LKhXgoXcQcxOmMaUfu8actlvl+G23Ek/cZNYQvOVh
         y61mFrPJUAPh11rv3nBV8bQR+HVDmiUZJv4KM445YFrIoEEEmcGsUnzr8pC2Qa2SPqd7
         D3aQ==
X-Gm-Message-State: AOAM533Zl3gZF/fw/O6Y140RMV2MhyBuBcRVupKrSijy4e/BvlwOwxuH
        ptIphDLTUjAtvp2Ue+ipO101amRVYGCjQ/K1qamG9pwN2sjli+0x3rICNURVurCxbTWZ7pLDxk7
        NA8FKp6772bf3RPWhPZFqhZkg3i3Mkop5runXslqyzN52uyfolNSlfw==
X-Google-Smtp-Source: ABdhPJwH+S36DfWuafDinqDURszU2zYS5C6uYVP5FNsg5i1f93BBY8b+A+/xPbK5dWf5HZwvorwzCYg=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:35e0:b2c:7263:cba9])
 (user=sdf job=sendgmr) by 2002:a0c:ca09:: with SMTP id c9mr26901qvk.61.1627485261815;
 Wed, 28 Jul 2021 08:14:21 -0700 (PDT)
Date:   Wed, 28 Jul 2021 08:14:19 -0700
Message-Id: <20210728151419.501183-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH bpf-next] selftests/bpf: move netcnt test under test_progs
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rewrite to skel and ASSERT macros as well while we are at it.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../testing/selftests/bpf/prog_tests/netcnt.c |  93 +++++++++++
 tools/testing/selftests/bpf/test_netcnt.c     | 148 ------------------
 3 files changed, 94 insertions(+), 150 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netcnt.c
 delete mode 100644 tools/testing/selftests/bpf/test_netcnt.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f405b20c1e6c..2a58b7b5aea4 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -38,7 +38,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_verifier_log test_dev_cgroup \
 	test_sock test_sockmap get_cgroup_id_user \
 	test_cgroup_storage \
-	test_netcnt test_tcpnotify_user test_sysctl \
+	test_tcpnotify_user test_sysctl \
 	test_progs-no_alu32
 
 # Also test bpf-gcc, if present
@@ -197,7 +197,6 @@ $(OUTPUT)/test_sockmap: cgroup_helpers.c
 $(OUTPUT)/test_tcpnotify_user: cgroup_helpers.c trace_helpers.c
 $(OUTPUT)/get_cgroup_id_user: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_storage: cgroup_helpers.c
-$(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 
diff --git a/tools/testing/selftests/bpf/prog_tests/netcnt.c b/tools/testing/selftests/bpf/prog_tests/netcnt.c
new file mode 100644
index 000000000000..063a40d228b6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/netcnt.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/sysinfo.h>
+#include <test_progs.h>
+#include "netcnt_prog.skel.h"
+#include "netcnt_common.h"
+
+#define CG_NAME "/netcnt"
+
+void test_netcnt(void)
+{
+	union percpu_net_cnt *percpu_netcnt = NULL;
+	struct bpf_cgroup_storage_key key;
+	int map_fd, percpu_map_fd;
+	struct netcnt_prog *skel;
+	unsigned long packets;
+	union net_cnt netcnt;
+	unsigned long bytes;
+	int cpu, nproc;
+	int cg_fd = -1;
+
+	skel = netcnt_prog__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "netcnt_prog__open_and_load"))
+		return;
+
+	nproc = get_nprocs_conf();
+	percpu_netcnt = malloc(sizeof(*percpu_netcnt) * nproc);
+	if (!ASSERT_OK_PTR(percpu_netcnt, "malloc(percpu_netcnt)"))
+		goto err;
+
+	cg_fd = test__join_cgroup(CG_NAME);
+	if (!ASSERT_GE(cg_fd, 0, "test__join_cgroup"))
+		goto err;
+
+	skel->links.bpf_nextcnt =
+		bpf_program__attach_cgroup(skel->progs.bpf_nextcnt, cg_fd);
+	if (!ASSERT_OK_PTR(skel->links.bpf_nextcnt,
+			   "attach_cgroup(bpf_nextcnt)"))
+		goto err;
+
+	if (system("which ping6 &>/dev/null") == 0)
+		assert(!system("ping6 ::1 -c 10000 -f -q > /dev/null"));
+	else
+		assert(!system("ping -6 ::1 -c 10000 -f -q > /dev/null"));
+
+	map_fd = bpf_map__fd(skel->maps.netcnt);
+	if (!ASSERT_GE(map_fd, 0, "bpf_map__fd(netcnt)"))
+		goto err;
+
+	percpu_map_fd = bpf_map__fd(skel->maps.percpu_netcnt);
+	if (!ASSERT_GE(percpu_map_fd, 0, "bpf_map__fd(percpu_netcnt)"))
+		goto err;
+
+	if (!ASSERT_OK(bpf_map_get_next_key(map_fd, NULL, &key),
+		       "bpf_map_get_next_key"))
+		goto err;
+
+	if (!ASSERT_OK(bpf_map_lookup_elem(map_fd, &key, &netcnt),
+		       "bpf_map_lookup_elem(netcnt)"))
+		goto err;
+
+	if (!ASSERT_OK(bpf_map_lookup_elem(percpu_map_fd, &key,
+					   &percpu_netcnt[0]),
+		       "bpf_map_lookup_elem(percpu_netcnt)"))
+		goto err;
+
+	/* Some packets can be still in per-cpu cache, but not more than
+	 * MAX_PERCPU_PACKETS.
+	 */
+	packets = netcnt.packets;
+	bytes = netcnt.bytes;
+	for (cpu = 0; cpu < nproc; cpu++) {
+		ASSERT_LE(percpu_netcnt[cpu].packets, MAX_PERCPU_PACKETS,
+			  "MAX_PERCPU_PACKETS");
+
+		packets += percpu_netcnt[cpu].packets;
+		bytes += percpu_netcnt[cpu].bytes;
+	}
+
+	/* No packets should be lost */
+	ASSERT_EQ(packets, 10000, "packets");
+
+	/* Let's check that bytes counter matches the number of packets
+	 * multiplied by the size of ipv6 ICMP packet.
+	 */
+	ASSERT_EQ(bytes, packets * 104, "bytes");
+
+err:
+	if (cg_fd != -1)
+		close(cg_fd);
+	free(percpu_netcnt);
+	netcnt_prog__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/test_netcnt.c b/tools/testing/selftests/bpf/test_netcnt.c
deleted file mode 100644
index 4990a99e7381..000000000000
--- a/tools/testing/selftests/bpf/test_netcnt.c
+++ /dev/null
@@ -1,148 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <errno.h>
-#include <assert.h>
-#include <sys/sysinfo.h>
-#include <sys/time.h>
-
-#include <linux/bpf.h>
-#include <bpf/bpf.h>
-#include <bpf/libbpf.h>
-
-#include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
-#include "netcnt_common.h"
-
-#define BPF_PROG "./netcnt_prog.o"
-#define TEST_CGROUP "/test-network-counters/"
-
-static int bpf_find_map(const char *test, struct bpf_object *obj,
-			const char *name)
-{
-	struct bpf_map *map;
-
-	map = bpf_object__find_map_by_name(obj, name);
-	if (!map) {
-		printf("%s:FAIL:map '%s' not found\n", test, name);
-		return -1;
-	}
-	return bpf_map__fd(map);
-}
-
-int main(int argc, char **argv)
-{
-	union percpu_net_cnt *percpu_netcnt;
-	struct bpf_cgroup_storage_key key;
-	int map_fd, percpu_map_fd;
-	int error = EXIT_FAILURE;
-	struct bpf_object *obj;
-	int prog_fd, cgroup_fd;
-	unsigned long packets;
-	union net_cnt netcnt;
-	unsigned long bytes;
-	int cpu, nproc;
-	__u32 prog_cnt;
-
-	nproc = get_nprocs_conf();
-	percpu_netcnt = malloc(sizeof(*percpu_netcnt) * nproc);
-	if (!percpu_netcnt) {
-		printf("Not enough memory for per-cpu area (%d cpus)\n", nproc);
-		goto err;
-	}
-
-	if (bpf_prog_load(BPF_PROG, BPF_PROG_TYPE_CGROUP_SKB,
-			  &obj, &prog_fd)) {
-		printf("Failed to load bpf program\n");
-		goto out;
-	}
-
-	cgroup_fd = cgroup_setup_and_join(TEST_CGROUP);
-	if (cgroup_fd < 0)
-		goto err;
-
-	/* Attach bpf program */
-	if (bpf_prog_attach(prog_fd, cgroup_fd, BPF_CGROUP_INET_EGRESS, 0)) {
-		printf("Failed to attach bpf program");
-		goto err;
-	}
-
-	if (system("which ping6 &>/dev/null") == 0)
-		assert(!system("ping6 ::1 -c 10000 -f -q > /dev/null"));
-	else
-		assert(!system("ping -6 ::1 -c 10000 -f -q > /dev/null"));
-
-	if (bpf_prog_query(cgroup_fd, BPF_CGROUP_INET_EGRESS, 0, NULL, NULL,
-			   &prog_cnt)) {
-		printf("Failed to query attached programs");
-		goto err;
-	}
-
-	map_fd = bpf_find_map(__func__, obj, "netcnt");
-	if (map_fd < 0) {
-		printf("Failed to find bpf map with net counters");
-		goto err;
-	}
-
-	percpu_map_fd = bpf_find_map(__func__, obj, "percpu_netcnt");
-	if (percpu_map_fd < 0) {
-		printf("Failed to find bpf map with percpu net counters");
-		goto err;
-	}
-
-	if (bpf_map_get_next_key(map_fd, NULL, &key)) {
-		printf("Failed to get key in cgroup storage\n");
-		goto err;
-	}
-
-	if (bpf_map_lookup_elem(map_fd, &key, &netcnt)) {
-		printf("Failed to lookup cgroup storage\n");
-		goto err;
-	}
-
-	if (bpf_map_lookup_elem(percpu_map_fd, &key, &percpu_netcnt[0])) {
-		printf("Failed to lookup percpu cgroup storage\n");
-		goto err;
-	}
-
-	/* Some packets can be still in per-cpu cache, but not more than
-	 * MAX_PERCPU_PACKETS.
-	 */
-	packets = netcnt.packets;
-	bytes = netcnt.bytes;
-	for (cpu = 0; cpu < nproc; cpu++) {
-		if (percpu_netcnt[cpu].packets > MAX_PERCPU_PACKETS) {
-			printf("Unexpected percpu value: %llu\n",
-			       percpu_netcnt[cpu].packets);
-			goto err;
-		}
-
-		packets += percpu_netcnt[cpu].packets;
-		bytes += percpu_netcnt[cpu].bytes;
-	}
-
-	/* No packets should be lost */
-	if (packets != 10000) {
-		printf("Unexpected packet count: %lu\n", packets);
-		goto err;
-	}
-
-	/* Let's check that bytes counter matches the number of packets
-	 * multiplied by the size of ipv6 ICMP packet.
-	 */
-	if (bytes != packets * 104) {
-		printf("Unexpected bytes count: %lu\n", bytes);
-		goto err;
-	}
-
-	error = 0;
-	printf("test_netcnt:PASS\n");
-
-err:
-	cleanup_cgroup_environment();
-	free(percpu_netcnt);
-
-out:
-	return error;
-}
-- 
2.32.0.554.ge1b32706d8-goog

