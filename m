Return-Path: <netdev+bounces-4738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC68E70E121
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8905E1C20D81
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E79E20681;
	Tue, 23 May 2023 15:55:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424E61F92A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:55:33 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D617F8E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gs0gqFaUOBGvlNDsIWPf3JDZ4gaOrGJ3l+VkU1960CI=; b=rq0TiXpqq451igMCcsVhR4rYin
	SZ5kshBYULb6Z68EZqOd0pi64XemWDeI12IT0bbmIXzrskmw/OUTYMBClBU0c5gKxSqHGSkSUvUq4
	SC4UV1M1o4W3SyGmhjkUsZwMdHMiPDRiLLBuxqJ8hb9kHhTrcW5/9Tk/LJfpyHDUOMaibPiwbV1dp
	bYS2dU0c90mLxJ24l7m0WQ9D5vRUogRfD0nXbP8DRz9twvRFkb0lwvOHJF4XNg4QEm5wr5TcHJGa1
	hUKCt9Xk35Jmly+GAS0QQs7/+9onot6A7Q6CfAZ07hymP72PcO34gFA6Vx7l1f4vh5kqOck3VIB7c
	avtpcVeQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48976 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1UM9-0000jW-Tf; Tue, 23 May 2023 16:55:25 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1UM9-007FSu-A0; Tue, 23 May 2023 16:55:25 +0100
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
Subject: [PATCH RFC net-next 4/9] net: qca8k: switch PCS driver to use
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
Message-Id: <E1q1UM9-007FSu-A0@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 16:55:25 +0100
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
 drivers/net/dsa/qca/qca8k-8xxx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 6d5ac7588a69..acede9f3c253 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1500,6 +1500,7 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 {
 	struct qca8k_priv *priv = pcs_to_qca8k_pcs(pcs)->priv;
 	int cpu_port_index, ret, port;
+	unsigned int neg_mode;
 	u32 reg, val;
 
 	port = pcs_to_qca8k_pcs(pcs)->port;
@@ -1519,15 +1520,15 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		return -EINVAL;
 	}
 
+	neg_mode = phylink_pcs_neg_mode(mode, interface, advertising);
+
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
-- 
2.30.2


