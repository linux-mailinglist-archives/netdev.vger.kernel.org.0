Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E76E2A1112
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgJ3WpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:45:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:45959 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgJ3WpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 18:45:15 -0400
IronPort-SDR: f0p7u0l9diQIbevvVbGCgG37OjM2eZoc0c+tlyYFvLxr2+dKsfNaOeoiOTnQq4Pt9TKFe046PY
 LAHBzQ1lLaiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="165177393"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="165177393"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:14 -0700
IronPort-SDR: uBRcZFl0wFhMenoFqZkAUFk+zIBY/WaYLg6RTtpgqkT4TjWnFg1Uq/ccWr5dQKt+gPWbmtzvLm
 n27mvreAjxsA==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="361983933"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.102.227])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:12 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net-next 0/6] mptcp: Miscellaneous MPTCP fixes
Date:   Fri, 30 Oct 2020 15:45:00 -0700
Message-Id: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a collection of small fixup and minor enhancement patches that
have accumulated in the MPTCP tree while net-next was closed. These are
prerequisites for larger changes we have queued up.

Patch 1 refines receive buffer autotuning.

Patches 2 and 4 are some minor locking and refactoring changes.

Patch 3 improves GRO and RX coalescing with MPTCP skbs.

Patches 5 and 6 add a sysctl for tuning ADD_ADDR retransmission timeout
and corresponding test code.

Florian Westphal (3):
  mptcp: adjust mptcp receive buffer limit if subflow has larger one
  mptcp: use _fast lock version in __mptcp_move_skbs
  mptcp: split mptcp_clean_una function

Geliang Tang (2):
  mptcp: add a new sysctl add_addr_timeout
  selftests: mptcp: add ADD_ADDR timeout test case

Paolo Abeni (1):
  tcp: propagate MPTCP skb extensions on xmit splits

 include/net/mptcp.h                           | 21 ++++-
 net/ipv4/tcp_output.c                         |  3 +
 net/mptcp/ctrl.c                              | 14 +++
 net/mptcp/pm_netlink.c                        |  8 +-
 net/mptcp/protocol.c                          | 67 +++++++++----
 net/mptcp/protocol.h                          |  1 +
 tools/testing/selftests/net/mptcp/config      | 10 ++
 .../testing/selftests/net/mptcp/mptcp_join.sh | 94 ++++++++++++++-----
 8 files changed, 171 insertions(+), 47 deletions(-)


base-commit: 1fb74191988fd1cc340c4b2fdaf4c47d2a7d1d17
-- 
2.29.2

