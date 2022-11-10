Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD637624E68
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiKJXXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKJXXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:23:31 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B667813CFB
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668122610; x=1699658610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=08INuczsVucp5wVRZ+rv6X4otGbIrUIqPbdYPU3peQ4=;
  b=kdunJhHkmhdjmhLOAFljEBMV1/cgDUvYpZfZl1HkYqauC+HvES6v9Ilt
   kIYg2NZXUqaK67TkmJVRuDcGMHF7dUkWewhLe/lqjwe2xrdgRfQTZhrB8
   ooHpBbpLF7+y9gHDuKeMfH6n0tBrX1UrzRWzXqX9kQSNZY9bXa74nZ2yE
   w9A4RHd+PM81vfdgfp8HZwxmta6cPKANX9dcK0moq7qPtW1z04gm4GxJX
   q/EAIexgGUbXrLS3lY4EUR4RJERzit8uEpTINHD3YKlW41VPMaHVcUAjh
   GyHJRNbNM4+suUOHimDiQbIUF8AdNnVs0DXlYNKner0Guk66DYUrGI1Hc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="309093984"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="309093984"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="637367369"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="637367369"
Received: from jsandova-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.81.89])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 15:23:29 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/5] mptcp: use msk instead of mptcp_sk
Date:   Thu, 10 Nov 2022 15:23:18 -0800
Message-Id: <20221110232322.125068-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
References: <20221110232322.125068-1-mathew.j.martineau@linux.intel.com>
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

From: Geliang Tang <geliang.tang@suse.com>

Use msk instead of mptcp_sk(sk) in the functions where the variable
"msk = mptcp_sk(sk)" has been defined.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 109eea2c65ff..64d7070de901 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1625,7 +1625,7 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 			 * check for a different subflow usage only after
 			 * spooling the first chunk of data
 			 */
-			xmit_ssk = first ? ssk : mptcp_subflow_get_send(mptcp_sk(sk));
+			xmit_ssk = first ? ssk : mptcp_subflow_get_send(msk);
 			if (!xmit_ssk)
 				goto out;
 			if (xmit_ssk != ssk) {
@@ -2275,7 +2275,7 @@ bool __mptcp_retransmit_pending_data(struct sock *sk)
 	struct mptcp_data_frag *cur, *rtx_head;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (__mptcp_check_fallback(mptcp_sk(sk)))
+	if (__mptcp_check_fallback(msk))
 		return false;
 
 	if (tcp_rtx_and_write_queues_empty(sk))
@@ -2949,7 +2949,7 @@ bool __mptcp_close(struct sock *sk, long timeout)
 
 	sock_hold(sk);
 	pr_debug("msk=%p state=%d", sk, sk->sk_state);
-	if (mptcp_sk(sk)->token)
+	if (msk->token)
 		mptcp_event(MPTCP_EVENT_CLOSED, msk, NULL, GFP_KERNEL);
 
 	if (sk->sk_state == TCP_CLOSE) {
@@ -3008,8 +3008,8 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	mptcp_stop_timer(sk);
 	sk_stop_timer(sk, &sk->sk_timer);
 
-	if (mptcp_sk(sk)->token)
-		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
+	if (msk->token)
+		mptcp_event(MPTCP_EVENT_CLOSED, msk, NULL, GFP_KERNEL);
 
 	/* msk->subflow is still intact, the following will not free the first
 	 * subflow
-- 
2.38.1

