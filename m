Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF553196AA
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhBKXcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:32:36 -0500
Received: from mga05.intel.com ([192.55.52.43]:55189 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhBKXcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:32:35 -0500
IronPort-SDR: l77S77c+QoQH91w1ZI6dXvv+mBEfddkKIx7enbYmKb3SatIGDiSEHV2lLPrg2v6sbzSc+KAPUV
 EaMhPpsotzTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9892"; a="267177931"
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="267177931"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:48 -0800
IronPort-SDR: Md547g7XAz3lyhiSCsqfageDc4GENqukl6skyrhlN8nJR14ykTwQ8ZMTsDLen46Wb/TClRoNAo
 oH61f6E758fA==
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="381226379"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.100.224])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:47 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        matthieu.baerts@tessares.net
Subject: [PATCH net 0/6] mptcp: Miscellaneous fixes
Date:   Thu, 11 Feb 2021 15:30:36 -0800
Message-Id: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some MPTCP fixes for the -net tree, addressing various issues
we have seen thanks to syzkaller and other testing:

Patch 1 correctly propagates errors at connection time and for TCP
fallback connections.

Patch 2 sets the expected poll() events on SEND_SHUTDOWN.

Patch 3 fixes a retranmit crash and unneeded retransmissions.

Patch 4 fixes possible uninitialized data on the error path during
socket creation.

Patch 5 addresses a problem with MPTCP window updates.

Patch 6 fixes a case where MPTCP retransmission can get stuck.


Paolo Abeni (6):
  mptcp: deliver ssk errors to msk
  mptcp: fix poll after shutdown
  mptcp: fix spurious retransmissions
  mptcp: init mptcp request socket earlier
  mptcp: better msk receive window updates
  mptcp: add a missing retransmission timer scheduling

 net/mptcp/options.c  | 10 +++---
 net/mptcp/protocol.c | 55 +++++++++++++++++++----------
 net/mptcp/protocol.h | 18 ++++------
 net/mptcp/subflow.c  | 83 +++++++++++++++++++++++++++++++-------------
 4 files changed, 107 insertions(+), 59 deletions(-)


base-commit: 8a28af7a3e85ddf358f8c41e401a33002f7a9587
-- 
2.30.1

