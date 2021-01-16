Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187EB2F8A2E
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbhAPBCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbhAPBB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:57 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCC1C06179E
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:47 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id n26so15810928eju.6
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=200TmBKtTfL2h/FLWqy8HgcNhiwZAAkB1z4+Zrk5ZnQ=;
        b=aDhZw33Hf7wzVmjrpqR9vV0o/2UprQjRdkQKm4I085KIVF2D4mBsKpOmyGoz0Py0Mo
         2WFiHMBUvtx8gNrjeY9Uo9yrTz6kWvW1NoYw2BO1drcyG4zh94tZktj9qKF8EtZE4WWu
         b+JHx9bjnYwFaAkEqCSeqxPImaZE8n+EVdviHlmAklZyKoOiXOrrw3GIBy+SqhNz38Pz
         50BY/qhGYSpcLInj8Bujt9RTdWArNkmrkqg1nz+f9rod6ftGY8ZAKL1VlWQpuQNs8ahK
         zsAMUetHUyxvHF81EwaXfU9JqFQYCvFanMlqrRSmiwaV5/Qey2Z7Shq2t213mKv1F7zT
         RyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=200TmBKtTfL2h/FLWqy8HgcNhiwZAAkB1z4+Zrk5ZnQ=;
        b=uJRvTP/sLt+LDb9nhowXQN86Xtedl7VViF3WN5JYQd4PsNQezK4GiFVKJHDU2Sl8yZ
         IJ8YdFT2xL9iomqvspY0xlB3D3CL8vMir4jUfMvoyyOdYNTXd+lXs6rFPuhlg+RaRRm4
         S5pEMkWA0BlAZ6cBwAyWDyUBHa8gPiQt2Lj1Mpo3sfiJWC3Ue1//OmdZL0pNfDQ+LumR
         uHNAI+Z8pWAozJVWsLKEftW+JVHcrS4I+FwQvvBsQKI/PQsmagOiALZWKi7LdoX9I+yW
         sAvXllMhd536KV39uizxeR+9XLgxY2A2PEyPPE7acsFkz78Nj74b5qHrfH5eLpgB8UWt
         DOEw==
X-Gm-Message-State: AOAM530umKQOfMgcLq8MaCwtQHtosLJJzE+YgXRc9bggyTDkeGYMwI1J
        vZTxzzUrVWQ352+BNTR8M+I=
X-Google-Smtp-Source: ABdhPJy3FfGIWbZZdvy5YnRMRnJYnVLszV3wkEaMcoZBTBsdoeiHcJ2/Tr6dZtMPwYmV0vQW6vmznw==
X-Received: by 2002:a17:906:9497:: with SMTP id t23mr7138398ejx.523.1610758845816;
        Fri, 15 Jan 2021 17:00:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:45 -0800 (PST)
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
Subject: [PATCH v2 net-next 10/14] net: mscc: ocelot: set up logical port IDs centrally
Date:   Sat, 16 Jan 2021 02:59:39 +0200
Message-Id: <20210116005943.219479-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The setup of logical port IDs is done in two places: from the inconclusively
named ocelot_setup_lag and from ocelot_port_lag_leave, a function that
also calls ocelot_setup_lag (which apparently does an incomplete setup
of the LAG).

To improve this situation, we can rename ocelot_setup_lag into
ocelot_setup_logical_port_ids, and drop the "lag" argument. It will now
set up the logical port IDs of all switch ports, which may be just
slightly more inefficient but more maintainable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 47 ++++++++++++++++++------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8ab74325eb78..1bcf68bd1bff 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1260,20 +1260,36 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 	}
 }
 
-static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
+/* When offloading a bonding interface, the switch ports configured under the
+ * same bond must have the same logical port ID, equal to the physical port ID
+ * of the lowest numbered physical port in that bond. Otherwise, in standalone/
+ * bridged mode, each port has a logical port ID equal to its physical port ID.
+ */
+static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 {
-	unsigned long bond_mask = ocelot->lags[lag];
-	unsigned int p;
+	int port;
 
-	for_each_set_bit(p, &bond_mask, ocelot->num_phys_ports) {
-		u32 port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, p);
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct net_device *bond;
+
+		if (!ocelot_port)
+			continue;
 
-		port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
+		bond = ocelot_port->bond;
+		if (bond) {
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
 
-		/* Use lag port as logical port for port i */
-		ocelot_write_gix(ocelot, port_cfg |
-				 ANA_PORT_PORT_CFG_PORTID_VAL(lag),
-				 ANA_PORT_PORT_CFG, p);
+			ocelot_rmw_gix(ocelot,
+				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
+				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
+				       ANA_PORT_PORT_CFG, port);
+		} else {
+			ocelot_rmw_gix(ocelot,
+				       ANA_PORT_PORT_CFG_PORTID_VAL(port),
+				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
+				       ANA_PORT_PORT_CFG, port);
+		}
 	}
 }
 
@@ -1305,7 +1321,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 		ocelot->lags[lag] |= BIT(port);
 	}
 
-	ocelot_setup_lag(ocelot, lag);
+	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
@@ -1316,7 +1332,6 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
-	u32 port_cfg;
 	int i;
 
 	ocelot->ports[port]->bond = NULL;
@@ -1333,15 +1348,9 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 
 		ocelot->lags[n] = ocelot->lags[port];
 		ocelot->lags[port] = 0;
-
-		ocelot_setup_lag(ocelot, n);
 	}
 
-	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
-	port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
-	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
-			 ANA_PORT_PORT_CFG, port);
-
+	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
-- 
2.25.1

