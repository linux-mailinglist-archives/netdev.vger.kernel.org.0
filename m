Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E8A258475
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 01:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgHaXgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 19:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgHaXgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 19:36:14 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028B5C061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:13 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c142so1588715pfb.7
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DFYo8QIYjtFOqJXeDBuNjkJ3G9hImanULIk67aS8k5A=;
        b=uidExLppvfcyV8m/yiPsgP21OKNkM5EpHyMmyW/OpqjrcAjfJcLBWKTm/WPJl311/G
         SELJ1JcR5u0lyojnWJeoH92xOoYPuDdhW2TRqxwGR3bgrribYw9D+t/p0rmffnbVXzWd
         //1IOinjLcxcKJtXvD29oh2q3A5QKfDQPTgH6/cvnmBwGdRNnYKyjz2XsmzVHT164q1j
         G2KnkwYvuh/oFpRFcI9JXjOrl3V5pcagugNKSYSr3xW8DkCU2mGQtbM68JZFHcHthoG8
         VIm+4qjMERy87sW3IW0tiM0XeP+xekYfNcg6mVJPrVl8sYt+0DmKCzX6VPSmzTOLzlZ6
         UnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DFYo8QIYjtFOqJXeDBuNjkJ3G9hImanULIk67aS8k5A=;
        b=py9IFp550IpcaDkTXEoGEkx+iRg+44utlcrJ/4Du5iLhwGbthuIeHXjUvrr636qH7V
         3KOJk8oOCXr/i+0oZxXOkEBUiALL8xfPZnXuHOLJlBmRrvuYMNfemGMIGnQjDNR5V3xS
         gchoNawSHnj1woxVnUtualTEvGQb9Qd5csKx1UOzb7WQS134NXXt+16Yx/vW48JiHkfD
         qrFslpbjSab2rfeU2vbAksHqZNOw8p0gQrRrsHjKTV9W1X4PvARgwMQ98/mmdKOc3sFg
         nU5YZjg4cJwrO0S5kK4yLwoz13kCU5zoTf5mb6wpOclu8lOXpuuWIO+oqF2Aq9dfHt4b
         TC7A==
X-Gm-Message-State: AOAM532MvlbdtOgTi6O1g64eDUDELUbTBsq+vcd/sEm4e+m0SjSazNW4
        +SvjSiYBNTHWlGg7oFDZbF/bXL8lMLS+tg==
X-Google-Smtp-Source: ABdhPJzvnyQagwRK4bjJL8rFlOrp6SNj7xqWTcbhRZ/rZbTus/6e92Z7VJlEY5ZBLm6XaTfUdV4FWA==
X-Received: by 2002:a63:ca4e:: with SMTP id o14mr3182799pgi.213.1598916972958;
        Mon, 31 Aug 2020 16:36:12 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 65sm9082651pfx.104.2020.08.31.16.36.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2020 16:36:11 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>, Neel Patel <neel@pensando.io>
Subject: [PATCH net-next 5/5] ionic: clean adminq service routine
Date:   Mon, 31 Aug 2020 16:35:58 -0700
Message-Id: <20200831233558.71417-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831233558.71417-1-snelson@pensando.io>
References: <20200831233558.71417-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only thing calling ionic_napi any more is the adminq
processing, so combine and simplify.

Signed-off-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  3 --
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 44 +++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_main.c  | 26 -----------
 3 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index f699ed19eb4f..084a924431d5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -64,9 +64,6 @@ struct ionic_admin_ctx {
 	union ionic_adminq_comp comp;
 };
 
-int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
-	       ionic_cq_done_cb done_cb, void *done_arg);
-
 int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
 int ionic_set_dma_mask(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index eeaa73650986..ee683cb142a8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -800,21 +800,6 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 	return true;
 }
 
-static int ionic_notifyq_clean(struct ionic_lif *lif, int budget)
-{
-	struct ionic_dev *idev = &lif->ionic->idev;
-	struct ionic_cq *cq = &lif->notifyqcq->cq;
-	u32 work_done;
-
-	work_done = ionic_cq_service(cq, budget, ionic_notifyq_service,
-				     NULL, NULL);
-	if (work_done)
-		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
-				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
-
-	return work_done;
-}
-
 static bool ionic_adminq_service(struct ionic_cq *cq,
 				 struct ionic_cq_info *cq_info)
 {
@@ -830,15 +815,36 @@ static bool ionic_adminq_service(struct ionic_cq *cq,
 
 static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 {
+	struct ionic_intr_info *intr = napi_to_cq(napi)->bound_intr;
 	struct ionic_lif *lif = napi_to_cq(napi)->lif;
+	struct ionic_dev *idev = &lif->ionic->idev;
+	unsigned int flags = 0;
 	int n_work = 0;
 	int a_work = 0;
+	int work_done;
+
+	if (lif->notifyqcq && lif->notifyqcq->flags & IONIC_QCQ_F_INITED)
+		n_work = ionic_cq_service(&lif->notifyqcq->cq, budget,
+					  ionic_notifyq_service, NULL, NULL);
 
-	if (likely(lif->notifyqcq && lif->notifyqcq->flags & IONIC_QCQ_F_INITED))
-		n_work = ionic_notifyq_clean(lif, budget);
-	a_work = ionic_napi(napi, budget, ionic_adminq_service, NULL, NULL);
+	if (lif->adminqcq && lif->adminqcq->flags & IONIC_QCQ_F_INITED)
+		a_work = ionic_cq_service(&lif->adminqcq->cq, budget,
+					  ionic_adminq_service, NULL, NULL);
+
+	work_done = max(n_work, a_work);
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		flags |= IONIC_INTR_CRED_UNMASK;
+		DEBUG_STATS_INTR_REARM(intr);
+	}
 
-	return max(n_work, a_work);
+	if (work_done || flags) {
+		flags |= IONIC_INTR_CRED_RESET_COALESCE;
+		ionic_intr_credits(idev->intr_ctrl,
+				   intr->index,
+				   n_work + a_work, flags);
+	}
+
+	return work_done;
 }
 
 void ionic_get_stats64(struct net_device *netdev,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 2b72a51be1d0..cfb90bf605fe 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -305,32 +305,6 @@ int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 	return ionic_adminq_check_err(lif, ctx, (remaining == 0));
 }
 
-int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
-	       ionic_cq_done_cb done_cb, void *done_arg)
-{
-	struct ionic_qcq *qcq = napi_to_qcq(napi);
-	struct ionic_cq *cq = &qcq->cq;
-	u32 work_done, flags = 0;
-
-	work_done = ionic_cq_service(cq, budget, cb, done_cb, done_arg);
-
-	if (work_done < budget && napi_complete_done(napi, work_done)) {
-		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(cq->bound_intr);
-	}
-
-	if (work_done || flags) {
-		flags |= IONIC_INTR_CRED_RESET_COALESCE;
-		ionic_intr_credits(cq->lif->ionic->idev.intr_ctrl,
-				   cq->bound_intr->index,
-				   work_done, flags);
-	}
-
-	DEBUG_STATS_NAPI_POLL(qcq, work_done);
-
-	return work_done;
-}
-
 static void ionic_dev_cmd_clean(struct ionic *ionic)
 {
 	union ionic_dev_cmd_regs *regs = ionic->idev.dev_cmd_regs;
-- 
2.17.1

