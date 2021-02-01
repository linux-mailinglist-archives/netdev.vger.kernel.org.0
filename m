Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F6A30B338
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhBAXPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:15:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:51849 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhBAXPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 18:15:15 -0500
IronPort-SDR: xK7KWCrevEbyAsGISElkClFUBn8cRdlIE3Mbe5+Uacw3SrBFaNeZCEBtMSOLkCPFv+CJYCcu0+
 3nAiX1EBpH7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="159934342"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="159934342"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:27 -0800
IronPort-SDR: Oy9rvc61/AiP+Lsx1AcqopgAVeZfpL7iWg6c7LLK2G5S40s7WZaZoh/+kZD0ihOKZ+yEC1z/YM
 Y+nX7hHhGTqg==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="391188472"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.7.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:27 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 08/15] mptcp: drop unused skb in subflow_token_join_request
Date:   Mon,  1 Feb 2021 15:09:13 -0800
Message-Id: <20210201230920.66027-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
References: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
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

