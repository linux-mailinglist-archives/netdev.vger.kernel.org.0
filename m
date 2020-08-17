Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCC82462C7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgHQJS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbgHQJSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:18:51 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4468AC061389;
        Mon, 17 Aug 2020 02:18:51 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mw10so7404711pjb.2;
        Mon, 17 Aug 2020 02:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y/Lyd9iyb+e3Iwz9Po/fyIeEqiW8mHah9rIvstjO+PU=;
        b=DXgG1thdfskvtuXZP8/vM2gAxPo04jWU1e+8F2TitfrFT6HmCFefFj4nhScJQTVk1q
         gwLxkldM/Z+lONZzeR6zuZqiQyflB90NTYeiTaY2uBfmMOfTAXYT7jbI0r056THCHfBd
         3Di3net4lwJTB43A0rF2kp+rBzJcJY7T89VTsfvGCemy2qENpzVMLpR5W4yUkLrg5+z4
         9JO+T6FYEZY6ZUFsXdmos0B6tU4Q5kqzOQ+gRjZVd4YWOoPWnjX11Km6g+E3oY819bdf
         yrJ9k2JC0MEmc+k1DjYwwIX9qR0IT6cjxsIz2qZVtoxc4ZLZ/IK7rkcfNaetwR8RSOCf
         y05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y/Lyd9iyb+e3Iwz9Po/fyIeEqiW8mHah9rIvstjO+PU=;
        b=mHIz9d2uKi6aZZ82Rd7d5vtBF4rgSWN5Lkx+Lq4cq1JO7vz64p/Kx6wmSIhVnmsvW8
         ydmNNoWsTAvXohx6LhJYjueVOer9sNuK3cBGtSa9lc2KWoSjCv9OWD1ntzEvxfrcQxmN
         r8qhjMXtVJZZCt73qcglnl3EN7jOk+zhdyq86XWkDMU9YV72i61DZn3vicAIGsVd2rg9
         mRiDUOUp/kMyw9mcZIUBet0xlGdF009sCqgDlvuwSooAlAe3GnsCF4jd4h9ZMDIln99w
         wkwxQBt+KJJKgCYWcSr/FjudBVW/RsYQtwLUtKeKe8UoeMyEPFCtQ7zh2x51AIi2gz0E
         nEJg==
X-Gm-Message-State: AOAM531VXFzaTvpRSwC0D4T+Wz8UCqEHBNaURwzNzqOL5BbgFcHRTxxj
        7pfx0OwEiWBLynEcts2bdz0=
X-Google-Smtp-Source: ABdhPJyIur6thpXJWevzBAIQBHYV2xsdEEXHh/+HT4l4m1kZQXfbzh30rMtWwCA6A2KqL1fU9TH91w==
X-Received: by 2002:a17:90a:2525:: with SMTP id j34mr12831046pje.208.1597655930802;
        Mon, 17 Aug 2020 02:18:50 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:18:50 -0700 (PDT)
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
Subject: [PATCH] firewire: ohci: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:05 +0530
Message-Id: <20200817091617.28119-11-allen.cryptic@gmail.com>
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
 drivers/firewire/ohci.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 7dde21b18b04..6298ff03796e 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -921,9 +921,9 @@ static void ar_recycle_buffers(struct ar_context *ctx, unsigned int end_buffer)
 	}
 }
 
-static void ar_context_tasklet(unsigned long data)
+static void ar_context_tasklet(struct tasklet_struct *t)
 {
-	struct ar_context *ctx = (struct ar_context *)data;
+	struct ar_context *ctx = from_tasklet(ctx, t, tasklet);
 	unsigned int end_buffer_index, end_buffer_offset;
 	void *p, *end;
 
@@ -977,7 +977,7 @@ static int ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci,
 
 	ctx->regs        = regs;
 	ctx->ohci        = ohci;
-	tasklet_init(&ctx->tasklet, ar_context_tasklet, (unsigned long)ctx);
+	tasklet_setup(&ctx->tasklet, ar_context_tasklet);
 
 	for (i = 0; i < AR_BUFFERS; i++) {
 		ctx->pages[i] = alloc_page(GFP_KERNEL | GFP_DMA32);
@@ -1049,9 +1049,9 @@ static struct descriptor *find_branch_descriptor(struct descriptor *d, int z)
 		return d + z - 1;
 }
 
-static void context_tasklet(unsigned long data)
+static void context_tasklet(struct tasklet_struct *t)
 {
-	struct context *ctx = (struct context *) data;
+	struct context *ctx = from_tasklet(ctx, t, tasklet);
 	struct descriptor *d, *last;
 	u32 address;
 	int z;
@@ -1145,7 +1145,7 @@ static int context_init(struct context *ctx, struct fw_ohci *ohci,
 	ctx->buffer_tail = list_entry(ctx->buffer_list.next,
 			struct descriptor_buffer, list);
 
-	tasklet_init(&ctx->tasklet, context_tasklet, (unsigned long)ctx);
+	tasklet_setup(&ctx->tasklet, context_tasklet);
 	ctx->callback = callback;
 
 	/*
@@ -1420,7 +1420,7 @@ static void at_context_flush(struct context *ctx)
 	tasklet_disable(&ctx->tasklet);
 
 	ctx->flushing = true;
-	context_tasklet((unsigned long)ctx);
+	context_tasklet(&ctx->tasklet);
 	ctx->flushing = false;
 
 	tasklet_enable(&ctx->tasklet);
@@ -3472,7 +3472,7 @@ static int ohci_flush_iso_completions(struct fw_iso_context *base)
 	tasklet_disable(&ctx->context.tasklet);
 
 	if (!test_and_set_bit_lock(0, &ctx->flushing_completions)) {
-		context_tasklet((unsigned long)&ctx->context);
+		context_tasklet(&ctx->context.tasklet);
 
 		switch (base->type) {
 		case FW_ISO_CONTEXT_TRANSMIT:
-- 
2.17.1

