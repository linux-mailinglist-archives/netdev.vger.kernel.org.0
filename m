Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8F0245F7E
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgHQIWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgHQIWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:22:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCF1C061388;
        Mon, 17 Aug 2020 01:22:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a79so7856928pfa.8;
        Mon, 17 Aug 2020 01:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HqFQaMaVlN4v+XRE6EAAx4lkt2C6k9NLYs6BovvOyBc=;
        b=XCo9FRKJqzxD9YIFVBEkvWvIE6d8IhdAaiDCtzQO7t4uXgFaRRScmAvp0jzrkTU4HN
         c8T4cfAHELvaWoAq4xMW2JM0VEedndfRcDWLW92Tk7hKPiOJWScPnhSp11JUzjxwj5Wc
         tiJdQ8nOdN/Z7aW1egi2EdY1Omzr3UvEyyneLR1hEUAsPju2N1nHj6d3e15q3oaZiyvP
         bXMiI5e4811zae96GuOOUkWztczj4bgmH/joFr4ApZ0qxChUW0b1UqRRBKaSgxhomiJG
         p2k9h60UtRATSv4JkakeSpHpSRDExkbbgmjWcH6nbiz2/9WZIAfKL5178CUcItTg9tbK
         Bu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HqFQaMaVlN4v+XRE6EAAx4lkt2C6k9NLYs6BovvOyBc=;
        b=tDbTI0FpbXx2OLyuDUoPYh0q7UnwV/7FgAewA1XGaMfPQ140D0HeoYAPMOJe2mRS95
         BjfAFNf+kvCCqrdUl3Ih/85WtMmSs2tag8hmqoV/hL1ziP6joWTJXSWazqGS/Gcu/5yr
         Elea7SskphaoCIB4YVe5GA1WZvfOOF3G4VbdrCLWLQesQNFdOoZ3No0cfFj0Mr0xIPL7
         iaKvoFv1KcOP1uQPMnGJlazOpmaFuAKLCt4HhIk0UD9sZCG/i8vN5Zwwyz75pLpDKJxH
         tgPAyJRc4fcKOEBfRhGUdks8i175OKgvA721+M79w4/VMDrQVSdP+MNIHrJRgZc1B0Ux
         aM6w==
X-Gm-Message-State: AOAM531ykYtEDSfFeW2q/otmmkxg3DVqCiuW2E7vU78d7nHlXEsOzYtX
        3xkJ7udNerIUi2YlxNFc0gc=
X-Google-Smtp-Source: ABdhPJyPMSt/qjmwIlaM5eY0uLHA/f/qnk1WbIgQl1cjJGvqnctrPF7J892OqBSbDL22FjnEZivrnw==
X-Received: by 2002:a62:8cd4:: with SMTP id m203mr10376894pfd.74.1597652532712;
        Mon, 17 Aug 2020 01:22:12 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:22:12 -0700 (PDT)
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
Subject: [PATCH 27/35] dma: tegra20: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:18 +0530
Message-Id: <20200817081726.20213-28-allen.lkml@gmail.com>
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
 drivers/dma/tegra20-apb-dma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 55fc7400f717..71827d9b0aa1 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -644,9 +644,9 @@ static void handle_cont_sngl_cycle_dma_done(struct tegra_dma_channel *tdc,
 	}
 }
 
-static void tegra_dma_tasklet(unsigned long data)
+static void tegra_dma_tasklet(struct tasklet_struct *t)
 {
-	struct tegra_dma_channel *tdc = (struct tegra_dma_channel *)data;
+	struct tegra_dma_channel *tdc = from_tasklet(tdc, t, tasklet);
 	struct dmaengine_desc_callback cb;
 	struct tegra_dma_desc *dma_desc;
 	unsigned int cb_count;
@@ -1523,8 +1523,7 @@ static int tegra_dma_probe(struct platform_device *pdev)
 		tdc->id = i;
 		tdc->slave_id = TEGRA_APBDMA_SLAVE_ID_INVALID;
 
-		tasklet_init(&tdc->tasklet, tegra_dma_tasklet,
-			     (unsigned long)tdc);
+		tasklet_setup(&tdc->tasklet, tegra_dma_tasklet);
 		spin_lock_init(&tdc->lock);
 		init_waitqueue_head(&tdc->wq);
 
-- 
2.17.1

