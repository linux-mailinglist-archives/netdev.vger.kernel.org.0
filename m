Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AD52FC493
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbhASXLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbhASXJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:28 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74D3C061793
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:12 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g24so23503993edw.9
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3eU6kSjEOcWiIAeYb5djdb4+zYVSgxq7JRDf7QIRx6g=;
        b=n0ZPhrsxsHE2EdhLRRqLHZp8D6zgNG/HoCzqKH0ZWB8DFpZC/OkkRak2V83p7jG+y0
         ZXrQSqu4ZDErsOBgc3UkZeHdI8lFqgyPNaGv4ouXpRdRV2SApD3WCt/IWWzUgO8VFeCP
         yYpMIy1QaOIIPfJxKFsDhEFP6xfXAK2EU7bCW1QZnZevcryB7xCftzB3g2t5u6u6jLcx
         yK4BdS8vIOP3msH5BwuULIbjHKdsZj9UldfzK+RTdsJE0sS6kC4G+TfRsKZebXlNXTzE
         HOnAwbafP24HbbshhDYIvAyOKytohVB0BXUua+VdpoKyhUCcnqZmnBtyZXH7vYgIpnt/
         QELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3eU6kSjEOcWiIAeYb5djdb4+zYVSgxq7JRDf7QIRx6g=;
        b=eWiy26P8D6r5nugo5GFgGcg5FASg3+aDWsFwj/oHtt8SETQYiUreTZysCN+N7nGhGD
         ftbK2S98FLjih87Fm7YDMKbGBHMfpplo8fRmAuCsJOlJ+2XyeH41f2nU22SsexQrYDXO
         Ujv9f5imY0m4npKhRqcMOvQfk1HbiR5G20+375Uh/yJh0OI8gWGbagdQ34NY0/CIA0EN
         z8QKntZq7BvgabJ602eeAmNW9CyUC00sfWrLytCCArIff1AHGLb8xdKeghzujX117y41
         oRUFta4bTtGxdwhQbrBVYO+RvsSNAgQ31KMmNIe1E3CyV1ZMF7PWDLGKcCKCKxR5yht5
         Jxmg==
X-Gm-Message-State: AOAM530C8h0kfSmgBePGPG1yz6cOSFmoawK8Rbpe1GHxGZd2tZs/JDns
        p7ZE+Lj4TstLT0J0tx1rDbiJMkockRE=
X-Google-Smtp-Source: ABdhPJynZJe1FEhTIn9p9Up9kao6YyFxOQlt077IdZdmSNOB7aEdAvZFafllE9QMm6nttq+BggFWLQ==
X-Received: by 2002:a05:6402:268a:: with SMTP id w10mr5161977edd.331.1611097691610;
        Tue, 19 Jan 2021 15:08:11 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 08/16] net: mscc: ocelot: stop returning IRQ_NONE in ocelot_xtr_irq_handler
Date:   Wed, 20 Jan 2021 01:07:41 +0200
Message-Id: <20210119230749.1178874-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since the xtr (extraction) IRQ of the ocelot switch is not shared, then
if it fired, it means that some data must be present in the queues of
the CPU port module. So simplify the code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 407244fe5b17..5140639910a6 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -604,10 +604,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 	int i = 0, grp = 0;
 	int err = 0;
 
-	if (!(ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)))
-		return IRQ_NONE;
-
-	do {
+	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
 		struct skb_shared_hwtstamps *shhwtstamps;
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
@@ -702,7 +699,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 			netif_rx(skb);
 		dev->stats.rx_bytes += len;
 		dev->stats.rx_packets++;
-	} while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp));
+	}
 
 	if (err)
 		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
-- 
2.25.1

