Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB982A1E13
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgKAMxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgKAMwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:41 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67450C061A47;
        Sun,  1 Nov 2020 04:52:40 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id e18so200887edy.6;
        Sun, 01 Nov 2020 04:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l7XDSYM/M1bjp6B3mGcMlMpBp17+2oQJyNz+LsCC7C0=;
        b=BkErPnIGHExmK5i2T9n1bweyav+KSix7ZdkSOZVnnpP2xleH7nRWgsirkohDkSxglf
         E09WL/h2LeHQh+UEVkKmts9FV/0blWdVnae5CMKo3S2iau4pGvYoAgKUQU4PRtEFba3F
         130fDRHP5M7nujMDHp3HVeF+I1iPK2GgxLA6r9Bwsjluhd8R42z+JA299RNQ1QWY6lZ2
         q2z3tpXG6oNZBeVBttkzVFQcqgmXLJ0OQccBMl8u/ihn5HLRbxARe6h4kGU52zQaN23d
         2af/XZs2hdGwdOOjaeXC83j6gLI9yZBNWPZhCj4HGm/plDDrF6/W5ByPiBf1icIIx1FN
         Hn8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l7XDSYM/M1bjp6B3mGcMlMpBp17+2oQJyNz+LsCC7C0=;
        b=ii+9y+g5ddoe8ZJKD8pB+f2uJt5F7Km4HebuX37OPDfD4BociCgjU4ywEEFxOcTljm
         4RQFaJ3wTG9dDab/eCEm48rPnVeAP8YT2xWm0y2WZYF8LQEU2SOLoQJOb3MdTMTMO+3s
         LPdKgmdXtbeNciRH0ULhETPHb4T5DmRpeapxUIWE+fYYmudaLbBT+AKRAjgcoGqEwvcD
         1QjGFr2K6S/G5u3mMFsY8iD/HJXJoo89x0zld9bhBCa4yy8VvU82a3tyA1/GaWn+3LO6
         JE8IcYIWPXIM7OiafrYWEXrtPyK22dDKrZFONMd0/1lkRphRQ4BDZhgzEtZzBcSlMzDK
         L67w==
X-Gm-Message-State: AOAM533DYqa8qeZ1MzCE2/Bo2hNJ0UeX8vTohut2Yy2Kqlg5Kx3OhfTh
        O27bRwk0QO9xFNq6OHIFd/U=
X-Google-Smtp-Source: ABdhPJzeEHD+lIlaKQR/Ny8kaHUajQD9L0rMdbl693s5IlA0WkuWt8FKD7IlX+f2th3Ev0TAMASH5g==
X-Received: by 2002:a05:6402:b28:: with SMTP id bo8mr11982363edb.57.1604235159172;
        Sun, 01 Nov 2020 04:52:39 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:38 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 14/19] net: phy: cicada: remove the use of .ack_interrupt()
Date:   Sun,  1 Nov 2020 14:51:09 +0200
Message-Id: <20201101125114.1316879-15-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/phy/cicada.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/cicada.c b/drivers/net/phy/cicada.c
index 086c62ff5293..ef5f412e101f 100644
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

