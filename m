Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AE935602A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhDGASh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:18:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:29199 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233858AbhDGASg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:18:36 -0400
IronPort-SDR: 2bb2HtBZABgm+JZ4S5yOEWYIGyGgbT3D1ONA9bQzv3xuZIUjCG6mgUVqvMnCFn0NIdX3YMvrdT
 hySOMgs0C6wQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="257170793"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="257170793"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:11 -0700
IronPort-SDR: PMtHpY18O+6SuqDS9FcGkKxT2UQfwONTAem1nVg1uafhHmVYi1rUe8eEJt/lxecG6NjaQSG4I6
 gyc0/k53HHxg==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="458105204"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.115.52])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:11 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/8] selftests: mptcp: add the net device name testcase
Date:   Tue,  6 Apr 2021 17:16:03 -0700
Message-Id: <20210407001604.85071-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
References: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new testcase for setting the net device name. In it,
pass the net device name to pm_nl_ctl to set the ifindex field of struct
mptcp_pm_addr_entry.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index abeb24b7f8ec..fd99485cf2a4 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -777,6 +777,14 @@ subflows_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "multiple subflows, limited by server" 2 2 1
+
+	# single subflow, dev
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow dev ns2eth3
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "single subflow, dev" 1 1 1
 }
 
 signal_address_tests()
-- 
2.31.1

