Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF36245F8A
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgHQIW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgHQIWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:22:51 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B33C061389;
        Mon, 17 Aug 2020 01:22:51 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a79so7857601pfa.8;
        Mon, 17 Aug 2020 01:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K7Q+JLR8+W/rWkKJtwswByUgPhPynE2pfcWEkcTUtiM=;
        b=RWiqS0NjR5pWuZhqmNoy+E4MnkeCIRO+ngM8BUOuKzwEHQm28K+TNu8Ql/pRFZ6o+a
         ig71ooeNimb8NNb5hxmNUoHadcZFXlatv8afTGeclF7DVGLEl80zM/xxnAVWDzsf+dFk
         Rs+OzW2zsNgWc8xXYp+nyR4jVXwg/5yC22ILxI3bR8cwHvUfWrpmq8TL2qs0YLF03qXk
         YgVJHokzq0jyIA0G8zVPl/GYmss8dGHDb6V6PyDjOE6w3wlutcco45Ds1cqfAwtbLiUc
         zdRxDLHzVTLNT3NpC2QUjzqte7NvzHvs1y6EcCXkzJbVcBfGlphRWACjnn+s6JAnsYjO
         l9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K7Q+JLR8+W/rWkKJtwswByUgPhPynE2pfcWEkcTUtiM=;
        b=BCix5UEGB5hlhqecGfQ6mAixUvU4Urqixkp716y/v/9FQ/xvfPIOhKA/IwdIxWEQe1
         j55ls9zFGMT2guaAjRaTB/6fnc1dHg/yuD0aX1KRJz9s4VVyGxFqwbTP35UWgMAi3VHT
         ZwackyCwV0YhwLHbDEFKkTweSVw+rcIkRLTK5v7p19JKx2/8pUSF9JtantBhgp1LzphY
         juVXMckQVyHG+zp4EY88Cwi0avBnnxBTxyGdERVbPiLd2sfipO/ArqhlAKl+sXC7Fpmb
         uGbnDK1C51C+iDFwTA4da9Y5K2SAbMsjp3xAYPLFIW8br62VjSXb7XD2Cm/QNcCwWzAc
         5fwA==
X-Gm-Message-State: AOAM532uYYZXHAHMkATrCncxoFO8SIiqYrJ63VV1Oned9+L+ID32VmXD
        ifSFjOlVSAX6g8Mg3CVTmRg=
X-Google-Smtp-Source: ABdhPJwJDGhQfZ+pLbcNjt9w+RQvcAMUzKo2R1igy7gIEXDlsJaWZHPSR5xpse+9lSMXYCtYc+wF6g==
X-Received: by 2002:a63:4c57:: with SMTP id m23mr8909063pgl.77.1597652570727;
        Mon, 17 Aug 2020 01:22:50 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:22:50 -0700 (PDT)
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
Subject: [PATCH 31/35] dma: xgene: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:22 +0530
Message-Id: <20200817081726.20213-32-allen.lkml@gmail.com>
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
 drivers/dma/xgene-dma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/xgene-dma.c b/drivers/dma/xgene-dma.c
index 4f733d37a22e..3589b4ef50b8 100644
--- a/drivers/dma/xgene-dma.c
+++ b/drivers/dma/xgene-dma.c
@@ -975,9 +975,9 @@ static enum dma_status xgene_dma_tx_status(struct dma_chan *dchan,
 	return dma_cookie_status(dchan, cookie, txstate);
 }
 
-static void xgene_dma_tasklet_cb(unsigned long data)
+static void xgene_dma_tasklet_cb(struct tasklet_struct *t)
 {
-	struct xgene_dma_chan *chan = (struct xgene_dma_chan *)data;
+	struct xgene_dma_chan *chan = from_tasklet(chan, t, tasklet);
 
 	/* Run all cleanup for descriptors which have been completed */
 	xgene_dma_cleanup_descriptors(chan);
@@ -1539,8 +1539,7 @@ static int xgene_dma_async_register(struct xgene_dma *pdma, int id)
 	INIT_LIST_HEAD(&chan->ld_pending);
 	INIT_LIST_HEAD(&chan->ld_running);
 	INIT_LIST_HEAD(&chan->ld_completed);
-	tasklet_init(&chan->tasklet, xgene_dma_tasklet_cb,
-		     (unsigned long)chan);
+	tasklet_setup(&chan->tasklet, xgene_dma_tasklet_cb);
 
 	chan->pending = 0;
 	chan->desc_pool = NULL;
-- 
2.17.1

