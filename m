Return-Path: <netdev+bounces-8539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C92227247AE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C1B51C20AC5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F722DBD7;
	Tue,  6 Jun 2023 15:25:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4789C37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:25:26 +0000 (UTC)
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CC010D4;
	Tue,  6 Jun 2023 08:25:23 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686065122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+xPNxPluiQLUdXA04A2YJr3G7ZHNVmkXepB9CnKmbc=;
	b=Ew3L3o0QOKR4qCyb5VWPw5izdXReDf6atajR2pRNUbswisofsbOUD0F5RfQtJ3SQx4H07U
	G0ZaEJxSRid+7TRIyhixOR3SpVg1rzLQ+2F/ojh5zbSzdYrnWWrTCjIB1Dz4JI3x7Vx4GK
	AXYR/AshIMNDC7RQ9lFQb8+aCqka13nZz1Q+MYdzlisG8RsTQZ7c1tzOyFTWgdWPqdiVF6
	elvXtwZID/X1fafXAH0s1FIAzneg5CLWU5eao7uAD0ns0kyRrjlvw1EUdPyURqClHk3wdT
	3Pgetmamlh+aQbE7qHLJSeMyGdh44spytuAi85HQKtI7VAE0E5OD3C1yugIuHw==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id BFAA0FF80B;
	Tue,  6 Jun 2023 15:25:19 +0000 (UTC)
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Simon Horman <simon.horman@corigine.com>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v3 5/5] net: dwmac_socfpga: explicitly disable autoscan on the regmap-mdio bus
Date: Tue,  6 Jun 2023 17:25:01 +0200
Message-Id: <20230606152501.328789-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606152501.328789-1-maxime.chevallier@bootlin.com>
References: <20230606152501.328789-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Set the .autoscan flag to false on the regmap-mdio bus, to avoid using a
random uninitialized value. We don't want autoscan in this case as the
mdio device is a PCS and not a PHY.

Fixes: 5d1f3fe7d2d5 ("net: stmmac: dwmac-sogfpga: use the lynx pcs driver")
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V2->V3 : New patch

 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 1fb808be843b..e1bdf132cede 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -470,6 +470,7 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 		mrc.regmap = pcs_regmap;
 		mrc.parent = &pdev->dev;
 		mrc.valid_addr = 0x0;
+		mrc.autoscan = false;
 
 		snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);
 		pcs_bus = devm_mdio_regmap_register(&pdev->dev, &mrc);
-- 
2.40.1


