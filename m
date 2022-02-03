Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A444A7D31
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348722AbiBCBDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:03:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:6288 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237577AbiBCBDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 20:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643850229; x=1675386229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7X+m5cdLWaZh4tYFJBJ/dkJI7qFZSYhYD4KmzoHQe1g=;
  b=oKqFtF5VJ5jKsMYdc4DSg9vm72hwPrjRXLP/2vMVIWd4Ia0h35AcwTEV
   vKpCd4lDW/LB00cMFCtV7jdO082esN7UmUqXjyOnbxicZr1BMrk2aHGkT
   HrmVoMQsnNE4P3mz1rLpCF+W3Yc2n45WEYpNklHgjs18/IhQwM0dLdZww
   aCWOuHaM03jkLr8/bvqeOYUjU55IK1tuMv+5gQyqn+MreBfsDHU9pv70g
   SW8+31DzP8ZoIWkoIuNLAhoPIkX1nOQkz85Kbub0F6vlGKE8TbAjorqR6
   kUXWTNaD8oJulPptL8Cf9vwNHKMh5wPM6psXVS1WoyT/73sBiqKuw//ju
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="308782832"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="308782832"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="483070831"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.1.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/7] mptcp: print out reset infos of MP_RST
Date:   Wed,  2 Feb 2022 17:03:40 -0800
Message-Id: <20220203010343.113421-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
References: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch printed out the reset infos, reset_transient and reset_reason,
of MP_RST in mptcp_parse_option() to show that MP_RST is received.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 7345f28f3de1..3e82ac24d548 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -336,6 +336,8 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		flags = *ptr++;
 		mp_opt->reset_transient = flags & MPTCP_RST_TRANSIENT;
 		mp_opt->reset_reason = *ptr;
+		pr_debug("MP_RST: transient=%u reason=%u",
+			 mp_opt->reset_transient, mp_opt->reset_reason);
 		break;
 
 	case MPTCPOPT_MP_FAIL:
-- 
2.35.1

