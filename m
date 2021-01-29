Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4251E308317
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhA2BPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:15:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:6819 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231855AbhA2BO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:14:59 -0500
IronPort-SDR: zVHgq/UTJazEGDkX0ws6kda1eOPxM5zaG/NnqKILRvqURxMpU/XSCN2F4Ez9AO1adYCkgfePXI
 u9RE/Y+1eDDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430170"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430170"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
IronPort-SDR: NpV9TyeV8l9OrUAIk5581//EuhXsb7gFCY61lyZLScFepjQ9cRGGfRvx4f07+qB9u4Tw4z+Dq4
 4Yk6Rkrvj3jQ==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538329"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/16] selftests: mptcp: use minus values for removing address numbers
Date:   Thu, 28 Jan 2021 17:11:04 -0800
Message-Id: <20210129011115.133953-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch changes the removing addresses numbers to minus values, left
the plus values for the adding addresses numbers.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 32 ++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index be34b9ccbd20..e5fb2b01f31c 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -209,8 +209,8 @@ do_transfer()
 	srv_proto="$4"
 	connect_addr="$5"
 	test_link_fail="$6"
-	rm_nr_ns1="$7"
-	rm_nr_ns2="$8"
+	addr_nr_ns1="$7"
+	addr_nr_ns2="$8"
 	speed="$9"
 	bkup="${10}"
 
@@ -264,7 +264,8 @@ do_transfer()
 	fi
 	cpid=$!
 
-	if [ $rm_nr_ns1 -gt 0 ]; then
+	if [ $addr_nr_ns1 -lt 0 ]; then
+		let rm_nr_ns1=-addr_nr_ns1
 		if [ $rm_nr_ns1 -lt 8 ]; then
 			counter=1
 			sleep 1
@@ -281,7 +282,8 @@ do_transfer()
 		fi
 	fi
 
-	if [ $rm_nr_ns2 -gt 0 ]; then
+	if [ $addr_nr_ns2 -lt 0 ]; then
+		let rm_nr_ns2=-addr_nr_ns2
 		if [ $rm_nr_ns2 -lt 8 ]; then
 			counter=1
 			sleep 1
@@ -368,8 +370,8 @@ run_tests()
 	connector_ns="$2"
 	connect_addr="$3"
 	test_linkfail="${4:-0}"
-	rm_nr_ns1="${5:-0}"
-	rm_nr_ns2="${6:-0}"
+	addr_nr_ns1="${5:-0}"
+	addr_nr_ns2="${6:-0}"
 	speed="${7:-fast}"
 	bkup="${8:-""}"
 	lret=0
@@ -386,7 +388,7 @@ run_tests()
 	fi
 
 	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} \
-		${test_linkfail} ${rm_nr_ns1} ${rm_nr_ns2} ${speed} ${bkup}
+		${test_linkfail} ${addr_nr_ns1} ${addr_nr_ns2} ${speed} ${bkup}
 	lret=$?
 
 	if [ "$test_linkfail" -eq 1 ];then
@@ -677,7 +679,7 @@ reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 ip netns exec $ns2 ./pm_nl_ctl limits 0 1
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow
+run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
 chk_join_nr "remove single subflow" 1 1 1
 chk_rm_nr 1 1
 
@@ -687,7 +689,7 @@ ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 ip netns exec $ns2 ./pm_nl_ctl limits 0 2
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 0 2 slow
+run_tests $ns1 $ns2 10.0.1.1 0 0 -2 slow
 chk_join_nr "remove multiple subflows" 2 2 2
 chk_rm_nr 2 2
 
@@ -696,7 +698,7 @@ reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
+run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
 chk_join_nr "remove single address" 1 1 1
 chk_add_nr 1 1
 chk_rm_nr 0 0
@@ -707,7 +709,7 @@ ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 2
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 1 1 slow
+run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
 chk_join_nr "remove subflow and signal" 2 2 2
 chk_add_nr 1 1
 chk_rm_nr 1 1
@@ -719,7 +721,7 @@ ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 3
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 1 2 slow
+run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
 chk_join_nr "remove subflows and signal" 3 3 3
 chk_add_nr 1 1
 chk_rm_nr 2 2
@@ -731,7 +733,7 @@ ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 3
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 8 8 slow
+run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 chk_join_nr "flush subflows and signal" 3 3 3
 chk_add_nr 1 1
 chk_rm_nr 2 2
@@ -774,7 +776,7 @@ reset
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_tests $ns1 $ns2 dead:beef:1::1 0 1 0 slow
+run_tests $ns1 $ns2 dead:beef:1::1 0 -1 0 slow
 chk_join_nr "remove single address IPv6" 1 1 1
 chk_add_nr 1 1
 chk_rm_nr 0 0
@@ -785,7 +787,7 @@ ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
 ip netns exec $ns2 ./pm_nl_ctl limits 1 2
 ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
-run_tests $ns1 $ns2 dead:beef:1::1 0 1 1 slow
+run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
 chk_join_nr "remove subflow and signal IPv6" 2 2 2
 chk_add_nr 1 1
 chk_rm_nr 1 1
-- 
2.30.0

