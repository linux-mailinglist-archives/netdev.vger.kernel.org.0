Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5445E4BAFFB
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiBRDDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:03:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbiBRDDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:03:34 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCB958E6A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645153398; x=1676689398;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/+fdgO+cd1J3Z+MrI8XeZw3LC+mXZz3iq8eO6M0LvQ4=;
  b=ZIWG4mGpInkyPVS9Y0qFvBwqWo+iyqGkyobMHV27/wGiv1eWxU2z3hfP
   b9j22sGIqso7lpdHwtlwJggR6vWDMDXWfcp99wpcstX0nNdiJecReraWj
   k6U6IB9LCCHVlrY7QAhYjbAm4x05rbUbr7QIT7zBHeuROA3cQBIqvK791
   SP85xghFrF3LJogUevOsTMRErt8Ebnirb9NZZtDDZ2htdrQDMDo5d7BsQ
   OiUDdMSxvEoYwhNflDEBG5wiy7ryrvcVR5RCFOu/mZtkJ8/2jzV0Qywe7
   7LmnAzh4vLKA7BrTY2K+Fc+0Bod/Gxj+BnGplr/Ffj4KIFXleNz6BgjpO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="250794591"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="250794591"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="635431885"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.101.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:17 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/7] mptcp: Selftest fine-tuning and cleanup
Date:   Thu, 17 Feb 2022 19:03:04 -0800
Message-Id: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
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

Patch 1 adjusts the mptcp selftest timeout to account for slow machines
running debug builds.

Patch 2 simplifies one test function.

Patches 3-6 do some cleanup, like deleting unused variables and avoiding
extra work when only printing usage information.

Patch 7 improves the checksum tests by utilizing existing checksum MIBs.

Geliang Tang (2):
  selftests: mptcp: simplify pm_nl_change_endpoint
  selftests: mptcp: add csum mib check for mptcp_connect

Matthieu Baerts (5):
  selftests: mptcp: increase timeout to 20 minutes
  selftests: mptcp: join: exit after usage()
  selftests: mptcp: join: remove unused vars
  selftests: mptcp: join: create tmp files only if needed
  selftests: mptcp: join: check for tools only if needed

 .../selftests/net/mptcp/mptcp_connect.sh      |  19 +++
 .../testing/selftests/net/mptcp/mptcp_join.sh | 130 +++++++++---------
 tools/testing/selftests/net/mptcp/settings    |   2 +-
 3 files changed, 85 insertions(+), 66 deletions(-)


base-commit: 2aed49da6c080cbb8e35a39886f513ff97e954b4
-- 
2.35.1

