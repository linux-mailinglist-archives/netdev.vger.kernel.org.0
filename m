Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA603245F17
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgHQISN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHQISH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:18:07 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411A1C061388;
        Mon, 17 Aug 2020 01:18:07 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f9so7330292pju.4;
        Mon, 17 Aug 2020 01:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RCQBB24TVyQgJJKqQrd+pMSwLixAZ8RHZ/Oe1XSH5Ms=;
        b=CpZtowomUtwba5d+9jG3umtKblXH0Nv9enQMbrOs6GYgS65k2pOGxHWdIWP2HSmvN2
         UTdqM9Ncf5dEJKdISwV6uubgdu8uI7cYuG1eQXJn6kbbH8gKtCrdZO07OHnFp4RHnQRr
         XzQcPkzksCDZYle4I0axA1CnUQMWX652Fy2AFVu32HNSRSw9hOi+fIAKuLBBrELgJXHZ
         sykti7yWoxKWEDjSPKRiIB3Z6Kse+8MQWiVxR3a2xzpZjSQnMxbI5Jvjg/JdCl31Cd7a
         0oU4NiFpQWsjEi6zpSFOYz0olNYeMB+kX3knAyb76mWd2VjY1RAHjESHDDQczHrA6pfR
         2C0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RCQBB24TVyQgJJKqQrd+pMSwLixAZ8RHZ/Oe1XSH5Ms=;
        b=ZVnEH5q1nH2QVuDZx+n7yk0E+MTx3TVG147CNXYRpDyNBC0MngIzK2senSbxUzmwJ3
         CtD06ogBx73LbpHFvlt7kRRwW8vBJw/h4LrLqsq49HiMtCIfyxUwuJfRq/x60j3C5hgR
         +JHzlvT8WmIixPuOYBCK687L+D+y05ItAXYFPgezdWBqStKAowIE9ho69ygFrmdN5Vou
         ejf5xY3Zkpv6BfbfSXlL3XUuLPKNtbBqE6dex+Hztn3uuAUD2LzAWY3Lfq3/CdZh6w85
         9ECdbfUHyjLpMI/kdVZZ8Eq4bGDl/boSSznFWpTfYBlxA93v8V93umD2gszv+6as6bto
         d8nw==
X-Gm-Message-State: AOAM530xJGi4A4THKiMsaL8/kW/lMEoXuu5bYrX9e6Wc1bmlkV/50Lqj
        G7AI9RP0EQe+QrmWQCPE520=
X-Google-Smtp-Source: ABdhPJwxa56ov/nlIFhSPEveChi/D5g+3jgKhjy/JdPQQGEGTnn9XaevZeRC4yuK/+UJ9g0YArNzag==
X-Received: by 2002:a17:90a:ea82:: with SMTP id h2mr7951833pjz.75.1597652286870;
        Mon, 17 Aug 2020 01:18:06 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:18:06 -0700 (PDT)
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
Subject: [PATCH 02/35] dma: at_hdmac: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:46:53 +0530
Message-Id: <20200817081726.20213-3-allen.lkml@gmail.com>
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
 drivers/dma/at_hdmac.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 45bbcd6146fd..4162c9a177e0 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -598,9 +598,9 @@ static void atc_handle_cyclic(struct at_dma_chan *atchan)
 
 /*--  IRQ & Tasklet  ---------------------------------------------------*/
 
-static void atc_tasklet(unsigned long data)
+static void atc_tasklet(struct tasklet_struct *t)
 {
-	struct at_dma_chan *atchan = (struct at_dma_chan *)data;
+	struct at_dma_chan *atchan = from_tasklet(atchan, t, tasklet);
 
 	if (test_and_clear_bit(ATC_IS_ERROR, &atchan->status))
 		return atc_handle_error(atchan);
@@ -1885,8 +1885,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&atchan->queue);
 		INIT_LIST_HEAD(&atchan->free_list);
 
-		tasklet_init(&atchan->tasklet, atc_tasklet,
-				(unsigned long)atchan);
+		tasklet_setup(&atchan->tasklet, atc_tasklet);
 		atc_enable_chan_irq(atdma, i);
 	}
 
-- 
2.17.1

