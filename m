Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBB75625F4
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 00:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiF3WST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 18:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiF3WSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 18:18:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFC95723A
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656627485; x=1688163485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kficdG33KB5IFb2Wh6Gc/zp7DW5LVB1zb0myAwDVGow=;
  b=CSwUk8zdoE/L8dSAuz4CUUpWxmhyF0P7OE0kaIiHtm79CgzNup26j6mu
   Usib+W+RWMw98IlRrLqOXKxmpYG/gb0ApjK8GkWTq9X8n+bkRj0gm4sgD
   D7jWpB3mzQQcPgEGj92BZ8i45PvRSJY/GOI37ktdHMe2tQwFw5p4cCr9u
   O3KRXq/3WmCgzQ+iXyqPnbNTN3lzZGMR30qTnB13pX8W85Z8Xdf2WEWHf
   M1TVRB7iirvM3nAmepOOczRCMjJ8bPdncUEq7xdXN5UAu7H1/0Sb+ZekE
   u3iHEBYhC0hBWHRDnvBc2s+y6y6GghEyYMNhi6AcsVZsxpaKSlSKs/15g
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="283583510"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="283583510"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="733804543"
Received: from mhtran-desk5.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.176.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:18:02 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/4] net: remove SK_RECLAIM_THRESHOLD and SK_RECLAIM_CHUNK
Date:   Thu, 30 Jun 2022 15:17:57 -0700
Message-Id: <20220630221757.763751-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630221757.763751-1-mathew.j.martineau@linux.intel.com>
References: <20220630221757.763751-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

There are no more users for the mentioned macros, just
drop them.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/sock.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 40bbd0e8925b..0dd43c3df49b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1619,11 +1619,6 @@ static inline void sk_mem_charge(struct sock *sk, int size)
 	sk->sk_forward_alloc -= size;
 }
 
-/* the following macros control memory reclaiming in mptcp_rmem_uncharge()
- */
-#define SK_RECLAIM_THRESHOLD	(1 << 21)
-#define SK_RECLAIM_CHUNK	(1 << 20)
-
 static inline void sk_mem_uncharge(struct sock *sk, int size)
 {
 	if (!sk_has_account(sk))
-- 
2.37.0

