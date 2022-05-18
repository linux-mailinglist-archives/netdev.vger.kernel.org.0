Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FD052BEA6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiEROzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238882AbiEROzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:55:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290381DE543
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HbolTbU71PwGrjrYUUqTIX87mDyGzw3Qcfgdv4lmj/0=; b=i6GhToCfhnA2Cn0t75TlkbInCm
        0tVeGpkL7v6/tdRREwF8JFpd4VxHaQOCglc2cyar54ky38mSaxRIZyjUsS51/Be0h2MaWca2kAsxW
        PojR3k+5EU4t4Cm7eognaNvz95n4as8+RGvR/x946iJPTuroKxhUilh3yuTBCuz2efls7UFvLY8m5
        fXIeA/09A878SlT3cwLigFZSuUKCDNwEnvzB8T16oihIm801iHbQe6zWnHHRxSiwuvo1NLE6fdNZI
        mKgO7rpHthvFEy39gYHHTN43e8AHxtSNDkGud/36pmhyuOoh6N0Yf1dnsVIsijJ/z2omRaw2g9WyY
        DWvHVvbA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38622 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nrL4o-0002Fm-KD; Wed, 18 May 2022 15:55:03 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nrL4o-00AM5E-Go; Wed, 18 May 2022 15:55:02 +0100
In-Reply-To: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
References: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 07/12] net: mtk_eth_soc: provide mtk_sgmii_config()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nrL4o-00AM5E-Go@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 May 2022 15:55:02 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide mtk_sgmii_config() to wrap up the decisions about which SGMII
configuration will be called.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  7 +------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  5 ++---
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 20 +++++++++++++++++---
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 080f7e356591..87b5a837695f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -388,12 +388,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		       0 : mac->id;
 
 		/* Setup SGMIISYS with the determined property */
-		if (state->interface != PHY_INTERFACE_MODE_SGMII)
-			err = mtk_sgmii_setup_mode_force(eth->sgmii, sid,
-							 state->interface);
-		else if (phylink_autoneg_inband(mode))
-			err = mtk_sgmii_setup_mode_an(eth->sgmii, sid);
-
+		err = mtk_sgmii_config(eth->sgmii, sid, mode, state->interface);
 		if (err)
 			goto init_err;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 455b1460160e..fa3c085bf7ed 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1014,9 +1014,8 @@ u32 mtk_r32(struct mtk_eth *eth, unsigned reg);
 
 int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *np,
 		   u32 ana_rgc3);
-int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id);
-int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
-			       phy_interface_t interface);
+int mtk_sgmii_config(struct mtk_sgmii *ss, int id, unsigned int mode,
+		     phy_interface_t interface);
 void mtk_sgmii_link_up(struct mtk_sgmii *ss, int id, int speed, int duplex);
 void mtk_sgmii_restart_an(struct mtk_eth *eth, int mac_id);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 38d52386c88f..4defc1ca41b6 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -35,7 +35,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 }
 
 /* For SGMII interface mode */
-int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
+static int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
 {
 	unsigned int val;
 
@@ -64,8 +64,8 @@ int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
 /* For 1000BASE-X and 2500BASE-X interface modes, which operate at a
  * fixed speed.
  */
-int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
-			       phy_interface_t interface)
+static int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
+				      phy_interface_t interface)
 {
 	unsigned int val;
 
@@ -97,6 +97,20 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
 	return 0;
 }
 
+int mtk_sgmii_config(struct mtk_sgmii *ss, int id, unsigned int mode,
+		     phy_interface_t interface)
+{
+	int err = 0;
+
+	/* Setup SGMIISYS with the determined property */
+	if (interface != PHY_INTERFACE_MODE_SGMII)
+		err = mtk_sgmii_setup_mode_force(ss, id, interface);
+	else if (phylink_autoneg_inband(mode))
+		err = mtk_sgmii_setup_mode_an(ss, id);
+
+	return err;
+}
+
 /* For 1000BASE-X and 2500BASE-X interface modes */
 void mtk_sgmii_link_up(struct mtk_sgmii *ss, int id, int speed, int duplex)
 {
-- 
2.30.2

