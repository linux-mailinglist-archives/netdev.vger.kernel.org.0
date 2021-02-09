Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBA831452F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhBIBBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhBIBBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 20:01:18 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64683C06178B;
        Mon,  8 Feb 2021 17:00:37 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0614423E5F;
        Tue,  9 Feb 2021 02:00:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612832435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tlMbOLlnttzc2yi2QIs9YDNySRHjbXZPpuZQyV3BLzs=;
        b=OG/65SgjmeyYnrPIRTtOEUJ1/2nrJuwI/MmGlMAQaE8xkZXmuqCfDn/zUnOTtqrYUA7qrF
        PQolq/xCDsyTN0h6nkbFIjqx3OkYN9xR6p4D12PO8Xn6Yd0BGG5eIA8KJw2Fi4tWc6rl45
        PmoAXTCW5mJNNsVoXoshr13wrH8HqsY=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: phy: drop explicit genphy_read_status() op
Date:   Tue,  9 Feb 2021 02:00:18 +0100
Message-Id: <20210209010018.1134-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

genphy_read_status() is already the default for the .read_status() op.
Drop the unnecessary references.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/marvell.c | 1 -
 drivers/net/phy/micrel.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 620052c023a5..b523aa37ebf0 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2852,7 +2852,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = m88e1145_config_init,
 		.config_aneg = m88e1101_config_aneg,
-		.read_status = genphy_read_status,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 39c7c786a912..494abf608b8f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1368,7 +1368,6 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz9131_config_init,
-	.read_status	= genphy_read_status,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
-- 
2.20.1

