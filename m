Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1843E0596
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhHDQNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 12:13:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:7251 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234064AbhHDQNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 12:13:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="193547287"
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="193547287"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 09:11:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="569083207"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2021 09:11:05 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 1/4] net: wwan: iosm: fix lkp buildbot warning
Date:   Wed,  4 Aug 2021 21:39:49 +0530
Message-Id: <20210804160952.70254-2-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
References: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct td buffer type casting & format specifier to fix lkp buildbot
warning.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
index 91109e27efd3..35d590743d3a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
@@ -412,8 +412,8 @@ struct sk_buff *ipc_protocol_dl_td_process(struct iosm_protocol *ipc_protocol,
 	}
 
 	if (p_td->buffer.address != IPC_CB(skb)->mapping) {
-		dev_err(ipc_protocol->dev, "invalid buf=%p or skb=%p",
-			(void *)p_td->buffer.address, skb->data);
+		dev_err(ipc_protocol->dev, "invalid buf=%llx or skb=%p",
+			(unsigned long long)p_td->buffer.address, skb->data);
 		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
 		skb = NULL;
 		goto ret;
-- 
2.25.1

