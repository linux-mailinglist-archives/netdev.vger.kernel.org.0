Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54234311946
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhBFDBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbhBFCvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:51:24 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DB3C061224
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:19 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id r12so14406432ejb.9
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qg0FNg0PtL0XgjN5bkLtn3U5F0iKT5oU5G6kbieF+Bw=;
        b=Ie/ekkLswFrNQ16FSp+vPmx4iWNp3rXHFCXzCgaOhJ0SosGXwtbxjrZLNyDcI08g/B
         xGxraOVxCkIgvwvYTS7/EwWT9W03rByXIsQpVDm2Ddyg2qTds3pGSUuHW5Iu8uD56wiN
         WGBsinwQrSb/2KmhqO5v1+Af0h8DjooynAL/B1jmXqX13WfSNngElE3Y3C7wpDCz57I5
         G5Kt4p0HSgLE6cbLjThvfJREEOUbwoISPA9RFSJGWcENeUMk2ZPxpN2mG095kH1BCTSM
         qQZhKUmb6yFdUkwSrhCJUNGeVq1mLurEiR9Aw6lEDDABdESBAzR3P1g/IK5R01coXfVm
         AY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qg0FNg0PtL0XgjN5bkLtn3U5F0iKT5oU5G6kbieF+Bw=;
        b=ljkljDiLQODk7cZ2jLVt6Tyz0vlbu/RV2XNwWDNIMydyGNxBTOrXEwIdqbDQhaysQW
         BU3w/AOcj+9EnbCkGsVPQghzeoVUYPv/s6JUNldBT0S1qFKak0ccCJl3vyAKOtINwjU4
         sXZ0wjYiML32i2/wSuP4xb9L4JmeDvTU/GjTa6/e/b9MV4t2MAtXSltgC8U5EGHH4uf0
         6pjftwDxqCV973/g0BX4QjUnHVSqKMs9r3CQB8c+WEmr5Q16p5VYvyb3bnjCFa5UoFS6
         OLie5Cci1Wf7d1NdSGFDfQu1tLhPACAGrhL+0kxR78yJGOOUPq9la+2RXP42xr8NmQRm
         aKrw==
X-Gm-Message-State: AOAM532ACcannZJUOTuLpi2xEhysJd1yCUDxtKmRdBdlDgyiT21Wg0DI
        cJfBMPPUiHcb2lHbacgKMyQ=
X-Google-Smtp-Source: ABdhPJxPLozTEMF9GVMIesQDPUrdpGdL/nKMyhH6C/BFCz+fK+u3sKQC5mAauJGi8vj6PGziK7PqUQ==
X-Received: by 2002:a17:906:c010:: with SMTP id e16mr5829996ejz.91.1612562597737;
        Fri, 05 Feb 2021 14:03:17 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:17 -0800 (PST)
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
Subject: [PATCH RESEND v3 net-next 06/12] net: mscc: ocelot: avoid unneeded "lp" variable in LAG join
Date:   Sat,  6 Feb 2021 00:02:15 +0200
Message-Id: <20210205220221.255646-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The index of the LAG is equal to the logical port ID that all the
physical port members have, which is further equal to the index of the
first physical port that is a member of the LAG.

The code gets a bit carried away with logic like this:

	if (a == b)
		c = a;
	else
		c = b;

which can be simplified, of course, into:

	c = b;

(with a being port, b being lp, c being lag)

This further makes the "lp" variable redundant, since we can use "lag"
everywhere where "lp" (logical port) was used. So instead of a "c = b"
assignment, we can do a complete deletion of b. Only one comment here:

		if (bond_mask) {
			lp = __ffs(bond_mask);
			ocelot->lags[lp] = 0;
		}

lp was clobbered before, because it was used as a temporary variable to
hold the new smallest port ID from the bond. Now that we don't have "lp"
any longer, we'll just avoid the temporary variable and zeroize the
bonding mask directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 127beedcccde..7f6fb872f588 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1338,7 +1338,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct netdev_lag_upper_info *info)
 {
 	u32 bond_mask = 0;
-	int lag, lp;
+	int lag;
 
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
@@ -1347,22 +1347,18 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 
 	bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
-	lp = __ffs(bond_mask);
+	lag = __ffs(bond_mask);
 
 	/* If the new port is the lowest one, use it as the logical port from
 	 * now on
 	 */
-	if (port == lp) {
-		lag = port;
+	if (port == lag) {
 		ocelot->lags[port] = bond_mask;
 		bond_mask &= ~BIT(port);
-		if (bond_mask) {
-			lp = __ffs(bond_mask);
-			ocelot->lags[lp] = 0;
-		}
+		if (bond_mask)
+			ocelot->lags[__ffs(bond_mask)] = 0;
 	} else {
-		lag = lp;
-		ocelot->lags[lp] |= BIT(port);
+		ocelot->lags[lag] |= BIT(port);
 	}
 
 	ocelot_setup_lag(ocelot, lag);
-- 
2.25.1

