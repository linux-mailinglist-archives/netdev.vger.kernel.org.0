Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F22A4D08B5
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239622AbiCGUpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiCGUpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:45:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3002881197
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646685886; x=1678221886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eDGInZ02EZTQhjOVuz9yt7L4hFYAeZ10SMHH1IYnTJY=;
  b=bgBOZaOFvclUu63fZ4lCn0XlJsvRAjGDvTJFMsay2wWuflBvAOjwb9mt
   IUeHxNP8CfvxYbL95NxCpw6bIP3uVvKCTHuAVy0CvCYZyWt72PklLrtKi
   PigR17GtQSttd++qXC+hA4NFnpUqCceqhLQA0unqSGyJTU+Maq7Kgm6Df
   yDsGW4zRH+fa8NAUWx2vNtCuRqN7Mm4rMC7x4AQa6CTw8+ExYPGmW81u+
   lCb/YMq3ReLVWjqbu/yCPDlP0m+XgcW6zkn5Tn2pagphkVm/u2hS02XlB
   wIidasUbLeSnnPDBgHe920LtTeYzZxJPZs1Dmoyuxk+BhMoT+SyaW90m2
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254440158"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254440158"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:44 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="553320482"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.192.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:44 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/9] mptcp: use MPTCP_SUBFLOW_NODATA
Date:   Mon,  7 Mar 2022 12:44:32 -0800
Message-Id: <20220307204439.65164-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
References: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Set subflow->data_avail with the enum value MPTCP_SUBFLOW_NODATA, instead
of using 0 directly.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 45c004f87f5a..bb09a008e733 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1104,7 +1104,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	struct sk_buff *skb;
 
 	if (!skb_peek(&ssk->sk_receive_queue))
-		WRITE_ONCE(subflow->data_avail, 0);
+		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
 	if (subflow->data_avail)
 		return true;
 
@@ -1169,7 +1169,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		subflow->reset_transient = 0;
 		subflow->reset_reason = MPTCP_RST_EMIDDLEBOX;
 		tcp_send_active_reset(ssk, GFP_ATOMIC);
-		WRITE_ONCE(subflow->data_avail, 0);
+		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
 		return true;
 	}
 
@@ -1182,7 +1182,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		subflow->reset_transient = 0;
 		subflow->reset_reason = MPTCP_RST_EMPTCP;
 		tcp_send_active_reset(ssk, GFP_ATOMIC);
-		WRITE_ONCE(subflow->data_avail, 0);
+		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
 		return false;
 	}
 
@@ -1204,7 +1204,7 @@ bool mptcp_subflow_data_available(struct sock *sk)
 	if (subflow->map_valid &&
 	    mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len) {
 		subflow->map_valid = 0;
-		WRITE_ONCE(subflow->data_avail, 0);
+		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
 
 		pr_debug("Done with mapping: seq=%u data_len=%u",
 			 subflow->map_subflow_seq,
-- 
2.35.1

