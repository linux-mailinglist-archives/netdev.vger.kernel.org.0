Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D2C20E0E9
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbgF2Uur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731429AbgF2TNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:34 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FDFC0D941F
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:12 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b6so16252011wrs.11
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3SFeAEvbOoZI/xpVJ8MO71Sd1LqnSCGoIeWQbxnMQg=;
        b=W34A5EzIFj5HWi2O+Uu6ihBeBiDeWhpckbWrX2jnfqXAR3x0qNViaW+WgvnvpxwiWO
         MGqgE1enmwmS0gQxdKT5NnCo8pT8qbnyks2TEEdLnPjFm0OCLBWs+QPHAs9eXm7uQdat
         JWbhorZHQ3BtymX0aXM/lywfKu/bT8ZNk4SSMGwMY45YdISPCRJHVeIp8gOWUa6hI3x5
         yl2q7FCGF3ftBuUSxFt5y3sPjglhVa+3G49n58H+eBi39BWD3W01vtmugl+iYZj5MxaS
         mkrYBWhfSoM6r/EQlCIFuE/GmGSu3DIPQIVdw8C/+juCBxxelde4Yfeywt4RMER4CJbR
         0+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3SFeAEvbOoZI/xpVJ8MO71Sd1LqnSCGoIeWQbxnMQg=;
        b=J7OXKUj+p65ZzXxZ/M9Bzb/wVEc3R9D/OBfLouIoVKqZ7DBCp+bSM3z2dZSFTUOtdQ
         3noed5F8lyuvAT8TwudUhcQJ0UJh8KOwKr1WdcSyP7KULIHh56qdbEfApP6zm4JdAnBE
         4W4dAL9hynqnVPVBcZX4XdExpXlDhEcMnwRrugMMrDa4ImJqn5bvORmjgPdxkehMET1g
         JDa2QgDlyLYBTxaEZlxAFQ1nRDyY2wgTg44m7VNiZmJJI9oTgAUTc1yysozpeeUk7riw
         8/8TxuWZDsOv4S9PDp8U2qQ6782enSRR1jM/6dtloxsmnQEP/gKQyJZEI7xQoleo+1Ip
         X30Q==
X-Gm-Message-State: AOAM532MjFHgmKLQ7qf4ajJXS7jI9fS40GNrNGawb/OP76crLDyRMePl
        enfn9AY6VE7hTytkOjBOspevXw==
X-Google-Smtp-Source: ABdhPJzvKPYK67MLNdl2CXmAriudaJFiLrZRmwhzT6FCEy4WwbiER21DP71IWFlJPEiw6dlp0MpaYQ==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr18038664wrm.271.1593432250982;
        Mon, 29 Jun 2020 05:04:10 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id d81sm25274347wmc.0.2020.06.29.05.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 05:04:10 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 00/10] net: improve devres helpers
Date:   Mon, 29 Jun 2020 14:03:36 +0200
Message-Id: <20200629120346.4382-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

So it seems like there's no support for relaxing certain networking devres
helpers to not require previously allocated structures to also be managed.
However the way mdio devres variants are implemented is still wrong and I
modified my series to address it while keeping the functions strict.

First two patches modify the ixgbe driver to get rid of the last user of
devm_mdiobus_free().

Patches 3, 4, 5 and 6 are mostly cosmetic.

Patch 7 fixes the way devm_mdiobus_register() is implemented.

Patches 8 & 9 provide a managed variant of of_mdiobus_register() and
last patch uses it in mtk-star-emac driver.

v1 -> v2:
- drop the patch relaxing devm_register_netdev()
- require struct mii_bus to be managed in devm_mdiobus_register() and
  devm_of_mdiobus_register() but don't store that information in the
  structure itself: use devres_find() instead

Bartosz Golaszewski (10):
  net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()
  net: ethernet: ixgbe: don't call devm_mdiobus_free()
  net: devres: rename the release callback of devm_register_netdev()
  Documentation: devres: add missing mdio helper
  phy: un-inline devm_mdiobus_register()
  phy: mdio: add kerneldoc for __devm_mdiobus_register()
  net: phy: don't abuse devres in devm_mdiobus_register()
  of: mdio: remove the 'extern' keyword from function declarations
  of: mdio: provide devm_of_mdiobus_register()
  net: ethernet: mtk-star-emac: use devm_of_mdiobus_register()

 .../driver-api/driver-model/devres.rst        |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c  |  14 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c |  13 +-
 drivers/net/ethernet/realtek/r8169_main.c     |   2 +-
 drivers/net/phy/Makefile                      |   2 +
 drivers/net/phy/mdio_bus.c                    |  73 ----------
 drivers/net/phy/mdio_devres.c                 | 133 ++++++++++++++++++
 include/linux/of_mdio.h                       |  40 +++---
 include/linux/phy.h                           |  21 +--
 net/devres.c                                  |   4 +-
 11 files changed, 174 insertions(+), 137 deletions(-)
 create mode 100644 drivers/net/phy/mdio_devres.c

-- 
2.26.1

