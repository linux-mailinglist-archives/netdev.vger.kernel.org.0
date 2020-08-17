Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E730245F70
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgHQIVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgHQIVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:21:35 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0CEC061388;
        Mon, 17 Aug 2020 01:21:35 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o5so7770733pgb.2;
        Mon, 17 Aug 2020 01:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QME4/rDj4IUPM5kJpeHXTQIgsJQOMifnZCInRk/A1C4=;
        b=RmM7bRuMfULJD/wWAddFVHPn4qOcLkmjxMn/rAcczyzgMa1wKBhw5p2SIoYN0WDrgF
         NLO0KMAW82As872kQ7UVo1mfQclmRJC1kdrKiR8FAtxpqgjn6MqeGpoy02ZVJKrW+mU3
         X7B7rFIM6NIoov9H3IL9Jkp2iXe9vdqn5gyAavfv8/tJX7qAmPnKetRMWrB/gw81S1Y4
         UcAGdAEyO+Uoq2v7u1oEzXyYj7Zjusf9b3P7acUR+0+jKW594BbO4bhGriaAVgEjxG6F
         EhtL7ITOfC8RpzfLLj/5Mqg3VtkzaaCXo3ramFImsX/kuOkoMpti5lf+oaTUXcKsVACU
         pijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QME4/rDj4IUPM5kJpeHXTQIgsJQOMifnZCInRk/A1C4=;
        b=uf9GntA7Lis2RNi+Ong6jBwzR4fR1deuxJNKJZAMHZ9+S2vXtOH1Or8p2KVuXHda9s
         Jya6BKYAZX5czunPEahpvS5+Y/wtjeY6hvC9xPJc1AngRmmujYJWyYpWEvv5FzI4wUPt
         D4QbS1r1sLIjSjxoNp0GhsFg3W+g33gY+QQ6t5qhZhokCeyFaBgBUg9riPC7g+8slPpZ
         pVbVIuOGDdqswHF0OymOro4butojsgOYn3TI9wbV3pXp00RJ7tZMrKWsXdusfZSZ/nFh
         RyrIMDdf7JC2Fi2woefQNCqs1GwCQkLUxH3iQ3s2aB56emKsgedlEUBYYKwa/2YQJ83d
         Esvw==
X-Gm-Message-State: AOAM532VtNw7+jKX88v+WTORQ6mH9UQyvlb6pMMvixiWnEjaStmMXCGT
        jXiR6j/0aO6yyCpqa/NFwg8=
X-Google-Smtp-Source: ABdhPJw1yMHZg4IX+ujfu1AKl4GGcYUn7OVJSQqidNZWKgU+pVKkUHwkDp/1muHPa+24Z7+wVKSoDg==
X-Received: by 2002:a63:dc11:: with SMTP id s17mr9103570pgg.254.1597652495077;
        Mon, 17 Aug 2020 01:21:35 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id d93sm16735334pjk.44.2020.08.17.01.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:21:34 -0700 (PDT)
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
Subject: [PATCH 23/35] dma: sa11x0: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:47:14 +0530
Message-Id: <20200817081726.20213-24-allen.lkml@gmail.com>
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
 drivers/dma/sa11x0-dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sa11x0-dma.c b/drivers/dma/sa11x0-dma.c
index 0fa7f14a65a1..1e918e284fc0 100644
--- a/drivers/dma/sa11x0-dma.c
+++ b/drivers/dma/sa11x0-dma.c
@@ -323,9 +323,9 @@ static void sa11x0_dma_start_txd(struct sa11x0_dma_chan *c)
 	}
 }
 
-static void sa11x0_dma_tasklet(unsigned long arg)
+static void sa11x0_dma_tasklet(struct tasklet_struct *t)
 {
-	struct sa11x0_dma_dev *d = (struct sa11x0_dma_dev *)arg;
+	struct sa11x0_dma_dev *d = from_tasklet(d, t, task);
 	struct sa11x0_dma_phy *p;
 	struct sa11x0_dma_chan *c;
 	unsigned pch, pch_alloc = 0;
@@ -928,7 +928,7 @@ static int sa11x0_dma_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	tasklet_init(&d->task, sa11x0_dma_tasklet, (unsigned long)d);
+	tasklet_setup(&d->task, sa11x0_dma_tasklet);
 
 	for (i = 0; i < NR_PHY_CHAN; i++) {
 		struct sa11x0_dma_phy *p = &d->phy[i];
-- 
2.17.1

