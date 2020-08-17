Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1410246301
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgHQJUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgHQJUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:20:01 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C50C061389;
        Mon, 17 Aug 2020 02:20:00 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s15so7822152pgc.8;
        Mon, 17 Aug 2020 02:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lUWUV2v5oTJVUGMm6xf12JUfYyiWzcefGfdAtQk2jwM=;
        b=mbKVOHJMzNpskDzHydVD5JZdcRfrw+xd2+Uv78XbvKMc+387psZ2V2hk4qrHnsS81T
         /zH73TElq4axoclHQIy0bA2CbV9hfC8GYC+eakgtOktC3A5XsD2xiPjCrklKsR3XFyFd
         fsIOloQVGdK6RU/6EWDMjEAfDxSohJd//jLLtalmI0rGbeu1xwfLvpwSymywSxSBVX3G
         uhosJxEfiUcPuUNVJvS0yzIPELIzVumGhuE5Qx9Ojw3cmc6kmaA4ZQewhXRClGiu+tq2
         Aj/I10puZjlvAygrQvpRDOADkQfmJxn+4bXKvfXCvf9sZS7FhECvv/YiYSa/EN75dMVj
         0suw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lUWUV2v5oTJVUGMm6xf12JUfYyiWzcefGfdAtQk2jwM=;
        b=pWcZcdhbyPXpwJEOzA33YkNnX5Of1VlMktdhk/iV3sOi4roL0J5MTp4VNZFypx064g
         PRfozJaypGQFEj7s6IIuGNtHkBCHp8pHClaHMkLquHQFzlvF9ja+T78kwV835w6r6Fnh
         6iphQEYjTSAvVrnWQT/WnT+bXs+SpakvHuQsfkHp/p1cZKAT+92tyzfFaYuz20bD3HIr
         Jnmpf0zp8Qp4mbC44Di1BWfP+NMqSy0r3fIM7OanJDKeeYxWlrFGWTq2BnlBMD4wZDwR
         DLYO09RR4JOtKTbBJvGuwqFtyPAeDKwIJ2YYt9y6BuwwpznlK0WLtKXSUGB1IwBxdB6X
         cxYA==
X-Gm-Message-State: AOAM5337n7dn1xcWyZVysN2o6JHmvENam6JDrouKdfHIy3BLC54hBxhk
        7SGAiBvfoZfl7PL+0Lpzwok=
X-Google-Smtp-Source: ABdhPJxQcfdrrCrfZXVUBP2XgAqTEjdFaPRIHC7BcYbo0cXrAVQPSPy8pM2ZDmwAm4cu8q6kfjMCtw==
X-Received: by 2002:a62:7785:: with SMTP id s127mr10452297pfc.196.1597656000455;
        Mon, 17 Aug 2020 02:20:00 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:19:59 -0700 (PDT)
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
Subject: [PATCH 1/2] misc: ibmvmc: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:10 +0530
Message-Id: <20200817091617.28119-16-allen.cryptic@gmail.com>
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
 drivers/misc/ibmvmc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index 2d778d0f011e..347278c1a5e4 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -2064,10 +2064,10 @@ static void ibmvmc_handle_crq(struct ibmvmc_crq_msg *crq,
 	}
 }
 
-static void ibmvmc_task(unsigned long data)
+static void ibmvmc_task(struct tasklet_struct *t)
 {
-	struct crq_server_adapter *adapter =
-		(struct crq_server_adapter *)data;
+	struct crq_server_adapter *adapter = from_tasklet(adapter, t,
+							  work_task);
 	struct vio_dev *vdev = to_vio_dev(adapter->dev);
 	struct ibmvmc_crq_msg *crq;
 	int done = 0;
@@ -2150,7 +2150,7 @@ static int ibmvmc_init_crq_queue(struct crq_server_adapter *adapter)
 	queue->cur = 0;
 	spin_lock_init(&queue->lock);
 
-	tasklet_init(&adapter->work_task, ibmvmc_task, (unsigned long)adapter);
+	tasklet_setup(&adapter->work_task, ibmvmc_task);
 
 	if (request_irq(vdev->irq,
 			ibmvmc_handle_event,
-- 
2.17.1

