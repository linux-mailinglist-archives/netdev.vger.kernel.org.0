Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5632D9AE2
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgLNPYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:24:43 -0500
Received: from mga17.intel.com ([192.55.52.151]:28673 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408356AbgLNPYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 10:24:12 -0500
IronPort-SDR: 0ZIPLNF+c/k8CKq3GSZIgg8c4P+OKZLUU2wX04xENfLKO04upCeA4j4VTIg7r9xVOVHa5VLRGe
 KR+VorUbn00Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9834"; a="154531366"
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="154531366"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 07:23:11 -0800
IronPort-SDR: ctp9ScIgn6YcqGCvrAdH0QTDHWYEnWb8z+6R82dHgYTMKJNdwk7MX1I1sr2oCNFG/QFVtwkE+L
 1WnJpaF38FWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="411285763"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 14 Dec 2020 07:23:09 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: [PATCH v2 net-next 8/8] i40e, xsk: Simplify the do-while allocation loop
Date:   Mon, 14 Dec 2020 16:13:08 +0100
Message-Id: <20201214151308.15275-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201214151308.15275-1-maciej.fijalkowski@intel.com>
References: <20201214151308.15275-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Fold the count decrement into the while-statement.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index bfa84bfb0488..679200d94ef8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -215,9 +215,7 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 			bi = i40e_rx_bi(rx_ring, 0);
 			ntu = 0;
 		}
-
-		count--;
-	} while (count);
+	} while (--count);
 
 no_buffers:
 	if (rx_ring->next_to_use != ntu)
-- 
2.20.1

