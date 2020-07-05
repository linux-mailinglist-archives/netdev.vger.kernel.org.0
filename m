Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C7A214BBD
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 11:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGEJ4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 05:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgGEJ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 05:56:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED333C08C5DE
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 02:56:06 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f2so9631717wrp.7
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 02:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VvvmotkcreCkunyFDHoCINthVwki6Zcg3uI33EtJQCo=;
        b=kokH5V2PsQ38hABOU5WOwvp71zv0WLZGiVYknksqrcmFy4auI7pPbUtTQ2xqp61+RM
         CbhwuQmLcnWlxEkAsDP8wtkijf8dyqQXjXY+gSr5mB4FMIXQauYCrs7Dc8LDT+V0AWX4
         WragB8E8mLg1WdEpuHlJWnsc89cGq3pej5vLN14QjwbBJxH9IErfBGcJC5OxeqMQLLjI
         yos6GkiyP8glsvIwN+Q0+US7qAerIjetGDdmlfphbOCoc8Wl7B3FKNnQ50JxMZSih9cK
         tiQDMJku7/jP6IZDxDRO1TUdEKSRf+MazDoMCX6tiqLxOBHitaHYYc94JMJUNz8c7o0s
         X25Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VvvmotkcreCkunyFDHoCINthVwki6Zcg3uI33EtJQCo=;
        b=KAmfRK8YaGLBSHVowTw/8962xhaYOvJ7DYsIMpnPbr4EOSODGkRSuqicx6NTn73kT+
         lsRa+CXNZM79YMyn/SKwq8TIPZ8Fx9GyfQj3GRp4Te+yjr/vwWq1WSMnk/doN0BOrBHl
         BSLn8VX7aHxNaJM02t9AA163ekb/sMdg1RdU4uF3QUfmNIHSwXH3LbZaVjyR4NUXmrs7
         uKKreX7n5pPbF3n+2HPQalprt2UVB6pdyatq3wqKITurAzPX5M6Fb4wq8JEMl9QW4bop
         j+04cisab/yCCU1tPZ9j+dDstJcj9D/8YcgIYsppYeZi0QCxs2sw3BCYhp3TDthb53/v
         WwEw==
X-Gm-Message-State: AOAM53356fig7ucawPsDj9MKiQ/hLkXsbwIs2s10Co2x2fT5MeIsAdbR
        M2QzsWQh3GnFG7c3ekXXJfCilw==
X-Google-Smtp-Source: ABdhPJx0eClwan21mf6twIBb6IiwAabsnV88Z3hj0O9AMB0NM4BXoawQf3Jxc24R1IvFY74V/I/UMw==
X-Received: by 2002:a5d:4dc2:: with SMTP id f2mr44802365wru.399.1593942965475;
        Sun, 05 Jul 2020 02:56:05 -0700 (PDT)
Received: from debian-brgl.home (lfbn-nic-1-68-20.w2-15.abo.wanadoo.fr. [2.15.159.20])
        by smtp.gmail.com with ESMTPSA id d28sm21106192wrc.50.2020.07.05.02.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 02:56:04 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: phy: add a Kconfig option for mdio_devres
Date:   Sun,  5 Jul 2020 11:55:47 +0200
Message-Id: <20200705095547.22527-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

If phylib is built as a module and CONFIG_MDIO_DEVICE is 'y', the
mdio_device and mdio_bus code will be in the phylib module, not in the
kernel image. Meanwhile we build mdio_devres depending on the
CONFIG_MDIO_DEVICE symbol, so if it's 'y', it will go into the kernel
and we'll hit the following linker error:

   ld: drivers/net/phy/mdio_devres.o: in function `devm_mdiobus_alloc_size':
>> drivers/net/phy/mdio_devres.c:38: undefined reference to `mdiobus_alloc_size'
   ld: drivers/net/phy/mdio_devres.o: in function `devm_mdiobus_free':
>> drivers/net/phy/mdio_devres.c:16: undefined reference to `mdiobus_free'
   ld: drivers/net/phy/mdio_devres.o: in function `__devm_mdiobus_register':
>> drivers/net/phy/mdio_devres.c:87: undefined reference to `__mdiobus_register'
   ld: drivers/net/phy/mdio_devres.o: in function `devm_mdiobus_unregister':
>> drivers/net/phy/mdio_devres.c:53: undefined reference to `mdiobus_unregister'
   ld: drivers/net/phy/mdio_devres.o: in function `devm_of_mdiobus_register':
>> drivers/net/phy/mdio_devres.c:120: undefined reference to `of_mdiobus_register'

Add a hidden Kconfig option for MDIO_DEVRES which will be currently
selected by CONFIG_PHYLIB as there are no non-phylib users of these
helpers.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/Kconfig  | 4 ++++
 drivers/net/phy/Makefile | 3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index e351d65533aa..7ffa8a4529a8 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -21,6 +21,9 @@ config MDIO_BUS
 
 if MDIO_BUS
 
+config MDIO_DEVRES
+	tristate
+
 config MDIO_ASPEED
 	tristate "ASPEED MDIO bus controller"
 	depends on ARCH_ASPEED || COMPILE_TEST
@@ -252,6 +255,7 @@ menuconfig PHYLIB
 	tristate "PHY Device support and infrastructure"
 	depends on NETDEVICES
 	select MDIO_DEVICE
+	select MDIO_DEVRES
 	help
 	  Ethernet controllers are usually attached to PHY
 	  devices.  This option provides infrastructure for
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index c9a9adf194d5..d84bab489a53 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -4,7 +4,6 @@
 libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o \
 				   linkmode.o
 mdio-bus-y			+= mdio_bus.o mdio_device.o
-mdio-devres-y			+= mdio_devres.o
 
 ifdef CONFIG_MDIO_DEVICE
 obj-y				+= mdio-boardinfo.o
@@ -18,7 +17,7 @@ libphy-y			+= $(mdio-bus-y)
 else
 obj-$(CONFIG_MDIO_DEVICE)	+= mdio-bus.o
 endif
-obj-$(CONFIG_MDIO_DEVICE)	+= mdio-devres.o
+obj-$(CONFIG_MDIO_DEVRES)	+= mdio_devres.o
 libphy-$(CONFIG_SWPHY)		+= swphy.o
 libphy-$(CONFIG_LED_TRIGGER_PHY)	+= phy_led_triggers.o
 
-- 
2.26.1

