Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314CA2A1E0D
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgKAMxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgKAMwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:45 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66344C061A04;
        Sun,  1 Nov 2020 04:52:44 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id l24so11347704edj.8;
        Sun, 01 Nov 2020 04:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hO8iEAWXFC7W/MF6vT8UKXWiO7uCrbk5wP0QUGzUSFk=;
        b=pIqD7R0EAHt+2uEyvaVLLyrbWqgJtipiyZxV7FZ+O//0GDRRnkcS/EbwMbisPEqvvA
         uBlrsNXQbDJkb25jFG16C5Ref4vi+9MxYomFNnS5tGtM8jVSK2MmaipDLGff/aQefZ7n
         cm4rIUgVMEnY1LaW05o64w/9h4hcPLsEdHnwkQq61dtfiGxp8NcRrx2rF4fLJEd+ESlz
         BNcTv4gQa/hH1A2o/aiObIJ3vAXoTtFH7Gc8QnZfP9z+b7NZ0S0g5uNTj0bqbHR+r5hP
         c8LfgPdTKazgfKiB963b21Ze6rNGFtFrgctpVWs5xS8lAVJdV8TRNFfzrH4Z9+5dp6Yx
         /3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hO8iEAWXFC7W/MF6vT8UKXWiO7uCrbk5wP0QUGzUSFk=;
        b=txiPmOJjLV67pWBghfP3c7ucLbDg/x3Zy7MppGfM+yX4OplsIdEZVIFiYz1c2vK33V
         Otq8XCjt7B0D1txVUD6zXqwVNe3sk4tU5OE7I24HStnPYlPrtHSzKpeMcXI41PzMFbas
         vvSdqnN8UHRRL33SLs0DBcbG6ltFM0F/VCmv63M7Tk7mQkOrjvfGI5v1FetEnThOK3Ay
         DHhc0jzxDNfbTAWbLQlPzZtbhgB0+Tr+5TPKJVC3Ilbad5Cbk4E1uZNvdIwb6PBuMe16
         GZNKT7RhQXrghCHStYrVrkVY2DCWhEvjP36pb8m/Xp8ifAAIPWUe11pYaPrOWpoW/5rF
         ahtQ==
X-Gm-Message-State: AOAM532yD6Ub/vZW8/iJxoVTv9OCHy3R3q504WaGDpZJCbrFaqMp6u7W
        p2TKpuUDq/isNqtA3x1Y0O4zzBbwHmR5+gp7
X-Google-Smtp-Source: ABdhPJwbj4EMYmNcxY9i11I4L1ZfHpEkP004uta9h4LdRM+a54UvUf7owtkrnjLdrnfhz50IT/tgig==
X-Received: by 2002:a05:6402:3136:: with SMTP id dd22mr378857edb.256.1604235163120;
        Sun, 01 Nov 2020 04:52:43 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:42 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 17/19] net: phy: add genphy_handle_interrupt_no_ack()
Date:   Sun,  1 Nov 2020 14:51:12 +0200
Message-Id: <20201101125114.1316879-18-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

It seems there are cases where the interrupts are handled by another
entity (ie an IRQ controller embedded inside the PHY) and do not need
any other interraction from phylib. For this kind of PHYs, like the
RTL8366RB, add the genphy_handle_interrupt_no_ack() function which just
triggers the link state machine.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/phy/phy_device.c | 13 +++++++++++++
 include/linux/phy.h          |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f54f483d7fd6..e13a46c25437 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2463,6 +2463,19 @@ int genphy_soft_reset(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_soft_reset);
 
+irqreturn_t genphy_handle_interrupt_no_ack(struct phy_device *phydev)
+{
+	/* It seems there are cases where the interrupts are handled by another
+	 * entity (ie an IRQ controller embedded inside the PHY) and do not
+	 * need any other interraction from phylib. In this case, just trigger
+	 * the state machine directly.
+	 */
+	phy_trigger_machine(phydev);
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_handle_interrupt_no_ack);
+
 /**
  * genphy_read_abilities - read PHY abilities from Clause 22 registers
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 566b39f6cd64..4f158d6352ae 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1510,6 +1510,7 @@ int genphy_suspend(struct phy_device *phydev);
 int genphy_resume(struct phy_device *phydev);
 int genphy_loopback(struct phy_device *phydev, bool enable);
 int genphy_soft_reset(struct phy_device *phydev);
+irqreturn_t genphy_handle_interrupt_no_ack(struct phy_device *phydev);
 
 static inline int genphy_config_aneg(struct phy_device *phydev)
 {
-- 
2.28.0

