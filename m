Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DCD29E87B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgJ2KI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgJ2KIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:53 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AB0C0613CF;
        Thu, 29 Oct 2020 03:08:51 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p5so3031519ejj.2;
        Thu, 29 Oct 2020 03:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7p5sd8HpKn7j9HEPtoN1/rIYQ3dommsje0cNEMRYS2E=;
        b=hGiTW6Rqz4leNA39D/oGurRlvyjkzEF3becxTaHASh8spzPC8e1gT7nyGzFsK0w28l
         eZkDeUyDWr9v3HzLYMPq5q4XVcCSFhNdNsty/0Xq3JF6KRbgQRR1TZkm1A28mtxDZgRZ
         xmDZ7cdRH5AWAV6x33m+Vj6cmnoGyJnyp6H48pL/2ftRRJ95sZ3WezXPZ53CumxF0DM6
         sd0jQBcubZ4FF1LkfqxpSQ/UegGWOUQtf/OTdeZAXwF0BwrEO28OfTLJgogEmvTkS9OZ
         bRsPJkhOoKrtQlrxMDv4gcyj9yd9/b6zom4VkvYCzcjEX+X4AyqpJKZgsivoeZiSbORy
         KuxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7p5sd8HpKn7j9HEPtoN1/rIYQ3dommsje0cNEMRYS2E=;
        b=cqJO91melp58i+C/9H7tNwEGYFapS9s4fAHRcl5vGeqbzfSpXyf0zhDp/CbGyVHOXP
         WAgzn62jK2xld8NZSDJR/iz4LKjQ8F9q0+YcbVOYVif+2US1UOjMsm9xmIwI2IwvOIfU
         Ent+iIMFtgbPxoJfkP2p4ALdpOrHYqDlNsAZr9CPTuhSx2zPRB/gYG19BK5p0Gga0S/w
         m0g+wLmiP+iQYRj1KvUjcifyWjTWBg/fMNAWoOttpHdUm8nCvb+CBnpfAKZdww55CRqe
         I37r/R+FYKrBLBS3dFBPQc3DSIFUoKF8puaiDTetNu75d7aYbNAF2e3b7uxH5T8w1wCI
         5PpQ==
X-Gm-Message-State: AOAM531HGX3zmJV/RyTLuf/CqVozAQDR5oBMGAxq3vRoGs5KHjEZ7UUL
        vx5bCveLsNgJpzj7KJTQ3Is=
X-Google-Smtp-Source: ABdhPJwFnmqzT2rki5Lh0vqhXOzM0r56Kv/qNiyUOFanwiXAqWm7+S3k2Vi0EkcivcQ6IvOt1f5H0A==
X-Received: by 2002:a17:907:43c0:: with SMTP id ok24mr3212909ejb.385.1603966130219;
        Thu, 29 Oct 2020 03:08:50 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:49 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: [PATCH net-next 08/19] net: phy: mscc: remove the use of .ack_interrupt()
Date:   Thu, 29 Oct 2020 12:07:30 +0200
Message-Id: <20201029100741.462818-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
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
 drivers/net/phy/mscc/mscc_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index ae790fd3734c..266231b18bb4 100644
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

