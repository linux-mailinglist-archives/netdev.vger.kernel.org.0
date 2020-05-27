Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AE21E3F20
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgE0Keb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729861AbgE0Keb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:34:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCB4C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mzvdtBNa2V3w32xlpiuWuZRLqUYkkOBzmDoAtyzf/r8=; b=aA3+RlXC1fJFZ7WHrRY1PWJhAI
        KL/IeHQQZxyy/DMutV04K3W4IzV0ida0Qu+g8Y7yuEfX7OL2/XX25ysXWA/Ww6RGGOTrY9Kcguhjm
        zXwvY9x6VOlthBbC706ydtAUE2jkLNiSQklgTsgFzUSvuFPUgtRlo/3t3+NOUkeMF70bp9B5uCEHi
        2s0W95Veb526Ky7FBn+2Wu316rP+pn4pBhaBupqXe8ty0fEv+4CnPNCUx0pcJarL+/c5rK/zHamnJ
        1K15GOH3Je7QwQm2pHO/jKCw0MOaN8QDBs+Tr7nefAa+A5FZIsFfOxh3GzjozgEpbpn7ejpa3rqmK
        pwW5pShA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:50562 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNx-0001ws-0Z; Wed, 27 May 2020 11:34:09 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNu-00083q-Ok; Wed, 27 May 2020 11:34:06 +0100
In-Reply-To: <20200527103318.GK1551@shell.armlinux.org.uk>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC v2 5/9] net: phy: reword get_phy_device() kerneldoc
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdtNu-00083q-Ok@rmk-PC.armlinux.org.uk>
Date:   Wed, 27 May 2020 11:34:06 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 424e608cec21..bc20ee01b31d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -798,8 +798,17 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
  * @addr: PHY address on the MII bus
  * @is_c45: If true the PHY uses the 802.3 clause 45 protocol
  *
- * Description: Reads the ID registers of the PHY at @addr on the
- *   @bus, then allocates and returns the phy_device to represent it.
+ * Probe for a PHY at @addr on @bus.
+ *
+ * When probing for a clause 22 PHY, then read the ID registers. If we find
+ * a valid ID, allocate and return a &struct phy_device.
+ *
+ * When probing for a clause 45 PHY, read the "devices in package" registers.
+ * If the "devices in package" appears valid, read the ID registers for each
+ * MMD, allocate and return a &struct phy_device.
+ *
+ * Returns an allocated &struct phy_device on success, %-ENODEV if there is
+ * no PHY present, or %-EIO on bus access error.
  */
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-- 
2.20.1

