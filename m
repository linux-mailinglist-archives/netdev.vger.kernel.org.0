Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDE93D0533
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhGTWir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:38:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:50230 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232115AbhGTWhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341477"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341477"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407137"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 05/12] e1000e: Add support for the next LOM generation
Date:   Tue, 20 Jul 2021 16:20:54 -0700
Message-Id: <20210720232101.3087589-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add devices IDs for the next LOM generations that will be
available on the next Intel Client platforms
This patch provides the initial support for these devices

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/hw.h     | 4 ++++
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index 36ff936918c9..bcf680e83811 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -98,10 +98,14 @@ struct e1000_hw;
 #define E1000_DEV_ID_PCH_TGP_I219_V14		0x15FA
 #define E1000_DEV_ID_PCH_TGP_I219_LM15		0x15F4
 #define E1000_DEV_ID_PCH_TGP_I219_V15		0x15F5
+#define E1000_DEV_ID_PCH_RPL_I219_LM23		0x0DC5
+#define E1000_DEV_ID_PCH_RPL_I219_V23		0x0DC6
 #define E1000_DEV_ID_PCH_ADP_I219_LM16		0x1A1E
 #define E1000_DEV_ID_PCH_ADP_I219_V16		0x1A1F
 #define E1000_DEV_ID_PCH_ADP_I219_LM17		0x1A1C
 #define E1000_DEV_ID_PCH_ADP_I219_V17		0x1A1D
+#define E1000_DEV_ID_PCH_RPL_I219_LM22		0x0DC7
+#define E1000_DEV_ID_PCH_RPL_I219_V22		0x0DC8
 #define E1000_DEV_ID_PCH_MTP_I219_LM18		0x550A
 #define E1000_DEV_ID_PCH_MTP_I219_V18		0x550B
 #define E1000_DEV_ID_PCH_MTP_I219_LM19		0x550C
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 59f22a75b96d..152cacbc527e 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7902,10 +7902,14 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM23), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V23), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM22), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V22), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_cnp },
-- 
2.26.2

