Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B7D245F60
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgHQIUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgHQIUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:20:48 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674E0C061388;
        Mon, 17 Aug 2020 01:20:48 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so7752756pgi.9;
        Mon, 17 Aug 2020 01:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dqznZ0QFtNhvUqAjtholQ/Q+9qOGKPjtIbAySrocxDs=;
        b=KRBYv0V7RGxjCNY2koURdTLqlf5T4Z5jbej72if9UXEFoL/RlV6R2AvNxEL7dsnkWj
         0Ocb0N5z5mpfGDeBczn80DTSBEiOrPHHULXZM2bbF2PT18waNq8KIv/teDOjtojWbR/o
         +utDsvnj0AiO/C0hDKdBK5L3ZEIFNo1ncyj3M37kjc5nrD+4woYiqlvpl7WkU63sNC3s
         /z4oHsk2a5X6cL0vJjbAo8Q0jygbeBZTUK1omsbE3UDj2SLH/dnrgSMmm41FmZ4H/Jqb
         uQF+QmUGHr2ATgAq4IklyAkVPA8988eGdhnOuKCkWnKzJ1jh6EvOFScbKkNP2V/Z+eeY
         +WTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dqznZ0QFtNhvUqAjtholQ/Q+9qOGKPjtIbAySrocxDs=;
        b=pFRM6Vobl4+Fpa64A0bxQVkWROaDZoxKVZklYtH91vH3xNrfMw148NkxDhLkUAyUih
         eIbkReb2TTzUgsW3lGcQZY71B+LzOw0X/fs8GpcFYqL2cqFznb163vzz84HLxsbLrnHL
         u4ngSCRE4qubperbVS+aI4S36STFR7Iz1KtixPinwD3byTy7ukZyUKecRTJrKb85pClB
         5ffacbn/KEhIANLK1+q1xJN5ct3rU9Q56V931j6PMFAK4LbzlxpyN0hWzLjydqKlOuBc
         SGoUir523JrAv1dWOvvcLb3Eh9Kl3gHusjP67ZlQwfipj/vuQfqTTrNpIVEbVHNBbb4p
         yaYQ==
X-Gm-Message-State: AOAM532UwnEBcatZBfnMAyE2m2o1Ak6p6ij3fkQHycrzq0TlPZ72bTWh
        MpACbLBPdxZSw4lZTvhwRrQ=
X-Google-Smtp-Source: ABdhPJzX+N/OkXU+vrrmrFmCMg/4yjHapdnCrzQXpTIDVt6HxLMh86+qWux6PojScRvt2WSRNYNUQw==
X-Received: by 2002:a62:1543:: with SMTP id 64mr10645592pfv.242.1597652447996;
        Mon, 17 Aug 2020 01:20:47 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:20:47 -0700 (PDT)
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
Subject: [PATCH 18/35] dma: nbpfaxi: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:09 +0530
Message-Id: <20200817081726.20213-19-allen.lkml@gmail.com>
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
 drivers/dma/nbpfaxi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index 74df621402e1..4ef0838840f3 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -1113,9 +1113,9 @@ static struct dma_chan *nbpf_of_xlate(struct of_phandle_args *dma_spec,
 	return dchan;
 }
 
-static void nbpf_chan_tasklet(unsigned long data)
+static void nbpf_chan_tasklet(struct tasklet_struct *t)
 {
-	struct nbpf_channel *chan = (struct nbpf_channel *)data;
+	struct nbpf_channel *chan = from_tasklet(chan, t, tasklet);
 	struct nbpf_desc *desc, *tmp;
 	struct dmaengine_desc_callback cb;
 
@@ -1260,7 +1260,7 @@ static int nbpf_chan_probe(struct nbpf_device *nbpf, int n)
 
 	snprintf(chan->name, sizeof(chan->name), "nbpf %d", n);
 
-	tasklet_init(&chan->tasklet, nbpf_chan_tasklet, (unsigned long)chan);
+	tasklet_setup(&chan->tasklet, nbpf_chan_tasklet);
 	ret = devm_request_irq(dma_dev->dev, chan->irq,
 			nbpf_chan_irq, IRQF_SHARED,
 			chan->name, chan);
-- 
2.17.1

