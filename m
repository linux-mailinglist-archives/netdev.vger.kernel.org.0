Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7444A7D33
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348708AbiBCBDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:03:50 -0500
Received: from mga17.intel.com ([192.55.52.151]:7851 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233773AbiBCBDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 20:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643850229; x=1675386229;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jsyE099v4+HWgF7jMhM4Z+cIr6BUGWAi0HEwDv3wVa8=;
  b=Gzyvc94NrwSpkounkshKnTCzM75uXOnQ7rqnoGoTtzqoOieYOXIZXX+Z
   b74r2P2LsoR9mnvib60qAi3P1avkkC9/euA1JGAkZ7aQnF06Q/ImUdru9
   btEompOcLxmL1PxuiaJzbLp5JstI4ShFN0oFxui0farNrXznfwGTKOQXz
   FYDNgcI8axrgop6avZZU7cSip/F7U3ZJbqski8bc+fJKTbzXeZlW2Daw2
   v0xpofCr8ZPAzo9Jz7TJqlFcttmpN5rkScmoFBv+32HJYf8vcuQ7Hkfey
   bVo993fqgs7+mnukRLOkulO+FpoPkuAGfU7He1Q97efCD5q3mKN5K+FmA
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="228708713"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="228708713"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="483070826"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.1.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/7] mptcp: Miscellaneous changes for 5.18
Date:   Wed,  2 Feb 2022 17:03:36 -0800
Message-Id: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 has some minor cleanup in mptcp_write_options().

Patch 2 moves a rarely-needed branch to optimize mptcp_write_options().

Patch 3 adds a comment explaining which combinations of MPTCP option
headers are expected.

Patch 4 adds a pr_debug() for the MPTCP_RST option.

Patches 5-7 allow setting MPTCP_PM_ADDR_FLAG_FULLMESH with the "set
flags" netlink command. This allows changing the behavior of existing
path manager endpoints. The flag was previously only set at endpoint
creation time. Associated selftests also updated.


Geliang Tang (5):
  mptcp: move the declarations of ssk and subflow
  mptcp: print out reset infos of MP_RST
  mptcp: set fullmesh flag in pm_netlink
  selftests: mptcp: set fullmesh flag in pm_nl_ctl
  selftests: mptcp: add fullmesh setting tests

Matthieu Baerts (2):
  mptcp: reduce branching when writing MP_FAIL option
  mptcp: clarify when options can be used

 net/mptcp/options.c                           | 64 +++++++++++++------
 net/mptcp/pm_netlink.c                        | 37 ++++++++---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 49 ++++++++++++--
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c |  8 ++-
 4 files changed, 121 insertions(+), 37 deletions(-)


base-commit: 52dae93f3bad842c6d585700460a0dea4d70e096
-- 
2.35.1

