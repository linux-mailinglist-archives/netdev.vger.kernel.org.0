Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38570245F6D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgHQIVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbgHQIV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:21:26 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F550C061388;
        Mon, 17 Aug 2020 01:21:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x25so7873254pff.4;
        Mon, 17 Aug 2020 01:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dvX6FlWRqibGpy5qHiY9CD/HZDa4GdoItaD6hrOhnJQ=;
        b=rqX/O6h8qAd/dpn+JctX6LgY5uudHkjGG9VkbS3cy03GAhbVo2lbpKtH9yM8eLV/RQ
         E11vvSqgQML8bl4nCCgMOlthyv5Mr/UGHYPY+DruP2yrfpAnN77AvSIZutoswYCQWzjv
         PR0QHfu1kIatmrl0v2HUdpUvZq2eEouj7FTMKrEK7b06anDW96TsSwQsbyASLjF9iz5T
         Az86MZWloCjWnB8VRhgNVFUmbvFs/XodWt9vkPZMuRx/BPwUf80emnpwsmAl/Mg4G/zN
         Uhob0gmb+pwKhovQtl+zK6hasDdGQ1+HFzr/J8BRhasUJlc/M02cHMvSH4Ev2rP9hdu/
         3CYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dvX6FlWRqibGpy5qHiY9CD/HZDa4GdoItaD6hrOhnJQ=;
        b=oHMtNhNIrq+iq0T2y+QbkV/1RA3f/knB1htbuncXhMgpTMvZ9eiBWfF1L9vMNm4p5+
         nWyZBSrvEueXKL0SG0h0W+YPDRkinm9IL9MrsL8ZTbCvqKAopfAzA+RTxW0YVCbLcXbk
         5vX1Jfmr1LVCfLFTGcmCwKfwaPMng8qhLxBC9cURWwmhOjUmVCs9sJ2TirSFDwXCaMP9
         MN9Arit+nXKLjUDVE3jIIqH3LvSYWyXepP2SXl2Q5Ys7GRB91FacfeS52gFXu6npnAkb
         G9PGtHgNiben8kRtrcoHc7slhKApT1bXpz6bNVkfbj94p+7w4IhkafFEOtu4vyojolCf
         GKWg==
X-Gm-Message-State: AOAM531YQkP6tjVFDRP2EGpyYVcrLW9PbibDo0+/izWA8cRxSAsDlC7s
        fngK7oBsIQHpYT1HhkqGTJs=
X-Google-Smtp-Source: ABdhPJyzYdcL9n1eXaLOXLnH3937UeGl4OMGwZ1XGWANR3WtM8FkSL68n8dAz52LrCPevc3ZARv1fA==
X-Received: by 2002:a63:ed07:: with SMTP id d7mr8900878pgi.414.1597652485719;
        Mon, 17 Aug 2020 01:21:25 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:21:25 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, baohua@kernel.org, mripard@kernel.org,
        wens@csie.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
        michal.simek@xilinx.com, matthias.bgg@gmail.com
Cc:     keescook@chromium.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 22/35] dma: qcom: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:13 +0530
Message-Id: <20200817081726.20213-23-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817081726.20213-1-allen.lkml@gmail.com>
References: <20200817081726.20213-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/dma/qcom/bam_dma.c  | 6 +++---
 drivers/dma/qcom/hidma.c    | 6 +++---
 drivers/dma/qcom/hidma_ll.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 5a08dd0d3388..8ba7a8f089c8 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1075,9 +1075,9 @@ static void bam_start_dma(struct bam_chan *bchan)
  *
  * Sets up next DMA operation and then processes all completed transactions
  */
-static void dma_tasklet(unsigned long data)
+static void dma_tasklet(struct tasklet_struct *t)
 {
-	struct bam_device *bdev = (struct bam_device *)data;
+	struct bam_device *bdev = from_tasklet(bdev, t, task);
 	struct bam_chan *bchan;
 	unsigned long flags;
 	unsigned int i;
@@ -1293,7 +1293,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_disable_clk;
 
-	tasklet_init(&bdev->task, dma_tasklet, (unsigned long)bdev);
+	tasklet_setup(&bdev->task, dma_tasklet);
 
 	bdev->channels = devm_kcalloc(bdev->dev, bdev->num_channels,
 				sizeof(*bdev->channels), GFP_KERNEL);
diff --git a/drivers/dma/qcom/hidma.c b/drivers/dma/qcom/hidma.c
index 0a6d3ea08c78..6c0f9eb8ecc6 100644
--- a/drivers/dma/qcom/hidma.c
+++ b/drivers/dma/qcom/hidma.c
@@ -224,9 +224,9 @@ static int hidma_chan_init(struct hidma_dev *dmadev, u32 dma_sig)
 	return 0;
 }
 
-static void hidma_issue_task(unsigned long arg)
+static void hidma_issue_task(struct tasklet_struct *t)
 {
-	struct hidma_dev *dmadev = (struct hidma_dev *)arg;
+	struct hidma_dev *dmadev = from_tasklet(dmadev, t, task);
 
 	pm_runtime_get_sync(dmadev->ddev.dev);
 	hidma_ll_start(dmadev->lldev);
@@ -885,7 +885,7 @@ static int hidma_probe(struct platform_device *pdev)
 		goto uninit;
 
 	dmadev->irq = chirq;
-	tasklet_init(&dmadev->task, hidma_issue_task, (unsigned long)dmadev);
+	tasklet_setup(&dmadev->task, hidma_issue_task);
 	hidma_debug_init(dmadev);
 	hidma_sysfs_init(dmadev);
 	dev_info(&pdev->dev, "HI-DMA engine driver registration complete\n");
diff --git a/drivers/dma/qcom/hidma_ll.c b/drivers/dma/qcom/hidma_ll.c
index bb4471e84e48..53244e0e34a3 100644
--- a/drivers/dma/qcom/hidma_ll.c
+++ b/drivers/dma/qcom/hidma_ll.c
@@ -173,9 +173,9 @@ int hidma_ll_request(struct hidma_lldev *lldev, u32 sig, const char *dev_name,
 /*
  * Multiple TREs may be queued and waiting in the pending queue.
  */
-static void hidma_ll_tre_complete(unsigned long arg)
+static void hidma_ll_tre_complete(struct tasklet_struct *t)
 {
-	struct hidma_lldev *lldev = (struct hidma_lldev *)arg;
+	struct hidma_lldev *lldev = from_tasklet(lldev, t, task);
 	struct hidma_tre *tre;
 
 	while (kfifo_out(&lldev->handoff_fifo, &tre, 1)) {
@@ -792,7 +792,7 @@ struct hidma_lldev *hidma_ll_init(struct device *dev, u32 nr_tres,
 		return NULL;
 
 	spin_lock_init(&lldev->lock);
-	tasklet_init(&lldev->task, hidma_ll_tre_complete, (unsigned long)lldev);
+	tasklet_setup(&lldev->task, hidma_ll_tre_complete);
 	lldev->initialized = 1;
 	writel(ENABLE_IRQS, lldev->evca + HIDMA_EVCA_IRQ_EN_REG);
 	return lldev;
-- 
2.17.1

