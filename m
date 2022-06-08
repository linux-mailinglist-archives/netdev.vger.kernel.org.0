Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2130C543CB1
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 21:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbiFHTTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 15:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbiFHTTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 15:19:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAB93BF9D
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 12:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654715972; x=1686251972;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ypaTwO0pQdtrccJnIA7clYfA5CtbDAy0cfvBFehY6Fg=;
  b=mEnTP61NyJC6Ss7aRKt8YnbJVodSkCLYIYMY0HWyjGiaqbSqAx/9jHjs
   rm44oA2kYJ6HrRfv2KzTnBxczpOgLYQrTHEoFbxykxLPTfGZCd4Qw6W0/
   OQzuOoK0RaAIb5ZbLj/L0z777VO8oZle1cnOeAaj6dYFQu/2tUSyGapAE
   rknqks5u1vQGyeE8/eaezZ87Znmy1NpsQ+KXSWVfhecklNFiIlbflSaj7
   OSi5A9dmADPJaMvlbthIn2sDj53Cxthqp+Wj0Dd17yxr/42xBwrZMoPkT
   wEVlh8Tq+urvMgzfjH6BSkrMVRX7YAN+hGF+OsKt3+nD0YN+nX0JtWBHt
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="257442774"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="257442774"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 12:19:29 -0700
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="580206810"
Received: from pperi-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.138.161])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 12:19:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/2] mptcp: move MPTCPOPT_HMAC_LEN to net/mptcp.h
Date:   Wed,  8 Jun 2022 12:19:19 -0700
Message-Id: <20220608191919.327705-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608191919.327705-1-mathew.j.martineau@linux.intel.com>
References: <20220608191919.327705-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Move macro MPTCPOPT_HMAC_LEN definition from net/mptcp/protocol.h to
include/net/mptcp.h.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h  | 3 ++-
 net/mptcp/protocol.h | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 4d761ad530c9..ac9cf7271d46 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -39,6 +39,7 @@ struct mptcp_ext {
 			infinite_map:1;
 };
 
+#define MPTCPOPT_HMAC_LEN	20
 #define MPTCP_RM_IDS_MAX	8
 
 struct mptcp_rm_list {
@@ -89,7 +90,7 @@ struct mptcp_out_options {
 			u32 nonce;
 			u32 token;
 			u64 thmac;
-			u8 hmac[20];
+			u8 hmac[MPTCPOPT_HMAC_LEN];
 		};
 	};
 #endif
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 200f89f6d62f..8f03775a2f22 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -83,7 +83,6 @@
 
 /* MPTCP MP_JOIN flags */
 #define MPTCPOPT_BACKUP		BIT(0)
-#define MPTCPOPT_HMAC_LEN	20
 #define MPTCPOPT_THMAC_LEN	8
 
 /* MPTCP MP_CAPABLE flags */
-- 
2.36.1

