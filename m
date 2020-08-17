Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829CB245F69
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgHQIVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgHQIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:21:17 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D98C061388;
        Mon, 17 Aug 2020 01:21:16 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t6so7343341pjr.0;
        Mon, 17 Aug 2020 01:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y9TFyb5YPU9meSmmE+/B5Cy2MtU4Ivp78FeC1LNG7+4=;
        b=KjvdAoYou4ybaWcAads3ZK4SvLiE31HbsHKajely8IWfAQdMn/OSyMaY3js7C7Ht8H
         i/qCUkOyKDkjLNCAwIYxcnlQGSLxjCkEcE152V3EDZTRpOEbW08rDrNuuqzcUb5C2yI5
         krHyqEmaDLqw6LYtAhr4BmFpFxKLFqaIzoXd3kKOja4G0vAqHho4VIGCOha30JuEs/1l
         /ci2DECl5T9mgtDOhF1NpiC0yOq8h/NRmi4q8Ul+UFZH+AJqvt1m7I9ZZe5GTZ4iVICN
         HB9ZSWz9nm28pjeTzk/T8DJsGKGRLeR2RaLpdJ0p07D7vPszP148/HV+dFZkZt7u0G/Y
         EF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y9TFyb5YPU9meSmmE+/B5Cy2MtU4Ivp78FeC1LNG7+4=;
        b=gRTr1L/QldapkW7tIDUEHxvUVM4NKpyklBCEp/RD6+1TlfzbIvij4p/uDe00tLDoV5
         qjAxXwEJl5KRFMbzrE9aGxIWznje62ar+qmgh6LO+puxBSzNPYLdA9IN1j2Md5l7wDR5
         ZLcgm4SG+0rLVG1aJ4PX+OcRR0PvOaUkN6EUQ/XeSrv13tAKYbIKCbHqjDmws2TYLkp7
         sTK8gRfPFWk4Q207sQqFL7qmUfSAYPiOlBY3exiJ2AvR/jq/5ZAlxDJho7VFSf+4H4qQ
         TxqAi7mvGFVMpD+dQZV8vJkKfw+vwpH8yH3ZecIoC6sJAYR1dk1o8YL2GsDwnDjRVrJj
         L59w==
X-Gm-Message-State: AOAM533TG2NELjHyZiIRn5VCs02pI/iFAg4Emyi5NgOQ4H/3Tr6rJWIz
        vangB+6TX9D7vQ66nEKxnyA=
X-Google-Smtp-Source: ABdhPJz3s3uZbr2e0/pl68cyu2TvshN2/ql+aVmWQNdSIKkRhrV2ij/yHaGbIZqOmjwusPAgdTGx9w==
X-Received: by 2002:a17:902:8648:: with SMTP id y8mr10178303plt.91.1597652476410;
        Mon, 17 Aug 2020 01:21:16 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:21:15 -0700 (PDT)
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
Subject: [PATCH 21/35] dma: ppc4xx: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:12 +0530
Message-Id: <20200817081726.20213-22-allen.lkml@gmail.com>
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
 drivers/dma/ppc4xx/adma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 4db000d5f01c..71cdaaa8134c 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -1660,9 +1660,9 @@ static void __ppc440spe_adma_slot_cleanup(struct ppc440spe_adma_chan *chan)
 /**
  * ppc440spe_adma_tasklet - clean up watch-dog initiator
  */
-static void ppc440spe_adma_tasklet(unsigned long data)
+static void ppc440spe_adma_tasklet(struct tasklet_struct *t)
 {
-	struct ppc440spe_adma_chan *chan = (struct ppc440spe_adma_chan *) data;
+	struct ppc440spe_adma_chan *chan = from_tasklet(chan, t, irq_tasklet);
 
 	spin_lock_nested(&chan->lock, SINGLE_DEPTH_NESTING);
 	__ppc440spe_adma_slot_cleanup(chan);
@@ -4141,8 +4141,7 @@ static int ppc440spe_adma_probe(struct platform_device *ofdev)
 	chan->common.device = &adev->common;
 	dma_cookie_init(&chan->common);
 	list_add_tail(&chan->common.device_node, &adev->common.channels);
-	tasklet_init(&chan->irq_tasklet, ppc440spe_adma_tasklet,
-		     (unsigned long)chan);
+	tasklet_setup(&chan->irq_tasklet, ppc440spe_adma_tasklet);
 
 	/* allocate and map helper pages for async validation or
 	 * async_mult/async_sum_product operations on DMA0/1.
-- 
2.17.1

