Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5CE248EE3
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgHRTon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRToe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:44:34 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4282C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:33 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id a6so20792pjd.1
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7r/Cv7mUYExUV6yXLs8q8FwJJe7X91sTEib5RQYrszA=;
        b=mfR+R6xlUgmK/G0cn5e36DABL3h9Vhun2/FrntPK9zOv/UxioZg6Ph5/amv3CCV+os
         D+kH/TAGZyxssnQcIkUNDgTIrI6pCtpQrLyCooztCrn2Rt5rb6xBo9EDWl5v4gUH2SHT
         r2GLPnTq/1oXRQDaRJ2w1zoLLaLC2OIy6ebp0gmSp9KBG9OI6g/Dm8/eiy5v+hs5H5O6
         xqLKiHwH1TobkiYJd1sC5aWXvvcY29dZGyKDz8pLztkD1vRoFwaDAsHTX4Yiw9JAwKg9
         qymSi2OA+SAg0qnT82YBhGOZEmWhNE0mKRDm1kVEHzcnJ7UXZHiRsqtRYKft+f4DfG6r
         RKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7r/Cv7mUYExUV6yXLs8q8FwJJe7X91sTEib5RQYrszA=;
        b=FNwzviysPTs9DlAuXptswaZreHl5BGgQOY1Wz8KIsLAIFeDZu3sjKLwL3v1M9+hsap
         XBVYgheZqnROUhg8uR4zJaUIEifvhaA76tIBqp4YCnaIY8LTaT5yVNMDVBZuXhKVAD+g
         7hKDCLYCz/QXbfFF554CllfC51W8QNWXB7qaVT5yt1Lpp4OS+kMgfe6a9zaqCVpEFyEv
         zjqmVPA3HhJ7C+Vt1RITlM54PYYp1d0Q/ji6m24tibPTlUbmA4JVjIOyIEJrt7q0KdzH
         rWv8GWkHzriONq52l6ENquTYENo07OnlC0wq12uxHfLzbPHU6LapmrQqqz2+FyBUATtV
         Z4mw==
X-Gm-Message-State: AOAM533tAypZ6Ou4zS2syGneqZgB9aNC1Tf4FndFBBp9UslNcO2r4YSg
        wuZq8dkFoVVpMXHHsmEu62/SXe64UYN1kDMzEHZca4PA5/xx+v3/1MHkT0NiYi7qetHPWhouJZl
        zFXhxL8BX4/yc5OlBIZmmEpzhU51mvY9yltG2TLWFJwHWQmY9X+ybnAbKH1uR8KuQ9isUlAVu
X-Google-Smtp-Source: ABdhPJxueTeFDWbwS5QuAj0WDAOaxoSOuStakmW5MNWa0ZANCNZxI8t3NXSb4MazszjoC5STMGVkatG0djRnKKkA
X-Received: by 2002:a65:4808:: with SMTP id h8mr14584683pgs.113.1597779873002;
 Tue, 18 Aug 2020 12:44:33 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:02 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 03/18] gve: Register netdev earlier
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Move the registration of the netdev up to initialize
it before doing any logging so that the correct device name
is displayed.

dev_info/err should then be used, not netif_info/err.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 15 +++++------
 drivers/net/ethernet/google/gve/gve_main.c   | 27 ++++++++++++--------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 9dbfcfb8cf63..6a93fe8e6a2b 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -334,8 +334,7 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 
 	priv->tx_desc_cnt = be16_to_cpu(descriptor->tx_queue_entries);
 	if (priv->tx_desc_cnt * sizeof(priv->tx->desc[0]) < PAGE_SIZE) {
-		netif_err(priv, drv, priv->dev, "Tx desc count %d too low\n",
-			  priv->tx_desc_cnt);
+		dev_err(&priv->pdev->dev, "Tx desc count %d too low\n", priv->tx_desc_cnt);
 		err = -EINVAL;
 		goto free_device_descriptor;
 	}
@@ -344,8 +343,7 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	    < PAGE_SIZE ||
 	    priv->rx_desc_cnt * sizeof(priv->rx->data.data_ring[0])
 	    < PAGE_SIZE) {
-		netif_err(priv, drv, priv->dev, "Rx desc count %d too low\n",
-			  priv->rx_desc_cnt);
+		dev_err(&priv->pdev->dev, "Rx desc count %d too low\n", priv->rx_desc_cnt);
 		err = -EINVAL;
 		goto free_device_descriptor;
 	}
@@ -353,8 +351,7 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 				be64_to_cpu(descriptor->max_registered_pages);
 	mtu = be16_to_cpu(descriptor->mtu);
 	if (mtu < ETH_MIN_MTU) {
-		netif_err(priv, drv, priv->dev, "MTU %d below minimum MTU\n",
-			  mtu);
+		dev_err(&priv->pdev->dev, "MTU %d below minimum MTU\n", mtu);
 		err = -EINVAL;
 		goto free_device_descriptor;
 	}
@@ -362,12 +359,12 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	priv->num_event_counters = be16_to_cpu(descriptor->counters);
 	ether_addr_copy(priv->dev->dev_addr, descriptor->mac);
 	mac = descriptor->mac;
-	netif_info(priv, drv, priv->dev, "MAC addr: %pM\n", mac);
+	dev_info(&priv->pdev->dev, "MAC addr: %pM\n", mac);
 	priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
 	priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
 	if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
-		netif_err(priv, drv, priv->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
-			  priv->rx_pages_per_qpl);
+		dev_err(&priv->pdev->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
+			priv->rx_pages_per_qpl);
 		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 4f6c1fc9c58d..b0c1cfe44a73 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -930,7 +930,7 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 		priv->dev->max_mtu = PAGE_SIZE;
 		err = gve_adminq_set_mtu(priv, priv->dev->mtu);
 		if (err) {
-			netif_err(priv, drv, priv->dev, "Could not set mtu");
+			dev_err(&priv->pdev->dev, "Could not set mtu");
 			goto err;
 		}
 	}
@@ -970,10 +970,10 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 						priv->rx_cfg.num_queues);
 	}
 
-	netif_info(priv, drv, priv->dev, "TX queues %d, RX queues %d\n",
-		   priv->tx_cfg.num_queues, priv->rx_cfg.num_queues);
-	netif_info(priv, drv, priv->dev, "Max TX queues %d, Max RX queues %d\n",
-		   priv->tx_cfg.max_queues, priv->rx_cfg.max_queues);
+	dev_info(&priv->pdev->dev, "TX queues %d, RX queues %d\n",
+		 priv->tx_cfg.num_queues, priv->rx_cfg.num_queues);
+	dev_info(&priv->pdev->dev, "Max TX queues %d, Max RX queues %d\n",
+		 priv->tx_cfg.max_queues, priv->rx_cfg.max_queues);
 
 setup_device:
 	err = gve_setup_device_resources(priv);
@@ -1133,7 +1133,9 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto abort_with_db_bar;
 	}
 	SET_NETDEV_DEV(dev, &pdev->dev);
+
 	pci_set_drvdata(pdev, dev);
+
 	dev->ethtool_ops = &gve_ethtool_ops;
 	dev->netdev_ops = &gve_netdev_ops;
 	/* advertise features */
@@ -1160,11 +1162,16 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->state_flags = 0x0;
 
 	gve_set_probe_in_progress(priv);
+
+	err = register_netdev(dev);
+	if (err)
+		goto abort_with_netdev;
+
 	priv->gve_wq = alloc_ordered_workqueue("gve", 0);
 	if (!priv->gve_wq) {
 		dev_err(&pdev->dev, "Could not allocate workqueue");
 		err = -ENOMEM;
-		goto abort_with_netdev;
+		goto abort_while_registered;
 	}
 	INIT_WORK(&priv->service_task, gve_service_task);
 	priv->tx_cfg.max_queues = max_tx_queues;
@@ -1174,18 +1181,18 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto abort_with_wq;
 
-	err = register_netdev(dev);
-	if (err)
-		goto abort_with_wq;
-
 	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
 	gve_clear_probe_in_progress(priv);
 	queue_work(priv->gve_wq, &priv->service_task);
+
 	return 0;
 
 abort_with_wq:
 	destroy_workqueue(priv->gve_wq);
 
+abort_while_registered:
+	unregister_netdev(dev);
+
 abort_with_netdev:
 	free_netdev(dev);
 
-- 
2.28.0.220.ged08abb693-goog

