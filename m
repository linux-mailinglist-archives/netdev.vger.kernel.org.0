Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1412C2D7C
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbgKXQxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:53:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:45927 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390673AbgKXQxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:53:06 -0500
IronPort-SDR: haOgHf3gVNwQ1RLqGJ27Kwzo+Pbu+WxSIrQZgxRX+IBHQeMaF9tIkp9uTJ4ws6gCSaxbqpIeJL
 EKyeEu8kyp4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="172134513"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="172134513"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 08:53:05 -0800
IronPort-SDR: lKiIlK+tVwo/ZIt5e08G44/AOf8BZ9ADRBaY6BvXi2DZX2c2lAOtMZ0Tlsk6eN2yyaXzaR25/N
 nwJzasFn8G+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="365068656"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2020 08:53:05 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Marek Majtyka <marekx.majtyka@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [net-next v2 1/3] i40e: remove redundant assignment
Date:   Tue, 24 Nov 2020 08:52:43 -0800
Message-Id: <20201124165245.2844118-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124165245.2844118-1-anthony.l.nguyen@intel.com>
References: <20201124165245.2844118-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Remove a redundant assignment of the software ring pointer in the i40e
driver. The variable is assigned twice with no use in between, so just
get rid of the first occurrence.

Fixes: 3b4f0b66c2b3 ("i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 567fd67e900e..67febc7b6798 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -311,7 +311,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 			continue;
 		}
 
-		bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 		size = (qword & I40E_RXD_QW1_LENGTH_PBUF_MASK) >>
 		       I40E_RXD_QW1_LENGTH_PBUF_SHIFT;
 		if (!size)
-- 
2.26.2

