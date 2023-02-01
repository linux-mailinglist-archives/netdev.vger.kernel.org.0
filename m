Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526D66870BE
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 22:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjBAVxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 16:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjBAVx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 16:53:28 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201818680;
        Wed,  1 Feb 2023 13:53:28 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id h9so11276608plf.9;
        Wed, 01 Feb 2023 13:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tLp5ZQAmIsso9n6U/cVas1dfVfKmm+HocsrQi1jdGpU=;
        b=U+w3KMMxuYROKu607z5NG19MS4JmHQ/C+C2opcAdLW98xCmjTjl4aceqX0CjOM6T2h
         oFyrOv2crppvW+BRotVz3yEZpi2SAwxnhp7GDTn2FQj2wEBVcf/f6rR5sFufviwXqbJZ
         pJFErase+EmB8IWPW1X7JzXz7xqMb61bmwuN4za1qo0/LysOvuuTYEVQhY9t+k9oagSa
         0woC9BwJ4RRQ7RFCc8SrDM9wtkwRmtlmTDk/jwcpfznsYUpxd/GJaG4cgouEqdSN326Z
         9ze6kOvxXDPi1omAee89uoFRQEBSRo7XzySgc8tWrYORxf86LKDgAt7ymlEMzqFhxUvW
         jUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tLp5ZQAmIsso9n6U/cVas1dfVfKmm+HocsrQi1jdGpU=;
        b=rLJNJLFPQF8AP623MFPL7/y8+G03q9UpxjJkS5JvJPBuUeMczG5Cp34JyeEkIUBVqP
         K5KnT3a+3GaCiypT/BPPXQiW09SSKxtmpatDQD/q1oNhL6lJ47EZzrDuHjIb4DO2lxhc
         pQgIwd9btOZZWcqHxRSXMs5pkr8/MRZPWYK0qUf/En5LxvdlmSTs6irhjjHmWxEuZRcA
         Jc8AHSbzpo5FIeE2eR2WNUowQmAZis8YWZcEwz8BBQrjSEe+bhy0EdgWDuNuuKWr8nRX
         Kg22bVmji2iQQnC5l8YlsUO8RZiA23lt3CXM8gMGixRBGZFP1mbKirdmVcw05OHJ7n8w
         CYgQ==
X-Gm-Message-State: AO0yUKXgu/dSFU8SjIYKX1iLyWQhU/qs3dXlvuQXdZvPM1lBP68GhD8Y
        Y6bjS50mPZk23e3M+wCGKBU=
X-Google-Smtp-Source: AK7set+z5jn1JNydUIn8dfJKpEJOsXUBw8l6JElR9IJ/yHoNNcLnTonmZkHBUcR6TxJKFaLjoJ8EJQ==
X-Received: by 2002:a17:90a:ec07:b0:228:f13b:9649 with SMTP id l7-20020a17090aec0700b00228f13b9649mr4035768pjy.43.1675288407417;
        Wed, 01 Feb 2023 13:53:27 -0800 (PST)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id h15-20020a17090a054f00b002276ba8fb71sm1781957pjf.25.2023.02.01.13.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 13:53:26 -0800 (PST)
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
Subject: [PATCH v3 2/2] net: fec: do not double-parse 'phy-reset-active-high' property
Date:   Wed,  1 Feb 2023 13:53:20 -0800
Message-Id: <20230201215320.528319-2-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
References: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Conversion to gpiod API done in commit 468ba54bd616 ("fec: convert
to gpio descriptor") clashed with gpiolib applying the same quirk to the
reset GPIO polarity (introduced in commit b02c85c9458c). This results in
the reset line being left active/device being left in reset state when
reset line is "active low".

Remove handling of 'phy-reset-active-high' property from the driver and
rely on gpiolib to apply needed adjustments to avoid ending up with the
double inversion/flipped logic.

Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

v3: new patch, split from the original one

 drivers/net/ethernet/freescale/fec_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 00115b55d0ff..c73e25f8995e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4036,7 +4036,6 @@ static int fec_enet_init(struct net_device *ndev)
 static int fec_reset_phy(struct platform_device *pdev)
 {
 	struct gpio_desc *phy_reset;
-	bool active_high = false;
 	int msec = 1, phy_post_delay = 0;
 	struct device_node *np = pdev->dev.of_node;
 	int err;
@@ -4054,10 +4053,8 @@ static int fec_reset_phy(struct platform_device *pdev)
 	if (!err && phy_post_delay > 1000)
 		return -EINVAL;
 
-	active_high = of_property_read_bool(np, "phy-reset-active-high");
-
 	phy_reset = devm_gpiod_get_optional(&pdev->dev, "phy-reset",
-			active_high ? GPIOD_OUT_HIGH : GPIOD_OUT_LOW);
+					    GPIOD_OUT_HIGH);
 	if (IS_ERR(phy_reset))
 		return dev_err_probe(&pdev->dev, PTR_ERR(phy_reset),
 				     "failed to get phy-reset-gpios\n");
@@ -4070,7 +4067,7 @@ static int fec_reset_phy(struct platform_device *pdev)
 	else
 		usleep_range(msec * 1000, msec * 1000 + 1000);
 
-	gpiod_set_value_cansleep(phy_reset, !active_high);
+	gpiod_set_value_cansleep(phy_reset, 0);
 
 	if (!phy_post_delay)
 		return 0;
-- 
2.39.1.456.gfc5497dd1b-goog

