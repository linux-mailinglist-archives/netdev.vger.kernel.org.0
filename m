Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1372E2EF6EA
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbhAHSDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbhAHSDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:03:54 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D77BC06129C
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:02:40 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id x16so15656763ejj.7
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vZtUlZCZfzf06Tx5MGStuprMYc1JfWJ+r+y9bMDBcqM=;
        b=H2UzJ9u7KODS29OYcIX82LQ3eEAixeIRo32lVKku7s2PQTwdiipaa2BhxP97WnPOQE
         yHB2E+4iRNOVXKi+LBw0fEAzTB0KIn4uK2+2a/lyyNfatSk33Dir3HfIIPuezCV7DuyZ
         ksytrVbQ6na9jSxtf1PtS8+DZw+jNH3MNdboDPXBwSwv//jfFVF/BPZv1auyqJvyHGeJ
         Zh3AE2AhXuzYQjohdycNTXVXyTK/bmZcGJGTBK8RkuOcffTICWYf1poWfmdKxasGNvd1
         NlialukGamdAC064o8UAObQytoRzdiofaHGmVBq8qB9ZT+zH2TOGZ5oWKvG0u7l4c5B8
         EC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vZtUlZCZfzf06Tx5MGStuprMYc1JfWJ+r+y9bMDBcqM=;
        b=EsnFBhKWUFlS1r0Xn2I5VxKSGvMDSm2UdMU0T7XPnvXNqAtjcWwCybcGsBvA9FdvKu
         OJqRLRR9Mgxc43QIYrFySK/+SrHhNW32GAfi/lRt3Xl+pJXcgnv5+GKRF133Wc9DtwIY
         skSOx+aYK7/sVy3Ym2mPTApHGnVqt5ut4nmpzjQx9rznS3AIxoUB7i9dXM4ZAoxXUpcz
         IJ2k8q6DKYFCi8EngNBjkiX6wgi6UFJ0Cz2NHeAgNfsBfiuq4iNAajaUCkoa8nNQeP8a
         mRssyroVFrGIpDRdl1/eEU0EPz0EP1/YZU5stjBUuKk36SkiNDVGAyuIsezZjIRlSN4y
         Wh1Q==
X-Gm-Message-State: AOAM530jPhHVt3PHRSpEMc20Prjhn2LTGvjiRuA0UIPaDcoE3j9X6z2+
        5rlYJGuZPYiiHUMHzCuMwdkNyOQMtLY=
X-Google-Smtp-Source: ABdhPJxnyt8w6zTeaSU293Szd6Yx/8N66JP1x2B2vzsc3I2zZpm2Lb/NBV6wg978Eft7kJRA+MlXWA==
X-Received: by 2002:a17:906:495b:: with SMTP id f27mr3452169ejt.338.1610128958813;
        Fri, 08 Jan 2021 10:02:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b19sm4059713edx.47.2021.01.08.10.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 10:02:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 06/10] net: mscc: ocelot: export NUM_TC constant from felix to common switch lib
Date:   Fri,  8 Jan 2021 19:59:46 +0200
Message-Id: <20210108175950.484854-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108175950.484854-1-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
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
Changes in v3:
None.

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
index 42770a86e871..f41f3476ae06 100644
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

