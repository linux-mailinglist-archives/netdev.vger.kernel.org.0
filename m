Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33124162336
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgBRJQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:16:37 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:35649 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgBRJQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 04:16:36 -0500
Received: by mail-pf1-f172.google.com with SMTP id y73so10353542pfg.2;
        Tue, 18 Feb 2020 01:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gTzqX9MZ+13NkjyUA3S/Rp+W6CQYR2KrA7XcAGA6wdU=;
        b=B+AlZHGcpJk0mxGmPoY7aZFp0ikUmF6RIRP7ID7OmMIL90dTtMS9GCU/YyRDm3lfMu
         sdtpz6yMAR9tiT2bY5cM2Z9ZgsfXHLH1MSEqxrOkjE2CXhVmHuiu1hEpYsNb5IpVaw/H
         S/FGaT/DNPuCoHcSdDtZKvH5tR4wwI/KdZGUGBt1UldliBgZarCa1b17OGwwpzzS2mfg
         MxSpEL760lVTX9b+TFfmr1ETsCb1Ap7z0akQAleYQbi6wk00vZ68vqsxJQ988DX1szh/
         KY4KEfScmqLJKodyO6O1oXv7Yh/+w90UEns2cNwvSOg1GB/0FmK6CT9BGCgqNygyTG3i
         eLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gTzqX9MZ+13NkjyUA3S/Rp+W6CQYR2KrA7XcAGA6wdU=;
        b=HkJGVu8N2xBJb1RoIMXYGX6e8QjMmAnpoDdRkrpt9gYUGfPChV84ypwCskVstvO4vZ
         NMH/G8StHqBcE70kXdo5gfYJ9fgo1Gko08YwhVLAkTUIOoA1h8Q8UuydCjaFDpr9JMHa
         0rzBBBazaPYgxorq1IDZAzvNDTkHf+RoAb+L/qQ0OidZAuf/Ma9EMntNAFnixwI4pQtA
         JwaqfxTVq6Y0dlQvfZL3MrA1NpZqxrCefLnXbgLk0Uty3JfHNXdgk4sy8pcj37IJLaBu
         K7kKKvth3Q2hPSzsJgCgsli7RhgWJ5VmgHMK4dLNwECiGop/owbfeyNbp//hxPsbKL4A
         8Dqg==
X-Gm-Message-State: APjAAAV21EYBd8iEkDCX2ii4s6tXaWX4M3GOYMfbIm8Bs5K0BC4GrgOg
        3N2uh4GZHmU9sgmd3TFxnn2sPfdiv1fYfg==
X-Google-Smtp-Source: APXvYqw78e8junFXhv9T9LHsbHXY4LhWqaxISEgzBHJrNzX/HevXlUf23y/TUMVgvKIZ5MCorVaTtQ==
X-Received: by 2002:a62:15d8:: with SMTP id 207mr21015921pfv.40.1582017395525;
        Tue, 18 Feb 2020 01:16:35 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id h191sm1992110pge.85.2020.02.18.01.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 01:16:35 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: add selftest for sock_ops_get_netns helper
Date:   Tue, 18 Feb 2020 09:15:41 +0000
Message-Id: <20200218091541.107371-4-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218091541.107371-1-forrest0579@gmail.com>
References: <20200206083515.10334-1-forrest0579@gmail.com>
 <20200218091541.107371-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

adding selftest for new bpf helper function sock_ops_get_netns

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
---
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 11 +++++
 .../testing/selftests/bpf/test_tcpbpf_user.c  | 46 ++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index 1f1966e86e9f..044967f70432 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -28,6 +28,13 @@ struct {
 	__type(value, int);
 } sockopt_results SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} netns_number SEC(".maps");
+
 static inline void update_event_map(int event)
 {
 	__u32 key = 0;
@@ -61,6 +68,7 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 	int rv = -1;
 	int v = 0;
 	int op;
+	__u64 netns_inum;
 
 	op = (int) skops->op;
 
@@ -144,6 +152,9 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 		__u32 key = 0;
 
 		bpf_map_update_elem(&sockopt_results, &key, &v, BPF_ANY);
+
+		netns_inum = bpf_sock_ops_get_netns(skops);
+		bpf_map_update_elem(&netns_number, &key, &netns_inum, BPF_ANY);
 		break;
 	default:
 		rv = -1;
diff --git a/tools/testing/selftests/bpf/test_tcpbpf_user.c b/tools/testing/selftests/bpf/test_tcpbpf_user.c
index 3ae127620463..77a344f41310 100644
--- a/tools/testing/selftests/bpf/test_tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/test_tcpbpf_user.c
@@ -76,6 +76,41 @@ int verify_sockopt_result(int sock_map_fd)
 	return ret;
 }
 
+int verify_netns(__u64 netns_inum)
+{
+	char buf1[40];
+	char buf2[40];
+	int ret = 0;
+	ssize_t len = 0;
+
+	len = readlink("/proc/self/ns/net", buf1, 39);
+	sprintf(buf2, "net:[%llu]", netns_inum);
+
+	if (len <= 0) {
+		printf("FAILED: readlink /proc/self/ns/net");
+		return ret;
+	}
+
+	if (strncmp(buf1, buf2, len)) {
+		printf("FAILED: netns don't match");
+		ret = 1;
+	}
+	return ret;
+}
+
+int verify_netns_result(int netns_map_fd)
+{
+	__u32 key = 0;
+	__u64 res = 0;
+	int ret = 0;
+	int rv;
+
+	rv = bpf_map_lookup_elem(netns_map_fd, &key, &res);
+	EXPECT_EQ(0, rv, "d");
+
+	return verify_netns(res);
+}
+
 static int bpf_find_map(const char *test, struct bpf_object *obj,
 			const char *name)
 {
@@ -92,7 +127,7 @@ static int bpf_find_map(const char *test, struct bpf_object *obj,
 int main(int argc, char **argv)
 {
 	const char *file = "test_tcpbpf_kern.o";
-	int prog_fd, map_fd, sock_map_fd;
+	int prog_fd, map_fd, sock_map_fd, netns_map_fd;
 	struct tcpbpf_globals g = {0};
 	const char *cg_path = "/foo";
 	int error = EXIT_FAILURE;
@@ -137,6 +172,10 @@ int main(int argc, char **argv)
 	if (sock_map_fd < 0)
 		goto err;
 
+	netns_map_fd = bpf_find_map(__func__, obj, "netns_number");
+	if (netns_map_fd < 0)
+		goto err;
+
 retry_lookup:
 	rv = bpf_map_lookup_elem(map_fd, &key, &g);
 	if (rv != 0) {
@@ -161,6 +200,11 @@ int main(int argc, char **argv)
 		goto err;
 	}
 
+	if (verify_netns_result(netns_map_fd)) {
+		printf("FAILED: Wrong netns stats\n");
+		goto err;
+	}
+
 	printf("PASSED!\n");
 	error = 0;
 err:
-- 
2.20.1

