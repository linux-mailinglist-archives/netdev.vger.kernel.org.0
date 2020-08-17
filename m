Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E208245F3A
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgHQITk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgHQITg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:19:36 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12419C061388;
        Mon, 17 Aug 2020 01:19:36 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id m8so7872604pfh.3;
        Mon, 17 Aug 2020 01:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hn4KAQ3gCFoOl9r0ujaoL0SRctsTF3JFLZ2Rz0kI31Y=;
        b=UgrPYIJbdqsyAE/Fx6gmPFEQMc7zf7xRzMLMRZQ81mNRQ8r/wsHJ5XnwLrP0u+jzbb
         dl3/wP7rbEMaBGkc9Dqh7I1vj/vWVr3IK/R+KEaSPz4L/YA1WrTHfP/DZkyv+D2dF8YO
         fGRQUc6xscqzKG31PNgreYX86TUNQz1GEkpBWD/hgEIQ3mOEeU7i4VyvByRvd2vo5xyX
         ysyJpOD0qtT+rbSeT3efFP9ythU3610pUWwg6Rnq7OGQiNd5+PSg6HNKzwO4+bFpfjUN
         htIUzpe4CYMH51WkhSfmWhRu+7rfrE6sTreHEqQTr+ON8HSS40dT+eLoYpXYWUOI8X9f
         utiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hn4KAQ3gCFoOl9r0ujaoL0SRctsTF3JFLZ2Rz0kI31Y=;
        b=glVEqdhiEwsVmQTBz0HGS39ad27gbvJjIiyOEJdJmtaTtBu9VVVoBklpTMjSkSBMqw
         1HEYEeZkq+4wkVa4RGfn7n6EUh+9d9sZcRJsyhKaDr36I1vnjHCfiFVRxQv2XjAy+F+v
         yk1kQz2GX9Q+cvn89bcnwDEjX0cKObiRnZc7ffRGBBzfqGQYMau5uYRCOSgtnBO9337M
         BjvR5WJkTciGZNAmWaNcqt4Cw0d8FafIwmtGDVDRMnlhp9WPQLB1stPDkuXkD+/drUgw
         E3AXx0HXLeMPfOC+mhBVTcMnGOmXhkIk06kzPyOiJr8iKp8Lh68d423ZPgeVka351HW5
         QfOA==
X-Gm-Message-State: AOAM530rjVxRwrceJNkJaG3o3fLBpiuDvOLywjGH+z/2hxfBJRuDH6Mp
        tfevmR9lJ0lEta2ELIvFz/I=
X-Google-Smtp-Source: ABdhPJwKzgY7w0A1JlXR4OuCaZ4g4WLJQtisLZUR6BZuNQ4S9PcFCNNh4aK23T5dkHQTo4ssudR52Q==
X-Received: by 2002:a05:6a00:91:: with SMTP id c17mr10263590pfj.151.1597652375645;
        Mon, 17 Aug 2020 01:19:35 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:19:34 -0700 (PDT)
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
Subject: [PATCH 11/35] dma: ipu: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:02 +0530
Message-Id: <20200817081726.20213-12-allen.lkml@gmail.com>
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
 drivers/dma/ipu/ipu_idmac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 0457b1f26540..38036db284cb 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1299,9 +1299,9 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void ipu_gc_tasklet(unsigned long arg)
+static void ipu_gc_tasklet(struct tasklet_struct *t)
 {
-	struct ipu *ipu = (struct ipu *)arg;
+	struct ipu *ipu = from_tasklet(ipu, t, tasklet);
 	int i;
 
 	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
@@ -1740,7 +1740,7 @@ static int __init ipu_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_idmac_init;
 
-	tasklet_init(&ipu_data.tasklet, ipu_gc_tasklet, (unsigned long)&ipu_data);
+	tasklet_setup(&ipu_data.tasklet, ipu_gc_tasklet);
 
 	ipu_data.dev = &pdev->dev;
 
-- 
2.17.1

