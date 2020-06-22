Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C802033CF
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgFVJlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgFVJl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:28 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F6AC061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:28 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g75so6114066wme.5
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XLmPOYVdaqe+y9UvFG8JqfkTSyC/6Nk+DJj6OjGJzDQ=;
        b=2GosbQAaXiA/JCZI+g11JdzSxLyfN527ZSvaJacFgJHvRnRrhvLEPiWmyJFet6DLEb
         hARZd6Itp8Ly0hWe26lMW947wIjwj7XUtHNewIkPpHDfvslkT6iaZRGzwVc1+AdkfN9E
         77J7zDnRp2cYGiifSFx4PYoShheiwsluJXswRLqt8WCuWUWb6Embtw6Z9mU9W3xNZj5+
         FkCtTAjDmKfNu78ysMk7zie06INp6h4obBSJsjUfKcugxIeYOlBAJsbCB32uIVigpa55
         H1TopXYcKvoxi2/iyqbeMnFO353y8FNqh6Aqq/dcIb9ZhBcMg37bYYwmNiEdTQ26X7wA
         iCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XLmPOYVdaqe+y9UvFG8JqfkTSyC/6Nk+DJj6OjGJzDQ=;
        b=D9lLnTGQfHeE/L4KYkG0kAHhFMAUe58soE2DOHC1Rtg91ueOwPWD1jkb/RvZTqIpgz
         JfW2jWBR3u2j2zAKlD81mMqWI77GNFHGgVLXcV3AU+yqGCtPr1OnJg2tP3KtTt5TB0Dz
         Dev22Z7ZRM//7131rXF4VxgJ0lSMRKJqY5SKkJnrnzVYDZyn6BRitSM8Ji2DflmNrOIz
         bR5+BGyZ7pgsf0oJUR6V7Sbg20kmJ5sqYk9mhNml8zqfHWyNAyeO2NuldbOBkfzwwMWi
         jM3HxyZZ6jtg7kMH0T06IVF7lS3aWa7Qg8XW/WcuCukxPblsLgBFbPMjMiMlenqRjf4m
         fp0w==
X-Gm-Message-State: AOAM53305qem7UMRdekpnJ8zb5oCN/04ARZ4tWI9OzqQ7wkSIHMlQk5q
        GcUlvHhnreXtQkXsw8XiG6RDjw==
X-Google-Smtp-Source: ABdhPJzDaXbcIaH5nH0mryMVoe9yjbkPdBB2oGScnXDu1GQppXU4cUVJs6lCaQVoAVfhbUhW/QgYFw==
X-Received: by 2002:a1c:f204:: with SMTP id s4mr18359072wmc.159.1592818887262;
        Mon, 22 Jun 2020 02:41:27 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:26 -0700 (PDT)
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
Subject: [PATCH 03/15] net: phy: arrange headers in phy_device.c alphabetically
Date:   Mon, 22 Jun 2020 11:37:32 +0200
Message-Id: <20200622093744.13685-4-brgl@bgdev.pl>
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
 drivers/net/phy/phy_device.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 04946de74fa0..1b4df12c70ad 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,28 +9,28 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/errno.h>
-#include <linux/unistd.h>
-#include <linux/slab.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
+#include <linux/bitmap.h>
 #include <linux/delay.h>
-#include <linux/netdevice.h>
+#include <linux/errno.h>
 #include <linux/etherdevice.h>
-#include <linux/skbuff.h>
+#include <linux/ethtool.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mdio.h>
+#include <linux/mii.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/mii.h>
-#include <linux/ethtool.h>
-#include <linux/bitmap.h>
+#include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
 #include <linux/sfp.h>
-#include <linux/mdio.h>
-#include <linux/io.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/unistd.h>
 
 MODULE_DESCRIPTION("PHY library");
 MODULE_AUTHOR("Andy Fleming");
-- 
2.26.1

