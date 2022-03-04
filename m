Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041874CDDDF
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiCDUDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiCDUDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:03:32 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC780244A16
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423925; x=1677959925;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7y/BxYMS9tI6XR3NRSpOEvF3gtB7W3YhNNHW2z4bOH4=;
  b=Mw9vVRo0dFACmF3Mpe6JOn9nt4HgvvSAKo7N+P68kCUhUoFcMSAvPnYy
   3PC09uJmWn0SjUqSo9PUCeIy9rPJwif6iNsItt+4PYUNAODup5Nn7Grct
   pSnNjLLhfHTW1/n2YTkOQPx/nsPQqQjsWizfkBVSlSQIG5Pv3YbCDeo8k
   C6eJtwN7kHIjbR1ci9xzMgcgoqvOBX1ul1vIkxGk9nvpuY11SFnTb7T9e
   pZlPnKfITvKN/ohjDV54kWLdsf3ctI1/1qffMTYb8sPOVlfG9oeYy4rgJ
   /TEF8UjbatASBVpJFbi0Z/7zm6fkmXPbQJcvMN7FRx22UwsVLsLZ3H+pm
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981329"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981329"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340774"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:42 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 00/11] mptcp: Selftest refinements and a new test
Date:   Fri,  4 Mar 2022 11:36:25 -0800
Message-Id: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches 1 and 11 improve the printed output of the mptcp_join.sh
selftest.

Patches 2-8 add a test for the MP_FASTCLOSE option, including
prerequisite changes like additional MPTCP MIBs.

Patches 9-10 add some groundwork for upcoming tests.


Geliang Tang (11):
  selftests: mptcp: adjust output alignment for more tests
  mptcp: add the mibs for MP_FASTCLOSE
  selftests: mptcp: add the MP_FASTCLOSE mibs check
  mptcp: add the mibs for MP_RST
  selftests: mptcp: add the MP_RST mibs check
  selftests: mptcp: add extra_args in do_transfer
  selftests: mptcp: reuse linkfail to make given size files
  selftests: mptcp: add fastclose testcase
  selftests: mptcp: add invert check in check_transfer
  selftests: mptcp: add more arguments for chk_join_nr
  selftests: mptcp: update output info of chk_rm_nr

 net/mptcp/mib.c                               |   4 +
 net/mptcp/mib.h                               |   4 +
 net/mptcp/options.c                           |   5 +
 .../testing/selftests/net/mptcp/mptcp_join.sh | 271 ++++++++++++++----
 4 files changed, 223 insertions(+), 61 deletions(-)


base-commit: 1039135aedfc5021b4827eb87276d7b4272024ac
-- 
2.35.1

