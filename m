Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE945BA81A
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 10:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiIPIXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 04:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIPIXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 04:23:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96E4A4B39;
        Fri, 16 Sep 2022 01:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663316619; x=1694852619;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/NI2pu8giI3UdwHRrZq8eCC9VA82S1IW3MexOoaAZY0=;
  b=QQ/31nMcyWMJ/CH67Q23U5e6aG+tJu07P+UTpXbvtrw7B+tURDZWwq89
   8NTfjBCDJBh5Dy7t+4Ucf/SF1ZkqWln/yC/xYHLoY/XsQcJ/G9uIYxLsx
   G9MjyvdPo8//TaB9p2JGJqQtI/z4XWoRpz38Qf9H6fMI+dSPX6NWW0oSM
   5DtyldFqpUqtp+GXMd0Q1nA5XBUH2MO8LyOoRhBWHeSslpFZBDx7/obCx
   MJ77dLB6TsAHcZweBXL+ODQpT3zXtyodA01mZSgETtawkxamCyAFXOK5u
   Q6lUYDKqC322Efn+0WJYAwql63dHSpjQXof36DOqM8893BZlNyn3imZrk
   w==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="174167167"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2022 01:23:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 16 Sep 2022 01:23:37 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 16 Sep 2022 01:23:34 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 1/2] net: lan743x: Remove PTP_PF_EXTTS support for non-PCI11x1x devices
Date:   Fri, 16 Sep 2022 13:53:26 +0530
Message-ID: <20220916082327.370579-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220916082327.370579-1-Raju.Lakkaraju@microchip.com>
References: <20220916082327.370579-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not
support the PTP-IO Input event triggered timestamping mechanisms
added by commit 60942c397af6094c04406b77982314dfe69ef3c4

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
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

