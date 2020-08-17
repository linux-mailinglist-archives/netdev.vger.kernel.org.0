Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8730A2462B7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgHQJSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHQJSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:18:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF60CC061389;
        Mon, 17 Aug 2020 02:18:39 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f9so7396020pju.4;
        Mon, 17 Aug 2020 02:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XewQeBy6WMQV1RzMvwbB0P7og4UUzSYm8rIudQOA7EQ=;
        b=SB1by7KaCL6cQHhv3XdgwPt9YA/PFNHKz0XfjEYA7w8aj9S9xxq0uzFLbo5O6jzB4d
         /BYHZnjCspLMklc6e+gKyyCLFL3PHl7af9K5z5BDc5pWk2fIAQV01uqg0x9A0rU3WJxB
         ynFJ+ZLHuAglHnrYfLWpNfsi8kvUoViShOQNB7TA1ZWciy7PmxwYny6mHPJlIoYZ82L2
         ZlBRzMm/o+SqonfkfIlyC7nCbwSclfnufsgMssi54+P+P7lc4ySD7vMC9Fk1Ls9A6dWc
         Okus7LMmEyRKUYFE86ulIu8GL6VYAG0MmqBllZv+Zn5LQaK/NiqDbEErMnl69t8YVmpD
         i99A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XewQeBy6WMQV1RzMvwbB0P7og4UUzSYm8rIudQOA7EQ=;
        b=PWYLOIie0DLvONoG6jGYhpZnDfsV+LEmGs9EACx2t8XFxxCezkqFsxqL+l4i2DK3gP
         zAYGQIb1fEMrZXHYk7wGJFIUcValEBfS/s8acdE9DLsoMPatoo08x8cDXiXt3BorLrQV
         R3YwEOZn2oNgr6AoAG9B/tZoFVTyeRPmXL78VldijNa5ty2hUDdkArEUkQRW3pcxLhJB
         xp49WQJwF1lj7unM475BRCbObwRxw5ZlbC5FwQV59lWup5RGRG/9uEjKAFyUt8Fi+huI
         3wKTtm8wn0wjsHdL5PPiHj7c13RNbobaSICHKseTwrYCOKetQS8g0oZwmqE8Ge1GcwRw
         X0dg==
X-Gm-Message-State: AOAM531qDAcnvETa/KY7CRSmtqs/AWzGy6AN/tDXySbV6Vrg0beaqDiH
        kXYCQ0XZZguRLb8krNlbR20=
X-Google-Smtp-Source: ABdhPJzpGkHvt1LevgAfoz+X8j8B4a1KTwgUtKHLjr8EQlBQBbyxfG8elY9nfvO7GsksTpqaKtjyFg==
X-Received: by 2002:a17:90a:36ee:: with SMTP id t101mr12384566pjb.47.1597655919356;
        Mon, 17 Aug 2020 02:18:39 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:18:38 -0700 (PDT)
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
Subject: [PATCH] drm: i915: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:04 +0530
Message-Id: <20200817091617.28119-10-allen.cryptic@gmail.com>
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
and from_tasklet() to pass the tasklet pointer explicitly
and remove the .data field.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/gpu/drm/i915/gt/intel_lrc.c           | 31 ++++++++++---------
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c |  8 +++--
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 24322ef08aa4..c45e42b9f239 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -3130,9 +3130,10 @@ static bool preempt_timeout(const struct intel_engine_cs *const engine)
  * Check the unread Context Status Buffers and manage the submission of new
  * contexts to the ELSP accordingly.
  */
-static void execlists_submission_tasklet(unsigned long data)
+static void execlists_submission_tasklet(struct tasklet_struct *t)
 {
-	struct intel_engine_cs * const engine = (struct intel_engine_cs *)data;
+	struct intel_engine_cs * const engine = from_tasklet(engine, t,
+						     execlists.tasklet);
 	bool timeout = preempt_timeout(engine);
 
 	process_csb(engine);
@@ -4306,9 +4307,10 @@ static void execlists_reset_rewind(struct intel_engine_cs *engine, bool stalled)
 	spin_unlock_irqrestore(&engine->active.lock, flags);
 }
 
-static void nop_submission_tasklet(unsigned long data)
+static void nop_submission_tasklet(struct tasklet_struct *t)
 {
-	struct intel_engine_cs * const engine = (struct intel_engine_cs *)data;
+	struct intel_engine_cs * const engine = from_tasklet(engine, t,
+						     execlists.tasklet);
 
 	/* The driver is wedged; don't process any more events. */
 	WRITE_ONCE(engine->execlists.queue_priority_hint, INT_MIN);
@@ -4391,7 +4393,8 @@ static void execlists_reset_cancel(struct intel_engine_cs *engine)
 	execlists->queue = RB_ROOT_CACHED;
 
 	GEM_BUG_ON(__tasklet_is_enabled(&execlists->tasklet));
-	execlists->tasklet.func = nop_submission_tasklet;
+	execlists->tasklet.func = (void (*)(unsigned long))
+				  nop_submission_tasklet;
 
 	spin_unlock_irqrestore(&engine->active.lock, flags);
 }
@@ -4986,7 +4989,8 @@ void intel_execlists_set_default_submission(struct intel_engine_cs *engine)
 {
 	engine->submit_request = execlists_submit_request;
 	engine->schedule = i915_schedule;
-	engine->execlists.tasklet.func = execlists_submission_tasklet;
+	engine->execlists.tasklet.func = (void (*)(unsigned long))
+		execlists_submission_tasklet;
 
 	engine->reset.prepare = execlists_reset_prepare;
 	engine->reset.rewind = execlists_reset_rewind;
@@ -5113,8 +5117,7 @@ int intel_execlists_submission_setup(struct intel_engine_cs *engine)
 	struct intel_uncore *uncore = engine->uncore;
 	u32 base = engine->mmio_base;
 
-	tasklet_init(&engine->execlists.tasklet,
-		     execlists_submission_tasklet, (unsigned long)engine);
+	tasklet_setup(&engine->execlists.tasklet, execlists_submission_tasklet);
 	timer_setup(&engine->execlists.timer, execlists_timeslice, 0);
 	timer_setup(&engine->execlists.preempt, execlists_preempt, 0);
 
@@ -5509,9 +5512,10 @@ static intel_engine_mask_t virtual_submission_mask(struct virtual_engine *ve)
 	return mask;
 }
 
-static void virtual_submission_tasklet(unsigned long data)
+static void virtual_submission_tasklet(struct tasklet_struct *t)
 {
-	struct virtual_engine * const ve = (struct virtual_engine *)data;
+	struct virtual_engine *  ve = from_tasklet(ve, t,
+						   base.execlists.tasklet);
 	const int prio = READ_ONCE(ve->base.execlists.queue_priority_hint);
 	intel_engine_mask_t mask;
 	unsigned int n;
@@ -5724,9 +5728,8 @@ intel_execlists_create_virtual(struct intel_engine_cs **siblings,
 
 	INIT_LIST_HEAD(virtual_queue(ve));
 	ve->base.execlists.queue_priority_hint = INT_MIN;
-	tasklet_init(&ve->base.execlists.tasklet,
-		     virtual_submission_tasklet,
-		     (unsigned long)ve);
+	tasklet_setup(&ve->base.execlists.tasklet,
+		     virtual_submission_tasklet);
 
 	intel_context_init(&ve->context, &ve->base);
 
@@ -5748,7 +5751,7 @@ intel_execlists_create_virtual(struct intel_engine_cs **siblings,
 		 * layering if we handle cloning of the requests and
 		 * submitting a copy into each backend.
 		 */
-		if (sibling->execlists.tasklet.func !=
+		if (sibling->execlists.tasklet.func != (void (*)(unsigned long))
 		    execlists_submission_tasklet) {
 			err = -ENODEV;
 			goto err_put;
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index fdfeb4b9b0f5..3013ff54431c 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -344,9 +344,10 @@ static void __guc_dequeue(struct intel_engine_cs *engine)
 	execlists->active = execlists->inflight;
 }
 
-static void guc_submission_tasklet(unsigned long data)
+static void guc_submission_tasklet(struct tasklet_struct *t)
 {
-	struct intel_engine_cs * const engine = (struct intel_engine_cs *)data;
+	struct intel_engine_cs * const engine = from_tasklet(engine, t,
+							     execlists.tasklet);
 	struct intel_engine_execlists * const execlists = &engine->execlists;
 	struct i915_request **port, *rq;
 	unsigned long flags;
@@ -591,7 +592,8 @@ static void guc_set_default_submission(struct intel_engine_cs *engine)
 	 */
 	intel_execlists_set_default_submission(engine);
 
-	engine->execlists.tasklet.func = guc_submission_tasklet;
+	engine->execlists.tasklet.func =
+				(void (*)(unsigned long))guc_submission_tasklet;
 
 	/* do not use execlists park/unpark */
 	engine->park = engine->unpark = NULL;
-- 
2.17.1

