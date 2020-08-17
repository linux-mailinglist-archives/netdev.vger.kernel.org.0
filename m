Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16796245F37
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgHQITa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgHQIT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:19:26 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D415C061388;
        Mon, 17 Aug 2020 01:19:26 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so7113670plk.13;
        Mon, 17 Aug 2020 01:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SduS7GYrzCMOuDhMx/Gh1w2hqriGD/sY89ZovbEjnFE=;
        b=XH24MgRjHRYGPePUOq3aw4H5z0Vr33lqZWU9Wlczqoofn0SYwK930nVcgDozCL8vcP
         ONUcHFit8FvUlnNJY5xZECDV8iv+6xLVTKQ51c+RuZNBgtHQXOY1YvG7uubgdAg0SP0+
         BlK2QMTQVwwlmyoXsxrDybqm5kQaTHAjfYUT2t2hvzw9+gGVNwXNfcAYWDayGD9olG3b
         OBoUq3H+ZOsSslRrqPcZ3iLi6s6rKmvSoeWvJZibcRh0V6l2wlYaBuJUsu34hYRO3ENW
         vQfu4wD4n4yQItLkaeBkT6PTj9aQ22IIwUHUmAkUYdIhhbuZBRV/D/32Uky9eonf9Wnp
         jCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SduS7GYrzCMOuDhMx/Gh1w2hqriGD/sY89ZovbEjnFE=;
        b=O47dCFsseuKDcj0/n/gZ7LSx18vYYIRZKnBPzm6lCdwawjRzhS71EvaSqUUwq0BVR4
         YL2DIyNDcQ2Lm/TYfNvpa6pFJ0ZoiogE3DRi701EAA6RnX2Kga5GZehpFrCHoRvrPWGo
         PXwSXyFnl+3CufDYeyOXntUqPAwXxQB9ezWRvTBk+ER4oA044YV0q4yDVAHK9oqraHN+
         QmA0gahZ2OZylOAHirdVWJu1NmkIZTTdr9Rv94EwPktTnBH2lHz1M6yKJZ4387x5p4Lg
         vlkg5FIi2XFhMUaGDLi39K0XdZoJsQkZgIFDZqZHMrxP3op0WkO1WNcouAiHlSjs+CwX
         tM6w==
X-Gm-Message-State: AOAM531NWvzby77+O1aoK+jlJowb3PFORb+O7wOvtDqBWmyHxSKru6Qm
        s9jEpxCySv+ObQlPtqPK40E=
X-Google-Smtp-Source: ABdhPJzroCaU+Tt7oEAw88lrMX/tAJLQhR1tAgJzO5Lh4HdTX+ecDGKk5WTyNolUBaI2A4dXtvY8dg==
X-Received: by 2002:a17:902:ee82:: with SMTP id a2mr10184305pld.204.1597652366238;
        Mon, 17 Aug 2020 01:19:26 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:19:25 -0700 (PDT)
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
Subject: [PATCH 10/35] dma: iop_adma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:01 +0530
Message-Id: <20200817081726.20213-11-allen.lkml@gmail.com>
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
 drivers/dma/iop-adma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 3350bffb2e93..81f177894d1f 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -238,9 +238,10 @@ iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 	spin_unlock_bh(&iop_chan->lock);
 }
 
-static void iop_adma_tasklet(unsigned long data)
+static void iop_adma_tasklet(struct tasklet_struct *t)
 {
-	struct iop_adma_chan *iop_chan = (struct iop_adma_chan *) data;
+	struct iop_adma_chan *iop_chan = from_tasklet(iop_chan, t,
+						      irq_tasklet);
 
 	/* lockdep will flag depedency submissions as potentially
 	 * recursive locking, this is not the case as a dependency
@@ -1351,8 +1352,7 @@ static int iop_adma_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto err_free_iop_chan;
 	}
-	tasklet_init(&iop_chan->irq_tasklet, iop_adma_tasklet, (unsigned long)
-		iop_chan);
+	tasklet_setup(&iop_chan->irq_tasklet, iop_adma_tasklet);
 
 	/* clear errors before enabling interrupts */
 	iop_adma_device_clear_err_status(iop_chan);
-- 
2.17.1

