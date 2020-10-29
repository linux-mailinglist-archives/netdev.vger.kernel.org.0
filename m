Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF9F29E88F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgJ2KJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgJ2KI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:59 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0E4C0613D2;
        Thu, 29 Oct 2020 03:08:59 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so3024060eji.4;
        Thu, 29 Oct 2020 03:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CRDXjdq7k2ZUfERILal+mcfDKo9tm5bE4JR2tkEJbc0=;
        b=U6OZo3vCS2JK6FXlRnj3ScqcncSzdqY+4mXs3vnyVmL+qPC8Tcj8F0WNrlkG6hQhSs
         arISjM2PGBiWlFwiag99q+A4QDY+vYDzkF5501ScZ3FbKENkXvz3hfVvPTMGW7DL4leh
         6L9cfOo66fumFkFmajLoYuHdwjk6mz1sMXm8vpLRA4Osu2ttK0IjfpwJ+fh0oO1W79kC
         kcWi3j3e33NQkteOFwZhi/9CsaTLeh6gMexUXiuBzVp5zr9vNCLxKX3vEelTc5J7++IQ
         +EH35WK/wQKi0uR+w0dgV0eg3PHSmS8gzT0vyVJI/a+yNH0zP3OV7V8WZZNlPoQ1vASn
         HbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CRDXjdq7k2ZUfERILal+mcfDKo9tm5bE4JR2tkEJbc0=;
        b=ik/ZQaT/HZF+GZqqrBrfYNpjR2CwzcBHvV+imLl3BvfOHQexkjsmmVzlv3kAFPd/zJ
         YpJvCyOj42XfF8sjmTe2qTduJbpEtH+zll14i4OwjRyEbYhCJ4XM9Y3puyBJh5kHFvNa
         9Esmo9GgeP1jbsdzvwiehjluLZq82lUZ9qfYkSOKOV/y6pVPhHisFJOSmDUY3rL9ziSJ
         eiEJV0e1oqAXxQlfgO1BKA37ujJPIiQieHZHjy6bfXzn56au8BGKkz+q8d5oN83PSUYF
         tWxWrIH85xVinXu1b5TGGwmr16rUU17pEH4CnZPtn63KhDFNOUTMp791uZCNEJ2PBKf4
         XWQg==
X-Gm-Message-State: AOAM533MQmzYj5snBZFETqAHxciqyARq5Xa+8bSCTznDzhwPaeddhbUT
        cvuHewlvLT1jG9fx72lQoZA=
X-Google-Smtp-Source: ABdhPJx8Sb5p1c3A229Q3xPCVNalyplW/16zbFfKuFuP+b9dSi2LqjkYkzrCtL7kpgBBWz4mcRHCig==
X-Received: by 2002:a17:906:70cf:: with SMTP id g15mr1484853ejk.323.1603966137875;
        Thu, 29 Oct 2020 03:08:57 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:57 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 14/19] net: phy: cicada: remove the use of .ack_interrupt()
Date:   Thu, 29 Oct 2020 12:07:36 +0200
Message-Id: <20201029100741.462818-15-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/cicada.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/cicada.c b/drivers/net/phy/cicada.c
index 03b957483023..5252ad320254 100644
--- a/drivers/net/phy/cicada.c
+++ b/drivers/net/phy/cicada.c
@@ -87,11 +87,20 @@ static int cis820x_config_intr(struct phy_device *phydev)
 {
 	int err;
 
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = cis820x_ack_interrupt(phydev);
+		if (err)
+			return err;
+
 		err = phy_write(phydev, MII_CIS8201_IMASK,
 				MII_CIS8201_IMASK_MASK);
-	else
+	} else {
 		err = phy_write(phydev, MII_CIS8201_IMASK, 0);
+		if (err)
+			return err;
+
+		err = cis820x_ack_interrupt(phydev);
+	}
 
 	return err;
 }
@@ -122,7 +131,6 @@ static struct phy_driver cis820x_driver[] = {
 	.phy_id_mask	= 0x000ffff0,
 	/* PHY_GBIT_FEATURES */
 	.config_init	= &cis820x_config_init,
-	.ack_interrupt	= &cis820x_ack_interrupt,
 	.config_intr	= &cis820x_config_intr,
 	.handle_interrupt = &cis820x_handle_interrupt,
 }, {
@@ -131,7 +139,6 @@ static struct phy_driver cis820x_driver[] = {
 	.phy_id_mask	= 0x000fffc0,
 	/* PHY_GBIT_FEATURES */
 	.config_init	= &cis820x_config_init,
-	.ack_interrupt	= &cis820x_ack_interrupt,
 	.config_intr	= &cis820x_config_intr,
 	.handle_interrupt = &cis820x_handle_interrupt,
 } };
-- 
2.28.0

