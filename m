Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C292B2988
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgKNALd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:11:33 -0500
Received: from mga17.intel.com ([192.55.52.151]:46584 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgKNALb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:11:31 -0500
IronPort-SDR: RoHBQOVzdAJ7istidffE7pmG6j0xON9QdgGniAZRQyiPfbLOcCFDDfh4q6c/pXSvXMTLjvBV6g
 TpdR4ouFC++g==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="150397827"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="150397827"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 16:11:26 -0800
IronPort-SDR: AdAeX0WxrCBV5ngU63vzz0SEfTBNPrp6Ssv/9kf6BE5bNkmx1PaD4QODpjtjIaNQXPkSwClAT4
 A/H2d+Ynd5uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="361505844"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 13 Nov 2020 16:11:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Marek Majtyka <marekx.majtyka@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [net-next 2/4] i40e: remove redundant assignment
Date:   Fri, 13 Nov 2020 16:10:55 -0800
Message-Id: <20201114001057.2133426-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201114001057.2133426-1-anthony.l.nguyen@intel.com>
References: <20201114001057.2133426-1-anthony.l.nguyen@intel.com>
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

