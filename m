Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22498245F75
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgHQIV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgHQIVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:21:54 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F51C061388;
        Mon, 17 Aug 2020 01:21:54 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t11so7138868plr.5;
        Mon, 17 Aug 2020 01:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=otxsu5o9cde9DrIHOXDNXEgKF0A0Yvtv94mFiTmu/m4=;
        b=hkUsh+NVWHTVxA9gVlu9/qoblBacsCvQCYPap4IIXPebOmgy1buaRFS5MjMwwL/9LG
         F2rokfNtHBS5mqJCekyQMEs1BVsuUJwOIfDxfDCIfulCY8CZCoXgXczW9lGtc6jUXP+R
         D2UG1eEspP7d5pShkpimqH/tBBY3W9aIvMSnW4MjDvi6eLFCsrvqMoV+dhfOaDQkHJhE
         Vj+3g6Vdc2GEIxYxscvN1e1o5r0pmFiwJ+THCH/i26eXAHF3Ucxrbkiu3cVtTT3ebk6t
         c1h7/n1jQVhAaNeUh9L9QrMkqmCl9HbtTVCztHLnjSY3ViP1SjVBblY0soJKQzlajbPa
         qFMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=otxsu5o9cde9DrIHOXDNXEgKF0A0Yvtv94mFiTmu/m4=;
        b=ItN139fi+tTTNbbraYxa+d/7e1wyf9YHgr2DUafDq8MfAozxWhY3X/7DzYYsNoHuS3
         4BH+EPXzqlOBwJOl3EthrT5RfN3Egm/jgDbq/V3P4CYZLExhWcca7C6umqsXcFFuliDj
         kIlciztLkvlMt4l+P96xswD4y+ntD/28O8EJYc8q2Mi4CH0M0e7TaSZfIhOQhZ3JFE5w
         9ubdsUv5++aiUy5soy4qfGdHd9g2AX2enZa49j7Tvu6JvLlVLAlB85wnOJlicpVWM+oM
         bS2choobuEsYE/h1SI305lLHr48Gmy1XrbNxhudfbxyVTiRHVkQJpV1VfPphfvLcQgBT
         S3WQ==
X-Gm-Message-State: AOAM531/JDGsnUdptLJOP/PzijQ9DW7BIUp28g4z4MYvT9qwKqeQOazT
        5Wo3CbwOig7ySt0Z6grzb78=
X-Google-Smtp-Source: ABdhPJyxOKpoYw00kMjNh6B9fXmf3K4stoPq/ZFbhf1/t2EFSqwkjXm/sGSRck8OeciH8rQQHJSVfQ==
X-Received: by 2002:a17:90b:8c5:: with SMTP id ds5mr11636521pjb.110.1597652513772;
        Mon, 17 Aug 2020 01:21:53 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:21:53 -0700 (PDT)
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
Subject: [PATCH 25/35] dma: ste_dma40: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:16 +0530
Message-Id: <20200817081726.20213-26-allen.lkml@gmail.com>
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
 drivers/dma/ste_dma40.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 21e2f1d0c210..ec4611ae7230 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1573,9 +1573,9 @@ static void dma_tc_handle(struct d40_chan *d40c)
 
 }
 
-static void dma_tasklet(unsigned long data)
+static void dma_tasklet(struct tasklet_struct *t)
 {
-	struct d40_chan *d40c = (struct d40_chan *) data;
+	struct d40_chan *d40c = from_tasklet(d40c, t, tasklet);
 	struct d40_desc *d40d;
 	unsigned long flags;
 	bool callback_active;
@@ -2806,8 +2806,7 @@ static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
 		INIT_LIST_HEAD(&d40c->client);
 		INIT_LIST_HEAD(&d40c->prepare_queue);
 
-		tasklet_init(&d40c->tasklet, dma_tasklet,
-			     (unsigned long) d40c);
+		tasklet_setup(&d40c->tasklet, dma_tasklet);
 
 		list_add_tail(&d40c->chan.device_node,
 			      &dma->channels);
-- 
2.17.1

