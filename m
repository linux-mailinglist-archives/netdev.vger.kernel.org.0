Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103684B3F60
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 03:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiBNCVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 21:21:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiBNCVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 21:21:20 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A7F54FA0
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:21:13 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id s6-20020a0568301e0600b0059ea5472c98so10674481otr.11
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XHBYJ0FhYYa/VplEQ75FFPvzacvbyVuJcGwPiTu1/s8=;
        b=nDHrm9dSVRJvyCGqHqL7I31R3t/+V6Zai5XvbUHIw7B5pRIPiC80OmEsvaBOX3AKtf
         lWkGW40e1NnEUTjE3y17KRdH8oKOfsJcAfDq4J2wxTwRMETP7mzelLsDTaHIIVJRLzW4
         A4iDJa+sJYgz4svSR2OTKQ4+ZNQAvZvpp3Hkka5VMFJZen8T3Ap0rHoxYND3hXopSdsW
         a0D4VHxgi65BOoX9ooi61KF9C+vxoio1oyEiGV36wqTFtb0Q/IhKBduuaudtMKSE1I0c
         WypbIGvdSnPbYsTa/4OyYzdrSqPHWap5DCUIUr1dpt7VYKrHZAAUQo1m8Xkf3IgfRChn
         dTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XHBYJ0FhYYa/VplEQ75FFPvzacvbyVuJcGwPiTu1/s8=;
        b=WocbvwhjqETOKaa1mkV89F2wrty8kq/3fhDG3fNYsEWPaIguLcwJZ/4qBF0xBqxJfI
         hWOf2vM8L0UTNmQ/zeDC3z+LEDPgIGMBwkUqcB4/18V5llzbrm0U6ZkPYgF+Yil9gkhc
         xBPJ1I/CDi/EsTrxuaM7r2gABieOtJM02KnKklkbG+rIrtjaDMj+PeAkNFAfTu0KymGD
         g8G6zQw/Z4cVjVrAHCVoaJRQXEz34pFKrclg9NB87cOZZFVDYJMmu8wavUgNwSXuczwV
         M7EbrgTYG3gqFLaD/1iy7LbVpUQO4RliFPL2HzbBMRWutZA7hJgbQknT5OGSEb6VuUMb
         +4Xw==
X-Gm-Message-State: AOAM532mVJbm6ry2kp1ALDpbczQ/gtH/2MdZXgLtSkhmb6dBFvIYPlc0
        iAiho1+aMRZHO06WOxMMe0yrYjc5KroN8w==
X-Google-Smtp-Source: ABdhPJxdi/Yu5gHZuNnMeUAvyDC6ipg4MkUq1DwnFpypo3o8MiT9Fs1pYy4GYT3MyP6KEK08t4mJVg==
X-Received: by 2002:a9d:2781:: with SMTP id c1mr4232273otb.267.1644805270765;
        Sun, 13 Feb 2022 18:21:10 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id h203sm12321150oif.27.2022.02.13.18.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 18:21:10 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 1/2] net: dsa: realtek: realtek-smi: clean-up reset
Date:   Sun, 13 Feb 2022 23:20:11 -0300
Message-Id: <20220214022012.14787-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214022012.14787-1-luizluca@gmail.com>
References: <20220214022012.14787-1-luizluca@gmail.com>
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

When reset GPIO was missing, the driver was still printing an info
message and still trying to assert the reset. Although gpiod_set_value()
will silently ignore calls with NULL gpio_desc, it is better to make it
clear the driver might allow gpio_desc to be NULL.

The initial value for the reset pin was changed to GPIOD_OUT_LOW,
followed by a gpiod_set_value() asserting the reset. This way, it will
be easier to spot if and where the reset really happens.

A new "asserted RESET" message was added just after the reset is
asserted, similar to the existing "deasserted RESET" message. Both
messages were demoted to dbg. The code comment is not needed anymore.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-smi.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 946fbbd70153..33cf5a0692de 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -420,16 +420,19 @@ static int realtek_smi_probe(struct platform_device *pdev)
 
 	/* TODO: if power is software controlled, set up any regulators here */
 
-	/* Assert then deassert RESET */
-	priv->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	priv->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(priv->reset)) {
 		dev_err(dev, "failed to get RESET GPIO\n");
 		return PTR_ERR(priv->reset);
 	}
-	msleep(REALTEK_SMI_HW_STOP_DELAY);
-	gpiod_set_value(priv->reset, 0);
-	msleep(REALTEK_SMI_HW_START_DELAY);
-	dev_info(dev, "deasserted RESET\n");
+	if (priv->reset) {
+		gpiod_set_value(priv->reset, 1);
+		dev_dbg(dev, "asserted RESET\n");
+		msleep(REALTEK_SMI_HW_STOP_DELAY);
+		gpiod_set_value(priv->reset, 0);
+		msleep(REALTEK_SMI_HW_START_DELAY);
+		dev_dbg(dev, "deasserted RESET\n");
+	}
 
 	/* Fetch MDIO pins */
 	priv->mdc = devm_gpiod_get_optional(dev, "mdc", GPIOD_OUT_LOW);
@@ -474,7 +477,10 @@ static int realtek_smi_remove(struct platform_device *pdev)
 	dsa_unregister_switch(priv->ds);
 	if (priv->slave_mii_bus)
 		of_node_put(priv->slave_mii_bus->dev.of_node);
-	gpiod_set_value(priv->reset, 1);
+
+	/* leave the device reset asserted */
+	if (priv->reset)
+		gpiod_set_value(priv->reset, 1);
 
 	platform_set_drvdata(pdev, NULL);
 
-- 
2.35.1

