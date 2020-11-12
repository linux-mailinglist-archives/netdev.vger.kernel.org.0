Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD5C2B092D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgKLP6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgKLP6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:32 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47F6C0613D4;
        Thu, 12 Nov 2020 07:58:31 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id ay21so6876262edb.2;
        Thu, 12 Nov 2020 07:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3shoGVPTfTeSo9qIFJ3MH89QzogQsCpieTVJw1XX5s=;
        b=D19CIDdvhTLey6DIhu2OwHE+R3OyJghtpO6oKQembC9oNwDuAdc1YRrC/owFiMBeLF
         LPLPw/wfhSkM0mzbjhOnJHIg3ie6ydXxC7i6DSc+Mg7ErPlRuMm8pHPr5hKl/xyELxpN
         hL6NbdmXNPR4TZ2j8jspBEDRmaIIwI6ABrqJ6ayNEWOkkWJNSORj3tkPz9YpzKlc4gmE
         8fc+JORRioDd/oIrC5GO52WbB9DuRnlHVRUg8yKJ3SGNAWJJcUnUbAdxk4oca8Cj+g5+
         Ebc+Lbw7Y3B71rfZdkbMSkmwjles91r5Zf26KA1BVgjxLdbA4IncStFmI1AWoRwWhHQe
         PFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3shoGVPTfTeSo9qIFJ3MH89QzogQsCpieTVJw1XX5s=;
        b=lqSbcAXtlKr/SzNvDWQYB6Frf1+GQqBsAykr/xpG+yZMIJekOudLRo686rW4k0UgNK
         OrqjXI4Duq+jfbG+UeUowwx+Msu6vqW7lVG3XAAG8vWgozblfzECdLc/H7FtnSbNxzdV
         xf0pozZA7s5owvlv0oeaGQRciMAYbGtBsz9R+aKdx5m3abZNL7PEVZwBVs5pGlwTZ0GG
         HCB4D2tylv5QkqBnk21LFLZ8bGy0LWxrrWd2v0D4rbmg6cvh9ACzojyFr+x6gWYzNQwq
         VWLMr4yC8aBs1V9KA0Nt1MmXzUbzhlIRNLR65iUdDexz5KWkYHuk+gwY3LrObRICYPG3
         3nlg==
X-Gm-Message-State: AOAM531x16vzTdXsQ78afVsDQ85fVa71MYKBQ/C6Kit6ZbIwPfN1RV2l
        6RsmlI5x5CtIyRCi5C0Tm8A=
X-Google-Smtp-Source: ABdhPJwJrnl0kNPl3aRB22A6o+ewHPc8ZeMeEIh8GDWBhC7cslSdTo+1pGl/5M42e8cq96+vOwVkOg==
X-Received: by 2002:aa7:d146:: with SMTP id r6mr407168edo.268.1605196709133;
        Thu, 12 Nov 2020 07:58:29 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:28 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, Marek Vasut <marex@denx.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next 10/18] net: phy: nxp-tja11xx: remove the use of .ack_interrupt()
Date:   Thu, 12 Nov 2020 17:55:05 +0200
Message-Id: <20201112155513.411604-11-ciorneiioana@gmail.com>
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

