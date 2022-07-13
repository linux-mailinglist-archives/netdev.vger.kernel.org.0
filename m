Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBF5573DE6
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbiGMUlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237117AbiGMUlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:41:12 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AED131223;
        Wed, 13 Jul 2022 13:41:10 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w185so18473pfb.4;
        Wed, 13 Jul 2022 13:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v1DRyPsBFuh6aftETcwer1yzmkqbB6fixXL4Ircd/Lc=;
        b=aVxai1dokJtxwXIP4M+Y3N2uoNHX5DBWKCxHOJcBiCTZ7W5YxUtk6vTyJ2oKHChLDM
         /jwl5jFCvb4O1K0H37RGwyI/Lq24jmrS5DWGUZPZsLG00Bkx1arOkEKrQvChzjPv7xAB
         zlju+oDLpNln5AKTxJRahDGvnLARAyPmLnceh4qWucyT82Rtstj3biKkZhjhy4sJaniV
         I1dQleww4FG/B5eooLtQWmDiElSGGABMhcEjqwBsyiHRQ9yx+v11puhmJBVILbZ4COFI
         /oBKd5Lmo8ppa7eVWYR+ejOcnwGpMgKfuFfQK311YXhHnv7i+m5Pzd9nq7Ndd7bJo4G6
         arAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v1DRyPsBFuh6aftETcwer1yzmkqbB6fixXL4Ircd/Lc=;
        b=hzN6J7jMRToGQ0kEcS3AJ4SrzhTlr1OFu9wBvkiOJaAXb2lsJdsn0L4o2Btt93qSob
         fo3b2/5KkMaqqUYZoMaf2T9AUy2i+5DzN/AAQvRzCtgKW4j7lUnX7TFV0y0HW6uxlawb
         d7Vo9Gu3kFjsL+Xek9hYhfrcyj056P2X2qEOpF+dHjdE4HgzmfxQcJHuAAvr3rQwHmMZ
         iEs0L36UxeRyCuToLlqFFAqR0MEaALwHBSgsOjbg62ZdT8J7MtrNxI0bVrnv3i86gE1O
         KNKYEyULqxJ2A20u3YxMd//UDk/u++5mvj2dYxNO4XfZN9DHrC2AdV2o755/ljqgdeD0
         S96Q==
X-Gm-Message-State: AJIora9Nu94FY+UmwY4yycryJzvF2f1J2aJ6u6gb5OifTm27TJAHLwQD
        dfC4pAnISMw6sokwEr2C2JtUC20YUw==
X-Google-Smtp-Source: AGRyM1uQmusJsYXogPbDN8YI6ptYmN0gTrlR3DZFnf7x0Xebi7KCvIPMpeRHm2pOkJWSDRCdlX64Vg==
X-Received: by 2002:a65:5207:0:b0:3fb:c00f:f6e4 with SMTP id o7-20020a655207000000b003fbc00ff6e4mr4427783pgp.415.1657744869763;
        Wed, 13 Jul 2022 13:41:09 -0700 (PDT)
Received: from bytedance.bytedance.net ([4.7.18.210])
        by smtp.gmail.com with ESMTPSA id c204-20020a624ed5000000b00528c4c770c5sm9217825pfb.77.2022.07.13.13.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 13:41:09 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next] net/sched: sch_cbq: Delete unused delay_timer
Date:   Wed, 13 Jul 2022 13:40:51 -0700
Message-Id: <20220713204051.32551-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

delay_timer has been unused since commit c3498d34dd36 ("cbq: remove
TCA_CBQ_OVL_STRATEGY support").  Delete it.

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_cbq.c | 79 ---------------------------------------------
 1 file changed, 79 deletions(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 02d9f0dfe356..599e26fc2fa8 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -149,7 +149,6 @@ struct cbq_sched_data {
 	psched_time_t		now;		/* Cached timestamp */
 	unsigned int		pmask;
 
-	struct hrtimer		delay_timer;
 	struct qdisc_watchdog	watchdog;	/* Watchdog timer,
 						   started when CBQ has
 						   backlog, but cannot
@@ -441,81 +440,6 @@ static void cbq_overlimit(struct cbq_class *cl)
 	}
 }
 
-static psched_tdiff_t cbq_undelay_prio(struct cbq_sched_data *q, int prio,
-				       psched_time_t now)
-{
-	struct cbq_class *cl;
-	struct cbq_class *cl_prev = q->active[prio];
-	psched_time_t sched = now;
-
-	if (cl_prev == NULL)
-		return 0;
-
-	do {
-		cl = cl_prev->next_alive;
-		if (now - cl->penalized > 0) {
-			cl_prev->next_alive = cl->next_alive;
-			cl->next_alive = NULL;
-			cl->cpriority = cl->priority;
-			cl->delayed = 0;
-			cbq_activate_class(cl);
-
-			if (cl == q->active[prio]) {
-				q->active[prio] = cl_prev;
-				if (cl == q->active[prio]) {
-					q->active[prio] = NULL;
-					return 0;
-				}
-			}
-
-			cl = cl_prev->next_alive;
-		} else if (sched - cl->penalized > 0)
-			sched = cl->penalized;
-	} while ((cl_prev = cl) != q->active[prio]);
-
-	return sched - now;
-}
-
-static enum hrtimer_restart cbq_undelay(struct hrtimer *timer)
-{
-	struct cbq_sched_data *q = container_of(timer, struct cbq_sched_data,
-						delay_timer);
-	struct Qdisc *sch = q->watchdog.qdisc;
-	psched_time_t now;
-	psched_tdiff_t delay = 0;
-	unsigned int pmask;
-
-	now = psched_get_time();
-
-	pmask = q->pmask;
-	q->pmask = 0;
-
-	while (pmask) {
-		int prio = ffz(~pmask);
-		psched_tdiff_t tmp;
-
-		pmask &= ~(1<<prio);
-
-		tmp = cbq_undelay_prio(q, prio, now);
-		if (tmp > 0) {
-			q->pmask |= 1<<prio;
-			if (tmp < delay || delay == 0)
-				delay = tmp;
-		}
-	}
-
-	if (delay) {
-		ktime_t time;
-
-		time = 0;
-		time = ktime_add_ns(time, PSCHED_TICKS2NS(now + delay));
-		hrtimer_start(&q->delay_timer, time, HRTIMER_MODE_ABS_PINNED);
-	}
-
-	__netif_schedule(qdisc_root(sch));
-	return HRTIMER_NORESTART;
-}
-
 /*
  * It is mission critical procedure.
  *
@@ -1034,7 +958,6 @@ cbq_reset(struct Qdisc *sch)
 	q->tx_class = NULL;
 	q->tx_borrowed = NULL;
 	qdisc_watchdog_cancel(&q->watchdog);
-	hrtimer_cancel(&q->delay_timer);
 	q->toplevel = TC_CBQ_MAXLEVEL;
 	q->now = psched_get_time();
 
@@ -1162,8 +1085,6 @@ static int cbq_init(struct Qdisc *sch, struct nlattr *opt,
 	int err;
 
 	qdisc_watchdog_init(&q->watchdog, sch);
-	hrtimer_init(&q->delay_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
-	q->delay_timer.function = cbq_undelay;
 
 	err = cbq_opt_parse(tb, opt, extack);
 	if (err < 0)
-- 
2.20.1

