Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73B6AC208
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 23:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404246AbfIFVbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 17:31:33 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41976 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391892AbfIFVbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 17:31:31 -0400
Received: by mail-io1-f65.google.com with SMTP id r26so15997126ioh.8;
        Fri, 06 Sep 2019 14:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ctf47Isk+sWnuqgqj31UnomMaq5+optxw6xq0HgIW2Y=;
        b=eUmGZiHY6PK00maj+13dp0wquFLwQIyBCzSXt8batfQ4qm1OeWNEEkxQMvJxHQuALI
         ojQgAC5wpfMaFrvGfxiehzwxeJa9teTSCZJ5lQMYH3/9jwhW0qIcFn0OOIox9GmZveKU
         kRAppzZ5cjG1dRPyTqsd59kUFHf37bCxh4+enUjQzE6OewldbZV8MWSRzv9tdWz15Fpm
         BA1EgBEeqMuPZjF4et3euCRp/koOY/QVjksRr+9C344WBvcB3IwvIIR80uUGpFRtWsfU
         0O1+E5b3bYgVbsoZNyWsXl+X1l+UlM35fs9TrZIPYr6bN1INPnL8tH9VcCtjIZpjt2Ax
         UCuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ctf47Isk+sWnuqgqj31UnomMaq5+optxw6xq0HgIW2Y=;
        b=eDceYxtVJEm5HhlsuSm3HUaKBYAwi0MTgV6/oqEPUF0VRdfoAI/C6kdqcLw64vl6nS
         I1Q6Bjo+gHddBEkt3FKKk1UWVKQCka8lYH+xn+aV+ASWFhUIafr+it3GkoJqmvJqM+uT
         dzdCXCotHlqGgwhMA2avNC2baY4+cMMY+3yfl3ED/+XOl7r6q3Y5HGEJ4axI8bmszih0
         nhvw0Vz69b14QTLZwzHQKQCxC9LMkRecnQWywgpAm0RJ7JAAyImBI7YqUYaeKZudykCM
         algyIBZNmkwxYMNsfCR9HeWUbeIxdCqmKYCQdF3bnZTcyUew7XojygMifA3BFqheiNcC
         YsKA==
X-Gm-Message-State: APjAAAUNuCLpAUmDd8YKrpf++6GDj/OZc80HcAmouHQBsNQT/xOCmAqC
        JInrvWgh2arW5OLXBR98HhMFChR2Eg==
X-Google-Smtp-Source: APXvYqxF5zQ66iPLOKfHFfDP/II61WH+CVgQrt3EPFpOUdrpvHdm/DTUEE8NwOOoj19hYKPZyTo+ww==
X-Received: by 2002:a02:600c:: with SMTP id i12mr12940192jac.84.1567805490536;
        Fri, 06 Sep 2019 14:31:30 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id r2sm4158110ioh.61.2019.09.06.14.31.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 14:31:29 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: microchip: add ksz9567 to ksz9477 driver
Date:   Fri,  6 Sep 2019 16:30:53 -0500
Message-Id: <20190906213054.48908-3-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906213054.48908-1-george.mccollister@gmail.com>
References: <20190906213054.48908-1-george.mccollister@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the KSZ9567 7-Port Gigabit Ethernet Switch to the
ksz9477 driver. The KSZ9567 supports both SPI and I2C. Oddly the
ksz9567 is already in the device tree binding documentation.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477.c     | 9 +++++++++
 drivers/net/dsa/microchip/ksz9477_i2c.c | 1 +
 drivers/net/dsa/microchip/ksz9477_spi.c | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 187be42de5f1..50ffc63d6231 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1529,6 +1529,15 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
 	},
+	{
+		.chip_id = 0x00956700,
+		.dev_name = "KSZ9567",
+		.num_vlans = 4096,
+		.num_alus = 4096,
+		.num_statics = 16,
+		.cpu_ports = 0x7F,	/* can be configured as cpu port */
+		.port_cnt = 7,		/* total physical port count */
+	},
 };
 
 static int ksz9477_switch_init(struct ksz_device *dev)
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 85fd0fb43941..c1548a43b60d 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -77,6 +77,7 @@ MODULE_DEVICE_TABLE(i2c, ksz9477_i2c_id);
 static const struct of_device_id ksz9477_dt_ids[] = {
 	{ .compatible = "microchip,ksz9477" },
 	{ .compatible = "microchip,ksz9897" },
+	{ .compatible = "microchip,ksz9567" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 2e402e4d866f..f4198d6f72be 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -81,6 +81,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 	{ .compatible = "microchip,ksz9893" },
 	{ .compatible = "microchip,ksz9563" },
 	{ .compatible = "microchip,ksz8563" },
+	{ .compatible = "microchip,ksz9567" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
-- 
2.11.0

