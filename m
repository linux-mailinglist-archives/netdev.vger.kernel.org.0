Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823F91FF396
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgFRNp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgFRNp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:45:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AE0C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 06:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oryfz0YuhzbuZg/1pIX6cfRuGPEDdepmwEcWH2Rmj8c=; b=v3WkQZjrwuT0vMsFY9E/AtkNQo
        BmlbD4LyYCa4N+Ef0Nu6UTz0oUqZ7IJTTgcf1j15ENbRFmxHpcmFK6JlpaNzJATXQJVIHgfQ7qJ5m
        kDYQY/BIzasbxP72qZ/4XGV5+Txqst7Q4g2e5WklpQiK7p8tlqyODyIgUCiL217FvxSDUvIQfQCr3
        XJTwDZBP6HpQE0pB+gjlSFX84NdpRGZqHvY+K2M5fbgq6I2ADoE65jGKtel04qxwwyqPDa0lAHN2z
        HXSEzzEJyOmj71xtx/uVfIuyb9HfA/2vV+ABMcxDsO/MWSONEMSMwAmor2ahCo9dI3C8ZFviAr30w
        mIIExG+g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37652 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurZ-0005As-Fw; Thu, 18 Jun 2020 14:45:53 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurZ-0004kE-8l; Thu, 18 Jun 2020 14:45:53 +0100
In-Reply-To: <20200618134500.GB1551@shell.armlinux.org.uk>
References: <20200618134500.GB1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 5/9] net: phy: reword get_phy_device() kerneldoc
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jlurZ-0004kE-8l@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 14:45:53 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reword the get_phy_device() kerneldoc to be more explicit about how
we probe for the PHY, and what the various return conditions signify.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0e802c6add09..09096c3ceb86 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -800,8 +800,17 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
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

