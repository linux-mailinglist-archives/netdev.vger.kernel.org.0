Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C044405F1
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 01:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhJ2X7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 19:59:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:55256 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhJ2X7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 19:59:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="230634269"
X-IronPort-AV: E=Sophos;i="5.87,194,1631602800"; 
   d="scan'208";a="230634269"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 16:56:44 -0700
X-IronPort-AV: E=Sophos;i="5.87,194,1631602800"; 
   d="scan'208";a="487759731"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.3.7])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 16:56:44 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, pabeni@redhat.com,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 1/2] selftests: mptcp: fix proto type in link_failure tests
Date:   Fri, 29 Oct 2021 16:55:58 -0700
Message-Id: <20211029235559.246858-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211029235559.246858-1-mathew.j.martineau@linux.intel.com>
References: <20211029235559.246858-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

In listener_ns, we should pass srv_proto argument to mptcp_connect command,
not cl_proto.

Fixes: 7d1e6f1639044 ("selftests: mptcp: add testcase for active-back")
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 293d349e21fe..7ef639a9d4a6 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -297,7 +297,7 @@ do_transfer()
 	if [ "$test_link_fail" -eq 2 ];then
 		timeout ${timeout_test} \
 			ip netns exec ${listener_ns} \
-				$mptcp_connect -t ${timeout_poll} -l -p $port -s ${cl_proto} \
+				$mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
 					${local_addr} < "$sinfail" > "$sout" &
 	else
 		timeout ${timeout_test} \
-- 
2.33.1

