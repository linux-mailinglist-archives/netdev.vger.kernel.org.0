Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E995656C566
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiGHXgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiGHXgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:36:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B603606B2
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 16:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657323375; x=1688859375;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EYM3dMFqjlVHn6LqIw1/xdSb4hfj52ET+Bxqsfzd0rM=;
  b=QBoOTc886Yn9cuaCG7a59HCR8fEo+ZYkViWsn0S8I6wYdMNxdJJlKNA2
   xTt5CHBBAQzy+jy3bdMyXukwIOcoFjvSAfC/B40o4iDbPLUHfw+sNQgnA
   2nJSwElC0m/qz4Yb4jFakn8vckzeEQxqYrJ/N65tdjBlfLnfb2nSO1Ed7
   hTaGzwQ2fYcylTxcDTJGzQ64Ql+5NZMWSk+0o/vGuZNzRkfyfgULHHBWM
   6Oxbl2uVvm0QpN7IHmlX6a7R53B+30lP10bCbUXvfDxxsBZD3Ln1geUBG
   2fMc8uLiNXvsIanu5qvPVvSoVMvoz9WfvM3a5E5zrFTReQHiIegWuJtF6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="346071653"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="346071653"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 16:36:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="770933076"
Received: from aroras-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.203])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 16:36:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, kishen.maloor@intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net 0/2] mptcp: Disconnect and selftest fixes
Date:   Fri,  8 Jul 2022 16:36:08 -0700
Message-Id: <20220708233610.410786-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
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

Patch 1 switches to a safe list iterator in the MPTCP disconnect code.

Patch 2 adds the userspace_pm.sh selftest script to the MPTCP selftest
Makefile, resolving the netdev/check_selftest CI failure.

Matthieu Baerts (1):
  selftests: mptcp: validate userspace PM tests by default

Paolo Abeni (1):
  mptcp: fix subflow traversal at disconnect time

 net/mptcp/protocol.c                       | 4 ++--
 tools/testing/selftests/net/mptcp/Makefile | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


base-commit: 32b3ad1418ea53184ab7d652f13b5d66414d1bba
-- 
2.37.0

