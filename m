Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD2F2033A0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgFVJlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgFVJlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:23 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE95C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:23 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so6113802wme.5
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7JOFF+Nl1qiIhM1iOj4oCorX86E5B7hR8kg9WCnzUnw=;
        b=I/eaN9xrQqwwgmhuM+4CqaeHsY6aV60kH8mKn4OebmUYtK7pNQK0wVGunsLFglKTAy
         eUfthcd2EIQ1C+6upxc/23ua64/60kfHPQMRmNReX5PP2rqNblnCuw0jNW6ITtVZgxqW
         JMjW13bHUWbsnkuYKGTXldz63/aT5JAfKOHfJsdcPLDI6CaCjZlEVCVN1/cNK9IA3bVM
         sWSBmTqNhgt/nNmxR0EvpDrZ4oceKA+bx2hJY0Lo1o/pDYzIwKGHfLU+2NxtIdO7LXgx
         9KJhrZfL7yYB7s5BDFwVOlo/2O7aGyMMJ8C/qk+ipYeZOh/5oEPkN+TeTC0+JThrTbg7
         00hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7JOFF+Nl1qiIhM1iOj4oCorX86E5B7hR8kg9WCnzUnw=;
        b=kmNm5jMlZh8Pjoz2DRF7VfywV2sZaIuXkTxeI9t1CLAVv3JBDtWZMp1maAG5F0yWSZ
         YPc6jBxTTAZ2Mq8audIQBIyca5MHzA6iNXqMDvxwViK0cR810UHP/jvq/OlVPgGmCaou
         8BFUUecxrO+CVfN4rxLPnYB3vPeUJoJeuCC5aIw8tRwKDJWgahrPr4ftZCs4ufh9tUDL
         40iT5szQs4ZTQLn7Lb/QAiiJQKwSanudHubDGpN4uOAV+1Vd+AwqItnu6R1JjBwJgO5+
         p1Y+WuU+LSUanjrRx7YcaZvNfUAYI5T/nIvWPYNJLulRlrJk+67ufksyynbK/Gm2sQJE
         0ndA==
X-Gm-Message-State: AOAM5310xDdn19JgWOccm9ooO/doLi0URzdL+Stt49igT/3x0NT7SkO8
        rCbKy9ExxlEISBE2HOS4dPIdYw==
X-Google-Smtp-Source: ABdhPJwbib6BkarNo+K48caVL1EEcMyD4P1NjsZ159e2tdZhAydKdMgyxCTWdsPKQgIV/5CqbPqSBg==
X-Received: by 2002:a1c:4d0a:: with SMTP id o10mr17628133wmh.150.1592818881779;
        Mon, 22 Jun 2020 02:41:21 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:21 -0700 (PDT)
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
Subject: [PATCH 00/15] net: phy: correctly model the PHY voltage supply in DT
Date:   Mon, 22 Jun 2020 11:37:29 +0200
Message-Id: <20200622093744.13685-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

PHY devices on an MDIO bus can have their own regulators. This is currently
mostly modeled using the semi-standard phy-supply property on the MAC node.
This seems to be conceptually wrong though, as the MAC shouldn't need to
care about enabling the PHY regulator explicitly. Instead this should be
done by the core PHY/MDIO code.

This series introduces a new DT property at the PHY node level in mdio.yaml
and adds support for PHY regulator, then uses the new property on pumpkin
boards. It also addresses several issues I noticed when working on this
feature.

First four patches are just cosmetic improvements in source files we'll
modify later in this series.

Patches 5 and 6 modify the way PHY reset handling works. Currently the
probe() callback needs to be implemented to take the PHY out of reset but
PHY drivers without probe() can have resets defined as well.

Patches 7-11 address an issue where we probe the PHY for ID without
deasserting its reset signal. We delay the ID read until after the logical
device is created and resets have been configured.

Last four patches add the new DT property, implement support for PHY
regulator in phy and mdio code and set the new property in the DT file
for MediaTek's pumpkin boards.

Bartosz Golaszewski (15):
  net: phy: arrange headers in mdio_bus.c alphabetically
  net: phy: arrange headers in mdio_device.c alphabetically
  net: phy: arrange headers in phy_device.c alphabetically
  net: mdio: add a forward declaration for reset_control to mdio.h
  net: phy: reset the PHY even if probe() is not implemented
  net: phy: mdio: reset MDIO devices even if probe() is not implemented
  net: phy: split out the PHY driver request out of phy_device_create()
  net: phy: check the PHY presence in get_phy_id()
  net: phy: delay PHY driver probe until PHY registration
  net: phy: simplify phy_device_create()
  net: phy: drop get_phy_device()
  dt-bindings: mdio: add phy-supply property to ethernet phy node
  net: phy: mdio: add support for PHY supply regulator
  net: phy: add PHY regulator support
  ARM64: dts: mediatek: add a phy regulator to pumpkin-common.dtsi

 .../devicetree/bindings/net/mdio.yaml         |   4 +
 .../boot/dts/mediatek/pumpkin-common.dtsi     |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c   |   5 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_mac.c |   2 +-
 drivers/net/ethernet/socionext/netsec.c       |   3 +-
 drivers/net/phy/fixed_phy.c                   |   2 +-
 drivers/net/phy/mdio-xgene.c                  |   2 +-
 drivers/net/phy/mdio_bus.c                    |  55 +++--
 drivers/net/phy/mdio_device.c                 |  51 ++++-
 drivers/net/phy/nxp-tja11xx.c                 |   2 +-
 drivers/net/phy/phy_device.c                  | 216 ++++++++++--------
 drivers/net/phy/sfp.c                         |   2 +-
 drivers/of/of_mdio.c                          |  11 +-
 include/linux/mdio.h                          |   4 +
 include/linux/phy.h                           |  21 +-
 16 files changed, 240 insertions(+), 144 deletions(-)

-- 
2.26.1

