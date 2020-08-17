Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D610C245F42
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgHQIT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgHQITy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:19:54 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D971DC061388;
        Mon, 17 Aug 2020 01:19:54 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m71so7872778pfd.1;
        Mon, 17 Aug 2020 01:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LXAHZjWOCXqZNRFnEVorFd32pcE4Uer+STR5X7m1T40=;
        b=IgwVbNVcSBmDm38yYmUrvEmMnA/dM433v1XDeqYJgH3tqNNAT/iGYm+ZViMaYaBo90
         pApwy+Tu2y78SX96Tga4eXY8SM5KE8XPOZftkkdfMgUpjwInxrimrBUvqiYyWmmU29Ta
         dxlTZJ3UuRUIRAdpX6GXydlmBzIIeRbVuE6v1MHEuTUEFUe3LmOUfI+ZusiLGIk2ivl7
         8lrFn4miWWTHAfZpxTm5A4RTgtC5I3iZAxZVgSjFwPm/hIueFW/+tscAApV1Khs0Lc9F
         CgT9TQWa0eimAOI3NSDZD3viKz+1dycrei3FqN9ipQryGDVM+I5TEliaMkGRLmiPKljz
         o+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LXAHZjWOCXqZNRFnEVorFd32pcE4Uer+STR5X7m1T40=;
        b=FUM5nh4P3N69+WjPqQDYxk1V+WIkCc4oxmYk/IsQmrSkA1Cj2mf/D7KKhstlNLc6HA
         NfMh8NkCn+fBgn5qV138RlvJP4DROfXisvbWvoj5GhmrXqUWjPE+inBXmBba59Tb8jbe
         eChjvqFAZxI8Sh1pko2o5OYOwiBvt4iNllkT2gXGxdiKX/EDT6l+zmkJnTvk7LYzw/kX
         Zg6mGa7Bv8mOv6V97taDPEeLTfvnaR58dXP7J59XCm8K1c2tw28OF/Kb1m5TPYZjrFkn
         p9xNbvJj0gi0m0MzLcRQRQvSynBpIOyhEP5qbmSAHSm5Ln2AGeKXZ6mR9pkBcWf76FIT
         08xw==
X-Gm-Message-State: AOAM530Yz5YX8kwZ5xqU3ZrF41EnhplHfDe0yw05TB8tdxWQFifh0bdd
        BJtsWYNQZUyaJ0QArhM5MIw=
X-Google-Smtp-Source: ABdhPJzuT/8j9+SjbGA9NES+f4fyeu03MlTNL30utMUb/RKtQQp9CVCHKYWxptOH5Pi8FhszEQdMZw==
X-Received: by 2002:aa7:9813:: with SMTP id e19mr10555426pfl.285.1597652394480;
        Mon, 17 Aug 2020 01:19:54 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:19:54 -0700 (PDT)
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
Subject: [PATCH 13/35] dma: mediatek: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:04 +0530
Message-Id: <20200817081726.20213-14-allen.lkml@gmail.com>
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
 drivers/dma/mediatek/mtk-cqdma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/mediatek/mtk-cqdma.c b/drivers/dma/mediatek/mtk-cqdma.c
index 6bf838e63be1..41ef9f15d3d5 100644
--- a/drivers/dma/mediatek/mtk-cqdma.c
+++ b/drivers/dma/mediatek/mtk-cqdma.c
@@ -356,9 +356,9 @@ static struct mtk_cqdma_vdesc
 	return ret;
 }
 
-static void mtk_cqdma_tasklet_cb(unsigned long data)
+static void mtk_cqdma_tasklet_cb(struct tasklet_struct *t)
 {
-	struct mtk_cqdma_pchan *pc = (struct mtk_cqdma_pchan *)data;
+	struct mtk_cqdma_pchan *pc = from_tasklet(pc, t, tasklet);
 	struct mtk_cqdma_vdesc *cvd = NULL;
 	unsigned long flags;
 
@@ -878,8 +878,7 @@ static int mtk_cqdma_probe(struct platform_device *pdev)
 
 	/* initialize tasklet for each PC */
 	for (i = 0; i < cqdma->dma_channels; ++i)
-		tasklet_init(&cqdma->pc[i]->tasklet, mtk_cqdma_tasklet_cb,
-			     (unsigned long)cqdma->pc[i]);
+		tasklet_setup(&cqdma->pc[i]->tasklet, mtk_cqdma_tasklet_cb);
 
 	dev_info(&pdev->dev, "MediaTek CQDMA driver registered\n");
 
-- 
2.17.1

