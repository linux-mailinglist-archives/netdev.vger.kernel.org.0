Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B52441F33D
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355351AbhJARk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354890AbhJARkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:40:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6145CC06177D
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:38:34 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so9841301pjc.3
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2VaLxtyGqc9TJ9gj4cYDhZgXwkUEzupqxOTecBk+ONI=;
        b=qtjYxaoLdBIucaGFza3q5UMa8Z9aCR/hwfUEsYGH0udkJDg5hTOVswDRzmRzjZrLt3
         9K2qgGecxldSC+FV5CXnqmc/w2g0MSZcWr97V5K8CTWyyeznQpG+HLYct5aGhpuHMd7z
         7xnR2w6YfCKRK4wU/XE2D7+b8eeJMdEQq+EfDj5A5rQZcmRuGWQEuBsB+R71wRfmdpKS
         TIsyWFkvuQ+JBJrI83c8okv/r94FvzXyL9y3DsHXBZLR1b31JR/m65PkZUhJpQGYWCCG
         JChlDWM0ki8fTFvmYJW90PycZzi6JWAxkbefeWDS8yCbdcIlAsgvspr6tkQfURJZiPrq
         bIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2VaLxtyGqc9TJ9gj4cYDhZgXwkUEzupqxOTecBk+ONI=;
        b=lY7McCnSS/4a5aBkEQp8uzjE96nfwrOO3eKDaKcIJvO+0s0WDofYAnoI52VHId9oxm
         2cpfJSUGW8N4JwIQJZ0f8pS2GExjkaYBiBJNWndaozz2cCihdjIcUKr/Et9V/LrCe9ry
         iVtweI3LzTKP0TU9DMJrmCbYfPNPAs9vmDaMViG3CZa8pfK0W/kfAsXjPyLRh/d6fs7m
         Fvz5OqLlA0CQSAnRk8sTWzMrrQDIbJtvl/NzLhd5obT6w/VhOW+sjgUnyuUskZU8pv/2
         e+CZN1u+VCVmy43quji7YJHtoChHl1RiNuVWdH5iG3MBmtQzqjsw96YQh3BLLJH7z67y
         4aRg==
X-Gm-Message-State: AOAM532JuHIFZwXQHSMp2PSGD3PmMvIm4nNdL1FoTAZZj5iN7IYhwkno
        FT6PU1E9cTOg+i7uW1Ju1J1wUw==
X-Google-Smtp-Source: ABdhPJzFyAO79v+dSm1zO/lnvzqVsfZSviiO3VqseGqtoMRB1t4hwVvLd30/zkcz8ipjpjUIP9da5g==
X-Received: by 2002:a17:90a:d589:: with SMTP id v9mr14646373pju.2.1633109913964;
        Fri, 01 Oct 2021 10:38:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 26sm7854462pgx.72.2021.10.01.10.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:38:33 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 7/7] ionic: add lif param to ionic_qcq_disable
Date:   Fri,  1 Oct 2021 10:37:58 -0700
Message-Id: <20211001173758.22072-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001173758.22072-1-snelson@pensando.io>
References: <20211001173758.22072-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the lif parameter for use in an error message, and
to better match the style of most of the functions calls.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 16d98bb55178..5c020a263f0c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -287,10 +287,9 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 	return ionic_adminq_post_wait(lif, &ctx);
 }
 
-static int ionic_qcq_disable(struct ionic_qcq *qcq, int fw_err)
+static int ionic_qcq_disable(struct ionic_lif *lif, struct ionic_qcq *qcq, int fw_err)
 {
 	struct ionic_queue *q;
-	struct ionic_lif *lif;
 
 	struct ionic_admin_ctx ctx = {
 		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
@@ -300,11 +299,12 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq, int fw_err)
 		},
 	};
 
-	if (!qcq)
+	if (!qcq) {
+		netdev_err(lif->netdev, "%s: bad qcq\n", __func__);
 		return -ENXIO;
+	}
 
 	q = &qcq->q;
-	lif = q->lif;
 
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		struct ionic_dev *idev = &lif->ionic->idev;
@@ -1948,19 +1948,19 @@ static void ionic_txrx_disable(struct ionic_lif *lif)
 
 	if (lif->txqcqs) {
 		for (i = 0; i < lif->nxqs; i++)
-			err = ionic_qcq_disable(lif->txqcqs[i], err);
+			err = ionic_qcq_disable(lif, lif->txqcqs[i], err);
 	}
 
 	if (lif->hwstamp_txq)
-		err = ionic_qcq_disable(lif->hwstamp_txq, err);
+		err = ionic_qcq_disable(lif, lif->hwstamp_txq, err);
 
 	if (lif->rxqcqs) {
 		for (i = 0; i < lif->nxqs; i++)
-			err = ionic_qcq_disable(lif->rxqcqs[i], err);
+			err = ionic_qcq_disable(lif, lif->rxqcqs[i], err);
 	}
 
 	if (lif->hwstamp_rxq)
-		err = ionic_qcq_disable(lif->hwstamp_rxq, err);
+		err = ionic_qcq_disable(lif, lif->hwstamp_rxq, err);
 
 	ionic_lif_quiesce(lif);
 }
@@ -2160,7 +2160,7 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 		err = ionic_qcq_enable(lif->txqcqs[i]);
 		if (err) {
-			derr = ionic_qcq_disable(lif->rxqcqs[i], err);
+			derr = ionic_qcq_disable(lif, lif->rxqcqs[i], err);
 			goto err_out;
 		}
 	}
@@ -2182,13 +2182,13 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 err_out_hwstamp_tx:
 	if (lif->hwstamp_rxq)
-		derr = ionic_qcq_disable(lif->hwstamp_rxq, derr);
+		derr = ionic_qcq_disable(lif, lif->hwstamp_rxq, derr);
 err_out_hwstamp_rx:
 	i = lif->nxqs;
 err_out:
 	while (i--) {
-		derr = ionic_qcq_disable(lif->txqcqs[i], derr);
-		derr = ionic_qcq_disable(lif->rxqcqs[i], derr);
+		derr = ionic_qcq_disable(lif, lif->txqcqs[i], derr);
+		derr = ionic_qcq_disable(lif, lif->rxqcqs[i], derr);
 	}
 
 	return err;
-- 
2.17.1

