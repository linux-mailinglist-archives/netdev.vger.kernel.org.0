Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6368E2B0935
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbgKLP66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbgKLP6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:40 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58821C0613D1;
        Thu, 12 Nov 2020 07:58:40 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id l5so6829354edq.11;
        Thu, 12 Nov 2020 07:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qt4TBD0WTlxDExy+5uLdRHot9ANakmUntHhTQK8GBOE=;
        b=hG/pAXc4Rqx+fiSffXVFRMrDMv1CQgqt9lnLrsQUmroqA2K0Dnc9/GC5GvHdYhaLAr
         rPQoZW9298hD2xHQM7E+SfyUoOufRYnw/4lYgQqzk2Q9a/Ht/4HutCRBh8vmWERF8JCT
         JpWXQR2z1azXTm+cCu0dOBld+JxfMAFNdbU0iCyXwJAYICnnnwyeoo1LUs/bkODbKjji
         JfUAjyLscPxPJHseKBUzwDktlyxQc9yFu3sm4yIkgITpd0QwtP6NeVTm+wcS4uqCNCCQ
         mxIj5fgOflDBJ5pRH21KXlcHvnDeAko+xXOm9lFdvLkABRX3QXKEPPPnvgmnQzXm6B8P
         r2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qt4TBD0WTlxDExy+5uLdRHot9ANakmUntHhTQK8GBOE=;
        b=Ly7jSsW42OPrP6XzkeuhzE76XHMjCd41vAk+EQYend5jWy740jKtuLRQGSGhYNJ2gy
         DKUdbzpffYVIB7dM+m8nr/pHILpy47lgXPDvLvjzDO4rWeLQKAGIjE1fAzTrpjYq7eir
         LQwVoytJmylv5Xa5bnEyu2nW8Gu7rGCiLqjTEp5rZf02z3jGnu6FD9AGY1mIUb7nbu28
         wvDPDVvYXMXXCkmSj6pZhDv4cItycRuwPt6+tK4IJPKcPH51Y0aZpUazLZoS70biBMbS
         iy01BoZMyUMId7297ENsmZ5Dg05+tUDkpqLDuJqdihoAEN6fMHMxyhI3gySdimpCRkui
         4GmQ==
X-Gm-Message-State: AOAM531wh3PezoAe/M/lE3BUBDTnaFTqwEWB8uZMBC6pv4MTCceX8cLy
        oSrXDbE7YR1rOCeBTFXdObnUiy8Bt+0fmw==
X-Google-Smtp-Source: ABdhPJzp1sagmqL0w/HVEnj4Kj3SEMqwR25fZnEuYy6wLi7rgwTivNM12hGh+tnqOQeCA/AtTuxI2g==
X-Received: by 2002:a05:6402:b6e:: with SMTP id cb14mr430045edb.308.1605196719103;
        Thu, 12 Nov 2020 07:58:39 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:38 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH net-next 18/18] net: phy: adin: remove the use of the .ack_interrupt()
Date:   Thu, 12 Nov 2020 17:55:13 +0200
Message-Id: <20201112155513.411604-19-ciorneiioana@gmail.com>
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

Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/adin.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index ba24434b867d..55a0b91816e2 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -471,12 +471,25 @@ static int adin_phy_ack_intr(struct phy_device *phydev)
 
 static int adin_phy_config_intr(struct phy_device *phydev)
 {
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
-		return phy_set_bits(phydev, ADIN1300_INT_MASK_REG,
-				    ADIN1300_INT_MASK_EN);
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = adin_phy_ack_intr(phydev);
+		if (err)
+			return err;
+
+		err = phy_set_bits(phydev, ADIN1300_INT_MASK_REG,
+				   ADIN1300_INT_MASK_EN);
+	} else {
+		err = phy_clear_bits(phydev, ADIN1300_INT_MASK_REG,
+				     ADIN1300_INT_MASK_EN);
+		if (err)
+			return err;
+
+		err = adin_phy_ack_intr(phydev);
+	}
 
-	return phy_clear_bits(phydev, ADIN1300_INT_MASK_REG,
-			      ADIN1300_INT_MASK_EN);
+	return err;
 }
 
 static irqreturn_t adin_phy_handle_interrupt(struct phy_device *phydev)
@@ -895,7 +908,6 @@ static struct phy_driver adin_driver[] = {
 		.read_status	= adin_read_status,
 		.get_tunable	= adin_get_tunable,
 		.set_tunable	= adin_set_tunable,
-		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.handle_interrupt = adin_phy_handle_interrupt,
 		.get_sset_count	= adin_get_sset_count,
@@ -919,7 +931,6 @@ static struct phy_driver adin_driver[] = {
 		.read_status	= adin_read_status,
 		.get_tunable	= adin_get_tunable,
 		.set_tunable	= adin_set_tunable,
-		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.handle_interrupt = adin_phy_handle_interrupt,
 		.get_sset_count	= adin_get_sset_count,
-- 
2.28.0

