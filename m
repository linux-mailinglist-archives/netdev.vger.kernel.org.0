Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100F32631C6
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbgIIQ0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730598AbgIIQZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:25:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1CEC0613ED
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ATlz+OS+8eqk12Yw6kBHmkSIN4Gg6FnxaYGfskajSxk=; b=y86ePh0gkZklAvD27x/d+QMl0g
        dvFSgWkloss5brgPp+3z/N59zhpDKIevtoKm52R9295rScWO3LaiAjjJPZ5kDhwIF1L1jplN3/i3r
        yx8KRoVnm8W/En7I5MLSd7n6bjRjoOAFE+3nvPkmfTnVHcsg1YO/WpEBSxgG3x6CT6+z8T0v6/Z9r
        w3w2o1WWXWhdPslbz3w8jpPF6RqfMCavt6ctz0OY/XVXxWK03UJE5vGK6tg+mJouTjZBlYq5wOUX9
        xLl/0dLxNfZPMsQw7qyIACRdrFiZTce1whkZ9SmGRtotkF2dhfAT/JuA8e3G45WXiEGemz6Vwdg3+
        5R1/uv/w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46306 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kG2ui-00051r-Oo; Wed, 09 Sep 2020 17:25:40 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kG2ui-0002yh-IN; Wed, 09 Sep 2020 17:25:40 +0100
In-Reply-To: <20200909162501.GB1551@shell.armlinux.org.uk>
References: <20200909162501.GB1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 2/6] net: mvpp2: rename mis-named "link status"
 interrupt
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kG2ui-0002yh-IN@rmk-PC.armlinux.org.uk>
Date:   Wed, 09 Sep 2020 17:25:40 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The link interrupt is used for way more than just the link status; it
comes from a collection of units to do with the port. The Marvell
documentation describes the interrupt as "GOP port X interrupt".

Since we are adding PTP support, and the PTP interrupt uses this,
rename it to be more inline with the documentation.

This interrupt is also mis-named in the DT binding, but we leave that
alone.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 35 ++++++++++---------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index ecb5f4616a36..a2f787c83756 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -915,7 +915,7 @@ struct mvpp2_port {
 	 */
 	int gop_id;
 
-	int link_irq;
+	int port_irq;
 
 	struct mvpp2 *priv;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index bb7284306ee4..d85ba26ba886 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3036,7 +3036,7 @@ static void mvpp2_isr_handle_gmac_internal(struct mvpp2_port *port)
 }
 
 /* Per-port interrupt for link status changes */
-static irqreturn_t mvpp2_link_status_isr(int irq, void *dev_id)
+static irqreturn_t mvpp2_port_isr(int irq, void *dev_id)
 {
 	struct mvpp2_port *port = (struct mvpp2_port *)dev_id;
 
@@ -4230,12 +4230,13 @@ static int mvpp2_open(struct net_device *dev)
 		valid = true;
 	}
 
-	if (priv->hw_version == MVPP22 && port->link_irq) {
-		err = request_irq(port->link_irq, mvpp2_link_status_isr, 0,
+	if (priv->hw_version == MVPP22 && port->port_irq) {
+		err = request_irq(port->port_irq, mvpp2_port_isr, 0,
 				  dev->name, port);
 		if (err) {
-			netdev_err(port->dev, "cannot request link IRQ %d\n",
-				   port->link_irq);
+			netdev_err(port->dev,
+				   "cannot request port link/ptp IRQ %d\n",
+				   port->port_irq);
 			goto err_free_irq;
 		}
 
@@ -4246,7 +4247,7 @@ static int mvpp2_open(struct net_device *dev)
 
 		valid = true;
 	} else {
-		port->link_irq = 0;
+		port->port_irq = 0;
 	}
 
 	if (!valid) {
@@ -4290,8 +4291,8 @@ static int mvpp2_stop(struct net_device *dev)
 
 	if (port->phylink)
 		phylink_disconnect_phy(port->phylink);
-	if (port->link_irq)
-		free_irq(port->link_irq, port);
+	if (port->port_irq)
+		free_irq(port->port_irq, port);
 
 	mvpp2_irqs_deinit(port);
 	if (!port->has_tx_irqs) {
@@ -6056,16 +6057,16 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		goto err_free_netdev;
 
 	if (port_node)
-		port->link_irq = of_irq_get_byname(port_node, "link");
+		port->port_irq = of_irq_get_byname(port_node, "link");
 	else
-		port->link_irq = fwnode_irq_get(port_fwnode, port->nqvecs + 1);
-	if (port->link_irq == -EPROBE_DEFER) {
+		port->port_irq = fwnode_irq_get(port_fwnode, port->nqvecs + 1);
+	if (port->port_irq == -EPROBE_DEFER) {
 		err = -EPROBE_DEFER;
 		goto err_deinit_qvecs;
 	}
-	if (port->link_irq <= 0)
+	if (port->port_irq <= 0)
 		/* the link irq is optional */
-		port->link_irq = 0;
+		port->port_irq = 0;
 
 	if (fwnode_property_read_bool(port_fwnode, "marvell,loopback"))
 		port->flags |= MVPP2_F_LOOPBACK;
@@ -6229,8 +6230,8 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 err_free_stats:
 	free_percpu(port->stats);
 err_free_irq:
-	if (port->link_irq)
-		irq_dispose_mapping(port->link_irq);
+	if (port->port_irq)
+		irq_dispose_mapping(port->port_irq);
 err_deinit_qvecs:
 	mvpp2_queue_vectors_deinit(port);
 err_free_netdev:
@@ -6251,8 +6252,8 @@ static void mvpp2_port_remove(struct mvpp2_port *port)
 	for (i = 0; i < port->ntxqs; i++)
 		free_percpu(port->txqs[i]->pcpu);
 	mvpp2_queue_vectors_deinit(port);
-	if (port->link_irq)
-		irq_dispose_mapping(port->link_irq);
+	if (port->port_irq)
+		irq_dispose_mapping(port->port_irq);
 	free_netdev(port->dev);
 }
 
-- 
2.20.1

