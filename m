Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15092F8A30
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbhAPBCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbhAPBB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:59 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA15C0617A0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:49 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id r12so4479829ejb.9
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mx4MOhohDXzuBINH5jwpAk3u0L8oYJBbC4BCZjybXw8=;
        b=aOfC9G283WHtZ8NGU6obJVy5lplXpK40/aVW8xASIOuZytHUT0vOjdl2ABLMVxSSLL
         BYLoLjFEOA1hXBAIy501sd+2miv4aw6rwAXmtbkB/rFfvWMWH2bAG4tjbYtPGdywpXa/
         nZ2I8lKpYAfTkUjr3lJ0NGatOHScJHc0Hi0ZmZES7hzOIez2DaVZ7ayfQTUj0sP8WegN
         IOSds+kH0LVzwyNH69tgRd95RbkaC9S548LoO7rTLCLxZIf2hU/Hskwz9BG9rflF5QTS
         Njpgmq0ENp631qHbBzXqIFZvLbNEgZfTFqvDSOCIpS4nqUECaVFfYRkwe1ZbIBf60/Wk
         rJIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mx4MOhohDXzuBINH5jwpAk3u0L8oYJBbC4BCZjybXw8=;
        b=VwgnsJ8hqIxVIDEgifcHPofLk95FUrA1F8GMKFpBGpjocS3xvqeaRqzJAibGnEUUDX
         uK2aF28cJffXdDurCcUWI4cwGN5pBmHkgPFdmJuVPHxm0O9r7xM808HtvzQk8auCSH6y
         DN4WVn1SM2U4nJnW21Bfs/8Pv41ArKxiTM6Mvee6mXD9DnrDsenOr7iQDVSJE33z1uA6
         IwmG4q+m25R8q16wO0t5TnlnAhURJOYwX7QNG0sEFjOUM4rgyd7SV0aCYjTzmoZz2eks
         dIZi5YT1yjh63dt/8pSwG8hzqJO+Q+mfnSxdtxy8qHDqsrNCZ0poAqhPKcOOMUy3i1aa
         HG5g==
X-Gm-Message-State: AOAM533MP5hcoSZAm8W00TIW9f+B7IFdY6YNfLs+A8dxwQOW0EsMNJgU
        ISi4xi8JHfs8/ZuFgJmGtNg=
X-Google-Smtp-Source: ABdhPJzHZxCKyHbgv+yI2zeTbNcw5h5e+sPZj+8hV0XnX1giZmK9a6LAvkTy/d4uSX7zFsq6a0viXw==
X-Received: by 2002:a17:906:3d4a:: with SMTP id q10mr10831866ejf.85.1610758848370;
        Fri, 15 Jan 2021 17:00:48 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:47 -0800 (PST)
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
Subject: [PATCH v2 net-next 12/14] net: mscc: ocelot: rename aggr_count to num_ports_in_lag
Date:   Sat, 16 Jan 2021 02:59:41 +0200
Message-Id: <20210116005943.219479-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It makes it a bit easier to read and understand the code that deals with
balancing the 16 aggregation codes among the ports in a certain LAG.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index fa2ebfbb33eb..78a468d39e9b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1244,8 +1244,8 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 	/* Now, set PGIDs for each LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
+		int num_ports_in_lag = 0;
 		unsigned long bond_mask;
-		int aggr_count = 0;
 		u8 aggr_idx[16];
 
 		if (!bonds[lag])
@@ -1257,8 +1257,7 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[aggr_count] = port;
-			aggr_count++;
+			aggr_idx[num_ports_in_lag++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -1266,7 +1265,7 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
 			ac &= ~bond_mask;
-			ac |= BIT(aggr_idx[i % aggr_count]);
+			ac |= BIT(aggr_idx[i % num_ports_in_lag]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
 
-- 
2.25.1

