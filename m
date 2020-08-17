Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A73D245F4F
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgHQIU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbgHQIUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:20:20 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF6EC061388;
        Mon, 17 Aug 2020 01:20:20 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y6so7139646plt.3;
        Mon, 17 Aug 2020 01:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ciey4QNzrHRDVKJ8tzpjEmlmjYecYc8dBp9iK+FHt5M=;
        b=GLX/Udd5tRebzj17DAsk32nKkuKq6qYgYAA8Ky5wQ5P4cQogSbBbaFIMyGh8Y86VZt
         wYUU5DgcowgC3uxy73fZRdoZ5KZmLb9uHoM94LbDz7oyNcaenDC5HJl0iStCi8eGMy3E
         wjthrsKSMZrbEyoXtZyUHaUFFixSuIJ+FpgUUDl31tUNcVYv/LsO4SbO/RWiDQPREHNb
         zp9rJGwc2w2GrxZ3qcn8QZyrIgYK+TIXdW+2qfHAjnqswD00sMvZQLa5jLG5Wt5sQz27
         7v1L8ZouQY+TtruCA3udb7q5lmoqhJjGatDH1tPOIr9cVOnfXykv8lNvKhiyMhUHl0E2
         8Gag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ciey4QNzrHRDVKJ8tzpjEmlmjYecYc8dBp9iK+FHt5M=;
        b=RCBl7/6bZ+MFmNE0zZ8mI5D8AkNug7b255/RBgd546zyYYjWBzrdLKdqhFt4XzG7Sw
         tnlqTjo1SCZHg77STlSg63tZHn3+WiQIqiCGK01etMWhvJWgfkUPzGmcTbco8OtZ0NbE
         oxLJOF+K4dfuRuCkDVcfGKcaaGaWcGJTN9x+A2t38M8kfE+oWRQwYyB2JFu3G6EMPRXi
         kaJ7TxJHCOY6V4DEG56q5FqqgrBOb3Cp14/RVEnxKjh5+OOA9Zc0UCBb1pO6kf8wKx4D
         2/3mTS3mBjIFeUueUwBsNf2lXMh9l5NVxF5QdJYa4d014MiVhx0akDGZ08ztrq0TiMur
         6l2Q==
X-Gm-Message-State: AOAM533Tkk2sFZ9+HKJN/HCn/otKcxW1dbUX2YOg1vGNBMCGbmbw7OVK
        GhrkxVNCqTBX9j8Y0sTcUO0=
X-Google-Smtp-Source: ABdhPJz0F2US9fqARZfMJyfWp/s0XGl+JzpTQcpPKUV44N0W4/T09Rn8XRozs4MxA4z0xakNHtFzDw==
X-Received: by 2002:a17:90b:2092:: with SMTP id hb18mr12054250pjb.118.1597652420174;
        Mon, 17 Aug 2020 01:20:20 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:20:19 -0700 (PDT)
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
Subject: [PATCH 15/35] dma: mpc512x: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:06 +0530
Message-Id: <20200817081726.20213-16-allen.lkml@gmail.com>
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
 drivers/dma/mpc512x_dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index dc2cae7bcf69..c1a69149c8bf 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -414,9 +414,9 @@ static void mpc_dma_process_completed(struct mpc_dma *mdma)
 }
 
 /* DMA Tasklet */
-static void mpc_dma_tasklet(unsigned long data)
+static void mpc_dma_tasklet(struct tasklet_struct *t)
 {
-	struct mpc_dma *mdma = (void *)data;
+	struct mpc_dma *mdma = from_tasklet(mdma, t, tasklet);
 	unsigned long flags;
 	uint es;
 
@@ -1009,7 +1009,7 @@ static int mpc_dma_probe(struct platform_device *op)
 		list_add_tail(&mchan->chan.device_node, &dma->channels);
 	}
 
-	tasklet_init(&mdma->tasklet, mpc_dma_tasklet, (unsigned long)mdma);
+	tasklet_setup(&mdma->tasklet, mpc_dma_tasklet);
 
 	/*
 	 * Configure DMA Engine:
-- 
2.17.1

