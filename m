Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67C96ECF5F
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbjDXNk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjDXNkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:40:42 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18873A26A
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682343616; x=1713879616;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EE5wsdf2yMV5KS9cpXZnn/4tnWvxn8YNNNj+QeoSKZs=;
  b=OjPOgQO9wkJstr8VJSrDF32iqpaXFRH2kEmt5TIvOdXDkAYvRMfPGe/M
   D3KbIHU7irDyfIssSeHr6xnl3xqQH7X0FkuykZTEHMYg6JOioQUZ1Kky9
   BfIwLDalVlNTo+/HebMP40vlszEc9rR7WQo139iv4OmZFsQfRbI/P0rhf
   DVxSSSW1inLYvdaIoWf46HfirfHa+TIxmy/+v7EgR4HEaGaxhTWCb8PmP
   QsmKA4s9ibHUsC0zKk12NylsYjPC8n/nse+iod8VaYUyjgCv2jZz7SDbg
   hPoRZYpeLzPp+JTODdLdAUO/fl7xnurZWvshgFO2Wm5WHy47KUoFGq5e9
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30519660"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 24 Apr 2023 15:40:11 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 24 Apr 2023 15:40:11 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 24 Apr 2023 15:40:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682343611; x=1713879611;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EE5wsdf2yMV5KS9cpXZnn/4tnWvxn8YNNNj+QeoSKZs=;
  b=jtktcePVF8SEPkmzc1fOxH9YR0t+VpGb893g4TNWwwL6bZShbpWfuDuZ
   we4c3rig73cAvDEqrwJaN3nR7LqQx8v4JKvJNj50EWwzm9iEogH8rTJqX
   aNcfMcmd/ar0J6/sv/HWjUOyZiHxaIVA3To1y1j51Lc01ZRId+Au6HIS8
   Xgx/xXPLgZUcNVNS4STOA7UixFhCO/7eaFvNwX8S7Q7OSCZpXW7U7heO9
   G7fW0yoCdCxOxyFuqk4QILvtQN2kCXyDYdwouhaPDw22BS9S5WhuAF/EP
   6qLOBumTPj6ysvroqCfV8CDysDmOIZ/39eCuZvEQtcX0aVX4EaxscodXv
   A==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30519659"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 24 Apr 2023 15:40:11 +0200
Received: from steina-w.tq-net.de (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 47BAA280056;
        Mon, 24 Apr 2023 15:40:11 +0200 (CEST)
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
Subject: [PATCH 1/1] net: phy: Fix reading LED reg property
Date:   Mon, 24 Apr 2023 15:40:02 +0200
Message-Id: <20230424134003.297827-1-alexander.stein@ew.tq-group.com>
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
phy_device::index is u8, so an intermediate step is necessary, without
changing the whole phydev LED API.

 drivers/net/phy/phy_device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d373446ab5ac..d5c4c7f86a20 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3028,6 +3028,7 @@ static int of_phy_led(struct phy_device *phydev,
 	struct led_init_data init_data = {};
 	struct led_classdev *cdev;
 	struct phy_led *phyled;
+	u32 index;
 	int err;
 
 	phyled = devm_kzalloc(dev, sizeof(*phyled), GFP_KERNEL);
@@ -3037,10 +3038,11 @@ static int of_phy_led(struct phy_device *phydev,
 	cdev = &phyled->led_cdev;
 	phyled->phydev = phydev;
 
-	err = of_property_read_u8(led, "reg", &phyled->index);
+	err = of_property_read_u32(led, "reg", &index);
 	if (err)
 		return err;
 
+	phyled->index = index;
 	if (phydev->drv->led_brightness_set)
 		cdev->brightness_set_blocking = phy_led_set_brightness;
 	if (phydev->drv->led_blink_set)
-- 
2.34.1

