Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E5C2033D5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgFVJn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgFVJlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:25 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A2AC061797
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:24 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y20so15033720wmi.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jZFWs1jjiaVnSG438fJkY7s38xrX7YeHfB9snWv0f6M=;
        b=JohkqRDOkStLwOQBjn7GAxxxqeMmpsJpexC5Nvm3ZMZvZkzc6ARClZYDLYdCfBzdNP
         R+QJVrGl3nve0LVt+ru6aBGSu24D+tdHE1WXHHZuvA5Ccg3nHihCl36U5ScPUL7gEh57
         udVFjmWNOm6E0bczq/erJCZqK+GBkdblmTaRS2wxUujd7J+4fpcSfkvXc70p5jeaQvh0
         r7uqyKqpQR2LYCzlfV/PSR3Z3SvvEaicHAEj11kmaMKkCWH4prC3PqUu8JFXFO7jY4OE
         2ZItHe0laJ0Lf9dSzMlvGGUIslglMGg/vMwUmi0/DI2fZnDGPbhyK9nizsa0eDmyC4EL
         qmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZFWs1jjiaVnSG438fJkY7s38xrX7YeHfB9snWv0f6M=;
        b=hQD0MpsvS6muEg5shmPX3OUi90vLMwOsC94ecou5jx95wD5l+mhJKfeeCzpMEdRwId
         diJXyWNJvgmYXR9kjOW1DjJMbJaWtlmEpeGuch9RsmB3CFf3J7m7Gk8YGXZj9V50jDTJ
         KGPkdyPbTuo8ihUA7x5CNpq8N/yNMv2stvk99nm8Mdxb/0JbmbTrRpvVM2Nr1tk6/A2r
         JEe1kEdFlwlHll2MtzVZGBHXcyrEH0OQ8Kt1+B7EOB7eubaoOFTOBAdeO/ss81UJ9cMW
         X5ransBU/S0gkG+JYDgFgl3n2oIAxpUB+MTCPQztPZhlUnv0p959S5GHtAQ2xagadEQD
         cfpw==
X-Gm-Message-State: AOAM532YP0Xg+JdJuBeWUXDWIzEgOjBvsNPtfEOIZ0GrWol5QG61ATTy
        mdzbm5LeOvbpgxi3u+PBzWqn7A==
X-Google-Smtp-Source: ABdhPJyC1ihQ/cFNQCt/b68/kb0LNRNlp3xUizgD1UJeHr9htbQzK5ESNt14EIs0DoIuJdIEW8DsUQ==
X-Received: by 2002:a05:600c:2294:: with SMTP id 20mr18307854wmf.51.1592818883659;
        Mon, 22 Jun 2020 02:41:23 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:23 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 01/15] net: phy: arrange headers in mdio_bus.c alphabetically
Date:   Mon, 22 Jun 2020 11:37:30 +0200
Message-Id: <20200622093744.13685-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622093744.13685-1-brgl@bgdev.pl>
References: <20200622093744.13685-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Keeping the headers in alphabetical order is better for readability and
allows to easily see if given header is already included.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/mdio_bus.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 6ceee82b2839..296cf9771483 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -8,32 +8,32 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/errno.h>
-#include <linux/unistd.h>
-#include <linux/slab.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mii.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
 #include <linux/of_device.h>
-#include <linux/of_mdio.h>
 #include <linux/of_gpio.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
 #include <linux/reset.h>
 #include <linux/skbuff.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/mii.h>
-#include <linux/ethtool.h>
-#include <linux/phy.h>
-#include <linux/io.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/unistd.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/mdio.h>
-- 
2.26.1

