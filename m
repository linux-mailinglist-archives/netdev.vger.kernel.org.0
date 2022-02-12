Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8934B3617
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 16:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiBLPxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 10:53:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiBLPx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 10:53:29 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460B1B9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 07:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644681206; x=1676217206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ogBf1WGg2My/k7eNXylXLGcCHkQ+xrQ2uhoWzkDMzsI=;
  b=Ame4w8bu0LI9CGUu1rrx0K59cwi5eSzaawuX/aagplQZC0e3fv7pDAsR
   2gf4bAU+QdIVyFP4mQO+QXcexRLilSlxqY7VWIKINT0eKsbUcyYBQbfNI
   hUTELI5eomlvlW6pg59TaQNPInMZGKYOjQVSTkoBRYhYc98Hy25FOCnU3
   1MydwGMwONOZE08+6zeuCoSMbk+Y0UkBP/irwtlTBTnyA1ueVLVsngkJI
   jYXKzJqxVCJ9Y4XXc+6e8ZuBqxaS2H1vw8iwz1aSyZCXBPiNR4l36x0nz
   f4RdOzzvoMYHj56b+OSxjfaZdFqTP76eX3cAmVuT/1ig6o22eG5AL69XK
   g==;
IronPort-SDR: EYOiekYAdbJfuQccbFmq1NpDv826B5OdrrkL7qexnknoECMB6DQcdp4YiQzO59mZK7d1vu3BWf
 soQLOtCmDGRW+0AMVmoqOis/zB9Jp8xcSLzYNQG85UX6KgmEzeJaEbJC7tBknwm1J9QCinVA6e
 DYFl4OmjT4xGifk7Eqi+FERatyvtacwO1ClqsqtA7CSnOZl7eh+SXciVk6UFnBIwWnG9SDTW6e
 RfQhOAP9KK11LAAQYldaIJZunTrlemyDNp25Y5ELs1R0l+MYhpd2wKtUGmVcKOH1VgsraK3kGZ
 LNBvQ/0TXfs3bD8lFNBiJsfs
X-IronPort-AV: E=Sophos;i="5.88,363,1635231600"; 
   d="scan'208";a="85510909"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2022 08:53:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 12 Feb 2022 08:53:25 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 12 Feb 2022 08:53:23 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next V1 1/5] net: lan743x: Add PCI11010 / PCI11414 device IDs
Date:   Sat, 12 Feb 2022 21:23:11 +0530
Message-ID: <20220212155315.340359-2-Raju.Lakkaraju@microchip.com>
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

PCI11010/PCI11414 devices are enhancement of Ethernet LAN743x chip family.

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:
  V1: 1. Correct the device name in description
      2. Removed phy_mask

 drivers/net/ethernet/microchip/lan743x_main.c |  2 ++
 drivers/net/ethernet/microchip/lan743x_main.h | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 8c6390d95158..5c0ef33a61d5 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3056,6 +3056,8 @@ static const struct dev_pm_ops lan743x_pm_ops = {
 static const struct pci_device_id lan743x_pcidev_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SMSC, PCI_DEVICE_ID_SMSC_LAN7430) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SMSC, PCI_DEVICE_ID_SMSC_LAN7431) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_SMSC, PCI_DEVICE_ID_SMSC_A011) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_SMSC, PCI_DEVICE_ID_SMSC_A041) },
 	{ 0, }
 };
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index aaf7aaeaba0c..0143ac327d2b 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -16,8 +16,13 @@
 #define ID_REV_ID_MASK_			(0xFFFF0000)
 #define ID_REV_ID_LAN7430_		(0x74300000)
 #define ID_REV_ID_LAN7431_		(0x74310000)
-#define ID_REV_IS_VALID_CHIP_ID_(id_rev)	\
-	(((id_rev) & 0xFFF00000) == 0x74300000)
+#define ID_REV_ID_LAN743X_		(0x74300000)
+#define ID_REV_ID_A011_			(0xA0110000)	// PCI11010
+#define ID_REV_ID_A041_			(0xA0410000)	// PCI11414
+#define ID_REV_ID_A0X1_			(0xA0010000)
+#define ID_REV_IS_VALID_CHIP_ID_(id_rev)	    \
+	((((id_rev) & 0xFFF00000) == ID_REV_ID_LAN743X_) || \
+	 (((id_rev) & 0xFF0F0000) == ID_REV_ID_A0X1_))
 #define ID_REV_CHIP_REV_MASK_		(0x0000FFFF)
 #define ID_REV_CHIP_REV_A0_		(0x00000000)
 #define ID_REV_CHIP_REV_B0_		(0x00000010)
@@ -559,6 +564,8 @@ struct lan743x_adapter;
 #define PCI_VENDOR_ID_SMSC		PCI_VENDOR_ID_EFAR
 #define PCI_DEVICE_ID_SMSC_LAN7430	(0x7430)
 #define PCI_DEVICE_ID_SMSC_LAN7431	(0x7431)
+#define PCI_DEVICE_ID_SMSC_A011		(0xA011)
+#define PCI_DEVICE_ID_SMSC_A041		(0xA041)
 
 #define PCI_CONFIG_LENGTH		(0x1000)
 
-- 
2.25.1

