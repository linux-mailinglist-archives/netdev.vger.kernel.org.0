Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4846AE636
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCGQUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCGQTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:19:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BE27C3E5
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 08:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dNuvrGSIwTA5NXb6MRBDQvk5XI9567Ybm3Y4p+pxJr8=; b=abk7n52huIepcKyAXkjAnUx989
        IaRhFRd2yps55vUBvXSe44XBENZWVB4pSq4ZRVW4s5g1RGiY9TgQtVTQpN3pxXIFEROzcvBMzWVrm
        nXsrU5bFaAHyXVVCRT/U4RK8gg3WPGEFvfXi02fd7OVqN72RJD/887stiav6LdGTNENoD3qzpAb3K
        /BAm5m+TbqkYliv9Zp0/GDdAYJOisPwswc6IfnBJ600tAef6JHKhdRD/FzqxZVXE39qUB2eFXye9i
        VlvDSnvUhQd65Z+dCu+hTfn2JQaKA+KfZF/fFMoCo5m0CjKUwRZhNSsoVYQykd46sYPFuVbshClPB
        Rg0EbQLQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58696 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pZa2L-0000nJ-FZ; Tue, 07 Mar 2023 16:19:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pZa2K-00DFfR-Q8; Tue, 07 Mar 2023 16:19:36 +0000
In-Reply-To: <ZAdj9qUXcHUsK7Gt@shell.armlinux.org.uk>
References: <ZAdj9qUXcHUsK7Gt@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 3/4] net: mtk_eth_soc: remove unnecessary checks in
 mtk_mac_config()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pZa2K-00DFfR-Q8@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Mar 2023 16:19:36 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mtk_mac_config() checks that the interface mode is permitted for the
capabilities, but we already do these checks in mtk_add_mac() when
initialising phylink's supported_interfaces bitmap. Remove the
unnecessary tests.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 1b385dfe620f..f78810717f66 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -458,12 +458,6 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		/* Setup soc pin functions */
 		switch (state->interface) {
 		case PHY_INTERFACE_MODE_TRGMII:
-			if (mac->id)
-				goto err_phy;
-			if (!MTK_HAS_CAPS(mac->hw->soc->caps,
-					  MTK_GMAC1_TRGMII))
-				goto err_phy;
-			fallthrough;
 		case PHY_INTERFACE_MODE_RGMII_TXID:
 		case PHY_INTERFACE_MODE_RGMII_RXID:
 		case PHY_INTERFACE_MODE_RGMII_ID:
@@ -480,11 +474,9 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		case PHY_INTERFACE_MODE_1000BASEX:
 		case PHY_INTERFACE_MODE_2500BASEX:
 		case PHY_INTERFACE_MODE_SGMII:
-			if (MTK_HAS_CAPS(eth->soc->caps, MTK_SGMII)) {
-				err = mtk_gmac_sgmii_path_setup(eth, mac->id);
-				if (err)
-					goto init_err;
-			}
+			err = mtk_gmac_sgmii_path_setup(eth, mac->id);
+			if (err)
+				goto init_err;
 			break;
 		case PHY_INTERFACE_MODE_GMII:
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_GEPHY)) {
-- 
2.30.2

