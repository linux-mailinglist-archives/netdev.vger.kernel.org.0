Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE783D75B6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhG0NSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbhG0NSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:12 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F32C061757;
        Tue, 27 Jul 2021 06:18:12 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u15-20020a05600c19cfb02902501bdb23cdso1890796wmq.0;
        Tue, 27 Jul 2021 06:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SHN0knzzGUDpjgGLyjuHfb5FkhNeud4rrqTgmdVTNkY=;
        b=Dxq1hAc8rRxm1j7pBBfpeQlaTGwovuEQaH4XtU9gDQNZuBDj0FdqgsHdGMgXTWmo8u
         DEpb+8EVsNKN2+j/lCHG6QyynzZ7cdJCicuhTG/b0JvrmxL201GQDu4sWYV/V+jD5p3U
         YiVXfvs6NMTn8IQk1PxIrjwb16qNZ4wUyiY5uZtA2F+HT5uTY5nzL46pjUUuyDvFmVQC
         9Qg+cbAAFLosiODffitA2ZMP9c6s9+ltZ6HlBO+PXZL/UNRG3reKM4Hz27EEFlykXhB9
         CtmVRet1X3Zi/NpOblOwxVfnkh4MZqkN6iM/0uVlLYxxQI9RpKcGX4WFJgoSZu9iDncp
         TtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SHN0knzzGUDpjgGLyjuHfb5FkhNeud4rrqTgmdVTNkY=;
        b=PWc73YiYNFCdXzIjf75RXEJO+jrS27o9QG4Gre6PSffVrnBoQrQss6xiNY6R7Gl74Q
         R1lmXkEDtgvJqIL3QWwKCHIi40f6N+AgZiH8mXYykChzYwNlZGJf4Pv/emfMWhcaDoV2
         52nex9J3HKlGPZtzJy7Jo72O0vQs2peH+0rKwgnmmCW0B9rkF8ZsDl92DYLo7TkHZ0PL
         us67NU2SSigHQ4H3wYqtLxFVpBUV9c3ML/va8f8+SBhjx2Iq/etpwKEQSAvKj0Km/cfF
         VUVauENR01SioFOEAxjNCsfslHruBtY8TtnuyyVawOo4k6XjYBTri2/wcNAwHQ/RhW82
         1o8w==
X-Gm-Message-State: AOAM531SqCjQftvevrprEvNzih+yZgQxnOLEtHIsymh6Zt47GXZoHVwJ
        FkzTxGmlYEf6wgibY8p84Do=
X-Google-Smtp-Source: ABdhPJz/HqIymncdFcNwhh8s0lq/vQ0Y+seCu/vSUI5CSL44CqK6IhIDb9irOuOBomV4YAoSoWnHIw==
X-Received: by 2002:a7b:c390:: with SMTP id s16mr9741748wmj.148.1627391890687;
        Tue, 27 Jul 2021 06:18:10 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:10 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 02/17] selftests: xsk: remove the num_tx_packets option
Date:   Tue, 27 Jul 2021 15:17:38 +0200
Message-Id: <20210727131753.10924-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
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

