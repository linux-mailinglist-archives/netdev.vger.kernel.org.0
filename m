Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5C74B7D6E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbiBPCLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:11:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343548AbiBPCLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:11:52 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F102B22503
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644977501; x=1676513501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MA9QxId7X9d5GQsDAfk2riHjF8ntAdWskyCHH8+Bcyc=;
  b=kHTDeOdvNGVXxLwAE9hdrk5u/EFSUqCizM/LVhFrC0AE1kEFJiIHBSOf
   zl1qm5AX/7QowXBMwpEwKMtLn4Nz0Qy4Pmc7CFA7bhILrE7JC8XJFzFlw
   bnDtJONiXsuM87DWPiuG1xkqkSx8gVPP43y/V8wV8plNodsN7c3h3Q05S
   pAO7zWiSHQb6CBUyAADu1TswRqZw7GgVs3QZY4P/GRv4586OH8uSbNgkA
   pHdtsjXMG4YHfxvurR4G8uQ/5phCkXwZNP0S07IZrJmOCwj/juLWoy+Ti
   X1VxoVkKHfU/r+Eao2pTPyY2uqJ7bqOEy8iG0vRHMSTXacMgIr3z4fSs3
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237909074"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="237909074"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="571088819"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 3/8] mptcp: drop unused sk in mptcp_get_options
Date:   Tue, 15 Feb 2022 18:11:25 -0800
Message-Id: <20220216021130.171786-4-mathew.j.martineau@linux.intel.com>
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

The parameter 'sk' became useless since the code using it was dropped
from mptcp_get_options() in the commit 8d548ea1dd15 ("mptcp: do not set
unconditionally csum_reqd on incoming opt"). Let's drop it.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/options.c  |  5 ++---
 net/mptcp/protocol.h |  3 +--
 net/mptcp/subflow.c  | 10 +++++-----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 3e82ac24d548..a10536d7c84b 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -355,8 +355,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 	}
 }
 
-void mptcp_get_options(const struct sock *sk,
-		       const struct sk_buff *skb,
+void mptcp_get_options(const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
@@ -1114,7 +1113,7 @@ bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 		return true;
 	}
 
-	mptcp_get_options(sk, skb, &mp_opt);
+	mptcp_get_options(skb, &mp_opt);
 
 	/* The subflow can be in close state only if check_fully_established()
 	 * just sent a reset. If so, tell the caller to ignore the current packet.
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 85317ce38e3f..a23694ad69e7 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -643,8 +643,7 @@ int __init mptcp_proto_v6_init(void);
 struct sock *mptcp_sk_clone(const struct sock *sk,
 			    const struct mptcp_options_received *mp_opt,
 			    struct request_sock *req);
-void mptcp_get_options(const struct sock *sk,
-		       const struct sk_buff *skb,
+void mptcp_get_options(const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt);
 
 void mptcp_finish_connect(struct sock *sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bea47a1180dc..0d6a4109add1 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -153,7 +153,7 @@ static int subflow_check_req(struct request_sock *req,
 		return -EINVAL;
 #endif
 
-	mptcp_get_options(sk_listener, skb, &mp_opt);
+	mptcp_get_options(skb, &mp_opt);
 
 	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
 	opt_mp_join = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ);
@@ -250,7 +250,7 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	int err;
 
 	subflow_init_req(req, sk_listener);
-	mptcp_get_options(sk_listener, skb, &mp_opt);
+	mptcp_get_options(skb, &mp_opt);
 
 	opt_mp_capable = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPC);
 	opt_mp_join = !!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ);
@@ -410,7 +410,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
 	pr_debug("subflow=%p synack seq=%x", subflow, subflow->ssn_offset);
 
-	mptcp_get_options(sk, skb, &mp_opt);
+	mptcp_get_options(skb, &mp_opt);
 	if (subflow->request_mptcp) {
 		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC)) {
 			MPTCP_INC_STATS(sock_net(sk),
@@ -663,7 +663,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		 * reordered MPC will cause fallback, but we don't have other
 		 * options.
 		 */
-		mptcp_get_options(sk, skb, &mp_opt);
+		mptcp_get_options(skb, &mp_opt);
 		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC)) {
 			fallback = true;
 			goto create_child;
@@ -673,7 +673,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		if (!new_msk)
 			fallback = true;
 	} else if (subflow_req->mp_join) {
-		mptcp_get_options(sk, skb, &mp_opt);
+		mptcp_get_options(skb, &mp_opt);
 		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ) ||
 		    !subflow_hmac_valid(req, &mp_opt) ||
 		    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
-- 
2.35.1

