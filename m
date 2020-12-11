Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80EB2D7BE8
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404179AbgLKRCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:02:33 -0500
Received: from mga06.intel.com ([134.134.136.31]:8172 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392284AbgLKRAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 12:00:46 -0500
IronPort-SDR: 0Ma5hCUlEjNrqKOtRuQrEMwzKry4DS3wYECUZVBaYEZtT4z0drSPn17b0ijX3rgOBKSwG/NDI4
 xN7C9emBwUug==
X-IronPort-AV: E=McAfee;i="6000,8403,9832"; a="236055113"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="236055113"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 08:59:41 -0800
IronPort-SDR: a/edh5S++05OITw7g8Nm77D0CGanfPw213IMT96GmPop+iT5nqZFzkrar91MvZpaQuEbjE7Yuz
 bmo82Wcx/m8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="365497585"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2020 08:59:40 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: [PATCH net-next 8/8] i40e, xsk: Simplify the do-while allocation loop
Date:   Fri, 11 Dec 2020 17:49:56 +0100
Message-Id: <20201211164956.59628-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
References: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
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

