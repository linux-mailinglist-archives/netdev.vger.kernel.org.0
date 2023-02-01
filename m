Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E57685DE5
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 04:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjBADXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 22:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjBADXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 22:23:21 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16D043478;
        Tue, 31 Jan 2023 19:23:20 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id be8so17142758plb.7;
        Tue, 31 Jan 2023 19:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eF3+uQ/iC9ZPJbEUP+TfPygGgCu0+3aq1witfpsSE/w=;
        b=cjNHxxniZRvMUNs2AQL67d/8eW/wU+Pr4VE80JtdnqufgZIgaRQLPYqSFr0hYtAVPa
         IiwHcFtu12W1KcbyDWGiLdbVCz8oFVt8ly3m7yd4dngtDvb6OkYJ6FeOjPa2YHylQHSI
         cRu9SLTgml6f+iBf16+exqkUOyo9z7cCSroQjJMrJ8YgNF/XMvk3CyAvd6Xknbz0HkK/
         94KGdxlD/uRDWY0MbedInZLRhLRttnpuqK/5X5SWBHcKA68Wv2OPrIY60lAAL+jLwDGV
         ed5jMdk2uEyJqzmtr9w6lHbIpEBqqdBKS5lEPjEWRwfpCudbY5VqDd888ijEsY87Ah8/
         YLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eF3+uQ/iC9ZPJbEUP+TfPygGgCu0+3aq1witfpsSE/w=;
        b=BoiRbW4iF+PVaV/0iHNwI9KaiAQdBe/qB0qjXdWn+OPpKsD7lNhMNCtvQKzrW3B36U
         K4swxYm+NIar7aIZRUY9v7oneB2AbyO6TE+LRkxkSeT5BalOwv8d+OUh51STShFznH+6
         Em6opgbLmGdFga9uSv8yDJ1gZUpW5fmAk2qOW01gACG/fmKIQY3cz8FqagP7CrixWjYN
         zizTI0nnv+s55NN24IppFy9Dy8AxDJau3XdAnLW5odtw1OtD2p9IhSWVdpfg29IM0qpa
         W8XMhcUGHAtFaslegIxLY8LGqAtPEb1dfmtg4xX+Keb7gkjDcPquWUsQKtQwND4GHWh/
         2j+A==
X-Gm-Message-State: AO0yUKVzLSiYSRwVHyLWgW5RHCErfAkrBh0V2rbn7GnucPCjrlTd10qd
        ioTCNiP0VLNj9UwyFycEb6c=
X-Google-Smtp-Source: AK7set9hCNN3DCjuTcmqa47S420FczQLbyNjrEN33aHHYutsrnrKZr6DqhG8PYgBR03v1yM55dOmQQ==
X-Received: by 2002:a17:902:e751:b0:198:999e:4e5 with SMTP id p17-20020a170902e75100b00198999e04e5mr566185plf.62.1675221800055;
        Tue, 31 Jan 2023 19:23:20 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id 5-20020a170902c24500b0019335832ee9sm10434985plg.179.2023.01.31.19.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 19:23:19 -0800 (PST)
Date:   Tue, 31 Jan 2023 19:23:16 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: fec: fix conversion to gpiod API
Message-ID: <Y9nbJJP/2gvJmpnO@google.com>
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

The reset line is optional, so we should be using devm_gpiod_get_optional()
and not abort probing if it is not available. Also, there is a quirk in
gpiolib (introduced in b02c85c9458cdd15e2c43413d7d2541a468cde57) that
transparently handles "phy-reset-active-high" property. Remove handling
from the driver to avoid ending up with the double inversion/flipped
logic.

Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

v2: dropped conversion to generic device properties from the patch.

 drivers/net/ethernet/freescale/fec_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2716898e0b9b..1a8f1e6296f2 100644
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
@@ -4036,7 +4037,6 @@ static int fec_enet_init(struct net_device *ndev)
 static int fec_reset_phy(struct platform_device *pdev)
 {
 	struct gpio_desc *phy_reset;
-	bool active_high = false;
 	int msec = 1, phy_post_delay = 0;
 	struct device_node *np = pdev->dev.of_node;
 	int err;
@@ -4054,20 +4054,21 @@ static int fec_reset_phy(struct platform_device *pdev)
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
 				     "failed to get phy-reset-gpios\n");
 
+	if (!phy_reset)
+		return 0;
+
 	if (msec > 20)
 		msleep(msec);
 	else
 		usleep_range(msec * 1000, msec * 1000 + 1000);
 
-	gpiod_set_value_cansleep(phy_reset, !active_high);
+	gpiod_set_value_cansleep(phy_reset, 0);
 
 	if (!phy_post_delay)
 		return 0;
-- 
2.39.1.456.gfc5497dd1b-goog


-- 
Dmitry
