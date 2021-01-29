Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0B230831F
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhA2BRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:17:35 -0500
Received: from mga07.intel.com ([134.134.136.100]:6700 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231287AbhA2BRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:17:32 -0500
IronPort-SDR: DCkaFFJg/b3lwMbtECbZGbJMEjqMeKXbP0/8e8P0DGwLTxu0i5Zk+RmS7QeCC9ffLT2AHkeKyJ
 /RSVf8jCGnpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430174"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430174"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
IronPort-SDR: l6ZLyBNSb+Fkq9YetACVAJBBfDYmCRzwWyQpuMJPizM5WI+nESo+jY5I67Ux86vtBmDKiXvSjE
 c/mwCgRMa5Yw==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538334"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/16] mptcp: drop unused skb in subflow_token_join_request
Date:   Thu, 28 Jan 2021 17:11:07 -0800
Message-Id: <20210129011115.133953-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch drops the unused parameter skb in subflow_token_join_request.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 50a01546ac34..2dcc0fb5a69e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -64,8 +64,7 @@ static bool mptcp_can_accept_new_subflow(const struct mptcp_sock *msk)
 }
 
 /* validate received token and create truncated hmac and nonce for SYN-ACK */
-static struct mptcp_sock *subflow_token_join_request(struct request_sock *req,
-						     const struct sk_buff *skb)
+static struct mptcp_sock *subflow_token_join_request(struct request_sock *req)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
 	u8 hmac[SHA256_DIGEST_SIZE];
@@ -181,7 +180,7 @@ static int subflow_init_req(struct request_sock *req,
 		subflow_req->remote_id = mp_opt.join_id;
 		subflow_req->token = mp_opt.token;
 		subflow_req->remote_nonce = mp_opt.nonce;
-		subflow_req->msk = subflow_token_join_request(req, skb);
+		subflow_req->msk = subflow_token_join_request(req);
 
 		/* Can't fall back to TCP in this case. */
 		if (!subflow_req->msk)
-- 
2.30.0

