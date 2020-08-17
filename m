Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF461245F7B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgHQIWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgHQIWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:22:03 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB053C061388;
        Mon, 17 Aug 2020 01:22:03 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh1so7122823plb.12;
        Mon, 17 Aug 2020 01:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ScSchtGkwbuHnxQx7iSsqRyAzIGJLK/PgYB9DNEv3wQ=;
        b=i0K2xoe6D97BPwpwRK9Bh8AmH4RkiEpDe127j8GQnyPUIu90NxEYUKf2ZHVd5KtzTL
         NF3Y2fB1vWs/vlujrnGz5RsfEq0VAA0E6HuZJBVgo4f+4aW5ElwqdkdPxwRLhVQ0ZGnV
         0m+tA+pHZOvQLIHsUpEFQQPETdoeGVun3IWoKQDFb5d9T+HEpOGZqwPSXibEdWt9WIfb
         8sY2pHRmZqtyU2+vBXTmpjtHjkaep4il3F0TSQJrSsrQmxt56VjhWI0bUIj02LHAv8LG
         l4MvZEBNifnlR6R76r/NT0SEoXYAfFf68rs+ZPOkXWlMhXG3sd6ixpORdSvaiGqIB99e
         V7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ScSchtGkwbuHnxQx7iSsqRyAzIGJLK/PgYB9DNEv3wQ=;
        b=tfQcW3a9ieIjPZvu+gj61PYWp1hm1pmcSx5tMlpRbzdppPxg7bzw66nm1T6ALlc6bk
         eGSYlB3gpzHw6XFLhQxHBcSZoY4CW5oyWSGFn6QUNU7n4/S/CmzcDJ+gGrbRqu5cCqer
         c8RWhyJCo/GQosgGdG/Gjg0VCOThDxJIU7wNzCDjFVgDo0D+RE5NFOaVtiSZ8z2yBWmN
         73htKg6f2CO++sS0MZBPICzmLzHMvwITrpwrsLFYfiL6lK/nAjEXG1VfadPi+h0XBa2+
         qgUWVt3cO/YLPQneGM5FppkPzofgHsO4GUcuIa/Os/uYdxDSefEXxIYjrZOF3K786tfm
         fOWg==
X-Gm-Message-State: AOAM53196+Dk8tuTBamLEKgoWlm7TbaFaUaZfHBXqhTDIzQpXC56MxQi
        7BdyvAcONyfYJwEgfK+ztHs=
X-Google-Smtp-Source: ABdhPJyd9hITb+tghZ3TwtqGp09qIUQSVnYpI+TEsezUWXwAhph40aYGEYGOpiAwvWfVEY1OHJX9zA==
X-Received: by 2002:a17:90b:1493:: with SMTP id js19mr10563329pjb.223.1597652523277;
        Mon, 17 Aug 2020 01:22:03 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:22:02 -0700 (PDT)
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
Subject: [PATCH 26/35] dma: sun6i: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:17 +0530
Message-Id: <20200817081726.20213-27-allen.lkml@gmail.com>
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
 drivers/dma/sun6i-dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 06cd7f867f7c..f5f9c86c50bc 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -467,9 +467,9 @@ static int sun6i_dma_start_desc(struct sun6i_vchan *vchan)
 	return 0;
 }
 
-static void sun6i_dma_tasklet(unsigned long data)
+static void sun6i_dma_tasklet(struct tasklet_struct *t)
 {
-	struct sun6i_dma_dev *sdev = (struct sun6i_dma_dev *)data;
+	struct sun6i_dma_dev *sdev = from_tasklet(sdev, t, task);
 	struct sun6i_vchan *vchan;
 	struct sun6i_pchan *pchan;
 	unsigned int pchan_alloc = 0;
@@ -1343,7 +1343,7 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 	if (!sdc->vchans)
 		return -ENOMEM;
 
-	tasklet_init(&sdc->task, sun6i_dma_tasklet, (unsigned long)sdc);
+	tasklet_setup(&sdc->task, sun6i_dma_tasklet);
 
 	for (i = 0; i < sdc->num_pchans; i++) {
 		struct sun6i_pchan *pchan = &sdc->pchans[i];
-- 
2.17.1

