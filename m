Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79B6254C92
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgH0SHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbgH0SHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:07:52 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC249C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:51 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t185so4105965pfd.13
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9Dcu0ODgktyQopGmsvvfnLYcxiTT+wl+JncOEgcVoIU=;
        b=iv9ua9E8ZZlu3IrlDH9jqBBa5BYrIZN6elmiD3TUbUjjwaaIS6nDukfRi1A+r86ae4
         MQS1yDIVDjl71gzge50mzTrooWk4Hp52rxN9CbVj1xMSeH1H2NjS5mqiE9QNTrVkWwxT
         y95HCWi//tgPWtZc4GlSoU7PwQsU+MHpylcZRGuwFSRbwZ1A54fY0MAZozUk0F2aA4tt
         f1NHSqsWh+tgJDpKxYIk5TD4gOjjQ7XECVgA4WnJrCmheodadsK7/M3dPBI9Lnic/gjL
         zvTfWAnjYoZChTMYm7j5ndAlqAY3n2zNZo0JIx/Kd77UFr0SQwfr3szGDiJYeuNqgyom
         0mXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9Dcu0ODgktyQopGmsvvfnLYcxiTT+wl+JncOEgcVoIU=;
        b=s5MOPx4H1U26bKbTZfr8Mkv/vYen3fgO7sisr0NjJxMKHEMgHidYIgmBxBNvwHvu26
         qGtxqlS5T5RdLxfPfgst28OHpzPqFTX8I9vwg/BtAPautGMXKfRXL+jix2L6wAoB0Duo
         9maltEEVe9EHiWM1gWaWBZ45xqQtMo7JMnkHVfWz1fAI0r7T36TH9B2PNxbUXluuNaBw
         GgPw+Lj0IJT3nHMEtnY0VXM3oKtPyb7YosmURseliq5oiT1bQQ9EQ2vmO1tJ3UOoIqJo
         kDHhAbcaR10M9XXEVkP4MR2FIzgbWPT8f6KkQ/tQrVPI6kDEC824pVfR2zUErhBNzLnQ
         WfjA==
X-Gm-Message-State: AOAM531GAzuK6ULT6ByC8x3QvOEFYb04gfhpQFvpDpOolFCoiVlVlnQT
        TecXdYCnc6awd9R+oDigfd5kT+uwePr/Ig==
X-Google-Smtp-Source: ABdhPJyZYRRhzLL2UlK51GXIn8dg/AlpoIwKzmBCkIfS9gI4xHPUI6rPdEU/IUNGu7nT0r+zBEETmw==
X-Received: by 2002:a17:902:7445:: with SMTP id e5mr17511388plt.233.1598551671179;
        Thu, 27 Aug 2020 11:07:51 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n1sm3480249pfu.2.2020.08.27.11.07.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 11:07:50 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 03/12] ionic: use kcalloc for new arrays
Date:   Thu, 27 Aug 2020 11:07:26 -0700
Message-Id: <20200827180735.38166-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827180735.38166-1-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kcalloc for allocating arrays of structures.

Following along after
commit e71642009cbdA ("ionic_lif: Use devm_kcalloc() in ionic_qcq_alloc()")
there are a couple more array allocations that can be converted
to using devm_kcalloc().

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e95e3fa8840a..d73beddc30cc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -522,7 +522,6 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 static int ionic_qcqs_alloc(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
-	unsigned int q_list_size;
 	unsigned int flags;
 	int err;
 	int i;
@@ -552,9 +551,9 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 		ionic_link_qcq_interrupts(lif->adminqcq, lif->notifyqcq);
 	}
 
-	q_list_size = sizeof(*lif->txqcqs) * lif->nxqs;
 	err = -ENOMEM;
-	lif->txqcqs = devm_kzalloc(dev, q_list_size, GFP_KERNEL);
+	lif->txqcqs = devm_kcalloc(dev, lif->ionic->ntxqs_per_lif,
+				   sizeof(*lif->txqcqs), GFP_KERNEL);
 	if (!lif->txqcqs)
 		goto err_out_free_notifyqcq;
 	for (i = 0; i < lif->nxqs; i++) {
@@ -565,7 +564,8 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 			goto err_out_free_tx_stats;
 	}
 
-	lif->rxqcqs = devm_kzalloc(dev, q_list_size, GFP_KERNEL);
+	lif->rxqcqs = devm_kcalloc(dev, lif->ionic->nrxqs_per_lif,
+				   sizeof(*lif->rxqcqs), GFP_KERNEL);
 	if (!lif->rxqcqs)
 		goto err_out_free_tx_stats;
 	for (i = 0; i < lif->nxqs; i++) {
-- 
2.17.1

