Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE084403D4
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhJ2UKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhJ2UKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 16:10:39 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F24C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 13:08:10 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d5so2994740wrc.1
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 13:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hFQqw1HX0svLmy6OwkL6+F6Jr5rqv/vr4Xq67T76n/M=;
        b=FCuokvEFvunR1tVj2uIrLzQ4UYv20Igs40+s9IEoVFZVqD342SLL+RCQp2f7TScRUq
         WXqUUXUvnliGAOhq4U3/UPvUjpSUGQYB8dIysRY1PkGHsc60KgmQB5IhgQ51Q3c7LUFE
         DXHaSKRnJ48ieAYqaRyQaP1Xi803C0s1zpdOQryuMpd4iwLjcewNldcFIrU4w/hg1tnv
         MBpkhcUWZ7Mu5DRka5B9bQeGsnGGLDLP05j+T4/qa5QG62/SfCoFqcyi90smmbwyLuAC
         o2cp8EFyLR076h8vStevAkqA4xboBQC2wpxOOX4FSHGK1zHqNyLUxiOwDDwWOjnkK2bn
         Fjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hFQqw1HX0svLmy6OwkL6+F6Jr5rqv/vr4Xq67T76n/M=;
        b=B9RAPW0InNe/Sf0i/fBncm/IEQax8If5dJmmWnWwQyMk4nL+9uhOvOgBthq0dQpp5r
         nqz+A4nFW5Wf6LIW2G/ZsA092wq8gINtPWJTUFw+zBS0nsElBn2nS8NhU/fUgSBp4/pk
         +Ao3pw4pU1rFjx39v4pLzIYMEvktTIrIwVJDvX891PMfbtIo7e3Id1aUzNxE8yIMILpi
         5l1Cozv81OsHquLKPD2I52J8Df0RPlc5tva09vJRCKPCpRx1Xo2ttPOvoCpOEF40tZSx
         ckyC85cW4FqVVD9xMXyPY2aAXwnacUoKPhhHqIVf4xJhTT2VaCNtwI0b3h1wjygZQubk
         Jsog==
X-Gm-Message-State: AOAM533HJcLaaXmibLVp2abc/Pwh/UZW1Csy60zHVXOHmZ/zDLzW7BwT
        hOQhfh6IDcLjt0NJLp/7ysJbAQ==
X-Google-Smtp-Source: ABdhPJxX1SN85Az0fWoqddxsgtY6IZrOwqWqUnv9bylHp54PcWiKLLgF5LV38zIDw9nmIHsMSQ4FdA==
X-Received: by 2002:a5d:548f:: with SMTP id h15mr15571850wrv.99.1635538088760;
        Fri, 29 Oct 2021 13:08:08 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id v3sm6818324wrg.23.2021.10.29.13.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 13:08:08 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 0/3] TSN endpoint Ethernet MAC driver
Date:   Fri, 29 Oct 2021 22:07:39 +0200
Message-Id: <20211029200742.19605-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a driver for my FPGA based TSN endpoint Ethernet MAC.
It also includes the device tree binding.

The device is designed as Ethernet MAC for TSN networks. It will be used
in PLCs with real-time requirements up to isochronous communication with
protocols like OPC UA Pub/Sub.

v3:
 - set MAC mode based on PHY information (Andrew Lunn)
 - remove/postpone loopback mode interface (Andrew Lunn)
 - add suppress_preamble node support (Andrew Lunn)
 - add mdio timeout (Andrew Lunn)
 - no need to call phy_start_aneg (Andrew Lunn)
 - remove unreachable code (Andrew Lunn)
 - move 'struct napi_struct' closer to queues (Vinicius Costa Gomes)
 - remove unused variable (kernel test robot)
 - switch from mdio interrupt to polling
 - mdio register without PHY address flag
 - thread safe interrupt enable register
 - add PTP_1588_CLOCK_OPTIONAL dependency to Kconfig
 - introduce dmadev for DMA allocation
 - mdiobus for platforms without device tree
 - prepare MAC address support for platforms without device tree
 - add missing interrupt disable to probe error path

v2:
 - add C45 check (Andrew Lunn)
 - forward phy_connect_direct() return value (Andrew Lunn)
 - use phy_remove_link_mode() (Andrew Lunn)
 - do not touch PHY directly, use PHY subsystem (Andrew Lunn)
 - remove management data lock (Andrew Lunn)
 - use phy_loopback (Andrew Lunn)
 - remove GMII2RGMII handling, use xgmiitorgmii (Andrew Lunn)
 - remove char device for direct TX/RX queue access (Andrew Lunn)
 - mdio node for mdiobus (Rob Herring)
 - simplify compatible node (Rob Herring)
 - limit number of items of reg and interrupts nodes (Rob Herring)
 - restrict phy-connection-type node (Rob Herring)
 - reference to mdio.yaml under mdio node (Rob Herring)
 - remove device tree (Michal Simek)
 - fix %llx warning (kernel test robot)
 - fix unused tmp variable warning (kernel test robot)
 - add missing of_node_put() for of_parse_phandle()
 - use devm_mdiobus_alloc()
 - simplify mdiobus read/write
 - reduce required nodes
 - ethtool priv flags interface for loopback
 - add missing static for some functions
 - remove obsolete hardware defines

Gerhard Engleder (3):
  dt-bindings: Add vendor prefix for Engleder
  dt-bindings: net: Add tsnep Ethernet controller
  tsnep: Add TSN endpoint Ethernet MAC driver

 .../bindings/net/engleder,tsnep.yaml          |   79 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/engleder/Kconfig         |   29 +
 drivers/net/ethernet/engleder/Makefile        |    9 +
 drivers/net/ethernet/engleder/tsnep.h         |  171 +++
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  288 ++++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  230 +++
 drivers/net/ethernet/engleder/tsnep_main.c    | 1252 +++++++++++++++++
 drivers/net/ethernet/engleder/tsnep_ptp.c     |  221 +++
 drivers/net/ethernet/engleder/tsnep_tc.c      |  442 ++++++
 drivers/net/ethernet/engleder/tsnep_test.c    |  811 +++++++++++
 13 files changed, 3536 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml
 create mode 100644 drivers/net/ethernet/engleder/Kconfig
 create mode 100644 drivers/net/ethernet/engleder/Makefile
 create mode 100644 drivers/net/ethernet/engleder/tsnep.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ethtool.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_hw.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_main.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ptp.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_tc.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_test.c

-- 
2.20.1

