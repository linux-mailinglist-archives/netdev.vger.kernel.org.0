Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26A54C3A85
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 01:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbiBYAxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 19:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbiBYAxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 19:53:37 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1896E10BBF7
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 16:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645750387; x=1677286387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oKM2fvwOsoxNYiRY2TPnQn4Ts4UIqfnrnhTuR2TshaM=;
  b=MR7bAccaytiK4fIP9yDyym+ldWKJssXEZubWKcUcutorzZRvTMKmpsdB
   fgEizsKNHt3xKGuRob3m0WQ69Criehd8kEOxNnmgKoJa8NrzEsV2LjqhV
   4HeryUaA/oJILpbChKezgn/8iD7+lcdcZ1M5xe9rMizLGroIf+6CFUw1H
   rW4LTjKZuNZ2oRTzCL+i3GKPdOWwKXHzeWQh8IvPLQGg99QF/HpKzCpFQ
   y7yr4lq5wTN2l0G4ackgsy6yhtTwrgjXi3sWp5Tkonr0pOLoxEr9hRscf
   e3+dASRezGGjQGVkQgGjc/pflCEBmyggqtbwNyW2tnLXrrOpX6Vdl6bJx
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="313105744"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="313105744"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 16:53:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="638050200"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.28.67])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 16:53:05 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/3] selftests: mptcp: do complete cleanup at exit
Date:   Thu, 24 Feb 2022 16:52:58 -0800
Message-Id: <20220225005259.318898-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220225005259.318898-1-mathew.j.martineau@linux.intel.com>
References: <20220225005259.318898-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

After commit 05be5e273c84 ("selftests: mptcp: add disconnect tests")
the mptcp selftests leave behind a couple of tmp files after
each run. run_tests_disconnect() misnames a few variables used to
track them. Address the issue setting the appropriate global variables

Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index cb5809b89081..f0f4ab96b8f3 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -763,8 +763,8 @@ run_tests_disconnect()
 	run_tests_lo "$ns1" "$ns1" dead:beef:1::1 1 "-I 3 -i $old_cin"
 
 	# restore previous status
-	cout=$old_cout
-	cout_disconnect="$cout".disconnect
+	sin=$old_sin
+	sin_disconnect="$cout".disconnect
 	cin=$old_cin
 	cin_disconnect="$cin".disconnect
 	connect_per_transfer=1
-- 
2.35.1

