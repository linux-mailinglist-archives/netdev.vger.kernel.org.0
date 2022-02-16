Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11174B7D33
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343550AbiBPCLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:11:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243539AbiBPCLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:11:51 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185C61EC5B
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644977500; x=1676513500;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pqnRaIFh1sSDvPWAjRsmzpIOXJT8CkRc4jB7kaQCavQ=;
  b=IbaE57vtRmYp56bHZ2frfvWO/kkFKugnxsy34pZCQfwtYlE0arnkZiCA
   eEJI6IqZasq0nJRdKEdpMXDUWQkHx0dWPUT0JUChEdfXG8BtxIEzs7yIQ
   4Qy55W15FHUMCeVvkX7v8V7sWU1SFtaWf5PSZ42BR68RrWy9DLQPzNZ0f
   YgA7zvNg76RPhMZa8OOqH8kxvwsA0h+9AOgtqKCGj5dT98GTEhnKDjNf0
   pzukDvBrJEjWhxk6uo7yhombieKI0Kl/65bZ9vOpt6yqq+ns7usVB1z2A
   UIvb4NZeeGHGdxmRQWr5GWPzKIGa6CURJFHePaHMJbaRBBfPgIcYzZaKs
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237909068"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="237909068"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="571088814"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/8] mptcp: SO_SNDTIMEO and misc. cleanup
Date:   Tue, 15 Feb 2022 18:11:22 -0800
Message-Id: <20220216021130.171786-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 adds support for the SO_SNDTIMEO socket option on MPTCP sockets.

The remaining patches are various small cleanups:

Patch 2 removes an obsolete declaration.

Patches 3 and 5 remove unnecessary function parameters.

Patch 4 removes an extra cast.

Patches 6 and 7 add some const and ro_after_init modifiers.

Patch 8 removes extra storage of TCP helpers.


Florian Westphal (2):
  mptcp: mark ops structures as ro_after_init
  mptcp: don't save tcp data_ready and write space callbacks

Geliang Tang (4):
  mptcp: add SNDTIMEO setsockopt support
  mptcp: drop unused sk in mptcp_get_options
  mptcp: drop unneeded type casts for hmac
  mptcp: drop port parameter of mptcp_pm_add_addr_signal

Matthieu Baerts (1):
  mptcp: mptcp_parse_option is no longer exported

Paolo Abeni (1):
  mptcp: constify a bunch of of helpers

 include/net/mptcp.h    |  6 ------
 net/mptcp/options.c    | 13 +++++--------
 net/mptcp/pm.c         | 11 ++++++-----
 net/mptcp/pm_netlink.c | 42 +++++++++++++++++++++---------------------
 net/mptcp/protocol.h   | 29 +++++++++++++----------------
 net/mptcp/sockopt.c    |  2 ++
 net/mptcp/subflow.c    | 37 +++++++++++++++++--------------------
 7 files changed, 64 insertions(+), 76 deletions(-)


base-commit: 2c955856da4faec3a36df1e85b3ba3dfe230d6fd
-- 
2.35.1

