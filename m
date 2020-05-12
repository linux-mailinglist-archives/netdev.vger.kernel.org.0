Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D691CE9E5
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgELBAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbgELA77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:59:59 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F172BC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:57 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f6so5368045pgm.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FppOT3huqldEMCkKgTI0yDPNlvD/EFSFA7HbJTAex7Y=;
        b=BmQ4BBmgEhj12ApzEwg/OZB3fzCxPQi2STg5HWaU7NxIqiQuA8GUDViMWBjAAmrJkR
         puOTUjDj+XO5KKbIWV/bcFkgI2WDgHS4cW1llBrvSMW380QFzGyPZV2rwFTzuS+9IyQc
         EhphhK2eRQYjkKw/KtqfsxZCJLCEUg+AbWou7MKJK6vqTFZYVPOS3/zR9FP7xwKy+apy
         o2tIQQ7fCXpGX/i4PzENm8cb5y0lv3YZtUCD8UpvAkIofnfr1eTAK8v0TPbazRAnJhRp
         yNJkavymbPCCDak+igk1A7ghoEx1IZ9SSHUsjzip0LnTIafk0pXNpjIycn1zPdsdBmKe
         S9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FppOT3huqldEMCkKgTI0yDPNlvD/EFSFA7HbJTAex7Y=;
        b=YbE9PpnVhRkc+tL6RrwrqLoENR6z0OwLfsOuN6LbFkeG6AonOcxhRFasnOPoStwelC
         PUfbwjjxc5kbjvPHy01yVOmNGw9x2kYkn/+MH5sI7ulw6jYcSKA7vbjw1BWPkshIESGz
         M3eC0DNBo/5GmmYgByO/yrQd09WzobJi9+JG1fyQT4qGd3VLFnss3IRw1vvGFsdgGQ0x
         je/+oGyb1URnyMmnBnf8kVFwmTEyjg137gyDNlL5EmUU6NtF2x2rI37oDNWL6NN9H/VX
         rJ252NXJFJYWu6knQwRQ8dg6GA2FzkJNUfvTTNwLjiTBiZw3wndVyAYbt2Wh/7G5WRW5
         b6xQ==
X-Gm-Message-State: AGi0PubEPm/J09FGvY80ADBIsxBS7/nNiMG7RsB9NTiL6P+ccjwa9wcc
        xteDjbMhX334Q89uToUmvvjF5PdUiJc=
X-Google-Smtp-Source: APiQypLkyM5Vg4v9qHSouqLKDTVkVT24zmW/FrhEZljjt6eCbAbcuTM/tjdL8pmWS2FbZ1bcF8hM8Q==
X-Received: by 2002:a62:7555:: with SMTP id q82mr18541639pfc.136.1589245196853;
        Mon, 11 May 2020 17:59:56 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:56 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 07/10] ionic: ionic_intr_free parameter change
Date:   Mon, 11 May 2020 17:59:33 -0700
Message-Id: <20200512005936.14490-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the ionic_intr_free parameter from struct ionic_lif to
struct ionic since that's what it actually cares about.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5f63c611d1fd..9bf142446645 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -197,10 +197,10 @@ static int ionic_intr_alloc(struct ionic_lif *lif, struct ionic_intr_info *intr)
 	return 0;
 }
 
-static void ionic_intr_free(struct ionic_lif *lif, int index)
+static void ionic_intr_free(struct ionic *ionic, int index)
 {
-	if (index != INTR_INDEX_NOT_ASSIGNED && index < lif->ionic->nintrs)
-		clear_bit(index, lif->ionic->intrs);
+	if (index != INTR_INDEX_NOT_ASSIGNED && index < ionic->nintrs)
+		clear_bit(index, ionic->intrs);
 }
 
 static int ionic_qcq_enable(struct ionic_qcq *qcq)
@@ -310,7 +310,7 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		irq_set_affinity_hint(qcq->intr.vector, NULL);
 		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
 		qcq->intr.vector = 0;
-		ionic_intr_free(lif, qcq->intr.index);
+		ionic_intr_free(lif->ionic, qcq->intr.index);
 	}
 
 	devm_kfree(dev, qcq->cq.info);
@@ -356,7 +356,7 @@ static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
 				      struct ionic_qcq *n_qcq)
 {
 	if (WARN_ON(n_qcq->flags & IONIC_QCQ_F_INTR)) {
-		ionic_intr_free(n_qcq->cq.lif, n_qcq->intr.index);
+		ionic_intr_free(n_qcq->cq.lif->ionic, n_qcq->intr.index);
 		n_qcq->flags &= ~IONIC_QCQ_F_INTR;
 	}
 
@@ -508,7 +508,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		devm_free_irq(dev, new->intr.vector, &new->napi);
 err_out_free_intr:
 	if (flags & IONIC_QCQ_F_INTR)
-		ionic_intr_free(lif, new->intr.index);
+		ionic_intr_free(lif->ionic, new->intr.index);
 err_out:
 	dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
 	return err;
-- 
2.17.1

