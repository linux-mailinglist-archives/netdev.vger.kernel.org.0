Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A642B092F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgKLP6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgKLP6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:33 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EE9C0613D1;
        Thu, 12 Nov 2020 07:58:33 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id cw8so8547889ejb.8;
        Thu, 12 Nov 2020 07:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MXHSBEvaUT7iZ7CGrQ4Tj9isAY8p/NdNFR8NBXTFZaY=;
        b=P+SxahmHJykectq8dDAl91TJIpGlsiJP0t3SVDbMvp89YxcH7diwTZw1WLZR5UbIku
         WJxGS9+LJ+dlSEkehN0tEP+EJO5iupoOqZvO4yGX9RuICRtBROntK0xJH43knDHU9qGz
         lLNSBblT/nOE1whtkn39Lj/jt8qTFe7zzPa09FadOKeZsiJ3FPlGW4fM1AE4TRiqsEuz
         XOqrvUZG5dhZurbVLntWKyZNH/H3McdVLAcaOXiXDAGC2K5J13acalB9b+Xb+LinLFC0
         00KWdelUNPQjnvnCnEK6fVWMZO7O7B6F5V0dGZTOAN59ILFYgtxXAuIEC39pXwtdFj8D
         m5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MXHSBEvaUT7iZ7CGrQ4Tj9isAY8p/NdNFR8NBXTFZaY=;
        b=KcTfez3UqhBR1Fmqh9f/174uP6tgA4GDE5mbaNyedk/7+I83/CZqdl92za2uE6yCwt
         tXgog7AelsZVLi0+qKRkqAk8TLG1sXF9iTnD7fAzUQfW1jpk4W/nbOjV1iagI0fUh65C
         J8NNz5F8UbnltA4yh7PvZEt3gnkGwV9lyEptMn3cqVYdbYwjZ0iOF558nf8b43K9XN+y
         upOl2sXfV4bnGrqCP34Nx5lzFzkYdQKjdWcAOUbaWoniD+nMgPU1UtObgvYksjveNICY
         MBMpF0KhQ09axCW9lwKP90kjHhj+UpSEcSBMiQGdvT51V9B0dURLDnfSnTUvIXzOHGut
         PZow==
X-Gm-Message-State: AOAM531muuwZR2BJ4FNGe4NLGB765Twi6NcGZJSk4QqXVbzE2R77/ipY
        nhKXaOFf8ICD9NwIugyTmTY=
X-Google-Smtp-Source: ABdhPJzgaAQ8aHdotyotm4BG2tyQGVj3dCnmSRnzjmGfuxCTUKmzqUPrqxaTBqq2KeNkj40MJUpttA==
X-Received: by 2002:a17:906:8142:: with SMTP id z2mr29916690ejw.30.1605196711675;
        Thu, 12 Nov 2020 07:58:31 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:31 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 12/18] net: phy: amd: remove the use of .ack_interrupt()
Date:   Thu, 12 Nov 2020 17:55:07 +0200
Message-Id: <20201112155513.411604-13-ciorneiioana@gmail.com>
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

