Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A48156A0F7
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiGGLQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiGGLQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:16:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D512C125;
        Thu,  7 Jul 2022 04:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657192588; x=1688728588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aQLC61ic/NAz6GOTSrDoQgoAxkJq71obwi5tOIlo96I=;
  b=StPOZZJORnRu4UNaYRuldazXZTnsp2FZfziQlqT4uBdH52ytziHlP6m0
   L9/A6vpkZ7lfQ5iRX5jwBF1ZpIItvESfFjC/qQIbvp2ZCV6mtxy+fVeWK
   Tj3RzFGK5Ry5sg2Yu1pXxU4WBSYU7K5erktQeXMIOWxmxR3YsJLEgsk4L
   Tqdj3XrdtAaJrjKwKklI8rpPbFYHTozV/+sGE5hg5cIuHoY6vXI1h8uIV
   sp7z+veH3xgKLl3UEGQnyd5ErA3dWosgwcPv/VtkdV1kCIRuLLiHwMIcm
   JDTMLqFmRLX0mIHFqcjAKlTTWHhjuAXdA0d1bQXzqXqh4hj9fUqNSOlDO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="309556179"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="309556179"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 04:16:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="543788244"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 07 Jul 2022 04:16:18 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 1/2] selftests: xsk: rename AF_XDP testing app
Date:   Thu,  7 Jul 2022 13:16:12 +0200
Message-Id: <20220707111613.49031-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220707111613.49031-1-maciej.fijalkowski@intel.com>
References: <20220707111613.49031-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently, xsk part of libbpf was moved to selftests/bpf directory and
lives on its own because there is an AF_XDP testing application that
needs it called xdpxceiver. That name makes it a bit hard to indicate
who maintains it as there are other XDP samples in there, whereas this
one is strictly about AF_XDP.

Do s/xdpxceiver/xskxceiver so that it will be easier to figure out who
maintains it. A follow-up patch will correct MAINTAINERS file.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/.gitignore                     | 2 +-
 tools/testing/selftests/bpf/Makefile                       | 4 ++--
 tools/testing/selftests/bpf/test_xsk.sh                    | 6 +++---
 tools/testing/selftests/bpf/xsk_prereqs.sh                 | 4 ++--
 tools/testing/selftests/bpf/{xdpxceiver.c => xskxceiver.c} | 4 ++--
 tools/testing/selftests/bpf/{xdpxceiver.h => xskxceiver.h} | 6 +++---
 6 files changed, 13 insertions(+), 13 deletions(-)
 rename tools/testing/selftests/bpf/{xdpxceiver.c => xskxceiver.c} (99%)
 rename tools/testing/selftests/bpf/{xdpxceiver.h => xskxceiver.h} (98%)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index ca2f47f45670..3a8cb2404ea6 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -41,6 +41,6 @@ test_cpp
 /bench
 *.ko
 *.tmp
-xdpxceiver
+xskxceiver
 xdp_redirect_multi
 xdp_synproxy
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e32a28fe8bc1..7ec53df97be7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -82,7 +82,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
-	xdpxceiver xdp_redirect_multi xdp_synproxy
+	xskxceiver xdp_redirect_multi xdp_synproxy
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 
@@ -231,7 +231,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
 $(OUTPUT)/test_maps: $(TESTING_HELPERS)
 $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
 $(OUTPUT)/xsk.o: $(BPFOBJ)
-$(OUTPUT)/xdpxceiver: $(OUTPUT)/xsk.o
+$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
 
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 567500299231..096a957594cd 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -47,7 +47,7 @@
 #       conflict with any existing interface
 #   * tests the veth and xsk layers of the topology
 #
-# See the source xdpxceiver.c for information on each test
+# See the source xskxceiver.c for information on each test
 #
 # Kernel configuration:
 # ---------------------
@@ -160,14 +160,14 @@ statusList=()
 
 TEST_NAME="XSK_SELFTESTS_SOFTIRQ"
 
-execxdpxceiver
+exec_xskxceiver
 
 cleanup_exit ${VETH0} ${VETH1} ${NS1}
 TEST_NAME="XSK_SELFTESTS_BUSY_POLL"
 busy_poll=1
 
 setup_vethPairs
-execxdpxceiver
+exec_xskxceiver
 
 ## END TESTS
 
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index 684e813803ec..a0b71723a818 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -8,7 +8,7 @@ ksft_xfail=2
 ksft_xpass=3
 ksft_skip=4
 
-XSKOBJ=xdpxceiver
+XSKOBJ=xskxceiver
 
 validate_root_exec()
 {
@@ -77,7 +77,7 @@ validate_ip_utility()
 	[ ! $(type -P ip) ] && { echo "'ip' not found. Skipping tests."; test_exit $ksft_skip; }
 }
 
-execxdpxceiver()
+exec_xskxceiver()
 {
         if [[ $busy_poll -eq 1 ]]; then
 	        ARGS+="-b "
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
similarity index 99%
rename from tools/testing/selftests/bpf/xdpxceiver.c
rename to tools/testing/selftests/bpf/xskxceiver.c
index 4c425a43e5b0..74d56d971baf 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -98,11 +98,11 @@
 #include <unistd.h>
 #include <stdatomic.h>
 #include "xsk.h"
-#include "xdpxceiver.h"
+#include "xskxceiver.h"
 #include "../kselftest.h"
 
 /* AF_XDP APIs were moved into libxdp and marked as deprecated in libbpf.
- * Until xdpxceiver is either moved or re-writed into libxdp, suppress
+ * Until xskxceiver is either moved or re-writed into libxdp, suppress
  * deprecation warnings in this file
  */
 #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
similarity index 98%
rename from tools/testing/selftests/bpf/xdpxceiver.h
rename to tools/testing/selftests/bpf/xskxceiver.h
index 8f672b0fe0e1..3d17053f98e5 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -2,8 +2,8 @@
  * Copyright(c) 2020 Intel Corporation.
  */
 
-#ifndef XDPXCEIVER_H_
-#define XDPXCEIVER_H_
+#ifndef XSKXCEIVER_H_
+#define XSKXCEIVER_H_
 
 #ifndef SOL_XDP
 #define SOL_XDP 283
@@ -169,4 +169,4 @@ pthread_cond_t pacing_cond = PTHREAD_COND_INITIALIZER;
 
 int pkts_in_flight;
 
-#endif				/* XDPXCEIVER_H */
+#endif				/* XSKXCEIVER_H_ */
-- 
2.27.0

