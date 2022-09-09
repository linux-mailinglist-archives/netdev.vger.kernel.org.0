Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B916D5B3C95
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 18:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiIIQCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 12:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiIIQCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 12:02:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD98116B5C;
        Fri,  9 Sep 2022 09:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662739343; x=1694275343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H2xYKBMOoGGpAzj9Eam7mDzfrED6zMoahKfEe7aJR3Y=;
  b=EnChl7mnXNOeTXtKiEsOTumpbkZI8yhqvCMPOSym6kG6jf4wnQvr6n0d
   ZWlSW5FUdjipi/k3s3KDDUi5tcauDkwz6ryszOqlZm2XiQAYH+xswM/0e
   pk26lc8eQ/j1qPdmB0/ykGu2UcJ+mfYJ/9C/f2/wtxFKy0dSIsDL+qlJJ
   5BL3kgin5t/XN612xV5ygzrt2foeA2J3cR+61PHIR2XvRhAVCXHQzgtw0
   DueDfup1uazsRm02y50g4AFm3nNsa+XnZr525U7MdsBRlJ5rAf/svIja/
   2vxGdlidmJqeh3COkkD9iaav9hPAXrcqFPHvE5YuQ9XFr0D/VFDyepupP
   w==;
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="190177821"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2022 09:02:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Sep 2022 09:02:21 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Sep 2022 09:02:16 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>
Subject: [RFC Patch net-next 4/4] net: phy: micrel: enable interrupt for ksz9477 phy
Date:   Fri, 9 Sep 2022 21:31:20 +0530
Message-ID: <20220909160120.9101-5-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220909160120.9101-1-arun.ramadoss@microchip.com>
References: <20220909160120.9101-1-arun.ramadoss@microchip.com>
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

Config_intr and handle_interrupt are enabled for ksz9477 phy. It is
similar to all other phys in the micrel phys.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/micrel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 7b8c5c8d013e..09f2bef5d96c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3191,6 +3191,8 @@ static struct phy_driver ksphy_driver[] = {
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

