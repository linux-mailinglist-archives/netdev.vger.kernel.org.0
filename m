Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE193E09AF
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 22:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbhHDUzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 16:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbhHDUzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 16:55:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2405C061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 13:55:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e145-20020a2550970000b029056eb288352cso4168656ybb.2
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 13:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1e0S4DnKUJvlhdmbQUU0ywz8+b9MuvzdJQ/I1zDhCdU=;
        b=H7/KwVhHPIS41UxqU+N4zLq+0JSpDkob4qOMHgIbMKRpafB/O01cJ5yKamgDzE+hVo
         iBmj2Oa9vdi+Fqzoeu+QF1jvuw9bEsJD/KYOym0CpC1AFpvy2QzT5jwr7DyBPF446jAS
         EUBD5cqh+cBaHKAiPGjUPavUMJh+vFY6zbzNhst2k0KPdFLjLQW6IADjnaHI4nUf8UG/
         gm/gRKMgpCgAz3MEcUqTHplHlbl1QnkoXsJHTIVWiapdtEGnKMumjNwEFCamYZtbW5kV
         DwKqy4rJgyY2uLvZiSnN0A08NEHv3M2GyFIWqtHYsSZ+WCXOp7y3I1LctyCIZri1nSao
         DOUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1e0S4DnKUJvlhdmbQUU0ywz8+b9MuvzdJQ/I1zDhCdU=;
        b=iLG3zn8p5QJeZvRyKfOa6h3BZsm3mOkVCoI0drC19G079c/90PIUK1zkANy6xINQKO
         1BjAlG9irJ6Vf95TTDLI9UIcXjFI9USw24Xq/4I0jghb4abiJ7RazNQdzLnmN0TPRVjH
         RvKJaSlDOwrfXea7STSPfAsqEGYulW9Beq27PiQvdA1AmEyWvES3FNzeAZgOvAgZD6r6
         9/40sDUMhvQozTXc0IzpqfOWMyo9vS7vXipLsrok6qF4aWaZvS5xsO/wzYZ9eWevRhni
         Mz3j7a3L2liJYKDxNOeo9OBoWJjs57nKxdQt6ZqeHT7qFA24h2ztF2G+kjZFXFfJqZCf
         cVng==
X-Gm-Message-State: AOAM533dD008M6BFPBT4sMgciJmIWX9VUsYSyoASI1ItWYZJvHwOG+en
        ZgUoisRX2RLLvn/LFNUSB8b5Po6aOd4KUNluRYZLzvU+GbC/kdFPsRlUAVyA5ZGwY4nfAuuhAMo
        vvdvWj3Qvkc8OHuqzDBkTCg/MN4YhfdJrlfdjU0v1Fs3H86/mB/TiTg==
X-Google-Smtp-Source: ABdhPJyUfgX95yGI6MbafdBm8kZzq68xeapo7DX8i4QDvs3OwF1lrGQNRBURdFU0FF8X9UTts6Jz4RY=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:838b:f63a:12a:c444])
 (user=sdf job=sendgmr) by 2002:a25:7cc3:: with SMTP id x186mr1599874ybc.227.1628110526921;
 Wed, 04 Aug 2021 13:55:26 -0700 (PDT)
Date:   Wed,  4 Aug 2021 13:55:24 -0700
Message-Id: <20210804205524.3748709-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH bpf-next v3] selftests/bpf: move netcnt test under test_progs
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rewrite to skel and ASSERT macros as well while we are at it.

v3:
- replace -f with -A to make it work with busybox ping.
  -A is available on both busybox and iputils, from the man page:
  On networks with low RTT this mode is essentially equivalent to
  flood mode.

v2:
- don't check result of bpf_map__fd (Yonghong Song)
- remove from .gitignore (Andrii Nakryiko)
- move ping_command into network_helpers (Andrii Nakryiko)
- remove assert() (Andrii Nakryiko)

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 -
 tools/testing/selftests/bpf/Makefile          |   3 +-
 tools/testing/selftests/bpf/network_helpers.c |  12 ++
 tools/testing/selftests/bpf/network_helpers.h |   1 +
 .../testing/selftests/bpf/prog_tests/netcnt.c |  82 ++++++++++
 .../selftests/bpf/prog_tests/tc_redirect.c    |  12 --
 tools/testing/selftests/bpf/test_netcnt.c     | 148 ------------------
 7 files changed, 96 insertions(+), 163 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netcnt.c
 delete mode 100644 tools/testing/selftests/bpf/test_netcnt.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index addcfd8b615e..433f8bef261e 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -23,7 +23,6 @@ test_skb_cgroup_id_user
 test_cgroup_storage
 test_flow_dissector
 flow_dissector_load
-test_netcnt
 test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
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
 
diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index 26468a8f44f3..d6857683397f 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -310,3 +310,15 @@ int make_sockaddr(int family, const char *addr_str, __u16 port,
 	}
 	return -1;
 }
+
+char *ping_command(int family)
+{
+	if (family == AF_INET6) {
+		/* On some systems 'ping' doesn't support IPv6, so use ping6 if it is present. */
+		if (!system("which ping6 >/dev/null 2>&1"))
+			return "ping6";
+		else
+			return "ping -6";
+	}
+	return "ping";
+}
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index d60bc2897770..c59a8f6d770b 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -46,5 +46,6 @@ int fastopen_connect(int server_fd, const char *data, unsigned int data_len,
 		     int timeout_ms);
 int make_sockaddr(int family, const char *addr_str, __u16 port,
 		  struct sockaddr_storage *addr, socklen_t *len);
+char *ping_command(int family);
 
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/netcnt.c b/tools/testing/selftests/bpf/prog_tests/netcnt.c
new file mode 100644
index 000000000000..6ede48bde91b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/netcnt.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/sysinfo.h>
+#include <test_progs.h>
+#include "network_helpers.h"
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
+	char cmd[128];
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
+	skel->links.bpf_nextcnt = bpf_program__attach_cgroup(skel->progs.bpf_nextcnt, cg_fd);
+	if (!ASSERT_OK_PTR(skel->links.bpf_nextcnt,
+			   "attach_cgroup(bpf_nextcnt)"))
+		goto err;
+
+	snprintf(cmd, sizeof(cmd), "%s ::1 -A -c 10000 -q > /dev/null", ping_command(AF_INET6));
+	ASSERT_OK(system(cmd), cmd);
+
+	map_fd = bpf_map__fd(skel->maps.netcnt);
+	if (!ASSERT_OK(bpf_map_get_next_key(map_fd, NULL, &key), "bpf_map_get_next_key"))
+		goto err;
+
+	if (!ASSERT_OK(bpf_map_lookup_elem(map_fd, &key, &netcnt), "bpf_map_lookup_elem(netcnt)"))
+		goto err;
+
+	percpu_map_fd = bpf_map__fd(skel->maps.percpu_netcnt);
+	if (!ASSERT_OK(bpf_map_lookup_elem(percpu_map_fd, &key, &percpu_netcnt[0]),
+		       "bpf_map_lookup_elem(percpu_netcnt)"))
+		goto err;
+
+	/* Some packets can be still in per-cpu cache, but not more than
+	 * MAX_PERCPU_PACKETS.
+	 */
+	packets = netcnt.packets;
+	bytes = netcnt.bytes;
+	for (cpu = 0; cpu < nproc; cpu++) {
+		ASSERT_LE(percpu_netcnt[cpu].packets, MAX_PERCPU_PACKETS, "MAX_PERCPU_PACKETS");
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
diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index 932e4ee3f97c..e7201ba29ccd 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -390,18 +390,6 @@ static void test_tcp(int family, const char *addr, __u16 port)
 		close(client_fd);
 }
 
-static char *ping_command(int family)
-{
-	if (family == AF_INET6) {
-		/* On some systems 'ping' doesn't support IPv6, so use ping6 if it is present. */
-		if (!system("which ping6 >/dev/null 2>&1"))
-			return "ping6";
-		else
-			return "ping -6";
-	}
-	return "ping";
-}
-
 static int test_ping(int family, const char *addr)
 {
 	SYS("ip netns exec " NS_SRC " %s " PING_ARGS " %s > /dev/null", ping_command(family), addr);
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

