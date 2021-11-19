Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FBA4577D4
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 21:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhKSUoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:44:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:43529 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235226AbhKSUos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:44:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="231971903"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="231971903"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 12:41:46 -0800
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="506889210"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.14.166])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 12:41:44 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/4] mptcp: More socket option support
Date:   Fri, 19 Nov 2021 12:41:33 -0800
Message-Id: <20211119204137.415733-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches add MPTCP socket support for a few additional socket
options: IP_TOS, IP_FREEBIND, IP_TRANSPARENT, IPV6_FREEBIND, and
IPV6_TRANSPARENT.

Patch 1 exposes __ip_sock_set_tos() for use in patch 2.

Patch 2 adds IP_TOS support.

Patches 3 and 4 add the freebind and transparent support, with a
selftest for the latter.


Florian Westphal (2):
  mptcp: sockopt: add SOL_IP freebind & transparent options
  selftests: mptcp: add tproxy test case

Poorva Sonparote (2):
  ipv4: Exposing __ip_sock_set_tos() in ip.h
  mptcp: Support for IP_TOS for MPTCP setsockopt()

 include/net/ip.h                              |   1 +
 net/ipv4/ip_sockglue.c                        |   2 +-
 net/mptcp/sockopt.c                           | 106 +++++++++++++++++-
 net/mptcp/subflow.c                           |   3 +-
 tools/testing/selftests/net/mptcp/config      |   8 +-
 .../selftests/net/mptcp/mptcp_connect.c       |  51 ++++++++-
 .../selftests/net/mptcp/mptcp_connect.sh      |  80 +++++++++++++
 7 files changed, 245 insertions(+), 6 deletions(-)


base-commit: 520fbdf7fb19b7744e370d36d9244a446299ceb7
-- 
2.34.0

