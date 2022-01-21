Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F510495768
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 01:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378420AbiAUAfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 19:35:37 -0500
Received: from mga17.intel.com ([192.55.52.151]:65249 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378409AbiAUAfh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 19:35:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642725337; x=1674261337;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dTzLvvcnyLCTna+HzSfQ605V7CdwOfrhhKrfMjlmUCY=;
  b=FoSZ62kLeMp7ZPavCMtsRNIkhSRM5PmwvOpl3LnvjLZ8FrKD+WnYiJ5c
   jHtdsNX7hYHFcCtb3F8QomrR08NjQdO7OJNWUqBD1+kFveUyYo390H5s7
   lPmvXej3Z9GcwT3aYJbSLQQm0yPypwjxmURmh+dH5aU+JlrbAQZgADAh9
   Jdldr3nBg4csQu2kxxZbLeRsRyuCuFT+IxoxW1pzQHz76xxuAezIKKfRf
   2AtBJ6oDGdSlakYSvJoZtwyYC7ZCbiAbnCDTCAS8F5Ges43ucNM0nWP6v
   5chHE88sv/10zms0N8W+NhvW8W7/1t8KCRTHb0dz63IuI5Q0y11bFMN7V
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="226200814"
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="226200814"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:35:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="531215210"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.220.167])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:35:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/3] mptcp: A few fixes
Date:   Thu, 20 Jan 2022 16:35:26 -0800
Message-Id: <20220121003529.54930-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some fixes from the mptcp tree:

Patch 1 fixes a RCU locking issue when processing a netlink command that
updates endpoint flags in the in-kernel MPTCP path manager.

Patch 2 fixes a typo affecting available endpoint id tracking.

Patch 3 fixes IPv6 routing in the MPTCP self tests.


Geliang Tang (1):
  mptcp: fix removing ids bitmap setting

Paolo Abeni (2):
  mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()
  selftests: mptcp: fix ipv6 routing setup

 net/mptcp/pm_netlink.c                        | 39 +++++++++++++------
 .../testing/selftests/net/mptcp/mptcp_join.sh |  5 ++-
 2 files changed, 31 insertions(+), 13 deletions(-)


base-commit: 57afdc0aab094b4c811b3fe030b2567812a495f3
-- 
2.34.1

