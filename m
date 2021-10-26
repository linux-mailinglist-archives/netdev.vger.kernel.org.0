Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306F243BDDD
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbhJZXbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:31:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:24059 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231847AbhJZXbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 19:31:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="316242944"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="316242944"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 16:29:21 -0700
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="597124825"
Received: from jdweinst-mobl2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.54.246])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 16:29:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        pabeni@redhat.com, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/4] mptcp: Rework fwd memory allocation and one cleanup
Date:   Tue, 26 Oct 2021 16:29:12 -0700
Message-Id: <20211026232916.179450-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches from the MPTCP tree rework forward memory allocation for
MPTCP (with some supporting changes in the net core), and also clean up
an unused function parameter.


Patch 1 updates TCP code but does not change any behavior, and creates
some macros for reclaim thresholds that will be reused in the MPTCP
code.

Patch 2 adds sk_forward_alloc_get() to the networking core to support
MPTCP's forward allocation with the diag interface.

Patch 3 reworks forward memory for MPTCP.

Patch 4 removes an unused arg and has no functional changes.


Geliang Tang (1):
  mptcp: drop unused sk in mptcp_push_release

Paolo Abeni (3):
  tcp: define macros for a couple reclaim thresholds
  net: introduce sk_forward_alloc_get()
  mptcp: allocate fwd memory separately on the rx and tx path

 include/net/sock.h   |  20 +++-
 net/ipv4/af_inet.c   |   2 +-
 net/ipv4/inet_diag.c |   2 +-
 net/mptcp/protocol.c | 234 ++++++++++++++++++-------------------------
 net/mptcp/protocol.h |  15 +--
 net/sched/em_meta.c  |   2 +-
 6 files changed, 120 insertions(+), 155 deletions(-)


base-commit: 06338ceff92510544a732380dbb2d621bd3775bf
-- 
2.33.1

