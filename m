Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9B32F62E4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbhANOQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbhANOQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:16:40 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72874C061786
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:50 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b6so5379381edx.5
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=99nCmHFhBHiF92XkZ7c7L5oLSRyjj54vYf+ozkXzH2E=;
        b=eQAacpaddiTC3m7Q2Z86/o8KxKNBWiDGnnNv+j+nbxJrWrSK7fbeXgIY9P8wXNxyxZ
         udnqy6ddaeoSHPQKIkP9jAM4Di9DAQadUnvPG0PxrEoU33JVSbsQU7NDOk4+95lD7/Dj
         TCT2SF1o+1sRwM+yRa4OYJYlWJ5K/Mo2yD3FqLEgozTMuogdfSydZCbpSTt9eXFdFcXN
         D9s0z95LQm1I+O3w4afz8e0pg/cpW8z5BdXUNhAVkVSrqql8vftF8trf2KDHJUYdPQcH
         MXEaEYJ/vyX3HFdRF+jffyFXWdLMVQcN8DFvpkHrRiXGgMY2F1l8Vm2bBFwst4DhgOiy
         eehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=99nCmHFhBHiF92XkZ7c7L5oLSRyjj54vYf+ozkXzH2E=;
        b=hvmw6H1v3jPRXHMTxZqRtDyz014qOs8my+XFjPU5R9ebsZCWXg6erlF3ZXBA42Xgk+
         /92HN/WF1ckXqGqt0OIFHKybDDdtp6Cu+s27XOAwYgdTPM0VkZi9cgJC+HjpOBHvDur6
         lG9SCmUd2lSMNsG8xBI726MZE9NHhR8tJx+cXpg2xUsh1emocORa1pKrmZ6l9Rv4ZKRh
         zf8CnZtJeXfHhQ0pNNesNcINJe7C6UCEYGh3qHeWFkE71RDtTz0YCFA0rpylkeh6vu/a
         UzaNsq0MCpnOMotl7RmctzmGZfvT24r2aRmn58yEcLQHgQrNh3gw4brwOWZLqsBuGFGh
         7IoA==
X-Gm-Message-State: AOAM533Jh/wD/279+AJF2v29eoq6QrmbymcyN4ejBqG9WUiP/P0bSFjq
        fDmwDubersOP+nxbts4tPhg=
X-Google-Smtp-Source: ABdhPJwrT0jVXr8l020FyFzU5hlujKY1PlZrbJu1qJ/PfzBlIK6xfJSjlTCOAkU18te7EfUwNf1VsA==
X-Received: by 2002:a50:ed04:: with SMTP id j4mr6046900eds.84.1610633749055;
        Thu, 14 Jan 2021 06:15:49 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr3sm773535ejc.41.2021.01.14.06.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:15:48 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 06/10] net: mscc: ocelot: export NUM_TC constant from felix to common switch lib
Date:   Thu, 14 Jan 2021 16:15:18 +0200
Message-Id: <20210114141522.2478059-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210114141522.2478059-1-olteanv@gmail.com>
References: <20210114141522.2478059-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
None.

Changes in v4:
None.

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
index 3ec06bdd175a..6c584496abc6 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -299,7 +299,7 @@ static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
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
index 21dacb85976e..f9711e69b8d5 100644
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
@@ -1435,7 +1435,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
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
index e548b0f51d0c..1dc0c6d0671a 100644
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

