Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3630333157E
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhCHSHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhCHSHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:07:35 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16012C06174A;
        Mon,  8 Mar 2021 10:07:35 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w11so12437622wrr.10;
        Mon, 08 Mar 2021 10:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eXXm6RkQtTCNpGgM0WHM3tT7K7Hex/U099iaqa2eF0w=;
        b=mqO4N4purk9yJjPq0JRku7ZDR2dA0PzrcGFoKwQ4di2g4aTLR7FPtn9XNPTSLyo0pX
         OJLiokR6Xs3t6Q6EU1929NksdHkWQkkZRgwv9daTqiRSfAEHUgO+WAn6wg539tcEoKk5
         r49nL/yViFuGCeDlmpQz0AGDelm0Eef3wKKv9lVONeURQc/ZBITNSP4/ANeqQztkpx2C
         k1GikchASIxTqVUk9ohioBpfqT+G4820VtSjRJBZ3/efuHmNnMME+DDr5pnyuBmbFt6z
         NfML8DEEDYh0j4UW+fgj852ISywxTMSIPgfn1bNQS2b8e4ITcj54q0KwKII9/Lk/qfCI
         H9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eXXm6RkQtTCNpGgM0WHM3tT7K7Hex/U099iaqa2eF0w=;
        b=MVeydk2w6PLsr1nVnmm+i+/YXUblLX7t/nU4NTqQA4t0X5uQABvG+GH5WSdmKLwY3C
         AqKsUoT6YAqy2sDdVR/jNoiovKTqE/uENMdokWonnOWlFn3glBKP9ukL9rgQb+/vgYCT
         R69igoQDMwrOckKuepkUAglDkec7nktccAXdNESvG3jrSscUgKBZ+7OxfHF7xiWHwU9t
         v8751fu6hXg9KbDbZhPFfhJKdd9e9DJuKR3d8WGO/uzK2bo6mKRb3OKdAKyQQxUKUWOO
         2vwr0bq0gZlXwBDvVow8ZRuwTLy/EBwgU1Xp2bR0RKKR47MpWNcrMxkLi5/29iRLyM41
         l6gQ==
X-Gm-Message-State: AOAM5329D7D7jauVgZ9wg6fVpiIlGS3BE0e7CeWmHWOi65xR5GUTbV55
        VmaoBspLEzPpYkg02AU6B9w=
X-Google-Smtp-Source: ABdhPJyFR1Wsw03JKrEDMX35fAODz6FVaDnHDoYGwjAC7TPwV5M89A2ZbHjY2ASOs5bajrZsu4L5mw==
X-Received: by 2002:adf:ed12:: with SMTP id a18mr24385253wro.249.1615226853796;
        Mon, 08 Mar 2021 10:07:33 -0800 (PST)
Received: from skynet.lan (224.red-2-138-103.dynamicip.rima-tde.net. [2.138.103.224])
        by smtp.gmail.com with ESMTPSA id c9sm3763256wrr.78.2021.03.08.10.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 10:07:33 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH] net: dsa: b53: mmap: Add device tree support
Date:   Mon,  8 Mar 2021 19:07:15 +0100
Message-Id: <20210308180715.18571-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree support to b53_mmap.c while keeping platform devices support.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_mmap.c | 36 ++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index c628d0980c0b..b897b4263930 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -228,12 +228,48 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write64 = b53_mmap_write64,
 };
 
+static int b53_mmap_probe_of(struct platform_device *pdev,
+			     struct b53_platform_data **ppdata)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct b53_platform_data *pdata;
+	void __iomem *mem;
+
+	mem = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
+
+	pdata = devm_kzalloc(dev, sizeof(struct b53_platform_data),
+			     GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	pdata->regs = mem;
+	pdata->chip_id = BCM63XX_DEVICE_ID;
+	pdata->big_endian = of_property_read_bool(np, "big-endian");
+	of_property_read_u16(np, "brcm,ports", &pdata->enabled_ports);
+
+	*ppdata = pdata;
+
+	return 0;
+}
+
 static int b53_mmap_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct b53_platform_data *pdata = pdev->dev.platform_data;
 	struct b53_mmap_priv *priv;
 	struct b53_device *dev;
 
+	if (np) {
+		int ret = b53_mmap_probe_of(pdev, &pdata);
+		if (ret) {
+			dev_err(&pdev->dev, "OF probe error\n");
+			return ret;
+		}
+	}
+
 	if (!pdata)
 		return -EINVAL;
 
-- 
2.20.1

