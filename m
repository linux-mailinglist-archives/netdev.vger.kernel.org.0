Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27EA6C1AC0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbjCTQAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbjCTQAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:00:11 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A523E0BA;
        Mon, 20 Mar 2023 08:50:37 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so9459945wmb.5;
        Mon, 20 Mar 2023 08:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679327432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16/AUEfT4/3aNTDuWfjKv1lfTz12+h3pg0SmLHFA5Y8=;
        b=n+22dPTXjE1jqw2beYW8Kqab5uczPETidauati8u3xeWTbKyfCENVVcYJBQgNPM3pw
         BeH+srFpkROFpxJ+btOlNSEZA4pIuBf2EOOU4AWrlPTWglRDxVHZ3X7kVDptJnxVGvre
         zNQ31LP8wxHP9XSFxYbkK9ybYYC8WP3fQZwcGcAgliP2cbKQMwuUP/i2w3Hqml8t6rP1
         5HaZgmWt9wdh8c76nCWP03IuNM9oJ9qa3YWDBrVVN2eMe0mGxZmKR+Wb/BZj3o5ezJmu
         q41drXRwHBC6vF1K+HHeOgAcMlTKIJUAo2daNVm/UBTXj2SXsvfh4nfgrWVAexOpd/uP
         elYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679327432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=16/AUEfT4/3aNTDuWfjKv1lfTz12+h3pg0SmLHFA5Y8=;
        b=6ZfI8DXxxDA2NF5hw1Mfoc/pGgW+OfRfwgMoE4jB/ABbQg8zdQ/Ja7FGIqVPbi2hZe
         fvd7j+dw8CZvNbkRbsYQvMTwRfDRonn8aAwJBBNkMyTcm8s3D5BRURzVpe0ScyzPYvxQ
         0cXZASSL+EXA7Fyf51y4emSNy6Xb3nY0pjKWFUphqra9TdFQzhtnpdlN3tTwXFN9jlEu
         3Se1FWEiQP5FRtqXIU/oefh5FMXoJEDCKq8geZ04mouAdeVxZd/FUBR754EY6uNAhMVG
         hef4iX7HeDpTCJLCprNVFgQ80bbl/uh+QnBtEVGlDFcH4GR7csGSIp2g/3Qzj/m78rkz
         ml1Q==
X-Gm-Message-State: AO0yUKUPCBZQSCICZA8m4nHTp32xYgPPzQnSGO9a0aop0wLJeOUszuYx
        hH7zNhPrx7BZWaytny88AN0=
X-Google-Smtp-Source: AK7set9y2vPkyUF0Tln19u08/DwcR4L11U6iFXPmpi6kdzFhq0OrCiFNu8aAeCvisP/C/rvYvKH9Lw==
X-Received: by 2002:a05:600c:310e:b0:3e9:f15b:935b with SMTP id g14-20020a05600c310e00b003e9f15b935bmr34745262wmo.32.1679327432097;
        Mon, 20 Mar 2023 08:50:32 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c020300b003eddefd8792sm4812333wmi.14.2023.03.20.08.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 08:50:31 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 3/4] net: dsa: b53: mmap: allow passing a chip ID
Date:   Mon, 20 Mar 2023 16:50:23 +0100
Message-Id: <20230320155024.164523-4-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230320155024.164523-1-noltari@gmail.com>
References: <20230320155024.164523-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

BCM63268 SoCs require a special handling for their RGMIIs, so we should be
able to identify them as a special BCM63xx switch.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_mmap.c | 32 +++++++++++++++++++++++---------
 drivers/net/dsa/b53/b53_priv.h |  9 ++++++++-
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index 464c77e10f60..706df04b6cee 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -248,7 +248,7 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
 		return -ENOMEM;
 
 	pdata->regs = mem;
-	pdata->chip_id = BCM63XX_DEVICE_ID;
+	pdata->chip_id = (u32)device_get_match_data(dev);
 	pdata->big_endian = of_property_read_bool(np, "big-endian");
 
 	of_ports = of_get_child_by_name(np, "ports");
@@ -330,14 +330,28 @@ static void b53_mmap_shutdown(struct platform_device *pdev)
 }
 
 static const struct of_device_id b53_mmap_of_table[] = {
-	{ .compatible = "brcm,bcm3384-switch" },
-	{ .compatible = "brcm,bcm6318-switch" },
-	{ .compatible = "brcm,bcm6328-switch" },
-	{ .compatible = "brcm,bcm6362-switch" },
-	{ .compatible = "brcm,bcm6368-switch" },
-	{ .compatible = "brcm,bcm63268-switch" },
-	{ .compatible = "brcm,bcm63xx-switch" },
-	{ /* sentinel */ },
+	{
+		.compatible = "brcm,bcm3384-switch",
+		.data = (void *)BCM63XX_DEVICE_ID,
+	}, {
+		.compatible = "brcm,bcm6318-switch",
+		.data = (void *)BCM63XX_DEVICE_ID,
+	}, {
+		.compatible = "brcm,bcm6328-switch",
+		.data = (void *)BCM63XX_DEVICE_ID,
+	}, {
+		.compatible = "brcm,bcm6362-switch",
+		.data = (void *)BCM63XX_DEVICE_ID,
+	}, {
+		.compatible = "brcm,bcm6368-switch",
+		.data = (void *)BCM63XX_DEVICE_ID,
+	}, {
+		.compatible = "brcm,bcm63268-switch",
+		.data = (void *)BCM63268_DEVICE_ID,
+	}, {
+		.compatible = "brcm,bcm63xx-switch",
+		.data = (void *)BCM63XX_DEVICE_ID,
+	}, { /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, b53_mmap_of_table);
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 4cf9f540696e..a689a6950189 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -70,6 +70,7 @@ enum {
 	BCM53125_DEVICE_ID = 0x53125,
 	BCM53128_DEVICE_ID = 0x53128,
 	BCM63XX_DEVICE_ID = 0x6300,
+	BCM63268_DEVICE_ID = 0x63268,
 	BCM53010_DEVICE_ID = 0x53010,
 	BCM53011_DEVICE_ID = 0x53011,
 	BCM53012_DEVICE_ID = 0x53012,
@@ -191,7 +192,13 @@ static inline int is531x5(struct b53_device *dev)
 
 static inline int is63xx(struct b53_device *dev)
 {
-	return dev->chip_id == BCM63XX_DEVICE_ID;
+	return dev->chip_id == BCM63XX_DEVICE_ID ||
+		dev->chip_id == BCM63268_DEVICE_ID;
+}
+
+static inline int is63268(struct b53_device *dev)
+{
+	return dev->chip_id == BCM63268_DEVICE_ID;
 }
 
 static inline int is5301x(struct b53_device *dev)
-- 
2.30.2

