Return-Path: <netdev+bounces-997-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE3D76FBCAF
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D83321C20A9A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6CDF39A;
	Tue,  9 May 2023 01:51:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A05396
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:51:03 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C8FAD1A;
	Mon,  8 May 2023 18:50:48 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64115eef620so38952521b3a.1;
        Mon, 08 May 2023 18:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683597047; x=1686189047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81wtSULTB0ChL61hyyooDIvEy586bIFEIldimjXDoCw=;
        b=Wus/yyNbT6hCeCqfAjbRPgG9xEFpVMm+qPLAE/Id1SAoC/43EZnAXhfUrPO/0lxqEI
         EmY7kmttOyTPtq/JaLn0n92/O7yWkKXK+jeT1RsnV3G55QL8dnn7tROfuIEzSScjpCYc
         cLRoiZ2I9idWdzZ+2wOOY1Rwh5WQX84C8LaFkYB7+Ej42dR2pnebYgzcySmg5WSFOCTM
         rjvEfJ5phohVQQjckUxQNzndDGd1NV9wGmfeFACjGqYxGqU/XBlzhUIZrPxZEmS8QN9C
         XuOHeIavBlij1/aHO0rrrdQthhKwFR499hjKCG/fWzYrmTv9PIz4tQu7MwMbZsAMk154
         2Ptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683597047; x=1686189047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=81wtSULTB0ChL61hyyooDIvEy586bIFEIldimjXDoCw=;
        b=W8ZSwpXILmsNnB6FfsjNR8idBtzjTeYvZWmIqP0iG4Cw8ownjelXl3XqFpy+IuCgil
         6yMVHqIT7f12+qc8XwNysrRXjghKND8rcyJLH3+S6ncjLY6afOZH4P2gIs1CxPAlogZK
         SHKvIQA/HpTuNx2UNrxw5es7RlkHk4FRCRcw3u13K88TrUn7qna/xlFw4x3/OF1ftquZ
         FFiEP91SrF0Dr5xmvxiNWLC11+A0KjbEYMLqpx4wLr8U3FZW40mQr5soQwY1X8XnhNUN
         taNHdCMV9+bJWF+OEdsgnD//5XMlS63e7gR/CedrhPpkInNl/qiviUwUPJknRyOvU0bJ
         11Gw==
X-Gm-Message-State: AC+VfDySLrUj80jx+wlbEmHfL+B4fsSRC/xCdpaSKol1LyUOWK2nbT1p
	JETAU8YcsC13Ah7Tfpbzs6M=
X-Google-Smtp-Source: ACHHUZ5lBi/vJVd3FkKzXLtYKKsFetl0+biKdLlL3uSBu90oEO/3tLDMkppj06DEPvUA6N61O425ig==
X-Received: by 2002:a17:90a:744c:b0:246:9c75:351a with SMTP id o12-20020a17090a744c00b002469c75351amr14109220pjk.12.1683597047142;
        Mon, 08 May 2023 18:50:47 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id g20-20020a17090ace9400b0024dfbac9e2fsm10533231pju.21.2023.05.08.18.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 18:50:46 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
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
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH 06/13] net: wwan: t7xx: Use alloc_ordered_workqueue() to create ordered workqueues
Date: Mon,  8 May 2023 15:50:25 -1000
Message-Id: <20230509015032.3768622-7-tj@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509015032.3768622-1-tj@kernel.org>
References: <20230509015032.3768622-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
2.40.1


