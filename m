Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F666D1A35
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjCaIfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbjCaIfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:35:05 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BAD1CBA9
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:54 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m2so21588787wrh.6
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251694;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lbX5AvtH3XQkpXillVC2r4t4ZcO7K1MUGKa8995+UMc=;
        b=FXPQE0eL9eqATklkjZEYI6FjUYba0uQ/MQ+Nov2T3gJF3W+h3+1jgFcJnDVdHt17UU
         vhTpGd1CnckRRNR2FMMFJDdlPLcqhq7wVtKtupuheO3qJnU4yi/dnsPI4aZ+Jq7uyo9V
         g8W//zwz0inADvyoEIMT35Q/6Pbjj1CacqHmhVjcT9k8m14teR64Ytv9umBulZJyn4ye
         xoFBF0UW0z1k6fwE5uVdc5uPydJLwya3pHrzDxk4wv8JyWGSU8Y5rQ7Y00Eef2fwqvs7
         lsL6aOkIB4J2tq9HaaGj8W7m89y51dE1sYpZw6c91qmFImmY9Nhokl1z0Wg0jc3YIii2
         Azvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251694;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lbX5AvtH3XQkpXillVC2r4t4ZcO7K1MUGKa8995+UMc=;
        b=klWH/75BWizqE+N4RjJoVFmsZ56YjIoErH7AcJlNU/asDqL0uaoLhAfpBc8lyWVFBW
         t1POH+UBjm2xaNyEcbCFk7Jj1X4nAftIgh11NjexQBXcSidRzACi9YEOXXCsDqz6GLFu
         ZDdSpfkGAc4y9r4ljdhY6Y+oXwhQY2hO+RoGswCJLXW5HvbM8TMXde9WTd02kvdeUM7V
         haRYCpiC0dALtKy0lG4YAcObjmxWgNCgcRH8Gz8WALh78EgRursDip7G2KePcPppar/3
         IaLFFRfaCZPDCn0PEbbpWgdMVHlm59CJUVhPr8UhxhxR4zJjzM9JKjzO9bMMILGaa0Ys
         hoLw==
X-Gm-Message-State: AAQBX9dgFFIemJ2w6A2Z7AKUEEnF/S6UH9MyoIhIiXuqUsBnEqO4SvNA
        Qt2Ed40M6ZjRlXX44OUiGJy2RA==
X-Google-Smtp-Source: AKy350a6Wf8rj2xwut2Qu0Ukl1DJvimaFjv0cbtV5kR6Di/Cb/RS9MmoOkXKp4Sl7MChLqy4NJUeWA==
X-Received: by 2002:adf:fa11:0:b0:2c5:510b:8f9c with SMTP id m17-20020adffa11000000b002c5510b8f9cmr20833338wrr.52.1680251693811;
        Fri, 31 Mar 2023 01:34:53 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:53 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:45 +0200
Subject: [PATCH RFC 07/20] clksource: timer-oxnas-rps: remove obsolete
 timer driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-7-5bd58fd1dd1f@linaro.org>
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to lack of maintainance and stall of development for a few years now,
and since no new features will ever be added upstream, remove support
for OX810 and OX820 timer.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/clocksource/Kconfig           |   7 -
 drivers/clocksource/Makefile          |   1 -
 drivers/clocksource/timer-oxnas-rps.c | 288 ----------------------------------
 3 files changed, 296 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 5fc8f0e7fb38..cd494646ebf4 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -461,13 +461,6 @@ config VF_PIT_TIMER
 	help
 	  Support for Periodic Interrupt Timer on Freescale Vybrid Family SoCs.
 
-config OXNAS_RPS_TIMER
-	bool "Oxford Semiconductor OXNAS RPS Timers driver" if COMPILE_TEST
-	select TIMER_OF
-	select CLKSRC_MMIO
-	help
-	  This enables support for the Oxford Semiconductor OXNAS RPS timers.
-
 config SYS_SUPPORTS_SH_CMT
 	bool
 
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 64ab547de97b..a15608cb0ea3 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -53,7 +53,6 @@ obj-$(CONFIG_CLKSRC_QCOM)	+= timer-qcom.o
 obj-$(CONFIG_MTK_TIMER)		+= timer-mediatek.o
 obj-$(CONFIG_CLKSRC_PISTACHIO)	+= timer-pistachio.o
 obj-$(CONFIG_CLKSRC_TI_32K)	+= timer-ti-32k.o
-obj-$(CONFIG_OXNAS_RPS_TIMER)	+= timer-oxnas-rps.o
 obj-$(CONFIG_OWL_TIMER)		+= timer-owl.o
 obj-$(CONFIG_MILBEAUT_TIMER)	+= timer-milbeaut.o
 obj-$(CONFIG_SPRD_TIMER)	+= timer-sprd.o
diff --git a/drivers/clocksource/timer-oxnas-rps.c b/drivers/clocksource/timer-oxnas-rps.c
deleted file mode 100644
index d514b44e67dd..000000000000
--- a/drivers/clocksource/timer-oxnas-rps.c
+++ /dev/null
@@ -1,288 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * drivers/clocksource/timer-oxnas-rps.c
- *
- * Copyright (C) 2009 Oxford Semiconductor Ltd
- * Copyright (C) 2013 Ma Haijun <mahaijuns@gmail.com>
- * Copyright (C) 2016 Neil Armstrong <narmstrong@baylibre.com>
- */
-
-#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
-
-#include <linux/init.h>
-#include <linux/irq.h>
-#include <linux/io.h>
-#include <linux/clk.h>
-#include <linux/slab.h>
-#include <linux/interrupt.h>
-#include <linux/of_irq.h>
-#include <linux/of_address.h>
-#include <linux/clockchips.h>
-#include <linux/sched_clock.h>
-
-/* TIMER1 used as tick
- * TIMER2 used as clocksource
- */
-
-/* Registers definitions */
-
-#define TIMER_LOAD_REG		0x0
-#define TIMER_CURR_REG		0x4
-#define TIMER_CTRL_REG		0x8
-#define TIMER_CLRINT_REG	0xC
-
-#define TIMER_BITS		24
-
-#define TIMER_MAX_VAL		(BIT(TIMER_BITS) - 1)
-
-#define TIMER_PERIODIC		BIT(6)
-#define TIMER_ENABLE		BIT(7)
-
-#define TIMER_DIV1		(0)
-#define TIMER_DIV16		(1 << 2)
-#define TIMER_DIV256		(2 << 2)
-
-#define TIMER1_REG_OFFSET	0
-#define TIMER2_REG_OFFSET	0x20
-
-/* Clockevent & Clocksource data */
-
-struct oxnas_rps_timer {
-	struct clock_event_device clkevent;
-	void __iomem *clksrc_base;
-	void __iomem *clkevt_base;
-	unsigned long timer_period;
-	unsigned int timer_prescaler;
-	struct clk *clk;
-	int irq;
-};
-
-static irqreturn_t oxnas_rps_timer_irq(int irq, void *dev_id)
-{
-	struct oxnas_rps_timer *rps = dev_id;
-
-	writel_relaxed(0, rps->clkevt_base + TIMER_CLRINT_REG);
-
-	rps->clkevent.event_handler(&rps->clkevent);
-
-	return IRQ_HANDLED;
-}
-
-static void oxnas_rps_timer_config(struct oxnas_rps_timer *rps,
-				   unsigned long period,
-				   unsigned int periodic)
-{
-	uint32_t cfg = rps->timer_prescaler;
-
-	if (period)
-		cfg |= TIMER_ENABLE;
-
-	if (periodic)
-		cfg |= TIMER_PERIODIC;
-
-	writel_relaxed(period, rps->clkevt_base + TIMER_LOAD_REG);
-	writel_relaxed(cfg, rps->clkevt_base + TIMER_CTRL_REG);
-}
-
-static int oxnas_rps_timer_shutdown(struct clock_event_device *evt)
-{
-	struct oxnas_rps_timer *rps =
-		container_of(evt, struct oxnas_rps_timer, clkevent);
-
-	oxnas_rps_timer_config(rps, 0, 0);
-
-	return 0;
-}
-
-static int oxnas_rps_timer_set_periodic(struct clock_event_device *evt)
-{
-	struct oxnas_rps_timer *rps =
-		container_of(evt, struct oxnas_rps_timer, clkevent);
-
-	oxnas_rps_timer_config(rps, rps->timer_period, 1);
-
-	return 0;
-}
-
-static int oxnas_rps_timer_set_oneshot(struct clock_event_device *evt)
-{
-	struct oxnas_rps_timer *rps =
-		container_of(evt, struct oxnas_rps_timer, clkevent);
-
-	oxnas_rps_timer_config(rps, rps->timer_period, 0);
-
-	return 0;
-}
-
-static int oxnas_rps_timer_next_event(unsigned long delta,
-				struct clock_event_device *evt)
-{
-	struct oxnas_rps_timer *rps =
-		container_of(evt, struct oxnas_rps_timer, clkevent);
-
-	oxnas_rps_timer_config(rps, delta, 0);
-
-	return 0;
-}
-
-static int __init oxnas_rps_clockevent_init(struct oxnas_rps_timer *rps)
-{
-	ulong clk_rate = clk_get_rate(rps->clk);
-	ulong timer_rate;
-
-	/* Start with prescaler 1 */
-	rps->timer_prescaler = TIMER_DIV1;
-	rps->timer_period = DIV_ROUND_UP(clk_rate, HZ);
-	timer_rate = clk_rate;
-
-	if (rps->timer_period > TIMER_MAX_VAL) {
-		rps->timer_prescaler = TIMER_DIV16;
-		timer_rate = clk_rate / 16;
-		rps->timer_period = DIV_ROUND_UP(timer_rate, HZ);
-	}
-	if (rps->timer_period > TIMER_MAX_VAL) {
-		rps->timer_prescaler = TIMER_DIV256;
-		timer_rate = clk_rate / 256;
-		rps->timer_period = DIV_ROUND_UP(timer_rate, HZ);
-	}
-
-	rps->clkevent.name = "oxnas-rps";
-	rps->clkevent.features = CLOCK_EVT_FEAT_PERIODIC |
-				 CLOCK_EVT_FEAT_ONESHOT |
-				 CLOCK_EVT_FEAT_DYNIRQ;
-	rps->clkevent.tick_resume = oxnas_rps_timer_shutdown;
-	rps->clkevent.set_state_shutdown = oxnas_rps_timer_shutdown;
-	rps->clkevent.set_state_periodic = oxnas_rps_timer_set_periodic;
-	rps->clkevent.set_state_oneshot = oxnas_rps_timer_set_oneshot;
-	rps->clkevent.set_next_event = oxnas_rps_timer_next_event;
-	rps->clkevent.rating = 200;
-	rps->clkevent.cpumask = cpu_possible_mask;
-	rps->clkevent.irq = rps->irq;
-	clockevents_config_and_register(&rps->clkevent,
-					timer_rate,
-					1,
-					TIMER_MAX_VAL);
-
-	pr_info("Registered clock event rate %luHz prescaler %x period %lu\n",
-			clk_rate,
-			rps->timer_prescaler,
-			rps->timer_period);
-
-	return 0;
-}
-
-/* Clocksource */
-
-static void __iomem *timer_sched_base;
-
-static u64 notrace oxnas_rps_read_sched_clock(void)
-{
-	return ~readl_relaxed(timer_sched_base);
-}
-
-static int __init oxnas_rps_clocksource_init(struct oxnas_rps_timer *rps)
-{
-	ulong clk_rate = clk_get_rate(rps->clk);
-	int ret;
-
-	/* use prescale 16 */
-	clk_rate = clk_rate / 16;
-
-	writel_relaxed(TIMER_MAX_VAL, rps->clksrc_base + TIMER_LOAD_REG);
-	writel_relaxed(TIMER_PERIODIC | TIMER_ENABLE | TIMER_DIV16,
-			rps->clksrc_base + TIMER_CTRL_REG);
-
-	timer_sched_base = rps->clksrc_base + TIMER_CURR_REG;
-	sched_clock_register(oxnas_rps_read_sched_clock,
-			     TIMER_BITS, clk_rate);
-	ret = clocksource_mmio_init(timer_sched_base,
-				    "oxnas_rps_clocksource_timer",
-				    clk_rate, 250, TIMER_BITS,
-				    clocksource_mmio_readl_down);
-	if (WARN_ON(ret)) {
-		pr_err("can't register clocksource\n");
-		return ret;
-	}
-
-	pr_info("Registered clocksource rate %luHz\n", clk_rate);
-
-	return 0;
-}
-
-static int __init oxnas_rps_timer_init(struct device_node *np)
-{
-	struct oxnas_rps_timer *rps;
-	void __iomem *base;
-	int ret;
-
-	rps = kzalloc(sizeof(*rps), GFP_KERNEL);
-	if (!rps)
-		return -ENOMEM;
-
-	rps->clk = of_clk_get(np, 0);
-	if (IS_ERR(rps->clk)) {
-		ret = PTR_ERR(rps->clk);
-		goto err_alloc;
-	}
-
-	ret = clk_prepare_enable(rps->clk);
-	if (ret)
-		goto err_clk;
-
-	base = of_iomap(np, 0);
-	if (!base) {
-		ret = -ENXIO;
-		goto err_clk_prepare;
-	}
-
-	rps->irq = irq_of_parse_and_map(np, 0);
-	if (!rps->irq) {
-		ret = -EINVAL;
-		goto err_iomap;
-	}
-
-	rps->clkevt_base = base + TIMER1_REG_OFFSET;
-	rps->clksrc_base = base + TIMER2_REG_OFFSET;
-
-	/* Disable timers */
-	writel_relaxed(0, rps->clkevt_base + TIMER_CTRL_REG);
-	writel_relaxed(0, rps->clksrc_base + TIMER_CTRL_REG);
-	writel_relaxed(0, rps->clkevt_base + TIMER_LOAD_REG);
-	writel_relaxed(0, rps->clksrc_base + TIMER_LOAD_REG);
-	writel_relaxed(0, rps->clkevt_base + TIMER_CLRINT_REG);
-	writel_relaxed(0, rps->clksrc_base + TIMER_CLRINT_REG);
-
-	ret = request_irq(rps->irq, oxnas_rps_timer_irq,
-			  IRQF_TIMER | IRQF_IRQPOLL,
-			  "rps-timer", rps);
-	if (ret)
-		goto err_iomap;
-
-	ret = oxnas_rps_clocksource_init(rps);
-	if (ret)
-		goto err_irqreq;
-
-	ret = oxnas_rps_clockevent_init(rps);
-	if (ret)
-		goto err_irqreq;
-
-	return 0;
-
-err_irqreq:
-	free_irq(rps->irq, rps);
-err_iomap:
-	iounmap(base);
-err_clk_prepare:
-	clk_disable_unprepare(rps->clk);
-err_clk:
-	clk_put(rps->clk);
-err_alloc:
-	kfree(rps);
-
-	return ret;
-}
-
-TIMER_OF_DECLARE(ox810se_rps,
-		       "oxsemi,ox810se-rps-timer", oxnas_rps_timer_init);
-TIMER_OF_DECLARE(ox820_rps,
-		       "oxsemi,ox820-rps-timer", oxnas_rps_timer_init);

-- 
2.34.1

