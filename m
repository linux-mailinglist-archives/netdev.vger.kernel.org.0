Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA5556C537
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbiGHXgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238449AbiGHXgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:36:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2047A606B2
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 16:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657323377; x=1688859377;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mLtbgDckIbKax2TRKG/sQfPD3NEQ0gRiAtYmyp8RjqY=;
  b=MQDmBMTjNN41x8QBSW7nXMrPvDm3ORbpRyQ6dsFZDrWA10XfuiN9fDVd
   Vm2+6NWtDElby0LX2omIB6qAJiqzdn/0uvFW975jG/qtYc4HijoxXZ380
   dQKbr2sfPZ5nLZsYwE/lAqZD0zk3zTLc7kI+/0jn3RuEokJGfk14ENdXh
   aEGcRh5D7XZX7usUnsf1ioGCAGKXMJFJ+BmrVVGDrsGwcsUyzvVPDkLG/
   bK44vIi1JbXbYHNflJYW4RPUEsP7kzix+2JMr18yt/CEk9ySLT3EabkCx
   Ylpm6xLgJhxlb2+A/ZELm6LzCwl9rT47mEutKcaawetnxuvbCwe5TSB5O
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="346071659"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="346071659"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 16:36:15 -0700
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="770933082"
Received: from aroras-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.203])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 16:36:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, kishen.maloor@intel.com,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/2] selftests: mptcp: validate userspace PM tests by default
Date:   Fri,  8 Jul 2022 16:36:10 -0700
Message-Id: <20220708233610.410786-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220708233610.410786-1-mathew.j.martineau@linux.intel.com>
References: <20220708233610.410786-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

The new script was not listed in the programs to test.

By consequence, some CIs running MPTCP selftests were not validating
these new tests. Note that MPTCP CI was validating it as it executes all
.sh scripts from 'tools/testing/selftests/net/mptcp' directory.

Fixes: 259a834fadda ("selftests: mptcp: functional tests for the userspace PM type")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/Makefile b/tools/testing/selftests/net/mptcp/Makefile
index f905d5358e68..48a99e1453e1 100644
--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -6,7 +6,7 @@ KSFT_KHDR_INSTALL := 1
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
 
 TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh \
-	      simult_flows.sh mptcp_sockopt.sh
+	      simult_flows.sh mptcp_sockopt.sh userspace_pm.sh
 
 TEST_GEN_FILES = mptcp_connect pm_nl_ctl mptcp_sockopt mptcp_inq
 
-- 
2.37.0

