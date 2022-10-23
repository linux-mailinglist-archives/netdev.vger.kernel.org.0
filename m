Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA342609546
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 19:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiJWRxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 13:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJWRxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 13:53:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B136B143;
        Sun, 23 Oct 2022 10:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=152+j1ecdJ/pTxbDHF3JcWO1hEBXq3IkRPt0LcgCa1k=; b=pPoXbhHMdvPpU8DeMUjStDzBCX
        SHuaXIZ3Bku8RUSYvJMu5S+8tdYnEz9wsAT5dgdSd7f+AfYKY68AHt1o5Cy9p+AuUg0UAAHgNahdM
        Mli+le0876Z0UglZ5Vq6d9Bk/Knr6HZC1nBaPDoGePFRq+c0mPmvNuHoZlvJOkWzoRAqdMRnq+199
        dWHwrDzUK75ly6A3SgzMa1D5AgcywfBJZzNT3H2+3zYTVmuhe67DoLIKkkSR/FI1aOrFbslWlZgIp
        64iqMeGHjnSTkS8rzTnv1lNOHUtUPFX21FDLsIUU3ZCG5Lts5S88C6bea09kmm7OALkqSP0PpGqPB
        fZj1s/uA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34912)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1omf9Z-0002Ao-QY; Sun, 23 Oct 2022 18:52:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1omf9O-0006Gp-Ez; Sun, 23 Oct 2022 18:52:42 +0100
Date:   Sun, 23 Oct 2022 18:52:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
References: <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
 <trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49>
 <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
 <trinity-164dc5a6-98ce-464c-a43d-b00b91ca69e5-1666461195968@3c-app-gmx-bs49>
 <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
 <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
 <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
 <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
 <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
 <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 06:41:45PM +0200, Frank Wunderlich wrote:
> bootup:
> 
> [    1.098876] dev: 1 offset:0 0x81140
> [    1.102699] dev: 1 offset:4 0x4d544950
> [    1.106180] dev: 1 offset:8 0x1
> [    1.109914] dev: 1 offset:32 0x3112001b
> 
> after putting eth1 up:
> 
> [   32.566099] timer 0x186a0
> [   32.623021] offset:0 0x2c1140
> [   32.625653] offset:4 0x4d544950
> [   32.628614] offset:8 0x40e041a0
> [   32.631746] offset:32 0x3112011b

Hi Frank,

Based on this, could you give the following patch a try - it replaces
my previous patch.

Thanks.

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index b52f3b0177ef..1a3eb3ecf7e3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -479,7 +479,7 @@
 
 /* Register to programmable link timer, the unit in 2 * 8ns */
 #define SGMSYS_PCS_LINK_TIMER	0x18
-#define SGMII_LINK_TIMER_DEFAULT	(0x186a0 & GENMASK(19, 0))
+#define SGMII_LINK_TIMER_MASK		GENMASK(19, 0)
 
 /* Register to control remote fault */
 #define SGMSYS_SGMII_MODE		0x20
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 736839c84130..63736c52bab2 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -20,19 +20,40 @@ static struct mtk_pcs *pcs_to_mtk_pcs(struct phylink_pcs *pcs)
 }
 
 /* For SGMII interface mode */
-static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
+static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs,
+				 phy_interface_t interface,
+				 const unsigned long *advertising)
 {
-	unsigned int val;
+	unsigned int val, link_timer;
+	int advertise;
+	bool changed;
+
+	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
+							     advertising);
+	if (advertise < 0)
+		return advertise;
+
+	if (interface == PHY_INTERFACE_MODE_SGMII)
+		link_timer = 1600000 / 2 / 8;
+	else
+		link_timer = 10000000 / 2 / 8;
 
 	/* Setup the link timer and QPHY power up inside SGMIISYS */
-	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
-		     SGMII_LINK_TIMER_DEFAULT);
+	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer);
 
 	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
+	if (interface = == PHY_INTERFACE_MODE_SGMII)
+		val |= SGMII_IF_MODE_BIT0;
+	else
+		val &= ~SGMII_IF_MODE_BIT0;
 	val |= SGMII_REMOTE_FAULT_DIS;
 	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
 
+	regmap_update_bits_check(mpcs->regmap, SGMSYS_PCS_CONTROL_1 + 8, 0xffff,
+				 advertise, &changed);
+
 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
+	val |= SGMII_AN_ENABLE;
 	val |= SGMII_AN_RESTART;
 	regmap_write(mpcs->regmap, SGMSYS_PCS_CONTROL_1, val);
 
@@ -40,7 +61,7 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
 	val &= ~SGMII_PHYA_PWD;
 	regmap_write(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL, val);
 
-	return 0;
+	return changed ? 1 : 0;
 
 }
 
@@ -52,12 +73,6 @@ static int mtk_pcs_setup_mode_force(struct mtk_pcs *mpcs,
 {
 	unsigned int val;
 
-	regmap_read(mpcs->regmap, mpcs->ana_rgc3, &val);
-	val &= ~RG_PHY_SPEED_MASK;
-	if (interface == PHY_INTERFACE_MODE_2500BASEX)
-		val |= RG_PHY_SPEED_3_125G;
-	regmap_write(mpcs->regmap, mpcs->ana_rgc3, val);
-
 	/* Disable SGMII AN */
 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
 	val &= ~SGMII_AN_ENABLE;
@@ -83,13 +98,22 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			  bool permit_pause_to_mac)
 {
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
+	unsigned int val;
 	int err = 0;
 
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		val = RG_PHY_SPEED_3_125G;
+	else
+		val = 0;
+
+	regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
+			   RG_PHY_SPEED_3_125G, val);
+
 	/* Setup SGMIISYS with the determined property */
-	if (interface != PHY_INTERFACE_MODE_SGMII)
+	if (phylink_autoneg_inband(mode))
+		err = mtk_pcs_setup_mode_an(mpcs, interface, advertising);
+	else if (interface != PHY_INTERFACE_MODE_SGMII)
 		err = mtk_pcs_setup_mode_force(mpcs, interface);
-	else if (phylink_autoneg_inband(mode))
-		err = mtk_pcs_setup_mode_an(mpcs);
 
 	return err;
 }


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
