Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7E3504E33
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 11:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiDRJKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 05:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236256AbiDRJKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 05:10:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E365120AB
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 02:07:43 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t12so11872471pll.7
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 02:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NA8/aEyGhIzDnEgdP0XRa8mkKOOqf+rsQNxuJwTlPuM=;
        b=Q038OYeOHLRhfJe0c8CO2Iok6GmH4uksWCcGgLcZWbSKFJpuxgKbBsiI03W7fcwFKr
         FYwfH8COlOJFNR5IgK2h+0p9zO5wIJRceyn03aA/eCkCZhumeZd/8Ayu1JSyeuFokn9f
         yCSw3B6+SxEXqjiuo7YMv/2Oru8ihsE3r+B6WMHrrvLpoNYkh+esKpskmNtPEv2H85n6
         h6cKmbLKMqOO2NvXEIEHm1nEY2BabUcj5onjNp3ngp2Mr9vlZIyhcv3DtewGD4MUiFfK
         Qj8GfSkwnZeQrwW6NpyqP1iYcSXbCc23M4eD1tLmV/mdnm0biIhODQaGpoevsgmD5ZWS
         OaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NA8/aEyGhIzDnEgdP0XRa8mkKOOqf+rsQNxuJwTlPuM=;
        b=z8OUkHEusMcNpLwYeYyBHmE8q87dTv0/aXM7yZLGiIir+B8khtnOFjTN3XSA+hd2jb
         VK1W4kB3BbhziLh3AvTLEv88g9k8pxukVEykyxJz4yIxsYl0tsryRDIK4NoDPsMUpi7/
         5mWPUcWTOcbEBAayyrTMnpkCQtloA2u0f1d9j8O4MXoELFphK/DZ23sCx9TvBuoUowXv
         Fp0pXCbWYo6XwYAp+Itvu+W25liiw4/DQSJMmYYREo6LN/rHjNuaocYjkoeb0WbU2Fym
         PZuIFXxTf+h8mVZy8AZKH9K046zxo8gPVi21d5Hek6f8C69Qc72eoL6zZqo++I+ZEOSv
         XVLQ==
X-Gm-Message-State: AOAM532hdjLbEL7UZOgNnRexoHo5uyvbxaa93OcZL3SgPsA9vqCtYivk
        +osT+zmKTuv1cK6KSelkLQo341rSC5U=
X-Google-Smtp-Source: ABdhPJzFcerp2f3zryTVgKmHWUl4AUDFkrSc60fSUf3vBiN874GtjTZ6O53WXW5TwR5My7wj1gxv3Q==
X-Received: by 2002:a17:90a:2983:b0:1cb:8d6e:e10b with SMTP id h3-20020a17090a298300b001cb8d6ee10bmr11917007pjd.208.1650272862770;
        Mon, 18 Apr 2022 02:07:42 -0700 (PDT)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id g3-20020a056a000b8300b0050a833a491bsm1520172pfj.197.2022.04.18.02.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 02:07:42 -0700 (PDT)
From:   Kevin Hao <haokexin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH] net: stmmac: Use readl_poll_timeout_atomic() in atomic state
Date:   Mon, 18 Apr 2022 17:05:00 +0800
Message-Id: <20220418090500.3393423-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.34.1
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

The init_systime() may be invoked in atomic state. We have observed the
following call trace when running "phc_ctl /dev/ptp0 set" on a Intel
Agilex board.
  BUG: sleeping function called from invalid context at drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c:74
  in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 381, name: phc_ctl
  preempt_count: 1, expected: 0
  RCU nest depth: 0, expected: 0
  Preemption disabled at:
  [<ffff80000892ef78>] stmmac_set_time+0x34/0x8c
  CPU: 2 PID: 381 Comm: phc_ctl Not tainted 5.18.0-rc2-next-20220414-yocto-standard+ #567
  Hardware name: SoCFPGA Agilex SoCDK (DT)
  Call trace:
   dump_backtrace.part.0+0xc4/0xd0
   show_stack+0x24/0x40
   dump_stack_lvl+0x7c/0xa0
   dump_stack+0x18/0x34
   __might_resched+0x154/0x1c0
   __might_sleep+0x58/0x90
   init_systime+0x78/0x120
   stmmac_set_time+0x64/0x8c
   ptp_clock_settime+0x60/0x9c
   pc_clock_settime+0x6c/0xc0
   __arm64_sys_clock_settime+0x88/0xf0
   invoke_syscall+0x5c/0x130
   el0_svc_common.constprop.0+0x4c/0x100
   do_el0_svc+0x7c/0xa0
   el0_svc+0x58/0xcc
   el0t_64_sync_handler+0xa4/0x130
   el0t_64_sync+0x18c/0x190

So we should use readl_poll_timeout_atomic() here instead of
readl_poll_timeout().

Fixes: ff8ed737860e ("net: stmmac: use readl_poll_timeout() function in init_systime()")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 22fea0f67245..58448e9b6625 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -71,7 +71,7 @@ static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
 	writel(value, ioaddr + PTP_TCR);
 
 	/* wait for present system time initialize to complete */
-	return readl_poll_timeout(ioaddr + PTP_TCR, value,
+	return readl_poll_timeout_atomic(ioaddr + PTP_TCR, value,
 				 !(value & PTP_TCR_TSINIT),
 				 10000, 100000);
 }
-- 
2.34.1

