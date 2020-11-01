Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996772A1E06
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgKAMwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgKAMwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:34 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A14C061A04;
        Sun,  1 Nov 2020 04:52:32 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id k9so11382279edo.5;
        Sun, 01 Nov 2020 04:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EfqQt3242lrk5/PPkfKYwkypm+y6YbFO8gCqknLDny4=;
        b=S1CUQxDXVhPG+xo7ugNxYf1BMflN4657p8vy6Zv68iYOO3+RBdMcL+cAQqUdf3UU+S
         UokfHM1z85PBomTiPw6CM1wblZ7WhJ05JiuMJjQPdap2uaKEFH3xQR3zcX23xnHg+Mwp
         5BjzB/si9BK87BBKngAnqKitSqQ1eSW7IaEgOQwi1vK1L80be7iZu29qkPabKIkAlOOA
         rTnGIwTDCsmZXBsjq4kECenfueFebkanL406GnwMhKYCQOOXvqSHeAhwhJ5tH1DdGDDS
         taJll1771hbIZn2Sa/sd59CZ/tlKboPfArgU/0vl8PvF5LAFfPnkt1Cdg7vf+cnsGvgI
         kRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EfqQt3242lrk5/PPkfKYwkypm+y6YbFO8gCqknLDny4=;
        b=SYtLl8L/dJESv1OcUh7E5ZLXziBVWpDUkTGK++Pq+LQarlCqMgv09kR1HhbYpdXTuw
         5qXUSGUvBJxOndn+gdrNFtPPaii2cIQFCpY8KSOH1dglSjbSnGrIptud3CK3YRaIgwFS
         ZHhOMdojUe6/ZA3Mxwz12q+1oU3R9cmPpzr83+G8tOJSYNm3rAQZQUzcDxpjSWBiccwR
         hK0ryW3kI/BxMuGIKxXyuUVAJdZLXzB7gszPByD6APvEwwqvj0hmYxx3QNNgr+WuAUGj
         dFPICTG3EU8A++kADSsx2MN9YXskj3m6re6MNTF64s2EmiBSrmmrqSL3gFdIPb738qBx
         G+uw==
X-Gm-Message-State: AOAM533CGu5qBw3XRyzLIN3amcYDP8v0PW8N0GGkKRPcATvEjRFw2hDX
        YbX7xGNNxZ9RBdrTbvCvUM0=
X-Google-Smtp-Source: ABdhPJyVQrgdG65YC/SKuy2KlP7/dw6SZ/JTTFlC5wNE8SmpV7lTpTEybJiIF2N3RcRtJQVGpBZt7w==
X-Received: by 2002:a50:e705:: with SMTP id a5mr11962752edn.29.1604235151304;
        Sun, 01 Nov 2020 04:52:31 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:30 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: [PATCH net-next v2 08/19] net: phy: mscc: remove the use of .ack_interrupt()
Date:   Sun,  1 Nov 2020 14:51:03 +0200
Message-Id: <20201101125114.1316879-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
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

Cc: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/phy/mscc/mscc_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 48883730bf6f..2f2157e3deab 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1923,6 +1923,10 @@ static int vsc85xx_config_intr(struct phy_device *phydev)
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		rc = vsc85xx_ack_interrupt(phydev);
+		if (rc)
+			return rc;
+
 		vsc8584_config_macsec_intr(phydev);
 		vsc8584_config_ts_intr(phydev);
 
@@ -1933,6 +1937,10 @@ static int vsc85xx_config_intr(struct phy_device *phydev)
 		if (rc < 0)
 			return rc;
 		rc = phy_read(phydev, MII_VSC85XX_INT_STATUS);
+		if (rc < 0)
+			return rc;
+
+		rc = vsc85xx_ack_interrupt(phydev);
 	}
 
 	return rc;
@@ -2338,7 +2346,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.handle_interrupt = &vsc8584_handle_interrupt,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
@@ -2389,7 +2396,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.handle_interrupt = &vsc8584_handle_interrupt,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
@@ -2413,7 +2419,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.handle_interrupt = &vsc8584_handle_interrupt,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
@@ -2437,7 +2442,6 @@ static struct phy_driver vsc85xx_driver[] = {
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
 	.handle_interrupt = &vsc8584_handle_interrupt,
-	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.suspend	= &genphy_suspend,
 	.resume		= &genphy_resume,
-- 
2.28.0

