Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC702A367E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgKBWYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:24:39 -0500
Received: from mga05.intel.com ([192.55.52.43]:16130 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbgKBWYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:24:21 -0500
IronPort-SDR: lrVRQ8RQNawV8RU/9O2e7qbmo+uwJB5um11St6DOgttI8F1wtR/PN+q49PZ0zcaZhEuNt3Uq4d
 HErIxQ4t1Mbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="253670981"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="253670981"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 14:24:20 -0800
IronPort-SDR: O6YdqHZ1VVHXjGHwn9EN7vLT7Rj4mG4pG+rrq32o0P2f/bsVZ+ZdjQXzmri/cDnX7zHgoJ7uUv
 2jw4KhmEOuYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305591803"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2020 14:24:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 13/15] ice: silence static analysis warning
Date:   Mon,  2 Nov 2020 14:23:36 -0800
Message-Id: <20201102222338.1442081-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
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

