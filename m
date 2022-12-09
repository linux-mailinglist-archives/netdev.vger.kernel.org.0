Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01256647AE5
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLIAoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLIAoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:44:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FC24F19E
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670546677; x=1702082677;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WpCZuEoj9S+cdDYyVkX372txxL33h20MU9oS7XPvEk0=;
  b=VwLvM0/lQNCnDQ8VXif8Ojqo0dqFBXoE/DFILX8zc8woCAgiOt8CuX4L
   So15UAGKrB0t4LgrjDTt1zPGup99EPzKEEC3Cpvz7VA8TjK+YXA2V2HnR
   pDiie8uaseBbz9h26Vtxn/hMFLtQhWS9VJE7ffXtgbgrX0ot4YHGVig9s
   BzC0XIwdw5V4SjKVDE34cqsGhJCiLduHTCRYbQ1erheM9G2gvuBj8GvcM
   bXuEeWWu6kcsXcG4G7B5xibqKAS7kIrB5LbniwWgwcpUBe08Ey3R5CfJn
   apVEXfujWtfbmHxMk1peTWAQZzQnYJYRa01mGF7duNHi3TuY6ndSEPxhL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317367573"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="317367573"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 16:44:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="736027000"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="736027000"
Received: from mchombea-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.102.119])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 16:44:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/2] mptcp: Miscellaneous cleanup
Date:   Thu,  8 Dec 2022 16:44:29 -0800
Message-Id: <20221209004431.143701-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two code cleanup patches for the 6.2 merge window that don't change
behavior:

Patch 1 makes proper use of nlmsg_free(), as suggested by Jakub while
reviewing f8c9dfbd875b ("mptcp: add pm listener events").

Patch 2 clarifies success status in a few mptcp functions, which
prevents some smatch false positives.

Geliang Tang (1):
  mptcp: use nlmsg_free instead of kfree_skb

Matthieu Baerts (1):
  mptcp: return 0 instead of 'err' var

 net/mptcp/pm_netlink.c | 12 ++++++------
 net/mptcp/sockopt.c    |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)


base-commit: ff36c447e2330625066d193a25a8f94c1408d9d9
-- 
2.38.1

