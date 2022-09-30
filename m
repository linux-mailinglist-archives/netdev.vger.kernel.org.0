Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB435F078C
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 11:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiI3J2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 05:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiI3J17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 05:27:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A96201931;
        Fri, 30 Sep 2022 02:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664530078; x=1696066078;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=06Xbmv620CsGGAsAg6PM90IvXhrNtfGqmlVvRMXVv2c=;
  b=sRdr9eXX7RAhNq27/NqW5vUFRQ+Z9CppVs2AYyY4yPbp8DR01Kwk1MmA
   Sc2j8R2/T9hItSbdPCkvXVKskEyECFgm6XeDBe3VGgTpsqLBk2AEan1P9
   ph2Ri01XF4OFTc/0IC4kMQBj+H0lnY4+r6p8f71C0VxfXGS4sSvhLmacb
   ASX/x4ooTbKMCy51ssuQ6p0BbGYIUTubt069TauLgP01UptOG9nOQES6r
   hgMPT6fDV1tJgNU4RiBkU676Jvv2A/fazD5uX7rhbXL/wUOU7FegPd0xr
   PFXFQlR5eE3FQ5EpLwhj2BN3V8WFHnpIo15269tf+sbJK7Wo7gn6Mk3Td
   w==;
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="182660408"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Sep 2022 02:27:56 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 30 Sep 2022 02:27:56 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 30 Sep 2022 02:27:53 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net V5] eth: lan743x: reject extts for non-pci11x1x devices
Date:   Fri, 30 Sep 2022 14:57:40 +0530
Message-ID: <20220930092740.130924-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not support
the PTP-IO Input event triggered timestamping mechanisms added

Fixes: 60942c397af6 ("net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)")
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:
========
V4 -> V5:
 - Remove the Reviewed-by tag added by me 
 - Correct the Fixes tag subject line

V3 -> V4:
  - Fix the Fixes tag line split

V2 -> V3:
 - Correct the Fixes tag

V1 -> V2:
 - Repost against net with a Fixes tag

 drivers/net/ethernet/microchip/lan743x_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 6a11e2ceb013..da3ea905adbb 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -1049,6 +1049,10 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
 					   enum ptp_pin_function func,
 					   unsigned int chan)
 {
+	struct lan743x_ptp *lan_ptp =
+		container_of(ptp, struct lan743x_ptp, ptp_clock_info);
+	struct lan743x_adapter *adapter =
+		container_of(lan_ptp, struct lan743x_adapter, ptp);
 	int result = 0;
 
 	/* Confirm the requested function is supported. Parameter
@@ -1057,7 +1061,10 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
 	switch (func) {
 	case PTP_PF_NONE:
 	case PTP_PF_PEROUT:
+		break;
 	case PTP_PF_EXTTS:
+		if (!adapter->is_pci11x1x)
+			result = -1;
 		break;
 	case PTP_PF_PHYSYNC:
 	default:
-- 
2.25.1

