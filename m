Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DFC345147
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCVVAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbhCVU7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:59:25 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0DDC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:24 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ce10so23555741ejb.6
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BuU1u1y3b2PNxqXWD3n5YK1eZY5chlYDecQQtC6r1xU=;
        b=Qm+T3TKBxFMJEoEYxTX3tNC4aGtw2qD/U0d4kT0I/CLQpM9cUmxjaL7VD86Xos4FMu
         t7pfTPb4f+ueBV0DXDmHkUZ3rbNsmX5cnbetX+l+zkTU/KVGuupatyQkFrWUAlQmUoV5
         tRwjvwgY1xmF/RWSSXUtMbhnMU03tfOyc3YREOR9quTnfn6uhUeUSz5KPwTLMdyyefBg
         oFKVc6KZ5albk7ay6+qko40WF7rMM4fiOX8FJ7W1YZMoPN7VgurNZKhH62IN4KxWfmu/
         cGTNiJqKsgqlgwdfViHMQPmM9dngm5mtzTS7rTx4a9Mj9oW1vxbfexjY6WapXt1/xw8g
         jOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BuU1u1y3b2PNxqXWD3n5YK1eZY5chlYDecQQtC6r1xU=;
        b=Sat9eXQeU3MYKrBMoiR+OudBan3kq8GVU4KaLegwGUkkb7lM7567bgHIdvYhEhINFC
         yTFSSVEvDw0gS7yzg0sPvW4d/j1dm9GmKN6dipPItqhT3fsxyFAlka7C5+ZZpuih86KK
         sIWYH0wIGnsKK1JL7+UHY/IcKBKPXhdZ36QwNkMup5wR/NO2Utcr3R7l+dRsxWSTQVCZ
         uW83PE21vJ6mzSBwPwfkIBL8maLOCbr00MTkfcQ6TyTk1sZVp9qdb5W/TdyGcmYhVS6x
         xzpgjLCRSjHNUwyATq6G731cM+yH8cp3ChUx/N/NEXDBGvzThEOxr/JhsQb0YYZGGw8e
         xetg==
X-Gm-Message-State: AOAM531vIwlHndVupwbvtnL/OQEE6QnDew7YevuK9lARMTv1vCxliGZz
        eWuuJDO+15V4/8TeTvBWlS4=
X-Google-Smtp-Source: ABdhPJy5uY1DQMw1naHTSzST1btHIrPb5Lrg9RlWpGCaJQwI+PYRQM6NwVGu7lJv3w7xIJz+N1xf2w==
X-Received: by 2002:a17:906:2e45:: with SMTP id r5mr1589482eji.380.1616446763336;
        Mon, 22 Mar 2021 13:59:23 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v25sm11621074edr.18.2021.03.22.13.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:59:22 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/6] dpaa2-switch: move the dpaa2_switch_fdb_set_egress_flood function
Date:   Mon, 22 Mar 2021 22:58:54 +0200
Message-Id: <20210322205859.606704-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210322205859.606704-1-ciorneiioana@gmail.com>
References: <20210322205859.606704-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In order to avoid a forward declaration in the next patches, move the
dpaa2_switch_fdb_set_egress_flood() function to the top of the file.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 84 +++++++++----------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 2fd05dd18d46..5254eae5c86a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -110,6 +110,48 @@ static u16 dpaa2_switch_port_set_fdb(struct ethsw_port_priv *port_priv,
 	return 0;
 }
 
+static int dpaa2_switch_fdb_set_egress_flood(struct ethsw_core *ethsw, u16 fdb_id)
+{
+	struct dpsw_egress_flood_cfg flood_cfg;
+	int i = 0, j;
+	int err;
+
+	/* Add all the DPAA2 switch ports found in the same bridging domain to
+	 * the egress flooding domain
+	 */
+	for (j = 0; j < ethsw->sw_attr.num_ifs; j++)
+		if (ethsw->ports[j] && ethsw->ports[j]->fdb->fdb_id == fdb_id)
+			flood_cfg.if_id[i++] = ethsw->ports[j]->idx;
+
+	/* Add the CTRL interface to the egress flooding domain */
+	flood_cfg.if_id[i++] = ethsw->sw_attr.num_ifs;
+
+	/* Use the FDB of the first dpaa2 switch port added to the bridge */
+	flood_cfg.fdb_id = fdb_id;
+
+	/* Setup broadcast flooding domain */
+	flood_cfg.flood_type = DPSW_BROADCAST;
+	flood_cfg.num_ifs = i;
+	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				    &flood_cfg);
+	if (err) {
+		dev_err(ethsw->dev, "dpsw_set_egress_flood() = %d\n", err);
+		return err;
+	}
+
+	/* Setup unknown flooding domain */
+	flood_cfg.flood_type = DPSW_FLOODING;
+	flood_cfg.num_ifs = i;
+	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				    &flood_cfg);
+	if (err) {
+		dev_err(ethsw->dev, "dpsw_set_egress_flood() = %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
 				dma_addr_t iova_addr)
 {
@@ -1442,48 +1484,6 @@ static int dpaa2_switch_port_attr_set_event(struct net_device *netdev,
 	return notifier_from_errno(err);
 }
 
-static int dpaa2_switch_fdb_set_egress_flood(struct ethsw_core *ethsw, u16 fdb_id)
-{
-	struct dpsw_egress_flood_cfg flood_cfg;
-	int i = 0, j;
-	int err;
-
-	/* Add all the DPAA2 switch ports found in the same bridging domain to
-	 * the egress flooding domain
-	 */
-	for (j = 0; j < ethsw->sw_attr.num_ifs; j++)
-		if (ethsw->ports[j] && ethsw->ports[j]->fdb->fdb_id == fdb_id)
-			flood_cfg.if_id[i++] = ethsw->ports[j]->idx;
-
-	/* Add the CTRL interface to the egress flooding domain */
-	flood_cfg.if_id[i++] = ethsw->sw_attr.num_ifs;
-
-	/* Use the FDB of the first dpaa2 switch port added to the bridge */
-	flood_cfg.fdb_id = fdb_id;
-
-	/* Setup broadcast flooding domain */
-	flood_cfg.flood_type = DPSW_BROADCAST;
-	flood_cfg.num_ifs = i;
-	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
-				    &flood_cfg);
-	if (err) {
-		dev_err(ethsw->dev, "dpsw_set_egress_flood() = %d\n", err);
-		return err;
-	}
-
-	/* Setup unknown flooding domain */
-	flood_cfg.flood_type = DPSW_FLOODING;
-	flood_cfg.num_ifs = i;
-	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
-				    &flood_cfg);
-	if (err) {
-		dev_err(ethsw->dev, "dpsw_set_egress_flood() = %d\n", err);
-		return err;
-	}
-
-	return 0;
-}
-
 static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 					 struct net_device *upper_dev)
 {
-- 
2.30.0

