Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C6E3F71DB
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239708AbhHYJip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239700AbhHYJil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:41 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BE3C061757;
        Wed, 25 Aug 2021 02:37:55 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z9so35354712wrh.10;
        Wed, 25 Aug 2021 02:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SHN0knzzGUDpjgGLyjuHfb5FkhNeud4rrqTgmdVTNkY=;
        b=CP8O+bCjnQC2GH4fM4yB/W5yjfVituw17NH4tBpruQ0TGGW2iCHy+JFY6b263fThXK
         G5Zrc2leoyA+Omf6q6X1ykKG8kDZ5KInYl4jD98FFrZFWnsbXjUBk+bj3MGbD33Qt/pe
         riqol+FiYiK9W/RhOdNwP2DiyeCPE/g7c7MS8IotCAjkU4vHL/x6S4eEUU48rIu4IlCR
         5whGkFd752QwmSBPoKdnXex8+0PKh/D7VUTX+HYUX2Q7UhJ0Q19H07kMC5Opbg+UhCIz
         xy4AfV4uTOwgMpceWLnrOlPrfp6DQuZLFAeW/Ch3yHtZKMgj1+7OjYdwLCBchQWMQQJq
         11zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SHN0knzzGUDpjgGLyjuHfb5FkhNeud4rrqTgmdVTNkY=;
        b=NGq7sboeNPJi/f6/9yd05ZNXRF1WPQgS6N9BvGJr3NVh1jNL9rj/hqgh8Sipbbcnk9
         GsDRy74BZ73I986+bVt/chsDaUMSeCSYiwjXqhwxk/l6hodzz3OWFYxnqf4xceGvPpRO
         Iscd+5ORmxa1wO8d1sfivr7IflXyMkcbK4HRiYHzXhThaaE0Bg7QsAY4wXkdFljT65kQ
         DiG2WiLBgOwr0N/n7ks6I1HfZuH24J8d6if3Vzh+GLUC6+xWwTM5jOymfRON8My7qKdj
         3Z8p8BNehE6vkTBKVD+Ucva0K5x8jt0TiUT1R0xvTGXo/aI+l2/H1i9W/XTinwp7FC0F
         Rg7w==
X-Gm-Message-State: AOAM530sbjSBJp452BQ/zfc2eC6AhAugXqWhd4Q8yRo8n8ed4zI96qqd
        7iUJe50eDkCtcN3qc86TX54=
X-Google-Smtp-Source: ABdhPJyOsivdfAw46qz7bOrsQK4dvtwR7FRffMqa4bQclv5ahZSkSy0nWd3Rf46eQom6cA6FV6YzsA==
X-Received: by 2002:a5d:4f02:: with SMTP id c2mr24642975wru.311.1629884274428;
        Wed, 25 Aug 2021 02:37:54 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.37.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:37:54 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 02/16] selftests: xsk: remove the num_tx_packets option
Date:   Wed, 25 Aug 2021 11:37:08 +0200
Message-Id: <20210825093722.10219-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove the number of tx packet option as this should be decided by the
test itself. Also change the number of packets to be sent to 4096
speeding up the execution.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c   | 33 +++++++---------------
 tools/testing/selftests/bpf/xdpxceiver.h   |  4 +--
 tools/testing/selftests/bpf/xsk_prereqs.sh |  3 +-
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 1135fb980814..1b0efe566278 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -333,20 +333,19 @@ static struct option long_options[] = {
 	{"queue", optional_argument, 0, 'q'},
 	{"dump-pkts", optional_argument, 0, 'D'},
 	{"verbose", no_argument, 0, 'v'},
-	{"tx-pkt-count", optional_argument, 0, 'C'},
 	{0, 0, 0, 0}
 };
 
 static void usage(const char *prog)
 {
 	const char *str =
-	    "  Usage: %s [OPTIONS]\n"
-	    "  Options:\n"
-	    "  -i, --interface      Use interface\n"
-	    "  -q, --queue=n        Use queue n (default 0)\n"
-	    "  -D, --dump-pkts      Dump packets L2 - L5\n"
-	    "  -v, --verbose        Verbose output\n"
-	    "  -C, --tx-pkt-count=n Number of packets to send\n";
+		"  Usage: %s [OPTIONS]\n"
+		"  Options:\n"
+		"  -i, --interface      Use interface\n"
+		"  -q, --queue=n        Use queue n (default 0)\n"
+		"  -D, --dump-pkts      Dump packets L2 - L5\n"
+		"  -v, --verbose        Verbose output\n";
+
 	ksft_print_msg(str, prog);
 }
 
@@ -392,7 +391,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:DC:v", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:Dv", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -415,9 +414,6 @@ static void parse_command_line(int argc, char **argv)
 		case 'D':
 			debug_pkt_dump = 1;
 			break;
-		case 'C':
-			opt_pkt_count = atoi(optarg);
-			break;
 		case 'v':
 			opt_verbose = 1;
 			break;
@@ -427,11 +423,6 @@ static void parse_command_line(int argc, char **argv)
 		}
 	}
 
-	if (!opt_pkt_count) {
-		print_verbose("No tx-pkt-count specified, using default %u\n", DEFAULT_PKT_CNT);
-		opt_pkt_count = DEFAULT_PKT_CNT;
-	}
-
 	if (!validate_interfaces()) {
 		usage(basename(argv[0]));
 		ksft_exit_xfail();
@@ -554,9 +545,6 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
 
 static int get_batch_size(int pkt_cnt)
 {
-	if (!opt_pkt_count)
-		return BATCH_SIZE;
-
 	if (pkt_cnt + BATCH_SIZE <= opt_pkt_count)
 		return BATCH_SIZE;
 
@@ -586,7 +574,7 @@ static void tx_only_all(struct ifobject *ifobject)
 	fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds[0].events = POLLOUT;
 
-	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
+	while (pkt_cnt < opt_pkt_count) {
 		int batch_size = get_batch_size(pkt_cnt);
 
 		if (test_type == TEST_TYPE_POLL) {
@@ -602,8 +590,7 @@ static void tx_only_all(struct ifobject *ifobject)
 		pkt_cnt += batch_size;
 	}
 
-	if (opt_pkt_count)
-		complete_tx_only_all(ifobject);
+	complete_tx_only_all(ifobject);
 }
 
 static void worker_pkt_dump(void)
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 6c428b276ab6..4ce5a18b32e7 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -39,7 +39,7 @@
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
 #define POLL_TMOUT 1000
-#define DEFAULT_PKT_CNT 10000
+#define DEFAULT_PKT_CNT (4 * 1024)
 #define RX_FULL_RXQSIZE 32
 
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
@@ -79,7 +79,7 @@ static u32 num_frames;
 static bool second_step;
 static int test_type;
 
-static int opt_pkt_count;
+static u32 opt_pkt_count = DEFAULT_PKT_CNT;
 static u8 opt_verbose;
 
 static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index 8fe022a4dbfa..bf29d2549bee 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -10,7 +10,6 @@ ksft_skip=4
 
 SPECFILE=veth.spec
 XSKOBJ=xdpxceiver
-NUMPKTS=10000
 
 validate_root_exec()
 {
@@ -92,5 +91,5 @@ validate_ip_utility()
 
 execxdpxceiver()
 {
-	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} -C ${NUMPKTS} ${VERBOSE_ARG} ${DUMP_PKTS_ARG}
+	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${VERBOSE_ARG} ${DUMP_PKTS_ARG}
 }
-- 
2.29.0

