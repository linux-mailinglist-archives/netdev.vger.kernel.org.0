Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6D22462DE
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgHQJTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgHQJTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:19:17 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F369CC061389;
        Mon, 17 Aug 2020 02:19:16 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d19so7813710pgl.10;
        Mon, 17 Aug 2020 02:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BhmC2dfR9Z2FpcZrdiI/rF+di1B3O2m2kCZjxi0Nzus=;
        b=pH1u/a65jck4CF/HaoBjMB2yQ7DQRuOjq2EQe/YOxb/OD7LRTsfaGPckhcN+7n9R1u
         8haLtPH3/hoBwBJOPjlUu2iYNKNPElK2iQu8xAhfWEfShI0bje7FwzTh8mTzsrV2FN/G
         T9q7gfYpRkJs922O9WCJDcFzNiLghUNavbp+zlHscWAG2oqdLCD4z56Z3vUZOyp4D6dk
         KhQqBlfrQV46/Pb2iMfJWkdHHcpVNp7jqYJJ9NEWjQKozVbz9oxhRN55xVrJNhB3JaO3
         Dp4F6ts/oPz/ziaWkRipTHlRzYfTQoj0G/RUnkwPSw1bnvtUKBj+EftqSWTMiaLoQ1jv
         lH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BhmC2dfR9Z2FpcZrdiI/rF+di1B3O2m2kCZjxi0Nzus=;
        b=jiBhcFNy0GB6EkcHBF3C4LRovgc7QduoSaoXf0YS0zNMyDJlR8cZt9JM3HeSWRgPkY
         Zvavvm6e6RyUXHFdQlD5UpTyliaBx8oQIpdu62d+HC3uocf11IU7WUI6f9LDhk3Xe0Hm
         mjBqKSjK3TFckTau2A5EaMwtgmwCoayIxf/hsdONPcoACGv7J5DiuxM9S1SZEi9G3aHL
         TAYIscR4nMJYFqOpzzd2u6kuuOMPz5uUEQlZSVx4vOUYRGsrK6DDLpObPyeWdjIqpRU0
         go3EThYYAMmYMZ/2lKKWHAzmtxvAuJ/EtAznXmDkE/0JbKl0WU10Z7JTHGvE7TQraLvy
         hjhA==
X-Gm-Message-State: AOAM530z3xIe2uU4JEBkJhtfYDw4RNBkc36tKDdcHD1OBwi07bCS5rXW
        CYQLJpPxhsHcTu3LxSMeQow=
X-Google-Smtp-Source: ABdhPJyB5tc5dUu27VbUdOZ9DzBdNo9HMZYO5yS/FgK5KFnwUfpfaMSoblaoVOfdDSu8KmjNrpWWGw==
X-Received: by 2002:a63:2e87:: with SMTP id u129mr9420810pgu.347.1597655956522;
        Mon, 17 Aug 2020 02:19:16 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:19:15 -0700 (PDT)
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
Subject: [PATCH] input: serio: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:07 +0530
Message-Id: <20200817091617.28119-13-allen.cryptic@gmail.com>
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
 drivers/input/serio/hp_sdc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 13eacf6ab431..91f8253ac66a 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -301,7 +301,7 @@ static irqreturn_t hp_sdc_nmisr(int irq, void *dev_id)
 
 unsigned long hp_sdc_put(void);
 
-static void hp_sdc_tasklet(unsigned long foo)
+static void hp_sdc_tasklet(struct tasklet_struct *unused)
 {
 	write_lock_irq(&hp_sdc.rtq_lock);
 
@@ -890,7 +890,7 @@ static int __init hp_sdc_init(void)
 	hp_sdc_status_in8();
 	hp_sdc_data_in8();
 
-	tasklet_init(&hp_sdc.task, hp_sdc_tasklet, 0);
+	tasklet_setup(&hp_sdc.task, hp_sdc_tasklet, 0);
 
 	/* Sync the output buffer registers, thus scheduling hp_sdc_tasklet. */
 	t_sync.actidx	= 0;
-- 
2.17.1

