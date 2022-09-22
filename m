Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C295E5C1B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiIVHPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiIVHMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:12:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F553C8888;
        Thu, 22 Sep 2022 00:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663830753; x=1695366753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O+umzB8XumVjod2RefyJG+r8Vj+Oh+sTFiIyFSpsRjo=;
  b=CFvx6/9ZPI1tuDcVlXSgNlo1z+m88XiZx3qdSbgjcKwKxRKFSDPSNzT0
   cwldM2imQBdY83nBphotCU6Rj2Eytj+nPsmTM4S6H1Cn5/ATOE5XwRW+S
   mGD4tVicM5gxGqAzztteKRmmu+FGWRQAEZGNGqODVb6Pn7B0lvNHQr7ZX
   WNoaOfvLbjkDmb5tvMwk/kIma71ufdk3jADx0221ppapoHx01bJzZD7Sw
   IMNHDGh/JN21RtGqmJ1Qsu9AkPEuBI+rSH84QmEyCGToDHEGMMFU15cc9
   +GUuFCfr+EHb0yQS3bycTLlyw/Z5M3etFWNoxd3v6gK4oj30jJF6519Xg
   A==;
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="114867105"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2022 00:12:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 22 Sep 2022 00:12:26 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 22 Sep 2022 00:12:20 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next v4 6/6] net: phy: micrel: enable interrupt for ksz9477 phy
Date:   Thu, 22 Sep 2022 12:40:28 +0530
Message-ID: <20220922071028.18012-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220922071028.18012-1-arun.ramadoss@microchip.com>
References: <20220922071028.18012-1-arun.ramadoss@microchip.com>
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

Config_intr and handle_interrupt are enabled for ksz9477 phy. It is
similar to all other phys in the micrel phys.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/micrel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c225df56b7d2..b3d2c025b45b 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3342,6 +3342,8 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Microchip KSZ9477",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= kszphy_config_init,
+	.config_intr	= kszphy_config_intr,
+	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
-- 
2.36.1

