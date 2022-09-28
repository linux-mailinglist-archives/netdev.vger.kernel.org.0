Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E411C5ED5AE
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiI1HIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiI1HIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:08:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A3EE3EF3;
        Wed, 28 Sep 2022 00:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664348919; x=1695884919;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=k8LpqHay4HmwnWtui8VFFgLfp9KP1+BML4qzqAIm0So=;
  b=r6HaQFOCv2jdyhpuIl+g5YAlcWhzmVlcOEZPvpbAFGR6nZE/4McqjwuH
   Kop2l25MOXm5ThCzIGOoxaL3B4Jp4lynnfhNcdrPuzbY+m5v+CdKrx7N6
   GXDWqgrTMT4X/bI5wc69G2DfQ0gu1ClK0IU5O9e1hS9EOsVj5+DvLQb3i
   BD/wh9HD1lpjUL988zirq20jfbLadMNkRLNeqsmd3eleheBXAXgb8CLA2
   oJbtPCaN7MvkWwVbg3jhDnrE8TkrQwxP2K1tu5L6Cb91vAHUfudWFt2ll
   i225xrYB11saggfRW6GaV2xafRXDE4XnyiE4YLuaHS85bs3LdXLdApIEX
   g==;
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="182278536"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2022 00:08:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 28 Sep 2022 00:08:37 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 28 Sep 2022 00:08:34 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net V3] eth: lan743x: reject extts for non-pci11x1x devices
Date:   Wed, 28 Sep 2022 12:38:30 +0530
Message-ID: <20220928070830.22517-1-Raju.Lakkaraju@microchip.com>
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

Fixes: 60942c397af6 ("Add support for PTP-IO Event Input External  Timestamp
 (extts)")

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:                                                                        
========
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

