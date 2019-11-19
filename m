Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB6102AAC
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfKSRS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:18:59 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54600 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbfKSRS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=d7gaQXaOZuD56XOR2d5iryMWvBxv9PFeFj7jATwMUok=; b=MOKrtpvf/Noiak6ccZp4jfzPug
        q0xW786z+zN2nJa8RBmO9OTzfZuoR/odUimAuHrywu3tTDJyFwn58SPT5Ag0WI0xQxGe0FBMPYe12
        WeHX41M2plUTVD3fcW8cg25N2LEJBetBWZCjMn9j7T1La44vrniEz4Ao5O+kb6q/s31mYBLIIBDg8
        K4FTEP+RVMRuf92UJLfNLphtaZbpybkdDGnRh2SeRK6Hdz7ha78n3ZSaHwLRgsqI2j7iyCv/Cmu+V
        xjBuJAwC3CMBZj/guvYki5atcZU2UdWpdFWwi++51Mc9kM5WVg0L2PMth0LN6wxKQdmFVNi/fvllD
        h9vau+tg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37072 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iX79Q-0002jT-Os; Tue, 19 Nov 2019 17:18:52 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iX79Q-0000hw-0u; Tue, 19 Nov 2019 17:18:52 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: update documentation on create and destroy
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iX79Q-0000hw-0u@rmk-PC.armlinux.org.uk>
Date:   Tue, 19 Nov 2019 17:18:52 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the documentation on phylink's create and destroy functions to
explicitly state that the rtnl lock must not be held while calling
these.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8b5e1086523c..342521ed7e7a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -580,6 +580,8 @@ static int phylink_register_sfp(struct phylink *pl,
  * Create a new phylink instance, and parse the link parameters found in @np.
  * This will parse in-band modes, fixed-link or SFP configuration.
  *
+ * Note: the rtnl lock must not be held when calling this function.
+ *
  * Returns a pointer to a &struct phylink, or an error-pointer value. Users
  * must use IS_ERR() to check for errors from this function.
  */
@@ -659,6 +661,8 @@ EXPORT_SYMBOL_GPL(phylink_create);
  *
  * Destroy a phylink instance. Any PHY that has been attached must have been
  * cleaned up via phylink_disconnect_phy() prior to calling this function.
+ *
+ * Note: the rtnl lock must not be held when calling this function.
  */
 void phylink_destroy(struct phylink *pl)
 {
-- 
2.20.1

