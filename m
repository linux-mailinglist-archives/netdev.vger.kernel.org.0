Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9446D245FAA
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgHQIWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgHQIWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:22:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAA8C061388;
        Mon, 17 Aug 2020 01:22:22 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 128so7761134pgd.5;
        Mon, 17 Aug 2020 01:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MNsn+KIrzPWCkkACLUaTpczD1K+bZF0NZOkHpu9iBlw=;
        b=tYWB4U4C3lwkJ7KzspGsY+JnaAbBB4RFJjtsDwVaVyquMo6llfLpsyP9HNjqx1vAIN
         tNns+ubKbtrgwB4oggj7I3Zr83JcvEl+SgLdMcnPMX23O9iX5y4bFVvsMkM84xtU8b7/
         +Eh/zZcvnTl7hVw4au6Uev5ggpg/tW4J7GN+Uv2rTa2t1u4AqO7pManPuCNVvB9LU3CW
         xn3yfjrJR27u4ykM7g7HngBfdPPCgD0Wdpw9gMFztIGBvAlNoqEESuj/91CBWAIgmrhD
         BUcxlVmTEeAchaVIIZw8ber5GPLfmV+DsiDN1Bc37D+zA8Gm56gHJ58cUvd+8mo5wY81
         yhlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MNsn+KIrzPWCkkACLUaTpczD1K+bZF0NZOkHpu9iBlw=;
        b=KAlLfcexm+UcEMNVZz5L18G2Ofa6fNJfuTu88CMF5UV+QhdI7TbrNAIpZYmjXryg9D
         qubEzXaGPWyxFCuOlF+9BswpIiOua9dQZ4IwifhBDIOOh4ghgjhFNSMsw0UGSHuchAIz
         UPYBfulTZTUnHwKOYGr8Y6NMwTuzPX6LMThP+sy7WR1+EmvYfU3SKfTO2Vdnu+DiBpzy
         oeg3fZl34UtWuH1DghxN7oDJ9BooDFejHLj7mVhrHpRgbQxZ1hk4RHsZn/uEi5VxWuW6
         WDxDwS1nPqKZEXPmD5H2OsWZPiDs7piFlYCGCdNjlzt9o/a6WAmlRYsTetbjPsVBOG6f
         UIsw==
X-Gm-Message-State: AOAM533nO1xT+Nb7ApblnIDe/QHOrsjGxbK3rBQ03pKY5D0wh7GahNxV
        YpAbHAycnYCF2CtclaGGTXc=
X-Google-Smtp-Source: ABdhPJwip8+ZBfBIF2rZWZD4jUDBwY6tGIUOnI8p5i+Ag2NB9ZORtoqizmkvtq5iIYQRR7kPC5mbcw==
X-Received: by 2002:a62:38cb:: with SMTP id f194mr10567474pfa.243.1597652541981;
        Mon, 17 Aug 2020 01:22:21 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:22:21 -0700 (PDT)
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
Subject: [PATCH 28/35] dma: timb_dma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:19 +0530
Message-Id: <20200817081726.20213-29-allen.lkml@gmail.com>
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
 drivers/dma/timb_dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 68e48bf54d78..3f524be69efb 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -563,9 +563,9 @@ static int td_terminate_all(struct dma_chan *chan)
 	return 0;
 }
 
-static void td_tasklet(unsigned long data)
+static void td_tasklet(struct tasklet_struct *t)
 {
-	struct timb_dma *td = (struct timb_dma *)data;
+	struct timb_dma *td = from_tasklet(td, t, tasklet);
 	u32 isr;
 	u32 ipr;
 	u32 ier;
@@ -658,7 +658,7 @@ static int td_probe(struct platform_device *pdev)
 	iowrite32(0x0, td->membase + TIMBDMA_IER);
 	iowrite32(0xFFFFFFFF, td->membase + TIMBDMA_ISR);
 
-	tasklet_init(&td->tasklet, td_tasklet, (unsigned long)td);
+	tasklet_setup(&td->tasklet, td_tasklet);
 
 	err = request_irq(irq, td_irq, IRQF_SHARED, DRIVER_NAME, td);
 	if (err) {
-- 
2.17.1

