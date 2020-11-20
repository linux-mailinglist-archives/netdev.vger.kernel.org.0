Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D34A2BAABB
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgKTNAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbgKTNAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:00:50 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A419FC0613CF;
        Fri, 20 Nov 2020 05:00:49 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c198so8396687wmd.0;
        Fri, 20 Nov 2020 05:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=osRy1FbXLS8WJ/jwgsa84l1vv7LffAWp2JoJMu+h49k=;
        b=c1Uio7K7wq49Uh6G1ygbQ52gqcig+FiSOCKsyTCVzvJ+t7gBZzVMUbYpUiH/RIduqz
         6hDK0KRewIfX4NrA20AZ4BJX8TvN9M6LoAt6zf6hRlOWvHEKPv20Zqy4fv0YV0w9IaOH
         9g//wvTYAmBMwilobAkvmQTMBFPTLiYZR+ehs9f0NnfAm+jZrjFg2Y6Vy2pAmIwVhEa9
         GZsiBUJiKK/YtMWlkhu33lj1J9PJD6y0mY4LNNNXJ9F2a/VSN+WyifvKWcVBfq06dea2
         ixttCQcfztv8FDuFBc7H8d2y+dm/sbxvKUG1MbCePLqyOZD9k8PWswwxe49j++WrDOZg
         zwVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=osRy1FbXLS8WJ/jwgsa84l1vv7LffAWp2JoJMu+h49k=;
        b=bR9YBntLIY+C0VyHHsFbQa4FV2jKKIsIn/R5xfQCe4C/S9jvypHjCdc/8f7n5AhIEQ
         gHfk3ZlcZEUd31M3kX9pJzBUGIEPFNwPKoWdHxBk3VXTHPGRRUEn8JnXhaV/GGs7zatf
         /u0BnUiKlqIahw1i8wrs53ozwTAvtPo4uu+bNE2OyUN++opiEYMthtTEU/gLaImMWZYR
         wOzQuiReJx4eLH95bKKrs8tVFw/7KNJrGb5txvzBp8qmDBd5x5JVf02O8F4ZxOI31dTR
         j7zIiqVQqa8QhzX2V4HTWQEp1S8PNEJTVbEPEC1O3PqUJ9hpDo2UIhBDZ2Nb4zb+9Tz5
         EBww==
X-Gm-Message-State: AOAM5307OBfrlwsrTZH2THyrUkzfFoK0UZIjVSrc49TQMWOBVPXOxBtk
        y0SkNVwIjEbLHNkNs9HzuvZ5uMdYFS4c+6WgHsQ=
X-Google-Smtp-Source: ABdhPJwHjlL6dJ9KdUOqH6c6q218o2/VCOMdoVR4575eCpBuOUcc+4Ty+kpbUf3rotn8u+xvCAtcSQ==
X-Received: by 2002:a1c:8085:: with SMTP id b127mr8681104wmd.142.1605877247808;
        Fri, 20 Nov 2020 05:00:47 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id b8sm4074238wmj.9.2020.11.20.05.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 05:00:47 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 4/5] selftests/bpf: xsk selftests - Socket Teardown - SKB, DRV
Date:   Fri, 20 Nov 2020 13:00:25 +0000
Message-Id: <20201120130026.19029-5-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds following tests:

1. AF_XDP SKB mode
   c. Socket Teardown
      Create a Tx and a Rx socket, Tx from one socket, Rx on another.
      Destroy both sockets, then repeat multiple times. Only nopoll mode
      is used

2. AF_XDP DRV/Native mode
   c. Socket Teardown
   * Only copy mode is supported because veth does not currently support
     zero-copy mode

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/bpf/Makefile          |  4 ++-
 .../selftests/bpf/test_xsk_drv_poll.sh        |  3 --
 .../selftests/bpf/test_xsk_drv_teardown.sh    | 23 ++++++++++++
 .../selftests/bpf/test_xsk_skb_teardown.sh    | 20 +++++++++++
 tools/testing/selftests/bpf/xdpxceiver.c      | 35 ++++++++++++++++---
 tools/testing/selftests/bpf/xdpxceiver.h      |  2 ++
 6 files changed, 79 insertions(+), 8 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_teardown.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_teardown.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 9dd3f3b9014f..515b29d321d7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -76,7 +76,9 @@ TEST_PROGS := test_kmod.sh \
 	test_xsk_skb_nopoll.sh \
 	test_xsk_skb_poll.sh \
 	test_xsk_drv_nopoll.sh \
-	test_xsk_drv_poll.sh
+	test_xsk_drv_poll.sh \
+	test_xsk_skb_teardown.sh \
+	test_xsk_drv_teardown.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
diff --git a/tools/testing/selftests/bpf/test_xsk_drv_poll.sh b/tools/testing/selftests/bpf/test_xsk_drv_poll.sh
index 1fe488d5794a..46e0ae0cabed 100755
--- a/tools/testing/selftests/bpf/test_xsk_drv_poll.sh
+++ b/tools/testing/selftests/bpf/test_xsk_drv_poll.sh
@@ -17,7 +17,4 @@ execxdpxceiver params
 retval=$?
 test_status $retval "${TEST_NAME}"
 
-# Must be called in the last test to execute
-cleanup_exit ${VETH0} ${VETH1} ${NS1}
-
 test_exit $retval 0
diff --git a/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh b/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh
new file mode 100755
index 000000000000..28bf730b589e
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh
@@ -0,0 +1,23 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+# See test_xsk_prerequisites.sh for detailed information on tests
+
+. xsk_prereqs.sh
+. xsk_env.sh
+
+TEST_NAME="DRV SOCKET TEARDOWN"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-T")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+# Must be called in the last test to execute
+cleanup_exit ${VETH0} ${VETH1} ${NS1}
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/bpf/test_xsk_skb_teardown.sh b/tools/testing/selftests/bpf/test_xsk_skb_teardown.sh
new file mode 100755
index 000000000000..3ceda125647b
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xsk_skb_teardown.sh
@@ -0,0 +1,20 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+# See test_xsk_prerequisites.sh for detailed information on tests
+
+. xsk_prereqs.sh
+. xsk_env.sh
+
+TEST_NAME="SKB SOCKET TEARDOWN"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "-T")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index e998200502de..ba5de1ef9f64 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -26,6 +26,9 @@
  *    generic XDP path. XDP hook from netif_receive_skb().
  *    a. nopoll - soft-irq processing
  *    b. poll - using poll() syscall
+ *    c. Socket Teardown
+ *       Create a Tx and a Rx socket, Tx from one socket, Rx on another. Destroy
+ *       both sockets, then repeat multiple times. Only nopoll mode is used
  *
  * 2. AF_XDP DRV/Native mode
  *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -33,10 +36,11 @@
  *    hook available just after DMA of buffer descriptor.
  *    a. nopoll
  *    b. poll
+ *    c. Socket Teardown
  *    - Only copy mode is supported because veth does not currently support
  *      zero-copy mode
  *
- * Total tests: 4
+ * Total tests: 6
  *
  * Flow:
  * -----
@@ -96,7 +100,8 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
+	(ksft_test_result_pass("PASS: %s %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
+			       "NOPOLL", opt_teardown ? "Socket Teardown" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -321,6 +326,7 @@ static struct option long_options[] = {
 	{"xdp-skb", no_argument, 0, 'S'},
 	{"xdp-native", no_argument, 0, 'N'},
 	{"copy", no_argument, 0, 'c'},
+	{"tear-down", no_argument, 0, 'T'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
 	{0, 0, 0, 0}
@@ -337,6 +343,7 @@ static void usage(const char *prog)
 	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
 	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
 	    "  -c, --copy           Force copy mode\n"
+	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
 	ksft_print_msg(str, prog);
@@ -427,7 +434,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTDC:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -465,6 +472,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'c':
 			opt_xdp_bind_flags |= XDP_COPY;
 			break;
+		case 'T':
+			opt_teardown = 1;
+			break;
 		case 'D':
 			debug_pkt_dump = 1;
 			break;
@@ -853,6 +863,9 @@ static void *worker_testapp_validate(void *arg)
 
 		ksft_print_msg("Received %d packets on interface %s\n",
 			       pkt_counter, ((struct ifobject *)arg)->ifname);
+
+		if (opt_teardown)
+			ksft_print_msg("Destroying socket\n");
 	}
 
 	xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
@@ -898,6 +911,20 @@ static void testapp_validate(void)
 		free(pkt_buf);
 	}
 
+	if (!opt_teardown)
+		print_ksft_result();
+}
+
+static void testapp_sockets(void)
+{
+	for (int i = 0; i < MAX_TEARDOWN_ITER; i++) {
+		pkt_counter = 0;
+		prev_pkt = -1;
+		sigvar = 0;
+		ksft_print_msg("Creating socket\n");
+		testapp_validate();
+	}
+
 	print_ksft_result();
 }
 
@@ -964,7 +991,7 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(1);
 
-	testapp_validate();
+	opt_teardown ? testapp_sockets() : testapp_validate();
 
 	for (int i = 0; i < MAX_INTERFACES; i++)
 		free(ifdict[i]);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index dba47e818466..9d2670f28d86 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -21,6 +21,7 @@
 #define MAX_INTERFACE_NAME_CHARS 7
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
 #define MAX_SOCKS 1
+#define MAX_TEARDOWN_ITER 10
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
 			sizeof(struct udphdr))
 #define MIN_PKT_SIZE 64
@@ -55,6 +56,7 @@ static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int opt_queue;
 static int opt_pkt_count;
 static int opt_poll;
+static int opt_teardown;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
-- 
2.20.1

