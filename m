Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4466E1E7502
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgE2EkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:40325 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgE2EkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:07 -0400
IronPort-SDR: pCSQ9FxYy1MuICgGN85G7z+iT40NkghBJvPTGZk6RJK9iDR2I3/aPOPXDe92qv7vmdqfbNFZ0b
 Blj3dL+5l4nQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:05 -0700
IronPort-SDR: EX4F1TGJeCkOcaJ1UyIauWPrjY3z1w14iiy9QRmlU8jTKwTJ8WG64mn3LrsPEmZNTH6d4SKoJT
 YH1ryfT3U68g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850905"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jason Yan <yanaijie@huawei.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/17] ixgbe: Remove conversion to bool in ixgbe_device_supports_autoneg_fc()
Date:   Thu, 28 May 2020 21:39:51 -0700
Message-Id: <20200529044004.3725307-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>

No need to convert '==' expression to bool. This fixes the following
coccicheck warning:

drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:68:11-16: WARNING:
conversion to bool not needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 39c5e6fdb72c..17357a12cbdc 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -64,8 +64,7 @@ bool ixgbe_device_supports_autoneg_fc(struct ixgbe_hw *hw)
 			hw->mac.ops.check_link(hw, &speed, &link_up, false);
 			/* if link is down, assume supported */
 			if (link_up)
-				supported = speed == IXGBE_LINK_SPEED_1GB_FULL ?
-				true : false;
+				supported = speed == IXGBE_LINK_SPEED_1GB_FULL;
 			else
 				supported = true;
 		}
-- 
2.26.2

