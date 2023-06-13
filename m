Return-Path: <netdev+bounces-10418-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8AAF72E5FE
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DC201C20C92
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2C82A9FB;
	Tue, 13 Jun 2023 14:38:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138AB3B8D1
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:38:37 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D6F1B0
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sohyzqjHoglhxJYapMiqtRsLL/cfxTOCOEf9P4U53WM=; b=MjU0XMfzjbjCW61z33UsnXDLKx
	vhB6D/oJ0DOuQRxxEDBKEOKXbrbZGy3TckMP9jJyeH6hxcWIJn5TSZbk1wHB8wJsDnlHBwGdKkcdl
	DIZ9Bk5cJ4n1KRtjaBpQty/CT1IxR0V2g58chg4TmiM8GnzimZezXId+SaWBQRKnTYE5j4HrQzOpF
	Z2E5Y22HI30tPCRRWV6hnzxTl4aZa8eEJE+0SXY/oX7OBylPFqGvRL+05VMXlmh4s1erXZdWXqOmN
	zTNAnVBFqkkpDZF6G15RrhHhvxH1Fbi2ykF66c23Jn/BINnofT7kkbunVXcY9FX88yUn60/xgchcm
	6n9PvsuA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43802 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q95A8-0007WA-Tl; Tue, 13 Jun 2023 15:38:24 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q95A8-00EBwW-69; Tue, 13 Jun 2023 15:38:24 +0100
In-Reply-To: <ZIh/CLQ3z89g0Ua0@shell.armlinux.org.uk>
References: <ZIh/CLQ3z89g0Ua0@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Alexander Couzens <lynxis@fe80.eu>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Cc@web.codeaurora.org:Alexander Couzens <lynxis@fe80.eu>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	DENG Qingfang <dqfext@gmail.com>, Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 11/15] net: qca8k: update PCS driver to use
 neg_mode
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q95A8-00EBwW-69@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 13 Jun 2023 15:38:24 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Update qca8k's embedded PCS driver to use neg_mode rather than the
mode argument. As there is no pcs_link_up() method, this only affects
the pcs_config() method.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index dee7b6579916..f7d7cfb2fd86 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1493,7 +1493,7 @@ static void qca8k_pcs_get_state(struct phylink_pcs *pcs,
 		state->pause |= MLO_PAUSE_TX;
 }
 
-static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 			    phy_interface_t interface,
 			    const unsigned long *advertising,
 			    bool permit_pause_to_mac)
@@ -1520,14 +1520,12 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	}
 
 	/* Enable/disable SerDes auto-negotiation as necessary */
-	ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
+	val = neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED ?
+		0 : QCA8K_PWS_SERDES_AEN_DIS;
+
+	ret = qca8k_rmw(priv, QCA8K_REG_PWS, QCA8K_PWS_SERDES_AEN_DIS, val);
 	if (ret)
 		return ret;
-	if (phylink_autoneg_inband(mode))
-		val &= ~QCA8K_PWS_SERDES_AEN_DIS;
-	else
-		val |= QCA8K_PWS_SERDES_AEN_DIS;
-	qca8k_write(priv, QCA8K_REG_PWS, val);
 
 	/* Configure the SGMII parameters */
 	ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
@@ -1598,6 +1596,7 @@ static void qca8k_setup_pcs(struct qca8k_priv *priv, struct qca8k_pcs *qpcs,
 			    int port)
 {
 	qpcs->pcs.ops = &qca8k_pcs_ops;
+	qpcs->pcs.neg_mode = true;
 
 	/* We don't have interrupts for link changes, so we need to poll */
 	qpcs->pcs.poll = true;
-- 
2.30.2


