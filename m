Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3B24AA4D5
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 01:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378359AbiBEADn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 19:03:43 -0500
Received: from mga17.intel.com ([192.55.52.151]:46958 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244086AbiBEADn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 19:03:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644019423; x=1675555423;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=88fpml2V3bTkfhWRV3yeGOzte+HGrWElZ3H3z2OSIYM=;
  b=aHN2wUJHBdJXjYqrp9WrYW5566/YSwY5fBZT7rTklj5wXLaPSHxjt06Y
   PRLXXgvgQWyLdkhCWvOE2e+ld6fYV4rv3917Hg7Shg3VPewUE53XyCcTh
   B/hTI0wY9A9vll837nfgV6wgWs3FTJMQkJ+A5v3Oh4YHzjwRIIrx+wPSn
   sbedvL3k5mTJlUQKKJ9DGQWVarnOzkXnrnUUiZlb8n3KYMKZgVhA/7O39
   pquz1c+/+SDEN/LtwVaR5s9jpBQYFNOWueFXHKUEsgYF8zrh2T7ktg2Sa
   8YmNYI8/KWqcOpjKDY82nKzWBwBPFj4Ao3+MZ5s34Us1lol0Yfzd6juix
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="229115078"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="229115078"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="770097511"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:42 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/9] mptcp: Improve set-flags command and update self tests
Date:   Fri,  4 Feb 2022 16:03:28 -0800
Message-Id: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches 1-3 allow more flexibility in the combinations of features and
flags allowed with the MPTCP_PM_CMD_SET_FLAGS netlink command, and add
self test case coverage for the new functionality.

Patches 4-6 and 9 refactor the mptcp_join.sh self tests to allow them to
configure all of the test cases using either the pm_nl_ctl utility (part
of the mptcp self tests) or the 'ip mptcp' command (from iproute2). The
default remains to use pm_nl_ctl.

Patches 7 and 8 update the pm_netlink.sh self tests to cover the use of
endpoint ids to set endpoint flags (instead of just addresses).

Geliang Tang (9):
  mptcp: allow to use port and non-signal in set_flags
  selftests: mptcp: add the port argument for set_flags
  selftests: mptcp: add backup with port testcase
  selftests: mptcp: add ip mptcp wrappers
  selftests: mptcp: add wrapper for showing addrs
  selftests: mptcp: add wrapper for setting flags
  selftests: mptcp: add the id argument for set_flags
  selftests: mptcp: add set_flags tests in pm_netlink.sh
  selftests: mptcp: set ip_mptcp in command line

 net/mptcp/pm_netlink.c                        |  13 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 877 +++++++++++-------
 .../testing/selftests/net/mptcp/pm_netlink.sh |  18 +
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c |  75 +-
 4 files changed, 595 insertions(+), 388 deletions(-)


base-commit: c531adaf884d313df2729ca94228317a52e46b83
-- 
2.35.1

