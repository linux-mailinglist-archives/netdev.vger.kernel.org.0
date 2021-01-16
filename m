Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8AC2F8A33
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbhAPBCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728560AbhAPBB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:56 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1A7C06179B
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:44 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id w1so15797689ejf.11
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UX/lJ4lr146a+hMYkf2pbnGPcIK0sUkdje3PPIr+qcA=;
        b=cYb/EfEgO6ryrwcnyjyUFDaRc0L6r8PrkXgNxMQzQHhPqu/AgF94sjzG0sXIcP3KaF
         04LQxA8wMpwulqKJ0zIZ3sdNQ+18rSqrFm3d+HsJyEw5SlJMoINZtYvseOoZ79WX+zdl
         wE3VthpEB7xtzY2ArDsCIhB+TvOp+y9HXKf/0/brFW9ut/3OZLliusUPVxZgnPCcu3U3
         8FU64ytN5pZQnjpAP2W+ikQZCGmDtHhwOXKReMMRYOOvfLEushm5Ur44L9jkQeoGUi49
         U0zefAHQSQgg5csdLZp8tL1zXkaE78m7mSSNpKMy6Zo5tuWicXnCuLJZdgGZtRuUfTHy
         19ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UX/lJ4lr146a+hMYkf2pbnGPcIK0sUkdje3PPIr+qcA=;
        b=mv5DUZdqOYXqv74EB8Apf/DpwmAIj37DfSmdKi0AhHAyrhiqUSFypPU9moZG9p8yaP
         iI9wCjtEwDvro9oNO16Sdk78XkNLcv0IBCweIFoSjQ8MvsXrDTrBRyBq9/npOylT54Ya
         4gfBsOoZnNfx1XW4qTZDeKpLV1ejHB+15GYJMuVBvEfn/tkQh6DWq/0+XhJc9/3F6b3H
         /rmjPnd7gIiRAEpqRaggzknxuNHOE0RXmxjxDxSRQ72SHtmgRzbyQGKYxAXouHieBBZS
         I42y9B6BBfYCdfg2XIJK7xFMbLhqB6UxEGWOHRfkLXaZgrMqBlLvqE35fF/MWVeHom4D
         TZYg==
X-Gm-Message-State: AOAM531pYzwMXZ108sh/bhpf3DoeBzOuGGGlMnpjTuJK59BMlSlw4o4Q
        xtKXXA0mE418fNQ/jitzij0=
X-Google-Smtp-Source: ABdhPJyY+p+f9ZB44P4HfoMepr8GlmFs8I4v5//xoK1hj4LvjYYL3k1fxaqj1qGLOBJeXfGYJB5cbg==
X-Received: by 2002:a17:906:748:: with SMTP id z8mr6049077ejb.233.1610758843274;
        Fri, 15 Jan 2021 17:00:43 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:42 -0800 (PST)
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
Subject: [PATCH v2 net-next 08/14] net: mscc: ocelot: use "lag" variable name in ocelot_bridge_stp_state_set
Date:   Sat, 16 Jan 2021 02:59:37 +0200
Message-Id: <20210116005943.219479-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In anticipation of further simplification, make it more clear what we're
iterating over.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ce52bf892f9b..915cf81f602a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -897,7 +897,7 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	u32 port_cfg;
-	int p, i;
+	int p;
 
 	if (!(BIT(port) & ocelot->bridge_mask))
 		return;
@@ -921,14 +921,17 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
 
 	/* Apply FWD mask. The loop is needed to add/remove the current port as
-	 * a source for the other ports.
+	 * a source for the other ports. If the source port is in a bond, then
+	 * all the other ports from that bond need to be removed from this
+	 * source port's forwarding mask.
 	 */
 	for (p = 0; p < ocelot->num_phys_ports; p++) {
 		if (ocelot->bridge_fwd_mask & BIT(p)) {
 			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
+			int lag;
 
-			for (i = 0; i < ocelot->num_phys_ports; i++) {
-				unsigned long bond_mask = ocelot->lags[i];
+			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
+				unsigned long bond_mask = ocelot->lags[lag];
 
 				if (!bond_mask)
 					continue;
-- 
2.25.1

