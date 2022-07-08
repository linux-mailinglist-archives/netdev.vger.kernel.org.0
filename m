Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305F056C073
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238360AbiGHROU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238128AbiGHROT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:14:19 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C5820BE2
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 10:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657300458; x=1688836458;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KBRIXR3aGF0nsqNQI8+grRRLlOpYjO7WAY0/ZqdFtNU=;
  b=cBejby28SFsbbyXpapp7/j3xK63Jp+8eTCLq2xUlSNmbUtcv4VGX+/Sr
   xxgYfSb1GOHmx6JOFuaeVK7uib1tVrDzlAK3vAp3tM/gQKD199PM0cfaC
   WuIUJx9L15j48LKd3k5RK1yBxngNvcBr59TWFeHtqOdeNwIiOWtHX5/8P
   nDLhrFfUKBNY1lW79O71VagnMBQ6boXtmiBvMw5HiOlwEOhQ/S1XCoEpd
   +Zc+N0IUzO6se3J6/jGNCAnaF+HL+2UEapSUKSfjPN+iYqOY0rjfD49ys
   7Y5vRMY2KYlsRRYM8zSRnmk40NicloCICQX/tetWHvHeIpxnAcxA+/QHi
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="267364235"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="267364235"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="651641496"
Received: from aroras-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.203])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:17 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        geliang.tang@suse.com, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/6] mptcp: Self test improvements and a header tweak
Date:   Fri,  8 Jul 2022 10:14:07 -0700
Message-Id: <20220708171413.327112-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 moves a definition to a header so it can be used in a struct
declaration.

Patch 2 adjusts a time threshold for a selftest that runs much slower on
debug kernels (and even more on slow CI infrastructure), to reduce
spurious failures.

Patches 3 & 4 improve userspace PM test coverage.

Patches 5 & 6 clean up output from a test script and selftest helper
tool.

Geliang Tang (5):
  mptcp: move MPTCPOPT_HMAC_LEN to net/mptcp.h
  selftests: mptcp: userspace pm address tests
  selftests: mptcp: userspace pm subflow tests
  selftests: mptcp: avoid Terminated messages in userspace_pm
  selftests: mptcp: update pm_nl_ctl usage header

Paolo Abeni (1):
  selftests: mptcp: tweak simult_flows for debug kernels

 include/net/mptcp.h                           |  3 +-
 net/mptcp/protocol.h                          |  1 -
 .../testing/selftests/net/mptcp/mptcp_join.sh | 86 ++++++++++++++++++-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c |  2 +-
 .../selftests/net/mptcp/simult_flows.sh       | 14 ++-
 .../selftests/net/mptcp/userspace_pm.sh       | 40 +++++----
 6 files changed, 123 insertions(+), 23 deletions(-)


base-commit: 67d7ebdeb2d5a058dd5079107505fffe7332b27a
-- 
2.37.0

