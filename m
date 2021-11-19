Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEA1457936
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhKSXBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 18:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhKSXBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 18:01:50 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FD8C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 14:58:47 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p18so9804076wmq.5
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 14:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OCx/fbex/Cpzkwb/hcbkSf+IH75bR+nXU/NNsk1RbjE=;
        b=JFXpQgj8yypGh/Qzuomm9eOHPe2Pn8aXOElmmG6u3eGMJOQqrMoPn66YSsJ3YQjURH
         qfZart77FA9UHMP2nDE/XzyJD/Jps6QZ+h7FItOtf4gsmwM4Pr69spKRR9LaeRw++/o9
         zYlzjftRv6qepgvaRZ+0t10RLSd+a8YkAFturOvB+rqdzouBdnzLhuDsC7WeaMvFbvbp
         eO1jaYKvr3AV/wYun+Y4/g2JGDo7/+XS65HpZaaiKcteW3uJFQTxBrevosaho1IBY7B4
         olCpqn+RKCgIg6JdqTyvTu1fYceplzznHwhWUy684scOTEUneAvK+Slm+B3r1B9ebFSv
         flDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OCx/fbex/Cpzkwb/hcbkSf+IH75bR+nXU/NNsk1RbjE=;
        b=PGumV+HgFDDfv2hd8uAwTpS3rN6ptExECyKcqJszDp/UY6sWJno4RzR9kbjMosWDa2
         8ilbUGvqX/RWPtkEhDkIxF7o7qe7E4GCCZpP7kyJITHfzcjicsrJS+BmOw4jC0yoDAGM
         743kPiG5POf+jKkyJkbkf1UUpcCORSivjMYTJsWU0bXsnVJbx2R6bZrUsifHYzYc69Yb
         OEUc1OMLCUqlVocyFlhLQ1E6x5HzPLJz6cz2AHCQlp9ncqNy6SnetWcgyPQYBGwY2mVs
         aA87pQPGYFoylUu/WhY8TSZ8CqZdmI7wosFeY4rVQGbzXw0g1P5166c9zbDbmTsCuJdv
         gbbQ==
X-Gm-Message-State: AOAM532Kfb5LlFN8IRr3vhdClw+SdUBQWsjXtXTZertJYAVBtXxZrh2o
        8s0X8lr55SlMAHYP4+RJESLMvw==
X-Google-Smtp-Source: ABdhPJx8S99vrh/JwGShRIzavDhM+mze/ILnzep5q9V6SMps0k/gGtUGXJ+gYTmIxcSr+6Qbwx3AsQ==
X-Received: by 2002:a7b:cd96:: with SMTP id y22mr4127860wmj.121.1637362726338;
        Fri, 19 Nov 2021 14:58:46 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id n32sm17637377wms.1.2021.11.19.14.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 14:58:45 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v6 0/3] TSN endpoint Ethernet MAC driver
Date:   Fri, 19 Nov 2021 23:58:23 +0100
Message-Id: <20211119225826.19617-1-gerhard@engleder-embedded.com>
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

v6:
 - add build time configuration option for selftests (Andrew Lunn)
 - use only of_mdiobus_register (Andrew Lunn)
 - add comment to register length calculation (Andrew Lunn)
 - rework wmb() to dma_wmb() (Heiner Kallweit)
 - add comments to dma_rmb() and dma_wmb() (Heiner Kallweit)
 - fix compilation without CONFIG_NEED_DMA_MAP_STATE (kernel test robot)
 - fix typo 'incrememted'

v5:
 - rebase net-next/master

v4:
 - fix sparse __iomem warnings (Jakub Kicinski, Andrew Lunn)
 - fix sparse endian warnings (Jakub Kicinski, Andrew Lunn)

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

 .../bindings/net/engleder,tsnep.yaml          |   79 +
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/engleder/Kconfig         |   38 +
 drivers/net/ethernet/engleder/Makefile        |   10 +
 drivers/net/ethernet/engleder/tsnep.h         |  190 +++
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  293 ++++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  230 +++
 drivers/net/ethernet/engleder/tsnep_main.c    | 1273 +++++++++++++++++
 drivers/net/ethernet/engleder/tsnep_ptp.c     |  221 +++
 .../net/ethernet/engleder/tsnep_selftests.c   |  811 +++++++++++
 drivers/net/ethernet/engleder/tsnep_tc.c      |  443 ++++++
 13 files changed, 3592 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml
 create mode 100644 drivers/net/ethernet/engleder/Kconfig
 create mode 100644 drivers/net/ethernet/engleder/Makefile
 create mode 100644 drivers/net/ethernet/engleder/tsnep.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ethtool.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_hw.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_main.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ptp.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_selftests.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_tc.c

-- 
2.20.1

