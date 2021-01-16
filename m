Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61A22F8A32
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbhAPBCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728604AbhAPBB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:56 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC425C06179C
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:45 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w1so15797756ejf.11
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=38njsxJ3FWx1u0iWIDZPp+d4mrwHS6vkGES4CWjer7Q=;
        b=uzVLSUH18bF0rOl2XaB+/sPysgPXDwVNk/jpbvNAU0ST0tqgxUxHEJBgWX8cWFs57g
         Ig+OFuBWQ7ao7K/NXXcnX9t+wJOA6DHN338wk/yWQqW0AG+N/EzNnNRAxYwSKv92fRq0
         qJXwkLpJVD7U2twM5pMVuzUwplQ3CrZ58x6ohR7GqhD1QndXjt8RRJp+WfrEhrM/8DPc
         ARPO/bBB/cUld2ZHuqTTa+32KJTyx7ZD0ND4PdOq8UUGgP1EtLrDjVXYtYuX+e6NPcXq
         piwuCfhVrKAYLWn/ZzVLSKu7r5DT0gC0xFl9NP/jgqc8KhUcYokHAv933ep2V8T+NR+f
         2rbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=38njsxJ3FWx1u0iWIDZPp+d4mrwHS6vkGES4CWjer7Q=;
        b=l9VY2EVgHkN2ajwXvOFNeK/zOG68j+eecWYb24nrsQDSybm1b5Q949vcco+u9JxxAT
         FOlJagHDhH2gr9xw91LzFByUx3qzCUtl0UPzqxSABo9h44P3xi87Zv9+sSTGwEY3d7O0
         BXAmzjuaqL4NI4g+cv8QGYI4xCxY85idQ9zQ8PgeJg6dkbKEtA3LoWFfLvXj/6vQfpQd
         kWf7Qzeb4j8B6cCRy7Qhwe4Er8O99DC3+oTZ8/5zjFcC6ycLQxHC3h4Mq7WJI3davD2j
         S5QiqmtEBqwtqkwnvDdloQqZwMPExkfH2uewMN4CHbadK3/pHywGSDIp1yxmcOYBxFXO
         ZABA==
X-Gm-Message-State: AOAM530VcGDI8cFoOgLACIpSFVuqdaYZw/RFWxkNmlHJB49W0aaJcnVF
        /frhTvHJXFQTT94z6QOtMFQ=
X-Google-Smtp-Source: ABdhPJwHempbVMhHwlgPPi96IQr3G42XV5U/8h9slhvJ9m/PQGK1jWOGe7fYnQZoPAXtthg2vqzjjg==
X-Received: by 2002:a17:906:c09:: with SMTP id s9mr10711936ejf.539.1610758844565;
        Fri, 15 Jan 2021 17:00:44 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 net-next 09/14] net: mscc: ocelot: reapply bridge forwarding mask on bonding join/leave
Date:   Sat, 16 Jan 2021 02:59:38 +0200
Message-Id: <20210116005943.219479-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Applying the bridge forwarding mask currently is done only on the STP
state changes for any port. But it depends on both STP state changes,
and bonding interface state changes. Export the bit that recalculates
the forwarding mask so that it could be reused, and call it when a port
starts and stops offloading a bonding interface.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v2:
Found a better strategic placement for the ocelot_apply_bridge_fwd_mask
function (i.e. just code ordering).

 drivers/net/ethernet/mscc/ocelot.c | 68 +++++++++++++++++-------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 915cf81f602a..8ab74325eb78 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -894,40 +894,18 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 	return bond_mask;
 }
 
-void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
+static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 {
-	u32 port_cfg;
-	int p;
-
-	if (!(BIT(port) & ocelot->bridge_mask))
-		return;
-
-	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
-
-	switch (state) {
-	case BR_STATE_FORWARDING:
-		ocelot->bridge_fwd_mask |= BIT(port);
-		fallthrough;
-	case BR_STATE_LEARNING:
-		port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
-		break;
-
-	default:
-		port_cfg &= ~ANA_PORT_PORT_CFG_LEARN_ENA;
-		ocelot->bridge_fwd_mask &= ~BIT(port);
-		break;
-	}
-
-	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
+	int port;
 
 	/* Apply FWD mask. The loop is needed to add/remove the current port as
 	 * a source for the other ports. If the source port is in a bond, then
 	 * all the other ports from that bond need to be removed from this
 	 * source port's forwarding mask.
 	 */
-	for (p = 0; p < ocelot->num_phys_ports; p++) {
-		if (ocelot->bridge_fwd_mask & BIT(p)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (ocelot->bridge_fwd_mask & BIT(port)) {
+			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
 			int lag;
 
 			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
@@ -936,20 +914,48 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 				if (!bond_mask)
 					continue;
 
-				if (bond_mask & BIT(p)) {
+				if (bond_mask & BIT(port)) {
 					mask &= ~bond_mask;
 					break;
 				}
 			}
 
 			ocelot_write_rix(ocelot, mask,
-					 ANA_PGID_PGID, PGID_SRC + p);
+					 ANA_PGID_PGID, PGID_SRC + port);
 		} else {
 			ocelot_write_rix(ocelot, 0,
-					 ANA_PGID_PGID, PGID_SRC + p);
+					 ANA_PGID_PGID, PGID_SRC + port);
 		}
 	}
 }
+
+void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
+{
+	u32 port_cfg;
+
+	if (!(BIT(port) & ocelot->bridge_mask))
+		return;
+
+	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
+
+	switch (state) {
+	case BR_STATE_FORWARDING:
+		ocelot->bridge_fwd_mask |= BIT(port);
+		fallthrough;
+	case BR_STATE_LEARNING:
+		port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
+		break;
+
+	default:
+		port_cfg &= ~ANA_PORT_PORT_CFG_LEARN_ENA;
+		ocelot->bridge_fwd_mask &= ~BIT(port);
+		break;
+	}
+
+	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
+
+	ocelot_apply_bridge_fwd_mask(ocelot);
+}
 EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
 
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs)
@@ -1300,6 +1306,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 	}
 
 	ocelot_setup_lag(ocelot, lag);
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
 	return 0;
@@ -1335,6 +1342,7 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
 			 ANA_PORT_PORT_CFG, port);
 
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
-- 
2.25.1

