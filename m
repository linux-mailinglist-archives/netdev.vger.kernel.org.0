Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D1230E8EA
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhBDAuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:50:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:40083 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234506AbhBDAni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:43:38 -0500
IronPort-SDR: 6UIlcZGi+pMwxYJ5g9nCFaR01WdeF79Jbo7JWQeC8VmBKIbw7n9mYaW5PprhqNswTnEQJJymdD
 tiq8iwnu/uvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638234"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638234"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:14 -0800
IronPort-SDR: lfvISThLfS9aJi+lQkdNPqLti85BglPNM8PjzrmCH0HpasAfEC5UjRvNBHMrLSycnVDCzf8Qyw
 qxhjli1yw0dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687508"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Gal Hammer <ghammer@redhat.com>
Subject: [PATCH net-next 10/15] igc: Fix TDBAL register show incorrect value
Date:   Wed,  3 Feb 2021 16:42:54 -0800
Message-Id: <20210204004259.3662059-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Fixed a typo which caused the registers dump function to read the
RDBAL register when printing TDBAL register values.
_reg_dump method has been partially derived from i210 and have
same typo.

Suggested-by: Gal Hammer <ghammer@redhat.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_dump.c b/drivers/net/ethernet/intel/igc/igc_dump.c
index 4b9ec7d0b727..495bed47ed0a 100644
--- a/drivers/net/ethernet/intel/igc/igc_dump.c
+++ b/drivers/net/ethernet/intel/igc/igc_dump.c
@@ -75,7 +75,7 @@ static void igc_regdump(struct igc_hw *hw, struct igc_reg_info *reginfo)
 		break;
 	case IGC_TDBAL(0):
 		for (n = 0; n < 4; n++)
-			regs[n] = rd32(IGC_RDBAL(n));
+			regs[n] = rd32(IGC_TDBAL(n));
 		break;
 	case IGC_TDBAH(0):
 		for (n = 0; n < 4; n++)
-- 
2.26.2

