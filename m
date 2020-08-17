Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25594245F1D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgHQIS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgHQISZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:18:25 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E8CC061388;
        Mon, 17 Aug 2020 01:18:25 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f10so7122059plj.8;
        Mon, 17 Aug 2020 01:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aYKSRTuJVIPdNCr61TO9wwSP37OM1E0JoVpfKCdbfwU=;
        b=I6ylsGUaMfCBojePfsAD++yD9Jyf7sQWTNHKgpA2bcqRyX9BAHEfxGWEM9QDDhOFO+
         1Aj/tmhFnG3KsGf6BolUWSjdZMlfyD2uX2lkAUA42sJHEQ0a9V7YMBisyFpNRtxCnbzp
         E6oGA/Z4/l5RNBrfBcvJB8Lc5UIEbrVPPtjo0Fw7DFonrQk5k1QAAiUXTN3N6DC07bC9
         0N3KKLv43BiFGLdhyP8Xcpkrx/H3MWkerEDcMpP9FrmM/hEu60Tv3negE3rEaX21brK1
         YafNNM8/AZprasmodUSRhhhcuX/BJraUe5FQ5kfZ90HsS2Cjda4MKIVjbS6boph9Y6ks
         /hKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aYKSRTuJVIPdNCr61TO9wwSP37OM1E0JoVpfKCdbfwU=;
        b=jstKCu9BYMl3sxQIjOu3WZer+Tj9zPnbu7AlnsDEeeAXEGWF7NZb9mfcbs31cSiMH0
         MYtk82VrgntzYniLA7eveIJjQhY7TN5MnCcGSd2dXe8olKgU9dR/i1YSoQare/c1oGaJ
         JHrxwoDV+/WtAR3TvyLYT6p2Emmes6DnAz4dgeHW17I8djG1zMgKrbnzncQ1uR6Q3OJY
         ZBEb3xTY/ic/hVVfeqNjaz3wEcZHgZQrt0E7tEr/GV8N/JZDH5BjP8LsSlKvl8O+DJUL
         pafxkOIaGc0ff4rqlQtlMBcDIe6BRkQriDvGTWQZktdHBdYcsZLEWKLPgON4fgPixuLr
         rs+w==
X-Gm-Message-State: AOAM531Ga0GYRItuzFqOxKZUiHJA3s2gLFKhMKsK5N7Iq5kcF67QrZkW
        AA01+Za+bWsvEjJkrqOrOrg=
X-Google-Smtp-Source: ABdhPJypVY66AJT3+h/SfRYb56ToGyJfJnM+NnJ6R5f1ym1n7hF8zV0Xux1hjYWDHRbRMpD1vPqebw==
X-Received: by 2002:a17:90b:784:: with SMTP id l4mr11034976pjz.96.1597652305207;
        Mon, 17 Aug 2020 01:18:25 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:18:24 -0700 (PDT)
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
Subject: [PATCH 04/35] dma: coh901318: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:46:55 +0530
Message-Id: <20200817081726.20213-5-allen.lkml@gmail.com>
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
 drivers/dma/coh901318.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 1092d4ce723e..95b9b2f5358e 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1868,9 +1868,9 @@ static struct coh901318_desc *coh901318_queue_start(struct coh901318_chan *cohc)
  * This tasklet is called from the interrupt handler to
  * handle each descriptor (DMA job) that is sent to a channel.
  */
-static void dma_tasklet(unsigned long data)
+static void dma_tasklet(struct tasklet_struct *t)
 {
-	struct coh901318_chan *cohc = (struct coh901318_chan *) data;
+	struct coh901318_chan *cohc = from_tasklet(cohc, t, tasklet);
 	struct coh901318_desc *cohd_fin;
 	unsigned long flags;
 	struct dmaengine_desc_callback cb;
@@ -2615,8 +2615,7 @@ static void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 			INIT_LIST_HEAD(&cohc->active);
 			INIT_LIST_HEAD(&cohc->queue);
 
-			tasklet_init(&cohc->tasklet, dma_tasklet,
-				     (unsigned long) cohc);
+			tasklet_setup(&cohc->tasklet, dma_tasklet);
 
 			list_add_tail(&cohc->chan.device_node,
 				      &dma->channels);
-- 
2.17.1

