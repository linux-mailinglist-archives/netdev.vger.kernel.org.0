Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514BA649104
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 23:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiLJWh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 17:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLJWh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 17:37:27 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B332A12622
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 14:37:25 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id m18so19430969eji.5
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 14:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SOpPPmLDqJRTyYLaP8xxRj41YiDFLX4ctufztbQrUmk=;
        b=qszhE2sJQ6bWXYvVqHbTZ8nAvZOEowBhjcvlCDYV4i8nKemFDpRYb4vXCTmhTCM97m
         nWX5SJZxjERmwOi+gBi/fnkgofRtZYhSCoYgT31hc7tA5uUDF+pM4d6YCgJcfUti7yhT
         CqZy3BjINrii2V1ZwPU4wmTv44MNbUAOEG07u+UZaPbi6kQochR/Q5dZvUUQCwbApIm6
         VjTJcrwpaTAF7GdVGPsD6A+Hc5eKORrnim3MDFXUbMgFXO07hlHcGhMQYCZ0ua5XSJt9
         xnNqjpc6SvrlpszMYqaoYIUanG0nSB4LVQYAy7mYl1oMZmorbmKsBVo8KzTOtmIskw4F
         dCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SOpPPmLDqJRTyYLaP8xxRj41YiDFLX4ctufztbQrUmk=;
        b=pmF5/qr1AQ5tY+/zwkZbkb3x0ApAJWHXeWyBT5leFWTXFbbpEQa9aEYQSJJ3kRVnqh
         wtrSwJEiSPz9PI2m+NP0CFQ3nDJm/6VYJDy0rUC9uVV7OJH58Q7llyj1RtAB5OAe8KCs
         ox5/lN6g0bd90F1PXlBd1BAvtFZkKNHjYR/16SZIgOW9t3rC6MmvJV6Ocy3yVTNKC1UN
         xR6HZoQxNVGPfsCSoD7tdTWg7q6C8EoZyHtgnbVJVG2zVo7+H8CQkTDcOz2yRW+4x0lV
         zYc2kENXp7BwlyfU1snjo8HCFIIUszfJmKxrhaAltRxIYwGaVhEKTIuhCB7QkilBewMl
         AsIQ==
X-Gm-Message-State: ANoB5pnMuZN974SX4q9IL9hTj/cqgTadnelvbiH8XLLKnQdjB6Jo9/BU
        PqUVaMlpzpRLmdJUhn02VpLYBFoJbUJjuBMe
X-Google-Smtp-Source: AA0mqf73zLrDH5rjGi0vsHLpIzaPOxCwgNKCwrmxNTNfinbqNvf4R/idOBB0ItCeCZX+v04qWG+AZA==
X-Received: by 2002:a17:907:30d8:b0:7c0:e30a:d3e5 with SMTP id vl24-20020a17090730d800b007c0e30ad3e5mr7364909ejb.18.1670711843911;
        Sat, 10 Dec 2022 14:37:23 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id kv4-20020a17090778c400b007c0b530f3cfsm1424043ejc.72.2022.12.10.14.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 14:37:23 -0800 (PST)
Date:   Sat, 10 Dec 2022 23:37:22 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Julien Beraud <julien.beraud@orolia.com>
Cc:     netdev@vger.kernel.org, Andreww Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net 1/1] stmmac: fix potential division by 0
Message-ID: <de4c64ccac9084952c56a06a8171d738604c4770.1670678513.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the MAC is connected to a 10 Mb/s PHY and the PTP clock is derived
from the MAC reference clock (default), the clk_ptp_rate becomes too
small and the calculated sub second increment becomes 0 when computed by
the stmmac_config_sub_second_increment() function within
stmmac_init_tstamp_counter().

Therefore, the subsequent div_u64 in stmmac_init_tstamp_counter()
operation triggers a divide by 0 exception as shown below.

[   95.062067] socfpga-dwmac ff700000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   95.076440] socfpga-dwmac ff700000.ethernet eth0: PHY [stmmac-0:08] driver [NCN26000] (irq=49)
[   95.095964] dwmac1000: Master AXI performs any burst length
[   95.101588] socfpga-dwmac ff700000.ethernet eth0: No Safety Features support found
[   95.109428] Division by zero in kernel.
[   95.113447] CPU: 0 PID: 239 Comm: ifconfig Not tainted 6.1.0-rc7-centurion3-1.0.3.0-01574-gb624218205b7-dirty #77
[   95.123686] Hardware name: Altera SOCFPGA
[   95.127695]  unwind_backtrace from show_stack+0x10/0x14
[   95.132938]  show_stack from dump_stack_lvl+0x40/0x4c
[   95.137992]  dump_stack_lvl from Ldiv0+0x8/0x10
[   95.142527]  Ldiv0 from __aeabi_uidivmod+0x8/0x18
[   95.147232]  __aeabi_uidivmod from div_u64_rem+0x1c/0x40
[   95.152552]  div_u64_rem from stmmac_init_tstamp_counter+0xd0/0x164
[   95.158826]  stmmac_init_tstamp_counter from stmmac_hw_setup+0x430/0xf00
[   95.165533]  stmmac_hw_setup from __stmmac_open+0x214/0x2d4
[   95.171117]  __stmmac_open from stmmac_open+0x30/0x44
[   95.176182]  stmmac_open from __dev_open+0x11c/0x134
[   95.181172]  __dev_open from __dev_change_flags+0x168/0x17c
[   95.186750]  __dev_change_flags from dev_change_flags+0x14/0x50
[   95.192662]  dev_change_flags from devinet_ioctl+0x2b4/0x604
[   95.198321]  devinet_ioctl from inet_ioctl+0x1ec/0x214
[   95.203462]  inet_ioctl from sock_ioctl+0x14c/0x3c4
[   95.208354]  sock_ioctl from vfs_ioctl+0x20/0x38
[   95.212984]  vfs_ioctl from sys_ioctl+0x250/0x844
[   95.217691]  sys_ioctl from ret_fast_syscall+0x0/0x4c
[   95.222743] Exception stack(0xd0ee1fa8 to 0xd0ee1ff0)
[   95.227790] 1fa0:                   00574c4f be9aeca4 00000003 00008914 be9aeca4 be9aec50
[   95.235945] 1fc0: 00574c4f be9aeca4 0059f078 00000036 be9aee8c be9aef7a 00000015 00000000
[   95.244096] 1fe0: 005a01f0 be9aec38 004d7484 b6e67d74

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Fixes: 91a2559c1dc5 ("net: stmmac: Fix sub-second increment")
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 3 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h      | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 764832f4dae1..8b50f03056b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -47,7 +47,8 @@ static void config_sub_second_increment(void __iomem *ioaddr,
 	if (!(value & PTP_TCR_TSCTRLSSR))
 		data = (data * 1000) / 465;
 
-	data &= PTP_SSIR_SSINC_MASK;
+	if (data > PTP_SSIR_SSINC_MAX)
+		data = PTP_SSIR_SSINC_MAX;
 
 	reg_value = data;
 	if (gmac4)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
index 53172a439810..bf619295d079 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
@@ -64,7 +64,7 @@
 #define	PTP_TCR_TSENMACADDR	BIT(18)
 
 /* SSIR defines */
-#define	PTP_SSIR_SSINC_MASK		0xff
+#define	PTP_SSIR_SSINC_MAX		0xff
 #define	GMAC4_PTP_SSIR_SSINC_SHIFT	16
 
 /* Auxiliary Control defines */
-- 
2.35.1

