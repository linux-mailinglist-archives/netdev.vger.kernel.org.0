Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DA7629F97
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiKOQvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiKOQvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:51:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EA460C1;
        Tue, 15 Nov 2022 08:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668531097; x=1700067097;
  h=from:to:subject:date:message-id:mime-version;
  bh=M037HZoZIJZwjrgxuGpwa/KRgNyMbZlaFJUwnENLVUo=;
  b=Les+63OUjl4x2Xk2lmk5hyHHWuJ2BUe+TpLqsJt+BJrWKILL7bv8AhnN
   oeL+IU9ZwFXfG0ZebwzO5Fo+nagzdWpv2/7GNHdRZcX9n7jxrvNllJAc9
   dYPDLHL5Wrckh75rWlE87jMnoRga9eYV2pN32KaMjg05+S8l2Fiqip4SC
   R6HwHfel+oIEMXb9G7lm9sPIIZhCDwaYTXxsmooY7LTZT6O4x6ySpuhcL
   nT0L+hlaiaXU1/Jfte9zkZ4rPr/MHFfZMBnizgg5kYN5xyUMhR4M9HKhZ
   pwDOHzdOU5aelYGcLjs1Pqg1fcGt6O/qSfKF1xMW3HjlBfaWCINVnTb5y
   w==;
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="189129273"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Nov 2022 09:51:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 15 Nov 2022 09:51:36 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 15 Nov 2022 09:51:33 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jerry Ray <jerry.ray@microchip.com>
Subject: [net-next][PATCH v2 1/2] dsa: lan9303: Change stat name
Date:   Tue, 15 Nov 2022 10:51:30 -0600
Message-ID: <20221115165131.11467-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the reported ethtool statistics for the lan9303
family of parts covered by this driver.

The TxUnderRun statistic label is renamed to RxShort to accurately
reflect what stat the device is reporting.  I did not reorder the
statistics as that might cause problems with existing user code that
are expecting the stats at a certain offset.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
v1->v2:
  Split patch into 2 pieces.
---
 drivers/net/dsa/lan9303-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 438e46af03e9..80f07bd20593 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -961,7 +961,7 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
 	{ .offset = LAN9303_MAC_TX_BRDCST_CNT_0, .name = "TxBroad", },
 	{ .offset = LAN9303_MAC_TX_PAUSE_CNT_0, .name = "TxPause", },
 	{ .offset = LAN9303_MAC_TX_MULCST_CNT_0, .name = "TxMulti", },
-	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "TxUnderRun", },
+	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "RxShort", },
 	{ .offset = LAN9303_MAC_TX_64_CNT_0, .name = "Tx64Byte", },
 	{ .offset = LAN9303_MAC_TX_127_CNT_0, .name = "Tx128Byte", },
 	{ .offset = LAN9303_MAC_TX_255_CNT_0, .name = "Tx256Byte", },
-- 
2.17.1

