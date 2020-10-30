Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E242A0526
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgJ3MOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgJ3MOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:14:40 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E58AC0613D2;
        Fri, 30 Oct 2020 05:14:40 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a9so6187216wrg.12;
        Fri, 30 Oct 2020 05:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YLrNmLdT2Zh37renO4KYI0eOM5fqnzOYxS5D/+rhIhw=;
        b=G9ZIiZNZEIIGkkadVQAoiLmaWAXObAKYxNCjl7YseJAsCRkqUspcnwTtZ8GtB+v9eo
         fHfb6Pk83IUwxtQNSn4dwFDQBg91eXgZT0cFuxWXhdtBjyIvOa/6erTS7wQ13McX5haf
         tJ2DCX5yM5C83MjWt99nqNNGXIdiiOwTySRyM2orjfFcJEnZr75gktu786+Gr/YiP8jU
         P3y45hMjGmEKGAEiZ5HsDJtAv9S7272hdE+y+MyUAFnfNFTx9eecuk4wXiobUNDfFLX8
         g7KJhuR69+SlbP+0117bDq2a96RA5uZaYGL6xuPsKAcT5tCjFILYZj824ZqaD9v/UQrB
         cFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YLrNmLdT2Zh37renO4KYI0eOM5fqnzOYxS5D/+rhIhw=;
        b=Ct8DLuf021izZAfv/pkt0hMZ9dG1fjOkycKZjdHZNrAchtj0wdYSv4UYM9ZMMzBesD
         T1qufVcFQlEZ4OWyT1qYMPz7jM/+98usvjd5EN1G+cnlVnn+bdp9X6knMLHaLlrZG4+B
         Y+VGw4CNrRWuUt4xT+mXeD5Z/HJhhhUbQRhhoyWvSAWw5UpXwhgW06smbFE0ldfHTvcX
         7SYPUjgyHSwsU8Dvi12o0nfWESyBrthVCaDlWbTe16lk/nZS5GUzFhGin+LWMXY7eEv6
         p6k5PD6bHET39+waBpEEZvKL0HhysaJ2PkNgIJ+655KQTZEWB6sXxuBKiqR0lL5FxVYw
         ux3Q==
X-Gm-Message-State: AOAM533LOTNzWTaDct2/IGoNCojDbCvTSDP86KWHoIzXEsL1nf89R7Py
        aeEQ0/o2hhZl7LqlboQcsJDEdvb9Q+2h1t14y1E=
X-Google-Smtp-Source: ABdhPJzYMYbLSiUVGCIO6VpAeIWkjk2FguRUUrdBx5qdkMHXcDw+2ZjxayP5BYMzKu8j2JZ3tnug7Q==
X-Received: by 2002:adf:e2c9:: with SMTP id d9mr2734853wrj.11.1604060078587;
        Fri, 30 Oct 2020 05:14:38 -0700 (PDT)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id 90sm10020925wrh.35.2020.10.30.05.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 05:14:38 -0700 (PDT)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 4/5] selftests/xsk: xsk selftests - Socket Teardown - SKB, DRV
Date:   Fri, 30 Oct 2020 12:13:46 +0000
Message-Id: <20201030121347.26984-5-weqaar.a.janjua@intel.com>
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
 tools/testing/selftests/xsk/Makefile          |  4 ++-
 tools/testing/selftests/xsk/README            |  6 +++-
 .../selftests/xsk/TEST_XSK_DRV_POLL.sh        |  3 --
 .../selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh    | 21 ++++++++++++++
 .../selftests/xsk/TEST_XSK_SKB_TEARDOWN.sh    | 18 ++++++++++++
 .../selftests/xsk/xdpprogs/xdpxceiver.c       | 29 +++++++++++++++++--
 .../selftests/xsk/xdpprogs/xdpxceiver.h       |  2 ++
 7 files changed, 75 insertions(+), 8 deletions(-)
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_SKB_TEARDOWN.sh

diff --git a/tools/testing/selftests/xsk/Makefile b/tools/testing/selftests/xsk/Makefile
index 472d8975fa5a..79d106b30922 100644
--- a/tools/testing/selftests/xsk/Makefile
+++ b/tools/testing/selftests/xsk/Makefile
@@ -10,7 +10,9 @@ TEST_PROGS := TEST_PREREQUISITES.sh \
 	TEST_XSK_SKB_NOPOLL.sh \
 	TEST_XSK_SKB_POLL.sh \
 	TEST_XSK_DRV_NOPOLL.sh \
-	TEST_XSK_DRV_POLL.sh
+	TEST_XSK_DRV_POLL.sh \
+	TEST_XSK_SKB_TEARDOWN.sh \
+	TEST_XSK_DRV_TEARDOWN.sh
 TEST_FILES := prereqs.sh xskenv.sh
 TEST_TRANSIENT_FILES := veth.spec
 TEST_PROGS_EXTENDED := $(XSKDIR)/$(XSKOBJ)
diff --git a/tools/testing/selftests/xsk/README b/tools/testing/selftests/xsk/README
index 0088c136a0d1..e2ae3c804bfb 100644
--- a/tools/testing/selftests/xsk/README
+++ b/tools/testing/selftests/xsk/README
@@ -63,6 +63,9 @@ The following tests are run:
    generic XDP path. XDP hook from netif_receive_skb().
    a. nopoll - soft-irq processing
    b. poll - using poll() syscall
+   c. Socket Teardown
+      Create a Tx and a Rx socket, Tx from one socket, Rx on another. Destroy
+      both sockets, then repeat multiple times. Only nopoll mode is used
 
 2. AF_XDP DRV/Native mode
    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -70,10 +73,11 @@ The following tests are run:
    hook available just after DMA of buffer descriptor.
    a. nopoll
    b. poll
+   c. Socket Teardown
    * Only copy mode is supported because veth does not currently support
      zero-copy mode
 
-Total tests: 4.
+Total tests: 6.
 
 Flow:
 * Single process spawns two threads: Tx and Rx
diff --git a/tools/testing/selftests/xsk/TEST_XSK_DRV_POLL.sh b/tools/testing/selftests/xsk/TEST_XSK_DRV_POLL.sh
index 05e6c0372074..fbad353f0000 100755
--- a/tools/testing/selftests/xsk/TEST_XSK_DRV_POLL.sh
+++ b/tools/testing/selftests/xsk/TEST_XSK_DRV_POLL.sh
@@ -15,7 +15,4 @@ execxdpxceiver params
 retval=$?
 test_status $retval "${TEST_NAME}"
 
-# Must be called in the last test to execute
-cleanup_exit ${VETH0} ${VETH1} ${NS1}
-
 test_exit $retval 0
diff --git a/tools/testing/selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh b/tools/testing/selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh
new file mode 100755
index 000000000000..1867f3c07d74
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_XSK_DRV_TEARDOWN.sh
@@ -0,0 +1,21 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. prereqs.sh
+. xskenv.sh
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
diff --git a/tools/testing/selftests/xsk/TEST_XSK_SKB_TEARDOWN.sh b/tools/testing/selftests/xsk/TEST_XSK_SKB_TEARDOWN.sh
new file mode 100755
index 000000000000..51be8f30163d
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_XSK_SKB_TEARDOWN.sh
@@ -0,0 +1,18 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. prereqs.sh
+. xskenv.sh
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
diff --git a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
index 777f839bbd3a..6877b59f4534 100644
--- a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
+++ b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
@@ -49,7 +49,8 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
+	(ksft_test_result_pass("PASS: %s %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
+			       "NOPOLL", opt_teardown ? "Socket Teardown" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -274,6 +275,7 @@ static struct option long_options[] = {
 	{"xdp-skb", no_argument, 0, 'S'},
 	{"xdp-native", no_argument, 0, 'N'},
 	{"copy", no_argument, 0, 'c'},
+	{"tear-down", no_argument, 0, 'T'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
 	{0, 0, 0, 0}
@@ -290,6 +292,7 @@ static void usage(const char *prog)
 	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
 	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
 	    "  -c, --copy           Force copy mode\n"
+	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
 	ksft_print_msg(str, prog);
@@ -380,7 +383,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTDC:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -418,6 +421,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'c':
 			opt_xdp_bind_flags |= XDP_COPY;
 			break;
+		case 'T':
+			opt_teardown = 1;
+			break;
 		case 'D':
 			debug_pkt_dump = 1;
 			break;
@@ -806,6 +812,9 @@ static void *worker_testapp_validate(void *arg)
 
 		ksft_print_msg("Received %d packets on interface %s\n",
 			       pkt_counter, ((struct ifobject *)arg)->ifname);
+
+		if (opt_teardown)
+			ksft_print_msg("Destroying socket\n");
 	}
 
 	xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
@@ -851,6 +860,20 @@ static void testapp_validate(void)
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
 
@@ -917,7 +940,7 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(1);
 
-	testapp_validate();
+	opt_teardown ? testapp_sockets() : testapp_validate();
 
 	for (int i = 0; i < MAX_INTERFACES; i++)
 		free(ifdict[i]);
diff --git a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
index 91ddc01836c9..41fc62adad3b 100644
--- a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
+++ b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
@@ -21,6 +21,7 @@
 #define MAX_INTERFACE_NAME_CHARS 7
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
 #define MAX_SOCKS 1
+#define MAX_TEARDOWN_ITER 10
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
 			sizeof(struct udphdr))
 #define MIN_PKT_SIZE 64
@@ -56,6 +57,7 @@ static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int opt_queue;
 static int opt_pkt_count;
 static int opt_poll;
+static int opt_teardown;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
-- 
2.20.1

