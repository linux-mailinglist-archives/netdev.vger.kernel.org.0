Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67CA266730
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgIKRji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgIKRjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:39:00 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63520C061786
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:00 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s2so6498557pgm.18
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=N0kdt+2j1dat2YZJNnAdAMKo2xpgQsKToY41ORzkWGM=;
        b=bYkig6Zu0eWvlFK9Wz2tQ2adzYKzQkbBOj9nLSK6/eVnsBW0Beb94A4RZd3y+m6wuK
         ioodyLIqdqfjV1u7gjDXuhVo0eJRuQwvQQN1EalGke9xsQSfdQ5n0BGpRzDYyP7+UR0b
         yht7hUT+h+UJ+Aye+yePmkLnz2wXt6rOTr2rqrbmoO28BRVHVZmsbigDWFqEk6L0mJZy
         W4C3Uzyr78kFtwucXk5xxzK989hxQYVPFhWMw2y/fW9RCYoxzI+3CBLlsDbipf8/NcyZ
         ZXyH9cCLROL7uJdFSKhyxRD/pYEcVsB/VwKoBRHQ9vASPy2V6JD+ErvbA1CVFHCcT9Hr
         tt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N0kdt+2j1dat2YZJNnAdAMKo2xpgQsKToY41ORzkWGM=;
        b=OGzv1VQNB58NO45uYpR8/R0+jqS4mjs/M2bQPrvEn+xOFfAUHicDuRyCfAkMuSLkiL
         UobC+j3nJc1ClT7qiYI0XDgyp8W9th26ctOSPqFYTTZJmf2HTv8lgmlsRYjEPzbvJHuy
         1QBlV4it823uqP/MWGlA3SB3DqCunZlgf224vNSSGyj0F9krpnLvAiTBqdIsg9S1mQyd
         LGKN7sp/9uTsPJ1whI44WDWovMLpOHgL9gZNOTtdFrqBlrhtor4jE47+rUq/QS+MCe/h
         kuvvkDeYIfR1AmCE+71SiY8BLGDAmT5ancxMx21ar6TxDxpDQXg1H5eZgZrqLy465MPP
         1Z5w==
X-Gm-Message-State: AOAM533j/BGuGKiZn+SKBn/aq7NvQGY5EJl299YU4jTFLfQ5GZUtFIVR
        yFz6PAPvyfGuoBTgXI9HG8cn503JuafUOOMhVX+5+W7zjiXpBR485nmE2mriSZ3yL3r8nybH02J
        oMXD2LPAfGTQ55UCAR1vcj59Yow6IuQ+D2dF24GwYj8t+kmQuRYO1CV/Atf9cmTdCl2wox0h4
X-Google-Smtp-Source: ABdhPJxkc06j7mN2taZr9oIdauEBE2Clpl/PUr0GxdNBDXk+1IhK5nkGFCyHT769HC8q3710HVuyzzLSywa1tRnL
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:902:522:b029:d1:9bc8:15df with SMTP
 id 31-20020a1709020522b02900d19bc815dfmr3468944plf.25.1599845939781; Fri, 11
 Sep 2020 10:38:59 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:38:46 -0700
In-Reply-To: <20200911173851.2149095-1-awogbemila@google.com>
Message-Id: <20200911173851.2149095-4-awogbemila@google.com>
Mime-Version: 1.0
References: <20200911173851.2149095-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next v4 3/8] gve: Use dev_info/err instead of netif_info/err.
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
2.28.0.618.gf4bc123cb7-goog

