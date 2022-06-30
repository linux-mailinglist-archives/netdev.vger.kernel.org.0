Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5675625F3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 00:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiF3WSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 18:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiF3WSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 18:18:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987CB57225
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656627482; x=1688163482;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p0dqqgfy8zGcMIKh3FRaJtb3/66ZiVUFsAN86DmeRho=;
  b=IEy0bvmejhTW6uUMmcef5JQWYWeK52Ul9wngt3AHjPS9KU7FAcs4I6cp
   b27QLZHvBBTV5YIEW9DUHOtOURvCTgu9ncSUQh/qlSBiH/VoWVPSWf8LI
   4EiRLDf+RDQw6BMSXys2C00oIupj5AIpF2RDuMNHTXSPwB3XF1QqxTtCI
   xjA9CEMxshr6IaJ8mPYLyUjGkNAGpfC0I7s/4lqd3PohT2FI3Nq0h3sxn
   ZV02bGK6uiPhYsX5y+1P3XHtxwWq1LZrp/inkZBgVyZBCH7zBAUw1zEcE
   QIVGO41rWsgqABNDkWqkL4/nbyPzIqkbmb3vWf8m8ScnulFrZOzFf/Ftk
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="283583501"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="283583501"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="733804538"
Received: from mhtran-desk5.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.176.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:01 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/4] mptcp: Updates for mem scheduling and SK_RECLAIM
Date:   Thu, 30 Jun 2022 15:17:53 -0700
Message-Id: <20220630221757.763751-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the "net: reduce tcp_memory_allocated inflation" series (merge commit
e10b02ee5b6c), Eric Dumazet noted that "Removal of SK_RECLAIM_CHUNK and
SK_RECLAIM_THRESHOLD is left to MPTCP maintainers as a follow up."

Patches 1-3 align MPTCP with the above TCP changes to forward memory
allocation, reclaim, and memory scheduling.

Patch 4 removes the SK_RECLAIM_* macros as Eric requested.


Paolo Abeni (4):
  mptcp: never fetch fwd memory from the subflow
  mptcp: drop SK_RECLAIM_* macros
  mptcp: refine memory scheduling
  net: remove SK_RECLAIM_THRESHOLD and SK_RECLAIM_CHUNK

 include/net/sock.h   |  5 -----
 net/mptcp/protocol.c | 49 +++++++-------------------------------------
 2 files changed, 7 insertions(+), 47 deletions(-)


base-commit: b7d78b46d5e8dc77c656c13885d31e931923b915
-- 
2.37.0

