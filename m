Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB15E557A45
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbiFWMZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiFWMZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:25:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED51635DFC
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 05:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Rq1WfrKqkMxNo2r5hZ771Ipx4n854ru9+cKF/myfpoo=; b=WWnUqo9sj+YlaCdgG51x2/bbhB
        Rwn8IO/p0fXM3qYxfFfSfnbuzYFm8MGrnn3EbSe7UsFkH1nYUc7FKOaiN87kwwRWAko+uIMK9gzfS
        HF90jFmPykAuqKIPC7PVJms9o1ZAObT/D8bwbguhW87AD65Em87mnXFKJHKu7ghVkFwKLGu6p6k8g
        CbCeznKxF6CWrIvJ7VNI3z86vYQ0a9Xjh0cY6y0K3i1hc2yn5VGxrZ+j7px9pmb+qzbYUaoaVaG9/
        p+Rs50HIKJAuUIxrHiTmPGccTNTHoi5/klHQ4xaOy1YxyeKCUiWkwywfnmkbuQjReYipGkMWp5eEm
        k8q0m6SQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37560 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o4Ltm-0004q1-C0; Thu, 23 Jun 2022 13:25:26 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o4Ltl-003fYA-Po; Thu, 23 Jun 2022 13:25:25 +0100
In-Reply-To: <YrRbjOEEww38JFIK@shell.armlinux.org.uk>
References: <YrRbjOEEww38JFIK@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/2] net: phylink: add QSGMII support to
 phylink_mii_c22_pcs_encode_advertisement()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o4Ltl-003fYA-Po@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 23 Jun 2022 13:25:25 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QSGMII MAC-to-PHY reply is the same as the SGMII MAC-to-PHY reply.
Add support for this to phylink_mii_c22_pcs_encode_advertisement().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 066684b80919..e20cdab824db 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2991,6 +2991,7 @@ int phylink_mii_c22_pcs_encode_advertisement(phy_interface_t interface,
 			adv |= ADVERTISE_1000XPSE_ASYM;
 		return adv;
 	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
 		return 0x0001;
 	default:
 		/* Nothing to do for other modes */
-- 
2.30.2

