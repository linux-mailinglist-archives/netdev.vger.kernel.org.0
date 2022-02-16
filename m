Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDF44B7D55
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343557AbiBPCLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:11:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343549AbiBPCLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:11:52 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A6013F66
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644977501; x=1676513501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qrnYRmJrn6hTTdPY3q7FWl8XGYjIDPWqRW7s3SDCYxs=;
  b=R+Jepm33+vloR/X49uwixDj1CFQaGdlpoZm3SP98+QGns2We6sPM1+N+
   PKB0hHnxHlIDrfqwexcDZlzee1i2/fLaI9UgJrMXAYZOs+yd6u5GvUDdQ
   XowR3+J+gBv47r8ga10ds7GoFqKqnr6mOMPQM8a0WDQ9e2I15SIcCSI9V
   aeAATxELSH3IGbmQ99co7FQuWCxvGG0XgX/bLWgSTSY8ODPKrNis4Pw1G
   PkZdHgdEH5RInG8LW65KUmncMPHX3UgrsNClJfeQghMUItqVYavTF61d4
   JoK2g/KwPZVE8ixRekVtymZayKlPqGKdj9EKxjCV15BGzu7NLMXkp+6BL
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237909072"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="237909072"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="571088818"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:11:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/8] mptcp: mptcp_parse_option is no longer exported
Date:   Tue, 15 Feb 2022 18:11:24 -0800
Message-Id: <20220216021130.171786-3-mathew.j.martineau@linux.intel.com>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Options parsing in now done from mptcp_incoming_options().

mptcp_parse_option() has been removed from mptcp.h when CONFIG_MPTCP is
defined but not when it is not.

Fixes: cfde141ea3fa ("mptcp: move option parsing into mptcp_incoming_options()")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index a925349b4b89..0a3b0fb04a3b 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -217,12 +217,6 @@ static inline bool rsk_drop_req(const struct request_sock *req)
 	return false;
 }
 
-static inline void mptcp_parse_option(const struct sk_buff *skb,
-				      const unsigned char *ptr, int opsize,
-				      struct tcp_options_received *opt_rx)
-{
-}
-
 static inline bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 				     unsigned int *size,
 				     struct mptcp_out_options *opts)
-- 
2.35.1

