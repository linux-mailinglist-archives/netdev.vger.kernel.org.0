Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC55E2FEFC0
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbhAUQEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731852AbhAUQDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:03:10 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4D9C061786
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:30 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id g3so3317433ejb.6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 08:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ohla8RW9X5hOAtkri6reXxURsKt2qhYCgBML7GU10yo=;
        b=rRdNJEO3rtDOCcFALhoYLPMXZSClmcIPkiPwU6n1mteT4iDTWR38YBhrrH6tp9KCED
         uWWVs1gZcomAEb4f3Ra+yARgqCL0oDxiRaKLUEWdhuvl6uaI+hqbbLTVMYcNqvBvr4Si
         B0nQ8B31mfs0lE5rjhWbGWbR6Mpo6TDFwC5zrwXOXwfxbORNOTKOg3P0XmBrXHA4qJJ0
         CVtCfAB7AdNEKERmZd/at3sT/6QeQRt9Uejfr9IZsMszlLSUHTB1ZnrkI0PZs4N+z2w/
         NaUtZoziiVlsps8OU4FjJXDvEcUuNjmhYrH5UniDTTIAFw0XPzbtlqVMJsNxYChoU+yU
         jpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ohla8RW9X5hOAtkri6reXxURsKt2qhYCgBML7GU10yo=;
        b=ZfgJOHWp1y116PzHFDL0aYtSwkp/EMiwgnVk0TJ1fs+lGxghZfMQjZ0P37Voiqyeau
         k9HYMK7FThZ8lVXcZIA/0ZblpQepzwGYM2wRj47eHHNWRRl8EaYXLAfu2I1z7Wyppccs
         hXI+8nQKqJt0bhT95EB2+i3rb/ilipG/E7ptJyHoobNJ/z1dmDQYWmLPEqZCZf+zJUNR
         mTCwwPBqkgISA9hCY0/99NHdPaPqh2ZvqIppOFXhNN6Zu9aoyI046V/oixy4Fpi0JdQK
         Udw5g1/sEwDYJyhaJqPuL1IbGLfUhyLyz8v+qg/26Ze987nUudPXI8KtVQCczAZik+gm
         ltdQ==
X-Gm-Message-State: AOAM533Fx4FhF8D+aGn9+UlqQ7xhRuGzG1QxbZjZPE+n09H5MQQXj7OP
        OuEVpbgeOHVxS9NhMc6CgGw=
X-Google-Smtp-Source: ABdhPJxgtPtDONUT1EwtmWF1RismmczmjFaKl8P5jGOuNuotZ/LmLDlyPonNJqaUks7h7Gayx6tDBw==
X-Received: by 2002:a17:907:2851:: with SMTP id el17mr78790ejc.405.1611244948963;
        Thu, 21 Jan 2021 08:02:28 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id zk10sm2419973ejb.10.2021.01.21.08.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 08:02:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 04/10] net: mscc: ocelot: reapply bridge forwarding mask on bonding join/leave
Date:   Thu, 21 Jan 2021 18:01:25 +0200
Message-Id: <20210121160131.2364236-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121160131.2364236-1-olteanv@gmail.com>
References: <20210121160131.2364236-1-olteanv@gmail.com>
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

Now that the logic is split into a separate function, we can rename "p"
into "port", since the "port" variable was already taken in
ocelot_bridge_stp_state_set. Also, we can rename "i" into "lag", to make
it more clear what is it that we're iterating through.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v6:
None.
Jakub, just FYI: ./scripts/get_maintainer.pl parses the "bpf" string
from the patchwork instance name, and wants me to CC the BPF maintainers
because of that.

Changes in v5:
None.

Changes in v4:
Patch is carried over from the "LAG offload for Ocelot DSA switches"
series:
https://patchwork.kernel.org/project/netdevbpf/patch/20210116005943.219479-10-olteanv@gmail.com/
I need it here because it refactors ocelot_apply_bridge_fwd_mask into a
separate function which I also need to call from felix now.

 drivers/net/ethernet/mscc/ocelot.c | 63 +++++++++++++++++-------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5b2c0cea49ea..7352f58f9bc2 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -889,10 +889,42 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
+static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
+{
+	int port;
+
+	/* Apply FWD mask. The loop is needed to add/remove the current port as
+	 * a source for the other ports.
+	 */
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (ocelot->bridge_fwd_mask & BIT(port)) {
+			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
+			int lag;
+
+			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
+				unsigned long bond_mask = ocelot->lags[lag];
+
+				if (!bond_mask)
+					continue;
+
+				if (bond_mask & BIT(port)) {
+					mask &= ~bond_mask;
+					break;
+				}
+			}
+
+			ocelot_write_rix(ocelot, mask,
+					 ANA_PGID_PGID, PGID_SRC + port);
+		} else {
+			ocelot_write_rix(ocelot, 0,
+					 ANA_PGID_PGID, PGID_SRC + port);
+		}
+	}
+}
+
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	u32 port_cfg;
-	int p, i;
 
 	if (!(BIT(port) & ocelot->bridge_mask))
 		return;
@@ -915,32 +947,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 
 	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
 
-	/* Apply FWD mask. The loop is needed to add/remove the current port as
-	 * a source for the other ports.
-	 */
-	for (p = 0; p < ocelot->num_phys_ports; p++) {
-		if (ocelot->bridge_fwd_mask & BIT(p)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
-
-			for (i = 0; i < ocelot->num_phys_ports; i++) {
-				unsigned long bond_mask = ocelot->lags[i];
-
-				if (!bond_mask)
-					continue;
-
-				if (bond_mask & BIT(p)) {
-					mask &= ~bond_mask;
-					break;
-				}
-			}
-
-			ocelot_write_rix(ocelot, mask,
-					 ANA_PGID_PGID, PGID_SRC + p);
-		} else {
-			ocelot_write_rix(ocelot, 0,
-					 ANA_PGID_PGID, PGID_SRC + p);
-		}
-	}
+	ocelot_apply_bridge_fwd_mask(ocelot);
 }
 EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
 
@@ -1297,6 +1304,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 	}
 
 	ocelot_setup_lag(ocelot, lag);
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
 	return 0;
@@ -1330,6 +1338,7 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
 			 ANA_PORT_PORT_CFG, port);
 
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
-- 
2.25.1

