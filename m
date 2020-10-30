Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722642A0525
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgJ3MOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgJ3MOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:14:39 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59715C0613D5;
        Fri, 30 Oct 2020 05:14:39 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id b8so6256986wrn.0;
        Fri, 30 Oct 2020 05:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S7+2YlYexcf1AU0qOsB2/bovpOihknJOQtAdl1enaOE=;
        b=tLf3hXPnutrvK8FKC/fGQhfazCRZY9Yoo2HYgJoHng4lZYn+vq5hU3c5uyWuH7t1ke
         gZopjwQf+JzBzsVvyjBGXiqTi7/7cCpQDG2wNMEfm5PlsstRBhdY7TSDRBoJcvbuTTvW
         0N+EOxHQ2fwfI1wDd5WHTZuqYP7Z64pyPUWMlq9k0ckgS7bCnXcxQKx5oUFawIBlpUsi
         E3QiiN+h3LW9cwbeNiqOUDcoo4U8qB5H7NtPlTO3ZKsI8DMprdPK1fj5eDXGvjQMGiH5
         xA5SMUz5R9RaxFDD8LZN1eQidnSGfSHUoAz28a4fe45UqNbAxXp4HegbPYnkeW1YZItT
         CKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S7+2YlYexcf1AU0qOsB2/bovpOihknJOQtAdl1enaOE=;
        b=HX98gajNZd4duJfBBs14MfDfYzG+zMWP5YMFRXYBYjJgZNVhVlTZ99iy+QittfJgwe
         JMHQqZWyfL8/Sci0mSo7GdbapugPc1urpwGFO+hrh7j9Mpj009wEGO1XaY/ylxzLGD2/
         r9oSgB6W+kNYWbkLwd2L4XnPFB7hFQrB3bQ6GCd0aFduUkqriEuiCwiXpskUNwYcuTjO
         A3JKDSiTmcs8fFMZDivtfc3ej8vUU3Ly+MTC9JzUPSmPxQz7fDcVIFIZcrx9e314h3G/
         Tjuc9/o1LKm/mVS36vViip7VtacU5f3Id6xdZtLzPtJuiwWG5Oic2DYtixz3FfhvauWM
         pXDQ==
X-Gm-Message-State: AOAM530gRqeGadkL7OP26d/rqcbAPsHnFtgUxL64NwGSX/9nwhKiA4Or
        auEXD08h24aTWlM7lRcqgcIOgW2fQLbY3XcPzHk=
X-Google-Smtp-Source: ABdhPJyvJFaeJthNQ00vU1zaOK/Th+z0uytT8g0oCH+iUP9IXyluxv5WOfuwDEI1GXhiJ462flE3DA==
X-Received: by 2002:adf:9361:: with SMTP id 88mr2658680wro.37.1604060077431;
        Fri, 30 Oct 2020 05:14:37 -0700 (PDT)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id 90sm10020925wrh.35.2020.10.30.05.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 05:14:36 -0700 (PDT)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 3/5] selftests/xsk: xsk selftests - DRV POLL, NOPOLL
Date:   Fri, 30 Oct 2020 12:13:45 +0000
Message-Id: <20201030121347.26984-4-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
References: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds following tests:

2. AF_XDP DRV/Native mode
   Works on any netdevice with XDP_REDIRECT support, driver dependent.
   Processes packets before SKB allocation. Provides better performance
   than SKB. Driver hook available just after DMA of buffer descriptor.
   a. nopoll
   b. poll
   * Only copy mode is supported because veth does not currently support
     zero-copy mode

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/xsk/Makefile          |  4 +++-
 tools/testing/selftests/xsk/README            | 11 +++++++++-
 .../selftests/xsk/TEST_XSK_DRV_NOPOLL.sh      | 18 ++++++++++++++++
 .../selftests/xsk/TEST_XSK_DRV_POLL.sh        | 21 +++++++++++++++++++
 .../selftests/xsk/TEST_XSK_SKB_POLL.sh        |  3 ---
 .../selftests/xsk/xdpprogs/xdpxceiver.c       | 11 ++++++++--
 .../selftests/xsk/xdpprogs/xdpxceiver.h       |  1 +
 7 files changed, 62 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_DRV_NOPOLL.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK_DRV_POLL.sh

diff --git a/tools/testing/selftests/xsk/Makefile b/tools/testing/selftests/xsk/Makefile
index 63008cd90ab6..472d8975fa5a 100644
--- a/tools/testing/selftests/xsk/Makefile
+++ b/tools/testing/selftests/xsk/Makefile
@@ -8,7 +8,9 @@ XSKOBJ := xdpxceiver
 
 TEST_PROGS := TEST_PREREQUISITES.sh \
 	TEST_XSK_SKB_NOPOLL.sh \
-	TEST_XSK_SKB_POLL.sh
+	TEST_XSK_SKB_POLL.sh \
+	TEST_XSK_DRV_NOPOLL.sh \
+	TEST_XSK_DRV_POLL.sh
 TEST_FILES := prereqs.sh xskenv.sh
 TEST_TRANSIENT_FILES := veth.spec
 TEST_PROGS_EXTENDED := $(XSKDIR)/$(XSKOBJ)
diff --git a/tools/testing/selftests/xsk/README b/tools/testing/selftests/xsk/README
index db507a0057c1..0088c136a0d1 100644
--- a/tools/testing/selftests/xsk/README
+++ b/tools/testing/selftests/xsk/README
@@ -64,7 +64,16 @@ The following tests are run:
    a. nopoll - soft-irq processing
    b. poll - using poll() syscall
 
-Total tests: 2.
+2. AF_XDP DRV/Native mode
+   Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
+   packets before SKB allocation. Provides better performance than SKB. Driver
+   hook available just after DMA of buffer descriptor.
+   a. nopoll
+   b. poll
+   * Only copy mode is supported because veth does not currently support
+     zero-copy mode
+
+Total tests: 4.
 
 Flow:
 * Single process spawns two threads: Tx and Rx
diff --git a/tools/testing/selftests/xsk/TEST_XSK_DRV_NOPOLL.sh b/tools/testing/selftests/xsk/TEST_XSK_DRV_NOPOLL.sh
new file mode 100755
index 000000000000..420f33ad6d14
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_XSK_DRV_NOPOLL.sh
@@ -0,0 +1,18 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. prereqs.sh
+. xskenv.sh
+
+TEST_NAME="DRV NOPOLL"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/xsk/TEST_XSK_DRV_POLL.sh b/tools/testing/selftests/xsk/TEST_XSK_DRV_POLL.sh
new file mode 100755
index 000000000000..05e6c0372074
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_XSK_DRV_POLL.sh
@@ -0,0 +1,21 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. prereqs.sh
+. xskenv.sh
+
+TEST_NAME="DRV POLL"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-p")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+# Must be called in the last test to execute
+cleanup_exit ${VETH0} ${VETH1} ${NS1}
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/xsk/TEST_XSK_SKB_POLL.sh b/tools/testing/selftests/xsk/TEST_XSK_SKB_POLL.sh
index 4d314ed72cd8..a06582855d6e 100755
--- a/tools/testing/selftests/xsk/TEST_XSK_SKB_POLL.sh
+++ b/tools/testing/selftests/xsk/TEST_XSK_SKB_POLL.sh
@@ -15,7 +15,4 @@ execxdpxceiver params
 retval=$?
 test_status $retval "${TEST_NAME}"
 
-# Must be called in the last test to execute
-cleanup_exit ${VETH0} ${VETH1} ${NS1}
-
 test_exit $retval 0
diff --git a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
index 9855a3b33fae..777f839bbd3a 100644
--- a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
+++ b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.c
@@ -49,7 +49,7 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s\n", uut ? "" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
+	(ksft_test_result_pass("PASS: %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
 
 static void pthread_init_mutex(void)
 {
@@ -272,6 +272,7 @@ static struct option long_options[] = {
 	{"queue", optional_argument, 0, 'q'},
 	{"poll", no_argument, 0, 'p'},
 	{"xdp-skb", no_argument, 0, 'S'},
+	{"xdp-native", no_argument, 0, 'N'},
 	{"copy", no_argument, 0, 'c'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
@@ -287,6 +288,7 @@ static void usage(const char *prog)
 	    "  -q, --queue=n        Use queue n (default 0)\n"
 	    "  -p, --poll           Use poll syscall\n"
 	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
+	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
 	    "  -c, --copy           Force copy mode\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
@@ -378,7 +380,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pScDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcDC:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -408,6 +410,11 @@ static void parse_command_line(int argc, char **argv)
 			opt_xdp_bind_flags |= XDP_COPY;
 			uut = ORDER_CONTENT_VALIDATE_XDP_SKB;
 			break;
+		case 'N':
+			opt_xdp_flags |= XDP_FLAGS_DRV_MODE;
+			opt_xdp_bind_flags |= XDP_COPY;
+			uut = ORDER_CONTENT_VALIDATE_XDP_DRV;
+			break;
 		case 'c':
 			opt_xdp_bind_flags |= XDP_COPY;
 			break;
diff --git a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
index 385a01ab04c0..91ddc01836c9 100644
--- a/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
+++ b/tools/testing/selftests/xsk/xdpprogs/xdpxceiver.h
@@ -45,6 +45,7 @@ typedef __u8 u8;
 
 enum TESTS {
 	ORDER_CONTENT_VALIDATE_XDP_SKB = 0,
+	ORDER_CONTENT_VALIDATE_XDP_DRV = 1,
 };
 
 u8 uut;
-- 
2.20.1

