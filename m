Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CBF31A809
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhBLWsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:48:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:44262 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232396AbhBLWpW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:45:22 -0500
IronPort-SDR: i4xUdFSyGS6FH13/DTaHZ0+xzEbb66EjnbspihuttyA9vI//girvC6tBHiwS4Sv8CBwLQqrlza
 LCqdfARLrFOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="169617165"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="169617165"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 14:39:01 -0800
IronPort-SDR: 5ZhBt5i1OnxoPd4OO3NwdN+rZfAlY3pQruhk31TLvaj8UERPkpiIofGZwCqHyA6NtbjK1oNH9R
 jB6p4bkq0HxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="381885381"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 14:39:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 08/11] i40e: Simplify the do-while allocation loop
Date:   Fri, 12 Feb 2021 14:39:49 -0800
Message-Id: <20210212223952.1172568-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
References: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Fold the count decrement into the while-statement.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 470b8600adb1..4f11f7bf75d1 100644
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
 	if (rx_ring->next_to_use != ntu) {
-- 
2.26.2

