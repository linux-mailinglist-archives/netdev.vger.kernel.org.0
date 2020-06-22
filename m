Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4831020342E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgFVKBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgFVKBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:01:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BF0C061795
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:06 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g10so14253948wmh.4
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0a5wnHY7CslRA6Iynsfhb3yG1izm8FY/pWdetFoi42c=;
        b=rxCKkG6SfwCZOTa1iL5Lojz3NDEQwyb2IxWpdYBFS7nvwaSmH3nUs6LKzmpIqO9fmz
         T0E4/NHNhWS1FxOj6Knq7vaDIfED18iz4zDTKFADfGdZ87o9VBNoHn9xKkFZ5ABiLuMo
         spikJGn8iabnLkYyJ4CKFueyLxhkCPXnn+tT0IIM62ri0cxtQBzPXWPE2OKAi+/WB4Hb
         Zm7iXcDn1Km9OIDru3YUscj0Ip3rFJhgBzUhsF68MWUFQB29eaTMLMdCy2o5sHrQdX4O
         +4gvt10n83RfLFmg67wO7WMqC6KCkbs7hPXvMxFl4ifmIlhRhWH6of7y0Q6ilwx8joXN
         aa9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0a5wnHY7CslRA6Iynsfhb3yG1izm8FY/pWdetFoi42c=;
        b=N5o2qcIqN25Ezh4r6zbFA7VTCZ5lV0mGgiCR+L4Kr5VRVXFUXwiWpJ0YLw7rVXmxhG
         JkMlErFgpCZ16PPPdDnknjdWZPbAr1U5J0bAsq0LFa9xkh8IAI/RN10ssKPCBS0/IxEV
         mhIZ5PwW1yCVnPxSBjw4vZ1rdfG0sXeE/2i7yPdtA7F2sJQR9S6/1JmASUj05tIjtLch
         dCDWSezoiFG2B+EZhTDG1+EdWiXwv1gU0M8VYp5YbluGV8VyIw+PXwCHFqdB2AYsY1s5
         7TYEt+FDY0Ftq4J2r2ZownOmPrU99m8WFXVxKCh2mz2pwAgIw4nNtcvE7mKa6aQdwWig
         +KRQ==
X-Gm-Message-State: AOAM530h+cwhWx6Wuu+AQK2JoZHS5np13SBLcfmsJ16JCgWMaP2jSDXp
        wsl9a+J7YMsEFh/2TKqjigzjqQ==
X-Google-Smtp-Source: ABdhPJwltFZXM/3VYa9tIy2MbCHj//CBC2paauuUY5AwGyYeKiWa1AZvShK5hzeRuXlvCn791GVruA==
X-Received: by 2002:a1c:c1:: with SMTP id 184mr17443220wma.74.1592820065387;
        Mon, 22 Jun 2020 03:01:05 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id x205sm16822187wmx.21.2020.06.22.03.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:01:04 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 00/11] net: improve devres helpers
Date:   Mon, 22 Jun 2020 12:00:45 +0200
Message-Id: <20200622100056.10151-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

When I first submitted the series adding devm_register_netdev() I was
told during review that it should check if the underlying struct net_device
is managed too before proceeding. I initially accepted this as the right
approach but in the back of my head something seemed wrong about this.
I started looking around and noticed how devm_mdiobus_register()
is implemented.

It turned out that struct mii_bus contains information about whether it's
managed or not and the release callback of devm_mdiobus_alloc() is responsible
for calling mdiobus_unregister(). This seems wrong to me as managed structures
shouldn't care about who manages them. It's devres' code task to correctly undo
whatever it registers/allocates.

With this series I propose to make the release callbacks of mdiobus devm
helpers only release the resources they actually allocate themselves as it the
standard in devm routines. I also propose to not check whether the structures
passed to devm_mdiobus_register() and devm_register_netdev() are already
managed as they could have been allocated over devres as part of bigger
memory chunk. I see this as an unnecessary limitation.

First two patches aim at removing the only use of devm_mdiobus_free(). It
modifies the ixgbe driver. I only compile tested it as I don't have the
relevant hw.

Next two patches relax devm_register_netdev() - we stop checking whether
struct net_device was registered using devm_etherdev_alloc().

We then document the mdio devres helper that's missing in devres.rst list
and un-inline the current implementation of devm_mdiobus_register().

Patch 8 re-implements the devres helpers for mdio conforming to common
devres patterns.

Patches 9 and 10 provide devm_of_mdiobus_register() and the last patch
adds its first user.

Bartosz Golaszewski (11):
  net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()
  net: ethernet: ixgbe: don't call devm_mdiobus_free()
  net: devres: relax devm_register_netdev()
  net: devres: rename the release callback of devm_register_netdev()
  Documentation: devres: add missing mdio helper
  phy: un-inline devm_mdiobus_register()
  phy: mdio: add kerneldoc for __devm_mdiobus_register()
  net: phy: don't abuse devres in devm_mdiobus_register()
  of: mdio: remove the 'extern' keyword from function declarations
  of: mdio: provide devm_of_mdiobus_register()
  net: ethernet: mtk-star-emac: use devm_of_mdiobus_register()

 .../driver-api/driver-model/devres.rst        |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c  | 14 +---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 13 +--
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/phy/Makefile                      |  2 +-
 drivers/net/phy/mdio_bus.c                    | 73 ----------------
 drivers/net/phy/mdio_devres.c                 | 83 +++++++++++++++++++
 drivers/of/of_mdio.c                          | 43 ++++++++++
 include/linux/of_mdio.h                       | 40 ++++-----
 include/linux/phy.h                           | 21 +----
 net/devres.c                                  | 23 +----
 12 files changed, 167 insertions(+), 156 deletions(-)
 create mode 100644 drivers/net/phy/mdio_devres.c

-- 
2.26.1

