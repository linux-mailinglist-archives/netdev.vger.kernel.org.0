Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE82930E8CA
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhBDAos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:44:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:40083 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234327AbhBDAoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:44:07 -0500
IronPort-SDR: +XTLdeYahUIMz/OQyjm+m0lVN6K7i2Wh1Zg+7NCgs5hLdjKDgqOgy1/twmrsCw+3mEpRjZBF+M
 fC9e4Ou1Cofg==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638235"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638235"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:14 -0800
IronPort-SDR: 560kuMKkwJwq0b14t5fdUKeu+4oENZo06nBCQUsJBenHdceYLeRSj9ChKqQ8xVwt2LWv+jW+D8
 Ug+bIL3i8RAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687512"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Gal Hammer <ghammer@redhat.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        David Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 11/15] igb: fix TDBAL register show incorrect value
Date:   Wed,  3 Feb 2021 16:42:55 -0800
Message-Id: <20210204004259.3662059-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Hammer <ghammer@redhat.com>

Fixed a typo which caused the registers dump function to read the
RDBAL register when printing TDBAL register values.

Signed-off-by: Gal Hammer <ghammer@redhat.com>
Tested-by: David Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 84d4284b8b32..d6090faaa41d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -316,7 +316,7 @@ static void igb_regdump(struct e1000_hw *hw, struct igb_reg_info *reginfo)
 		break;
 	case E1000_TDBAL(0):
 		for (n = 0; n < 4; n++)
-			regs[n] = rd32(E1000_RDBAL(n));
+			regs[n] = rd32(E1000_TDBAL(n));
 		break;
 	case E1000_TDBAH(0):
 		for (n = 0; n < 4; n++)
-- 
2.26.2

