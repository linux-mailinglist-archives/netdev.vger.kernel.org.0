Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055914CDE85
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiCDUEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiCDUEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:04:15 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADE824893B
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423960; x=1677959960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MHl3tFpaN+fsU4kfWcfNbKp6jA3RKOG/3r8nwwPkxZQ=;
  b=TYdU4EhbSm5JDfunkAs41DV8D/VLpyTnOEDIGLCI6NPQq7goOFUiVdhe
   2a8zu9V5SCgZAZIxH+UrQUv5xgmuRZdEt4iAE+QQ1NF/7LKNn1TUvuFj9
   nMe5LLZFvJ02hAD416g0gPbXr/8bgRha/i40AoSPZDUAmtgFpH/EI3yD8
   TuxJDAz9W67wWL6VAycPA/un1+ZbUvNj93mH7+zgxUGSy0MW8GjPJe9bM
   qfZWiZGkNliGK4CmBlXEAQcMR2tzSvLdhfwN3DMszzEfXdrpgEtMjuOWR
   IYbIV17MrPO+/YkzP3vvgA8n9H/13tCu7c1ZdPgF0YS8Lq/5FF+RQcdc+
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981333"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981333"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340784"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/11] mptcp: add the mibs for MP_RST
Date:   Fri,  4 Mar 2022 11:36:29 -0800
Message-Id: <20220304193636.219315-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
References: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
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

From: Geliang Tang <geliang.tang@suse.com>

This patch added two more mibs for MP_RST, MPTCP_MIB_MPRSTTX for
the MP_RST sending and MPTCP_MIB_MPRSTRX for the MP_RST receiving.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c     | 2 ++
 net/mptcp/mib.h     | 2 ++
 net/mptcp/options.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 975d17118bfe..e55d3dfbee0c 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -50,6 +50,8 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("MPFailRx", MPTCP_MIB_MPFAILRX),
 	SNMP_MIB_ITEM("MPFastcloseTx", MPTCP_MIB_MPFASTCLOSETX),
 	SNMP_MIB_ITEM("MPFastcloseRx", MPTCP_MIB_MPFASTCLOSERX),
+	SNMP_MIB_ITEM("MPRstTx", MPTCP_MIB_MPRSTTX),
+	SNMP_MIB_ITEM("MPRstRx", MPTCP_MIB_MPRSTRX),
 	SNMP_MIB_ITEM("RcvPruned", MPTCP_MIB_RCVPRUNED),
 	SNMP_MIB_ITEM("SubflowStale", MPTCP_MIB_SUBFLOWSTALE),
 	SNMP_MIB_ITEM("SubflowRecover", MPTCP_MIB_SUBFLOWRECOVER),
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 8206c65297e0..00576179a619 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -43,6 +43,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_MPFAILRX,		/* Received a MP_FAIL */
 	MPTCP_MIB_MPFASTCLOSETX,	/* Transmit a MP_FASTCLOSE */
 	MPTCP_MIB_MPFASTCLOSERX,	/* Received a MP_FASTCLOSE */
+	MPTCP_MIB_MPRSTTX,		/* Transmit a MP_RST */
+	MPTCP_MIB_MPRSTRX,		/* Received a MP_RST */
 	MPTCP_MIB_RCVPRUNED,		/* Incoming packet dropped due to memory limit */
 	MPTCP_MIB_SUBFLOWSTALE,		/* Subflows entered 'stale' status */
 	MPTCP_MIB_SUBFLOWRECOVER,	/* Subflows returned to active status after being stale */
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index c3697f06faf9..325383646f5c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -839,6 +839,7 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 		if (mptcp_established_options_rst(sk, skb, &opt_size, remaining, opts)) {
 			*size += opt_size;
 			remaining -= opt_size;
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPRSTTX);
 		}
 		return true;
 	}
@@ -1161,6 +1162,7 @@ bool mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 			subflow->reset_seen = 1;
 			subflow->reset_reason = mp_opt.reset_reason;
 			subflow->reset_transient = mp_opt.reset_transient;
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPRSTRX);
 		}
 
 		if (!(mp_opt.suboptions & OPTION_MPTCP_DSS))
-- 
2.35.1

