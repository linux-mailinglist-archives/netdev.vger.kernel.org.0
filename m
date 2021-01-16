Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2985E2F8A2C
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbhAPBB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbhAPBBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:01:55 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469FAC06179A
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:43 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p22so11489594edu.11
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n5BibzNtUVWtkQIdfb1fd0X382vN/3t8GEzoEkNaObM=;
        b=jeUL462tbWbqHVVxoNpbYrJKmeTaJc3rTQQp1sAt+YiVTKvExhVbM/f+LmK8mcQaqF
         SibUZzCNjJOUmx5ONxQWijySw3Jgn9EifFcmi0HkIAz5CAVL5IqfCYupm+V46L+x8S5Y
         oe3qiZulG438WEqw/pBY56lWK+E6ydeR87Rl2yVioCkPErVKjCuMOdRcSyD1b0bvOehz
         lUtZcGKP4sE3o+1JzckHjM4mPosfg5ZFq3ER7F0bcKbYdlHLOWa9RjlcOSKMReAKKDFH
         MeTDMUZFnj16H/KHUKB2Yvo52ve1lIF2lNIDlSVf0NKdgwx5+5cYoxa56XDY8NUZoMNT
         iqUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n5BibzNtUVWtkQIdfb1fd0X382vN/3t8GEzoEkNaObM=;
        b=SZI0WcbCVYiS3wd6wYdZgWnNMebqxyGUPYzxAeYtpKHewYOUsPk9/P6ZAAxqXaKdLq
         /PKyVM4gOa8VrZDnb7C8z3ItY8MnrXgd+zFJZkHzJvzRAUQR34r6iFbmSgw6n3AoK7d6
         D/NyXmuecQrPi40gYb1Ci/wCNHkFbxsPjYzRzVVDEm1Fa9ysitNNv/Y/T5FD05cBTcUv
         O7kwurN/zm3AwjLkkVZ+Nl+Xb/clh1UCgenN0daSNnm1PBtIjS5s3sG1CpTeQEIIuwtb
         ZU8hv0xWXkO8pIHqDGLZyor96YYHPHDDOdSaXTabo1LVWoew25gGS0bVqn4Vyvn39bBJ
         dBpg==
X-Gm-Message-State: AOAM533a2ef4YFcmCbdr87zcs86pBukDZOFtNl37nC3g447Mrzn8lM8H
        M3DENjSWpZUS+RvS6li2o5s=
X-Google-Smtp-Source: ABdhPJzmSP5a1agOgZAfAOKuhXQ3wDuWvUaJ8Pn7vPxZhPUwWxijfoymMSUM/DH3PzBfRq+NVxgJIg==
X-Received: by 2002:a50:b246:: with SMTP id o64mr11104151edd.132.1610758842032;
        Fri, 15 Jan 2021 17:00:42 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k3sm5666655eds.87.2021.01.15.17.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:00:41 -0800 (PST)
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
Subject: [PATCH v2 net-next 07/14] net: mscc: ocelot: avoid unneeded "lp" variable in LAG join
Date:   Sat, 16 Jan 2021 02:59:36 +0200
Message-Id: <20210116005943.219479-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116005943.219479-1-olteanv@gmail.com>
References: <20210116005943.219479-1-olteanv@gmail.com>
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
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e2744b921a97..ce52bf892f9b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1273,7 +1273,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct netdev_lag_upper_info *info)
 {
 	u32 bond_mask = 0;
-	int lag, lp;
+	int lag;
 
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
@@ -1282,22 +1282,18 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 
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

