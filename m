Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148672A0528
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgJ3MOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgJ3MOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:14:42 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22576C0613D2;
        Fri, 30 Oct 2020 05:14:42 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s9so6201036wro.8;
        Fri, 30 Oct 2020 05:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8gk9rHR2BMpwjI4+s357QU13xZVLjB9WG8eIeUJDvO4=;
        b=RyvZ6h9MhShsv+26kLW0obcr2y0ACo7uQUgdB6i9tJRhwdebeLCB8MWwOIOmujE6/X
         7griymeTzBcLqg8Dhuvb2YjyyWrW3dS8bMVG8oJJBfq0icPSla/8JuwD82ShCanR7OeB
         d4ztRZIR3htQ3kQNajDhYIhO6rooHpmUJxndnmuLYnzkdSmdfR8Ocg+MAYGzFtCmvsmm
         Kwax+pB892v5RChwA3M91eMJt7O3npsxpaiSvA1Vc1z2um1W9hJXFOD+TfTHg5RJ+4xM
         c2jzJalxyp3GkWl3zGFzIVWkGIBlu0Gs/Uf6DBAMXtujgZHl9MjLsVsIq4DaiTQnHC5A
         uZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gk9rHR2BMpwjI4+s357QU13xZVLjB9WG8eIeUJDvO4=;
        b=nX3jpUGMqFqxBQjt/V5rBWNbcZoCkfBl5hsyV9lOIsXFDgx1NX34d88P6soN6npjES
         IFJ43uFj971urKZ2mZya/rw1z+OzoRA+2HLQ8mW8vD/DCkwoPv8634fi3xzaJ26tz1nn
         VZQ341nZ3Zn7boOY8Ee5ZidBb8U+/pOxYFKrnzD9BGac3dSdiQQZi+GOKesPu8kL3rCr
         XZaUHTes2geqdKx4nNL8eFHBPvFkJr3mdrHslEmyIbFLa8Ft0Qy+3lwQf86wba77A6Bi
         8fMG38w2A6R+c2yrsdQct0jU4QNMButZ/DHPz5YRzCygTHydhHjl95HSQUh/z5lEVL15
         0Lrw==
X-Gm-Message-State: AOAM533edbpuMcRg2q0kXQ4N1KyI98DHvP1kdCSTwv6UTcfvw5cqDLuD
        IvvEPlGuVu1a4oOmVo5pVsPcRCle0dP6/sUoRFQ=
X-Google-Smtp-Source: ABdhPJw06oamBXEBESdF+n7rCiJTpR6UgPJGBEsDWfPPR27jPDWwhMd24aTcsq1JIy7C48OGD+P0zg==
X-Received: by 2002:adf:f4c9:: with SMTP id h9mr2672802wrp.332.1604060080185;
        Fri, 30 Oct 2020 05:14:40 -0700 (PDT)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id 90sm10020925wrh.35.2020.10.30.05.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 05:14:39 -0700 (PDT)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 5/5] selftests/xsk: xsk selftests - Bi-directional Sockets - SKB, DRV
Date:   Fri, 30 Oct 2020 12:13:47 +0000
Message-Id: <20201030121347.26984-6-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
References: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds following tests:

1. AF_XDP SKB mode
   d. Bi-directional Sockets
      Configure sockets as bi-directional tx/rx sockets, sets up fill
      and completion rings on each socket, tx/rx in both directions.
      Only nopoll mode is used

2. AF_XDP DRV/Native mode
   d. Bi-directional Sockets
   * Only copy mode is supported because veth does not currently support
     zero-copy mode

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/xsk/Makefile          |  4 +-
 tools/testing/selftests/xsk/README            |  7 +-
 .../xsk/TEST_XSK_DRV_BIDIRECTIONAL.sh         | 22 +++++
 .../selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh    |  3 -
 .../xsk/TEST_XSK_SKB_BIDIRECTIONAL.sh         | 19 ++++
 .../selftests/xsk/xdpprogs/xdpxceiver.c       | 93 ++++++++++++++-----
 .../selftests/xsk/xdpprogs/xdpxceiver.h       |  4 +
 7 files changed, 124 insertions(+), 28 deletions(-)
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_DRV_BIDIRECTIONAL.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_SKB_BIDIRECTIONAL.sh

diff --git a/tools/testing/selftests/xsk/Makefile b/tools/testing/selftests/xsk/Makefile
index 79d106b30922..550a9b0d81c4 100644
--- a/tools/testing/selftests/xsk/Makefile
+++ b/tools/testing/selftests/xsk/Makefile
@@ -12,7 +12,9 @@ TEST_PROGS := TEST_PREREQUISITES.sh \
 	TEST_XSK_DRV_NOPOLL.sh \
 	TEST_XSK_DRV_POLL.sh \
 	TEST_XSK_SKB_TEARDOWN.sh \
-	TEST_XSK_DRV_TEARDOWN.sh
+	TEST_XSK_DRV_TEARDOWN.sh \
+	TEST_XSK_SKB_BIDIRECTIONAL.sh \
+	TEST_XSK_DRV_BIDIRECTIONAL.sh
 TEST_FILES := prereqs.sh xskenv.sh
 TEST_TRANSIENT_FILES := veth.spec
 TEST_PROGS_EXTENDED := $(XSKDIR)/$(XSKOBJ)
diff --git a/tools/testing/selftests/xsk/README b/tools/testing/selftests/xsk/README
index e2ae3c804bfb..b96ba9333782 100644
--- a/tools/testing/selftests/xsk/README
+++ b/tools/testing/selftests/xsk/README
@@ -66,6 +66,10 @@ The following tests are run:
    c. Socket Teardown
       Create a Tx and a Rx socket, Tx from one socket, Rx on another. Destroy
       both sockets, then repeat multiple times. Only nopoll mode is used
+   d. Bi-directional sockets
+      Configure sockets as bi-directional tx/rx sockets, sets up fill and
+      completion rings on each socket, tx/rx in both directions. Only nopoll
+      mode is used
 
 2. AF_XDP DRV/Native mode
    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -74,10 +78,11 @@ The following tests are run:
    a. nopoll
    b. poll
    c. Socket Teardown
+   d. Bi-directional sockets
    * Only copy mode is supported because veth does not currently support
      zero-copy mode
 
-Total tests: 6.
+Total tests: 8.
 
 Flow:
 * Single process spawns two threads: Tx and Rx
diff --git a/tools/testing/selftests/xsk/TEST_XSK_DRV_BIDIRECTIONAL.sh b/tools/testing/selftests/xsk/TEST_XSK_DRV_BIDIRECTIONAL.sh
new file mode 100755
index 000000000000..6dca372f66cd
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_XSK_DRV_BIDIRECTIONAL.sh
@@ -0,0 +1,22 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+#Includes
+. prereqs.sh
+. xskenv.sh
+
+TEST_NAME="DRV BIDIRECTIONAL SOCKETS"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-B")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+# Must be called in the last test to execute
+cleanup_exit ${VETH0} ${VETH1} ${NS1}
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh b/tools/testing/selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh
index 1867f3c07d74..554dd629faad 100755
--- a/tools/testing/selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh
+++ b/tools/testing/selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh
@@ -15,7 +15,4 @@ execxdpxceiver params
 retval=$?
 test_status $retval "${TEST_NAME}"
 
-# Must be called in the last test to execute
-cleanup_exit ${VETH0} ${VETH1} ${NS1}
-
 test_exit $retval 0
diff --git a/tools/testing/selftests/xsk/TEST_XSK_SKB_BIDIRECTIONAL.sh b/tools/testing/selftests/xsk/TEST_XSK_SKB_BIDIRECTIONAL.sh
new file mode 100755
index 000000000000..0b9594b38166
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_XSK_SKB_BIDIRECTIONAL.sh
@@ -0,0 +1,19 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+#Includes
+. prereqs.sh
+. xskenv.sh
+
+TEST_NAME="SKB BIDIRECTIONAL SOCKETS"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "-B")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
index 6877b59f4534..b9d6a988dc07 100644
--- a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
+++ b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
@@ -49,8 +49,9 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
-			       "NOPOLL", opt_teardown ? "Socket Teardown" : ""))
+	(ksft_test_result_pass("PASS: %s %s %s%s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
+			       "NOPOLL", opt_teardown ? "Socket Teardown" : "",\
+			       opt_bidi ? "Bi-directional Sockets" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -256,8 +257,13 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 	cfg.xdp_flags = opt_xdp_flags;
 	cfg.bind_flags = opt_xdp_bind_flags;
 
-	rxr = (ifobject->fv.vector == rx) ? &ifobject->xsk->rx : NULL;
-	txr = (ifobject->fv.vector == tx) ? &ifobject->xsk->tx : NULL;
+	if (!opt_bidi) {
+		rxr = (ifobject->fv.vector == rx) ? &ifobject->xsk->rx : NULL;
+		txr = (ifobject->fv.vector == tx) ? &ifobject->xsk->tx : NULL;
+	} else {
+		rxr = &ifobject->xsk->rx;
+		txr = &ifobject->xsk->tx;
+	}
 
 	ret = xsk_socket__create(&ifobject->xsk->xsk, ifobject->ifname,
 				 opt_queue, ifobject->umem->umem, rxr, txr, &cfg);
@@ -276,6 +282,7 @@ static struct option long_options[] = {
 	{"xdp-native", no_argument, 0, 'N'},
 	{"copy", no_argument, 0, 'c'},
 	{"tear-down", no_argument, 0, 'T'},
+	{"bidi", optional_argument, 0, 'B'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
 	{0, 0, 0, 0}
@@ -293,6 +300,7 @@ static void usage(const char *prog)
 	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
 	    "  -c, --copy           Force copy mode\n"
 	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
+	    "  -B, --bidi           Bi-directional sockets test\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
 	ksft_print_msg(str, prog);
@@ -383,7 +391,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcTDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTBDC:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -424,6 +432,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'T':
 			opt_teardown = 1;
 			break;
+		case 'B':
+			opt_bidi = 1;
+			break;
 		case 'D':
 			debug_pkt_dump = 1;
 			break;
@@ -733,22 +744,25 @@ static void *worker_testapp_validate(void *arg)
 	struct generic_data *data = (struct generic_data *)malloc(sizeof(struct generic_data));
 	struct iphdr *ip_hdr = (struct iphdr *)(pkt_data + sizeof(struct ethhdr));
 	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
-	void *bufs;
+	void *bufs = NULL;
 
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
 
-	bufs = mmap(NULL, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE,
-		    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (bufs == MAP_FAILED)
-		exit_with_error(errno);
+	if (!bidi_pass) {
+		bufs = mmap(NULL, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE,
+			    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		if (bufs == MAP_FAILED)
+			exit_with_error(errno);
 
-	if (strcmp(((struct ifobject *)arg)->nsname, ""))
-		switch_namespace(((struct ifobject *)arg)->ifdict_index);
+		if (strcmp(((struct ifobject *)arg)->nsname, ""))
+			switch_namespace(((struct ifobject *)arg)->ifdict_index);
+	}
 
 	if (((struct ifobject *)arg)->fv.vector == tx) {
 		int spinningrxctr = 0;
 
-		thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_tx);
+		if (!bidi_pass)
+			thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_tx);
 
 		while (atomic_load(&spinning_rx) && spinningrxctr < SOCK_RECONF_CTR) {
 			spinningrxctr++;
@@ -778,7 +792,8 @@ static void *worker_testapp_validate(void *arg)
 		struct pollfd fds[MAX_SOCKS] = { };
 		int ret;
 
-		thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_rx);
+		if (!bidi_pass)
+			thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_rx);
 
 		ksft_print_msg("Interface [%s] vector [Rx]\n", ((struct ifobject *)arg)->ifname);
 		xsk_populate_fill_ring(((struct ifobject *)arg)->umem);
@@ -817,8 +832,10 @@ static void *worker_testapp_validate(void *arg)
 			ksft_print_msg("Destroying socket\n");
 	}
 
-	xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
-	(void)xsk_umem__delete(((struct ifobject *)arg)->umem->umem);
+	if (!opt_bidi || (opt_bidi && bidi_pass)) {
+		xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
+		(void)xsk_umem__delete(((struct ifobject *)arg)->umem->umem);
+	}
 	pthread_exit(NULL);
 }
 
@@ -827,11 +844,26 @@ static void testapp_validate(void)
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
 
+	if (opt_bidi && bidi_pass) {
+		pthread_init_mutex();
+		if (!switching_notify) {
+			ksft_print_msg("Switching Tx/Rx vectors\n");
+			switching_notify++;
+		}
+	}
+
 	pthread_mutex_lock(&sync_mutex);
 
 	/*Spawn RX thread */
-	if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[1]))
-		exit_with_error(errno);
+	if (!opt_bidi || (opt_bidi && !bidi_pass)) {
+		if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[1]))
+			exit_with_error(errno);
+	} else if (opt_bidi && bidi_pass) {
+		/*switch Tx/Rx vectors */
+		ifdict[0]->fv.vector = rx;
+		if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[0]))
+			exit_with_error(errno);
+	}
 
 	struct timespec max_wait = { 0, 0 };
 
@@ -845,8 +877,15 @@ static void testapp_validate(void)
 	pthread_mutex_unlock(&sync_mutex);
 
 	/*Spawn TX thread */
-	if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[0]))
-		exit_with_error(errno);
+	if (!opt_bidi || (opt_bidi && !bidi_pass)) {
+		if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[0]))
+			exit_with_error(errno);
+	} else if (opt_bidi && bidi_pass) {
+		/*switch Tx/Rx vectors */
+		ifdict[1]->fv.vector = tx;
+		if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[1]))
+			exit_with_error(errno);
+	}
 
 	pthread_join(t1, NULL);
 	pthread_join(t0, NULL);
@@ -860,18 +899,19 @@ static void testapp_validate(void)
 		free(pkt_buf);
 	}
 
-	if (!opt_teardown)
+	if (!opt_teardown && !opt_bidi)
 		print_ksft_result();
 }
 
 static void testapp_sockets(void)
 {
-	for (int i = 0; i < MAX_TEARDOWN_ITER; i++) {
+	for (int i = 0; i < (opt_teardown ? MAX_TEARDOWN_ITER : MAX_BIDI_ITER); i++) {
 		pkt_counter = 0;
 		prev_pkt = -1;
 		sigvar = 0;
 		ksft_print_msg("Creating socket\n");
 		testapp_validate();
+		opt_bidi ? bidi_pass++ : bidi_pass;
 	}
 
 	print_ksft_result();
@@ -940,7 +980,14 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(1);
 
-	opt_teardown ? testapp_sockets() : testapp_validate();
+	if (!opt_teardown && !opt_bidi) {
+		testapp_validate();
+	} else if (opt_teardown && opt_bidi) {
+		ksft_test_result_fail("ERROR: parameters -T and -B cannot be used together\n");
+		ksft_exit_xfail();
+	} else {
+		testapp_sockets();
+	}
 
 	for (int i = 0; i < MAX_INTERFACES; i++)
 		free(ifdict[i]);
diff --git a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
index 41fc62adad3b..d9b87a719e43 100644
--- a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
+++ b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
@@ -22,6 +22,7 @@
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
 #define MAX_SOCKS 1
 #define MAX_TEARDOWN_ITER 10
+#define MAX_BIDI_ITER 2
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
 			sizeof(struct udphdr))
 #define MIN_PKT_SIZE 64
@@ -52,12 +53,15 @@ enum TESTS {
 u8 uut;
 u8 debug_pkt_dump;
 u32 num_frames;
+u8 switching_notify;
+u8 bidi_pass;
 
 static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int opt_queue;
 static int opt_pkt_count;
 static int opt_poll;
 static int opt_teardown;
+static int opt_bidi;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
-- 
2.20.1

