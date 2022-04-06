Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448394F66CA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbiDFRPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238684AbiDFROd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:14:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2CB4D4CA9
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R926PzfjUYoA24VgpIYq2VzMgn3qO9GangkHxkFJif4=; b=WWvosuPOfDyD1qa4W377AX+7jI
        iDSQVSCozvzI4DiQEAqljJiE67qpAaXy7SkbzVlvZnD29lBlyrZpxejElg1Cx53QUs5b2E/JL0ngu
        gvckF1YQvm91sxAqWvfOSGpSE4mfAO2r3pGMQmgshBncMD357owCpQfqwCmL+vDnGyoovJyzTXIM3
        Q8eByHid7F9Jb7xib0RB8qoqxeCcg0RAXRDmg8ORYISNnL0nbh54Yi8FcA8zkATYpv6ZZevSawrrM
        HkauzIUWejBM1/r2dRNFpVkYHnGJPzX5PiwSBzxuIxjmehc7QUPWg7bS2TY3YCS+irrVzqUPhbWxG
        RRp0Kk9A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60674 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nc6ko-0002vK-1t; Wed, 06 Apr 2022 15:35:25 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nc6kn-004ik2-51; Wed, 06 Apr 2022 15:35:25 +0100
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
Subject: [PATCH RFC net-next 06/12] net: mtk_eth_soc: stop passing phylink
 state to sgmii setup
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nc6kn-004ik2-51@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Apr 2022 15:35:25 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that mtk_sgmii_setup_mode_force() only uses the interface mode
from the phylink state, pass just the interface mode into this
function.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6fedfa8fceb1..7f29256b4b3c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -387,7 +387,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		/* Setup SGMIISYS with the determined property */
 		if (state->interface != PHY_INTERFACE_MODE_SGMII)
 			err = mtk_sgmii_setup_mode_force(eth->sgmii, sid,
-							 state);
+							 state->interface);
 		else if (phylink_autoneg_inband(mode))
 			err = mtk_sgmii_setup_mode_an(eth->sgmii, sid);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 1912f84922c8..93f150bb09dd 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1006,7 +1006,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *np,
 		   u32 ana_rgc3);
 int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id);
 int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
-			       const struct phylink_link_state *state);
+			       phy_interface_t interface);
 void mtk_sgmii_link_up(struct mtk_sgmii *ss, int id, int speed, int duplex);
 void mtk_sgmii_restart_an(struct mtk_eth *eth, int mac_id);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index a5ec61e13b85..b656c8b3ca35 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -64,7 +64,7 @@ int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id)
  * fixed speed.
  */
 int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
-			       const struct phylink_link_state *state)
+			       phy_interface_t interface)
 {
 	unsigned int val;
 
@@ -73,7 +73,7 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
 
 	regmap_read(ss->regmap[id], ss->ana_rgc3, &val);
 	val &= ~RG_PHY_SPEED_MASK;
-	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
 		val |= RG_PHY_SPEED_3_125G;
 	regmap_write(ss->regmap[id], ss->ana_rgc3, val);
 
-- 
2.30.2

