Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CF3683992
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjAaWs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbjAaWs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:48:26 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EBC13DEB;
        Tue, 31 Jan 2023 14:48:20 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso2277947pju.0;
        Tue, 31 Jan 2023 14:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6kwuIhUv1yjhT0xuETFJz2oVLL3BtcvO9tDJ9jRzsWI=;
        b=Xr0ymyYNLQbibGsJScW4JKNLzoF6HH/dDhtTIDnfEVMHd389zDQ8G60HZCgEJc+gHO
         KgbQkbtZ8qwi8I1bHn7Ju3qcITk52xBKnNwHbVmMjcKx5EHw7P7k2Bcu1OEIan4+SI11
         jP1hMdp7Mb+3ADs14T4Ad6vOwioFlpsN2DcCmJyquzFMDNr4Ca207+t8jmg37ZVwiGP4
         uSsXANkIUfCqPsLF7wSdKrZEIRYLNf2qpLMtlEOmY3N+xDpGGjec6jX03MG1AtE+wRgw
         ImyDMjgjW1/8KamBNGASvhV3UNjbT/ajJ4D5Z9x22G8dYsIhdoy3faKnvRs01hvUIx2N
         Db9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6kwuIhUv1yjhT0xuETFJz2oVLL3BtcvO9tDJ9jRzsWI=;
        b=ZBm+pbzZWpQBrVnzrGDvuFGDT0mtER/dYFHy8ZdgOVmjl/xYHFMXU9NLSDeDNhmBpu
         pI+dtABryANzbImMYdFgap+h/kgiRA/QcLlbhRI+4MdWC0rkN5CV8wSToVPTV2N5dajH
         rShv3XxGKIywbTNa2og9kpl5ll9Vqk4OCAbaJ2WN997ixU5h1A8MEJeZTcK2c5cFNcqN
         kQS5QJOBC4W9RcmXYzjNWKxM2utGS3nQMv2R+lCE868AquNv7AMJ2sVmzrp4WaBKjwcV
         4sdrYCfNm+s/KEb7kJLk/Zc4+uG/3slH6v3+pF2muEvJrmLEg9M67WLLlow3Fxj2uYwz
         VEaQ==
X-Gm-Message-State: AO0yUKVNCFNY++3Ne9xPvvDHQsrOH1CZG+7RdYY3rZ/BvSiMEvUpzSBS
        +3YMYQbT+wGkYzqeOaQcQ8Dt8e2mGTg=
X-Google-Smtp-Source: AK7set95G8jOg+GrDZN+glwKR2rgPogOa/ncWkz9eb92xKjLy7i7L7rmJL+LG/vi4gt/0TkUoKMBww==
X-Received: by 2002:a17:903:41d1:b0:194:d057:46e5 with SMTP id u17-20020a17090341d100b00194d05746e5mr522369ple.62.1675205299907;
        Tue, 31 Jan 2023 14:48:19 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:effb:a74f:225a:28ef])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902ec8100b001966d94cb2esm6467139plg.288.2023.01.31.14.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 14:48:18 -0800 (PST)
Date:   Tue, 31 Jan 2023 14:48:15 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: fec: fix conversion to gpiod API
Message-ID: <Y9mar1COtT5z4mvT@google.com>
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

The reset line is optional, so we should be using
devm_gpiod_get_optional() and not abort probing if it is not available.
Also, gpiolib already handles phy-reset-active-high, continuing handling
it directly in the driver when using gpiod API results in flipped logic.

While at this convert phy properties parsing from OF to generic device
properties to avoid #ifdef-ery.

Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 36 ++++++++---------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2716898e0b9b..c2b54a31541e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -27,6 +27,7 @@
 #include <linux/string.h>
 #include <linux/pm_runtime.h>
 #include <linux/ptrace.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
@@ -65,6 +66,7 @@
 #include <linux/prefetch.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/property.h>
 #include <soc/imx/cpuidle.h>
 #include <linux/filter.h>
 #include <linux/bpf.h>
@@ -4032,42 +4034,38 @@ static int fec_enet_init(struct net_device *ndev)
 	return ret;
 }
 
-#ifdef CONFIG_OF
 static int fec_reset_phy(struct platform_device *pdev)
 {
 	struct gpio_desc *phy_reset;
-	bool active_high = false;
 	int msec = 1, phy_post_delay = 0;
-	struct device_node *np = pdev->dev.of_node;
 	int err;
 
-	if (!np)
-		return 0;
-
-	err = of_property_read_u32(np, "phy-reset-duration", &msec);
+	err = device_property_read_u32(&pdev->dev, "phy-reset-duration", &msec);
 	/* A sane reset duration should not be longer than 1s */
 	if (!err && msec > 1000)
 		msec = 1;
 
-	err = of_property_read_u32(np, "phy-reset-post-delay", &phy_post_delay);
+	err = device_property_read_u32(&pdev->dev, "phy-reset-post-delay",
+				       &phy_post_delay);
 	/* valid reset duration should be less than 1s */
 	if (!err && phy_post_delay > 1000)
 		return -EINVAL;
 
-	active_high = of_property_read_bool(np, "phy-reset-active-high");
-
-	phy_reset = devm_gpiod_get(&pdev->dev, "phy-reset",
-			active_high ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW);
+	phy_reset = devm_gpiod_get_optional(&pdev->dev, "phy-reset",
+					    GPIOD_OUT_HIGH);
 	if (IS_ERR(phy_reset))
 		return dev_err_probe(&pdev->dev, PTR_ERR(phy_reset),
-				     "failed to get phy-reset-gpios\n");
+				     "failed to request phy-reset-gpios\n");
+
+	if (!phy_reset)
+		return 0;
 
 	if (msec > 20)
 		msleep(msec);
 	else
 		usleep_range(msec * 1000, msec * 1000 + 1000);
 
-	gpiod_set_value_cansleep(phy_reset, !active_high);
+	gpiod_set_value_cansleep(phy_reset, 0);
 
 	if (!phy_post_delay)
 		return 0;
@@ -4080,16 +4078,6 @@ static int fec_reset_phy(struct platform_device *pdev)
 
 	return 0;
 }
-#else /* CONFIG_OF */
-static int fec_reset_phy(struct platform_device *pdev)
-{
-	/*
-	 * In case of platform probe, the reset has been done
-	 * by machine code.
-	 */
-	return 0;
-}
-#endif /* CONFIG_OF */
 
 static void
 fec_enet_get_queue_num(struct platform_device *pdev, int *num_tx, int *num_rx)
-- 
2.39.1.456.gfc5497dd1b-goog


-- 
Dmitry
