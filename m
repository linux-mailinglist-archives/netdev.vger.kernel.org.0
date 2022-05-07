Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F3751E658
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 12:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446271AbiEGKGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 06:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446217AbiEGKFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 06:05:44 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DDB3DA6B;
        Sat,  7 May 2022 03:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651917717; x=1683453717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/TH2t2Zl2v5PlFXuYgl2cfI4T7s5wGnQ+3rQ63ZiRDM=;
  b=BKyb90VKeR2fb351g3S7LYuQ5xQOwq1Wl/4LH7fcnrWhAY9hxMlo+X19
   pCnl2MJ01Y7dDmHGti17wcQVj1S3OH6IJp3HFkT+5oKxwo0FD7/XuDI4T
   hUBaAKijgBnVexRCAFqTd17ypx7A33gUnfJ8c3zch9mVhRudYrqceTvYN
   OOxYkFCI2rL0YsOexMLtUWUWZghkFOAG4ndOa5hG5AhNfUTXSFV4fjsvT
   uG41Ef1u1kgD+mxq171w6W2E2C+Gh6qykMtze4JoZcuF8VH/041MR82nl
   OA93H9JQX4vvCSAMWx5HlkvJIdBxA6GiljmysW4wNFaxBWGdqPMO/vW2c
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="250701988"
X-IronPort-AV: E=Sophos;i="5.91,206,1647327600"; 
   d="scan'208";a="250701988"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2022 03:01:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,206,1647327600"; 
   d="scan'208";a="655073428"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 07 May 2022 03:01:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 931661D6; Sat,  7 May 2022 13:01:49 +0300 (EEST)
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
Subject: [PATCH v2 3/4] powerpc/52xx: Get rid of of_node assignment
Date:   Sat,  7 May 2022 13:01:46 +0300
Message-Id: <20220507100147.5802-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
References: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let GPIO library assign of_node from the parent device.
This allows to move GPIO library and drivers to use fwnode
APIs instead of being stuck with OF-only interfaces.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: no changes
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 2605b4667b39..ae47fdcc8a96 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -58,6 +58,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 #include <linux/kernel.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/watchdog.h>
@@ -314,17 +315,15 @@ mpc52xx_gpt_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
-static void
-mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
+static void mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *gpt)
 {
 	int rc;
 
-	/* Only setup GPIO if the device tree claims the GPT is
-	 * a GPIO controller */
-	if (!of_find_property(node, "gpio-controller", NULL))
+	/* Only setup GPIO if the device claims the GPT is a GPIO controller */
+	if (!device_property_present(gpt->dev, "gpio-controller"))
 		return;
 
-	gpt->gc.label = kasprintf(GFP_KERNEL, "%pOF", node);
+	gpt->gc.label = kasprintf(GFP_KERNEL, "%pfw", dev_fwnode(gpt->dev));
 	if (!gpt->gc.label) {
 		dev_err(gpt->dev, "out of memory\n");
 		return;
@@ -336,7 +335,7 @@ mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 	gpt->gc.get = mpc52xx_gpt_gpio_get;
 	gpt->gc.set = mpc52xx_gpt_gpio_set;
 	gpt->gc.base = -1;
-	gpt->gc.of_node = node;
+	gpt->gc.parent = gpt->dev;
 
 	/* Setup external pin in GPIO mode */
 	clrsetbits_be32(&gpt->regs->mode, MPC52xx_GPT_MODE_MS_MASK,
@@ -349,8 +348,7 @@ mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 	dev_dbg(gpt->dev, "%s() complete.\n", __func__);
 }
 #else /* defined(CONFIG_GPIOLIB) */
-static void
-mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *p, struct device_node *np) { }
+static void mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *gpt) { }
 #endif /* defined(CONFIG_GPIOLIB) */
 
 /***********************************************************************
@@ -727,7 +725,7 @@ static int mpc52xx_gpt_probe(struct platform_device *ofdev)
 
 	dev_set_drvdata(&ofdev->dev, gpt);
 
-	mpc52xx_gpt_gpio_setup(gpt, ofdev->dev.of_node);
+	mpc52xx_gpt_gpio_setup(gpt);
 	mpc52xx_gpt_irq_setup(gpt, ofdev->dev.of_node);
 
 	mutex_lock(&mpc52xx_gpt_list_mutex);
-- 
2.35.1

