Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B7A245F56
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgHQIUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgHQIUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:20:39 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F46C061388;
        Mon, 17 Aug 2020 01:20:39 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u128so7864829pfb.6;
        Mon, 17 Aug 2020 01:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EzH+Sxo0+kwwV/JFv4Jtew4uUPj7pfAWvGnBJqZX2kA=;
        b=N6tTDOge5tw8M9NkByFSkZhki08OpnX3cup9whr2OMRwTNmIRwnuxH500ufS6O6oYS
         9FwpkqCZmeIIAgtaJ1Po0e7eVnFwKT04tK34TuAMkx9yH6h1dvT117uPFsIWWPThMxiP
         HKnxvP/bZCTY5ufO77byooN31q+rQ+5XdnI7EQ13QfikscWEvjP1FEsd4KmH1Mm2gIZA
         Bft6yyJObH0zEcNyrbgq8c5WQKWK6LBXQeDLKi5gSODm5B1wfSlDPsvT0o84CfMWqFYL
         v27valKSh6+yD8503cTOqT4+5Gk24FNFTz6tNnXObVLwcejLDdkz9xxUMbDiCIG0p+O6
         Fr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EzH+Sxo0+kwwV/JFv4Jtew4uUPj7pfAWvGnBJqZX2kA=;
        b=qWn7gfS0fsPk4fIUzt9hPLKFI9tnZZAfhHrJBz2EheYmv608LYIBZYWHZ7h40oMN8v
         i1O3ueX9fxtzNiNQ3u6GKwPkK54aaDjdCDurvC3e+ThzsIcL3HuYTJFL/nink63TXaoI
         vSUpcR+JdDcgITG7mPcwqrxKz6DQD9aJ6gXMhZdTdaDiGUIO9w9Rpp/tvzmh9YniKY2G
         hEe0NH8RdWp3KLguPffXdwlSCOCdFZzAE4hSIkgZJsbrjjr5nrzL8kp38xghlsH57KjA
         hCimA6OSYyQOQXCaWJfC9p7N8Jklo4vCnzr5QrVQ2Vv2tP7xlrq8BGEqQ4JORn9F3HLE
         VMkQ==
X-Gm-Message-State: AOAM5303hy23fI9IZfGvERv5XSbuDv6lIMZm+KhKXlmvdPnJI7Fyg3jR
        +Pj6Sj9mPNE5IGZEn+IYLvQ=
X-Google-Smtp-Source: ABdhPJyEDiiZcn2swD/FpmaQCjF3kpL10RdAb85gFToheYdre6qGu2gKaqG6UhP4EQqqRrv6fRYNDA==
X-Received: by 2002:aa7:9f8a:: with SMTP id z10mr10836424pfr.176.1597652439296;
        Mon, 17 Aug 2020 01:20:39 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:20:38 -0700 (PDT)
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
Subject: [PATCH 17/35] dma: mxs-dma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:08 +0530
Message-Id: <20200817081726.20213-18-allen.lkml@gmail.com>
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
 drivers/dma/mxs-dma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 3039bba0e4d5..6f296a137543 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -320,9 +320,9 @@ static dma_cookie_t mxs_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	return dma_cookie_assign(tx);
 }
 
-static void mxs_dma_tasklet(unsigned long data)
+static void mxs_dma_tasklet(struct tasklet_struct *t)
 {
-	struct mxs_dma_chan *mxs_chan = (struct mxs_dma_chan *) data;
+	struct mxs_dma_chan *mxs_chan = from_tasklet(mxs_chan, t, tasklet);
 
 	dmaengine_desc_get_callback_invoke(&mxs_chan->desc, NULL);
 }
@@ -812,8 +812,7 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
 		mxs_chan->chan.device = &mxs_dma->dma_device;
 		dma_cookie_init(&mxs_chan->chan);
 
-		tasklet_init(&mxs_chan->tasklet, mxs_dma_tasklet,
-			     (unsigned long) mxs_chan);
+		tasklet_setup(&mxs_chan->tasklet, mxs_dma_tasklet);
 
 
 		/* Add the channel to mxs_chan list */
-- 
2.17.1

