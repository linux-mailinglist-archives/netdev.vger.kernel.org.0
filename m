Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19391550403
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 12:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiFRK3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 06:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiFRK2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 06:28:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6799205DD
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PKHrlzywYFJRT92+/mCW/3kj8IPmNtPkoXii4nZOAa0=; b=1mz5CLVR5wSWTV3MJxI8Mvs7Bn
        OSkmb7bZ/Znujirwqai5iggBthBPmEDqD448zLBUWTcy4nspjphLGtVCget9Z/nx+2WRGxMn6OtNK
        PpH1xw8GMUwrQtcU0DTHhyJandaPDb6prqcSnP/Cw4VdnI8yuytFcCzL0XE5T9muEL8y0O82KXkpd
        II2ZgyDJcg1WMZuRPAHEhwoUEBsCuPBt+HXHezGvnMOQKUZhljk3OqD4Vg9oF7hrHaNAwMSGTDZ3r
        jP+bsW64AW+ZMPMNAHUa0hAJDTiWEDOO3nGCd2A2u3BPiXh5rw64FsVgvJZUGlHiPRBJtUgsxkVj6
        3BvuU/3A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44610 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o2VhA-0004BL-4T; Sat, 18 Jun 2022 11:28:48 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o2Vh9-0026CA-Hv; Sat, 18 Jun 2022 11:28:47 +0100
In-Reply-To: <Yq2iMpbsux5wEM54@shell.armlinux.org.uk>
References: <Yq2iMpbsux5wEM54@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 4/4] net: pcs: pcs-xpcs: use mii_bmcr_encode_fixed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o2Vh9-0026CA-Hv@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sat, 18 Jun 2022 11:28:47 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly introduced mii_bmcr_encode_fixed() for the xpcs driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index a5d520e34ea3..ab0af1d2531f 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1081,23 +1081,7 @@ static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
 	if (phylink_autoneg_inband(mode))
 		return;
 
-	switch (speed) {
-	case SPEED_1000:
-		val = BMCR_SPEED1000;
-		break;
-	case SPEED_100:
-		val = BMCR_SPEED100;
-		break;
-	case SPEED_10:
-		val = BMCR_SPEED10;
-		break;
-	default:
-		return;
-	}
-
-	if (duplex == DUPLEX_FULL)
-		val |= BMCR_FULLDPLX;
-
+	val = mii_bmcr_encode_fixed(speed, duplex);
 	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, val);
 	if (ret)
 		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
-- 
2.30.2

