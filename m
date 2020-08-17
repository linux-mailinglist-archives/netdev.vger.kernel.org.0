Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04784246317
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgHQJUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgHQJU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:20:29 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C91C061389;
        Mon, 17 Aug 2020 02:20:29 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id x6so7813804pgx.12;
        Mon, 17 Aug 2020 02:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QhPrNAdoeJw7hjMh0pGw+sjN4I+tDKGZ699gTXbu9Pc=;
        b=cTZNXtt7wNfV+e9cJ76fTsPPVQZeYJIEY2TuWXhYA+6rL5+mQtvGCpP7nLFEEHniIY
         ttRYkgElaSdYzjheNY+aJq+wt2TbwHocg2rHezNcVM8LeXUN8gM2nT5FPn17bkKOZJ/R
         FpcUeStKvy2IzIoPd11K1+w6c4p381QKwm4Dhy02AfZUx3SzHjBImZSC4gDgffWV6h+v
         8YTTF/IpemIy0SQFRYOlz4ZDOq/9HJmYTUqHCVWY4C5ejhmLcUfPEpCe73ql4ONWBhLK
         UZXD9rMiGnEuf0tCOKH/CAPFPO+ziHa24otJgykW+Fa09Aud/a6J7DqgcJ9+cKbuVreV
         L6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QhPrNAdoeJw7hjMh0pGw+sjN4I+tDKGZ699gTXbu9Pc=;
        b=BdQ4t8woOOOlewDc3FItD8QaSe8WAH2WZ/ysm1DYnHvOeaZcA3+uZS01deuOCtm5qM
         9CmBeqGO6lGCm8/7TANqgYKChxYpFwr7ZdFdCjxsGVPFRce5FCLOW1p9ud8ONiHzUl4C
         7t5xrUWdWPGcKrrt+P3RG6xJGwp44sxvI66K6kEqoPZigcg2raeta14ZS38OIgy3F6P/
         J+iJgZ7nM2b3rTLgp/RNirCYOflpndZZkBHHwL7HZD6OE1Px1OX2Jsjk6hrC5/Yf0k7f
         AQE3GWZ5yl2AhQfO42qHb8xSibQHRpwsGTs3ne2dp8i5Z+vTu0s3kZtnsmWIm8oxQ+h5
         hPLw==
X-Gm-Message-State: AOAM531agWFu0iPCQJ5AN76ECwqqZwx95+kBleCwticXVnspVn8DYdEp
        FQBL7DwrCUQDwNimzKbLJwg=
X-Google-Smtp-Source: ABdhPJzDyD/NrPXHKKUPdhhRODzrKgFhi3OcVBh0EqkEsk2AwP8x+cz/Kr8PlDriSCVb6p68quAdVw==
X-Received: by 2002:a63:4545:: with SMTP id u5mr9191366pgk.229.1597656028627;
        Mon, 17 Aug 2020 02:20:28 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:20:28 -0700 (PDT)
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
Subject: [PATCH] platform: goldfish: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:12 +0530
Message-Id: <20200817091617.28119-18-allen.cryptic@gmail.com>
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
 drivers/platform/goldfish/goldfish_pipe.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index 1ab207ec9c94..b9bead07760c 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -577,10 +577,10 @@ static struct goldfish_pipe *signalled_pipes_pop_front(
 	return pipe;
 }
 
-static void goldfish_interrupt_task(unsigned long dev_addr)
+static void goldfish_interrupt_task(struct tasklet_struct *t)
 {
 	/* Iterate over the signalled pipes and wake them one by one */
-	struct goldfish_pipe_dev *dev = (struct goldfish_pipe_dev *)dev_addr;
+	struct goldfish_pipe_dev *dev = from_tasklet(dev, t, irq_tasklet);
 	struct goldfish_pipe *pipe;
 	int wakes;
 
@@ -811,8 +811,7 @@ static int goldfish_pipe_device_init(struct platform_device *pdev,
 {
 	int err;
 
-	tasklet_init(&dev->irq_tasklet, &goldfish_interrupt_task,
-		     (unsigned long)dev);
+	tasklet_setup(&dev->irq_tasklet, &goldfish_interrupt_task);
 
 	err = devm_request_irq(&pdev->dev, dev->irq,
 			       goldfish_pipe_interrupt,
-- 
2.17.1

