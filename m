Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0615B2C0F17
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389755AbgKWPjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389616AbgKWPiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:50 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D97C0613CF;
        Mon, 23 Nov 2020 07:38:49 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id k27so23859287ejs.10;
        Mon, 23 Nov 2020 07:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2S7ssQEEvdv31f1tGseCE7r/iFxGWNgPQ4dQxgviHtI=;
        b=OML6Fp6lXxFp23Xned5zxBnKUuVVpD/EO456tcT0xn6ETKG8uHsel+JC4XOWeQtpmh
         r/FoweK7oxvpFM3pN9EKy3NA7SVr+Zc92PglnhWp90RRfSjQBNF/H3HKcBSZQAbO2TFF
         OqSsvf0vFTZe+yJ427CUjA0ap7glMASAxRE2NMrgb/GqOfBj41dTJtEvMYL6U4/EnscP
         kahiuelTeeXR4w1A3AbF0mHF6WO6GBp8SBi7Aotih7lTfVIQN4vBtCO2slaXWAI/IuPL
         wMLT6xhAHDP62gomwBxPG57ccDrixYLkIFc3KsvLTao4BGR50Bo/hhNUfIC4tMmCVaqb
         38TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2S7ssQEEvdv31f1tGseCE7r/iFxGWNgPQ4dQxgviHtI=;
        b=QickqYY8Bv942R7WHycHqUqAzB9I5Dp098Y7JBtv2jyEAXmFDhh3aCFx7kb+pbvhNT
         eDmTuEKiVqtKSn9ZWYTNq5AgduaiAfU4U1Tj978PYfEPXNMW4o6dcLBi72SM/7dcZ3jt
         wqazUvLc3Toweqy7uzzMlabu9/tpxfwBOggWDKC+Oj64cREcfNXOwWou2JJlYZqOybr5
         3O34VgBRwo8lr6nwdmtEZ4wi9cGTasgrMZz8KJLYAuJAxafbGwKKYzR61PlkJj5F6Xrs
         4Y11DmXK4P7taNYcsdrdY8DDvqsfBmGzrHRq2BA429wZZkQt/S4q1u9I9eNbMEIPB64j
         Atug==
X-Gm-Message-State: AOAM5334hKDd9d8vdelbtWKqhTo546awO8/UJms+trB+iTgzqWXkgbfc
        SQ/E1Viv2uJNurJWLU+Dx5c=
X-Google-Smtp-Source: ABdhPJzif1mTjoEhoOgh7G2S0HTVMY90o1qMTc624OcHQYMy/KaoLHnbb2Iyfl1gTP3V0vc/6xO/wA==
X-Received: by 2002:a17:906:c7d9:: with SMTP id dc25mr141743ejb.309.1606145928645;
        Mon, 23 Nov 2020 07:38:48 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:48 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH net-next 06/15] net: phy: meson-gxl: remove the use of .ack_callback()
Date:   Mon, 23 Nov 2020 17:38:08 +0200
Message-Id: <20201123153817.1616814-7-ciorneiioana@gmail.com>
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

Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/meson-gxl.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index b16b1cc89165..7e7904fee1d9 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -204,22 +204,27 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
 	int ret;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		/* Ack any pending IRQ */
+		ret = meson_gxl_ack_interrupt(phydev);
+		if (ret)
+			return ret;
+
 		val = INTSRC_ANEG_PR
 			| INTSRC_PARALLEL_FAULT
 			| INTSRC_ANEG_LP_ACK
 			| INTSRC_LINK_DOWN
 			| INTSRC_REMOTE_FAULT
 			| INTSRC_ANEG_COMPLETE;
+		ret = phy_write(phydev, INTSRC_MASK, val);
 	} else {
 		val = 0;
-	}
+		ret = phy_write(phydev, INTSRC_MASK, val);
 
-	/* Ack any pending IRQ */
-	ret = meson_gxl_ack_interrupt(phydev);
-	if (ret)
-		return ret;
+		/* Ack any pending IRQ */
+		ret = meson_gxl_ack_interrupt(phydev);
+	}
 
-	return phy_write(phydev, INTSRC_MASK, val);
+	return ret;
 }
 
 static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
@@ -249,7 +254,6 @@ static struct phy_driver meson_gxl_phy[] = {
 		.soft_reset     = genphy_soft_reset,
 		.config_init	= meson_gxl_config_init,
 		.read_status	= meson_gxl_read_status,
-		.ack_interrupt	= meson_gxl_ack_interrupt,
 		.config_intr	= meson_gxl_config_intr,
 		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
@@ -260,7 +264,6 @@ static struct phy_driver meson_gxl_phy[] = {
 		/* PHY_BASIC_FEATURES */
 		.flags		= PHY_IS_INTERNAL,
 		.soft_reset     = genphy_soft_reset,
-		.ack_interrupt	= meson_gxl_ack_interrupt,
 		.config_intr	= meson_gxl_config_intr,
 		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
-- 
2.28.0

