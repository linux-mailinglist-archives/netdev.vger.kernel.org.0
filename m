Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4582FDFCE
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393337AbhAUCww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436892AbhAUCoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:44:54 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EC3C0613D6
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:33 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ke15so475373ejc.12
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ns/K/2q0TW43nN/ICrcdifCMlirKCVGCHfsteZ36RJ4=;
        b=ZAKXqeHdl86cAgFP5+4P4ctgvoTaulsIzOlQ5gq6mK3VUtRqwR9wDZOZbHSkdosMIS
         KcfY9mwKFyg/2/NLe7Se/JjNdjPALLR0hzIxNWdJwHCamr6fMfpf5pcbtwVdxjp1Lqsb
         fSg7tQ/K8h86ng8EVIgI30f7VPckVpQPZr/9CRSquJ+YQvTBWouh7bkxk/0Li7oACuiW
         xIC4d3v0shZcJzOEeWJcjYPr6YQmsszfmvaQNI12YHEyNovvQHeh06VN6evNJyiwqrRw
         jk5QH4psbWi7HwR/FaxTmrpvlxws6hOfz2ZfGkOoRC/5R35MO6Yio0s6qGnXaeurQn5Z
         putg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ns/K/2q0TW43nN/ICrcdifCMlirKCVGCHfsteZ36RJ4=;
        b=nWMyjA96+2cw4DHXyTbUrtc/YfNny4r8TD/BSg/f3ZDnWeJ2HqfQoum15AYDhvj0m8
         EeeddeUTnauokEVfupn2+MPY85ht+jvCGLiR3QGUM0FiZVOBhX+v0906yEQErArWMk9U
         10aXrY4DIlGwSyyX7cEBRl4lZUgMn2z2BqnlY1sYFnJfMEyxbPhAgnFkYbIWbrjHVzao
         mLhcE4/V3CvLKTRoRQsUuHQDpr7hOice8AuaYJlpy/0RRsRF6xrmzfjspmLL+ogkozwk
         /hMU3pnN90pZuYN58IFHql0YUM9GO/4nqnFW8x+GQweU/+cjVBkk72PZ+SD+OFxiU+Vd
         IRGQ==
X-Gm-Message-State: AOAM5311U2rOrUZWRxd1qpXTmwPXQ21bQBZzE0+FyzXCNVpw7KzHGWXD
        pkoWW2LOJ95XqpR+rKYsapI=
X-Google-Smtp-Source: ABdhPJwPQTguzzadwakzBg/Qhhf5Zqh9KamCGJiDvNXe/kv6hgtwzcTXbum/dqlJ3jw1ECsLPy5CKQ==
X-Received: by 2002:a17:906:7f98:: with SMTP id f24mr7724835ejr.75.1611196592178;
        Wed, 20 Jan 2021 18:36:32 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k22sm2025787edv.33.2021.01.20.18.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 18:36:31 -0800 (PST)
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
Subject: [PATCH v5 net-next 04/10] net: mscc: ocelot: reapply bridge forwarding mask on bonding join/leave
Date:   Thu, 21 Jan 2021 04:36:10 +0200
Message-Id: <20210121023616.1696021-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121023616.1696021-1-olteanv@gmail.com>
References: <20210121023616.1696021-1-olteanv@gmail.com>
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
---
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
index a560d6be2a44..42d92a5b475d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -876,10 +876,42 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
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
@@ -902,32 +934,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 
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
 
@@ -1284,6 +1291,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 	}
 
 	ocelot_setup_lag(ocelot, lag);
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
 	return 0;
@@ -1317,6 +1325,7 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
 			 ANA_PORT_PORT_CFG, port);
 
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
-- 
2.25.1

