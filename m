Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1F64B7D54
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343552AbiBPCMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:12:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbiBPCLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:11:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C27413F66
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644977502; x=1676513502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9coNeKhRTejFQymmRpYR46T6Esk/19HCpyspAWEHY5w=;
  b=QH5Y5/47GhyOQewE48dabXQSWVMay/Gc4RHhDT3ygcdvdbYgiSl92VVD
   vyYZznKk7URcrmv9grFhBEMG1dtbA9hud4RQ1H0/qbkeVLD1Oq9+vj+CK
   4TEJtBA5wrl9kSyRemel3+6gzha4elMdEck1HtgbDrFnGwjP7JeqTsFmQ
   K0O3lu2tViGGW1wPPZYpuAo9mSs8+XSjbiYdmVdIaURfe7163Sd7PhFcX
   TgrCFIueBhvOMNF8ApDItzJE81uQcttvoeh5rPMlRzE7GFSrrWjjJ/cbL
   om+Br+4M7JNJXOICTaGmC9/vAx69RwkEVWZm0CJ4G6FbtkN4CCkFBFB8U
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237909079"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="237909079"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="571088823"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/8] mptcp: drop port parameter of mptcp_pm_add_addr_signal
Date:   Tue, 15 Feb 2022 18:11:27 -0800
Message-Id: <20220216021130.171786-6-mathew.j.martineau@linux.intel.com>
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

Drop the port parameter of mptcp_pm_add_addr_signal() and reflect it to
avoid passing too many parameters.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 5 ++---
 net/mptcp/pm.c       | 7 ++++---
 net/mptcp/protocol.h | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 5a14420b77c8..ac10a04ccd7c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -652,7 +652,6 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	bool drop_other_suboptions = false;
 	unsigned int opt_size = *size;
 	bool echo;
-	bool port;
 	int len;
 
 	/* add addr will strip the existing options, be sure to avoid breaking
@@ -661,12 +660,12 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	if (!mptcp_pm_should_add_signal(msk) ||
 	    (opts->suboptions & (OPTION_MPTCP_MPJ_ACK | OPTION_MPTCP_MPC_ACK)) ||
 	    !mptcp_pm_add_addr_signal(msk, skb, opt_size, remaining, &opts->addr,
-		    &echo, &port, &drop_other_suboptions))
+		    &echo, &drop_other_suboptions))
 		return false;
 
 	if (drop_other_suboptions)
 		remaining += opt_size;
-	len = mptcp_add_addr_len(opts->addr.family, echo, port);
+	len = mptcp_add_addr_len(opts->addr.family, echo, !!opts->addr.port);
 	if (remaining < len)
 		return false;
 
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 696b2c4613a7..ef6e4adeb0e5 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -278,11 +278,12 @@ void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, struct sk_buff *skb,
 			      unsigned int opt_size, unsigned int remaining,
 			      struct mptcp_addr_info *addr, bool *echo,
-			      bool *port, bool *drop_other_suboptions)
+			      bool *drop_other_suboptions)
 {
 	int ret = false;
 	u8 add_addr;
 	u8 family;
+	bool port;
 
 	spin_lock_bh(&msk->pm.lock);
 
@@ -300,10 +301,10 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, struct sk_buff *skb,
 	}
 
 	*echo = mptcp_pm_should_add_signal_echo(msk);
-	*port = !!(*echo ? msk->pm.remote.port : msk->pm.local.port);
+	port = !!(*echo ? msk->pm.remote.port : msk->pm.local.port);
 
 	family = *echo ? msk->pm.remote.family : msk->pm.local.family;
-	if (remaining < mptcp_add_addr_len(family, *echo, *port))
+	if (remaining < mptcp_add_addr_len(family, *echo, port))
 		goto out_unlock;
 
 	if (*echo) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a23694ad69e7..e381054910d0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -818,7 +818,7 @@ static inline int mptcp_rm_addr_len(const struct mptcp_rm_list *rm_list)
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, struct sk_buff *skb,
 			      unsigned int opt_size, unsigned int remaining,
 			      struct mptcp_addr_info *addr, bool *echo,
-			      bool *port, bool *drop_other_suboptions);
+			      bool *drop_other_suboptions);
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
-- 
2.35.1

