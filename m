Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FBE2C0F09
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389679AbgKWPjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389649AbgKWPi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:38:56 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC88C0613CF;
        Mon, 23 Nov 2020 07:38:55 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id k9so9088747ejc.11;
        Mon, 23 Nov 2020 07:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xG6uDKlgrW8upS/7a6NuAZ58QlyBJGLGwgNnAk0awZ4=;
        b=mPaiftkbj3DKiy+CAMAgVGvXeIMbALIGJPISrJWqQf56tQ6Mp0PaVaNOoziqx+i7vv
         qvIASwu9CfLzXI37Tsa+32dDlnOmjmhJZaCFyQtTofMSKk7najmc1NtjmoePBn3047v/
         p4MqSw+2v178CWQstO6hXw9LvgoMH3otuKjrISV9EOdrqA9oC2U+o3t3SQPFJwEcHkZd
         DuvrBsG+LIBP0uStjMEs8aCx0Qgb459iS+cQ8I75T4YxdI0ZY54jlG7zw4aQRxBVe/02
         PSWXVOQ1gTQjm2vKH5ZJfQ9bhtJX37aM38pnV7pZuXN9IPp4JirP/9Xm9iBBUpVqeOVl
         Cg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xG6uDKlgrW8upS/7a6NuAZ58QlyBJGLGwgNnAk0awZ4=;
        b=nkyYYhPy/FypeiAmrZ6rzZkf4s6hlO/LX1WAsi13T//ttA5tzuLdaITuLeSbWLsg13
         8D/ooT16G4Td/RRoUV1mnxMrxCq2c/2SgtfsAdkAKK04VO8tnpQn51d3EN75o3SN7s9b
         PaYbYzzhk5iqLmeKuMs82/jz1+jaBIs5Mu0Lz8z9oMU21yLyjvkKiXYrzBdJ4WoyfyGh
         MoAn4e7sJufHviyuKQ5j7bjY/GJm17tbKDgGH0TS7NK4EkftUM9PkEbL4i1M76rPhjIP
         03lQ815DGttbjJD3oY7ZQ286E4sLOHDkkKHVVUAShsK1lZXqTc6hQWa4ndOgLXuY4DZj
         8FYw==
X-Gm-Message-State: AOAM532Xrh3FBCQq8nuuZcHbpCF+34GbqPkj/X0lTUn7ZMUET7Uamfda
        ikV2aVT5iWQQ0wsSP1etBFE=
X-Google-Smtp-Source: ABdhPJzDGK/LHGD7/4kd8lGmrIOtibjByAwipK4SsTznS9iO+WROwbg775RdO6nFQLDI2BNCn9kPsw==
X-Received: by 2002:a17:906:9501:: with SMTP id u1mr131210ejx.405.1606145934666;
        Mon, 23 Nov 2020 07:38:54 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:54 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 10/15] net: phy: national: remove the use of the .ack_interrupt()
Date:   Mon, 23 Nov 2020 17:38:12 +0200
Message-Id: <20201123153817.1616814-11-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/national.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/national.c b/drivers/net/phy/national.c
index 8c71fd66b0b1..5a8c8eb18582 100644
--- a/drivers/net/phy/national.c
+++ b/drivers/net/phy/national.c
@@ -63,19 +63,6 @@ static void ns_exp_write(struct phy_device *phydev, u16 reg, u8 data)
 	phy_write(phydev, NS_EXP_MEM_DATA, data);
 }
 
-static int ns_config_intr(struct phy_device *phydev)
-{
-	int err;
-
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
-		err = phy_write(phydev, DP83865_INT_MASK,
-				DP83865_INT_MASK_DEFAULT);
-	else
-		err = phy_write(phydev, DP83865_INT_MASK, 0);
-
-	return err;
-}
-
 static int ns_ack_interrupt(struct phy_device *phydev)
 {
 	int ret = phy_read(phydev, DP83865_INT_STATUS);
@@ -110,6 +97,28 @@ static irqreturn_t ns_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static int ns_config_intr(struct phy_device *phydev)
+{
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = ns_ack_interrupt(phydev);
+		if (err)
+			return err;
+
+		err = phy_write(phydev, DP83865_INT_MASK,
+				DP83865_INT_MASK_DEFAULT);
+	} else {
+		err = phy_write(phydev, DP83865_INT_MASK, 0);
+		if (err)
+			return err;
+
+		err = ns_ack_interrupt(phydev);
+	}
+
+	return err;
+}
+
 static void ns_giga_speed_fallback(struct phy_device *phydev, int mode)
 {
 	int bmcr = phy_read(phydev, MII_BMCR);
@@ -154,7 +163,6 @@ static struct phy_driver dp83865_driver[] = { {
 	.name = "NatSemi DP83865",
 	/* PHY_GBIT_FEATURES */
 	.config_init = ns_config_init,
-	.ack_interrupt = ns_ack_interrupt,
 	.config_intr = ns_config_intr,
 	.handle_interrupt = ns_handle_interrupt,
 } };
-- 
2.28.0

