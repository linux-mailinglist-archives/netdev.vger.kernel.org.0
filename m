Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C872C0F0C
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389702AbgKWPjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389649AbgKWPjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:39:02 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D486C061A4D;
        Mon, 23 Nov 2020 07:39:02 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id a16so23935599ejj.5;
        Mon, 23 Nov 2020 07:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+FeXibTuIgwGfVQRfzn1QNcdeuVRN4zL8aR37xT1P1E=;
        b=IurMSwYnPKLYb4Iqmtc/C5bWUGna4RmdWi5lMn3oj6+TZM4aoCTJOatM+LSEcqAfc5
         5+OU7an60iO34LKtloCoKslhW4st8kvXA5OsUrxRUxWEA92gwFBymUS9GsdWaWW3Wgpm
         gvru1ESD0UGXOlOPSTK3IqIdLEAL4FJAQv+FFq/W9dk5p5VtDAkay8mm7NvL4ltDHTu5
         Tp34i13xf5oxXL8PSikjD2EmuESLBqkfSBZCbcflL17LwLjTVAdzcMKdkpo3EPzYo6xn
         lI+9KhosO4mGrMrg1furqV/We6lxHj95syomMT2fGggoyFltUu9WORRsatht7Y7awke0
         x1pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+FeXibTuIgwGfVQRfzn1QNcdeuVRN4zL8aR37xT1P1E=;
        b=cmnUDFsDJEA0ZZWRMmdFlYDKcrYKlV/DJFK4TBcK3UCSTgn9KHyEJAcZGVVOYufPFE
         SXUh5XpC2/ojiYOR5mPDXLCcZya2+8wBw9zluBhfc5kXNgBNYVITpVVUrFLZTP11+jHO
         iTDCwldoXvF2laTT5VfZ4J4Nx1d/d5gS0/0qWhXs5zmWmq64ohx/QatBtG0ON3IbEVLv
         j3cWkma/mmEi9u7aBtmT8tZR+V4sZ9RXxmlLMHsjgXJWOKb4U3X5l0bLc2+QP5r/BOW6
         bkn9CmA/U+K6XO221XJ1pQ7UOJ5kuRHSLjIsScsmQGgplRMW4ZGj9DLNgCcS+WpoyZgp
         bnMg==
X-Gm-Message-State: AOAM530/GlpvPZBXgweNDToVJ3aVt/UU9kFeY+4eShaaLK7yWuSA5JyD
        lOZftWNBWnsD2OnGv8DZqho=
X-Google-Smtp-Source: ABdhPJzbXW1OKamSInKqoX74QDVRyyD9wIGtXiZ+468HVMMYCEfeb5bXfTxii9EAgtnswat5868SQw==
X-Received: by 2002:a17:906:f186:: with SMTP id gs6mr162629ejb.171.1606145940827;
        Mon, 23 Nov 2020 07:39:00 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:39:00 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 14/15] net: phy: qsemi: remove the use of .ack_interrupt()
Date:   Mon, 23 Nov 2020 17:38:16 +0200
Message-Id: <20201123153817.1616814-15-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
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

Also, add a comment describing the multiple step interrupt
acknoledgement process.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/qsemi.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/qsemi.c b/drivers/net/phy/qsemi.c
index 97f29ed2f0ca..d5c1aaa8236a 100644
--- a/drivers/net/phy/qsemi.c
+++ b/drivers/net/phy/qsemi.c
@@ -75,6 +75,10 @@ static int qs6612_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
 
+	/* The Interrupt Source register is not self-clearing, bits 4 and 5 are
+	 * cleared when MII_BMSR is read and bits 1 and 3 are cleared when
+	 * MII_EXPANSION is read
+	 */
 	err = phy_read(phydev, MII_QS6612_ISR);
 
 	if (err < 0)
@@ -96,11 +100,22 @@ static int qs6612_ack_interrupt(struct phy_device *phydev)
 static int qs6612_config_intr(struct phy_device *phydev)
 {
 	int err;
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		/* clear any interrupts before enabling them */
+		err = qs6612_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		err = phy_write(phydev, MII_QS6612_IMR,
 				MII_QS6612_IMR_INIT);
-	else
+	} else {
 		err = phy_write(phydev, MII_QS6612_IMR, 0);
+		if (err)
+			return err;
+
+		/* clear any leftover interrupts */
+		err = qs6612_ack_interrupt(phydev);
+	}
 
 	return err;
 
@@ -133,7 +148,6 @@ static struct phy_driver qs6612_driver[] = { {
 	.phy_id_mask	= 0xfffffff0,
 	/* PHY_BASIC_FEATURES */
 	.config_init	= qs6612_config_init,
-	.ack_interrupt	= qs6612_ack_interrupt,
 	.config_intr	= qs6612_config_intr,
 	.handle_interrupt = qs6612_handle_interrupt,
 } };
-- 
2.28.0

