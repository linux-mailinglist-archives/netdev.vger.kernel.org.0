Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB7246254
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgHQJQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgHQJQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:16:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC9EC061389;
        Mon, 17 Aug 2020 02:16:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x25so7935160pff.4;
        Mon, 17 Aug 2020 02:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mHuwQk3c70LEeVRDgRBhzwGDJ7nUBqanmZ13DbCY85U=;
        b=Q0W/VwIVXHBj9YvXRE65zmYYW7OKSwPOhFA7L33Jnm2I/2WYc9/mTcQlvMPBfa5gSN
         2RqBUwnnXPqHfFkY/kdefbonLsqR7U5QnIT6xXUYsUHSEwB7JUQ6IrBQUdhBLTxOi/+G
         33dCqGC85wIzu4sVwhJXWst+XXWWfIhuU8OS9PUM4VbvTcwe9jbpbtJAG7iSDqxdcBMW
         jNrLB+vMhlGjl4glI2SnqDDpzzN+Zo4iUN3eXnADBqhYOpdGyO3gibX0u2a/Ix6ZYq6q
         3i+c4VwSQrSpK5GhTuNnF/NK1R/BwbjbUR0kjNWUX1g/BGGcsZFog29tDD6yJ+HItruh
         1xKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mHuwQk3c70LEeVRDgRBhzwGDJ7nUBqanmZ13DbCY85U=;
        b=p6o0sHIO0IdmS3OYmedBih5xiZxBWXSviHEzQlsBPV1x4KjdNqeOpz9VJ/M/vQoIEj
         4ByXEhmIsZx8hmElOO/xjihmqyMbjSBd2ggR3wbiHShZfN11HruPJfDVLAXYOwFAYbEo
         /tbV6cWCIJP8SOIbRwJHyGr8GxbjPU1+jA/VKzJZoVeKe6+wjkKACNVepjvq39B20WFl
         pkcJsxGGCWe40MoSqhOxsj7lTgcbN80/KuqZCjpdlOx3XDQZA6QvHNtNsyJ7NJXjO/JN
         M85LVXER3/3rKDYPUb8+uo55KkTcJi2sxoiWJVmt+ArLr+0nQXXo8e7jvQy24gEZMTMO
         XMDQ==
X-Gm-Message-State: AOAM530aBeA5MEXmFWCZPHRzgWjiIT6QHBuffmlkTDZ6SqfCKTdg3zeE
        Kd8dPgpCETFgBf4dsEvzYaA=
X-Google-Smtp-Source: ABdhPJwv96iWwUMvH8VXPkCg2sP5Tpy4AOwF/aDt/4dzgfyafzoO9ePqFKRKBzZcF9Jymu1V1GKZMg==
X-Received: by 2002:a63:5213:: with SMTP id g19mr8976321pgb.44.1597655813910;
        Mon, 17 Aug 2020 02:16:53 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:16:53 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        3chas3@gmail.com, axboe@kernel.dk, stefanr@s5r6.in-berlin.de,
        airlied@linux.ie, daniel@ffwll.ch, sre@kernel.org,
        James.Bottomley@HansenPartnership.com, kys@microsoft.com,
        deller@gmx.de, dmitry.torokhov@gmail.com, jassisinghbrar@gmail.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, davem@davemloft.net, kuba@kernel.org
Cc:     keescook@chromium.org, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH] block: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:45:56 +0530
Message-Id: <20200817091617.28119-2-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817091617.28119-1-allen.cryptic@gmail.com>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/block/umem.c    | 6 +++---
 drivers/block/xsysace.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 2b95d7b33b91..320781d5d156 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -405,7 +405,7 @@ static int add_bio(struct cardinfo *card)
 	return 1;
 }
 
-static void process_page(unsigned long data)
+static void process_page(struct tasklet_struct *t)
 {
 	/* check if any of the requests in the page are DMA_COMPLETE,
 	 * and deal with them appropriately.
@@ -415,7 +415,7 @@ static void process_page(unsigned long data)
 	 */
 	struct mm_page *page;
 	struct bio *return_bio = NULL;
-	struct cardinfo *card = (struct cardinfo *)data;
+	struct cardinfo *card = from_tasklet(card, t, tasklet);
 	unsigned int dma_status = card->dma_status;
 
 	spin_lock(&card->lock);
@@ -891,7 +891,7 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!card->queue)
 		goto failed_alloc;
 
-	tasklet_init(&card->tasklet, process_page, (unsigned long)card);
+	tasklet_setup(&card->tasklet, process_page);
 
 	card->check_batteries = 0;
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 5d8e0ab3f054..bdd50a87d10f 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -762,9 +762,9 @@ static void ace_fsm_dostate(struct ace_device *ace)
 	}
 }
 
-static void ace_fsm_tasklet(unsigned long data)
+static void ace_fsm_tasklet(struct tasklet_struct *t)
 {
-	struct ace_device *ace = (void *)data;
+	struct ace_device *ace = from_tasklet(ace, t, fsm_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ace->lock, flags);
@@ -1001,7 +1001,7 @@ static int ace_setup(struct ace_device *ace)
 	/*
 	 * Initialize the state machine tasklet and stall timer
 	 */
-	tasklet_init(&ace->fsm_tasklet, ace_fsm_tasklet, (unsigned long)ace);
+	tasklet_setup(&ace->fsm_tasklet, ace_fsm_tasklet);
 	timer_setup(&ace->stall_timer, ace_stall_timer, 0);
 
 	/*
-- 
2.17.1

