Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AA529E89D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgJ2KKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgJ2KIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81E8C0613CF;
        Thu, 29 Oct 2020 03:08:47 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id p93so2429931edd.7;
        Thu, 29 Oct 2020 03:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k4WnBvovvLFTUdht9hn8p81ikp0RDpqPhZr8zUzQUcw=;
        b=F6GFePrxKyv3OOTtfhs8hn53MnxFU0Qicp0kfSW+0/rbLkN1VP81jvfCND3EORVEM/
         vR66XySL2opqFPsmWrbVjL/nfip3+YGgLjH4dBtZ5oDBWLXKPeP6uyXR9f8Ap371ktoF
         POtIetILShwyaVTOotSAw+GhlLSLkrT75QyKRsl87GekgnMnbHP9Z7xmNfOcBweMB8Ij
         MqgoPgZp/zvBtI2MExymEUoZLXixBa7zb6nHNTdCvH3KQAWQb63zW6BEkDwbPo94/fvH
         fqaulQLb9xgijCYTirvWIDl9hPDeoIX91qvLrImWJ1gFB52BiGqZ6DDo2DuuFcoke59p
         Q6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k4WnBvovvLFTUdht9hn8p81ikp0RDpqPhZr8zUzQUcw=;
        b=IHNySXFPkMHgIkm8uZ/PVixS00J+PD+c/Viisme0vsEEqr+prbbQkWPvwVBKa+TQVl
         p86FaevlFxWari2AjI3xy7tX1ONKnoZaliHgcaqQu9wWuuDjTei1fGQQzBWYwnEsBj0+
         wCd030oqVIzL4tcrKqHOGgqes+mgr6gQKbclYPjWP6r9wGN8ysYTB5yWlSF2/uxStV2S
         7nMjActziagCQcGeb0oaMhxLx2/r/7ZjNU8HmXb+Cp48912V3Dx52nK+8mjLzRT1Ijcx
         ONDpKsSa0fMAdd6D7KeEYY8ar22JsfLyZA/GxGLL6dO5H8Tgpp7WIqJuutP8jCq/sblE
         /n+g==
X-Gm-Message-State: AOAM530fGyx3JbFZ259pqLVi/PD9HEtOJToOQ5x2+fOI6nt5Mw8nhr2v
        0BMPd1t6mU3mbBZVNQ/jaJQ=
X-Google-Smtp-Source: ABdhPJw0dMSbrp9XbN37ElgUYkNnxodDwEbPh26MMQIF1gHWupAUz03IS1jF5e4+cQuBuXQffafDzg==
X-Received: by 2002:aa7:dd49:: with SMTP id o9mr1495982edw.143.1603966126415;
        Thu, 29 Oct 2020 03:08:46 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:45 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 05/19] net: phy: at803x: remove the use of .ack_interrupt()
Date:   Thu, 29 Oct 2020 12:07:27 +0200
Message-Id: <20201029100741.462818-6-ciorneiioana@gmail.com>
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

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Michael Walle <michael@walle.cc>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/at803x.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 106c6f53755f..aba198adf62d 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -614,6 +614,11 @@ static int at803x_config_intr(struct phy_device *phydev)
 	value = phy_read(phydev, AT803X_INTR_ENABLE);
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		/* Clear any pending interrupts */
+		err = at803x_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		value |= AT803X_INTR_ENABLE_AUTONEG_ERR;
 		value |= AT803X_INTR_ENABLE_SPEED_CHANGED;
 		value |= AT803X_INTR_ENABLE_DUPLEX_CHANGED;
@@ -621,9 +626,14 @@ static int at803x_config_intr(struct phy_device *phydev)
 		value |= AT803X_INTR_ENABLE_LINK_SUCCESS;
 
 		err = phy_write(phydev, AT803X_INTR_ENABLE, value);
-	}
-	else
+	} else {
 		err = phy_write(phydev, AT803X_INTR_ENABLE, 0);
+		if (err)
+			return err;
+
+		/* Clear any pending interrupts */
+		err = at803x_ack_interrupt(phydev);
+	}
 
 	return err;
 }
@@ -1080,7 +1090,6 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
-	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
@@ -1101,7 +1110,6 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 }, {
@@ -1120,7 +1128,6 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
 	.aneg_done		= at803x_aneg_done,
-	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
@@ -1141,7 +1148,6 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
@@ -1154,7 +1160,6 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
 	/* PHY_BASIC_FEATURES */
-	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
-- 
2.28.0

