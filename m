Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6065D4B361D
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 16:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiBLPyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 10:54:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiBLPyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 10:54:01 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55392197
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 07:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644681238; x=1676217238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mw2DgBsSednITjrZu0h/yDPYKU5yVt/2ZVx5Creg75M=;
  b=UzXl7eUTAzdl74KW+IerW8E7dK5w7pDixNTGljt/oy7C5VFCNg0k33Jk
   lezu3Pbd1VMpu+LKFpVC3HSMn9cSx2kPnrmElKKMc47P/jyGl3jsVaJOI
   9U1CWI50vS95qN9lfWAk6ssD0e4CJ2u5gmao08RKhCQZLNsY7+XlqPDpv
   a+t5xfsfgNwTecHJgcujHenfJJC9QLqYjQfZfp7MYG6ERTS55LC42yMW5
   GFhLC2cNtRk1jbSmK3IsVmiO190hhGwTYPOpkKodvNZilwBBK4rVbG/P9
   Yfqnle0Vy2V9jeEfLImjJLyeNg2Mh++W8xyr81DqaTQ+gUHJXgHGuG8GD
   w==;
IronPort-SDR: 7JWoxpGgVF2WowxjBZOCoql+j3pXXGXlxFStl/YoGMYOdpUj7Whl3wkFhcfPTVMywMN5OIeS+E
 RO8/6gCRRRiWRh/op2A0Sl9b+VP04yiWxVVQrxk30dmCY4jkrsxslraSUpEMT4053gMTs5eVWV
 OmqqcGj75Fkiyb5Y+JdAYqsI5LNCC3AcVCECru/kPcpJFZ5dRJTWnvif01iI8U2J6TZlwl0K2v
 WGYWrjPqwlwDa1aRBrzRft94o5csJZo+8bdelANcjyMVmdoYk2uqilPXYP01VUF9eBavGFNM21
 YfqbtYtlBoEWCeBoMcErFPGb
X-IronPort-AV: E=Sophos;i="5.88,363,1635231600"; 
   d="scan'208";a="152858652"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2022 08:53:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 12 Feb 2022 08:53:30 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 12 Feb 2022 08:53:28 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next V1 3/5] net: lan743x: Increase MSI(x) vectors to 16 and Int de-assertion timers to 10
Date:   Sat, 12 Feb 2022 21:23:13 +0530
Message-ID: <20220212155315.340359-4-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
References: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase MSI / MSI-X vectors supported from 8 to 16 and
Interrupt De-assertion timers from 8 to 10

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:
 V1: 1. Change the subject line
     2. Correct the device name
     3. Based on review comments, optimise the code

 drivers/net/ethernet/microchip/lan743x_main.c | 32 +++++++++++++------
 drivers/net/ethernet/microchip/lan743x_main.h |  6 +++-
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index dc5f77bb525e..814d825e3deb 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -422,7 +422,7 @@ static u32 lan743x_intr_get_vector_flags(struct lan743x_adapter *adapter,
 {
 	int index;
 
-	for (index = 0; index < LAN743X_MAX_VECTOR_COUNT; index++) {
+	for (index = 0; index < adapter->max_vector_count; index++) {
 		if (adapter->intr.vector_list[index].int_mask & int_mask)
 			return adapter->intr.vector_list[index].flags;
 	}
@@ -435,9 +435,12 @@ static void lan743x_intr_close(struct lan743x_adapter *adapter)
 	int index = 0;
 
 	lan743x_csr_write(adapter, INT_EN_CLR, INT_BIT_MAS_);
-	lan743x_csr_write(adapter, INT_VEC_EN_CLR, 0x000000FF);
+	if (adapter->is_pci11x1x)
+		lan743x_csr_write(adapter, INT_VEC_EN_CLR, 0x0000FFFF);
+	else
+		lan743x_csr_write(adapter, INT_VEC_EN_CLR, 0x000000FF);
 
-	for (index = 0; index < LAN743X_MAX_VECTOR_COUNT; index++) {
+	for (index = 0; index < intr->number_of_vectors; index++) {
 		if (intr->flags & INTR_FLAG_IRQ_REQUESTED(index)) {
 			lan743x_intr_unregister_isr(adapter, index);
 			intr->flags &= ~INTR_FLAG_IRQ_REQUESTED(index);
@@ -457,10 +460,11 @@ static void lan743x_intr_close(struct lan743x_adapter *adapter)
 
 static int lan743x_intr_open(struct lan743x_adapter *adapter)
 {
-	struct msix_entry msix_entries[LAN743X_MAX_VECTOR_COUNT];
+	struct msix_entry msix_entries[PCI11X1X_MAX_VECTOR_COUNT];
 	struct lan743x_intr *intr = &adapter->intr;
 	unsigned int used_tx_channels;
 	u32 int_vec_en_auto_clr = 0;
+	u8 max_vector_count;
 	u32 int_vec_map0 = 0;
 	u32 int_vec_map1 = 0;
 	int ret = -ENODEV;
@@ -470,9 +474,10 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 	intr->number_of_vectors = 0;
 
 	/* Try to set up MSIX interrupts */
+	max_vector_count = adapter->max_vector_count;
 	memset(&msix_entries[0], 0,
-	       sizeof(struct msix_entry) * LAN743X_MAX_VECTOR_COUNT);
-	for (index = 0; index < LAN743X_MAX_VECTOR_COUNT; index++)
+	       sizeof(struct msix_entry) * max_vector_count);
+	for (index = 0; index < max_vector_count; index++)
 		msix_entries[index].entry = index;
 	used_tx_channels = adapter->used_tx_channels;
 	ret = pci_enable_msix_range(adapter->pdev,
@@ -570,8 +575,15 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 		lan743x_csr_write(adapter, INT_MOD_CFG5, LAN743X_INT_MOD);
 		lan743x_csr_write(adapter, INT_MOD_CFG6, LAN743X_INT_MOD);
 		lan743x_csr_write(adapter, INT_MOD_CFG7, LAN743X_INT_MOD);
-		lan743x_csr_write(adapter, INT_MOD_MAP0, 0x00005432);
-		lan743x_csr_write(adapter, INT_MOD_MAP1, 0x00000001);
+		if (adapter->is_pci11x1x) {
+			lan743x_csr_write(adapter, INT_MOD_CFG8, LAN743X_INT_MOD);
+			lan743x_csr_write(adapter, INT_MOD_CFG9, LAN743X_INT_MOD);
+			lan743x_csr_write(adapter, INT_MOD_MAP0, 0x00007654);
+			lan743x_csr_write(adapter, INT_MOD_MAP1, 0x00003210);
+		} else {
+			lan743x_csr_write(adapter, INT_MOD_MAP0, 0x00005432);
+			lan743x_csr_write(adapter, INT_MOD_MAP1, 0x00000001);
+		}
 		lan743x_csr_write(adapter, INT_MOD_MAP2, 0x00FFFFFF);
 	}
 
@@ -646,7 +658,7 @@ static int lan743x_intr_open(struct lan743x_adapter *adapter)
 				LAN743X_VECTOR_FLAG_SOURCE_STATUS_AUTO_CLEAR;
 		}
 		for (index = 0; index < number_of_rx_vectors; index++) {
-			int vector = index + 1 + LAN743X_USED_TX_CHANNELS;
+			int vector = index + 1 + used_tx_channels;
 			u32 int_bit = INT_BIT_DMA_RX_(index);
 
 			/* map RX interrupt to vector */
@@ -2731,9 +2743,11 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 	if (adapter->is_pci11x1x) {
 		adapter->max_tx_channels = PCI11X1X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = PCI11X1X_USED_TX_CHANNELS;
+		adapter->max_vector_count = PCI11X1X_MAX_VECTOR_COUNT;
 	} else {
 		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = LAN743X_USED_TX_CHANNELS;
+		adapter->max_vector_count = LAN743X_MAX_VECTOR_COUNT;
 	}
 
 	adapter->intr.irq = adapter->pdev->irq;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index f2fa33357c17..9a3ac9df4209 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -266,6 +266,8 @@
 #define INT_MOD_CFG5			(0x7D4)
 #define INT_MOD_CFG6			(0x7D8)
 #define INT_MOD_CFG7			(0x7DC)
+#define INT_MOD_CFG8			(0x7E0)
+#define INT_MOD_CFG9			(0x7E4)
 
 #define PTP_CMD_CTL					(0x0A00)
 #define PTP_CMD_CTL_PTP_CLK_STP_NSEC_			BIT(6)
@@ -619,13 +621,14 @@ struct lan743x_vector {
 };
 
 #define LAN743X_MAX_VECTOR_COUNT	(8)
+#define PCI11X1X_MAX_VECTOR_COUNT	(16)
 
 struct lan743x_intr {
 	int			flags;
 
 	unsigned int		irq;
 
-	struct lan743x_vector	vector_list[LAN743X_MAX_VECTOR_COUNT];
+	struct lan743x_vector	vector_list[PCI11X1X_MAX_VECTOR_COUNT];
 	int			number_of_vectors;
 	bool			using_vectors;
 
@@ -738,6 +741,7 @@ struct lan743x_adapter {
 	bool			is_pci11x1x;
 	u8			max_tx_channels;
 	u8			used_tx_channels;
+	u8			max_vector_count;
 
 #define LAN743X_ADAPTER_FLAG_OTP		BIT(0)
 	u32			flags;
-- 
2.25.1

