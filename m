Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D215468B87
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhLEPAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 10:00:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:20582 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234836AbhLEPAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 10:00:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="237132490"
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="237132490"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 06:57:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="514507289"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2021 06:57:04 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH V2 net-next 2/7] net: wwan: iosm: set tx queue len
Date:   Sun,  5 Dec 2021 20:34:50 +0530
Message-Id: <20211205150455.1829929-3-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
References: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set wwan net dev tx queue len to DEFAULT_TX_QUEUE_LEN.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
v2: Use the common DEFAULT_TX_QUEUE_LEN macro instead of defining the new macro
    for tx queue length.
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index b571d9cedba4..27151148c782 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -8,6 +8,7 @@
 #include <linux/if_link.h>
 #include <linux/rtnetlink.h>
 #include <linux/wwan.h>
+#include <net/pkt_sched.h>

 #include "iosm_ipc_chnl_cfg.h"
 #include "iosm_ipc_imem_ops.h"
@@ -159,7 +160,7 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
 {
 	iosm_dev->header_ops = NULL;
 	iosm_dev->hard_header_len = 0;
-	iosm_dev->priv_flags |= IFF_NO_QUEUE;
+	iosm_dev->tx_queue_len = DEFAULT_TX_QUEUE_LEN;

 	iosm_dev->type = ARPHRD_NONE;
 	iosm_dev->mtu = ETH_DATA_LEN;
--
2.25.1

