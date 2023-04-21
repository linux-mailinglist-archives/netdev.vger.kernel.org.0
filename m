Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684256EA1F4
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbjDUCvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbjDUCvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:51:14 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C9049C2;
        Thu, 20 Apr 2023 19:51:12 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b8b19901fso2243040b3a.3;
        Thu, 20 Apr 2023 19:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682045472; x=1684637472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KIwAxCs+xB0lesjbp62PO3r6+mEINYjwnW6XfaYSSdQ=;
        b=kuAIo58vZB1+qpKj9vHhK3ZK1gJVwSkzhEOvNl61GQlj9K2oUor4omQ++jwf+nzfIi
         sCkhXcZ9qrATu4V6fTz5ckRvJl/CyasxWjZDPEXg8GYjZmgbeS6xmY6yHeaQt/TIOnuF
         Y21XyflrnxJ7BtEGDyTFEY4FGU5Z8U49UJD8FleH6XmqEmGhvo9TJ49rr+7WSW0V4QCl
         p7TjHk3RBvGRQOGCk/mKI8cREbP3gqVF2EMcZvug7EWVSxneWt7O8LjN5nQrlG3QPL36
         2PhChguV2Naq0J3hSqUYEd1ZBwa7RpfO3v2JpkN21Ck1qtJCepDiTW0IWcmdIbYYrMkf
         kpDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682045472; x=1684637472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KIwAxCs+xB0lesjbp62PO3r6+mEINYjwnW6XfaYSSdQ=;
        b=JL0o241HNZOWZAzXvYhOI6OowGepWDYnMXDC0u4noZ3QQeRRUgV0Gk8Jzfyy3+t+3m
         jLpPY1PJxm3VFL3VEYHyx6tyM70pIHlv8M6B6eFwFI0suJMCAytjl6e69FDpr3Q2GZjD
         lHzIo3KQg6tqXzyT2UqNdPr31syTWw5YFvAh2QkuzmLoNfE6BhpiVQgKk9P6vINuF+G6
         Dijs9f3U4Pp/hYsDyoebx3mEq+x57E7MBAsOacMww2bt2j5WQdJ289D9jLEhQ6j9u2pn
         65R/dSIuqzHuU0qIziPB1XYFb6eMyVz/rnSMv3bdJ8omNwhnUC1/YE+0UJ6/doeaXTa3
         7KZw==
X-Gm-Message-State: AAQBX9eVSp7qLxo6RGaS64pudwYuklgLZZPSK0zx+DeYA4F41fh0LLKN
        E26iFDP7xig1K2GssMpUQC0=
X-Google-Smtp-Source: AKy350bWFtfugUfcWh97iRcdYWPpTtpybaRXOXuPoe4hh6KcFz0CtHBbytmKYJWUqIscguV/I+fyBw==
X-Received: by 2002:a05:6a21:29cb:b0:f0:2893:8a3d with SMTP id tv11-20020a056a2129cb00b000f028938a3dmr3457859pzb.45.1682045471653;
        Thu, 20 Apr 2023 19:51:11 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id bl11-20020a056a00280b00b0063b1b84d54csm1881841pfb.213.2023.04.20.19.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 19:51:11 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From:   Tejun Heo <tj@kernel.org>
To:     jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Tejun Heo <tj@kernel.org>,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH 11/22] net: wwan: t7xx: Use alloc_ordered_workqueue() to create ordered workqueues
Date:   Thu, 20 Apr 2023 16:50:35 -1000
Message-Id: <20230421025046.4008499-12-tj@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421025046.4008499-1-tj@kernel.org>
References: <20230421025046.4008499-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BACKGROUND
==========

When multiple work items are queued to a workqueue, their execution order
doesn't match the queueing order. They may get executed in any order and
simultaneously. When fully serialized execution - one by one in the queueing
order - is needed, an ordered workqueue should be used which can be created
with alloc_ordered_workqueue().

However, alloc_ordered_workqueue() was a later addition. Before it, an
ordered workqueue could be obtained by creating an UNBOUND workqueue with
@max_active==1. This originally was an implementation side-effect which was
broken by 4c16bd327c74 ("workqueue: restore WQ_UNBOUND/max_active==1 to be
ordered"). Because there were users that depended on the ordered execution,
5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active==1 to be ordered")
made workqueue allocation path to implicitly promote UNBOUND workqueues w/
@max_active==1 to ordered workqueues.

While this has worked okay, overloading the UNBOUND allocation interface
this way creates other issues. It's difficult to tell whether a given
workqueue actually needs to be ordered and users that legitimately want a
min concurrency level wq unexpectedly gets an ordered one instead. With
planned UNBOUND workqueue updates to improve execution locality and more
prevalence of chiplet designs which can benefit from such improvements, this
isn't a state we wanna be in forever.

This patch series audits all callsites that create an UNBOUND workqueue w/
@max_active==1 and converts them to alloc_ordered_workqueue() as necessary.

WHAT TO LOOK FOR
================

The conversions are from

  alloc_workqueue(WQ_UNBOUND | flags, 1, args..)

to

  alloc_ordered_workqueue(flags, args...)

which don't cause any functional changes. If you know that fully ordered
execution is not ncessary, please let me know. I'll drop the conversion and
instead add a comment noting the fact to reduce confusion while conversion
is in progress.

If you aren't fully sure, it's completely fine to let the conversion
through. The behavior will stay exactly the same and we can always
reconsider later.

As there are follow-up workqueue core changes, I'd really appreciate if the
patch can be routed through the workqueue tree w/ your acks. Thanks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Cc: Intel Corporation <linuxwwan@intel.com>
Cc: Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>
Cc: Liu Haijun <haijun.liu@mediatek.com>
Cc: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc: Loic Poulain <loic.poulain@linaro.org>
Cc: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 13 +++++++------
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c |  5 +++--
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index aec3a18d44bd..7162bf38a8c9 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -1293,9 +1293,9 @@ int t7xx_cldma_init(struct cldma_ctrl *md_ctrl)
 	for (i = 0; i < CLDMA_TXQ_NUM; i++) {
 		md_cd_queue_struct_init(&md_ctrl->txq[i], md_ctrl, MTK_TX, i);
 		md_ctrl->txq[i].worker =
-			alloc_workqueue("md_hif%d_tx%d_worker",
-					WQ_UNBOUND | WQ_MEM_RECLAIM | (i ? 0 : WQ_HIGHPRI),
-					1, md_ctrl->hif_id, i);
+			alloc_ordered_workqueue("md_hif%d_tx%d_worker",
+					WQ_MEM_RECLAIM | (i ? 0 : WQ_HIGHPRI),
+					md_ctrl->hif_id, i);
 		if (!md_ctrl->txq[i].worker)
 			goto err_workqueue;
 
@@ -1306,9 +1306,10 @@ int t7xx_cldma_init(struct cldma_ctrl *md_ctrl)
 		md_cd_queue_struct_init(&md_ctrl->rxq[i], md_ctrl, MTK_RX, i);
 		INIT_WORK(&md_ctrl->rxq[i].cldma_work, t7xx_cldma_rx_done);
 
-		md_ctrl->rxq[i].worker = alloc_workqueue("md_hif%d_rx%d_worker",
-							 WQ_UNBOUND | WQ_MEM_RECLAIM,
-							 1, md_ctrl->hif_id, i);
+		md_ctrl->rxq[i].worker =
+			alloc_ordered_workqueue("md_hif%d_rx%d_worker",
+						WQ_MEM_RECLAIM,
+						md_ctrl->hif_id, i);
 		if (!md_ctrl->rxq[i].worker)
 			goto err_workqueue;
 	}
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
index 46514208d4f9..8dab025a088a 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
@@ -618,8 +618,9 @@ int t7xx_dpmaif_txq_init(struct dpmaif_tx_queue *txq)
 		return ret;
 	}
 
-	txq->worker = alloc_workqueue("md_dpmaif_tx%d_worker", WQ_UNBOUND | WQ_MEM_RECLAIM |
-				      (txq->index ? 0 : WQ_HIGHPRI), 1, txq->index);
+	txq->worker = alloc_ordered_workqueue("md_dpmaif_tx%d_worker",
+				WQ_MEM_RECLAIM | (txq->index ? 0 : WQ_HIGHPRI),
+				txq->index);
 	if (!txq->worker)
 		return -ENOMEM;
 
-- 
2.40.0

