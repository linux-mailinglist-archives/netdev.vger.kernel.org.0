Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97355AF778
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiIFV4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiIFV4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:56:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C948E9B4
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662501373; x=1694037373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/uTv+2/G2n5DbmkjYN93MkjZyXQ6TaZ6Ur8sTTlOEXo=;
  b=ZjHbNzUr7H9nJrBrO9iaDy++z25if1cdOpkO2r18sYQminKgzGC10gf4
   rjkIzFOpDmLz41Pp21eRVCdP5KjGL2i1iC7NrtqGob9STyu4KMk2an0TC
   L8b+Zaowpu2n/as9u3qDfeyrlwLvuovdmyZBDHHIrzjsvrvsT8K+aKv3Z
   OMnryg3/49h1xxnmj1nTSoiVQnKSuGYMCnaLXfxEJgjEhj5t3rXpWIMhM
   xJfgX2eVgISbDXsZDk9WCbqNMsGiGaJQY81dYwWMTa2Gooxxw86zFGy9F
   qLG/+deyStQ8u4Pm00K5mKOBaf3wrOQ+6PyC8RmDdR/oT1TnjqXJVEtSR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="383012342"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="383012342"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:56:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="682562897"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 06 Sep 2022 14:56:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Stanislaw Grzeszczak <stanislaw.a.grzeszczak@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/3] i40e: Add basic support for I710 devices
Date:   Tue,  6 Sep 2022 14:56:04 -0700
Message-Id: <20220906215606.3501995-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
References: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislaw Grzeszczak <stanislaw.a.grzeszczak@intel.com>

Intel introduces a new line of 1G ethernet adapters with Device ID 0x0DD2

Signed-off-by: Stanislaw Grzeszczak <stanislaw.a.grzeszczak@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 3 +++
 drivers/net/ethernet/intel/i40e/i40e_devids.h | 4 +++-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 2819e261a126..4f01e2a6b6bb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -27,6 +27,7 @@ i40e_status i40e_set_mac_type(struct i40e_hw *hw)
 		case I40E_DEV_ID_QSFP_A:
 		case I40E_DEV_ID_QSFP_B:
 		case I40E_DEV_ID_QSFP_C:
+		case I40E_DEV_ID_1G_BASE_T_BC:
 		case I40E_DEV_ID_5G_BASE_T_BC:
 		case I40E_DEV_ID_10G_BASE_T:
 		case I40E_DEV_ID_10G_BASE_T4:
@@ -4974,6 +4975,7 @@ i40e_status i40e_write_phy_register(struct i40e_hw *hw,
 		status = i40e_write_phy_register_clause22(hw, reg, phy_addr,
 							  value);
 		break;
+	case I40E_DEV_ID_1G_BASE_T_BC:
 	case I40E_DEV_ID_5G_BASE_T_BC:
 	case I40E_DEV_ID_10G_BASE_T:
 	case I40E_DEV_ID_10G_BASE_T4:
@@ -5012,6 +5014,7 @@ i40e_status i40e_read_phy_register(struct i40e_hw *hw,
 		status = i40e_read_phy_register_clause22(hw, reg, phy_addr,
 							 value);
 		break;
+	case I40E_DEV_ID_1G_BASE_T_BC:
 	case I40E_DEV_ID_5G_BASE_T_BC:
 	case I40E_DEV_ID_10G_BASE_T:
 	case I40E_DEV_ID_10G_BASE_T4:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_devids.h b/drivers/net/ethernet/intel/i40e/i40e_devids.h
index 2610338002fe..d9c51a238dcc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_devids.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_devids.h
@@ -24,8 +24,10 @@
 #define I40E_DEV_ID_10G_B		0x104F
 #define I40E_DEV_ID_10G_SFP		0x104E
 #define I40E_DEV_ID_5G_BASE_T_BC	0x101F
+#define I40E_DEV_ID_1G_BASE_T_BC	0x0DD2
 #define I40E_IS_X710TL_DEVICE(d) \
-	(((d) == I40E_DEV_ID_5G_BASE_T_BC) || \
+	(((d) == I40E_DEV_ID_1G_BASE_T_BC) || \
+	 ((d) == I40E_DEV_ID_5G_BASE_T_BC) || \
 	 ((d) == I40E_DEV_ID_10G_BASE_T_BC))
 #define I40E_DEV_ID_KX_X722		0x37CE
 #define I40E_DEV_ID_QSFP_X722		0x37CF
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5e5290099b76..89dd46130c03 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -66,6 +66,7 @@ static const struct pci_device_id i40e_pci_tbl[] = {
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_QSFP_A), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_QSFP_B), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_QSFP_C), 0},
+	{PCI_VDEVICE(INTEL, I40E_DEV_ID_1G_BASE_T_BC), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_10G_BASE_T), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_10G_BASE_T4), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_10G_BASE_T_BC), 0},
-- 
2.35.1

