Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB27526EF1
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiENDAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 23:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiENC7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 22:59:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3D336AE2C
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 18:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652491730; x=1684027730;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v1FFDOLl/1CoYQYN6VQ020lcKIZK0JmY0EcIXIIcmg8=;
  b=O9q7jkaWcbdkB22gRJPBt0c1Uhi+ihf8M7LS1oCBgtEHjLBLnqnePpWi
   bYp/cxjx1Bd2L3tNX5U/AZw9AdKRqvJWL8QcwJFsug0kPUtxlK0NTm0Dr
   Uc4eCf4dhTFKU4pn0WNIEB5jw4daD9eEY0KUjPjDsSY+nihdDhijktUDL
   P7NWaQFBKUIyRSmWMNWtb3zY3SOjEowz3G7JxZbkUqIlfBZx/PyqfpG7d
   pgtlAQSHAk2FZ70OkHOwQotZVg9P1fKHjjZ3O9X/+zs97bSlFg+gZpIyF
   RZz5n7v2v+7dULngrFH79GQb3W550axq5jHktFdDTfXmJDBsUItBebv5F
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="257994306"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="257994306"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 17:21:20 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="625102781"
Received: from clakshma-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.160.121])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 17:21:20 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/3] mptcp: Updates for net-next
Date:   Fri, 13 May 2022 17:21:12 -0700
Message-Id: <20220514002115.725976-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three independent fixes/features from the MPTCP tree:

Patch 1 is a selftest workaround for older iproute2 packages.

Patch 2 removes superfluous locks that were added with recent MP_FAIL
patches.

Patch 3 adds support for the TCP_DEFER_ACCEPT sockopt.


Florian Westphal (1):
  mptcp: sockopt: add TCP_DEFER_ACCEPT support

Geliang Tang (1):
  selftests: mptcp: fix a mp_fail test warning

Paolo Abeni (1):
  Revert "mptcp: add data lock for sk timers"

 net/mptcp/protocol.c                            | 12 ------------
 net/mptcp/sockopt.c                             | 15 +++++++++++++++
 tools/testing/selftests/net/mptcp/mptcp_join.sh |  1 +
 3 files changed, 16 insertions(+), 12 deletions(-)


base-commit: 2c5f1536473b7530adefd09a25cf3fef2cfe01f2
-- 
2.36.1

