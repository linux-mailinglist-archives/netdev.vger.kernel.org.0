Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A784B7D5D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343560AbiBPCL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:11:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242956AbiBPCLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:11:52 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19489FDD
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644977501; x=1676513501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kYzMznrxDGLwKZFu0MSKfsyMG7hTzjLWAU+77WHCCUk=;
  b=FvWTR0dwaxuFUhzGlK/QPWYxMmgkX0iCxP3cyJDAVVxeRHPOag+jqpEV
   osc1ot+aMWXhFP+awI96/5MKe75tLwkWQejI2NlirUVLAfCAVWiLWcnbl
   cQGxjcsCKkKD30glOOxsQiJDD2jS77vY5+bpH4SD5TxfmgDiMwLIdOuhk
   Edo0BdeMZjXzGv6lHrfB+IJm5zvPPkRjspQ39Vep/tMxYYDX7aZSrKWRB
   a/Vlge+JUE/2Yqo0JKhwhS1MyqTI9TYyF8cWeawIccLsc9MOZVUdYg5Qx
   MyFu9UCYO13A0e89hskb+2lkpW1ew6jVbCrRbWL7QOAmCWrTsCnfuyKwi
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237909076"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="237909076"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="571088821"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/8] mptcp: drop unneeded type casts for hmac
Date:   Tue, 15 Feb 2022 18:11:26 -0800
Message-Id: <20220216021130.171786-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216021130.171786-1-mathew.j.martineau@linux.intel.com>
References: <20220216021130.171786-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Drop the unneeded type casts to 'unsigned long long' for printing out the
hmac values in add_addr_hmac_valid() and subflow_thmac_valid().

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 3 +--
 net/mptcp/subflow.c | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index a10536d7c84b..5a14420b77c8 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1085,8 +1085,7 @@ static bool add_addr_hmac_valid(struct mptcp_sock *msk,
 				      &mp_opt->addr);
 
 	pr_debug("msk=%p, ahmac=%llu, mp_opt->ahmac=%llu\n",
-		 msk, (unsigned long long)hmac,
-		 (unsigned long long)mp_opt->ahmac);
+		 msk, hmac, mp_opt->ahmac);
 
 	return hmac == mp_opt->ahmac;
 }
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 0d6a4109add1..8cf85684c88f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -344,9 +344,7 @@ static bool subflow_thmac_valid(struct mptcp_subflow_context *subflow)
 
 	thmac = get_unaligned_be64(hmac);
 	pr_debug("subflow=%p, token=%u, thmac=%llu, subflow->thmac=%llu\n",
-		 subflow, subflow->token,
-		 (unsigned long long)thmac,
-		 (unsigned long long)subflow->thmac);
+		 subflow, subflow->token, thmac, subflow->thmac);
 
 	return thmac == subflow->thmac;
 }
-- 
2.35.1

