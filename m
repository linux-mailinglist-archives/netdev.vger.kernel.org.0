Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964B04D39DF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbiCITSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238092AbiCITSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:18:14 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1A7182BF8
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646853407; x=1678389407;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/Ran1JNyW3eEs7d6BBS1NjHx1jcG0pHnNMJVrGsWSWI=;
  b=c9LNPaE+hLQRh19mNG/I3oB4lZT5J8QqtuOG36dPLVQvGhjjDhd1SZ1S
   mUmTKf/ocb0+v2+PBk9QlQhvzs3DcZcQf9j/GgOipXOKj4gHUEO3+beqi
   a99MYAhCPJPfmDq4hgYfPoGHI9wHU+jGqaLvOfP4syPm/re+WEJL58meK
   HoudBSb285tOSbwBj4uW+2kFI4DVwbuBfjN78OqCe3n1IMj0M9zyILtgh
   lnFYXZje8VYuimtAl6jvlWxIIg3r1stccuh7bwSbczz4fN/KNxzJ7A/r4
   zcBW2WBEO4pOKHtm7L36hX4Plnoq/2Zh58HBrSE0PSuJMGtNOydEwGpLo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237235263"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="237235263"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="495957051"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.194.198])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:45 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 00/10] mptcp: selftests: Refactor join tests
Date:   Wed,  9 Mar 2022 11:16:26 -0800
Message-Id: <20220309191636.258232-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mptcp_join.sh selftest is the largest and most complex self test for
MPTCP, and it is frequently used by MPTCP developers to reproduce bugs
and verify fixes. As it grew in size and execution time, it became more
cumbersome to use.

These changes do some much-needed cleanup, and add developer-friendly
features to make it easier to see failures and run a subset of the tests
when verifying fixes.


Geliang Tang (1):
  selftests: mptcp: drop msg argument of chk_csum_nr

Matthieu Baerts (9):
  selftests: mptcp: join: define tests groups once
  selftests: mptcp: join: reset failing links
  selftests: mptcp: join: option to execute specific tests
  selftests: mptcp: join: alt. to exec specific tests
  selftests: mptcp: join: list failure at the end
  selftests: mptcp: join: helper to filter TCP
  selftests: mptcp: join: clarify local/global vars
  selftests: mptcp: join: avoid backquotes
  selftests: mptcp: join: make it shellcheck compliant

 .../testing/selftests/net/mptcp/mptcp_join.sh | 2249 +++++++++--------
 1 file changed, 1210 insertions(+), 1039 deletions(-)


base-commit: 24055bb87977e0c687b54ebf7bac8715f3636bc3
-- 
2.35.1

