Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E742C31284D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 00:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhBGXZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 18:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhBGXY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 18:24:27 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E168C061794;
        Sun,  7 Feb 2021 15:23:15 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id f14so21814882ejc.8;
        Sun, 07 Feb 2021 15:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zCy1EvMOOXH22EDc1HyamzeL1z53w13AeBEhwJyUZ3g=;
        b=c5j/diN8gx4zgCBwE67swYl3o8kHpanpQ7ncIHsLV3r7pplyNhBoRLoe+laZ3L+o3c
         lGqm7S7lddC8LMo9HwNtmj1ohpiCmcbAeiFh3zBTk/BKvSQqZ9J3nJiv6f9au4Z4Uv12
         u4Asyha9Q2k2uRK/yonDDmGRO8/wQlsTpQdbn+7DaZ8Mti/mIlQ2VJLSnRK8K7jo2LAc
         WL7cN2jJlVu9NKNM5xe1Ot7ZrlsTbHZ1YKJ82vUgk0SlGK+RJL0gVzqp4ntxHZJd+BI3
         mW2aglhzFA8yampMpg+tLL9Tjc1TpHkLUNwgjUKT0YMEFO8qUeJvSb4ONEl/Rx/EmnId
         yNWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zCy1EvMOOXH22EDc1HyamzeL1z53w13AeBEhwJyUZ3g=;
        b=qk94OpVQJ3AUnsHvyspq1I6qgfR7odnG24+czJHn9nzbGdpWK38wdj2ejwMPuNNFoR
         IrwAik0sRg+EfnZ1dK4WmUUdsffFZTvIS8ERIfeW7y3rcRPkUirbTJN3j8wWUqAZePTL
         Uub1eO7RN2U8BnN+bfCP2+XOi1oPfPmFb2wfcIylFjUTeSPxtciDyNcQOELRQwDCDIfI
         OZhQAyCfvJ8a//JRXYGX7otDMvGf1nz9Yz9g3zDDXqqHfBY+/f/bUYNX3/3UvkJaBZGl
         omJhGDZRMjWUcQejZU5VDw5Aw/nMo0kh01CU3QwSHZ/urKpcvQGEdOIS2MSqX0xIvvlq
         u2Rg==
X-Gm-Message-State: AOAM530Wb8apf0EetCFw1PmF97ZeG2UyfpBMXkaz2USpYgNmistbPcPS
        E0xHxsunpEMkK1Fr8nyJj7c=
X-Google-Smtp-Source: ABdhPJwquKnPTKBiRX+xvUdB0FvC7LMA7bWVQGIsqLYHs2piy0t0wfFUtEx4Ivvn63GpGu6/t0mfQA==
X-Received: by 2002:a17:906:805:: with SMTP id e5mr14217883ejd.104.1612740194366;
        Sun, 07 Feb 2021 15:23:14 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u21sm7540016ejj.120.2021.02.07.15.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:23:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH net-next 7/9] net: mscc: ocelot: use separate flooding PGID for broadcast
Date:   Mon,  8 Feb 2021 01:21:39 +0200
Message-Id: <20210207232141.2142678-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207232141.2142678-1-olteanv@gmail.com>
References: <20210207232141.2142678-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In preparation of offloading the bridge port flags which have
independent settings for unknown multicast and for broadcast, we should
also start reserving one destination Port Group ID for the flooding of
broadcast packets, to allow configuring it individually.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 13 ++++++++-----
 include/soc/mscc/ocelot.h          | 15 ++++++++-------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index f8b85ab8be5d..8c1052346b58 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1662,7 +1662,7 @@ int ocelot_init(struct ocelot *ocelot)
 	/* Setup flooding PGIDs */
 	for (i = 0; i < ocelot->num_flooding_pgids; i++)
 		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
-				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
+				 ANA_FLOODING_FLD_BROADCAST(PGID_BC) |
 				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
 				 ANA_FLOODING, i);
 	ocelot_write(ocelot, ANA_FLOODING_IPMC_FLD_MC6_DATA(PGID_MCIPV6) |
@@ -1683,15 +1683,18 @@ int ocelot_init(struct ocelot *ocelot)
 		ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_SRC + port);
 	}
 
-	/* Allow broadcast MAC frames. */
 	for_each_nonreserved_multicast_dest_pgid(ocelot, i) {
 		u32 val = ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports - 1, 0));
 
 		ocelot_write_rix(ocelot, val, ANA_PGID_PGID, i);
 	}
-	ocelot_write_rix(ocelot,
-			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
-			 ANA_PGID_PGID, PGID_MC);
+	/* Allow broadcast and unknown L2 multicast to the CPU. */
+	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID, PGID_BC);
 	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV4);
 	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV6);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d0d48e9620fb..7ee85527cb5f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -54,16 +54,17 @@
  * PGID_CPU: used for whitelisting certain MAC addresses, such as the addresses
  *           of the switch port net devices, towards the CPU port module.
  * PGID_UC: the flooding destinations for unknown unicast traffic.
- * PGID_MC: the flooding destinations for broadcast and non-IP multicast
- *          traffic.
+ * PGID_MC: the flooding destinations for non-IP multicast traffic.
  * PGID_MCIPV4: the flooding destinations for IPv4 multicast traffic.
  * PGID_MCIPV6: the flooding destinations for IPv6 multicast traffic.
+ * PGID_BC: the flooding destinations for broadcast traffic.
  */
-#define PGID_CPU			59
-#define PGID_UC				60
-#define PGID_MC				61
-#define PGID_MCIPV4			62
-#define PGID_MCIPV6			63
+#define PGID_CPU			58
+#define PGID_UC				59
+#define PGID_MC				60
+#define PGID_MCIPV4			61
+#define PGID_MCIPV6			62
+#define PGID_BC				63
 
 #define for_each_unicast_dest_pgid(ocelot, pgid)		\
 	for ((pgid) = 0;					\
-- 
2.25.1

