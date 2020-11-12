Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4E32B095C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgKLQAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728813AbgKLP6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:19 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F962C0613D1;
        Thu, 12 Nov 2020 07:58:19 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id y4so1024691edy.5;
        Thu, 12 Nov 2020 07:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5eEkZyJuYqDgw3qo/V0uy1CW8YE9RreYkILxojzWYTQ=;
        b=c2qUOZpv1mSeHE1Ezmz+x7EJn7Cxg6PhpctF3FEnsMkIKNC1XCV6m9mV/ot9/XsPKR
         ZgtWVVN7YpFDpO8zOsiNDokInSOOOkLaRvkh9in2p3Gq3JIjsQUaQivyjkB83+QnUPHJ
         cZYVy9M+3iC/0k6HkhcfAeuGnKmdsJFyveY6e8x/7LHDN1iNUvbYitGbmmJhUx2nu1AQ
         A7+Kq5hU5DaSiyhX4mmOrIY/0GLSNW9J4A8bLvD6b+f/RpetYDflool6v4soHnEh3q5d
         LLyorezhK9OUOMbOkJ4CId88ZxD3bBIsjt/Zg2r8bgfg3g7kgnP6I6+QlX6h+3fwsZiB
         +lfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5eEkZyJuYqDgw3qo/V0uy1CW8YE9RreYkILxojzWYTQ=;
        b=dpacLMG+M6w57PIJ3D91stOYn7fB1LJpux77T3sWKfH2AceQ5XrbSCniaF/zIPHOaQ
         d0T55lnb+knhAK/gOT+BykYndjZ7WwqJ7NKu5gm+iVfP0FX5LIIJWPRCRCr2+qWb/Cuf
         /0/kC/t3IIuJg3ialHS5hQNibiOSbjXH3FXgIUZtkgoAwfksu6ptpfk5UTeuHxjFPAyS
         tN/DLZ7EUpRTvzONfvPE9DmxOVa2rcJj0J9K6TqnM1MraXw8l/Uah+KlvksnpC3b06GQ
         uJL2cXLHSnhfOQk+x4ulSUbYzY35bmT2eYFH2nGaUNfmJMfYJStBT4SDDKV+snPzXuso
         mq9Q==
X-Gm-Message-State: AOAM531QQ3YUB6/QqTUwySl4BFDy9Fe4IxOROKL/chsHJ+XH6P8NDrP8
        Owo6Mnhp0BPjGnAnPJLllrw=
X-Google-Smtp-Source: ABdhPJw3df+uqCkDTrnHagdbtlV3X9OJKGfd7YDfg0VX5HTAdKhJRkl3yzc3MVxzn2rHM0Hfp9x+tA==
X-Received: by 2002:a05:6402:44b:: with SMTP id p11mr440411edw.164.1605196697966;
        Thu, 12 Nov 2020 07:58:17 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:17 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 02/18] net: phy: vitesse: remove the use of .ack_interrupt()
Date:   Thu, 12 Nov 2020 17:54:57 +0200
Message-Id: <20201112155513.411604-3-ciorneiioana@gmail.com>
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

Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/vitesse.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/vitesse.c b/drivers/net/phy/vitesse.c
index 9f6cd6ec9747..16704e243162 100644
--- a/drivers/net/phy/vitesse.c
+++ b/drivers/net/phy/vitesse.c
@@ -275,25 +275,14 @@ static int vsc8601_config_init(struct phy_device *phydev)
 	return 0;
 }
 
-static int vsc824x_ack_interrupt(struct phy_device *phydev)
-{
-	int err = 0;
-
-	/* Don't bother to ACK the interrupts if interrupts
-	 * are disabled.  The 824x cannot clear the interrupts
-	 * if they are disabled.
-	 */
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
-		err = phy_read(phydev, MII_VSC8244_ISTAT);
-
-	return (err < 0) ? err : 0;
-}
-
 static int vsc82xx_config_intr(struct phy_device *phydev)
 {
 	int err;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		/* Don't bother to ACK the interrupts since the 824x cannot
+		 * clear the interrupts if they are disabled.
+		 */
 		err = phy_write(phydev, MII_VSC8244_IMASK,
 			(phydev->drv->phy_id == PHY_ID_VSC8234 ||
 			 phydev->drv->phy_id == PHY_ID_VSC8244 ||
@@ -420,7 +409,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init    = &vsc824x_config_init,
 	.config_aneg    = &vsc82x4_config_aneg,
-	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -430,7 +418,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init	= &vsc824x_config_init,
 	.config_aneg	= &vsc82x4_config_aneg,
-	.ack_interrupt	= &vsc824x_ack_interrupt,
 	.config_intr	= &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -440,7 +427,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init    = &vsc824x_config_init,
 	.config_aneg    = &vsc82x4_config_aneg,
-	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -449,7 +435,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	.phy_id_mask    = 0x000ffff0,
 	/* PHY_GBIT_FEATURES */
 	.config_init    = &vsc8601_config_init,
-	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -495,7 +480,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.config_init    = &vsc824x_config_init,
 	.config_aneg    = &vsc82x4_config_aneg,
-	.ack_interrupt  = &vsc824x_ack_interrupt,
 	.config_intr    = &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -505,7 +489,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	.name		= "Vitesse VSC8221",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= &vsc8221_config_init,
-	.ack_interrupt	= &vsc824x_ack_interrupt,
 	.config_intr	= &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 }, {
@@ -515,7 +498,6 @@ static struct phy_driver vsc82xx_driver[] = {
 	.name		= "Vitesse VSC8211",
 	/* PHY_GBIT_FEATURES */
 	.config_init	= &vsc8221_config_init,
-	.ack_interrupt	= &vsc824x_ack_interrupt,
 	.config_intr	= &vsc82xx_config_intr,
 	.handle_interrupt = &vsc82xx_handle_interrupt,
 } };
-- 
2.28.0

