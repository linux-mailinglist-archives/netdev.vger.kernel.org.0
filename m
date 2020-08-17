Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987F2245F4B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgHQIUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbgHQIUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:20:04 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFEFC061388;
        Mon, 17 Aug 2020 01:20:04 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 74so7843283pfx.13;
        Mon, 17 Aug 2020 01:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jvxuy1l/tmoRx6ToQ9/CnHSagxvVLNtLIuN2aBXKG9w=;
        b=inUl3AdkFX0a6b6fmByIUWU8g/ZSMLhnjh7NyMEcA3Bu6SPtvSONgdI8zsNQTCHqbz
         34awZ74cNxWmqvN4Y52URMl2mQeyPjNOOadpCzm8PGhUDavMOhJ7ETOj+hBQGQ4BneQl
         7mNFK5k0ae85WFZcEufTK6g9mAuO8PDMAnJgR8VsaF7ApTpDDlJsX3Y/+Vc8pe0OBSBi
         kGteehuwn5DYsN3eunz8qI3beF+ivdCN8BMk+M8JgZT562JxoDbfc9np/bM2LF24qXdv
         p3Lp6f3CUT7KIhVgYvOlxNIcw1VqGF9CIIHbF9bIPC6GlwQS7RDDoeUItSSFAI9tgz8C
         RAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jvxuy1l/tmoRx6ToQ9/CnHSagxvVLNtLIuN2aBXKG9w=;
        b=RmxaLD2N0K/JvrImMX2r7A4QDNADNzm47YAC9gh5hOMI95ylVLwsWFMYeMTh021oOv
         pC3g3KfHx4ZH6nI2P8gdJAd4hc5040jIvbsZdqHO25d/IjwdBVwG/dTmeCm3WdcmRMlT
         beXykiFD6/r1S+7nPFIP3bG5/pod9rHt3+WFjm2fK+hLyC3ym/1N9cRSesUoL3s/f0IY
         DntuFWZO1y+BvSNNTGK5fPCYFDw0lC9J+6E1cHoZQcsGSTv+Kaf4kC/oodHGzqoOeCXN
         dLKDHuZb4/xIJUlfKhVYC9UiA3ThrsBLrPiMA2cOGQywAee9MFz3SS7LqO8NLO8BgT8X
         EuIA==
X-Gm-Message-State: AOAM53098m4es9hMuySdyRQ7P5mk8IM4x1qeqFOASKCs/y/qA7TJFky6
        oy6z2qhkXTMj70PNDHRqYBY=
X-Google-Smtp-Source: ABdhPJxUuhOcBt6I3wTvzg7ljG+imTIqho7hmggMvHrg6Cku+rR+cfGtQ1URO829eIH99aTCywLmyg==
X-Received: by 2002:a62:1614:: with SMTP id 20mr10662690pfw.258.1597652404010;
        Mon, 17 Aug 2020 01:20:04 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:20:03 -0700 (PDT)
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
Subject: [PATCH 14/35] dma: mmp: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:05 +0530
Message-Id: <20200817081726.20213-15-allen.lkml@gmail.com>
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
 drivers/dma/mmp_pdma.c | 6 +++---
 drivers/dma/mmp_tdma.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index f42f792db277..b84303be8edf 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -873,9 +873,9 @@ static void mmp_pdma_issue_pending(struct dma_chan *dchan)
  * Do call back
  * Start pending list
  */
-static void dma_do_tasklet(unsigned long data)
+static void dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct mmp_pdma_chan *chan = (struct mmp_pdma_chan *)data;
+	struct mmp_pdma_chan *chan = from_tasklet(chan, t, tasklet);
 	struct mmp_pdma_desc_sw *desc, *_desc;
 	LIST_HEAD(chain_cleanup);
 	unsigned long flags;
@@ -993,7 +993,7 @@ static int mmp_pdma_chan_init(struct mmp_pdma_device *pdev, int idx, int irq)
 	spin_lock_init(&chan->desc_lock);
 	chan->dev = pdev->dev;
 	chan->chan.device = &pdev->device;
-	tasklet_init(&chan->tasklet, dma_do_tasklet, (unsigned long)chan);
+	tasklet_setup(&chan->tasklet, dma_do_tasklet);
 	INIT_LIST_HEAD(&chan->chain_pending);
 	INIT_LIST_HEAD(&chan->chain_running);
 
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 960c7c40aef7..a262e0eb4cc9 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -346,9 +346,9 @@ static irqreturn_t mmp_tdma_int_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 }
 
-static void dma_do_tasklet(unsigned long data)
+static void dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct mmp_tdma_chan *tdmac = (struct mmp_tdma_chan *)data;
+	struct mmp_tdma_chan *tdmac = from_tasklet(tdmac, t, tasklet);
 
 	dmaengine_desc_get_callback_invoke(&tdmac->desc, NULL);
 }
@@ -586,7 +586,7 @@ static int mmp_tdma_chan_init(struct mmp_tdma_device *tdev,
 	tdmac->pool	   = pool;
 	tdmac->status = DMA_COMPLETE;
 	tdev->tdmac[tdmac->idx] = tdmac;
-	tasklet_init(&tdmac->tasklet, dma_do_tasklet, (unsigned long)tdmac);
+	tasklet_setup(&tdmac->tasklet, dma_do_tasklet);
 
 	/* add the channel to tdma_chan list */
 	list_add_tail(&tdmac->chan.device_node,
-- 
2.17.1

