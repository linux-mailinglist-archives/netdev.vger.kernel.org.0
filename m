Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B60369909
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbhDWSRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:17:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:40508 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhDWSRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 14:17:51 -0400
IronPort-SDR: MzoMUZZfv7Sv6sDjys77Y+j67tuRjqBiPcac/aNJWfjM3oLLzKr/qZyJ9nQQlZKa26YPKfyz/r
 JoQzlCLwTDEQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="196172518"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="196172518"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:14 -0700
IronPort-SDR: LW9qXCt4g0q1brPfHw6YMETn7T8DGBIsajekmhAS4v7hpFBIvz5vPor+9Vbkidv7c9kJ5Gbkot
 rgTwGmZHT7hA==
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="402264966"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.72.13])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/5] mptcp: Compatibility with common msg flags
Date:   Fri, 23 Apr 2021 11:17:04 -0700
Message-Id: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches from the MPTCP tree handle some of the msg flags that are
typically used with TCP, to make it easier to adapt userspace programs
for use with MPTCP.

Patches 1, 2, and 4 add support for MSG_ERRQUEUE (no-op for now),
MSG_TRUNC, and MSG_PEEK on the receive side.

Patch 3 ignores unsupported msg flags for send and receive.

Patch 5 adds a selftest for MSG_PEEK.


Paolo Abeni (3):
  mptcp: implement dummy MSG_ERRQUEUE support
  mptcp: implement MSG_TRUNC support
  mptcp: ignore unsupported msg flags

Yonglong Li (2):
  mptcp: add MSG_PEEK support
  selftests: mptcp: add a test case for MSG_PEEK

 net/mptcp/protocol.c                          | 49 ++++++++++++-------
 .../selftests/net/mptcp/mptcp_connect.c       | 48 +++++++++++++++++-
 .../selftests/net/mptcp/mptcp_connect.sh      | 29 ++++++++---
 3 files changed, 99 insertions(+), 27 deletions(-)


base-commit: cad4162a90aeff737a16c0286987f51e927f003a
-- 
2.31.1

