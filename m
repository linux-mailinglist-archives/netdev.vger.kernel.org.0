Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4244C6606BF
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbjAFS6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbjAFS5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:57:42 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3182880AC2
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673031459; x=1704567459;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ReSnxVQ1DJz8unos+JBlWooMIESUVrgKBmg+G6yDpuc=;
  b=kas2vBOecGQ80y6UcxWxusD9gK5875LK0vFfCtAloSFk7H+cmxGJga2r
   7gWKYPfORS4E8feZJFynMpX9se92eF3+RwbXKONMSdKPmM/6h+t2NKNfr
   vTSOYTA7MwYur+Kt+QpY9Gu8AUQkivsTPJl1GpENCBSBQ3eOE+F5NSHER
   ldI8jdCgG0PRPpfQDYTBKUZrpgstIA+iAgpPWIH1utu9STfEk6WLXCsLX
   cEuVXCgeY9aHhrezMkHDBzcb+tvJ5CbBDwORZ1CpgEjozuq2beHRmhOJm
   RAwzvGGBxuR77tPsCeAvSiU1weqrJ/IHAWKs+lwoKmMTpDyYeE8KY2wL/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="322611239"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="322611239"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="688383433"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="688383433"
Received: from mechevar-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.63])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:34 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Menglong Dong <imagedong@tencent.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/9] mptcp: rename 'sk' to 'ssk' in mptcp_token_new_connect()
Date:   Fri,  6 Jan 2023 10:57:22 -0800
Message-Id: <20230106185725.299977-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
References: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

'ssk' should be more appropriate to be the name of the first argument
in mptcp_token_new_connect().

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.h | 2 +-
 net/mptcp/token.c    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a0d1658ce59e..5a8af5657796 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -754,7 +754,7 @@ static inline void mptcp_token_init_request(struct request_sock *req)
 
 int mptcp_token_new_request(struct request_sock *req);
 void mptcp_token_destroy_request(struct request_sock *req);
-int mptcp_token_new_connect(struct sock *sk);
+int mptcp_token_new_connect(struct sock *ssk);
 void mptcp_token_accept(struct mptcp_subflow_request_sock *r,
 			struct mptcp_sock *msk);
 bool mptcp_token_exists(u32 token);
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 65430f314a68..3af502a374bc 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -134,7 +134,7 @@ int mptcp_token_new_request(struct request_sock *req)
 
 /**
  * mptcp_token_new_connect - create new key/idsn/token for subflow
- * @sk: the socket that will initiate a connection
+ * @ssk: the socket that will initiate a connection
  *
  * This function is called when a new outgoing mptcp connection is
  * initiated.
@@ -148,9 +148,9 @@ int mptcp_token_new_request(struct request_sock *req)
  *
  * returns 0 on success.
  */
-int mptcp_token_new_connect(struct sock *sk)
+int mptcp_token_new_connect(struct sock *ssk)
 {
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	int retries = MPTCP_TOKEN_MAX_RETRIES;
 	struct token_bucket *bucket;
@@ -169,7 +169,7 @@ int mptcp_token_new_connect(struct sock *sk)
 	}
 
 	pr_debug("ssk=%p, local_key=%llu, token=%u, idsn=%llu\n",
-		 sk, subflow->local_key, subflow->token, subflow->idsn);
+		 ssk, subflow->local_key, subflow->token, subflow->idsn);
 
 	WRITE_ONCE(msk->token, subflow->token);
 	__sk_nulls_add_node_rcu((struct sock *)msk, &bucket->msk_chain);
-- 
2.39.0

