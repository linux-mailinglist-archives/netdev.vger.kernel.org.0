Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE5A245F92
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgHQIXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbgHQIXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:23:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F167AC061389;
        Mon, 17 Aug 2020 01:23:14 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m8so7876632pfh.3;
        Mon, 17 Aug 2020 01:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QgRf+wpU/fZBoNxgl2cgbgUN6DgUelo3akwYgZu93dg=;
        b=N1SK+GNofCoZQb2iwyLwbhqMBZ/02t64tvziIKDhXHB8O6S/04VKL49wPxaWWjVmc7
         YJnUvZkq20M1MiASIlZMT8ycvzh2eVJoOkqxpqoMRA9nCKDlmuIOW9N7eTprWc070gUn
         xG/AL5xiEzkyhp4APJ7Z+nMLLuVMDWY4MRHg3ijzzoMoBp7vOdmYArEnqqYuf5byYeuG
         Oc3VfG+wzLnUTBOlvtVBsuL9MLlsLdlxhNal1vMdAcFzTJEi5Ixa+lEDrYSvrc4cYBOf
         wULLGx26MZBlwDggfkDlK0hqGatM2avggFUDeP4KM0mFq3Nyi8lJXqAtfdPX7ui3aftp
         krvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QgRf+wpU/fZBoNxgl2cgbgUN6DgUelo3akwYgZu93dg=;
        b=IrRNWQnRmntGxskIGMorZpEieHF6y/pasY8rphlg0SrCWvyFT5tV6qsTh3dfnSZt0L
         dZi+7/IFXQrqIWTvOHqT0FtXlM51AnXWty+bEjiAVKs0c6kWdmJDF4ZC3X4aPjqRG1FB
         3coOZHE6kHZto4zrVeIfHxf+l165zY/A6RgehC5Vevu4hnaiv/Rzow8E6+ZRWLru8dV0
         N6+qsRLjFk94TPknTpNRRezsb5HALmvsbBBBc8+KvmAkurYaYg6JW0ZPozAUd6lW5X8v
         pIPnzna1Gr0wV/zV0rRry0VA6ckAWQYPn0Z9oG671RyhRlc+lQ7fuvdCFNyZupDLxIYj
         sYkQ==
X-Gm-Message-State: AOAM532uw8h2hkcs/EHJootPor8uh+TBZIejRbQTiXay+AXOAzFioAsC
        DjETPsm7ynDWDe0eQGbDa3s=
X-Google-Smtp-Source: ABdhPJy4idYpBjz1K02F706gi2k5e1lttvzSxamHoY9LZcYWsmMUV0jwPTbFNXxXTd25zDO71gDp6g==
X-Received: by 2002:aa7:9f8a:: with SMTP id z10mr10842423pfr.176.1597652594564;
        Mon, 17 Aug 2020 01:23:14 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:23:14 -0700 (PDT)
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
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 33/35] dma: plx_dma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:24 +0530
Message-Id: <20200817081726.20213-34-allen.lkml@gmail.com>
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

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/dma/plx_dma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/plx_dma.c b/drivers/dma/plx_dma.c
index db4c5fd453a9..f387c5bbc170 100644
--- a/drivers/dma/plx_dma.c
+++ b/drivers/dma/plx_dma.c
@@ -241,9 +241,9 @@ static void plx_dma_stop(struct plx_dma_dev *plxdev)
 	rcu_read_unlock();
 }
 
-static void plx_dma_desc_task(unsigned long data)
+static void plx_dma_desc_task(struct tasklet_struct *t)
 {
-	struct plx_dma_dev *plxdev = (void *)data;
+	struct plx_dma_dev *plxdev = from_tasklet(plxdev, t, desc_task);
 
 	plx_dma_process_desc(plxdev);
 }
@@ -513,8 +513,7 @@ static int plx_dma_create(struct pci_dev *pdev)
 	}
 
 	spin_lock_init(&plxdev->ring_lock);
-	tasklet_init(&plxdev->desc_task, plx_dma_desc_task,
-		     (unsigned long)plxdev);
+	tasklet_setup(&plxdev->desc_task, plx_dma_desc_task);
 
 	RCU_INIT_POINTER(plxdev->pdev, pdev);
 	plxdev->bar = pcim_iomap_table(pdev)[0];
-- 
2.17.1

