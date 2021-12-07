Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8342146C0A6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbhLGQ2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhLGQ2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:28:12 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDA9C061574;
        Tue,  7 Dec 2021 08:24:41 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y13so58979347edd.13;
        Tue, 07 Dec 2021 08:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cal9mgrfJeOC1t+KTZvLGazz6Vso8H/zFO8jZhM8iBo=;
        b=iE8IO3izriODdoUDlr44Meea61jxwybW6kVWqJKv30Nn85ei3+I8pXMc9cqh0TnTOg
         UTqvL0zToFLtUX0kdrR77H6GsCC6Q9IhEDV3TAzVeA3MTWDcL+5SInvnOtmi0CDE/ZFJ
         RK5r+Xmu8m+2SG/d+pZlFAhTICKLvkHDXL/6jbA5Q/4SyGYwITDnpmfp754j2t8mwsnw
         8c1x+kNHCPzkKt8dFD+LstcrEk3K4MyA/7Ett9r5P0WM/TU4pPnGT2zYLzPFke2o/QLf
         Cry3ildvBhV6FQ0mNSJbXEItmzM6SnbQpRl+dXkjzs9hFWsycRXqqMmAXD8ac+CDXWdz
         vloQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cal9mgrfJeOC1t+KTZvLGazz6Vso8H/zFO8jZhM8iBo=;
        b=VjXHRBnP8DwAi4YlsGg16dGDC7U7Q8ZlXwUZJdIeIESBqLWeFcgw0D9wDpu3ouMH2B
         Ny1CRyaXzHUZzxP4EFxciCPsWrdbZRCjeMJWU0oGfVXDk8i0efR5ALJQzLj7I72ok1CO
         sc6wkvoWwilfjAjnqpx1Rt5v0S2I7jPvz2XqvGvmYyP8HhFA5vB9ApJYnIQdYniUcVW+
         jZCgyjj/Bvufv1qJpzQ1lDNDOtldDCJdnYFNVx+En6kMKF/HCQroCi0Wd1ne1FhaABo3
         jHkNwe06Jy+ctLgLEuUUTuaXW9QybZSxL6gp9KbQ7b5uqNdY9IpuixMBSg3J/08tck6X
         ce8Q==
X-Gm-Message-State: AOAM532WjUTDvywUjR1tLJLd/XQE7ZOCOZ/yx0cgDuS/dT8a7u/PPxt0
        ErSsXwnNkdMF+lac29KE9FxlWE1TpNChOQ==
X-Google-Smtp-Source: ABdhPJxGZv56emhF1h6iMskn586AJ1Ae3K5o4Gl1fXpY3V5CvC+z3YrX4ofK6tXdhZyRxkcxjIf/Qw==
X-Received: by 2002:a05:6402:3cd:: with SMTP id t13mr10602633edw.97.1638894279805;
        Tue, 07 Dec 2021 08:24:39 -0800 (PST)
Received: from localhost.localdomain ([2a02:a03f:c062:a800:5f01:482d:95e2:b968])
        by smtp.gmail.com with ESMTPSA id i10sm6757ejw.48.2021.12.07.08.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 08:24:39 -0800 (PST)
From:   Mathieu Jadin <mathjadin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Mathieu Jadin <mathjadin@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, linux-kselftest@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, KP Singh <kpsingh@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Test for IPv6 ext header parsing
Date:   Tue,  7 Dec 2021 17:22:49 +0100
Message-Id: <20211207162249.301625-2-mathjadin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211207162249.301625-1-mathjadin@gmail.com>
References: <20211207162249.301625-1-mathjadin@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1638884270; l=7638; s=20211207; h=from:subject; bh=S9PpPGXrudTAXfgr3NRpH/1lgYiOVeZ/V9FOjs3vHDg=; b=bkjqSaNcM0gc6wbUMv+UdtJrBX5uE4NWu7v7wJq7tjZtOgJw1gjhH7HlsREREQ5cbOiZwsRzBpWX QCN4MRa8DMBiKX1KTjmAsd/skYxFiT19SRS6wwZqxPSpuoDGw6Xt
X-Developer-Key: i=mathjadin@gmail.com; a=ed25519; pk=LX0wKHMKZralQziQacrPu4w5BceQsC7CocWV714TPRU=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test creates a client and a server exchanging a single byte
with a Segment Routing Header and the eBPF program saves
the inner segment in a sk_storage. The test program checks that
the segment is correct.

Signed-off-by: Mathieu Jadin <mathjadin@gmail.com>
---
 .../bpf/prog_tests/tcp_ipv6_exthdr_srh.c      | 171 ++++++++++++++++++
 .../selftests/bpf/progs/tcp_ipv6_exthdr_srh.c |  78 ++++++++
 2 files changed, 249 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_ipv6_exthdr_srh.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ipv6_exthdr_srh.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_ipv6_exthdr_srh.c b/tools/testing/selftests/bpf/prog_tests/tcp_ipv6_exthdr_srh.c
new file mode 100644
index 000000000000..70f7ee230975
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_ipv6_exthdr_srh.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <linux/seg6.h>
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+
+struct tcp_srh_storage {
+	struct in6_addr inner_segment;
+};
+
+static void send_byte(int fd)
+{
+	char b = 0x55;
+
+	if (CHECK_FAIL(send(fd, &b, sizeof(b), 0) != 1))
+		perror("Failed to send single byte");
+}
+
+static int verify_srh(int map_fd, int server_fd, struct ipv6_sr_hdr *client_srh)
+{
+	int err = 0;
+	struct tcp_srh_storage val;
+
+	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &server_fd, &val) < 0)) {
+		perror("Failed to read socket storage");
+		return -1;
+	}
+
+	if (memcmp(&val.inner_segment, &client_srh->segments[1],
+		   sizeof(struct in6_addr))) {
+		log_err("The inner segment of the received SRH differs from the sent one");
+		err++;
+	}
+
+	return err;
+}
+
+static int run_test(int cgroup_fd, int listen_fd)
+{
+	struct bpf_prog_load_attr attr = {
+		.prog_type = BPF_PROG_TYPE_SOCK_OPS,
+		.file = "./tcp_ipv6_exthdr_srh.o",
+		.expected_attach_type = BPF_CGROUP_SOCK_OPS,
+	};
+	size_t srh_size = sizeof(struct ipv6_sr_hdr) +
+		2 * sizeof(struct in6_addr);
+	struct ipv6_sr_hdr *client_srh;
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	struct timeval tv;
+	int client_fd;
+	int server_fd;
+	int prog_fd;
+	int map_fd;
+	char byte;
+	int err;
+
+	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
+	if (err) {
+		log_err("Failed to load BPF object");
+		return -1;
+	}
+
+	map = bpf_object__next_map(obj, NULL);
+	map_fd = bpf_map__fd(map);
+
+	err = bpf_prog_attach(prog_fd, cgroup_fd, BPF_CGROUP_SOCK_OPS, 0);
+	if (err) {
+		log_err("Failed to attach BPF program");
+		goto close_bpf_object;
+	}
+
+	client_fd = connect_to_fd(listen_fd, 0);
+	if (client_fd < 0) {
+		err = -1;
+		goto close_bpf_object;
+	}
+
+	server_fd = accept(listen_fd, NULL, 0);
+	if (server_fd < 0) {
+		err = -1;
+		goto close_client_fd;
+	}
+
+	/* Set an SRH with ::1 as an intermediate segment on the client */
+
+	client_srh = calloc(1, srh_size);
+	if (!client_srh) {
+		log_err("Failed to create the SRH to send");
+		goto close_server_fd;
+	}
+	client_srh->type = IPV6_SRCRT_TYPE_4;
+	// We do not count the first 8 bytes (RFC 8200 Section 4.4)
+	client_srh->hdrlen = (2 * sizeof(struct in6_addr)) >> 3;
+	client_srh->segments_left = 1;
+	client_srh->first_segment = 1;
+	// client_srh->segments[0] is set by the kernel
+	memcpy(&client_srh->segments[1], &in6addr_loopback,
+	       sizeof(struct in6_addr));
+
+	if (setsockopt(client_fd, SOL_IPV6, IPV6_RTHDR, client_srh,
+		       srh_size)) {
+		log_err("Failed to set the SRH on the client");
+		goto free_srh;
+	}
+
+	/* Send traffic with this SRH
+	 * and check its parsing on the server side
+	 */
+
+	tv.tv_sec = 1;
+	tv.tv_usec = 0;
+	if (setsockopt(server_fd, SOL_SOCKET, SO_RCVTIMEO, (const char *)&tv,
+		       sizeof(tv))) {
+		log_err("Failed to set the receive timeout on the server");
+		err = -1;
+		goto free_srh;
+	}
+
+	send_byte(client_fd);
+	if (recv(server_fd, &byte, 1, 0) != 1) {
+		log_err("Failed to get the byte under one second on the server 2");
+		err = -1;
+		goto free_srh;
+	}
+
+	err += verify_srh(map_fd, server_fd, client_srh);
+
+free_srh:
+	free(client_srh);
+close_server_fd:
+	close(server_fd);
+close_client_fd:
+	close(client_fd);
+close_bpf_object:
+	bpf_object__close(obj);
+	return err;
+}
+
+void test_tcp_ipv6_exthdr_srh(void)
+{
+	int server_fd, cgroup_fd;
+
+	cgroup_fd = test__join_cgroup("/tcp_ipv6_exthdr_srh");
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
+
+	server_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	if (CHECK_FAIL(server_fd < 0))
+		goto close_cgroup_fd;
+
+	if (CHECK_FAIL(system("sysctl net.ipv6.conf.all.seg6_enabled=1")))
+		goto close_server;
+
+	if (CHECK_FAIL(system("sysctl net.ipv6.conf.lo.seg6_enabled=1")))
+		goto reset_sysctl;
+
+	CHECK_FAIL(run_test(cgroup_fd, server_fd));
+
+	if (CHECK_FAIL(system("sysctl net.ipv6.conf.lo.seg6_enabled=0")))
+		log_err("Cannot reset sysctl net.ipv6.conf.lo.seg6_enabled to 0");
+
+reset_sysctl:
+	if (CHECK_FAIL(system("sysctl net.ipv6.conf.all.seg6_enabled=0")))
+		log_err("Cannot reset sysctl net.ipv6.conf.all.seg6_enabled to 0");
+
+close_server:
+	close(server_fd);
+close_cgroup_fd:
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/tcp_ipv6_exthdr_srh.c b/tools/testing/selftests/bpf/progs/tcp_ipv6_exthdr_srh.c
new file mode 100644
index 000000000000..276bda8bbecb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tcp_ipv6_exthdr_srh.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+#include <linux/in6.h>
+#include <linux/ipv6.h>
+#include <linux/seg6.h>
+#include <linux/bpf.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define NEXTHDR_ROUTING	43
+
+struct tcp_srh_storage {
+	struct in6_addr inner_segment;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct tcp_srh_storage);
+} socket_storage_map SEC(".maps");
+
+/* Check the header received from the active side */
+static int read_incoming_srh(struct bpf_sock_ops *skops,
+			     struct tcp_srh_storage *storage)
+{
+	__u32 seg_size = 2 * sizeof(struct in6_addr);
+	struct ipv6_sr_hdr *srh;
+	struct ipv6hdr *ip6;
+	void *seg_list;
+	int ret = 1;
+
+	ip6 = (struct ipv6hdr *)skops->skb_data;
+	if (ip6 + 1 <= skops->skb_data_end && ip6->nexthdr == NEXTHDR_ROUTING) {
+		srh = (struct ipv6_sr_hdr *)(ip6 + 1);
+		if (srh + 1 <= skops->skb_data_end) {
+			if (srh->type != IPV6_SRCRT_TYPE_4)
+				return ret;
+
+			seg_list = (void *)(srh + 1);
+			if (seg_list + seg_size <= skops->skb_data_end) {
+				// This is an SRH with at least 2 segments
+				storage->inner_segment = srh->segments[1];
+				ret = 0;
+			}
+		}
+	}
+
+	return ret;
+}
+
+SEC("sockops")
+int srh_read(struct bpf_sock_ops *skops)
+{
+	struct tcp_srh_storage *storage;
+	int true_val = 1;
+
+	if (!skops->sk)
+		return 1;
+
+	storage = bpf_sk_storage_get(&socket_storage_map, skops->sk, 0,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!storage)
+		return 1;
+
+	switch (skops->op) {
+	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
+	case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
+		bpf_sock_ops_cb_flags_set(skops, skops->bpf_sock_ops_cb_flags |
+				  BPF_SOCK_OPS_PARSE_IPV6_HDR_CB_FLAG);
+		break;
+	case BPF_SOCK_OPS_PARSE_IPV6_HDR_CB:
+		return read_incoming_srh(skops, storage);
+	}
+
+	return 0;
+}
-- 
2.32.0

