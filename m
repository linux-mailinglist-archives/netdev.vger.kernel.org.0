Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8AD54D927
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 06:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358736AbiFPENS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 00:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358680AbiFPENN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 00:13:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C975183B3;
        Wed, 15 Jun 2022 21:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655352774; x=1686888774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vg5ew2Zvwc+QjD4rZCa48xRUzh+QBoonlzNg241xc/Y=;
  b=h0aUBkOzLahB20W831KaN/DbypuehRFmHpTjxuhyM+ujz0lqCG6Hx4MH
   3ykef/A6RzWVPd3SnEAkKtovkCDjz5K22mTjY7svOYWaLbNhBpbsnVIXy
   dbs+KSNu7KD4zfICXs1g98+NfJj8LOADv0TL4Jg1kVYbN8PerSiqP/lrd
   E/J/F7wOC1/bKfWpu8HQsAiQwBHGh6xdFcxIM2kkPKGFnEKrqlwzDCcjg
   bHeFvSQbs9c0gevSP1y9V7IFZFTDIEo/1DnVA6+hMhjgvE1qSekAC28gy
   C7t9jtQwABgTcC5j6lSth1Xi6OXLF5G28wW3+AHb5L/hZogRUTxI76nDM
   g==;
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="178175290"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 21:12:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 21:12:54 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Jun 2022 21:12:50 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <lxu@maxlinear.com>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <bryan.whitehead@microchip.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V2 4/4] net: phy: add support to get Master-Slave configuration
Date:   Thu, 16 Jun 2022 09:42:26 +0530
Message-ID: <20220616041226.26996-5-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
References: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to Master-Slave configuration and state

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Changes:                                                                        
V0 -> V1:                                                                       
  1. Remove the gpy_master_slave_cfg_get() function and use the                 
genphy_read_master_slave() funtion.

 drivers/net/phy/mxl-gpy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 5ce1bf03bbd7..6c4da2f9e90a 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -295,6 +295,9 @@ static void gpy_update_interface(struct phy_device *phydev)
 				   ret);
 		break;
 	}
+
+	if (phydev->speed == SPEED_2500 || phydev->speed == SPEED_1000)
+		genphy_read_master_slave(phydev);
 }
 
 static int gpy_read_status(struct phy_device *phydev)
-- 
2.25.1

