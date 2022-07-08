Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE37856BECA
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbiGHROU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbiGHROT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:14:19 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2E325C69
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 10:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657300459; x=1688836459;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wvwoov0ZtEtx5i1pjqAsOc7JoLHCC2rk2TZrjCa1l7A=;
  b=ChzUlCNbYf0+XCPbIukOJv0wT5B/lC+Jx+Ol+tIcVppbWFIUBidSCB7g
   ADmWN3xY0fRFBnWvXiBA/B4GxnNS0MHbXhu22ZFs9e961XgD2vXEkSRRe
   aKhYK7ZtIrdyG2oAOVG8JUNP0rTdvwtlOYUH/et3BVhmS79fPYFmcZPPO
   aIGLa1zDsNFBR48gDIJdgqoQryQU7dD8z7dGm310o/UB3rsn5qNZbPIjs
   +OlOvaHoWyoWa8Lqu9TcmSX6dlG/refx1S0z+IAQWRa45LeWUotzvPNwt
   yEu9fq9zmhQkAObO8SRJhluRwDtUc3IxHEzFmuNdSVYjdHx4CEPoVGTeW
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="267364236"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="267364236"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="651641497"
Received: from aroras-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.203])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:17 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/6] mptcp: move MPTCPOPT_HMAC_LEN to net/mptcp.h
Date:   Fri,  8 Jul 2022 10:14:08 -0700
Message-Id: <20220708171413.327112-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220708171413.327112-1-mathew.j.martineau@linux.intel.com>
References: <20220708171413.327112-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Move macro MPTCPOPT_HMAC_LEN definition from net/mptcp/protocol.h to
include/net/mptcp.h.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
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
index 480c5320b86e..07871e10e510 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -83,7 +83,6 @@
 
 /* MPTCP MP_JOIN flags */
 #define MPTCPOPT_BACKUP		BIT(0)
-#define MPTCPOPT_HMAC_LEN	20
 #define MPTCPOPT_THMAC_LEN	8
 
 /* MPTCP MP_CAPABLE flags */
-- 
2.37.0

