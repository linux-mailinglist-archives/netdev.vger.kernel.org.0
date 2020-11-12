Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50012B093B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgKLP7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgKLP6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:38 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF1AC0613D1;
        Thu, 12 Nov 2020 07:58:37 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f20so8585354ejz.4;
        Thu, 12 Nov 2020 07:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aWtwI+k7UCBs0l74OtNTgocL7WE2uWiSxbu1sqlhGi0=;
        b=J1itocdu74iBJHe9bC3lu+mulg15sQhTODrKNljLmDe1HbchhgOGq1zytThZ2AVlv7
         uWoZb1MNv1JeN6xii6ltpfx3c/deg7GAQw6nBBacDVRloIPaKvlCQGrCSFPmQlFts3Dv
         9Brme+ZJs91T0AOPL+UI2oVnYNmIhJuJOXghGc/oUpQN3mLZPv+YoRcVAnDvWndIURqv
         E0pb/KKwbmfrMfcmabMilIV6ZJcEFAIGTkocrNUqxLD3vF02yGjR1EQTLBmmr/Ng1U5O
         JT1EQ2QPpwnMf2Ok2dPPc7xnlt8uWu4xL+vcx8xp/mTU4jyHf5soCpafgGaCbCBlohzU
         1feA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aWtwI+k7UCBs0l74OtNTgocL7WE2uWiSxbu1sqlhGi0=;
        b=nzUK/Acoxjk2ghwefNdYbwiQOYqhm9Hy7oheW1OEXfQpjVRDWK1bDAMfnjaMWpY+Ni
         dFrPXkLcD3w5YJKgQ7nj7lcLMWOVJl1i+EpWyYMCYSHKUuvM2Qo0tIMwGEFvdm41z9EW
         pLZ7i/7LJhwWCdk28EIz0a7fiBmp4snqlA4fax5oCeAI7OR5bnKsQDc59EN4EA47QmVi
         gzWL84SCriiDUxjwc/5cGZ8C3ua9eCLsuCwlywK9TQhT8JeUE3oKU44echsqiolzm21d
         JMQWxneyeIGDkrc19LdvCN4n8RNlelTSVbq8dh7WkkskQcoruSiAnYXnFsBx8RGo21R+
         J1Rw==
X-Gm-Message-State: AOAM532CU+Js6CvDRWs28lpqcX0uUessRjbDlpLFTuvh4EuqxEEo71NB
        49BYIaY4PaqzEW+nNx9AWBY=
X-Google-Smtp-Source: ABdhPJywpd7JouNjscBecWHwRzLDMfR7VJnMGTg84KvhhOoDtu/RdbBVQfnzvrsNO10/CfOOFscsOw==
X-Received: by 2002:a17:906:43c7:: with SMTP id j7mr29431216ejn.397.1605196716593;
        Thu, 12 Nov 2020 07:58:36 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:36 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 16/18] net: phy: ste10Xp: remove the use of .ack_interrupt()
Date:   Thu, 12 Nov 2020 17:55:11 +0200
Message-Id: <20201112155513.411604-17-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112155513.411604-1-ciorneiioana@gmail.com>
References: <20201112155513.411604-1-ciorneiioana@gmail.com>
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

