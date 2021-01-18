Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3EB2FA499
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405645AbhARPZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:25:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:63478 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390745AbhARPYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:24:54 -0500
IronPort-SDR: WMzbcqEwnbeavvirUfhfwaplWD+pGwRuRQL6Y59wB5AXz+TmG3BdT1W419q61nw+NOAIvK52k0
 hsGUmXjLL9mA==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165905537"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="165905537"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 07:23:11 -0800
IronPort-SDR: MmXoUGZmd9k38JI/TnhxVUKTuP9rclFCNQmm/eZC9b9p2TgdDIi4Ad/K5fYzxXYr088JRzdi6p
 78KolVSjnsCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="500676375"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2021 07:23:09 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 net-next 08/11] i40e, xsk: Simplify the do-while allocation loop
Date:   Mon, 18 Jan 2021 16:13:15 +0100
Message-Id: <20210118151318.12324-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
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
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 47eb9c584a12..457ce365a007 100644
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
2.20.1

