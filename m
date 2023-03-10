Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B500C6B37A6
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCJHqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCJHqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:46:03 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3FD3B3FD
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1678434309; x=1709970309;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z91X3tMJiBai9L+GYTYXMNhmzQTiOYex0ekL7SgTIJk=;
  b=h6Y+ej+5Y5cnYF+QxZSeA//Dop27m+y1p1hjO0rk5RNInLgEM5zGDIud
   4qFCdO9Ia2pAEytpUZEhFT2yDpZOFDWaaqMZCBJ/3dh0rTPIMp7Wvt3R0
   NKfQBRMbGqqQ/w5X9NpUH1j4HU3fPOejWZ6bS/Uu5FnU2K6rsRD1FM2dq
   tzTIMFH/fBEHtY3M54ZzK73EPFvaLwayA/TTckl/YuRv8wTl7Iup3N3D2
   7B8qcEBfJ62A96nBNnqBlXdI+h1luE8vwlJyXGLnN9NbrC2iV6bipD/aw
   VEUbJBhcgosOO32TIn5vSWLmoeYtq0UKH6azmiP65Dh3ErDEb8Ovx9E0Y
   A==;
X-IronPort-AV: E=Sophos;i="5.98,249,1673910000"; 
   d="scan'208";a="29596762"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 10 Mar 2023 08:45:07 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 10 Mar 2023 08:45:07 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 10 Mar 2023 08:45:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1678434307; x=1709970307;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z91X3tMJiBai9L+GYTYXMNhmzQTiOYex0ekL7SgTIJk=;
  b=LBjydBAkFujR7esHURlehmspnK//v/gu4qh/mIhIr5yaVWRhr1e1RZN3
   Irou0BKGlLEB3zqR0FhNwjrA3W4/xkswP1Cdsm8UAQp6ms0CUoIhiW/QF
   9WOaVHwmuJbE5CKEi1sM8GqPfVSrUBOiAy01V+GRwSS/Z45foADem4kzE
   aYOV8b9E9h2lOXQHNw/eyKPalHC+rlNIM1aOTvZxyTbwp6UVnOfIrdJ8K
   C4DXdqkmvBfK3Ovuh5UeWIbJd5HS2LUyOn9a8GpJOoug+CGAexQgUYshe
   jsmjvt1xIqk58UVw1xrvzh3/p95zZFQmYY80SsQSgdaNYY9x2uATNY8b3
   g==;
X-IronPort-AV: E=Sophos;i="5.98,249,1673910000"; 
   d="scan'208";a="29596761"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 10 Mar 2023 08:45:07 +0100
Received: from steina-w.tq-net.de (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id F00C9280056;
        Fri, 10 Mar 2023 08:45:06 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/1] net: phy: dp83867: Disable IRQs on suspend
Date:   Fri, 10 Mar 2023 08:45:00 +0100
Message-Id: <20230310074500.3472858-1-alexander.stein@ew.tq-group.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before putting the PHY into IEEE power down mode, disable IRQs to
prevent accessing the PHY once MDIO has already been shutdown.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
---
Changes in v2:
* Directly call dp83867_config_intr
* Call genphy_resume after enabling IRQs again
* Removed superfluous empty line

 drivers/net/phy/dp83867.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 89cd821f1f46..5821f04c69dc 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -693,6 +693,30 @@ static int dp83867_of_init(struct phy_device *phydev)
 }
 #endif /* CONFIG_OF_MDIO */
 
+static int dp83867_suspend(struct phy_device *phydev)
+{
+	/* Disable PHY Interrupts */
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->interrupts = PHY_INTERRUPT_DISABLED;
+		dp83867_config_intr(phydev);
+	}
+
+	return genphy_suspend(phydev);
+}
+
+static int dp83867_resume(struct phy_device *phydev)
+{
+	/* Enable PHY Interrupts */
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->interrupts = PHY_INTERRUPT_ENABLED;
+		dp83867_config_intr(phydev);
+	}
+
+	genphy_resume(phydev);
+
+	return 0;
+}
+
 static int dp83867_probe(struct phy_device *phydev)
 {
 	struct dp83867_private *dp83867;
@@ -968,8 +992,8 @@ static struct phy_driver dp83867_driver[] = {
 		.config_intr	= dp83867_config_intr,
 		.handle_interrupt = dp83867_handle_interrupt,
 
-		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
+		.suspend	= dp83867_suspend,
+		.resume		= dp83867_resume,
 
 		.link_change_notify = dp83867_link_change_notify,
 		.set_loopback	= dp83867_loopback,
-- 
2.34.1

