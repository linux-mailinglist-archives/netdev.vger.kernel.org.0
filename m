Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18182B20FF
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgKMQx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgKMQxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:23 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AEFC0613D1;
        Fri, 13 Nov 2020 08:53:21 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id f23so14474954ejk.2;
        Fri, 13 Nov 2020 08:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qt4TBD0WTlxDExy+5uLdRHot9ANakmUntHhTQK8GBOE=;
        b=kfbB3R2x83Hu6nT+3hHGwjmrmOiohwfvD0yDmvglvsOnOLpTrvILVQJqs+RHIN2f5l
         Z3CUQdFrxWH1x05FuL8QjJvxXUpaLTo2fPCgue2OiTb1aO+ln/GZaXgUuVo/lptDOkbN
         FRHTPmeJAzhZJmG1aVTLoIq59FdONhMGlv4lmdDPDq6pSSvWriqQgj5HNJhcG7x8vdMQ
         fc3dGs/NY68ity9XdZuXliH7Wsvx+WBff17rVh5ifIQ0x0SroKn4GBFOuKfkK8ah5cfc
         zZjTQ4HO0T2AnMEuoQ0ZH/brxQYYRy5ujruB7fjFtpA2HoovrclNY1wJxT37k4UCE2b/
         aszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qt4TBD0WTlxDExy+5uLdRHot9ANakmUntHhTQK8GBOE=;
        b=MGYtHe/FhJHraALTB5pXXsyvSptbW34Rb9xn1z99Wzb9Q+X+LC5H2IqNTV1MAvLG2L
         I55C8wcHxFrMUdpNqvkhul/uEYoVBz7FTwkLtj30Wf+N4QBeTMTDD8Nsq/J8R/hSfK+3
         /HP/5BgnjAAnPpDr8Dcxx/f6lhpKL+IWEXldHX6a5/soy+mWClVzDZPwWF4e0CYwXLII
         D4MlCAXb4n5gOgicnBxz6l2RLxY2Rw+WPs9R18YYBy73DUEL4xR7OUn5kGpbVKjndhJQ
         0n+6lcfqdm/NqRvu040haD4rRVCKB2G16xyVReR5DfOiJ1QuQ66Jt11v8dfVLOjIbbx3
         btPg==
X-Gm-Message-State: AOAM532W24O8p2UP0YKXw2YNzxZp2l6JSuUN+fJZcgQmZDxZzcuNNbo8
        J7cMJJMpeLa5qnwi9KxbYiU=
X-Google-Smtp-Source: ABdhPJyoyPGDwWoKSxMEnCkUgmYIBNdoxJDo5ofiZ1HeDi3NGt2fH13XAXYhfmXwGJYlDCXT1/iCsw==
X-Received: by 2002:a17:906:ec9:: with SMTP id u9mr2814330eji.400.1605286395597;
        Fri, 13 Nov 2020 08:53:15 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:53:14 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH RESEND net-next 18/18] net: phy: adin: remove the use of the .ack_interrupt()
Date:   Fri, 13 Nov 2020 18:52:26 +0200
Message-Id: <20201113165226.561153-19-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113165226.561153-1-ciorneiioana@gmail.com>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
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

