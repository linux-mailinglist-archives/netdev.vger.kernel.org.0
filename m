Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25427245F8C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgHQIXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHQIXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:23:01 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF017C061388;
        Mon, 17 Aug 2020 01:23:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id g15so3234892plj.6;
        Mon, 17 Aug 2020 01:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7u/2cva1X+qYdcICcawfSm0XBYmeJIpXUg7S7BH2D4c=;
        b=f59rLF9LjolBojqbq/4JZGmfTXfEB+L96JJR9sacgtiSRQCZmed2VTEnSkjAUt3iLB
         w/CU1vEzDqLYh6XIg2WSNADktWvdNBKn2HeP4voucqqQo6X5tBUAG1GWk0uHcS9Sk944
         eppkXL7ASmU5QX23DnDbEarDozMgPpH5h5Pvonb551x/R0/i4389N8qyjrdQo1t5X9b/
         02CdnExPI4JZqLrGE5kfU9ufVBAByyKy5qyOu15io4OADxiiqJzyEza0y6eh4US5yfco
         QebJgojxUVzKtCua81hbXP/fyxvhvIGuJgcJgiUDqtLgzR2onZ7kvjwSlqeB2Gv2zetV
         s/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7u/2cva1X+qYdcICcawfSm0XBYmeJIpXUg7S7BH2D4c=;
        b=Wq6v5FoR1LQ9GAy2DItSsr6zv5xqAjDDgcqZ9jBD7RArLy/BcPOZx8vBrpCYFaGAWH
         tNaW6xpsPf06ZikWMmDFb1+djTIx4c+0CZb3Ynd7byjN6DluXmUddzLNEBKI5QFD/u5R
         j5u26LorBbWKidRqii60ojg/yWW+zo33dkxHAbHRi84kqtkpGuOvwsYHeMAFikSKRY/D
         YwuzBQADZUxIgQSuWxO67uwekUGyjWD8dWiCevoDGKRaoDfNe96kRO7rKaA9gpsswOqU
         l4O6Lvp+u6RnuQCQ1AMZ0k8aD2EeAToDUOUAyd71mLXVQ+HX5LXJyJexvoclx9NVmTYm
         A9bg==
X-Gm-Message-State: AOAM530VNF2Tj/KZBBafW7de2Q5NiRJEMOO9J97XRjD43SIyLn2U/INo
        GV+ZL4s6wvkxsyeP0FY0ElA=
X-Google-Smtp-Source: ABdhPJwV6kPES4OsAR2RefOiq3Oe3pIFKfQA1x69JuKv8ue6o8uHXJFpGG1kbvkdTWOg1UoHvjLCpQ==
X-Received: by 2002:a17:902:7c94:: with SMTP id y20mr3269952pll.309.1597652580480;
        Mon, 17 Aug 2020 01:23:00 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:23:00 -0700 (PDT)
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
Subject: [PATCH 32/35] dma: xilinx: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:23 +0530
Message-Id: <20200817081726.20213-33-allen.lkml@gmail.com>
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
 drivers/dma/xilinx/xilinx_dma.c | 7 +++----
 drivers/dma/xilinx/zynqmp_dma.c | 6 +++---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 5429497d3560..48aa78785f4d 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1046,9 +1046,9 @@ static void xilinx_dma_chan_desc_cleanup(struct xilinx_dma_chan *chan)
  * xilinx_dma_do_tasklet - Schedule completion tasklet
  * @data: Pointer to the Xilinx DMA channel structure
  */
-static void xilinx_dma_do_tasklet(unsigned long data)
+static void xilinx_dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct xilinx_dma_chan *chan = (struct xilinx_dma_chan *)data;
+	struct xilinx_dma_chan *chan = from_tasklet(chan, t, tasklet);
 
 	xilinx_dma_chan_desc_cleanup(chan);
 }
@@ -2866,8 +2866,7 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 	}
 
 	/* Initialize the tasklet */
-	tasklet_init(&chan->tasklet, xilinx_dma_do_tasklet,
-			(unsigned long)chan);
+	tasklet_setup(&chan->tasklet, xilinx_dma_do_tasklet);
 
 	/*
 	 * Initialize the DMA channel and add it to the DMA engine channels
diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index ff253696d183..15b0f961fdf8 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -744,9 +744,9 @@ static irqreturn_t zynqmp_dma_irq_handler(int irq, void *data)
  * zynqmp_dma_do_tasklet - Schedule completion tasklet
  * @data: Pointer to the ZynqMP DMA channel structure
  */
-static void zynqmp_dma_do_tasklet(unsigned long data)
+static void zynqmp_dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct zynqmp_dma_chan *chan = (struct zynqmp_dma_chan *)data;
+	struct zynqmp_dma_chan *chan = from_tasklet(chan, t, tasklet);
 	u32 count;
 	unsigned long irqflags;
 
@@ -908,7 +908,7 @@ static int zynqmp_dma_chan_probe(struct zynqmp_dma_device *zdev,
 
 	chan->is_dmacoherent =  of_property_read_bool(node, "dma-coherent");
 	zdev->chan = chan;
-	tasklet_init(&chan->tasklet, zynqmp_dma_do_tasklet, (ulong)chan);
+	tasklet_setup(&chan->tasklet, zynqmp_dma_do_tasklet);
 	spin_lock_init(&chan->lock);
 	INIT_LIST_HEAD(&chan->active_list);
 	INIT_LIST_HEAD(&chan->pending_list);
-- 
2.17.1

