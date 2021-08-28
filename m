Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4363FA215
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 02:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhH1ASg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 20:18:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:60799 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232503AbhH1ASf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 20:18:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="205257939"
X-IronPort-AV: E=Sophos;i="5.84,358,1620716400"; 
   d="scan'208";a="205257939"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 17:17:45 -0700
X-IronPort-AV: E=Sophos;i="5.84,358,1620716400"; 
   d="scan'208";a="528512880"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.16.51])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 17:17:45 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com
Subject: [PATCH net 0/2] mptcp: Prevent tcp_push() crash and selftest temp file buildup
Date:   Fri, 27 Aug 2021 17:17:29 -0700
Message-Id: <20210828001731.67757-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are two fixes for the net tree, addressing separate issues.

Patch 1 addresses a divide-by-zero crash seen in syzkaller and also
reported by a user on the netdev list. This changes MPTCP code so
tcp_push() cannot be called with an invalid (0) mss_now value.

Patch 2 fixes a selftest temp file cleanup issue that consumes excessive
disk space when running repeated tests.


Matthieu Baerts (1):
  selftests: mptcp: clean tmp files in simult_flows

Paolo Abeni (1):
  mptcp: fix possible divide by zero

 net/mptcp/protocol.c                          | 78 +++++++++----------
 .../selftests/net/mptcp/simult_flows.sh       |  4 +-
 2 files changed, 39 insertions(+), 43 deletions(-)


base-commit: 5fe2a6b4344cbb2120d6d81e371b7ec8e75f03e2
-- 
2.33.0

