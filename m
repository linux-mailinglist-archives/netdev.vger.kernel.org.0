Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEA825A101
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgIAVwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgIAVwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:02 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ED2C061247
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:52:02 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id v2so1246675pjh.3
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=oHAl543n3+XdgnsNi5tJ8OOOXJ+WfyTUR/GGlQR3uTs=;
        b=vktDh4NQJh/GKaU/0D1XXYbKZHks1GVpGBef2hUa95MN23rV/TPNaqJELUVV9n5M/F
         gUyloCvdJm9WE8AwEra/bUB2KCZ8L3yOsTDO9qntjG4LoPd3eKJsdkg3j+sxHPOPTolO
         JcZmMuX2g7n29uwjDcg5PeCKYEl82tYZjBzPsCXXnbUFxwLTZucedGMxdKDYPn4d0IHC
         FOuoQRI3SYO7IxJ2eqX+La7FFexajfC9JEUVxoGWW7ccmaVBjBSrVOwAbGG1pS+V8Atn
         v/mxzINQIq4C/Idus7X0tt9E4LB24nEvYKcPCLNSxI40kxPMCVzSiMqkrrY4HbuuipTW
         uqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oHAl543n3+XdgnsNi5tJ8OOOXJ+WfyTUR/GGlQR3uTs=;
        b=gI+gensnzHR3HrW3Q5/Y1QObcUj7Vd166wBBe3+vyd5rDwSxYHkl3oJt3JzfP/ZcFS
         u9bopnYDwx0/oUnM/eutFMXCiE7gdUX2YYbMJ7PlsWxxklk65FgjIPi0E/hfWD1Lq0gf
         pHRlDd8ep6ZuAOHw3vKpB2sM+GMY+DoLBFxji1osyNs4UjWPdnl44IWwuRkOcF6sUuER
         d15d5NxMX3nYtrrsB5NRMYVGJKVS65GiIByO+uKqhVxncq8+aPInj30dJ9P6UIScsfa6
         gudA8rZNp4h7H5hLfsxwdjcHkDiijdywOpscvy3MCrJ4BBnb35l+1gyNecd6skNXmbiZ
         TjDQ==
X-Gm-Message-State: AOAM531t1gn1RpdgELYrh9JNi7mgvKqrx6ErMUDeCQXwf9zHWXepkpeE
        3GW/iu9z6WHKF1wcR6XglW/Y4PMDHH1AkWQx7uH8apP0ISg/9l9eVOwifKO8MflnAOcevobrnzF
        pbU3kEYInCvT+yNKxQOIuBbreKyy5o5p2RQFHrcmrq9eRFdX/zej95CubIg/tLHEFZnX5AOKh
X-Google-Smtp-Source: ABdhPJwDrKzl7/r8WfdMEfXo2hPMVkFhiY7AFCodQppaPUY3Vpi5HJI15dIX9srtlABQ307oFzKaspvACyIfVaaQ
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90a:f117:: with SMTP id
 cc23mr3397642pjb.155.1598997122211; Tue, 01 Sep 2020 14:52:02 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:43 -0700
In-Reply-To: <20200901215149.2685117-1-awogbemila@google.com>
Message-Id: <20200901215149.2685117-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 3/9] gve: Use dev_info/err instead of netif_info/err.
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

Update the driver to use dev_info/err instead of netif_info/err.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 15 ++++++---------
 drivers/net/ethernet/google/gve/gve_main.c   | 14 +++++++++-----
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 529de756ff9b..d9aed217c1d6 100644
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
index 4f6c1fc9c58d..a0b8c1e8ed98 100644
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
@@ -1160,6 +1162,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->state_flags = 0x0;
 
 	gve_set_probe_in_progress(priv);
+
 	priv->gve_wq = alloc_ordered_workqueue("gve", 0);
 	if (!priv->gve_wq) {
 		dev_err(&pdev->dev, "Could not allocate workqueue");
@@ -1181,6 +1184,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
 	gve_clear_probe_in_progress(priv);
 	queue_work(priv->gve_wq, &priv->service_task);
+
 	return 0;
 
 abort_with_wq:
-- 
2.28.0.402.g5ffc5be6b7-goog

