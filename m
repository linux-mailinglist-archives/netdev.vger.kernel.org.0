Return-Path: <netdev+bounces-4741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D139070E133
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BCD4281405
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFF2200BF;
	Tue, 23 May 2023 15:55:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628FE1F92A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:55:48 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0774491
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nAKHJkTbZDzNX1B/hzv5a6k8k/EBeltxSBdWV5zZtJk=; b=j1NEbFSBxJKiqxyUzC2eun3Bo3
	xzoKeuaiWYvvd8CDzPnhunoNYdhmyNCHfsRzbvkIgL1/LaxlSm1ZmrNNRBJsBdK2p0kAEDcqEE9nh
	9xqGPIQPlQlcOI5o/pQyrpU5UD1X/qZGRJ8e6SyieSzgrlXhcl4xO+sRHZJ7tUw5ozGpw1AC528H1
	CAm8pUbPwKTQlGuP/eZ+/k9u9Fq+rMIsWk9JEm+ENU5t8uMHr90fwGwIy5afz4JNVFNUK1omGSjLY
	QI/I1A92Zgcmk3SGY/nQRoulSrr0pJAR/BZgmBHpAeFRx+lbl+/iUFRW0zw2UoBPfe4KG2w4iXEep
	xCI9z3ag==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46878 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1UMP-0000ky-9E; Tue, 23 May 2023 16:55:41 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1UMO-007FTD-Kv; Tue, 23 May 2023 16:55:40 +0100
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
Subject: [PATCH RFC net-next 7/9] net: prestera: switch PCS driver to use
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
Message-Id: <E1q1UMO-007FTD-Kv@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 16:55:40 +0100
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
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 9d504142e51a..2a26f96fbed2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -308,38 +308,36 @@ static int prestera_pcs_config(struct phylink_pcs *pcs,
 {
 	struct prestera_port *port = prestera_pcs_to_port(pcs);
 	struct prestera_port_mac_config cfg_mac;
+	unsigned int neg_mode;
 	int err;
 
+	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
+
 	err = prestera_port_cfg_mac_read(port, &cfg_mac);
 	if (err)
 		return err;
 
 	cfg_mac.admin = true;
 	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
+	cfg_mac.inband = neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED;
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_10GBASER:
 		cfg_mac.speed = SPEED_10000;
-		cfg_mac.inband = 0;
 		cfg_mac.mode = PRESTERA_MAC_MODE_SR_LR;
 		break;
 	case PHY_INTERFACE_MODE_2500BASEX:
 		cfg_mac.speed = SPEED_2500;
 		cfg_mac.duplex = DUPLEX_FULL;
-		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-					  advertising);
 		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
-		cfg_mac.inband = 1;
 		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
 		break;
 	case PHY_INTERFACE_MODE_1000BASEX:
 	default:
 		cfg_mac.speed = SPEED_1000;
 		cfg_mac.duplex = DUPLEX_FULL;
-		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-					  advertising);
 		cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
 		break;
 	}
-- 
2.30.2


