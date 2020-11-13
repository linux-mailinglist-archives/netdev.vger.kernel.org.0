Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C59A2B20F0
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgKMQxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgKMQxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:05 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0D9C0613D1;
        Fri, 13 Nov 2020 08:53:04 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id o20so11498362eds.3;
        Fri, 13 Nov 2020 08:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3shoGVPTfTeSo9qIFJ3MH89QzogQsCpieTVJw1XX5s=;
        b=ovoPHuwb70D/6RxJYMAFmNGWDZQm4KWTYItMRGH4/h/gtn5F7L8cGqxGrHI/iuJI8/
         2QBylFfo1gPNE8USYs5G4TEWqICZL2bcA/AyRWe8Vmm2MGbRJPBuT2xDJ52QvxkcsB9Z
         2nWQlft6AEiiZFnfWthl7/1lsXyEfWNUFbBbDKd40/tcYls/yID9jLXuPFGcmB6rXAcb
         p5FFHjmnGrhy2O3PwwD6TVVQcHvXDs8y4Eh1rT1PbGfw7gLHXqktIokbIpAE7rLtgq2y
         ikdMPB+TOmvy+xGC9bKbzQBxmC0sRBtItvZ6zvUIgQjiaSbHLk3iLr0UKKwuSiowhnnh
         uqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3shoGVPTfTeSo9qIFJ3MH89QzogQsCpieTVJw1XX5s=;
        b=hMJjNT65EK1S93DSp8vbh5FsZwG7ILOzmr+3L1xDyOtFdZkpX5Ex0MoJW+9C3lqANH
         y9Jm8j19/ksOvdp4pS6uEMuMMWc/PGdweCMJorietgpJe8algS6A+BRIQYQp8kA7l5R0
         yEjgR3aUcU6Bmm0HZTI4+TOJCwPp2bhEBj3ECYtEB4bL9IDWbwVF6YbTli4WsScIiP9n
         xitfLRrSoBaUSUa3+aihIkNbT6HrhoNq7R5QoQLOCOGbDsECUjA7eC+HwTy4+2n6v3/R
         KUtaDKxzIDH6c4/wFsQ4EY4hsiZgxgquohav3qcx61Hm/SywFRJjdb1HZnmNIp3iyAYn
         8/Yg==
X-Gm-Message-State: AOAM53325Er6CZk/f2RizOStnL+yOOacFd0tKzCoxsefwseJfK7TnG9L
        LaS5CkUBTdtb4e2vO8XSwutnl43p9vzUqA==
X-Google-Smtp-Source: ABdhPJyhvt4kgI6EtNtAI6MvYKmADCPxHUL3o4mSl0xF4jT45tR4EsYQxPAIhzO1iaUlyFpXlsJ/Fw==
X-Received: by 2002:a50:bb06:: with SMTP id y6mr3529713ede.278.1605286381524;
        Fri, 13 Nov 2020 08:53:01 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:53:00 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, Marek Vasut <marex@denx.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH RESEND net-next 10/18] net: phy: nxp-tja11xx: remove the use of .ack_interrupt()
Date:   Fri, 13 Nov 2020 18:52:18 +0200
Message-Id: <20201113165226.561153-11-ciorneiioana@gmail.com>
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

Cc: Marek Vasut <marex@denx.de>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/nxp-tja11xx.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 1c4c5c267fe6..afd7afa1f498 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -600,11 +600,24 @@ static int tja11xx_ack_interrupt(struct phy_device *phydev)
 static int tja11xx_config_intr(struct phy_device *phydev)
 {
 	int value = 0;
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = tja11xx_ack_interrupt(phydev);
+		if (err)
+			return err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
 		value = MII_INTEN_LINK_FAIL | MII_INTEN_LINK_UP;
+		err = phy_write(phydev, MII_INTEN, value);
+	} else {
+		err = phy_write(phydev, MII_INTEN, value);
+		if (err)
+			return err;
+
+		err = tja11xx_ack_interrupt(phydev);
+	}
 
-	return phy_write(phydev, MII_INTEN, value);
+	return err;
 }
 
 static irqreturn_t tja11xx_handle_interrupt(struct phy_device *phydev)
@@ -768,7 +781,6 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_sset_count = tja11xx_get_sset_count,
 		.get_strings	= tja11xx_get_strings,
 		.get_stats	= tja11xx_get_stats,
-		.ack_interrupt	= tja11xx_ack_interrupt,
 		.config_intr	= tja11xx_config_intr,
 		.handle_interrupt = tja11xx_handle_interrupt,
 		.cable_test_start = tja11xx_cable_test_start,
@@ -792,7 +804,6 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_sset_count = tja11xx_get_sset_count,
 		.get_strings	= tja11xx_get_strings,
 		.get_stats	= tja11xx_get_stats,
-		.ack_interrupt	= tja11xx_ack_interrupt,
 		.config_intr	= tja11xx_config_intr,
 		.handle_interrupt = tja11xx_handle_interrupt,
 		.cable_test_start = tja11xx_cable_test_start,
-- 
2.28.0

