Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEB3479791
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 00:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhLQXhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 18:37:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:5665 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229914AbhLQXhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 18:37:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="326146287"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="326146287"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:37:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="683556052"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.7.225])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:37:06 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/3] mptcp: Miscellaneous changes for 5.17
Date:   Fri, 17 Dec 2021 15:36:59 -0800
Message-Id: <20211217233702.299461-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are three unrelated patches that we've been testing in the MPTCP
tree.


Patch 1 modifies the packet scheduler that picks which TCP subflow is
used for each chunk of outgoing data. The updated scheduler improves
throughput on multiple-subflow connections.

Patch 2 updates a selftest to verify recent TCP_ULP sockopt changes
on MPTCP fallback sockets.

Patch 3 cleans up some unnecessary comparisons with an 8-bit value.


Florian Westphal (1):
  selftests: mptcp: try to set mptcp ulp mode in different sk states

Jean Sacren (1):
  mptcp: clean up harmless false expressions

Paolo Abeni (1):
  mptcp: enforce HoL-blocking estimation

 net/mptcp/pm_netlink.c                        |  8 +-
 net/mptcp/protocol.c                          | 72 +++++++++-----
 net/mptcp/protocol.h                          |  1 +
 .../selftests/net/mptcp/mptcp_connect.c       | 97 ++++++++++---------
 .../selftests/net/mptcp/mptcp_connect.sh      | 20 ----
 5 files changed, 103 insertions(+), 95 deletions(-)


base-commit: f75c1d55ecbadce027fd650d3ca79e357afae0d9
-- 
2.34.1

