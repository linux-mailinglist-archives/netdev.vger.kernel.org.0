Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5678D2ED598
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbhAGR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbhAGR26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:28:58 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62096C0612FB
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:27:44 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id x16so10763745ejj.7
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B45U+qHccHHHQJHXjjIWQwLF97Vrdvgfo/HFB/AGDSA=;
        b=JS0GLBCGYynzAqxVix8WKX5o4LRtqKDZm9BH12U/PIZv7jlO6icTKki9W7dKzRqWsa
         wvPNGcXneLsNOwrtqUNgY8ufebMIBLDPm/2b4GFZVTedODNdoYquSQ81I6DiaeimpFmP
         soMNVlEsefDkrKUTRdmJBby9oMX+aGtQUlYqguZiMVtTLwYmyLH2gWYZYyxXtsy697F8
         6seqddd9jmRIv6qdrrKqLdIQj0eWI782YKQ/ZubymqQgm8pqOT8d/Brd+oU7kIOVt+14
         ytTpc+RYEzKhSfUmLkK47nZ6Kt75Ljmny3fErABOkbUua9FhRjLDqqMcNuwg8NIXw75h
         i8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B45U+qHccHHHQJHXjjIWQwLF97Vrdvgfo/HFB/AGDSA=;
        b=aBFfLipujWT8zBhZrWHyr2+zWm8PyamTXn2BPWYbxCWKIsrF2Ygn/UK3wVxJeur15A
         akhCfqBVHxDDudE2v4b/Wux9pwpQz/PiyQ9Nvy6fxMmA9BUk2A04HaiOTpcjfLalTtrx
         VrUzFxk/E4sMhRTE7oor5Mlt3fGyj3EdlQRLr+VQzNvuBSS1I3wpHvgi1y8+vUYg3Wy4
         O6njyc2EXosqUn5R6L9zQP9hAhatoLxlhwuWrJVjUVUvrpSAW5Y6wglCjrg0LfOvNClY
         2TqUD5WKoIqGUId9E6C11GZ2WI6YSFQ4J+rvYwxNkyy+YGSuoPjFQSDG0VUHayhOKjJU
         qUDw==
X-Gm-Message-State: AOAM533TZ7OhtO4NVkp7i8YiYBQ7Q4FOhM4q9IRNUROckbKCdX/++1h8
        AujRStGIB3H7bSCnPxl/MVL9Jh8tW9c=
X-Google-Smtp-Source: ABdhPJzFPScqskxDBrwOnfY+4mPGmDoDqrgmvxNCLpusxVs9To6iKsqA3HM0i1Kt53MOx6cNhC4WHA==
X-Received: by 2002:a17:907:447d:: with SMTP id oo21mr7062685ejb.367.1610040462931;
        Thu, 07 Jan 2021 09:27:42 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id y14sm2643351eju.115.2021.01.07.09.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:27:42 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 06/10] net: mscc: ocelot: export NUM_TC constant from felix to common switch lib
Date:   Thu,  7 Jan 2021 19:27:22 +0200
Message-Id: <20210107172726.2420292-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107172726.2420292-1-olteanv@gmail.com>
References: <20210107172726.2420292-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We should be moving anything that isn't DSA-specific or SoC-specific out
of the felix DSA driver, and into the common mscc_ocelot switch library.

The number of traffic classes is one of the aspects that is common
between all ocelot switches, so it belongs in the library.

This patch also makes seville use 8 TX queues, and therefore enables
prioritization via the QOS_CLASS field in the NPI injection header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Rebased on top of commit edd2410b165e ("net: mscc: ocelot: fix dropping
of unknown IPv4 multicast on Seville").

 drivers/net/dsa/ocelot/felix.c           | 2 +-
 drivers/net/dsa/ocelot/felix.h           | 1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 4 ++--
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 include/soc/mscc/ocelot.h                | 1 +
 5 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a9bf8ea7bbce..ba710259ae6a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -328,7 +328,7 @@ static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
 		       ANA_PORT_QOS_CFG,
 		       port);
 
-	for (i = 0; i < FELIX_NUM_TC * 2; i++) {
+	for (i = 0; i < OCELOT_NUM_TC * 2; i++) {
 		ocelot_rmw_ix(ocelot,
 			      (ANA_PORT_PCP_DEI_MAP_DP_PCP_DEI_VAL & i) |
 			      ANA_PORT_PCP_DEI_MAP_QOS_PCP_DEI_VAL(i),
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 5434fe278d2c..994835cb9307 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -5,7 +5,6 @@
 #define _MSCC_FELIX_H
 
 #define ocelot_to_felix(o)		container_of((o), struct felix, ocelot)
-#define FELIX_NUM_TC			8
 
 /* Platform-specific information */
 struct felix_info {
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 540b86edbbb0..57d1d6767867 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1376,7 +1376,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.vcap			= vsc9959_vcap_props,
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
-	.num_tx_queues		= FELIX_NUM_TC,
+	.num_tx_queues		= OCELOT_NUM_TC,
 	.switch_pci_bar		= 4,
 	.imdio_pci_bar		= 0,
 	.ptp_caps		= &vsc9959_ptp_caps,
@@ -1446,7 +1446,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, felix);
 	ocelot = &felix->ocelot;
 	ocelot->dev = &pdev->dev;
-	ocelot->num_flooding_pgids = FELIX_NUM_TC;
+	ocelot->num_flooding_pgids = OCELOT_NUM_TC;
 	felix->info = &felix_info_vsc9959;
 	felix->switch_base = pci_resource_start(pdev,
 						felix->info->switch_pci_bar);
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 8dad0c894eca..5e9bfdea50be 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1201,6 +1201,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap			= vsc9953_vcap_props,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
+	.num_tx_queues		= OCELOT_NUM_TC,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 8eb134cd8d9d..9a46787c679b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -98,6 +98,7 @@
 #define IFH_REW_OP_TWO_STEP_PTP		0x3
 #define IFH_REW_OP_ORIGIN_PTP		0x5
 
+#define OCELOT_NUM_TC			8
 #define OCELOT_TAG_LEN			16
 #define OCELOT_SHORT_PREFIX_LEN		4
 #define OCELOT_LONG_PREFIX_LEN		16
-- 
2.25.1

