Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B472D2D6B0C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394154AbgLJWbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:31:21 -0500
Received: from mga04.intel.com ([192.55.52.120]:9089 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405140AbgLJW2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:28:01 -0500
IronPort-SDR: TwK1j7kN5Bfy7e4E6b5cXfl8p1/S0aFngRQsbQxOy8GywA7fH8d4rqXWLYbt0QGE557gWate2j
 X1JzyhG/GlcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="171776477"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="171776477"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:13 -0800
IronPort-SDR: Pb2OCY+LMUyvTOmfQCLBee/RtuYc9EOWVOrcdaQs7SaNWEnKNmFCeWWBiLffaQ1EvuWZLoQD1s
 +/YcXKGaJ0rA==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="338703749"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.112.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org
Subject: [PATCH net-next 0/9] mptcp: Another set of miscellaneous MPTCP fixes
Date:   Thu, 10 Dec 2020 14:24:57 -0800
Message-Id: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is another collection of MPTCP fixes and enhancements that we have
tested in the MPTCP tree:

Patch 1 cleans up cgroup attachment for in-kernel subflow sockets.

Patches 2 and 3 make sure that deletion of advertised addresses by an
MPTCP path manager when flushing all addresses behaves similarly to the
remove-single-address operation, and adds related tests.

Patches 4 and 8 do some minor cleanup.

Patches 5-7 add MPTCP_FASTCLOSE functionality. Note that patch 6 adds MPTCP
option parsing to tcp_reset().

Patch 9 optimizes skb size for outgoing MPTCP packets.


Florian Westphal (3):
  mptcp: hold mptcp socket before calling tcp_done
  tcp: parse mptcp options contained in reset packets
  mptcp: parse and act on incoming FASTCLOSE option

Geliang Tang (3):
  mptcp: remove address when netlink flushes addrs
  selftests: mptcp: add the flush addrs testcase
  mptcp: use MPTCPOPT_HMAC_LEN macro

Nicolas Rybowski (1):
  mptcp: attach subflow socket to parent cgroup

Paolo Abeni (2):
  mptcp: pm: simplify select_local_address()
  mptcp: let MPTCP create max size skbs

 include/net/tcp.h                             |  2 +-
 net/ipv4/tcp_input.c                          | 13 +++--
 net/ipv4/tcp_minisocks.c                      |  2 +-
 net/mptcp/options.c                           | 17 +++++++
 net/mptcp/pm_netlink.c                        | 21 ++++----
 net/mptcp/protocol.c                          | 47 +++++++++++++++--
 net/mptcp/protocol.h                          |  6 ++-
 net/mptcp/subflow.c                           | 34 ++++++++++++-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 50 +++++++++++++------
 9 files changed, 155 insertions(+), 37 deletions(-)


base-commit: 51e13685bd93654e0e9b2559c8e103d6545ddf95
-- 
2.29.2

