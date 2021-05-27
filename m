Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECEB3939A2
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhE0X4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:56:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:38823 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236616AbhE0X4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:56:10 -0400
IronPort-SDR: cfw2F6PoxoO7L7RjgSdm+R2DZ9u5SIQDP9N9gx65pI6gRydQkjcI1TZ7+EWVPJc4OPhEMNphEb
 p7TzpwAvtFyg==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="224079918"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="224079918"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:36 -0700
IronPort-SDR: GE8KJMkWMam7ImRErhAOCpq8IrS2BMUF4hQBsggUhUalaDzsHy5DL/KdA7x1b6esFWXKPdEbav
 KMCrUH8xg+lA==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="443774249"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.84.136])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:35 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/7] mptcp: Miscellaneous cleanup
Date:   Thu, 27 May 2021 16:54:23 -0700
Message-Id: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some cleanup patches we've collected in the MPTCP tree.

Patches 1-4 do some general tidying.

Patch 5 adds an explicit check at netlink command parsing time to
require a port number when the 'signal' flag is set, to catch the error
earlier.

Patches 6 & 7 fix up the MPTCP 'enabled' sysctl, enforcing it as a
boolean value, and ensuring that the !CONFIG_SYSCTL build still works
after the boolean change.

Jianguo Wu (5):
  mptcp: fix pr_debug in mptcp_token_new_connect
  mptcp: using TOKEN_MAX_RETRIES instead of magic number
  mptcp: generate subflow hmac after mptcp_finish_join()
  mptcp: remove redundant initialization in pm_nl_init_net()
  mptcp: make sure flag signal is set when add addr with port

Matthieu Baerts (2):
  mptcp: support SYSCTL only if enabled
  mptcp: restrict values of 'enabled' sysctl

 Documentation/networking/mptcp-sysctl.rst |  8 ++---
 net/mptcp/ctrl.c                          | 36 +++++++++++++++++------
 net/mptcp/pm_netlink.c                    | 15 ++++++++--
 net/mptcp/protocol.h                      |  2 ++
 net/mptcp/subflow.c                       |  8 ++---
 net/mptcp/token.c                         |  9 +++---
 6 files changed, 53 insertions(+), 25 deletions(-)


base-commit: 91b17a436759e9f3a6f9ff090693564c3299cd9a
-- 
2.31.1

