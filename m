Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358E7174761
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgB2Obc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:31:32 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38537 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgB2Oba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:31:30 -0500
Received: by mail-wr1-f66.google.com with SMTP id t11so418163wrw.5
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 06:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QfS3roUvCt58l5foLS6iq2R4UnQoF/uUnIyT6QKKyPg=;
        b=b3fWcGHYunDei+zKII7l4jA1Jj3Qa32GWJfKwusUQJ/QLeoZ1hC0mOc/h9GbMnHXIv
         kfl+IO6LX41ABZd5YetGMWZw510A4hUKqAtb3VHEjp1ERAotcg0SGwBX0bjytu8+iMhS
         xSsUi3XQ6ppuxigXUgGyvOz4LNDjRakVlIdptcu8pAmDkyX5lAFEvqOglOayOVsp5ZKt
         XhZnEh9qx0fnQrFfoCu0hFkFY+YSyx/P5vyhIhpgyB6OIT5WMHUAA4FIG5UkrFwCIVMS
         4CRPLGtiiuT7EA3ARQc5ot0TsIXziiODv+kVryXf7Ix6+/tHiEXcYfR9zQ3BGUqKDt7b
         DDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QfS3roUvCt58l5foLS6iq2R4UnQoF/uUnIyT6QKKyPg=;
        b=ctgYI9fQF+3pKuDPS+w4mE7NnmIKf08NS27S/bvadnI2i1lMGdA85tdGPiZ4V2impE
         8+xXxWQ7VZI2HJRM9dE5nao7eiEWdvitmTtDUgmmkgPCYhfzgjFd7YuQHoo2iP5+Nnmd
         9MjKJ/yzyECOzB5bUh/RXPRwwThMBghBXFGnB4L7UZqS7o0YLATBtjuxYRPlC+NhkWnV
         RWU3Lvp5rKA63qHM5I6U3emgj7FUVrxdLLAygKDRHcTyFnOLlZMZNDD0t5NVSB2K9rNh
         lPMJttexiqi3txeXv/OBvsvi4QxaK1ulP+v3RXPD1Ekh+EKjFpbf8EPvT/PTYs1lME6I
         X6wQ==
X-Gm-Message-State: APjAAAVoUv2sDh7L4//XyzV3ObNL1SuiFtj1dUQXi4HrR5cpaCxYqfcQ
        qLJVUDsQPOJ5XiTm1BWphUw=
X-Google-Smtp-Source: APXvYqzI0iwucn7emwE9YF0fMnMx6GztykKbA0REfMS0bsWs6XieWBzlQfaHGZ79sT15p5DxY+rxDw==
X-Received: by 2002:adf:c448:: with SMTP id a8mr7160506wrg.295.1582986688871;
        Sat, 29 Feb 2020 06:31:28 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id d7sm7573528wmc.6.2020.02.29.06.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:31:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH v2 net-next 07/10] net: mscc: ocelot: remove port_pcs_init indirection for VSC7514
Date:   Sat, 29 Feb 2020 16:31:11 +0200
Message-Id: <20200229143114.10656-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229143114.10656-1-olteanv@gmail.com>
References: <20200229143114.10656-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Felix driver is now using its own PHYLINK instance, not calling into
ocelot_adjust_link. So the port_pcs_init function pointer is an
unnecessary indirection. Remove it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Allan W. Nielsen <allan.nielsen@microchip.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c       | 19 +++++++++++++++++--
 drivers/net/ethernet/mscc/ocelot_board.c | 24 ------------------------
 include/soc/mscc/ocelot.h                |  3 ---
 3 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 2c307aa8bf3e..06f9d013f807 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -442,8 +442,23 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_MAC_MODE_CFG_FDX_ENA |
 			   mode, DEV_MAC_MODE_CFG);
 
-	if (ocelot->ops->pcs_init)
-		ocelot->ops->pcs_init(ocelot, port);
+	/* Disable HDX fast control */
+	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
+			   DEV_PORT_MISC);
+
+	/* SGMII only for now */
+	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
+			   PCS1G_MODE_CFG);
+	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
+
+	/* Enable PCS */
+	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
+
+	/* No aneg on SGMII */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
+
+	/* No loopback */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
 
 	/* Enable MAC module */
 	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 2f52d2866c9d..8234631a0911 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -212,29 +212,6 @@ static const struct of_device_id mscc_ocelot_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
 
-static void ocelot_port_pcs_init(struct ocelot *ocelot, int port)
-{
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
-	/* Disable HDX fast control */
-	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
-			   DEV_PORT_MISC);
-
-	/* SGMII only for now */
-	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
-			   PCS1G_MODE_CFG);
-	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
-
-	/* Enable PCS */
-	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
-
-	/* No aneg on SGMII */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
-
-	/* No loopback */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
-}
-
 static int ocelot_reset(struct ocelot *ocelot)
 {
 	int retries = 100;
@@ -259,7 +236,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 }
 
 static const struct ocelot_ops ocelot_ops = {
-	.pcs_init		= ocelot_port_pcs_init,
 	.reset			= ocelot_reset,
 };
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index f9da90c5171b..ab342eef251c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -462,7 +462,6 @@ enum ocelot_tag_prefix {
 struct ocelot;
 
 struct ocelot_ops {
-	void (*pcs_init)(struct ocelot *ocelot, int port);
 	int (*reset)(struct ocelot *ocelot);
 };
 
@@ -538,8 +537,6 @@ struct ocelot {
 	struct mutex			ptp_lock;
 	/* Protects the PTP clock */
 	spinlock_t			ptp_clock_lock;
-
-	void (*port_pcs_init)(struct ocelot_port *port);
 };
 
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-- 
2.17.1

