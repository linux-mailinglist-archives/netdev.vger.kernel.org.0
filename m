Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6451E655
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 12:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446292AbiEGKGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 06:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbiEGKFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 06:05:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040C53D4B9;
        Sat,  7 May 2022 03:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651917715; x=1683453715;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Q/otdjcbA6WbbPS5f3qcEn378K8z0rLFkeMOCGtuneE=;
  b=B61f1fM1p9qVEJQbfg4WSL1V39NNCIKF5mwSY0Zk4neWljbwsvU7x8Jl
   3j5ijrmTAsc7i0aYl4I6LSE4RjKFwCJ8yIq3dQCbeuwsAJqFCz6LJnrRZ
   QfPcNbP5eHDPdnDehEgjgi7n5huQSbFUuv9iIlCeYDLKec6X4pvkUkeHF
   +B/ee2gSw8gY4i7eDZrrQx3YArTQkX9Ec0lTgOtX2zwX8bvRfQpAlPxZR
   L1LsMLMjWmrukvMKmbtg3P4gYjjb/EX/gKj1FB/JjT/wOiNqrym0zQEhR
   BnsJ0O/KdvGj53iH6nwdA4L74HYMqdyNXVmoa8EmDBD4URt2LXy6RnoRf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="268828938"
X-IronPort-AV: E=Sophos;i="5.91,206,1647327600"; 
   d="scan'208";a="268828938"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2022 03:01:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,206,1647327600"; 
   d="scan'208";a="695555683"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 07 May 2022 03:01:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 78FB3155; Sat,  7 May 2022 13:01:49 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mark Brown <broonie@kernel.org>,
        chris.packham@alliedtelesis.co.nz,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Subject: [PATCH v2 1/4] powerpc/52xx: Remove dead code, i.e. mpc52xx_get_xtal_freq()
Date:   Sat,  7 May 2022 13:01:44 +0300
Message-Id: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems mpc52xx_get_xtal_freq() is not used anywhere. Remove dead code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Wolfram Sang <wsa@kernel.org>
---
v2: collected tags
 arch/powerpc/include/asm/mpc52xx.h           |  1 -
 arch/powerpc/platforms/52xx/mpc52xx_common.c | 37 --------------------
 2 files changed, 38 deletions(-)

diff --git a/arch/powerpc/include/asm/mpc52xx.h b/arch/powerpc/include/asm/mpc52xx.h
index ce1e0aabaa64..ddd80aae1e32 100644
--- a/arch/powerpc/include/asm/mpc52xx.h
+++ b/arch/powerpc/include/asm/mpc52xx.h
@@ -274,7 +274,6 @@ extern void mpc52xx_declare_of_platform_devices(void);
 extern int mpc5200_psc_ac97_gpio_reset(int psc_number);
 extern void mpc52xx_map_common_devices(void);
 extern int mpc52xx_set_psc_clkdiv(int psc_id, int clkdiv);
-extern unsigned int mpc52xx_get_xtal_freq(struct device_node *node);
 extern void __noreturn mpc52xx_restart(char *cmd);
 
 /* mpc52xx_gpt.c */
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_common.c b/arch/powerpc/platforms/52xx/mpc52xx_common.c
index 565e3a83dc9e..4a39e1cb2263 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_common.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_common.c
@@ -203,43 +203,6 @@ int mpc52xx_set_psc_clkdiv(int psc_id, int clkdiv)
 }
 EXPORT_SYMBOL(mpc52xx_set_psc_clkdiv);
 
-/**
- * mpc52xx_get_xtal_freq - Get SYS_XTAL_IN frequency for a device
- *
- * @node: device node
- *
- * Returns the frequency of the external oscillator clock connected
- * to the SYS_XTAL_IN pin, or 0 if it cannot be determined.
- */
-unsigned int mpc52xx_get_xtal_freq(struct device_node *node)
-{
-	u32 val;
-	unsigned int freq;
-
-	if (!mpc52xx_cdm)
-		return 0;
-
-	freq = mpc5xxx_get_bus_frequency(node);
-	if (!freq)
-		return 0;
-
-	if (in_8(&mpc52xx_cdm->ipb_clk_sel) & 0x1)
-		freq *= 2;
-
-	val  = in_be32(&mpc52xx_cdm->rstcfg);
-	if (val & (1 << 5))
-		freq *= 8;
-	else
-		freq *= 4;
-	if (val & (1 << 6))
-		freq /= 12;
-	else
-		freq /= 16;
-
-	return freq;
-}
-EXPORT_SYMBOL(mpc52xx_get_xtal_freq);
-
 /**
  * mpc52xx_restart: ppc_md->restart hook for mpc5200 using the watchdog timer
  */
-- 
2.35.1

