Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D913831A17A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhBLPTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhBLPRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:17:34 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C81C061793;
        Fri, 12 Feb 2021 07:16:22 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id g21so73880edm.6;
        Fri, 12 Feb 2021 07:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dHN/KEqqL5oOLZEZeyQA7jzjeIc7NEY7uPpaXIEmtwA=;
        b=gt82nsMmAQ+WIrw+CtYGDCHn8MzrKAE6EnVDlgcbV2yi2XhjPPVQL0/0OGYgl8G5kV
         GpRMlrWB9M8kxqxmTN3TzATAFFZr4oQB4cI2HNrw6u35b1eBmzOCIbMJKk+sX2NKRpj0
         b1FHZafx5E4aPfHjhhLJLQR+tvTzeACZJEO9wuLy75frNpgosMkmos4bdHnXlIWeHSox
         KzjIsH+38IjJUYYdZxsZpGwstSWfD/breQdAn7uJV2UfsBkZl6/q7C+GhDeCYcI0rY6h
         51DLov0vgem8sp+M3ZDlZmNfrwgD4pzhc/kNWNzuD/gIc8dlbUUb8kPP5QuRK+zP5G9z
         wVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dHN/KEqqL5oOLZEZeyQA7jzjeIc7NEY7uPpaXIEmtwA=;
        b=MRLbdhC8LIr7cLi3WEjKGovkyO6CKU7OtyrRdeqe2YxSyQ/XJ09lZbDyd33rKN7gTL
         2N03cIXh09Pg7Jd+10DJ4Q35MwkotlnXZJ+oAF4NtprXShUdbzbDk9Nlps51EidRT8m3
         Pqojsp5MARHjNlKckC/MQ2C41LCjPz60LhRagRoHELD4ITakplgw//VuFjVihJjMcqxw
         AO5D5m+90cpjTIFZxBnJMJ267+6ZtIPpuv3stshUoE35GHub2fFoJmzhY9NJpD9zQz4b
         V2q39ZsGTA8et/qdTyuempokBWLXxVsB3j13xspgsz/JRvoCb1xxvoF4MVVTBim0Fwr+
         Sfvw==
X-Gm-Message-State: AOAM532O3EKJ6bhO+dV/NCHGQv1J0C7NBtHYmcfwpDhn0bJ62nEolHZL
        nOK3xQOHZkQZEEuSZjPVn6I=
X-Google-Smtp-Source: ABdhPJxERN6QqoEHDrAuCtFFPYQ0A+bahP95QHpcJVPvMzT8BgrDS2zVg/HPSRHhwwDrXyiNcB3OnA==
X-Received: by 2002:a05:6402:100b:: with SMTP id c11mr3820883edu.193.1613142980909;
        Fri, 12 Feb 2021 07:16:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z19sm6515456edr.69.2021.02.12.07.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:16:20 -0800 (PST)
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
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v5 net-next 08/10] net: mscc: ocelot: use separate flooding PGID for broadcast
Date:   Fri, 12 Feb 2021 17:15:58 +0200
Message-Id: <20210212151600.3357121-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212151600.3357121-1-olteanv@gmail.com>
References: <20210212151600.3357121-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
Restore the PGID_BC value from the ocelot-8021q DSA tagger setup code too.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c     |  2 ++
 drivers/net/ethernet/mscc/ocelot.c | 13 ++++++++-----
 include/soc/mscc/ocelot.h          | 15 ++++++++-------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ae11d3f030ac..00b053d8294f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -299,6 +299,7 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_UC);
 	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, 0, cpu_flood, ANA_PGID_PGID, PGID_BC);
 
 	felix->dsa_8021q_ctx = kzalloc(sizeof(*felix->dsa_8021q_ctx),
 				       GFP_KERNEL);
@@ -412,6 +413,7 @@ static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu)
 	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
 	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_UC);
 	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_BC);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 1654a6e22a7d..1a31598e2ae6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1716,7 +1716,7 @@ int ocelot_init(struct ocelot *ocelot)
 	/* Setup flooding PGIDs */
 	for (i = 0; i < ocelot->num_flooding_pgids; i++)
 		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
-				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
+				 ANA_FLOODING_FLD_BROADCAST(PGID_BC) |
 				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
 				 ANA_FLOODING, i);
 	ocelot_write(ocelot, ANA_FLOODING_IPMC_FLD_MC6_DATA(PGID_MCIPV6) |
@@ -1737,15 +1737,18 @@ int ocelot_init(struct ocelot *ocelot)
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
index bfce3df61bfd..9acbef1416f1 100644
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

