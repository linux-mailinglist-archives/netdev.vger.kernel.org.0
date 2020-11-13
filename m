Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADEA2B20FC
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKMQxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbgKMQxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:18 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9C0C0613D1;
        Fri, 13 Nov 2020 08:53:18 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id oq3so14417934ejb.7;
        Fri, 13 Nov 2020 08:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aWtwI+k7UCBs0l74OtNTgocL7WE2uWiSxbu1sqlhGi0=;
        b=hFTvM0KXcAWgZYGr94f2uXH2yeNL7use8w0TgX4TOZ8EPYJIzI57RODxLXbQDVi+oJ
         0w4BGiHBCAVopmSHu+Kndle5eoR3PODnPfPh5RuS32uH1gPC472fLHJ5JVzg6N9SLZ/8
         nyCGbQdE/LKBDw676PN+0EwnxaqcWs1BDqNymzWnfXg1PvCNEKG7PYByXSR/K+wbS6tS
         4XCSyGWDaB1U3U4CHFCA628QoO4gG4dftzYG9Oy0Gpz0vV1stT/7nRzJOfWQtzOUB9jG
         yDgfpLW3Mvk6HbuNvvwpk8l/hzsVfX8UigQBfac8Eai3j8g0CgIJhmcLPq+rzZ2Exhq/
         wZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aWtwI+k7UCBs0l74OtNTgocL7WE2uWiSxbu1sqlhGi0=;
        b=ZYK3Sip9hYS+fSyzpGMzulwZq3m9UxyQhmGzUhRz8TBlIJFhzohPAISzssd0+RTkLq
         Tm+pGF71BMzNcdoyF45/XucV/JEIGImkOJPgADQd+V7GjxtjK/bWeVdEUgAW4P81L9ID
         uodQZYUHh1Wre8rP/3F/w6JqnLafgDa2fz91icPCZHLF/p5MZRbwe91cwxXmg52SUAJt
         reERGsELzm4ldH2FUmvpL7oj2Wa/4wanzvK5/erscSy1fbk8aDKTpZCmlKnOJ06C7f7w
         BrGWSllSY7CUJ2B2sUzX2a6/mj7hj5j0d3XacHDe74zEELXqSy/xzxvt1UwAiFmRIOVV
         xW5g==
X-Gm-Message-State: AOAM5327L4K/S+HQajg8TbMDSajXJcTfK0bG2A/dAvd5474oxEwxAYHC
        Rn8sxbz970yZrmywZJ2XkFo=
X-Google-Smtp-Source: ABdhPJzNnqyazxNApGEKsEr4UoLr+b5Hkh79+r62SMBF824IvIue2XnkbV1SgOkfmpP2kPT3n3BsZQ==
X-Received: by 2002:a17:906:35da:: with SMTP id p26mr2795962ejb.256.1605286391510;
        Fri, 13 Nov 2020 08:53:11 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:53:10 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RESEND net-next 16/18] net: phy: ste10Xp: remove the use of .ack_interrupt()
Date:   Fri, 13 Nov 2020 18:52:24 +0200
Message-Id: <20201113165226.561153-17-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113165226.561153-1-ciorneiioana@gmail.com>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In preparation of removing the .ack_interrupt() callback, we must replace
its occurrences (aka phy_clear_interrupt), from the 2 places where it is
called from (phy_enable_interrupts and phy_disable_interrupts), with
equivalent functionality.

This means that clearing interrupts now becomes something that the PHY
driver is responsible of doing, before enabling interrupts and after
clearing them. Make this driver follow the new contract.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/ste10Xp.c | 41 +++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/net/phy/ste10Xp.c b/drivers/net/phy/ste10Xp.c
index 9f315332e0f2..431fe5e0ce31 100644
--- a/drivers/net/phy/ste10Xp.c
+++ b/drivers/net/phy/ste10Xp.c
@@ -48,32 +48,37 @@ static int ste10Xp_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int ste10Xp_ack_interrupt(struct phy_device *phydev)
+{
+	int err = phy_read(phydev, MII_XCIIS);
+
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static int ste10Xp_config_intr(struct phy_device *phydev)
 {
-	int err, value;
+	int err;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		/* clear any pending interrupts */
+		err = ste10Xp_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		/* Enable all STe101P interrupts (PR12) */
 		err = phy_write(phydev, MII_XIE, MII_XIE_DEFAULT_MASK);
-		/* clear any pending interrupts */
-		if (err == 0) {
-			value = phy_read(phydev, MII_XCIIS);
-			if (value < 0)
-				err = value;
-		}
-	} else
+	} else {
 		err = phy_write(phydev, MII_XIE, 0);
+		if (err)
+			return err;
 
-	return err;
-}
-
-static int ste10Xp_ack_interrupt(struct phy_device *phydev)
-{
-	int err = phy_read(phydev, MII_XCIIS);
-	if (err < 0)
-		return err;
+		err = ste10Xp_ack_interrupt(phydev);
+	}
 
-	return 0;
+	return err;
 }
 
 static irqreturn_t ste10Xp_handle_interrupt(struct phy_device *phydev)
@@ -101,7 +106,6 @@ static struct phy_driver ste10xp_pdriver[] = {
 	.name = "STe101p",
 	/* PHY_BASIC_FEATURES */
 	.config_init = ste10Xp_config_init,
-	.ack_interrupt = ste10Xp_ack_interrupt,
 	.config_intr = ste10Xp_config_intr,
 	.handle_interrupt = ste10Xp_handle_interrupt,
 	.suspend = genphy_suspend,
@@ -112,7 +116,6 @@ static struct phy_driver ste10xp_pdriver[] = {
 	.name = "STe100p",
 	/* PHY_BASIC_FEATURES */
 	.config_init = ste10Xp_config_init,
-	.ack_interrupt = ste10Xp_ack_interrupt,
 	.config_intr = ste10Xp_config_intr,
 	.handle_interrupt = ste10Xp_handle_interrupt,
 	.suspend = genphy_suspend,
-- 
2.28.0

