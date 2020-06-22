Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4788820436F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbgFVWSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:18:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:7019 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731000AbgFVWSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:18:25 -0400
IronPort-SDR: ISlR70+R+GxEJJOtR6MXB0YkcRRH2YN3fQaSHkoR9JNJRAJsIh8r2wi/Ik4lH9F1s3Q1lDrOeg
 5MU2SqDATSHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="209077840"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="209077840"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:18:21 -0700
IronPort-SDR: sn6iPU7aIO3sYEyTrhp/WOUDRdYPkOQVuwqOchUN7H8NOP1wz7r0/Dkft1aDiLR0vR9BuPtswI
 L69x3XrimuWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="311075826"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jun 2020 15:18:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 7/9] i40e: Add support for 5Gbps cards
Date:   Mon, 22 Jun 2020 15:18:15 -0700
Message-Id: <20200622221817.2287549-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Make possible for the i40e driver to bind to the new v710 for 5GBASE-T
NICs.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 3 +++
 drivers/net/ethernet/intel/i40e/i40e_devids.h | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 4ab081953e19..afad5e9f80e0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -27,6 +27,7 @@ i40e_status i40e_set_mac_type(struct i40e_hw *hw)
 		case I40E_DEV_ID_QSFP_A:
 		case I40E_DEV_ID_QSFP_B:
 		case I40E_DEV_ID_QSFP_C:
+		case I40E_DEV_ID_5G_BASE_T_BC:
 		case I40E_DEV_ID_10G_BASE_T:
 		case I40E_DEV_ID_10G_BASE_T4:
 		case I40E_DEV_ID_10G_BASE_T_BC:
@@ -4906,6 +4907,7 @@ i40e_status i40e_write_phy_register(struct i40e_hw *hw,
 		status = i40e_write_phy_register_clause22(hw, reg, phy_addr,
 							  value);
 		break;
+	case I40E_DEV_ID_5G_BASE_T_BC:
 	case I40E_DEV_ID_10G_BASE_T:
 	case I40E_DEV_ID_10G_BASE_T4:
 	case I40E_DEV_ID_10G_BASE_T_BC:
@@ -4943,6 +4945,7 @@ i40e_status i40e_read_phy_register(struct i40e_hw *hw,
 		status = i40e_read_phy_register_clause22(hw, reg, phy_addr,
 							 value);
 		break;
+	case I40E_DEV_ID_5G_BASE_T_BC:
 	case I40E_DEV_ID_10G_BASE_T:
 	case I40E_DEV_ID_10G_BASE_T4:
 	case I40E_DEV_ID_10G_BASE_T_BC:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_devids.h b/drivers/net/ethernet/intel/i40e/i40e_devids.h
index 33df3bf2f73b..1bcb0ec0f0c0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_devids.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_devids.h
@@ -23,8 +23,10 @@
 #define I40E_DEV_ID_10G_BASE_T_BC	0x15FF
 #define I40E_DEV_ID_10G_B		0x104F
 #define I40E_DEV_ID_10G_SFP		0x104E
+#define I40E_DEV_ID_5G_BASE_T_BC	0x101F
 #define I40E_IS_X710TL_DEVICE(d) \
-	((d) == I40E_DEV_ID_10G_BASE_T_BC)
+	(((d) == I40E_DEV_ID_5G_BASE_T_BC) || \
+	 ((d) == I40E_DEV_ID_10G_BASE_T_BC))
 #define I40E_DEV_ID_KX_X722		0x37CE
 #define I40E_DEV_ID_QSFP_X722		0x37CF
 #define I40E_DEV_ID_SFP_X722		0x37D0
-- 
2.26.2

