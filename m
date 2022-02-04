Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476CC4A9886
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 12:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358454AbiBDLmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 06:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345608AbiBDLmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 06:42:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04C9C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 03:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=u+rVxvY6mypUIAlWq0LV2q4DDasZbfkQnlFLCI96OA8=; b=LkNHv0lLmsXNfHedJlQbnLzCrh
        FRGr3cJlD0/XdA4ojREjNaQvz2AxeqSrJIzBpQ4hiDfsZITo1gfvvGiqlPr4KKk2MLYkGh5IAQJ/q
        bn8f3AXuJuBIGwA9z4noWFypK3wbxX6Y58ifE1uWbGxm8+3fFQfMMQVYERYJXsZE9TsFj/JbYaVGU
        fLyHWV5KJbefv+itKCpx8OJ55hq8yMFRoYS8PheRfhqYJrMYuTKCRVJgNwbDij3CRTFOUGGgtZSSS
        dF6jQvzQRWdFoXmnJqboZYwSH3yxvcXKuUpbOrxsD/MBXxMN/M2iZwLG5Eep5gjjv90tWq4uC0Qmz
        Q0rPdBGA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60590 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFwyg-0004SY-Mk; Fri, 04 Feb 2022 11:42:10 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFwyg-006Yqs-4C; Fri, 04 Feb 2022 11:42:10 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: remove phylink_set_10g_modes()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFwyg-006Yqs-4C@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 04 Feb 2022 11:42:10 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_set_10g_modes() is no longer used with the conversion of
drivers to phylink_generic_validate(), so we can remove it.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 11 -----------
 include/linux/phylink.h   |  1 -
 2 files changed, 12 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 420201858564..5b53a3e23c89 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -132,17 +132,6 @@ void phylink_set_port_modes(unsigned long *mask)
 }
 EXPORT_SYMBOL_GPL(phylink_set_port_modes);
 
-void phylink_set_10g_modes(unsigned long *mask)
-{
-	phylink_set(mask, 10000baseT_Full);
-	phylink_set(mask, 10000baseCR_Full);
-	phylink_set(mask, 10000baseSR_Full);
-	phylink_set(mask, 10000baseLR_Full);
-	phylink_set(mask, 10000baseLRM_Full);
-	phylink_set(mask, 10000baseER_Full);
-}
-EXPORT_SYMBOL_GPL(phylink_set_10g_modes);
-
 static int phylink_is_empty_linkmode(const unsigned long *linkmode)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(tmp) = { 0, };
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 713a0c928b7c..cca149f78d35 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -582,7 +582,6 @@ int phylink_speed_up(struct phylink *pl);
 #define phylink_test(bm, mode)	__phylink_do_bit(test_bit, bm, mode)
 
 void phylink_set_port_modes(unsigned long *bits);
-void phylink_set_10g_modes(unsigned long *mask);
 void phylink_helper_basex_speed(struct phylink_link_state *state);
 
 void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
-- 
2.30.2

