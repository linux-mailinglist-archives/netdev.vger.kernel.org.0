Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809EA624E67
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiKJXXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiKJXXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:23:32 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9C712D18
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668122611; x=1699658611;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K5WFNYmzwEU6n6c2Iik7W5YdAFUW2w/26+1Z+wYlPJk=;
  b=fglNglDtTIA1fpZAZ6qHLTyU1fabDtY/Q8AO2uZvh/Cb93ryVu30tF++
   rAsM2dmSPZlIcT93YfUaYjZ4wp1B2BsIg0lvEC8/pDij0g9DupNbKeZr3
   Jm9q4HLetNpzNcG147FjunB06fB73uX6iWZ1dx3wDDM4+oKCL7FqNSpqu
   q6Pm1PD4uKyVOdKigr9hpMZTeDZuwy0pg7WflqOsBWxXWQtIaBW61uBa8
   xTN62Ojji+QPb1DUlOhfU92cLJCxwmkTRtleazzRpVP0pNjFQlKt9ud9H
   Hb8A/c1cHyhqmJ8gMN1KLpS8g+UAJqrM7W1soDLc7TOIvxeM4mxRV4OEB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="309093994"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="309093994"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="637367375"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="637367375"
Received: from jsandova-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.81.89])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:29 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/5] selftests: mptcp: use max_time instead of time
Date:   Thu, 10 Nov 2022 15:23:21 -0800
Message-Id: <20221110232322.125068-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
References: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

'time' is the local variable of run_test() function, while 'max_time' is
the local variable of do_transfer() function. So in do_transfer(),
$max_time should be used, not $time.

Please note that here $time == $max_time so the behaviour is not changed
but the right variable is used.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index ffa13a957a36..af70c14e0bf9 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -173,7 +173,7 @@ do_transfer()
 
 	timeout ${timeout_test} \
 		ip netns exec ${ns3} \
-			./mptcp_connect -jt ${timeout_poll} -l -p $port -T $time \
+			./mptcp_connect -jt ${timeout_poll} -l -p $port -T $max_time \
 				0.0.0.0 < "$sin" > "$sout" &
 	local spid=$!
 
@@ -181,7 +181,7 @@ do_transfer()
 
 	timeout ${timeout_test} \
 		ip netns exec ${ns1} \
-			./mptcp_connect -jt ${timeout_poll} -p $port -T $time \
+			./mptcp_connect -jt ${timeout_poll} -p $port -T $max_time \
 				10.0.3.3 < "$cin" > "$cout" &
 	local cpid=$!
 
-- 
2.38.1

