Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5FB245F26
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgHQISu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgHQISQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:18:16 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C01C061389;
        Mon, 17 Aug 2020 01:18:16 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t10so7119076plz.10;
        Mon, 17 Aug 2020 01:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VuEUvmYOOxy0cBG1vy1x0k+OUnxToU/d3epXaoj+zgU=;
        b=N+PqmoMsa7OSrh+YQoRWbjcFhyvAZVpnAGN18Dq9JnExrNg1QK1YiDTfCKZWX0tzAU
         w0Zv/q4BWvCVtYiBfxDO5AN18qkpPyECLdQM2sHFbyPzeAGVGdx1mGpOCt0IaXqUd3Mg
         /aiQZlslyJOYdh8VUcL0yXF3dJ7Q1LMsB8zAbDOEGpUcfKrPorsxdu5Qz/XnPbEPdy4B
         THV+bJCufjjEx4mVBDuLeJQWYBIiHX5Dxiq0N7Fit+YRUFklquEoieue7mHVIO5+HU9y
         bxOXL9nx9QPjhA9TOMwq1tLPi38SgRYtHGENItORu5NwrcVAl59CHDzoy4jqUksgAt+i
         rsBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VuEUvmYOOxy0cBG1vy1x0k+OUnxToU/d3epXaoj+zgU=;
        b=p+biaUZNIMKU/nSQaf93UptD+bnJoUCz/NCElmVpsDvKEje0WuoN/2MQD0MSFlY3AW
         BUIAd4HHmxxTZSeH0cuuTmaJTG63KTAV8IOaMO/u85RhYKr+f6omb80UHZIyO9Fj76RI
         1dJCbmnHNB0VjMxhunjbppQxzLa2958NwrYKJZoMopekIZLar6CQ75gMrNxXC30E3X44
         KaWDkXW6F06jzwCRfMMEVH53bELKeJ+5NydYBhtRFXQGSckVUZ9hhoto6PTp0aAa7+k4
         X42Zb8YukOSJn0FjWaR1iBFNeNomlqDFYgrBqHsiNKc6vIV/wGhWI7atPysnsZtmuX1S
         yl+g==
X-Gm-Message-State: AOAM531+9Y/9PD9/Y/5dVvcf3bupNdi9ahduZkO67ilpxG4Ju8QYjjXQ
        TwW6ee1lGnlWweJL4GsuNRs=
X-Google-Smtp-Source: ABdhPJxdwkKw4yzWqHKwHEGaahSJ53uh/FCPjaY9jium8wPVcefU6BXuAp+4B0DoFuGrH/xG8g/t3g==
X-Received: by 2002:a17:90a:46c2:: with SMTP id x2mr11593387pjg.184.1597652296086;
        Mon, 17 Aug 2020 01:18:16 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:18:15 -0700 (PDT)
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
Subject: [PATCH 03/35] dma: at_xdmac: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:46:54 +0530
Message-Id: <20200817081726.20213-4-allen.lkml@gmail.com>
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
 drivers/dma/at_xdmac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index fd92f048c491..18fc0f3f817f 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1615,7 +1615,7 @@ static void at_xdmac_handle_error(struct at_xdmac_chan *atchan)
 
 static void at_xdmac_tasklet(unsigned long data)
 {
-	struct at_xdmac_chan	*atchan = (struct at_xdmac_chan *)data;
+	struct at_xdmac_chan	*atchan = from_tasklet(atchan, t, tasklet);
 	struct at_xdmac_desc	*desc;
 	u32			error_mask;
 
@@ -2063,8 +2063,7 @@ static int at_xdmac_probe(struct platform_device *pdev)
 		spin_lock_init(&atchan->lock);
 		INIT_LIST_HEAD(&atchan->xfers_list);
 		INIT_LIST_HEAD(&atchan->free_descs_list);
-		tasklet_init(&atchan->tasklet, at_xdmac_tasklet,
-			     (unsigned long)atchan);
+		tasklet_setup(&atchan->tasklet, at_xdmac_tasklet);
 
 		/* Clear pending interrupts. */
 		while (at_xdmac_chan_read(atchan, AT_XDMAC_CIS))
-- 
2.17.1

