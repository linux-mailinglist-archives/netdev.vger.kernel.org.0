Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430E270E09
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 02:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387666AbfGWAU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 20:20:56 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:42644 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387654AbfGWAUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 20:20:54 -0400
Received: by mail-pg1-f177.google.com with SMTP id t132so18436018pgb.9;
        Mon, 22 Jul 2019 17:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c99wI2jfOxLnz3fmhTQtoGvPeUTV6PDxtGN0WADyrJ4=;
        b=TbzF36RLqf3xQFMehp2O7Pkqv8vK82CSnR6V2hyNXwIzAtDGmRRbKUccHcgR1o/H6M
         kJBE2CoE77vYdvDdh8zQKMhOEOu+bHEpdXQJwmH/tB0IHU/WDYrlvMP96l+4wswivbXB
         f9IifKiQ0oQZGKRA5BFex/hKpduPBSn53Vi7RAHdAWZQjzIG7C81SzlOD6dNDG/JRKZ1
         EiPvXEA4NxdH97le7WUVLvfh/z3qIhmZaBzi3gvsTcqXgFY14DYpA3dbx/L5fp5WoXei
         /AOTVaxjsslFFUUt96PJQqcKVfV8zxDC8LvEyDEIJ2u/CrtlDRSVJ/v+Y4uqVovy0VIx
         OGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c99wI2jfOxLnz3fmhTQtoGvPeUTV6PDxtGN0WADyrJ4=;
        b=H/rceGi6gbY1M5enVoPNBDuk3G/Hu4ZGTNzBy2R1o/k4FLczXi1uG5tiNAPK4TB6yY
         IG3RiD5Gpqal7FefTIEmP0nQOG6ROQ/IPmB6V90oDo3SXsTlUOBNliT4HL+XKIUBXmwS
         YhjQzBN4s2FcitWKLcbN+EtmG7BCy5rFM6ozlISMUTTOqeLky0ph6HgX2jw6Z/h+xjZA
         vVVpfs503sUySmjxLai4fNbvuCzGS/kInRknI39TAL3pz7otReSCf/ttM2Gs5hSqqUPP
         Pxk4eBddCZwCZ0QDgIKXScq3QBE58Bd9R2aYmdfTAGt8h8Cw6+MlKHImzsyVLXh/0z7s
         KbKw==
X-Gm-Message-State: APjAAAWhBGRwhxGmgww6WK/tMOSyKmewoPiLO9TuPsoDOVPbtJoR8pzx
        xY5eySvgQt2plG8hyGzeHH8ec8fb
X-Google-Smtp-Source: APXvYqwPAKyXkR6H82L55BrJOnevFktfT2e/P1ETBIADVido2fwEYFNPFs4ZhMRdCG615ws+O5D94g==
X-Received: by 2002:a63:4404:: with SMTP id r4mr72892133pga.245.1563841253222;
        Mon, 22 Jul 2019 17:20:53 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id k64sm21718423pge.65.2019.07.22.17.20.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 17:20:52 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next 6/6] selftests/bpf: add test for bpf_tcp_gen_syncookie
Date:   Mon, 22 Jul 2019 17:20:42 -0700
Message-Id: <20190723002042.105927-7-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
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
 .../bpf/progs/test_tcp_check_syncookie_kern.c | 48 +++++++++++++--
 .../selftests/bpf/test_tcp_check_syncookie.sh |  3 +
 .../bpf/test_tcp_check_syncookie_user.c       | 61 ++++++++++++++++---
 3 files changed, 99 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
index 1ab095bcacd8..d8803dfa8d32 100644
--- a/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcp_check_syncookie_kern.c
@@ -19,10 +19,29 @@
 struct bpf_map_def SEC("maps") results = {
 	.type = BPF_MAP_TYPE_ARRAY,
 	.key_size = sizeof(__u32),
-	.value_size = sizeof(__u64),
-	.max_entries = 1,
+	.value_size = sizeof(__u32),
+	.max_entries = 3,
 };
 
+static __always_inline __s64 gen_syncookie(void *data_end, struct bpf_sock *sk,
+					   void *iph, __u32 ip_size,
+					   struct tcphdr *tcph)
+{
+	__u32 thlen = tcph->doff * 4;
+
+	if (tcph->syn && !tcph->ack) {
+		// packet should only have an MSS option
+		if (thlen != 24)
+			return 0;
+
+		if ((void *)tcph + thlen > data_end)
+			return 0;
+
+		return bpf_tcp_gen_syncookie(sk, iph, ip_size, tcph, thlen);
+	}
+	return 0;
+}
+
 static __always_inline void check_syncookie(void *ctx, void *data,
 					    void *data_end)
 {
@@ -33,8 +52,10 @@ static __always_inline void check_syncookie(void *ctx, void *data,
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
@@ -66,6 +87,9 @@ static __always_inline void check_syncookie(void *ctx, void *data,
 		if (sk->state != BPF_TCP_LISTEN)
 			goto release;
 
+		seq_mss = gen_syncookie(data_end, sk, ipv4h, sizeof(*ipv4h),
+					tcph);
+
 		ret = bpf_tcp_check_syncookie(sk, ipv4h, sizeof(*ipv4h),
 					      tcph, sizeof(*tcph));
 		break;
@@ -95,6 +119,9 @@ static __always_inline void check_syncookie(void *ctx, void *data,
 		if (sk->state != BPF_TCP_LISTEN)
 			goto release;
 
+		seq_mss = gen_syncookie(data_end, sk, ipv6h, sizeof(*ipv6h),
+					tcph);
+
 		ret = bpf_tcp_check_syncookie(sk, ipv6h, sizeof(*ipv6h),
 					      tcph, sizeof(*tcph));
 		break;
@@ -103,8 +130,19 @@ static __always_inline void check_syncookie(void *ctx, void *data,
 		return;
 	}
 
-	if (ret == 0)
-		bpf_map_update_elem(&results, &key, &value, 0);
+	if (seq_mss > 0) {
+		__u32 cookie = (__u32)seq_mss;
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
diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie.sh b/tools/testing/selftests/bpf/test_tcp_check_syncookie.sh
index d48e51716d19..9b3617d770a5 100755
--- a/tools/testing/selftests/bpf/test_tcp_check_syncookie.sh
+++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie.sh
@@ -37,6 +37,9 @@ setup()
 	ns1_exec ip link set lo up
 
 	ns1_exec sysctl -w net.ipv4.tcp_syncookies=2
+	ns1_exec sysctl -w net.ipv4.tcp_window_scaling=0
+	ns1_exec sysctl -w net.ipv4.tcp_timestamps=0
+	ns1_exec sysctl -w net.ipv4.tcp_sack=0
 
 	wait_for_ip 127.0.0.1
 	wait_for_ip ::1
diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
index 87829c86c746..b9e991d43155 100644
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
+		printf("Skipping XDP cookie check\n");
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
2.22.0.657.g960e92d24f-goog

