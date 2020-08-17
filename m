Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE432245F30
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgHQITY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgHQITQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:19:16 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0178C061388;
        Mon, 17 Aug 2020 01:19:16 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id v15so7756474pgh.6;
        Mon, 17 Aug 2020 01:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jWR4tpYKdIgwTfTifXGcZkODpDZhHIDKqvJr9MK44Qo=;
        b=OYFh+2d+PvKPM1X1rs+IA+8SX7qx1z1ncQwibPS2FwYo+kTpxsmxlZE9XxbUtNm+tv
         AtBfUUth4VbOKdd2rod3vSx5BrzO6OfIsUX4eNFbo63ls/Un+mZgFuOI9zrd5PSmi0mW
         H16w2TyJV7ro8jO/jGh4t4forYJtnlH6hrEdr4/bfLh3c7tlqcu7pV8ykwMCV1ujbk1I
         /vRGMPVCJk6q71CRLDZ896xcZRAOaVw4MLpDpGh/5Rfo8xdzG+956Z1u+uG0lqEebRuf
         G+wjGGZFdWy/VHbmmvR2INPNPdeEJO0RrFN0fVosHIqm+ZdcpzHMVsoAyb+OwlMi1/EG
         vONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jWR4tpYKdIgwTfTifXGcZkODpDZhHIDKqvJr9MK44Qo=;
        b=fhqJtMJVL9xuntPnTmzc5Mz9U51/5GHSWNqQUCvD9N666dQlKf1+bBS6P9IwzyX7d0
         V61QKq7pEXzrJNKdL38X3TU61HFATD8RPTeI7Pt52yVUsHacRD7KpXid94tXeRd9Vbjz
         /E49H7WYzfKttKx/Q60HwtSrRBsl/hoClv/t7s12ezFzb+pKONBOOcE9GZbUtTOGrROy
         VyFFvHSnlWSvhBeenV/iajESghFkX3axGlIIZkx1cQt5HSTOELy8yvmcxKLZKKTJajCQ
         rpyom8LC6ktDmGqBU814FWS8sjFOQgF/2VWJDNe8o17E2DJ5YA0x801z78tKCYtI1VDr
         Buyg==
X-Gm-Message-State: AOAM533t6SmMPO0MmGQtdPgJyOW/p/Ha9PIV7Cr8gijpLqKu6Zugq6Wz
        gzmCKutg+n9dNZCiaXwPXVw=
X-Google-Smtp-Source: ABdhPJzQZQ8jCbyqROLlM27Ni7dlU0vjA+PPip0ZkkUZjaj/KtF/PrsiQ7sLHmgguZb6B+CXPAkl7w==
X-Received: by 2002:a63:fa09:: with SMTP id y9mr9461516pgh.0.1597652356434;
        Mon, 17 Aug 2020 01:19:16 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:19:15 -0700 (PDT)
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
Subject: [PATCH 09/35] dma: ioat: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:00 +0530
Message-Id: <20200817081726.20213-10-allen.lkml@gmail.com>
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
 drivers/dma/ioat/dma.c  | 6 +++---
 drivers/dma/ioat/dma.h  | 2 +-
 drivers/dma/ioat/init.c | 4 +---
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index a814b200299b..bfcf67febfe6 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -165,7 +165,7 @@ void ioat_stop(struct ioatdma_chan *ioat_chan)
 	tasklet_kill(&ioat_chan->cleanup_task);
 
 	/* final cleanup now that everything is quiesced and can't re-arm */
-	ioat_cleanup_event((unsigned long)&ioat_chan->dma_chan);
+	ioat_cleanup_event(&ioat_chan->cleanup_task);
 }
 
 static void __ioat_issue_pending(struct ioatdma_chan *ioat_chan)
@@ -690,9 +690,9 @@ static void ioat_cleanup(struct ioatdma_chan *ioat_chan)
 	spin_unlock_bh(&ioat_chan->cleanup_lock);
 }
 
-void ioat_cleanup_event(unsigned long data)
+void ioat_cleanup_event(struct tasklet_struct *t)
 {
-	struct ioatdma_chan *ioat_chan = to_ioat_chan((void *)data);
+	struct ioatdma_chan *ioat_chan = from_tasklet(ioat_chan, t, cleanup_task);
 
 	ioat_cleanup(ioat_chan);
 	if (!test_bit(IOAT_RUN, &ioat_chan->state))
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index f7f31fdf14cf..140cfe3782fb 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -393,7 +393,7 @@ int ioat_reset_hw(struct ioatdma_chan *ioat_chan);
 enum dma_status
 ioat_tx_status(struct dma_chan *c, dma_cookie_t cookie,
 		struct dma_tx_state *txstate);
-void ioat_cleanup_event(unsigned long data);
+void ioat_cleanup_event(struct tasklet_struct *t);
 void ioat_timer_event(struct timer_list *t);
 int ioat_check_space_lock(struct ioatdma_chan *ioat_chan, int num_descs);
 void ioat_issue_pending(struct dma_chan *chan);
diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 8a53f5c96b16..191b59279007 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -767,8 +767,6 @@ ioat_init_channel(struct ioatdma_device *ioat_dma,
 		  struct ioatdma_chan *ioat_chan, int idx)
 {
 	struct dma_device *dma = &ioat_dma->dma_dev;
-	struct dma_chan *c = &ioat_chan->dma_chan;
-	unsigned long data = (unsigned long) c;
 
 	ioat_chan->ioat_dma = ioat_dma;
 	ioat_chan->reg_base = ioat_dma->reg_base + (0x80 * (idx + 1));
@@ -778,7 +776,7 @@ ioat_init_channel(struct ioatdma_device *ioat_dma,
 	list_add_tail(&ioat_chan->dma_chan.device_node, &dma->channels);
 	ioat_dma->idx[idx] = ioat_chan;
 	timer_setup(&ioat_chan->timer, ioat_timer_event, 0);
-	tasklet_init(&ioat_chan->cleanup_task, ioat_cleanup_event, data);
+	tasklet_setup(&ioat_chan->cleanup_task, ioat_cleanup_event);
 }
 
 #define IOAT_NUM_SRC_TEST 6 /* must be <= 8 */
-- 
2.17.1

