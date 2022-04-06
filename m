Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5091B4F6697
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbiDFRPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238705AbiDFROq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:14:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33664D59E8
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C+mT+I7C+rLOYe6LNKXzFxNP6ULNetQoJpOopRm5OHY=; b=UGYzJtZnwvhZFBrjhlySSsm0je
        XuHys9yELk2KWm3ynxiYjR8MrDurnKPPskcq6ZXS/MwN/SCsyT1L4qd+ISX/dV5xX4z3+XTfM1dWx
        t90RrSeNZuNwCYVAjK/8Zel1sQhjmKxg3K1WenxL/z992dsYaNm3SkkxZZzXFth4hTvGw0xQ5lMis
        pei/ePQzXLT4RCy6UmhE+qFA8ARmI2agTW1ZeOUhw/cZLvbwbpS9bpeOHDKMv4ZknCiTggIiFf9hF
        RaPCIMhDPE9gEJmi1m/pKO//Z2NUWAyaV66OB4gMx4LUPlDtUviwFIckIBlE/mAajKnD5LHzDo0ip
        1kY0g1Rw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60676 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nc6kt-0002vc-7Q; Wed, 06 Apr 2022 15:35:30 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nc6ks-004ik8-8j; Wed, 06 Apr 2022 15:35:30 +0100
In-Reply-To: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
References: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 07/12] net: mtk_eth_soc: provide
 mtk_sgmii_config()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nc6ks-004ik8-8j@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Apr 2022 15:35:30 +0100
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
index 7f29256b4b3c..a16f02ed921a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -385,12 +385,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
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
index 93f150bb09dd..4be779109cff 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1004,9 +1004,8 @@ u32 mtk_r32(struct mtk_eth *eth, unsigned reg);
 
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
index b656c8b3ca35..57925910cf80 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -34,7 +34,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 }
 
 /* For SGMII interface mode */
-int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
+static int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
 {
 	unsigned int val;
 
@@ -63,8 +63,8 @@ int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
 /* For 1000BASE-X and 2500BASE-X interface modes, which operate at a
  * fixed speed.
  */
-int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
-			       phy_interface_t interface)
+static int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
+				      phy_interface_t interface)
 {
 	unsigned int val;
 
@@ -96,6 +96,20 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
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

