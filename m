Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0892B390B46
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 23:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhEYVZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 17:25:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:35473 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232965AbhEYVYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 17:24:53 -0400
IronPort-SDR: OJlvI3oiHHX7FSmlLRcv/pBelaDraUn9afhajXxOsx78uDfeV8SQAp5ApkT1NleUkRzamVpBLU
 L+pn020gyTyw==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="202062429"
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="202062429"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:20 -0700
IronPort-SDR: Xs+q2exyrhm3BZhvcVzN3KAfffl8ch4p/ndb/HjdBTtB0ja8s9aXhdoLuryOXuTkemxyOBPa4d
 kv4Ugrp09srA==
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="546924974"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.216.142])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/4] mptcp: avoid error message on infinite mapping
Date:   Tue, 25 May 2021 14:23:12 -0700
Message-Id: <20210525212313.148142-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
References: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Another left-over. Avoid flooding dmesg with useless text,
we already have a MIB for that event.

Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a5ede357cfbc..bde6be77ea73 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -867,7 +867,6 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 
 	data_len = mpext->data_len;
 	if (data_len == 0) {
-		pr_err("Infinite mapping not handled");
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_INFINITEMAPRX);
 		return MAPPING_INVALID;
 	}
-- 
2.31.1

