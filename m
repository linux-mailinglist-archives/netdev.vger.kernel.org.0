Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF25F20B556
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgFZPxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbgFZPxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:53:45 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FACC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:46 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h5so9969074wrc.7
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WmM0w9++YOvRbigI3M/z92SWeCSR1I4ysKIp85NsNQ8=;
        b=jsHKvQlFJchlk+nAS6EYxJsTrPWMAcRj0EHZs85DK/6iCVgykw7yR98sHXSnketSzR
         FI7rNq81sjrlfzX8fx+6ZDnDEqFSrhsrY//kpRlw6yGXVPdrY6Lvw01bBxNX9vnG20HB
         cEkyF3fKhzRDaJpYyZ31CMyB0XPvJ+jT3XMEGCZdta9X63MU6dQRRbgNWo6NJVX0DEAW
         QYChEWjf7nJYsj2UO9Wjk09rPNR4EMTCAG1uTz+9YZJyPHlL1Q/swWGAOYDA5uN1vHN1
         S+91cXzE3pab4b+F0UR/+62QxPZJWQ1QEeMwLtkEhv3RxXLYa9RwQBhRM2RaQEHXT2eQ
         AdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WmM0w9++YOvRbigI3M/z92SWeCSR1I4ysKIp85NsNQ8=;
        b=pSejzAqFbc1eoWr57kyywEVVhh8raXRPiKinuUAmYtsVKOQXLH9UfBjV8DK0knRpOe
         0WybYJHbXeEmeQxSbbodFeAwdl8pdnVUYbgHiqQkYJ2Id31SQxrRKs4oX14d5kO+iGST
         Hu73JCwHJN/2mq1X0C1X5cVZPc9Tqoq8e4zaB11uKdOO4Vw3u9WW6P8q5/0DTMphP16S
         Btxzp3UpUV3m3KYaGOEGSACsw5m9EaOOUtNXowzCRFGSHxbtNV4sfOoAsBjizMerYh+Y
         mph2GoA02cVLRomRb6fJ+d9yCaRooXTS7rMyuHtEmqvvBDOOQtJdNTMgkIL4tRlyK/TA
         TW4A==
X-Gm-Message-State: AOAM533KXd0XjXjYCii1PCBVgt36Ls60vHDWEHLU/1phTYB661EVXX9t
        1Sd31x06Lb+fZQbU7zXGxmE2jQ==
X-Google-Smtp-Source: ABdhPJxpfFa9oiq45cqxPoAt/649YHTlK3jOGv8zobpD2qHFN9TrEmp90ncl1Z9EYnXHMGeh8Q34rQ==
X-Received: by 2002:a05:6000:1008:: with SMTP id a8mr4597647wrx.416.1593186824858;
        Fri, 26 Jun 2020 08:53:44 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id h142sm8242791wme.3.2020.06.26.08.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 08:53:44 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 1/6] net: phy: arrange headers in mdio_bus.c alphabetically
Date:   Fri, 26 Jun 2020 17:53:20 +0200
Message-Id: <20200626155325.7021-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200626155325.7021-1-brgl@bgdev.pl>
References: <20200626155325.7021-1-brgl@bgdev.pl>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

