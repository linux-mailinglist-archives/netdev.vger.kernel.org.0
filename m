Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2562B210C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgKMQyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgKMQxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:00 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C136AC0617A6;
        Fri, 13 Nov 2020 08:52:59 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id za3so14422300ejb.5;
        Fri, 13 Nov 2020 08:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Dxgm0Fh4+mVDplG8D4f9NidT6Io7JYvUTeWlAV1zP4=;
        b=LAG/YVYnAcV1jEK77GCxF3CCd2jp0wHqNo67oikn8zKZlF3NENyGYoiUCIEW2bIw+I
         nlf+5Asa/iD6RPzxJxPMmy5A3Ze1iRzvRF7ZE+SZciWCDelB23dZ1M9zGa88nxMePpHE
         UYHKGAwX9tHVpFS9l03PEuBjxXOUW/w9Fx/SnAm119Cy8IPJKzBqUPF/sIFlQvWzzExK
         9cY+AOaVodBVWI7v8IMzm1tt+qmw+GzTZ49m2eDmjCXeqnKWfWnkYbDE2aRWkbrFfJyj
         LaJjOjxla9jtRxUi+Blmx4RMjRbt+S4Tnnsz87bbKGFodTmHDM/ns/9aUMC7EYOUJgNl
         8LwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Dxgm0Fh4+mVDplG8D4f9NidT6Io7JYvUTeWlAV1zP4=;
        b=SavrNDbuhiCNvxO0fi63D59AM5DrfIsu7TOWRW4XIRdU3BcpvGJktD4s24l8+NGlRF
         Nxj6ZjZtW8+e4HawKMghrZR8NcuXSSVomR3B7jD2+FIicYoARui/Yt9wfbHc3vnpjXHL
         nNrYBPh9ijzTkrBk/MnUl9CUI255Y9K2rRN1MwJnBabZZ8OB8hQiIBgg8ysoDzZqIhrk
         wBvQEjiPUv/ZaATNcqWWZrgHKDHNISklnV7Mj9nI2BTqJW5DlF+4wZo/G3eoJNOeLSBl
         cyDOPcgSm8TUO6P29yTzu/zWs7xtRNPxzhQWfTtI9f6RhKUbujSudpeWZF5E/1EVA9/V
         JLrQ==
X-Gm-Message-State: AOAM5319yFWxqXokYt6E5uXYfrR4Hi3psQh7JtSINkMNhad9Ek8dx50W
        /gvwkac8Riju7grSifAVnEg=
X-Google-Smtp-Source: ABdhPJw9uDMa8hwIIzwTPt848qbP937/aEK7w1XWYSoRbrY3LidzYNNCUDhBioZQCZHzDPCux/bKsQ==
X-Received: by 2002:a17:906:d9ce:: with SMTP id qk14mr2738446ejb.522.1605286373426;
        Fri, 13 Nov 2020 08:52:53 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:52:52 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Baruch Siach <baruch@tkos.co.il>,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH RESEND net-next 05/18] net: phy: marvell: implement generic .handle_interrupt() callback
Date:   Fri, 13 Nov 2020 18:52:13 +0200
Message-Id: <20201113165226.561153-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113165226.561153-1-ciorneiioana@gmail.com>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In an attempt to actually support shared IRQs in phylib, we now move the
responsibility of triggering the phylib state machine or just returning
IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
3 different IRQ handling callbacks (.handle_interrupt(),
.did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
driver implement directly an IRQ handler like any other device driver.
Make this driver follow the new convention.

Cc: Maxim Kochetkov <fido_max@inbox.ru>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/marvell.c | 57 ++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2563526bf4a6..bb843b960436 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -327,6 +327,24 @@ static int marvell_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t marvell_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_M1011_IEVENT);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_M1011_IMASK_INIT))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int marvell_set_polarity(struct phy_device *phydev, int polarity)
 {
 	int reg;
@@ -1659,18 +1677,6 @@ static int marvell_aneg_done(struct phy_device *phydev)
 	return (retval < 0) ? retval : (retval & MII_M1011_PHY_STATUS_RESOLVED);
 }
 
-static int m88e1121_did_interrupt(struct phy_device *phydev)
-{
-	int imask;
-
-	imask = phy_read(phydev, MII_M1011_IEVENT);
-
-	if (imask & MII_M1011_IMASK_INIT)
-		return 1;
-
-	return 0;
-}
-
 static void m88e1318_get_wol(struct phy_device *phydev,
 			     struct ethtool_wolinfo *wol)
 {
@@ -2699,6 +2705,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = m88e1101_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2717,6 +2724,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = marvell_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2738,6 +2746,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2759,6 +2768,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2779,6 +2789,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = m88e1118_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2798,7 +2809,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2820,7 +2831,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
 		.set_wol = m88e1318_set_wol,
 		.resume = genphy_resume,
@@ -2842,6 +2853,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = genphy_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2862,6 +2874,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = m88e1118_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2880,6 +2893,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_aneg = marvell_config_aneg,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2897,6 +2911,7 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1116r_config_init,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2919,7 +2934,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
 		.set_wol = m88e1318_set_wol,
 		.resume = marvell_resume,
@@ -2948,7 +2963,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2974,7 +2989,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -2999,7 +3014,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -3020,7 +3035,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -3045,7 +3060,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
@@ -3067,7 +3082,7 @@ static struct phy_driver marvell_drivers[] = {
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
-		.did_interrupt = m88e1121_did_interrupt,
+		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
 		.suspend = genphy_suspend,
 		.read_page = marvell_read_page,
-- 
2.28.0

