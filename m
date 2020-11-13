Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026F02B20F7
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgKMQxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgKMQxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:11 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99D0C0613D1;
        Fri, 13 Nov 2020 08:53:10 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id y4so5637885edy.5;
        Fri, 13 Nov 2020 08:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MXHSBEvaUT7iZ7CGrQ4Tj9isAY8p/NdNFR8NBXTFZaY=;
        b=Ycg0qMdd8kGJF2r4GDgYOpj3mL+H6idNHerP1X2nvpW2ETVQXdVPUXgK+3Cw7oRAAA
         xBGJ+XWMqmchrMzrkDlokfjlIXrGA+V06RAmSq+IclgVUuBE8WsCedYbP/rf9j1trS/V
         a4AwGwBLZkQWdegEENHEtCNbJLjxjMb6AvWSPQoqwB6dYIn8A6ZYf2sPqZhd0Bhne+qr
         RClf2Sa+c9nALel5hIKBguyr6iFs96b5lhjyc7p3mUxe8nLc2p4vL4HoQNQnlUJhlIPV
         w1AVuThIa1FIPqef2oqU1RfpykiTMk9Jw2JSq31/E4fR4SNPidGuJqGaF1aCjhbk7XJd
         xPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MXHSBEvaUT7iZ7CGrQ4Tj9isAY8p/NdNFR8NBXTFZaY=;
        b=L0MJ5KKQfjh8my+2qt4SYVP4oaOlgGQ816kZ4VK8Ghd87oZIokt6Fxt1N2umokiSp2
         DCS1a3GPpjwnU5yLjXqlRzgscavjrDDb8YibpGgR7JYp/Gq/2QY9mKjv91PRLp4s5bgb
         y+f+MvJYuzTmdr9uk8rGV15q2Gr846ofYHhgrYxYKIAFRQHNxfkZA7r+RKhXq20b0hGf
         TEBgR8eG6nNhoF+5KDtoorhaB2sHgll//sAO75iKT4Cpe7wcCiPKj2yv8XJVIN6Kt9hY
         mRfigBg+kAkCxRNCedv2fGnZWSw8SZ/A/Ohq5fmHtzD2ye6Ufx5elw0VBfMzcwPG00hJ
         Ob2g==
X-Gm-Message-State: AOAM53044lLU7e3fsOqMUxEiztVJwm+YntjVj+W2csg6XQOCWyiyjFFS
        6532PZGDjkNkTU9wknCKrTw=
X-Google-Smtp-Source: ABdhPJxKSMj1//HbrWqTlaTDPz+Mb3JdZrdsXFcEaKKL441EhfeoAUwtBWWvOgxtu82SzXOya5ARZw==
X-Received: by 2002:a50:fe02:: with SMTP id f2mr3431191edt.97.1605286384661;
        Fri, 13 Nov 2020 08:53:04 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:53:03 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RESEND net-next 12/18] net: phy: amd: remove the use of .ack_interrupt()
Date:   Fri, 13 Nov 2020 18:52:20 +0200
Message-Id: <20201113165226.561153-13-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/amd.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/amd.c b/drivers/net/phy/amd.c
index ae75d95c398c..001bb6d8bfce 100644
--- a/drivers/net/phy/amd.c
+++ b/drivers/net/phy/amd.c
@@ -52,10 +52,19 @@ static int am79c_config_intr(struct phy_device *phydev)
 {
 	int err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = am79c_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		err = phy_write(phydev, MII_AM79C_IR, MII_AM79C_IR_IMASK_INIT);
-	else
+	} else {
 		err = phy_write(phydev, MII_AM79C_IR, 0);
+		if (err)
+			return err;
+
+		err = am79c_ack_interrupt(phydev);
+	}
 
 	return err;
 }
@@ -84,7 +93,6 @@ static struct phy_driver am79c_driver[] = { {
 	.phy_id_mask	= 0xfffffff0,
 	/* PHY_BASIC_FEATURES */
 	.config_init	= am79c_config_init,
-	.ack_interrupt	= am79c_ack_interrupt,
 	.config_intr	= am79c_config_intr,
 	.handle_interrupt = am79c_handle_interrupt,
 } };
-- 
2.28.0

