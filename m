Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F5A261AC7
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbgIHSkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731867AbgIHSjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:39:19 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45059C061757
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 11:39:19 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q21so204472pgj.4
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 11:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=N/+vqe9kt4/7PabpwUAZkR63g5pOjQWJ8oQ2unDSBQQ=;
        b=N6r9XFIA6nn4B99OCtwi5LRjY3LmZakr8eX0svEfC4rtpS0TtDcgcc0l7VzOBxpB5Z
         um8FiMptB3IQKUJXh3ltMfjAJl2TzRjGPGYkaGlj7+IzWarDoe+gKBLBoxq/4zrBxRgA
         H9Soums8f5j59YjY/gBy6qdjRPXBty0OfNs3WBJKsPhvAVHo/rkVV8ITFo6rnSSEIrS3
         FJgrSmoXO+RrR4MWMu6R8l1GWa/j/M5zpPoXMMlGoJZxhCD4V6ybHd5xUp49wVt/ZppS
         XajzRh/DvZQC2seSHdSw1H3Lv5x/vIGF8nBS2OoXthq/m30a60BEPGJjkOeYnBmUPk+m
         sGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N/+vqe9kt4/7PabpwUAZkR63g5pOjQWJ8oQ2unDSBQQ=;
        b=Bf07UVufy4uEYXuTpRQfutoL1XjtMiRs3mVIqVqBpSBrStK7z74sJGIuf+YgcLdCcB
         FHHYHpHVF1+suj0HTWqXPqiU/ZyG9hPPcU0p9jaDfiwRfglnEhkAxquudNMfCi7ZqjJb
         Ok10QXOgTeTxv7WKoxrtgBtoXj5Z1U4BYDOjgAZYzIg0X0+3aGWKuf8LHkBWTqod6AA8
         73pfvHa8Vq7HoXRp99hmKH42u958tyONSRiP4fD+BUuugBxOJVZlFQY+lQhE8WMgk9gk
         qWSupsQjXM1BeMU++fhKKZHwQJKYbfvKSm4o8bpUk9WZL2VFo+fYio9vhWIedUU7pRiS
         REdw==
X-Gm-Message-State: AOAM531gya85OTfM9Kms3zZiktKlQRS8pCtFSkkbeoENESxK4lmbUj6s
        3VNvK34K4A0ORDff5PVSaDQtxRQRH24VwyMFurfpgGhU3/OAmHp6IXXXdghe9DO21CH2wJOucfG
        eDHVun61UiB05La0EijRHpQbwCb1/xXb8tRIsMBzpLF0Ea7SmSHIy+Alhd0o7RTCu9PZJ0DZ7
X-Google-Smtp-Source: ABdhPJzJL05Df75hOEDbK0dXyXBNCSrFPMfiJAA3v5LBo6JO0+JEfUtzIleiFwRLa9HUxxOew5VmUJj6sNrEW5a7
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a62:1451:0:b029:13e:d13d:a058 with SMTP
 id 78-20020a6214510000b029013ed13da058mr362245pfu.30.1599590358418; Tue, 08
 Sep 2020 11:39:18 -0700 (PDT)
Date:   Tue,  8 Sep 2020 11:39:03 -0700
In-Reply-To: <20200908183909.4156744-1-awogbemila@google.com>
Message-Id: <20200908183909.4156744-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20200908183909.4156744-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next v3 3/9] gve: Use dev_info/err instead of netif_info/err.
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
 drivers/net/ethernet/google/gve/gve_main.c   | 10 +++++-----
 2 files changed, 11 insertions(+), 14 deletions(-)

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
index 4f6c1fc9c58d..0fc68f844edf 100644
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
-- 
2.28.0.526.ge36021eeef-goog

