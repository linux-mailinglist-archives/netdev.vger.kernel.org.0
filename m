Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3B041F45A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355724AbhJASIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355691AbhJASIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 14:08:30 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4944BC06177E
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 11:06:46 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s16so8682118pfk.0
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 11:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2VaLxtyGqc9TJ9gj4cYDhZgXwkUEzupqxOTecBk+ONI=;
        b=YmX6bW8C99tBjmpDNEkOvJaiRrsPQ6ilZ14DQMqYb44lsrC2UZRpN5UDHottiqIjKe
         FjUWGAYDj+ZY3KiP5RVwfXW2ADFObSkFOGcsTKTooBPQY0uQaDRx++LdMh437g1IqOho
         +CR8A/DjhA1OcYZXI/vsO39A42dv5EIkkXbBa0JAZSAkOWhMuzc6ya2zRjRMuSXJA26g
         yrBOEEuU8yuMmYw+HQI3O+YEYDQDB8HGOAGt2YyPAmGY6EKKrVlG690/Ca4qhiiDei06
         AEMouhPJ84xT9Qd63I0vMlyd50RyE1gwtkKgw+gTiriTDGZs2MUFmualCzKfVEtR/ON1
         SJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2VaLxtyGqc9TJ9gj4cYDhZgXwkUEzupqxOTecBk+ONI=;
        b=daalcl2bZVcxBTscwVEpeam/NEbVZ6CKTzTJ5Pplar07o2tT2ZPIjA9v4E0UMKNZtT
         C5unGYOvt4W13Pnl2iSGP3k9cD8AHM0nMThiuOXsloXztMBpmrRXinMcjE+2ze9N458w
         YSocBK1VnYjqK5+0aX9ALzHlI3/+LSBiTL0pZygHjcTiikGozbnO5rHia98zqY4SF2r9
         yczMIrIY0Gu7rHzaLMZQt+FHBfZQraLe4KGwcxooHo1+kykTb8LjByY49RJbt7rbYXxS
         xhS1jj2ABqPKCwkOwwRaQP2Ca6mBrN6MYIhiQrbfiwd3lHPVeSgqYclVy5PO6UL4Y7Ec
         Z//A==
X-Gm-Message-State: AOAM5318Lq428/aIyvpcwR8+1u7UKfBn8PWcMSiVwj5fuxdpO3Dr1jGx
        1l8ftkI4QInY9cf7wJ7qLBfQFQ==
X-Google-Smtp-Source: ABdhPJws9G5YLX5uWgMnWhVY3z3GqimWmpw3plgUUwBkoHIKYYTIZLVr/WmGLvowZhkRLQHlv1PHsw==
X-Received: by 2002:a05:6a00:88e:b0:44c:c40:9279 with SMTP id q14-20020a056a00088e00b0044c0c409279mr6749252pfj.85.1633111605860;
        Fri, 01 Oct 2021 11:06:45 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm6409384pjd.33.2021.10.01.11.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 11:06:45 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 7/7] ionic: add lif param to ionic_qcq_disable
Date:   Fri,  1 Oct 2021 11:05:57 -0700
Message-Id: <20211001180557.23464-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001180557.23464-1-snelson@pensando.io>
References: <20211001180557.23464-1-snelson@pensando.io>
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

