Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E8D129C4D
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 02:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfLXBBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 20:01:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50016 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726865AbfLXBBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 20:01:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577149312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lNR8caCFuSaW15vNt0X+BCpE9Gkglp0py4B5ycCfZsA=;
        b=JQj378zDuv6WNysmPImBy44oa0jtqNH/QQjaRKtRGKfZ/XZMsQzhTsA3srGFlt484er2PS
        MhCiYed+dCA3OpGpM4og9iszN7FDgTSa4+1jHQN4l9YPH5l9Sr1RcvhZpMH14hoWcCAugm
        3An7dFA/5XqDWBEVYq6Xa57eBSHBqvw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-2AEX2kwxMFGpyRGU1mcU8w-1; Mon, 23 Dec 2019 20:01:46 -0500
X-MC-Unique: 2AEX2kwxMFGpyRGU1mcU8w-1
Received: by mail-wr1-f72.google.com with SMTP id y7so8835459wrm.3
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 17:01:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lNR8caCFuSaW15vNt0X+BCpE9Gkglp0py4B5ycCfZsA=;
        b=qGJGu7aG+z5HBrX6V9IhQKPdIqFl/KsHrdbsTsG+d5k0CHI9iMYf1fv/mc1191Ifdu
         8DZP3LpmTFSQRbkL8o5qsoXAm3wCwdb2E7IHO/UaW2iiG+FtEdB954gGzYS/a3baOjVE
         EZvmovK8MiJf2+18FfsDRQ++Yfhat6JoZELstJ9AJt0AL1W0rqID3+7LEoJbb8t+JbfC
         JTLuiIl0p5As9+555S5GxCM8O06MEDhE8tKfQnYpfMkBXSqrMEDoIMZRb9EoDMRmvGB9
         dHrYovtRy/dG4omqv/cjT5mu59Kdj0pANfOd49BCGGnqpzjLsUiIs05n8KBzeKLfzNRn
         7Z2w==
X-Gm-Message-State: APjAAAVJKClrhCBFFxt2gWopgLAe+4CYpugudYLTk9Gb0sT0AlfA/tLW
        uQdagImaSYvGEXUeBGpIwd0svVapnIaVKQ9qyEgFHnS1np9PfdZ6CmaZS5llOi599pjJSNWhxt5
        A0m8VhKYiZ8Ds6D05
X-Received: by 2002:a1c:a543:: with SMTP id o64mr1343952wme.108.1577149304964;
        Mon, 23 Dec 2019 17:01:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqwLbp9ysb39KhPxYI6LO1wfaY27/OAdRJojrU1rwE2sB5KzOrsO0TbdDO9yelLn37HkmqW28w==
X-Received: by 2002:a1c:a543:: with SMTP id o64mr1343939wme.108.1577149304792;
        Mon, 23 Dec 2019 17:01:44 -0800 (PST)
Received: from mcroce-redhat.homenet.telecomitalia.it (host213-32-dynamic.19-79-r.retail.telecomitalia.it. [79.19.32.213])
        by smtp.gmail.com with ESMTPSA id e18sm22330532wrw.70.2019.12.23.17.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 17:01:44 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tomislav Tomasic <tomislav.tomasic@sartura.hr>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Nadav Haklai <nadavh@marvell.com>
Subject: [RFC net-next 2/2] mvpp2: memory accounting
Date:   Tue, 24 Dec 2019 02:01:03 +0100
Message-Id: <20191224010103.56407-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191224010103.56407-1-mcroce@redhat.com>
References: <20191224010103.56407-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the XDP API for memory accounting.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  3 ++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 31 ++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 67b3bf0d3c8b..ffd633e0a3be 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1165,6 +1165,9 @@ struct mvpp2_rx_queue {
 
 	/* Port's logic RXQ number to which physical RXQ is mapped */
 	int logic_rxq;
+
+	/* XDP memory accounting */
+	struct xdp_rxq_info xdp_rxq;
 };
 
 struct mvpp2_bm_pool {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 4edb81c8941f..3b0aac66ac52 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2405,10 +2405,11 @@ static int mvpp2_aggr_txq_init(struct platform_device *pdev,
 /* Create a specified Rx queue */
 static int mvpp2_rxq_init(struct mvpp2_port *port,
 			  struct mvpp2_rx_queue *rxq)
-
 {
+	struct mvpp2 *priv = port->priv;
 	unsigned int thread;
 	u32 rxq_dma;
+	int err;
 
 	rxq->size = port->rx_ring_size;
 
@@ -2446,7 +2447,35 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
 	/* Add number of descriptors ready for receiving packets */
 	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
 
+	err = xdp_rxq_info_reg(&rxq->xdp_rxq, port->dev, rxq->id);
+	if (err < 0)
+		goto err_free_dma;
+
+	if (priv->percpu_pools) {
+		/* Every RXQ has a pool for short and another for long packets */
+		err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq,
+						 MEM_TYPE_PAGE_POOL,
+						 priv->page_pool[rxq->logic_rxq]);
+		if (err < 0)
+			goto err_unregister_rxq;
+
+		err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq,
+						 MEM_TYPE_PAGE_POOL,
+						 priv->page_pool[rxq->logic_rxq +
+								 port->nrxqs]);
+		if (err < 0)
+			goto err_unregister_rxq;
+	}
+
 	return 0;
+
+err_unregister_rxq:
+	xdp_rxq_info_unreg(&rxq->xdp_rxq);
+err_free_dma:
+	dma_free_coherent(port->dev->dev.parent,
+			  rxq->size * MVPP2_DESC_ALIGNED_SIZE,
+			  rxq->descs, rxq->descs_dma);
+	return err;
 }
 
 /* Push packets received by the RXQ to BM pool */
-- 
2.24.1

