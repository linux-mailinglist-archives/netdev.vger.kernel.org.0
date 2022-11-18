Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0407862FCF2
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242557AbiKRSqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiKRSqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:46:15 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EA1617B
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668797174; x=1700333174;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NLcIs5XItOiEJ9H5WtVJylx2BC7kGSi6m5yYiqOJlQc=;
  b=lPbuHDeCp8kl46U6mR8rYLIddMQZYumruQqwwqQDYhdgtrGyvBWa+LRr
   U56o468nHmuE4NJtEXn38Y7CywvR1w1sO2b1y/CAzwSz0Y7/FJORtJ87b
   rn4tsdjuDp2Pj4kvOzpJBa/QCvlkxmGBZbPzQx9jkrp3VlQZ9W1CBBEcm
   xPX0xBfZOIkzW7Cso1XngGecb7dG/MxMsZvlLNbSqFfwtoJFV/888kPy3
   117WAjnRHYyCeJRK67EwbH/c49ahoUI36nTL8tu93s8cdMupORlopnPCD
   fPpInvbtv07MnM/Q45Evca4N8Vwfaxs0zblU4iTXcfdE88qV9IPdxuXdw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="375342839"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="375342839"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 10:46:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="746102224"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="746102224"
Received: from mjenkins-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.47.242])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 10:46:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/2] mptcp: More specific netlink command errors
Date:   Fri, 18 Nov 2022 10:46:06 -0800
Message-Id: <20221118184608.187932-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes the error reporting for the MPTCP_PM_CMD_ADD_ADDR netlink
command more specific, since there are multiple reasons the command could
fail.

Note that patch 2 adds a GENL_SET_ERR_MSG_FMT() macro to genetlink.h,
which is outside the MPTCP subsystem.


Patch 1 refactors in-kernel listening socket and endpoint creation to
simplify the second patch.

Patch 2 updates the error values returned by the in-kernel path manager
when it fails to create a local endpoint.


Paolo Abeni (2):
  mptcp: deduplicate error paths on endpoint creation
  mptcp: more detailed error reporting on endpoint creation

 include/net/genetlink.h |  3 +++
 net/mptcp/pm_netlink.c  | 59 ++++++++++++++++++-----------------------
 2 files changed, 29 insertions(+), 33 deletions(-)


base-commit: ab0377803dafc58f1e22296708c1c28e309414d6
-- 
2.38.1

