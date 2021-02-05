Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEF43118B7
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhBFCby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhBFCbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:31:47 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD67C0611C0
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:22 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s11so10698116edd.5
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I/8G4m2IjEP9kJnVijcaplzNh0G1BLcnZbgghwOkNlo=;
        b=L1zgQWPs79z2BFkG34ftURrJ7s3qJ9no02C0GEhCFGZGoZBnHmCwRXrvotSfg1ZcdH
         nRdv/YFuFMI42Q3bDoWNyusWWerBEniHCo2EtyuwhY8qdM8EL//2FDhtcdSMnNdpLbsp
         jyV582ZQJIhWYFw5w0qauzX55sg62AbD+anQ/+0rTlwe9VpxOJdUDK1T3T93Qf3tJNpW
         TB6Epx6WYB36Cn4lV+h/NiaxBCf/wXHctmic9NGnMfuSWgSMMJAQWTgD945zYKqgA1TY
         aWEUYDXVEMyIhWxOY6kuqKuWBMQ0WrH4pc0LR9a1ZE2BG1I0dOgUKZ5FXGNolM2hMwut
         kd8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I/8G4m2IjEP9kJnVijcaplzNh0G1BLcnZbgghwOkNlo=;
        b=BZTtO1Pouvt50wm6Qb6UBHXGvYkzG8v5eRLHeXbVQMgsGxdbELJS7XyQV1cgIPrIba
         UPaexiTkpVhVgVp78x2deLHcJ9GWLG2VWFTLeOeyzNWd1IjvFm+VIa1mWIme8Nbdi/8e
         kxSlsJwpFm3Q5IY0hRMYS9JlRJqu/AV6YTgc1x075j9DAtacy4QbDD2B2sNhaVcFu+C6
         llJ/stbDBYrdLlmZL77S5/qXW2M7v9vK+ve3m+bJfrPuaBFnMzlvpHjoZO+j7oIan0Ch
         oZ6j/JXwdQnnkB2eVvAjlUs+tLHnY0TMginEm2FyxpJy1+iOtVTTIQdkEe8+ShbqaUVj
         Rmxg==
X-Gm-Message-State: AOAM5328zxSYXLH/UZmbzsaAKIJSZ5OEbROlY3qFQ9nT3ZkNHRpGz3Ky
        /polk4tkd3MxaF3zgQBCVdY=
X-Google-Smtp-Source: ABdhPJwypNrsHe8vP+DeAmwW7co8gqveBAwaylsemB+y6aRw/VTXfwQfRdeX/B/QFVQuCVtbryzEcQ==
X-Received: by 2002:a05:6402:2694:: with SMTP id w20mr5640138edd.200.1612562601205;
        Fri, 05 Feb 2021 14:03:21 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 09/12] net: mscc: ocelot: rename aggr_count to num_ports_in_lag
Date:   Sat,  6 Feb 2021 00:02:18 +0200
Message-Id: <20210205220221.255646-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
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
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c906c449d2dd..380a5a661702 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1298,8 +1298,8 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
 		struct net_device *bond = ocelot->ports[lag]->bond;
+		int num_ports_in_lag = 0;
 		unsigned long bond_mask;
-		int aggr_count = 0;
 		u8 aggr_idx[16];
 
 		if (!bond || (visited & BIT(lag)))
@@ -1311,8 +1311,7 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[aggr_count] = port;
-			aggr_count++;
+			aggr_idx[num_ports_in_lag++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -1320,7 +1319,7 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
 			ac &= ~bond_mask;
-			ac |= BIT(aggr_idx[i % aggr_count]);
+			ac |= BIT(aggr_idx[i % num_ports_in_lag]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
 
-- 
2.25.1

