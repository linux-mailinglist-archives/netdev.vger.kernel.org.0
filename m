Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71345245F27
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgHQITA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgHQISy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:18:54 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26ACC061388;
        Mon, 17 Aug 2020 01:18:54 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e4so7459016pjd.0;
        Mon, 17 Aug 2020 01:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=31As0TImtle4pJMBIPFKRSxatdRKcSvERFzrO8LgibE=;
        b=kVYLm00pzoz/kYADfRgu3biXEv4rb/ftLTz6v+Mm2Ug1uaoBSCJnXIC+O5/vlEqHEG
         SoN3MeizX3SsTGtWi6lLT9/XOUnxZn/8BU5hyYewUWLtJfBx1RGXKoxz0pPr7dx+pghg
         M69hQ46jFRp9eVSk7AR9qrZQAp0f37Kc+9Kk24UnbEqn+oajrWQG3MApns/YsJSZV7qC
         siz5ss3nuBGRrY6Mk/RvwVMbxpPKrWRPH5w8tLvplV3bADjPVgOmly7i4G9W49hfdmb5
         /Y17AISDHxF/rZ0dkCDnZKnr/Mbd4cPQ5DApM8nSF4Yo0pFYNuJi3oYRNJIU6q03IpKG
         IKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=31As0TImtle4pJMBIPFKRSxatdRKcSvERFzrO8LgibE=;
        b=XzhOBVAvXld+CCkSPwN+c3BpLz5CVKDjavq7QSA3kGmAMMCT5VEt2qw9ZFKMuL25BP
         OVOpLiI59Gkz8fic+egr5ZCZ9p9UbzjiaPwfzBHprSTpdHhLpS7tEb56KuT38zlNDyLc
         mnwpLuLjoP9NGIuPZWyeKTjfG1Z6maKRS1Ez8TJZqzJ76PqvM67scOYlnGNtgksN76bR
         1QqZtVwsljPg7rhlEfCnp3YSfICqNs/QDDSn1FsXFo7SXlpyJkJLeIdTbCvFqmXWekjf
         LpPQ4W78pxT6kVosNI28glxS6asKVZyvz/+WttvOMDtk/U4Psk878MGI3RDOfrfW4qPY
         A+Fw==
X-Gm-Message-State: AOAM533oaQelse3mQRlYuMdZL8eBNXYMuth0BLP4ebJIeSo4IHnbqvfi
        UNtJBtuJh8uKMiSkhQmvXrA=
X-Google-Smtp-Source: ABdhPJwP0zc4e3EnKYz6OndviVPG8NIAeh1Tmemt35ITvR7gj8KaKxs7FZF0RqsD/VedpkC323b1fw==
X-Received: by 2002:a17:902:e905:: with SMTP id k5mr9889863pld.342.1597652333981;
        Mon, 17 Aug 2020 01:18:53 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:18:53 -0700 (PDT)
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
Subject: [PATCH 07/35] dma: fsl: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:46:58 +0530
Message-Id: <20200817081726.20213-8-allen.lkml@gmail.com>
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
 drivers/dma/fsl_raid.c | 6 +++---
 drivers/dma/fsldma.c   | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index 493dc6c59d1d..26764bf2fc6d 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -154,9 +154,9 @@ static void fsl_re_cleanup_descs(struct fsl_re_chan *re_chan)
 	fsl_re_issue_pending(&re_chan->chan);
 }
 
-static void fsl_re_dequeue(unsigned long data)
+static void fsl_re_dequeue(struct tasklet_struct *t)
 {
-	struct fsl_re_chan *re_chan;
+	struct fsl_re_chan *re_chan from_tasklet(re_chan, t, irqtask);
 	struct fsl_re_desc *desc, *_desc;
 	struct fsl_re_hw_desc *hwdesc;
 	unsigned long flags;
@@ -671,7 +671,7 @@ static int fsl_re_chan_probe(struct platform_device *ofdev,
 	snprintf(chan->name, sizeof(chan->name), "re_jr%02d", q);
 
 	chandev = &chan_ofdev->dev;
-	tasklet_init(&chan->irqtask, fsl_re_dequeue, (unsigned long)chandev);
+	tasklet_setup(&chan->irqtask, fsl_re_dequeue);
 
 	ret = request_irq(chan->irq, fsl_re_isr, 0, chan->name, chandev);
 	if (ret) {
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index ad72b3f42ffa..3ce9cf3d62f5 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -976,9 +976,9 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void dma_do_tasklet(unsigned long data)
+static void dma_do_tasklet(struct tasklet_struct *t)
 {
-	struct fsldma_chan *chan = (struct fsldma_chan *)data;
+	struct fsldma_chan *chan = from_tasklet(chan, t, tasklet);
 
 	chan_dbg(chan, "tasklet entry\n");
 
@@ -1151,7 +1151,7 @@ static int fsl_dma_chan_probe(struct fsldma_device *fdev,
 	}
 
 	fdev->chan[chan->id] = chan;
-	tasklet_init(&chan->tasklet, dma_do_tasklet, (unsigned long)chan);
+	tasklet_setup(&chan->tasklet, dma_do_tasklet);
 	snprintf(chan->name, sizeof(chan->name), "chan%d", chan->id);
 
 	/* Initialize the channel */
-- 
2.17.1

