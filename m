Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4850B2B0957
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgKLQA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728849AbgKLP6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:25 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD524C0613D6;
        Thu, 12 Nov 2020 07:58:24 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id o20so6875758eds.3;
        Thu, 12 Nov 2020 07:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oNz8ucszFZGajN27xAe/ut4viosb6LUQd+Phco1FxbU=;
        b=izWPgd04V/VZW3Qwc8thc8F7Lmx3HnSszpF3SJZbtyPPDqNMbjmqqUwcxxmiKiBkXS
         Aa4V/35HpfcEf0qdldv4S6H7Vl7o+6DYMYedJFVZcG+/fqPeI2cBafGqAd+O0rk2E4Ei
         HlbdlmJimzIn6p3twbhy5Mup0pM1KgkJXiT6VHFF9uGc4lUHYamA9OqhNnKYytw51fPl
         mFKDYd5uU6HOla2T0hRRalYhILQXO5KiSU3nCiYEGDIXkcJlG6qtCFOGyDuEe9WzUxuN
         roxZpmKP91TLcTHMANlKbHNrLmCxFEsACc4Kcm8IEZ7YfmkwNMbRLoETYfNZ20dfu0vL
         7nbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oNz8ucszFZGajN27xAe/ut4viosb6LUQd+Phco1FxbU=;
        b=mzZf/MUpOeDFVxcdiZBGzY46XFwZ2/msgS9XIlK7p4x9EAv1pPAHSHXUY+GJZJCaI8
         MeSY8HrObcl0Z5kQnojP6QyyI5Z6wJiBUnywCJwmR/lzz5KcyrOnbIx6Xj/lBw+5IKDD
         xRrQNsGAPhxUznNMH4ai2VlvUev28ZsxnuuzrMOjn5JGW8UndJPn/uoN/Brol7giAHOt
         RL/rFRWma1FC0yKt2j6DtOY3qSPkrMc6j3NKMec5JbWV1Z/5S1U+qEkrjllWCX9wT1Xa
         cnnLo4b2f0vh3Og4aoF6igUqhHOZDzB9Fqz2LPD8nmE+netmRlDWXUfZ/pQh/iY8cxKB
         oqlQ==
X-Gm-Message-State: AOAM532NW4wZR3A59PchX6jv+tFJquXnhriAfQSwdith9DBEXojg2DhU
        vwkSSajYPdtHGnrrclN8uT4=
X-Google-Smtp-Source: ABdhPJzo7qu/k5YqYG4+kYp0rg+iGHJFPc3Gb+lnoEt137BOIwikjdyMj+5q3JJxlzPS7CISCHd9Aw==
X-Received: by 2002:a50:de45:: with SMTP id a5mr394821edl.91.1605196703608;
        Thu, 12 Nov 2020 07:58:23 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:23 -0800 (PST)
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
Subject: [PATCH net-next 06/18] net: phy: marvell: remove the use of .ack_interrupt()
Date:   Thu, 12 Nov 2020 17:55:01 +0200
Message-Id: <20201112155513.411604-7-ciorneiioana@gmail.com>
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

Cc: Maxim Kochetkov <fido_max@inbox.ru>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/marvell.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bb843b960436..587930a7f48b 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -317,12 +317,21 @@ static int marvell_config_intr(struct phy_device *phydev)
 {
 	int err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = marvell_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		err = phy_write(phydev, MII_M1011_IMASK,
 				MII_M1011_IMASK_INIT);
-	else
+	} else {
 		err = phy_write(phydev, MII_M1011_IMASK,
 				MII_M1011_IMASK_CLEAR);
+		if (err)
+			return err;
+
+		err = marvell_ack_interrupt(phydev);
+	}
 
 	return err;
 }
@@ -2703,7 +2712,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1101_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2722,7 +2730,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = m88e1111_config_init,
 		.config_aneg = marvell_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2744,7 +2751,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1111_config_init,
 		.config_aneg = m88e1111_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2766,7 +2772,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1111_config_init,
 		.config_aneg = m88e1111_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2787,7 +2792,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = m88e1118_config_init,
 		.config_aneg = m88e1118_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2807,7 +2811,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1121_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2829,7 +2832,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1318_config_init,
 		.config_aneg = m88e1318_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
@@ -2851,7 +2853,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1145_config_init,
 		.config_aneg = m88e1101_config_aneg,
 		.read_status = genphy_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2872,7 +2873,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = m88e1149_config_init,
 		.config_aneg = m88e1118_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2891,7 +2891,6 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		.config_init = m88e1111_config_init,
 		.config_aneg = marvell_config_aneg,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2909,7 +2908,6 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
 		.config_init = m88e1116r_config_init,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2932,7 +2930,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1510_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
@@ -2961,7 +2958,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -2987,7 +2983,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -3012,7 +3007,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e3016_config_init,
 		.aneg_done = marvell_aneg_done,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -3033,7 +3027,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e6390_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -3058,7 +3051,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
@@ -3080,7 +3072,6 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = marvell_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
 		.resume = genphy_resume,
-- 
2.28.0

