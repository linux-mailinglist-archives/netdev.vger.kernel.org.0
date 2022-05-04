Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9A951A187
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 15:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350950AbiEDN7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 09:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350941AbiEDN7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 09:59:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A891EEF5;
        Wed,  4 May 2022 06:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651672535; x=1683208535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VFRSvvAnvwFGIGd0aLNekAxiY2K03BO+iR35H1EOHsc=;
  b=hFvGydlCmIOHe7w4JMCpH2kH+nMZornELLVC91kGO7gfK2x8LVaNMoEg
   tsqYCUqq5RA0OmY+PYeHvU5+t/iNNtG6o8XLdbLC7jz+SnSGljORjJXGJ
   hxDcxLa8jha7kHWiGYxVoy+Jw3CcszIgYnQ+IOFzk6kypaNwmu0tlGd1A
   u0AbxhzxdosxpreGK+QhYpHjYbuqHS01sofRBbldRIo2y99wnvkHz958x
   FKlw0mj8mvmn9j1qhjYvTRAjp1yk3ejGK2oCkdb1LWWMwT/9CatB3XZZn
   GJX4Akg/1eYSQ7DsRVujLn3HlDooG+8eKp8KhPdonp4/gnMkrycvh6Miz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="267653578"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="267653578"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 06:55:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="536841297"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 04 May 2022 06:55:28 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 39228115; Wed,  4 May 2022 16:55:29 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
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
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 3/4] powerpc/52xx: Get rid of of_node assignment
Date:   Wed,  4 May 2022 16:44:48 +0300
Message-Id: <20220504134449.64473-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
References: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 8f896a42d7d8..0831f28345af 100644
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

