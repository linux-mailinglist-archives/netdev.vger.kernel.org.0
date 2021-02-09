Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842AE3152B5
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhBIPY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbhBIPVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:21:15 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7E3C0617A9;
        Tue,  9 Feb 2021 07:20:08 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s5so24223134edw.8;
        Tue, 09 Feb 2021 07:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=13x8BtqrFi7wGn+7v8wT41cX4qyFUC8xGVV984/bSdc=;
        b=b5qXSv5VHkMX+0fEBMpuVGSj5jcAVdrq2JbGFhvzTGNANk1aLfOv6gyaKVlIHPWUUw
         nY+08v32kbPM9KyzpTLy6U6X+OYrpdrSTzKsFrovcAHb6sq80BjjRcPBDSO8ZIe6Thre
         kpjWJTXul7gqwBW6YllzkYX4kWkQPPGNb/Y5OLjbm1wyHVQ6WWrRX+VySEBq34vTI2zR
         F9zGu00ZQh4qp7JqS577cJ8xS8aMbX6qW7i/PZ1CSGnUC0klfNkJlAOdDMyfo7B66PZS
         ZpojqxB+cxGMvDg/cTnTztp2EaTOV4hnEJWWdK2I6qBDdDVE07wOEvG6iGm6Y9BrRPeo
         TuNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=13x8BtqrFi7wGn+7v8wT41cX4qyFUC8xGVV984/bSdc=;
        b=Zr4+a5Opy3FUYErgorCTYp3PsW2CehGXX0Rjc7IAE7MpoD3itJYLY9uGBpGDMhlR6e
         HT46Zmq0+zKpDhbHCTNdrSAeQbwCXKjTnKoQSSU6KKbNn8U55HVRNs6Va2PlTN2e4K6U
         r/EiJaNskd5Idunwtbfxfx36ugZBoAPXZKZ03+hj43ZZ836JlSiydArSV9oFPQYD2yaP
         ua8vgBpfcyIFuF4Rgebl3KpE47X5teSfk22V2oiImcgLuvTXPQI91G9Nc896e9fFNf+Q
         yZj5P3BZvnzWgg2QUBXNkbpPeHvu1HS5/FemLQ/sqmJEcmIw+yP8QJqQ0XMXAZLLLAoS
         Rp5A==
X-Gm-Message-State: AOAM531W5qUDZOOjg0RXshI2DD9gzSDECUGsArKLh2spDs4aGgcumEMS
        xyVEqANZoQ5h7vLWby0wOOQ=
X-Google-Smtp-Source: ABdhPJzzspUKXFZrH+3VC6pisQEwk16pC6HXczLuqpBCKYPuBHBpr5QJ/eq6r00l4ZPqohpbOPxRYA==
X-Received: by 2002:a05:6402:497:: with SMTP id k23mr22979145edv.315.1612884005627;
        Tue, 09 Feb 2021 07:20:05 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11686108edv.93.2021.02.09.07.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 07:20:04 -0800 (PST)
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
Subject: [PATCH v2 net-next 09/11] net: mscc: ocelot: use separate flooding PGID for broadcast
Date:   Tue,  9 Feb 2021 17:19:34 +0200
Message-Id: <20210209151936.97382-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209151936.97382-1-olteanv@gmail.com>
References: <20210209151936.97382-1-olteanv@gmail.com>
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
Changes in v2:
None.

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

