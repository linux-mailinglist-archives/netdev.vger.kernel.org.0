Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15794D39E3
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237387AbiCITUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbiCITSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:18:25 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BC3144F5C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646853421; x=1678389421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HffHS+tgBcL14P63jBK+oadn/ULE2EtUEq4i5AhLI38=;
  b=RuhWOt5z9S+/fNEL4yWKvF2PSBdP9LZ26H1C0TvsKWVFovwwHKCXaxzg
   hVSquAkKLqktyGVmQ0+iOklUWaJVEnql/J+44rrwCvDrtqA1+AS5aPWHJ
   kPUBYtgkIaN/V7/iyy4fqS2BDoTp7cQA/zWj17R6znpR1qfSbVlIXaACd
   5sx+qbw8dk7R5Q2Uqn2/Ik0K8FibB8gviqc2CxdLge8ixdDxAN/j1Yolc
   jq631laWFThNnRfsxlWgOxAbmYraGJew8dSKTOZVmwDSy8vYbmUH6zMRD
   HEXesLjWpdNA/lGSkToP1CgEdMvW23HXs5l7VccQuxuJbXQxQhOIhsl0M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237235266"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="237235266"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="495957056"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.194.198])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/10] selftests: mptcp: join: reset failing links
Date:   Wed,  9 Mar 2022 11:16:29 -0800
Message-Id: <20220309191636.258232-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309191636.258232-1-mathew.j.martineau@linux.intel.com>
References: <20220309191636.258232-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Best to always reset this env var before each test to avoid surprising
behaviour depending on the order tests are running.

Also clearly set it for the last failing links test is also needed when
only this test is executed.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 8dc50b480152..65590f965e4d 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -23,6 +23,8 @@ declare -A all_tests
 TEST_COUNT=0
 nr_blank=40
 
+export FAILING_LINKS=""
+
 # generated using "nfbpf_compile '(ip && (ip[54] & 0xf0) == 0x30) ||
 #				  (ip6 && (ip6[74] & 0xf0) == 0x30)'"
 CBPF_MPTCP_SUBOPTION_ADD_ADDR="14,
@@ -63,6 +65,7 @@ init_partial()
 
 	check_invert=0
 	validate_checksum=$checksum
+	FAILING_LINKS=""
 
 	#  ns1              ns2
 	# ns1eth1    ns2eth1
@@ -1618,7 +1621,7 @@ link_failure_tests()
 	pm_nl_set_limits $ns1 0 2
 	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
 	pm_nl_set_limits $ns2 1 2
-	export FAILING_LINKS="1"
+	FAILING_LINKS="1"
 	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 1
 	chk_join_nr "backup subflow unused, link failure" 2 2 2
@@ -1633,7 +1636,7 @@ link_failure_tests()
 	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
 	pm_nl_set_limits $ns2 1 2
 	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
-	export FAILING_LINKS="1 2"
+	FAILING_LINKS="1 2"
 	run_tests $ns1 $ns2 10.0.1.1 1
 	chk_join_nr "backup flow used, multi links fail" 2 2 2
 	chk_add_nr 1 1
@@ -1648,6 +1651,7 @@ link_failure_tests()
 	pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
 	pm_nl_set_limits $ns2 1 3
 	pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
+	FAILING_LINKS="1 2"
 	run_tests $ns1 $ns2 10.0.1.1 2
 	chk_join_nr "backup flow used, bidi, link failure" 2 2 2
 	chk_add_nr 1 1
-- 
2.35.1

