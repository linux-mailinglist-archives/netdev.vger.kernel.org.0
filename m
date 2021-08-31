Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867F13FCC38
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbhHaRUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 13:20:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:40152 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240324AbhHaRUg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 13:20:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="216680283"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="216680283"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 10:19:33 -0700
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="690094684"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.180.246])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 10:19:32 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com
Subject: [PATCH net v2 0/2] mptcp: Prevent tcp_push() crash and selftest temp file buildup
Date:   Tue, 31 Aug 2021 10:19:24 -0700
Message-Id: <20210831171926.80920-1-mathew.j.martineau@linux.intel.com>
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


v2: Make suggested changes to lockdep check and indentation in patch 1


Matthieu Baerts (1):
  selftests: mptcp: clean tmp files in simult_flows

Paolo Abeni (1):
  mptcp: fix possible divide by zero

 net/mptcp/protocol.c                          | 76 +++++++++----------
 .../selftests/net/mptcp/simult_flows.sh       |  4 +-
 2 files changed, 37 insertions(+), 43 deletions(-)


base-commit: 57f780f1c43362b86fd23d20bd940e2468237716
-- 
2.33.0

