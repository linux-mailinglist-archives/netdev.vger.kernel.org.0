Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF59393948
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhE0XdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:33:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:8585 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233633AbhE0XdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:33:19 -0400
IronPort-SDR: 1coZOWxo8wIzs3Cj06EoFfV9CzNW9/slAu/r3TouB3qUsbytrTfKrDmY1jF7kSzVSDE/PRWBhj
 MDeOdryqnRIg==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="190227178"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="190227178"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:31:45 -0700
IronPort-SDR: R/G+pz4gfW74pjTxC7PXtjO4LjKr3lEJhcGj3FkBY+TQiJKLzIUmvKlh7rGW+DhafuxgPzkdGx
 A3rDP+VgRzgA==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="477700330"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.84.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:31:45 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/4] mptcp: Fixes for 5.13
Date:   Thu, 27 May 2021 16:31:36 -0700
Message-Id: <20210527233140.182728-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches address two issues in MPTCP.

Patch 1 fixes a locking issue affecting MPTCP-level retransmissions.

Patches 2-4 improve handling of out-of-order packet arrival early in a
connection, so it falls back to TCP rather than forcing a
reset. Includes a selftest.

Paolo Abeni (4):
  mptcp: fix sk_forward_memory corruption on retransmission
  mptcp: always parse mptcp options for MPC reqsk
  mptcp: do not reset MP_CAPABLE subflow on mapping errors
  mptcp: update selftest for fallback due to OoO

 net/mptcp/protocol.c                          | 16 +++-
 net/mptcp/subflow.c                           | 79 ++++++++++---------
 .../selftests/net/mptcp/mptcp_connect.sh      | 13 ++-
 3 files changed, 64 insertions(+), 44 deletions(-)


base-commit: fb91702b743dec78d6507c53a2dec8a8883f509d
-- 
2.31.1

