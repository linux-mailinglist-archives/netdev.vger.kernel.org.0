Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124AC4A988E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 12:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241380AbiBDLr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 06:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiBDLr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 06:47:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2026BC061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 03:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2mu7fSksejJ4hWK6Xu59gD5R4RLEca34ahd+6ifrpYk=; b=OILTr5akw6OAOKyZsbG31udYbm
        nXOWdITV434si7xgV9r94O+mwS98ioIMdDW5De36qyGT9dtNtur1OqNgbpHs/sO9iRlSfMQnpYAIr
        sHSvbH9W0TlIUiKTL+Vqh3ofEh+DvEtq0Rsn7AfYbnsBLAqPDUHpqQhOECFwXp0P7hUzCu3SUUks8
        RUsufhihkpi747YMB1hX8ADWKnBbuIGkWpX7uCCcdM7QvoUQ8RgTDz4z8Lr7j4MoKoNfPgrdv23Y2
        JNIMcjVO8VlWYv0gs3h3Zho+bxV+0Uve6UxS5YlILkPwElO/Q1DxIAmpFpBIRo6JLk8Q18Ca/em71
        s3EdYYhA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60624 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFx4E-0004T6-MU; Fri, 04 Feb 2022 11:47:54 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFx4D-006Ywj-Vw; Fri, 04 Feb 2022 11:47:54 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next] net: sparx5: remove phylink_config.pcs_poll usage
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFx4D-006Ywj-Vw@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 04 Feb 2022 11:47:53 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink will use PCS polling whenever phylink_config.pcs_poll or the
phylink_pcs poll member is set. As this driver sets both, remove the
former.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 35689b5e212c..394de85d360d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -291,7 +291,6 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 	/* Create a phylink for PHY management.  Also handles SFPs */
 	spx5_port->phylink_config.dev = &spx5_port->ndev->dev;
 	spx5_port->phylink_config.type = PHYLINK_NETDEV;
-	spx5_port->phylink_config.pcs_poll = true;
 	spx5_port->phylink_config.mac_capabilities = MAC_ASYM_PAUSE |
 		MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD |
 		MAC_2500FD | MAC_5000FD | MAC_10000FD | MAC_25000FD;
-- 
2.30.2

