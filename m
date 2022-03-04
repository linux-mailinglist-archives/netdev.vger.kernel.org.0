Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677014CDEAD
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiCDUFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiCDUEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:04:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40AE2FD3DD
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423984; x=1677959984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qpWcgTy9FY6xxmHVlOf7EsIb68lZRNZlVMoMSI/G4m8=;
  b=RBEOfJGckLSaJTc0P+kCKf8hjGRKZ81F0k/0KZ+M+AA3I2G+owrZnxfv
   CyZtZg74yFCZjU+tRnp8U+m7riFN9OyCqXtOI04iNjdhnf4r2d+nBX4/g
   gWmyFHv/UuEZN39UwR5QhgKrRMgHCDX+LIsG4Kxsu3Ji5J0BJIoFOaT9X
   kxoqqekIat/g1lEIFTGJ/0s6yKGD2IGctWcUOSo6y23VBUXH1at1P6PpM
   CDBLH8vbaDsd+44NygWD/TdEfLbBs42hQfaxu90Gq1XDuYwO47s/3CCuy
   TtN7sOvxEsS0NLz1WVmgejtWf0ma0wxGe23eptAWgQqiEinp9Ch265lmq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981336"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981336"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340790"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/11] selftests: mptcp: reuse linkfail to make given size files
Date:   Fri,  4 Mar 2022 11:36:32 -0800
Message-Id: <20220304193636.219315-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
References: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch reused the test_linkfail values above 2 to make test files with
the given sizes (KB) for both the client side and the server side. It's
useful for the test cases using different file sizes.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 32 ++++++++++++++++---
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 84c21282ee46..1fda29d5d69f 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -459,7 +459,7 @@ do_transfer()
 		local_addr="0.0.0.0"
 	fi
 
-	if [ "$test_link_fail" -eq 2 ];then
+	if [ "$test_link_fail" -gt 1 ];then
 		timeout ${timeout_test} \
 			ip netns exec ${listener_ns} \
 				./mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
@@ -479,13 +479,19 @@ do_transfer()
 			ip netns exec ${connector_ns} \
 				./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
 					$extra_args $connect_addr < "$cin" > "$cout" &
-	else
+	elif [ "$test_link_fail" -eq 1 ] || [ "$test_link_fail" -eq 2 ];then
 		( cat "$cinfail" ; sleep 2; link_failure $listener_ns ; cat "$cinfail" ) | \
 			tee "$cinsent" | \
 			timeout ${timeout_test} \
 				ip netns exec ${connector_ns} \
 					./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
 						$extra_args $connect_addr > "$cout" &
+	else
+		cat "$cinfail" | tee "$cinsent" | \
+			timeout ${timeout_test} \
+				ip netns exec ${connector_ns} \
+					./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
+						$extra_args $connect_addr > "$cout" &
 	fi
 	cpid=$!
 
@@ -645,7 +651,7 @@ do_transfer()
 		return 1
 	fi
 
-	if [ "$test_link_fail" -eq 2 ];then
+	if [ "$test_link_fail" -gt 1 ];then
 		check_transfer $sinfail $cout "file received by client"
 	else
 		check_transfer $sin $cout "file received by client"
@@ -690,9 +696,18 @@ run_tests()
 	speed="${7:-fast}"
 	sflags="${8:-""}"
 
+	# The values above 2 are reused to make test files
+	# with the given sizes (KB)
+	if [ "$test_linkfail" -gt 2 ]; then
+		size=$test_linkfail
+
+		if [ -z "$cinfail" ]; then
+			cinfail=$(mktemp)
+		fi
+		make_file "$cinfail" "client" $size
 	# create the input file for the failure test when
 	# the first failure test run
-	if [ "$test_linkfail" -ne 0 -a -z "$cinfail" ]; then
+	elif [ "$test_linkfail" -ne 0 -a -z "$cinfail" ]; then
 		# the client file must be considerably larger
 		# of the maximum expected cwin value, or the
 		# link utilization will be not predicable
@@ -705,7 +720,14 @@ run_tests()
 		make_file "$cinfail" "client" $size
 	fi
 
-	if [ "$test_linkfail" -eq 2 -a -z "$sinfail" ]; then
+	if [ "$test_linkfail" -gt 2 ]; then
+		size=$test_linkfail
+
+		if [ -z "$sinfail" ]; then
+			sinfail=$(mktemp)
+		fi
+		make_file "$sinfail" "server" $size
+	elif [ "$test_linkfail" -eq 2 -a -z "$sinfail" ]; then
 		size=$((RANDOM%16))
 		size=$((size+1))
 		size=$((size*2048))
-- 
2.35.1

