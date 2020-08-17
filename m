Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776D4245F21
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgHQISj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgHQISf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:18:35 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201B0C061388;
        Mon, 17 Aug 2020 01:18:35 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 74so7841528pfx.13;
        Mon, 17 Aug 2020 01:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=McUFqZfFTy7mHwbw8y2LjePaGU9tqMqaDH3Woad5dgY=;
        b=rbGPv1MoAStGdHictLBw1dH4GZoFIaptVHT/PTQUYarAqwH8jr/NQJpRblNtu8Q41b
         h5kE3FK0Bcrx3/+Zd6IsTlw5aHjVtw05s4dLWtVo+8g1TVa3DmIZfm5h7PClL9HJLOWp
         OTSIDh9iY+xzhXKlp3+CuWBnd4nGJLinJzWoIBQ5xoTLALb0n+9o8qX9Ebbj4jGqV2jT
         q83tfI49OfnTPFbY8Ecv64HoBmGwkwk/Xnvsa93zdxDBXM9nLmfRw4Q+HXL/WxWR8Axb
         gfANCDAg2XVcS363QcNFYYj/Z8yd6ay5UQWiYipx8c6dkumwh89srhCfyJfBev9nFJBI
         c/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=McUFqZfFTy7mHwbw8y2LjePaGU9tqMqaDH3Woad5dgY=;
        b=JXjvse10SmqZvRwJ31yf2nXk33srcUQsJT7gNkfCOScPMRIxru66X/t/EOv/3pnYPh
         orMLB4TinZ8jQlOsmC28GExuvJJLQSdiMB5uxebe1u21HWVoPLi7RP42zZwN4SKhsGQy
         /p8DL05onJS0jfLHjn4fdbm2znzXw/G/eNnr9jU8HA0VXXfZQQie54PahjUz5xGFoUv1
         7PZo6gtAZYywx5jvmJ+2xG/CrrJxJwPHw14Z8VSM6L4eDAr4UAkCIzHIw/T9YXao6EmH
         D29oC0g0olygnd4Ll0KHEjq7geiV/IbhXy82+tS4r1L1HeylMeMZetBv24Jzq9cpnxPU
         tkJA==
X-Gm-Message-State: AOAM530PYGAU3L+r5CXNO0jw+IVg0P/KeKqOwC6fwd5fzO3Vg8r+7nAD
        FOdHIxgUakE8mlLgsUUN8TY=
X-Google-Smtp-Source: ABdhPJz5jQMemPq+r7m/kRK32XCVq2NbmdAqGrkNdHPC5k9KVEpXSa2A/6RTZ0/LD+zMammtHEDMqA==
X-Received: by 2002:aa7:96e5:: with SMTP id i5mr7562519pfq.108.1597652314716;
        Mon, 17 Aug 2020 01:18:34 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:18:34 -0700 (PDT)
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
Subject: [PATCH 05/35] dma: dw: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:46:56 +0530
Message-Id: <20200817081726.20213-6-allen.lkml@gmail.com>
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
 drivers/dma/dw/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 4700f2e87a62..022ddc4d3af5 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -463,9 +463,9 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	dwc_descriptor_complete(dwc, bad_desc, true);
 }
 
-static void dw_dma_tasklet(unsigned long data)
+static void dw_dma_tasklet(struct tasklet_struct *t)
 {
-	struct dw_dma *dw = (struct dw_dma *)data;
+	struct dw_dma *dw = from_tasklet(dw, t, tasklet);
 	struct dw_dma_chan *dwc;
 	u32 status_xfer;
 	u32 status_err;
@@ -1138,7 +1138,7 @@ int do_dma_probe(struct dw_dma_chip *chip)
 		goto err_pdata;
 	}
 
-	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
+	tasklet_setup(&dw->tasklet, dw_dma_tasklet);
 
 	err = request_irq(chip->irq, dw_dma_interrupt, IRQF_SHARED,
 			  dw->name, dw);
-- 
2.17.1

