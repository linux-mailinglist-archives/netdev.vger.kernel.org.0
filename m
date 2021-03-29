Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F34334D5B8
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhC2RIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:08:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:51878 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhC2RH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:07:59 -0400
IronPort-SDR: PgvnNzpsr9QGjDFAPKANbbSdy0sPT2cnmOX2i3gq9iwtNuEt7Cgd3Qnw6L6E4AA6UItDtIIxWK
 Me+BQm4u7dwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="178720124"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="178720124"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 10:07:58 -0700
IronPort-SDR: P1soWp18uyTCqvcKYHvYo1iMdK7MD53KJZxBFadL7zotV/I2zynepWSrvnLPT8HfwF+JE+m4jK
 chZLZJRvve5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="606447254"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2021 10:07:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 1/8] igc: Remove unused argument from igc_tx_cmd_type()
Date:   Mon, 29 Mar 2021 10:09:24 -0700
Message-Id: <20210329170931.2356162-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
References: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The 'skb' argument from igc_tx_cmd_type() is not used so remove it.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index baa45a1f3a65..e1e38d797f29 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1029,7 +1029,7 @@ static inline int igc_maybe_stop_tx(struct igc_ring *tx_ring, const u16 size)
 	 ((u32)((_input) & (_flag)) * ((_result) / (_flag))) :	\
 	 ((u32)((_input) & (_flag)) / ((_flag) / (_result))))
 
-static u32 igc_tx_cmd_type(struct sk_buff *skb, u32 tx_flags)
+static u32 igc_tx_cmd_type(u32 tx_flags)
 {
 	/* set type for advanced descriptor with frame checksum insertion */
 	u32 cmd_type = IGC_ADVTXD_DTYP_DATA |
@@ -1078,7 +1078,7 @@ static int igc_tx_map(struct igc_ring *tx_ring,
 	u16 i = tx_ring->next_to_use;
 	unsigned int data_len, size;
 	dma_addr_t dma;
-	u32 cmd_type = igc_tx_cmd_type(skb, tx_flags);
+	u32 cmd_type = igc_tx_cmd_type(tx_flags);
 
 	tx_desc = IGC_TX_DESC(tx_ring, i);
 
-- 
2.26.2

