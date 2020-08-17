Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069A4245F9E
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgHQIXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbgHQIXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:23:33 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF21C061388;
        Mon, 17 Aug 2020 01:23:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t6so7345693pjr.0;
        Mon, 17 Aug 2020 01:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8m7i7NFD9jtK5LLWJqp7H8mCeAZp9HPWo5wwi/RHp1g=;
        b=shhgpJ08JxORr1lpKJUfn3rchd09xpy5GGqJOy+g9NZHI2yF93ITXi9gFGnHqql9PN
         IIqTRGM+YqPsbWPrgC9E5xcKRbIjXdKqoLaeQRRLy+BgZ0VlNpUtYLYotj9zO/XVLva2
         +Tllzxp32+qQBUXckBM4g+opSCRbBgFt5ss7ET0g7omdzkYjanAgDryppqe6/vD/LI6c
         6wkO4DAHsGqPFCf/eJ8A+MkhjsJ3eYHTsE7LczIFRuKKANtSFih6SHGz/cqeYpOIT9Jl
         HxCJg00kHcNEYxKHr7oEq3LU6Jw+8qU4B+UYcCRUEaTTnfKB2ZJEdkXfVIujaTMUF+yw
         YWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8m7i7NFD9jtK5LLWJqp7H8mCeAZp9HPWo5wwi/RHp1g=;
        b=exEjeocWw7iRLAma61FpooRQ9KNDQYKjya0Yq5kKYeFCXLM3neP0W6MgXoaDOrPCGx
         X04TDGBmmCZY3jTpU4iw8+08O1TS7Rg+/SvhGClXDHpQefS+BMSaNiP1HjCi9n6lwlRA
         cJMwOTKTQsmr8dgAcS5jmRqnWqNlZW1pzgSGtZCPK+eSIZNfJNCNkUQ3gd4c3ArqEY52
         jB5PBxsNSROGo6uijfWgAIqCYCyXWTf9pzoQ63ZCkGnkQvodz+jdkN3a0UDcQ5jaW2J+
         JnEigUphB3tcXwHd7KwtOaQ+AwgELc929xeAQ1mqRyNVCyOKx0n10/ASxpigMLM3roFV
         l8TQ==
X-Gm-Message-State: AOAM533Pquo9Q+MkL3fh+rTxNkEADHwH46DiYSnXTilCuXwysn6vBIae
        MSYCgCzMJduTg53PMF5cKZY=
X-Google-Smtp-Source: ABdhPJwa4r12zdeyzw2uMxlu/O5WMxHHX7aUf3vUQzREnZb/8WCIoQnzmvYJMcX5iK2KOq5isJHTnA==
X-Received: by 2002:a17:902:5991:: with SMTP id p17mr10568056pli.78.1597652612472;
        Mon, 17 Aug 2020 01:23:32 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:23:32 -0700 (PDT)
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
Subject: [PATCH 35/35] dma: k3-udma: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:26 +0530
Message-Id: <20200817081726.20213-36-allen.lkml@gmail.com>
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
 drivers/dma/ti/k3-udma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index c14e6cb105cd..59cd8770334c 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -2914,9 +2914,9 @@ static void udma_desc_pre_callback(struct virt_dma_chan *vc,
  * This tasklet handles the completion of a DMA descriptor by
  * calling its callback and freeing it.
  */
-static void udma_vchan_complete(unsigned long arg)
+static void udma_vchan_complete(struct tasklet_struct *t)
 {
-	struct virt_dma_chan *vc = (struct virt_dma_chan *)arg;
+	struct virt_dma_chan *vc = from_tasklet(vc, t, task);
 	struct virt_dma_desc *vd, *_vd;
 	struct dmaengine_desc_callback cb;
 	LIST_HEAD(head);
@@ -3649,8 +3649,7 @@ static int udma_probe(struct platform_device *pdev)
 
 		vchan_init(&uc->vc, &ud->ddev);
 		/* Use custom vchan completion handling */
-		tasklet_init(&uc->vc.task, udma_vchan_complete,
-			     (unsigned long)&uc->vc);
+		tasklet_setup(&uc->vc.task, udma_vchan_complete);
 		init_completion(&uc->teardown_completed);
 		INIT_DELAYED_WORK(&uc->tx_drain.work, udma_check_tx_completion);
 	}
-- 
2.17.1

