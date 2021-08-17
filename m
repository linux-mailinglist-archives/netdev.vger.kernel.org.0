Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4C13EE9BF
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239267AbhHQJ3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbhHQJ3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:30 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F71BC061764;
        Tue, 17 Aug 2021 02:28:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r6so27605450wrt.4;
        Tue, 17 Aug 2021 02:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SHN0knzzGUDpjgGLyjuHfb5FkhNeud4rrqTgmdVTNkY=;
        b=V82dXeXBSECwUshtZMbTtkeOFj/BN0I7KRH/i0pw/BtgUngyh4Q9eUK3iUXfPq6oRn
         4CiMDeuDBVgFjfzwWfqobp/JhA8ON2rM+G6UdD9uHyc/3kwMFmUxhqXW3XFbKhbA3T+N
         OMqt9aqlJOGOpuVVS6xoRBJ1JHuAPGA62iHvvEA1ue+o5+KJEsAMDgsxYr9ECoxd8+Pg
         Ihh3TLlcL3vsADOT0d8Juu3uICRt1iIPghrUX3N+K3rAaesU9SjtDECE4zfr4egZWFhf
         w7o8uMkDCQ0Su1n1qZkJ39cZGcOIZJ/W1WS4+43FxrRXB7aDZu9s9FsWzqNUTD/XhO3d
         LyzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SHN0knzzGUDpjgGLyjuHfb5FkhNeud4rrqTgmdVTNkY=;
        b=C1w+4KQ+ZoWwGtcDfhiboy+X5uZw2tOdsycH3wdaJrlUZevDntBuuG7OLxnSvd6Rtv
         bOr9L90cvrjVp3cWMLLngS9FOUgv8UN7z3vLWHVk+AY5AUicHaghdcEtrvjY4iTDD9le
         GC0WbCWTmLpcmDa0eWzgvfrx4DmgjKUBKHS0j5zudOQmaH3TFHAiyl+HQjBcsXHrCt0E
         j6uFMbSw9lUwYTUdiZwvmkxWg42T3npxa7bSyZhcCXVEznE8aQohPB+rWmBzlsdMA9mo
         Lsz5h4UML6Qe1wLcUsYTXkAX3z0anBoOMOLFdusyMMg4Ae4jlIBkB4T6oZ/m1UpwLCxw
         C35Q==
X-Gm-Message-State: AOAM531JjkkvtbOIthJ866fEyVTi19M8wk3gRY5JlBW4Lm49fTtaMHQR
        mBUM8WBFtRqb3jSWrkN6VHs=
X-Google-Smtp-Source: ABdhPJzJYIcqYOBlhY2ZCWXMP14nCTGHRcHO1/BNBBwMK8BLQVTE8563Q8EVskTH5yjY2F+SSypuZw==
X-Received: by 2002:a05:6000:1043:: with SMTP id c3mr2855042wrx.144.1629192536098;
        Tue, 17 Aug 2021 02:28:56 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.28.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:28:55 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 02/16] selftests: xsk: remove the num_tx_packets option
Date:   Tue, 17 Aug 2021 11:27:15 +0200
Message-Id: <20210817092729.433-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
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

