Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F066C232297
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgG2QYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:42161 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727814AbgG2QYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:18 -0400
IronPort-SDR: 03Ww6fWyn4WL8nOyIHii0aX7JTK9uhEBoXuoPL1DqdbaPaFS360iYJNWiPaWHAGkRCAE2jiv+R
 7kDmI4uqwLdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982353"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982353"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:17 -0700
IronPort-SDR: jKzcoqfFoeGxqGE6Ld7WCfexmW2JJ6H1DGkvC+kCYeMeuHhneSirhvEThkgmlClyfiBo8u17ku
 BogJy6qSPGPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087613"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Ben Shelton <benjamin.h.shelton@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 14/15] ice: disable no longer needed workaround for FW logging
Date:   Wed, 29 Jul 2020 09:24:04 -0700
Message-Id: <20200729162405.1596435-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Shelton <benjamin.h.shelton@intel.com>

For the FW logging info AQ command, we currently set the ICE_AQ_FLAG_RD
in order to work around a FW issue. This issue has been fixed so remove the
workaround.

Signed-off-by: Ben Shelton <benjamin.h.shelton@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 35644fe6235a..ad5941ec7b11 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -611,8 +611,6 @@ static enum ice_status ice_get_fw_log_cfg(struct ice_hw *hw)
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_fw_logging_info);
 
-	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
-
 	status = ice_aq_send_cmd(hw, &desc, config, size, NULL);
 	if (!status) {
 		u16 i;
-- 
2.26.2

