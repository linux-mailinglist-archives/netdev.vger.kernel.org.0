Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C712145EB
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 14:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGDMpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 08:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbgGDMpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 08:45:31 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298F0C08C5DE
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 05:45:31 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rk21so37253680ejb.2
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 05:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7lOYoNluu9DkW4lm9P3c1OqYLUyhbOun6I3w56FKIsE=;
        b=TLEwWhSGe+HAWixkVnETq7hbCyMlZX/d+E+l8IdxigE/4rx3aqcBTJtI4dCIFKj6s0
         xKeTdtkYLzuhpWdzf7diw9hKajdWdRNXz+OVZxr9Qjn1CidjvcJuguPIKwcQQsSVwocp
         8AkALmetPtuUuw+8/oqWTeLCMgDy875oGfFv+dSGggqVO8NMOr0J804bWYfucYz5Ysik
         1/Ld/MbY7U4U9bV9P2KLP5SbBI2XgSmm5QZu7drQ3muRYfKKdkGwi1+dipNyGSg+uE+5
         K9zXnhhNysogPkGFGfgG7hdsPwOWro6fkm960UN7Ofat8XOuMV2EeJ+PChAj/8w5/2/l
         iuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7lOYoNluu9DkW4lm9P3c1OqYLUyhbOun6I3w56FKIsE=;
        b=GiFKT5vA8V8JOe/OEOgSmGQY7ZoPk7ermxjoJN7zXF8oydHWvJpvbejtp0kGUqvuUs
         QhZ0QKtJNHt0nnrvk130otkHU9rjz0NCPpj2EqusnzXq/lWvjFSeDmfJJa40KeQwLHFJ
         fmhXauSVw884OUhi2Z7RgJ2gGGSmgLlPOT6UoYkCTrnGXUeHG+J7gtjLMqpJ4+VHg2do
         jkXCqKmjIYfDJt1eQQd0HBR62QzpenxHxRw1V8tMzYHep0w2Q2CkuLRgAm4Aa8BjI3cC
         EKDYMsQ3GY849UlktJiIohpcQbEGekmZCXD7ePz7zgu49UFCsw0WOX/ez+L3+Pr9IG3T
         yvHw==
X-Gm-Message-State: AOAM5335Q2iH70T6fcumyWg0hslomKxgAk1ouOl0IgwrmXPtbk98owIB
        erBqW4Ceq4Lpo3IfsWW9vUo2SyAG
X-Google-Smtp-Source: ABdhPJxXiHgZAznlr795wGUlgyl3o0nBig3Kjw9prFrI4M9xd5ZkkwCd0fihriID+hLqxAGiRROaGA==
X-Received: by 2002:a17:906:1e95:: with SMTP id e21mr37649071ejj.240.1593866729915;
        Sat, 04 Jul 2020 05:45:29 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id dm1sm12983851ejc.99.2020.07.04.05.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 05:45:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v2 net-next 3/6] net: dsa: felix: unconditionally configure MAC speed to 1000Mbps
Date:   Sat,  4 Jul 2020 15:45:04 +0300
Message-Id: <20200704124507.3336497-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200704124507.3336497-1-olteanv@gmail.com>
References: <20200704124507.3336497-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In VSC9959, the PCS is the one who performs rate adaptation (symbol
duplication) to the speed negotiated by the PHY. The MAC is unaware of
that and must remain configured for gigabit. If it is configured at
OCELOT_SPEED_10 or OCELOT_SPEED_100, it'll start transmitting PAUSE
frames out of control and never recover, _even if_ we then reconfigure
it at OCELOT_SPEED_1000 afterwards.

This patch fixes a bug that luckily did not have any functional impact.
We were writing 10, 100, 1000 etc into this 2-bit field in
DEV_CLOCK_CFG, but the hardware expects values in the range 0, 1, 2, 3.
So all speed values were getting truncated to 0, which is
OCELOT_SPEED_2500, and which also appears to be fine.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f54648dff0ec..4d819cc45bed 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -240,9 +240,14 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	u32 mac_fc_cfg;
 
 	/* Take port out of reset by clearing the MAC_TX_RST, MAC_RX_RST and
-	 * PORT_RST bits in CLOCK_CFG
+	 * PORT_RST bits in DEV_CLOCK_CFG. Note that the way this system is
+	 * integrated is that the MAC speed is fixed and it's the PCS who is
+	 * performing the rate adaptation, so we have to write "1000Mbps" into
+	 * the LINK_SPEED field of DEV_CLOCK_CFG (which is also its default
+	 * value).
 	 */
-	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(state->speed),
+	ocelot_port_writel(ocelot_port,
+			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
 			   DEV_CLOCK_CFG);
 
 	/* Flow control. Link speed is only used here to evaluate the time
-- 
2.25.1

