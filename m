Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5131262ADD8
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiKOWK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKOWKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:10:52 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131E62FC2F
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 14:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668550252; x=1700086252;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YhR6LLfPRwRi7J/KilLJ/w6vqBuEr/5KVeEOxzYOcuw=;
  b=IzCbK1pSIQOKnlPwk3g0B7znc2keFMf3WVeLyvCAt0St3VfzQgOy+3dY
   XDwuPsiAsRIF0p5m3uOMF6ZG0YCckNvnJ4hnFMowPwh+Vj2UpfAcpF8D9
   6z+KEnbufl31hMZYq3VHSyZDZ4tVPCAIZKFqPt2/24AXD9whIG5xuT2Vu
   bRGD87iKuILATGsse2oWILOMMWu0AA7AphGWNM5QpdmHfSvJiseCe22Ua
   8Otm/kRxz+ezvvMHobxAdDqFLtr3iIQbcareFeU5P7CLxv3PKkbZXiiU0
   YJodaNQvLXBBEifEd3w8jtBWHEIo7BePcJOYTzt5/4mdAvD387fyoabEW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="299906711"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="299906711"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 14:10:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="616917986"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="616917986"
Received: from imunagan-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.21.103])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 14:10:51 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, geliang.tang@suse.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net 0/3] mptcp: selftests: Fix timeouts and test isolation
Date:   Tue, 15 Nov 2022 14:10:43 -0800
Message-Id: <20221115221046.20370-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches 1 and 3 adjust test timeouts to reduce false negatives on slow
machines.

Patch 2 improves test isolation by running the mptcp_sockopt test in its
own net namespace.

Matthieu Baerts (2):
  selftests: mptcp: run mptcp_sockopt from a new netns
  selftests: mptcp: fix mibit vs mbit mix up

Paolo Abeni (1):
  selftests: mptcp: gives slow test-case more time

 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 6 +++---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh | 9 +++++----
 tools/testing/selftests/net/mptcp/simult_flows.sh  | 5 +++--
 3 files changed, 11 insertions(+), 9 deletions(-)


base-commit: 9d45921ee4cb364910097e7d1b7558559c2f9fd2
-- 
2.38.1

