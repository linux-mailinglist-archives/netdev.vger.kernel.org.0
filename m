Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDE0356007
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347461AbhDGAQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:16:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:23775 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347456AbhDGAQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:16:20 -0400
IronPort-SDR: Pf69rLjsBkgRtxF9cMD2vX2leZi8zskc4a55tDYibLseIerEffqjWDMy8NnMHdH10WNPeaha/4
 sHMwbpYYUmpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="193297247"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="193297247"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
IronPort-SDR: c0Tg82npxhOSKY4RKP9zNmlP5KGAoGGYCss0UJ0YNEYu/UH8QmiMV3QrLuQWQd2MJ+SAcPGDcJ
 +/JMf7it1PKg==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="458105191"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.115.52])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/8] mptcp: Cleanup, a new test case, and header trimming
Date:   Tue,  6 Apr 2021 17:15:56 -0700
Message-Id: <20210407001604.85071-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some more patches to include from the MPTCP tree:

Patches 1-6 refactor an address-related data structure and reduce some
duplicate code that handles IPv4 and IPv6 addresses.

Patch 7 adds a test case for the MPTCP netlink interface, passing a
specific ifindex to the kernel.

Patch 8 drops extra header options from IPv4 address echo packets,
improving consistency and testability between IPv4 and IPv6.

Davide Caratti (1):
  mptcp: drop all sub-options except ADD_ADDR when the echo bit is set

Geliang Tang (7):
  mptcp: move flags and ifindex out of mptcp_addr_info
  mptcp: use mptcp_addr_info in mptcp_out_options
  mptcp: drop OPTION_MPTCP_ADD_ADDR6
  mptcp: use mptcp_addr_info in mptcp_options_received
  mptcp: drop MPTCP_ADDR_IPVERSION_4/6
  mptcp: unify add_addr(6)_generate_hmac
  selftests: mptcp: add the net device name testcase

 include/net/mptcp.h                           |  21 ++-
 net/mptcp/options.c                           | 175 ++++++------------
 net/mptcp/pm_netlink.c                        |  41 ++--
 net/mptcp/protocol.h                          |  38 +---
 net/mptcp/subflow.c                           |   7 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh |   8 +
 6 files changed, 115 insertions(+), 175 deletions(-)


base-commit: be107538c5296fb888938ec3a32da21bb1733655
-- 
2.31.1

