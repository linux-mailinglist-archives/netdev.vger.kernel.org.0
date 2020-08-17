Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C932245F73
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgHQIVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728226AbgHQIVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:21:45 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF117C061388;
        Mon, 17 Aug 2020 01:21:44 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so7116417plk.13;
        Mon, 17 Aug 2020 01:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uH6lh/wm+k3oIhHiZx2SeVnKtHemKJugMwQhBtWwEsY=;
        b=pkHoMNTnBvBUY5wBnHq75aCKuxAgQAtFGnNZutY84jkzUGpyGZ6d/Lyt+P9feDGCmy
         oi5lOvVO7mwSRWBMI975qjlEqiWyRj9sLI9IKUYbo5xLFi2aEMIgvbIPHMNpl8I+S56X
         BDvNmlJ4DNOKPp2eTtWU1pi1nr9KPOFq5KQuJ4DW5r0Rz4og/KIwz3sgnQe5PVxdOedv
         BUTsFgaLQY4W7NY17bprObegQF47stPp4ILtIK9vzrJjv58M+JSJjtbLV01fLk+i/0Ff
         ZXGZ2N9nBxreCbE0WDGBaJrhwsSYKbjj/dkdz/u7S3PIm3OE4MnmO01ap+pIF614uhqQ
         GOgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uH6lh/wm+k3oIhHiZx2SeVnKtHemKJugMwQhBtWwEsY=;
        b=WszQ1NocWyOngqMdPgwoAE2VfyOMLL7TGgDPLgHFnru6MQJiKPtXM6AxYUdhBoNTRf
         zUND0KFbV5ZneWRVxmaQDMVNpRRXnMMPGhzx5Bl7UXzg0Az2+8OU1NCsInaiCGNVzFER
         dERdSTtzUHwGPzSh2zvx7WVcvf4RFWLoP9jujiFUcVBJotcwuZXfDTQSR/gGM1lnShb1
         ppjvB1vjCERsyGNmI80+tRA78XiT87sD5hW+7oiuUVQh2jdA2cFkju87mV5Mc8jPZkqc
         XTUzSMOqbQKY9QqXltinRfUGYKRMEcc0pAICOADK/tOVWXyfkKUsS1e2/+EOTAXNH8NS
         r3kA==
X-Gm-Message-State: AOAM532bZFT7quhBmvfM3LcFW55wOiHWd2vrkkJIIncko/wlZy3P/6OX
        cdBmQbhJwPAFisgJeYIHCIc=
X-Google-Smtp-Source: ABdhPJyAiC+gLop7N7yDKbnn4HN8Ga+G44y9G0wc3Fi3VEqVxz0aWSYAszxNuQ4brCXqCbddv6Jlvw==
X-Received: by 2002:a17:902:a412:: with SMTP id p18mr10268881plq.3.1597652504569;
        Mon, 17 Aug 2020 01:21:44 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:21:44 -0700 (PDT)
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
Subject: [PATCH 24/35] dma: sirf-dma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:15 +0530
Message-Id: <20200817081726.20213-25-allen.lkml@gmail.com>
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
 drivers/dma/sirf-dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 30064689d67f..a5c2843384fd 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -393,9 +393,9 @@ static void sirfsoc_dma_process_completed(struct sirfsoc_dma *sdma)
 }
 
 /* DMA Tasklet */
-static void sirfsoc_dma_tasklet(unsigned long data)
+static void sirfsoc_dma_tasklet(struct tasklet_struct *t)
 {
-	struct sirfsoc_dma *sdma = (void *)data;
+	struct sirfsoc_dma *sdma = from_tasklet(sdma, t, tasklet);
 
 	sirfsoc_dma_process_completed(sdma);
 }
@@ -938,7 +938,7 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 		list_add_tail(&schan->chan.device_node, &dma->channels);
 	}
 
-	tasklet_init(&sdma->tasklet, sirfsoc_dma_tasklet, (unsigned long)sdma);
+	tasklet_setup(&sdma->tasklet, sirfsoc_dma_tasklet);
 
 	/* Register DMA engine */
 	dev_set_drvdata(dev, sdma);
-- 
2.17.1

