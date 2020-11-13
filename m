Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863F72B210F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgKMQyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgKMQw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:52:59 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6F2C0613D1;
        Fri, 13 Nov 2020 08:52:59 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id za3so14422269ejb.5;
        Fri, 13 Nov 2020 08:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EHyQQOuXf5BU03as2u/ud2yF/KPxzFMDQ2v3ffUTBGc=;
        b=Oac01yGweCMZw6kb246TzAFc9ilEewb/HZbnmGUX6zedWmsgFK6tX58LKExOjTv7LY
         sR0/1GNxFdcbYbIz6xUB5rJRMST1LCVK7WwOpOz4A9YnAM8BUO1u6gMrxEwMBpKNjoLo
         C9CP7xNg7iKQszCoRt68u3Kkuegldndix+cdW/bTbsx9CubAQufzvL80B0unkThyAefg
         NDjjKoaEmWBfc/h4KJr8ZSM2OzB7NQA//rjWuJQLd7C9GwMq+ynmihP+Ii96/YKSMMMa
         sk1W5xCQ2FfY55epYqPM2jib/8udUoUefM8R8Hcdbd/tDTNhRXk6sZ5PJ5DhmrJOt50Y
         H0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EHyQQOuXf5BU03as2u/ud2yF/KPxzFMDQ2v3ffUTBGc=;
        b=JXtKmmTzA/aS/C7jyY15n+/th3C7jSExn+/mvv7ZGVdlBMy/NeOYZnz4wUb0qMOZMm
         bC0ac+cBde3nQR5/muCCytC2vOhw7rkJayRSXygUIDAj/9WfygWFlD+sv6GXb5EtNY3/
         LGwBHeU36blja9uZdu0vadpsn1CxR9D3dGzXR9W+TYG13MWHqe8eKi15bA2cAfq44ycc
         20EvfMriVErHnmtWFkSGxiiDX52a+uD4eZNPfmvdfuMN9NyEhUvp0GdV7y9ZBYe3PUId
         ePWHh5wX5s46sISGCLLQc8OJW7Csn94NkrLFjPRzz9KyUii8P9DNkozPGfrEt4xtNqIg
         GpcA==
X-Gm-Message-State: AOAM533bxIosjlhSV1rxWfb5FnKT1zacq9B23LVs4VbmYmL9RDMeusMU
        SjzxGuxsEPMG24+zhA4k7gtB4HGFF0Jo4w==
X-Google-Smtp-Source: ABdhPJz1r0DmTYhLVU80IGjksPD85Ungzwvv9wsKtpDUE0KbejhhGNnG3LFWMpuXKT2zf6q1xJ3ZLg==
X-Received: by 2002:a17:906:57cc:: with SMTP id u12mr2840322ejr.163.1605286377686;
        Fri, 13 Nov 2020 08:52:57 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:52:57 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH RESEND net-next 08/18] net: phy: lxt: remove the use of .ack_interrupt()
Date:   Fri, 13 Nov 2020 18:52:16 +0200
Message-Id: <20201113165226.561153-9-ciorneiioana@gmail.com>
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

Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/lxt.c | 44 +++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
index 716d9936bc90..0ee23d29c0d4 100644
--- a/drivers/net/phy/lxt.c
+++ b/drivers/net/phy/lxt.c
@@ -78,10 +78,23 @@ static int lxt970_ack_interrupt(struct phy_device *phydev)
 
 static int lxt970_config_intr(struct phy_device *phydev)
 {
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
-		return phy_write(phydev, MII_LXT970_IER, MII_LXT970_IER_IEN);
-	else
-		return phy_write(phydev, MII_LXT970_IER, 0);
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = lxt970_ack_interrupt(phydev);
+		if (err)
+			return err;
+
+		err = phy_write(phydev, MII_LXT970_IER, MII_LXT970_IER_IEN);
+	} else {
+		err = phy_write(phydev, MII_LXT970_IER, 0);
+		if (err)
+			return err;
+
+		err = lxt970_ack_interrupt(phydev);
+	}
+
+	return err;
 }
 
 static irqreturn_t lxt970_handle_interrupt(struct phy_device *phydev)
@@ -129,10 +142,23 @@ static int lxt971_ack_interrupt(struct phy_device *phydev)
 
 static int lxt971_config_intr(struct phy_device *phydev)
 {
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
-		return phy_write(phydev, MII_LXT971_IER, MII_LXT971_IER_IEN);
-	else
-		return phy_write(phydev, MII_LXT971_IER, 0);
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = lxt971_ack_interrupt(phydev);
+		if (err)
+			return err;
+
+		err = phy_write(phydev, MII_LXT971_IER, MII_LXT971_IER_IEN);
+	} else {
+		err = phy_write(phydev, MII_LXT971_IER, 0);
+		if (err)
+			return err;
+
+		err = lxt971_ack_interrupt(phydev);
+	}
+
+	return err;
 }
 
 static irqreturn_t lxt971_handle_interrupt(struct phy_device *phydev)
@@ -285,7 +311,6 @@ static struct phy_driver lxt97x_driver[] = {
 	.phy_id_mask	= 0xfffffff0,
 	/* PHY_BASIC_FEATURES */
 	.config_init	= lxt970_config_init,
-	.ack_interrupt	= lxt970_ack_interrupt,
 	.config_intr	= lxt970_config_intr,
 	.handle_interrupt = lxt970_handle_interrupt,
 }, {
@@ -293,7 +318,6 @@ static struct phy_driver lxt97x_driver[] = {
 	.name		= "LXT971",
 	.phy_id_mask	= 0xfffffff0,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt	= lxt971_ack_interrupt,
 	.config_intr	= lxt971_config_intr,
 	.handle_interrupt = lxt971_handle_interrupt,
 	.suspend	= genphy_suspend,
-- 
2.28.0

