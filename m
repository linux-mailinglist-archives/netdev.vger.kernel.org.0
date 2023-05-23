Return-Path: <netdev+bounces-4742-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3EDD70E13A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEDB01C20846
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A1D200C0;
	Tue, 23 May 2023 15:55:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0941F92A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:55:53 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBE78E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=FVOoKlcE9wbWI4c+QH+jePyQLl9O41VBGHtZioJCPsQ=; b=wizhLKf3/3+tPK6Z1OYi84b2os
	DQSOPSSfBjUj8bwXwofOD7sa6gRLE8yxSvG+KKgp3Nc8Rs7nXXzUrOJljvjC2vBFkofPnNCkor97E
	LAbSdHkM6rsMeXWQut/kLsSl3aSLDtu1vb0Xk4G0Afsx/O8Smwy4vMEv2NnWpjkAvdWQzdWvNyWly
	sgAsP/87ADszKiRMgusL76iQaihboqkDGtdc1iKexFRLFDhrlxZNzl1eYRwyBvcoHCOHYhqc7AuIE
	NyYSAk+WglhO6x9nPr8LygscAE5PSFG2deJlQtT8BNcRvBUwEFMuh7HQZPOc5QbGjQBJ6IX8XtUzV
	HydRRHGg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51716 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1UMU-0000lT-LD; Tue, 23 May 2023 16:55:46 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1UMT-007FTJ-Ov; Tue, 23 May 2023 16:55:45 +0100
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
Subject: [PATCH RFC net-next 8/9] net: lan966x: switch PCS driver to use
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
Message-Id: <E1q1UMT-007FTJ-Ov@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 16:55:45 +0100
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
 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
index c5f9803e6e63..29bbd642cec8 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
@@ -103,12 +103,16 @@ static int lan966x_pcs_config(struct phylink_pcs *pcs,
 {
 	struct lan966x_port *port = lan966x_pcs_to_port(pcs);
 	struct lan966x_port_config config;
+	unsigned int neg_mode;
 	int ret;
 
+	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
+
 	config = port->config;
 	config.portmode = interface;
-	config.inband = phylink_autoneg_inband(mode);
-	config.autoneg = phylink_test(advertising, Autoneg);
+	config.inband = neg_mode == PHYLINK_PCS_NEG_INBAND_DISABLED ||
+			neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED;
+	config.autoneg = neg_mode == PHYLINK_PCS_NEG_INBAND_ENABLED;
 	config.advertising = advertising;
 
 	ret = lan966x_port_pcs_set(port, &config);
-- 
2.30.2


