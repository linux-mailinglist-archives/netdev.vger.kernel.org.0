Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360A169FDA
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733086AbfGPA1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:27:13 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41161 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731009AbfGPA1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:27:06 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so9093329pls.8;
        Mon, 15 Jul 2019 17:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C5sbLTfe2RuDMOAfcQ0A+pj8yxLA1NP0/a7vJWI0Wyo=;
        b=lThVfbbIkbBkJC/o7jChzhRWnavVD4tkSg4EsqlIYGCyT6lXlQeG9kXrOFZIYIAX2a
         YEJ5s+r6h67ZodxP6MsNPH+btxrmkh+gwor7yDM4Nxhysq+iJGt8idRt0NTBxOf01W6l
         iNwBmgJRaoOxHAHy8dvUlybWpSJaLhZPLF3IUmfBcf/JRMVxouKzIpRfjPeBop4qIdOC
         SStdajmijPLO7HdXHj4Bf11pZiGa4Zr7lwhSVF1rkBdH5flxUi+rERTtCSQx7eTGcRK2
         F7V3U6lJvNSIW5w2+/xaWfIXU71h+NpaX6RyXJj5Mbyu0QvhGViLl8tTZPq93Bd2J/DN
         NbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C5sbLTfe2RuDMOAfcQ0A+pj8yxLA1NP0/a7vJWI0Wyo=;
        b=VCAM7bWfowlQywnPYnPdoX1Pjs32gRLEJuoW1QL8VLz9FU0FX6TurgIYt/X0MYaW3c
         ZhPSUHvakAU+odnMMBWC7qu1chFHADIEh11VI27MHYIMaXLsaSEo+I1BZ3g1hVyRvlYC
         mS7fQZ3y6wxgujPsfJdwg6WvWz6rZIsyHpNavCGQYrQs6pn4yICrywBBP/Q02U7J2wM3
         3Cc3/gGBcq0/WQS0pdJbkMMX7IyY+afFUgZAHyhHxN4oLsmQw4uX+vhrWrk34iahNo8j
         ElN30gcG1HOeWP+g1yxvNm5zg9vjrSh8TLbT4lDTbgViuk520xdM3BW1fH5Cq7BiVcWd
         WXZQ==
X-Gm-Message-State: APjAAAV+qOk8PCIsSTwwx9QyiA3SaDOtdDU/Tn5nA2FYKUpTdx4Wdx7/
        FVcG6mAhDNRvYXHFdJJ7fm+0BBBp
X-Google-Smtp-Source: APXvYqyPE0Lnb9TFXHQrwXvyGBUnY1A6kdLxZQBspMaRdgK3pAlX11dWpLd9VJFydXWi4NjyXpf1MA==
X-Received: by 2002:a17:902:968c:: with SMTP id n12mr33079468plp.59.1563236825956;
        Mon, 15 Jul 2019 17:27:05 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id q24sm16775444pjp.14.2019.07.15.17.27.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:27:05 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next RFC 6/6] selftests/bpf: add test for bpf_tcp_gen_syncookie
Date:   Mon, 15 Jul 2019 17:26:50 -0700
Message-Id: <20190716002650.154729-7-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

Modify the existing bpf_tcp_check_syncookie test to also generate a
SYN cookie, pass the packet to the kernel, and verify that the two
cookies are the same (and both valid). Since cloned SKBs are skipped
during generic XDP, this test does not issue a SYN cookie when run in
XDP mode. We therefore only check that a valid SYN cookie was issued at
the TC hook.

Additionally, verify that the MSS for that SYN cookie is within
expected range.

Signed-off-by: Petar Penkov <ppenkov@google.com>
---
 .../bpf/progs/test_tcp_check_syncookie_kern.c | 28 +++++++--
 .../bpf/test_tcp_check_syncookie_user.c       | 61 ++++++++++++++++---
 2 files changed, 76 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
index 1ab095bcacd8..229832766f42 100644
--- a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
@@ -19,8 +19,8 @@
 struct bpf_map_def SEC("maps") results = {
 	.type = BPF_MAP_TYPE_ARRAY,
 	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
-	.max_entries = 1,
+	.value_size = sizeof(__u32),
+	.max_entries = 3,
 };
 
 static __always_inline void check_syncookie(void *ctx, void *data,
@@ -33,8 +33,10 @@ static __always_inline void check_syncookie(void *ctx, void *data,
 	struct ipv6hdr *ipv6h;
 	struct tcphdr *tcph;
 	int ret;
+	__u32 key_mss = 2;
+	__u32 key_gen = 1;
 	__u32 key = 0;
-	__u64 value = 1;
+	__s64 seq_mss;
 
 	ethh = data;
 	if (ethh + 1 > data_end)
@@ -66,6 +68,8 @@ static __always_inline void check_syncookie(void *ctx, void *data,
 		if (sk->state != BPF_TCP_LISTEN)
 			goto release;
 
+		seq_mss = bpf_tcp_gen_syncookie(sk, ipv4h, sizeof(*ipv4h),
+						tcph, sizeof(*tcph));
 		ret = bpf_tcp_check_syncookie(sk, ipv4h, sizeof(*ipv4h),
 					      tcph, sizeof(*tcph));
 		break;
@@ -95,6 +99,9 @@ static __always_inline void check_syncookie(void *ctx, void *data,
 		if (sk->state != BPF_TCP_LISTEN)
 			goto release;
 
+		seq_mss = bpf_tcp_gen_syncookie(sk, ipv6h, sizeof(*ipv6h),
+						tcph, sizeof(*tcph));
+
 		ret = bpf_tcp_check_syncookie(sk, ipv6h, sizeof(*ipv6h),
 					      tcph, sizeof(*tcph));
 		break;
@@ -103,8 +110,19 @@ static __always_inline void check_syncookie(void *ctx, void *data,
 		return;
 	}
 
-	if (ret == 0)
-		bpf_map_update_elem(&results, &key, &value, 0);
+	if (seq_mss > 0) {
+		__u32 cookie = bpf_ntohl((__u32)seq_mss);
+		__u32 mss = seq_mss >> 32;
+
+		bpf_map_update_elem(&results, &key_gen, &cookie, 0);
+		bpf_map_update_elem(&results, &key_mss, &mss, 0);
+	}
+
+	if (ret == 0) {
+		__u32 cookie = bpf_ntohl(tcph->ack_seq) - 1;
+
+		bpf_map_update_elem(&results, &key, &cookie, 0);
+	}
 
 release:
 	bpf_sk_release(sk);
diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
index 87829c86c746..f3ff49ceb481 100644
--- a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
+++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2018 Facebook
 // Copyright (c) 2019 Cloudflare
 
+#include <limits.h>
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -77,7 +78,7 @@ static int connect_to_server(int server_fd)
 	return fd;
 }
 
-static int get_map_fd_by_prog_id(int prog_id)
+static int get_map_fd_by_prog_id(int prog_id, bool *xdp)
 {
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
@@ -104,6 +105,8 @@ static int get_map_fd_by_prog_id(int prog_id)
 		goto err;
 	}
 
+	*xdp = info.type == BPF_PROG_TYPE_XDP;
+
 	map_fd = bpf_map_get_fd_by_id(map_ids[0]);
 	if (map_fd < 0)
 		log_err("Failed to get fd by map id %d", map_ids[0]);
@@ -113,18 +116,32 @@ static int get_map_fd_by_prog_id(int prog_id)
 	return map_fd;
 }
 
-static int run_test(int server_fd, int results_fd)
+static int run_test(int server_fd, int results_fd, bool xdp)
 {
 	int client = -1, srv_client = -1;
 	int ret = 0;
 	__u32 key = 0;
-	__u64 value = 0;
+	__u32 key_gen = 1;
+	__u32 key_mss = 2;
+	__u32 value = 0;
+	__u32 value_gen = 0;
+	__u32 value_mss = 0;
 
 	if (bpf_map_update_elem(results_fd, &key, &value, 0) < 0) {
 		log_err("Can't clear results");
 		goto err;
 	}
 
+	if (bpf_map_update_elem(results_fd, &key_gen, &value_gen, 0) < 0) {
+		log_err("Can't clear results");
+		goto err;
+	}
+
+	if (bpf_map_update_elem(results_fd, &key_mss, &value_mss, 0) < 0) {
+		log_err("Can't clear results");
+		goto err;
+	}
+
 	client = connect_to_server(server_fd);
 	if (client == -1)
 		goto err;
@@ -140,8 +157,35 @@ static int run_test(int server_fd, int results_fd)
 		goto err;
 	}
 
-	if (value != 1) {
-		log_err("Didn't match syncookie: %llu", value);
+	if (value == 0) {
+		log_err("Didn't match syncookie: %u", value);
+		goto err;
+	}
+
+	if (bpf_map_lookup_elem(results_fd, &key_gen, &value_gen) < 0) {
+		log_err("Can't lookup result");
+		goto err;
+	}
+
+	if (xdp && value_gen == 0) {
+		// SYN packets do not get passed through generic XDP, skip the
+		// rest of the test.
+		log_err("Did not find SYN cookie at XDP.");
+		goto out;
+	}
+
+	if (bpf_map_lookup_elem(results_fd, &key_mss, &value_mss) < 0) {
+		log_err("Can't lookup result");
+		goto err;
+	}
+
+	if (value != value_gen) {
+		log_err("BPF generated cookie does not match kernel one");
+		goto err;
+	}
+
+	if (value_mss < 536 || value_mss > USHRT_MAX) {
+		log_err("Unexpected MSS retrieved");
 		goto err;
 	}
 
@@ -163,13 +207,14 @@ int main(int argc, char **argv)
 	int server_v6 = -1;
 	int results = -1;
 	int err = 0;
+	bool xdp;
 
 	if (argc < 2) {
 		fprintf(stderr, "Usage: %s prog_id\n", argv[0]);
 		exit(1);
 	}
 
-	results = get_map_fd_by_prog_id(atoi(argv[1]));
+	results = get_map_fd_by_prog_id(atoi(argv[1]), &xdp);
 	if (results < 0) {
 		log_err("Can't get map");
 		goto err;
@@ -194,10 +239,10 @@ int main(int argc, char **argv)
 	if (server_v6 == -1)
 		goto err;
 
-	if (run_test(server, results))
+	if (run_test(server, results, xdp))
 		goto err;
 
-	if (run_test(server_v6, results))
+	if (run_test(server_v6, results, xdp))
 		goto err;
 
 	printf("ok\n");
-- 
2.22.0.510.g264f2c817a-goog

