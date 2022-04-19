Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FC450671A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350104AbiDSIrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344465AbiDSIrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:47:45 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDD62631
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 01:45:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b7so5181162plh.2
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 01:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X2KGsW6b0Sn4O5TobSGtAgwWDjHoIqdrX635z8HKk2g=;
        b=Z3YP7m4Hi6+FbbD8Pnt/OWzIrDKkf6UfsHwQvK7UkBJGn9KWGJp9u6A9GOgNT39Mo4
         7VPRpOFFgWnQVrCAn0U+yjsfqW8nsa1HS161EzNFM9M6K0+y7baRoQqCi9mYhULFDm63
         3XYnPBSqcy5QvjwcXaE+ZXkKM35xDhm9xJpuWArDis1vDoNlKNs89nOW6nP826ubtk11
         ZhE6HcUqkbUBhs3w1Mf4zelk1cFSUSMuoj4z+2m/IhFCednSaLj4TBbHrvo7S2rA0nnl
         XX63DdRKyvzwQwiMUGNomNWPNpio6EXg19+zd+MBkNBlMkcFD8LeElTWD34d528yBFFI
         QOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X2KGsW6b0Sn4O5TobSGtAgwWDjHoIqdrX635z8HKk2g=;
        b=01ewTQgNhGBUzm92GMPpu8aD2rRWjCp23rM3+k5lB/EyNkQGIrzxWW3E1syLqDjZfH
         G6+HjLyySzSMDwDCVIWJ66uHFiN2rhOe2xuNedSYD/i5VmymqCJE7ReaABvlwnXRxVpu
         RRYrTbiTUw+zjiebikCTgONq3dSdSIWbb8Lz0ctxVIrAJ0suKUE9LCaLY5J1vzuemHnJ
         0AxV0rpUcLHdHdW3ICtCVwIvsJNRYsFE4decimJaR62DcusI7jhY/deQijqzoJvnV3Q9
         Conqa2B9UVuLz3wnfto3SbiHOY5OoCYVTMup1yEFZG6UUbaksgJ5iHPZ/GaTYpbMXIR4
         VKHw==
X-Gm-Message-State: AOAM530L3wi90sBeI9QKiiolIHSSvUgvEsUKtjmaLc0OUDU7m+pAHZPA
        rEW3e6Twk0jGI01IUoLRg9rQyYfiLaQ=
X-Google-Smtp-Source: ABdhPJyFqIglBKxu7J04iHFtU350zwAdnM+M5XIktrt7xCTxHoX5QbGCHczZPGQuJJmX0Rum6gYnjg==
X-Received: by 2002:a17:902:f24b:b0:158:f5c3:a210 with SMTP id j11-20020a170902f24b00b00158f5c3a210mr11336632plc.65.1650357903104;
        Tue, 19 Apr 2022 01:45:03 -0700 (PDT)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm16190618pfc.190.2022.04.19.01.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 01:45:02 -0700 (PDT)
From:   Kevin Hao <haokexin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 net] net: stmmac: Use readl_poll_timeout_atomic() in atomic state
Date:   Tue, 19 Apr 2022 16:42:26 +0800
Message-Id: <20220419084226.38340-1-haokexin@gmail.com>
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

Also adjust the delay time to 10us to fix a "__bad_udelay" build error
reported by "kernel test robot <lkp@intel.com>". I have tested this on
Intel Agilex and NXP S32G boards, there is no delay needed at all.
So the 10us delay should be long enough for most cases.

Fixes: ff8ed737860e ("net: stmmac: use readl_poll_timeout() function in init_systime()")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
v2: Fix the "__bad_udelay" build error.

 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 22fea0f67245..92d32940aff0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -71,9 +71,9 @@ static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
 	writel(value, ioaddr + PTP_TCR);
 
 	/* wait for present system time initialize to complete */
-	return readl_poll_timeout(ioaddr + PTP_TCR, value,
+	return readl_poll_timeout_atomic(ioaddr + PTP_TCR, value,
 				 !(value & PTP_TCR_TSINIT),
-				 10000, 100000);
+				 10, 100000);
 }
 
 static int config_addend(void __iomem *ioaddr, u32 addend)
-- 
2.34.1

