Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447422B8711
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgKRWEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgKRWEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:04:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77002C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:04:14 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYg-00058y-Dv; Wed, 18 Nov 2020 23:04:10 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYe-0000yr-Cy; Wed, 18 Nov 2020 23:04:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH 07/11] net: dsa: microchip: remove superfluous num_ports asignment
Date:   Wed, 18 Nov 2020 23:03:53 +0100
Message-Id: <20201118220357.22292-8-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable num_ports is already assigned in the init function.
This patch removes the extra assignment of the variable.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 2 --
 drivers/net/dsa/microchip/ksz9477.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 7114902495a0ebb..17dc720df2340b0 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -992,8 +992,6 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 	u8 remote;
 	int i;
 
-	ds->num_ports = dev->port_cnt + 1;
-
 	/* Switch marks the maximum frame with extra byte as oversize. */
 	ksz_cfg(dev, REG_SW_CTRL_2, SW_LEGAL_PACKET_DISABLE, true);
 	ksz_cfg(dev, S_TAIL_TAG_CTRL, SW_TAIL_TAG_ENABLE, true);
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index abfd3802bb51706..2119965da10ae1e 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1267,8 +1267,6 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 	struct ksz_port *p;
 	int i;
 
-	ds->num_ports = dev->port_cnt;
-
 	for (i = 0; i < dev->port_cnt; i++) {
 		if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
 			phy_interface_t interface;
-- 
2.29.2

