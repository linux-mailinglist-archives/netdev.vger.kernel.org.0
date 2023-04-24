Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7D76ED026
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 16:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjDXORI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 10:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjDXORH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 10:17:07 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469727A9B
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 07:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682345825; x=1713881825;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qgX4yDNOpCzz8tPLFu5vDrjBt+wVpc+dsQJJhds6R4g=;
  b=ZxEGxlDhfMiNfbHALGI/22ruQx3a3xMJ6vMPorvfFWsk+rOeZ/Hd2HIA
   QxIHo0aAY6mrRSD8hj2Nmp4Xkopo6el/KDHBCVuDNueYzpBaNGdLKjG/c
   4+CmntMulOtua6MzMOdpqVSWyuon9STt39RkgxqulgP3iIpDuWKpahRRi
   T3ODlEkL6O3HTvzt2BDBw6JyTsHRzCABHUiZ/5ZTWG5ZKbtXev/QxiBlC
   bIIKCcLVW1oCaNxZRPhQ0P3QnxRkEgMEL/oLpYsptxh2dGsCMswR6NKdM
   7UEXzVRSiSBFLVdmK6H4+sj8juBUqIQuLeLUsHjpxDeCdbRJ3u7UdY7/v
   w==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30520968"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 24 Apr 2023 16:17:03 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 24 Apr 2023 16:17:03 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 24 Apr 2023 16:17:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682345823; x=1713881823;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qgX4yDNOpCzz8tPLFu5vDrjBt+wVpc+dsQJJhds6R4g=;
  b=NhfNDFyopT4TRFWWeixZbUqPcN3jcMokJnvHRFnZhBFVYmxOLBtYJqnZ
   felxMCN7Pbw5Wj9aW9Pp5WO+ZFP+PFkqZPrkB3/ppr/Cnb7G6HwvhhSeX
   4BcWHNFbCKXYUhbbUHXoSf+XzkDEIyh3mlL7GYsgTVEnclltDyIQMgiMj
   cv9deFBKkgh+YglblwHTrBbu/i2SCCC/g02d6ioGUCjpuCE7Ll9kyKCyT
   rsJqbS/QaesLl+BsrjkmBGJGreV16I2CrmN9BiVYgl4Z1bI68FIDtlOse
   dR+sNbymzq5VQobCVArrtBKPrsNHEt0nQZjUWxy7w3DgdVWh5+WMaeGMU
   A==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30520967"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 24 Apr 2023 16:17:03 +0200
Received: from steina-w.tq-net.de (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 54CF1280056;
        Mon, 24 Apr 2023 16:17:03 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/1] net: phy: Fix reading LED reg property
Date:   Mon, 24 Apr 2023 16:16:48 +0200
Message-Id: <20230424141648.317944-1-alexander.stein@ew.tq-group.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'reg' is always encoded in 32 bits, thus it has to be read using the
function with the corresponding bit width.

Fixes: 01e5b728e9e4 ("net: phy: Add a binding for PHY LEDs")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
---
Changes in v2:
* Explicitly do range check before assigning to u8

 drivers/net/phy/phy_device.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d373446ab5ac..17d0d0555a79 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3028,6 +3028,7 @@ static int of_phy_led(struct phy_device *phydev,
 	struct led_init_data init_data = {};
 	struct led_classdev *cdev;
 	struct phy_led *phyled;
+	u32 index;
 	int err;
 
 	phyled = devm_kzalloc(dev, sizeof(*phyled), GFP_KERNEL);
@@ -3037,10 +3038,13 @@ static int of_phy_led(struct phy_device *phydev,
 	cdev = &phyled->led_cdev;
 	phyled->phydev = phydev;
 
-	err = of_property_read_u8(led, "reg", &phyled->index);
+	err = of_property_read_u32(led, "reg", &index);
 	if (err)
 		return err;
+	if (index > U8_MAX)
+		return -EINVAL;
 
+	phyled->index = index;
 	if (phydev->drv->led_brightness_set)
 		cdev->brightness_set_blocking = phy_led_set_brightness;
 	if (phydev->drv->led_blink_set)
-- 
2.34.1

