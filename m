Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA584643DAA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbiLFHf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiLFHfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:35:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565C310063;
        Mon,  5 Dec 2022 23:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670312122; x=1701848122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GqE71AOT1+Vhdnn7SHVKZ/Nhi1ar3JcXjhGeYGWKShg=;
  b=kzVE0fodtUtSsheLYe9f2OpjEBmj4WgCdfcEixUBWlrZSmM/33wWxL+N
   lGUdzRDJURaqIwvG7pwcCEkfPwxYy2iI2ERx4XFn4epkHz8ChuQYHiN9T
   TVmib3NeMBA5BZMwJrBZdT3uALSREMkeCrQBHyDV64RMmjQ6D8oZCQef2
   x/ghsmOi9O6GPGKKbNwNYZKrqxC1Wm1cCjntCL9L4xu4wNYrZWBw4DtQ6
   M6x8yOOM0MjyVExo4GpZ1XB77mWvGuLwZJu5nyHQTJJJiVsXgSgRYFClH
   s12tdTfMDQapzUslh318VLqrnTR9az+aHqkVqspSH6Lm1oaf9IT4F7bJX
   g==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="202761487"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 00:35:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 00:35:21 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 00:35:17 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v5 net-next 1/2] net: phy: micrel: Fixed error related to uninitialized symbol ret
Date:   Tue, 6 Dec 2022 13:05:10 +0530
Message-ID: <20221206073511.4772-2-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221206073511.4772-1-Divya.Koppera@microchip.com>
References: <20221206073511.4772-1-Divya.Koppera@microchip.com>
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
Fixes: 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814 phy")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
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

