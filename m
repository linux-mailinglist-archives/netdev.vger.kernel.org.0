Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D14E245F14
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHQISB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHQIR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:17:57 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508C5C061388;
        Mon, 17 Aug 2020 01:17:57 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f10so7121491plj.8;
        Mon, 17 Aug 2020 01:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PpOwkkESLwiuZVXjbiIFtl9hpeTezLFpf6exIb06VVg=;
        b=S9KzzLHTf4acEr4iIrHquzS1n+27I5KgmfY2Vx1u17p1+AxZhqIxQadXzBxZLnvNln
         cdQTO9F9bVR2qRTcZt+wkh9LVW6ePlwnXaNBchj5mrQeeNQaW/cXQCpNqYi3pPruPMeB
         euSI1bn/bnAnVHWiQrzolM2XtL/krrZaPNWUYlGuQezIoZtZNAJ4283es1PPqvBqE/KD
         28LtExPpYWRQrTwpX0B9mHTn8dJSAj7OO6qptzXwqtJeDYlCQMj/PIYGkY0+fNJ5yIGB
         oFYU43VVwYGCrYPAwPEBqA+m8HMoRJ2rACChE/4BIiDiBJ8FnfOx6J7Nh61U7Pnwpowt
         oC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PpOwkkESLwiuZVXjbiIFtl9hpeTezLFpf6exIb06VVg=;
        b=Dd8rS6ahdVsVtzHrTOnFXa747lOdqq96VVSxgvyrhs/TP2xUWZwSCGkDQCE7a5CmAC
         dKpi39be49l3dK3hbT6WWXqTaNKmczIaGn43GW8cjit0Mq8QMQUoHLDfsHDQ0jKERfX9
         rFiL2xrWyittymNfMHPAzvwWxipmohDJsJvNibhOapSK6+fCoFqldoJBuCyM0J60fbPc
         eWGXYfoUx87egJbYDPV0zb1D9a/Tw0P8gf3r/w8Du2JO1EfZvfqJyJN+CUCd63kWG7p7
         hd6U0q9w0bLDMRDCsjRyhqT6AIkhkRCQjCS+ifoJcZE62s6PhwMRY09UMIcIcE9z7TRZ
         +ktA==
X-Gm-Message-State: AOAM533JMIu5RjFsRHfHzPBW9UVmPvKfM7NCF4ArkHDWepckFmjVfO4r
        Gu8SCv3AMO7NKZs/q5Xwq88=
X-Google-Smtp-Source: ABdhPJzxyMicWdDqFa9Ms4TwNVlxegk5ZkYrtD4PG9ewuPRixw1owkp8YNo4HUfMixNJVCialhYcJQ==
X-Received: by 2002:a17:90b:2092:: with SMTP id hb18mr12048549pjb.118.1597652276966;
        Mon, 17 Aug 2020 01:17:56 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:17:56 -0700 (PDT)
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
Subject: [PATCH 01/35] dma: altera-msgdma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:46:52 +0530
Message-Id: <20200817081726.20213-2-allen.lkml@gmail.com>
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
 drivers/dma/altera-msgdma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/altera-msgdma.c b/drivers/dma/altera-msgdma.c
index 321ac3a7aa41..4d6751bf6f11 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -680,9 +680,9 @@ static int msgdma_alloc_chan_resources(struct dma_chan *dchan)
  * msgdma_tasklet - Schedule completion tasklet
  * @data: Pointer to the Altera sSGDMA channel structure
  */
-static void msgdma_tasklet(unsigned long data)
+static void msgdma_tasklet(struct tasklet_struct *t)
 {
-	struct msgdma_device *mdev = (struct msgdma_device *)data;
+	struct msgdma_device *mdev = from_tasklet(mdev, t, irq_tasklet);
 	u32 count;
 	u32 __maybe_unused size;
 	u32 __maybe_unused status;
@@ -830,7 +830,7 @@ static int msgdma_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	tasklet_init(&mdev->irq_tasklet, msgdma_tasklet, (unsigned long)mdev);
+	tasklet_setup(&mdev->irq_tasklet, msgdma_tasklet);
 
 	dma_cookie_init(&mdev->dmachan);
 
-- 
2.17.1

