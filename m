Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CF82B275F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgKMVps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:45:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:18968 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgKMVpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:45:12 -0500
IronPort-SDR: Kx5VRYG8HxYHgRa/1YpRAKd42rfulLE4gxHpbix0ivprZu13Sv51Q9CydQJVSQYBur6okZhHrO
 u/JMi4TXOL+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232153173"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232153173"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:44:58 -0800
IronPort-SDR: qM41nzwLrS1LfE0DTnNnzphRZVwTb5PgyoWfpp5qjAcsv2bsbceUxRZrl9vzFlCl82b+dq0aD5
 YBR+NYdsWebA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="532715901"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 13 Nov 2020 13:44:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v3 13/15] ice: silence static analysis warning
Date:   Fri, 13 Nov 2020 13:44:27 -0800
Message-Id: <20201113214429.2131951-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
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

