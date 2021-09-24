Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DCB4168A7
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 02:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243609AbhIXAFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 20:05:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:42862 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240701AbhIXAFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 20:05:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10116"; a="287641070"
X-IronPort-AV: E=Sophos;i="5.85,318,1624345200"; 
   d="scan'208";a="287641070"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 17:04:18 -0700
X-IronPort-AV: E=Sophos;i="5.85,318,1624345200"; 
   d="scan'208";a="435989057"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.218])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 17:04:18 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, fw@strlen.de, dcaratti@redhat.com,
        pabeni@redhat.com, geliangtang@gmail.com
Subject: [PATCH net 0/2] mptcp: Bug fixes
Date:   Thu, 23 Sep 2021 17:04:10 -0700
Message-Id: <20210924000413.89902-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set includes two separate fixes for the net tree:

Patch 1 makes sure that MPTCP token searches are always limited to the
appropriate net namespace.

Patch 2 allows userspace to always change the backup settings for 
configured endpoints even if those endpoints are not currently in use.


Davide Caratti (1):
  mptcp: allow changing the 'backup' bit when no sockets are open

Florian Westphal (1):
  mptcp: don't return sockets in foreign netns

 net/mptcp/mptcp_diag.c |  2 +-
 net/mptcp/pm_netlink.c |  4 +---
 net/mptcp/protocol.h   |  2 +-
 net/mptcp/subflow.c    |  2 +-
 net/mptcp/syncookies.c | 13 +------------
 net/mptcp/token.c      | 11 ++++++++---
 net/mptcp/token_test.c | 14 ++++++++------
 7 files changed, 21 insertions(+), 27 deletions(-)


base-commit: 9bc62afe03afdf33904f5e784e1ad68c50ff00bb
-- 
2.33.0

