Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523C02D4C99
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 22:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388010AbgLIVPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 16:15:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:24108 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387929AbgLIVPQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 16:15:16 -0500
IronPort-SDR: ZaGewaOsmrPnyWVp7XVCCDD7umD3qSn+bzPpfM6s49xaLgCa6HXRm8FkgwC1dX1JV8TFWigEif
 itoN9CMxVE6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="170641635"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="170641635"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 13:13:54 -0800
IronPort-SDR: iel0I2sJioRmFeWqYaLPBUEHVNX35AO4TNMCtpcxuseueYDdVtRKYOyAtk1ahvT5ci09XsyvMK
 6uMLZNm+ncdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="408228660"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 09 Dec 2020 13:13:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v4 7/9] ice: silence static analysis warning
Date:   Wed,  9 Dec 2020 13:13:10 -0800
Message-Id: <20201209211312.3850588-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
References: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

sparse warns about cast to/from restricted types which is not
an actual problem; silence the warning.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index dc0d82c844ad..0d1092cbc927 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -196,7 +196,7 @@ ice_read_sr_word_aq(struct ice_hw *hw, u16 offset, u16 *data)
 	 * Shadow RAM sector restrictions necessary when reading from the NVM.
 	 */
 	status = ice_read_flat_nvm(hw, offset * sizeof(u16), &bytes,
-				   (u8 *)&data_local, true);
+				   (__force u8 *)&data_local, true);
 	if (status)
 		return status;
 
-- 
2.26.2

