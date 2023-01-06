Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689E465FCB8
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjAFI3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjAFI3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:29:18 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE1265AD5;
        Fri,  6 Jan 2023 00:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672993758; x=1704529758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=glt2/hIaYrE5Dt1m5RibjZdA+M4Bt00OAWcsQL3Agfk=;
  b=BZGEUSoTR/zwneIjVHOQB0pAQChx4wP6zWRO28LeOBZR+zlPw/2dIrRC
   o5yuirk1BjhDjCyBKHcurdfCGlGBMZwfmCW/NG5axwJAJrchzd3rDZUC4
   t4PGxkUdJmbOHgO4+SlLsNGZg0jPU26TseQBXhnc+sBT6B12aTMATzE5U
   ezghMljKSTgg6YcE9Wngfir15+d6YC2sTTKsPjYs3DE3FiukfnKP3whD+
   LCtqKizIiiK8DylVtXrjdo8t+/rFceHPx16osGZDDLwSpAHgKbro0mYmN
   tfG0wJpjeW6IcYWc7tCV35k6msa/imncxI34vIxkq1blF1UgwfbVAZ7oF
   g==;
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="195664087"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2023 01:29:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 01:29:17 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 01:29:13 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>,
        <alexanderduyck@fb.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v6 net-next 1/2] net: phy: micrel: Fixed error related to uninitialized symbol ret
Date:   Fri, 6 Jan 2023 13:59:04 +0530
Message-ID: <20230106082905.1159-2-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230106082905.1159-1-Divya.Koppera@microchip.com>
References: <20230106082905.1159-1-Divya.Koppera@microchip.com>
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

Initialized return variable

Fixes Old smatch warnings:
drivers/net/phy/micrel.c:1750 ksz886x_cable_test_get_status() error:
uninitialized symbol 'ret'.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
v5 -> v6:
- Removed fixes tag as this is fixing static analysis issus and not
  a real fix.

v4 -> v5:
- No changes, added reviewed by tag.

v3 -> v4:
- Split the patch for different warnings.

v1 -> v3:
- No changes
---
 drivers/net/phy/micrel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 26ce0c5defcd..1bcdb828db56 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2088,7 +2088,8 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 	const struct kszphy_type *type = phydev->drv->driver_data;
 	unsigned long pair_mask = type->pair_mask;
 	int retries = 20;
-	int pair, ret;
+	int ret = 0;
+	int pair;
 
 	*finished = false;
 
-- 
2.17.1

