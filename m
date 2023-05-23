Return-Path: <netdev+bounces-4739-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA2370E127
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 166551C20BB9
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01E6200BD;
	Tue, 23 May 2023 15:55:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D392A1F92A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:55:38 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B68791
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=n9eDO+1ygvDE+gdpZgXbwnZiXkHIBqMNSiOE0viq9CY=; b=uVspDpPDe210Q2JkdLWxqwglwj
	WYH4VJap27Or+g8xdgKrjXkg69nxEMvD3/ObLMrbSTawbmMg2kxVQdDSVqWFYwZTqF33N9wwlUxsN
	m9FTUgUVoUBLUD1ZVPBf61oDcClH7Bp4o00oEKCj/NyUx3wkZTrxr5imUuYxsedqCe2UXpFcrbwdv
	ErcfLHToR/613vDqYbY0xy/wEZ5Iz64W3ykr4ZBVHh0UITGWJrsO1VTO2ejW+zrDJrEj4c1gwqQHv
	AgYwwDWvP9DhgC8g7lNWjdV2JnffYNOe6xQP94eCsHBgPJYxX7khv2TRxl79Uh6KP7tImAZEnyn8R
	EK21zD5g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48978 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1UMF-0000k2-1J; Tue, 23 May 2023 16:55:31 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1UME-007FT0-Dw; Tue, 23 May 2023 16:55:30 +0100
In-Reply-To: <ZGzhvePzPjJ0v2En@shell.armlinux.org.uk>
References: <ZGzhvePzPjJ0v2En@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Michal Simek <michal.simek@amd.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 5/9] net: mvneta: switch PCS driver to use
 phylink_pcs_neg_mode()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q1UME-007FT0-Dw@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 16:55:30 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use the newly introduced phylink_pcs_neg_mode() to configure whether
inband-AN should be used.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e2abc00d0472..d669276639b1 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4009,6 +4009,7 @@ static int mvneta_pcs_config(struct phylink_pcs *pcs,
 {
 	struct mvneta_port *pp = mvneta_pcs_to_port(pcs);
 	u32 mask, val, an, old_an, changed;
+	unsigned int neg_mode;
 
 	mask = MVNETA_GMAC_INBAND_AN_ENABLE |
 	       MVNETA_GMAC_INBAND_RESTART_AN |
@@ -4016,7 +4017,9 @@ static int mvneta_pcs_config(struct phylink_pcs *pcs,
 	       MVNETA_GMAC_AN_FLOW_CTRL_EN |
 	       MVNETA_GMAC_AN_DUPLEX_EN;
 
-	if (phylink_autoneg_inband(mode)) {
+	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
+
+	if (neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED) {
 		mask |= MVNETA_GMAC_CONFIG_MII_SPEED |
 			MVNETA_GMAC_CONFIG_GMII_SPEED |
 			MVNETA_GMAC_CONFIG_FULL_DUPLEX;
-- 
2.30.2


