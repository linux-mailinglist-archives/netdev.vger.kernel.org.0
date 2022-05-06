Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6707751D09A
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 07:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389105AbiEFF2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 01:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389093AbiEFF2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 01:28:42 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C2C5DA64;
        Thu,  5 May 2022 22:24:59 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2465OatZ049321;
        Fri, 6 May 2022 00:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1651814676;
        bh=4j1xMzQOmlht80z6F07pIV3L6cGhnmTTb4Ja+LRnZBw=;
        h=From:To:CC:Subject:Date;
        b=vKNmglauJKXzLk03BsjVhgwBqEm+7Pa5jhrM/7S6lykPGljyhXrNMGY9hLdJaqGAE
         hl810/olrqdH4c7md74IWlh9nzxqHMI37mlvKY5N9Ad9F5WuZYK58JYrw+PZPZcyHb
         YuxhWbo4jjjjvpKbDOXZ2CPB4DnzIUYG4vbgxAc4=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2465OZBW003996
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 May 2022 00:24:36 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 6
 May 2022 00:24:35 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Fri, 6 May 2022 00:24:35 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2465OY8F009958;
        Fri, 6 May 2022 00:24:34 -0500
From:   Puranjay Mohan <p-mohan@ti.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <nm@ti.com>, <ssantosh@kernel.org>,
        <s-anna@ti.com>, <p-mohan@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@kernel.org>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <kishon@ti.com>,
        <robh+dt@kernel.org>, <afd@ti.com>, <andrew@lunn.ch>
Subject: [PATCH 0/2] Introduce ICSSG based ethernet Driver
Date:   Fri, 6 May 2022 10:54:31 +0530
Message-ID: <20220506052433.28087-1-p-mohan@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Programmable Real-time Unit and Industrial Communication Subsystem
Gigabit (PRU_ICSSG) is a low-latency microcontroller subsystem in the TI
SoCs. This subsystem is provided for the use cases like implementation of
custom peripheral interfaces, offloading of tasks from the other
processor cores of the SoC, etc.

The subsystem includes many accelerators for data processing like
multiplier and multiplier-accumulator. It also has peripherals like
UART, MII/RGMII, MDIO, etc. Every ICSSG core includes two 32-bit
load/store RISC CPU cores called PRUs.

The above features allow it to be used for implementing custom firmware
based peripherals like ethernet.

This series adds the YAML documentation and the driver with basic EMAC
support for TI AM654 Silicon Rev 2 SoC with the PRU_ICSSG Sub-system.
running dual-EMAC firmware.
This currently supports basic EMAC with 1Gbps and 100Mbps link. 10M and
half-duplex modes are not yet supported because they require the support
of an IEP, which will be added later.
Advanced features like switch-dev and timestamping will be added later.

This series depends on two patch series that are not yet merged, one in
the remoteproc tree and another in the soc tree. the first one is titled
Introduce PRU remoteproc consumer API and the second one is titled
Introduce PRU platform consumer API.
Both of these are required for this driver.

To explain this dependency and to get reviews, I had earlier posted all
three of these as an RFC[1], this can be seen for understanding the
dependencies.

I then posted the remoteproc[2] and soc[3] series seperately to their
respective trees.

[1] https://lore.kernel.org/all/20220406094358.7895-1-p-mohan@ti.com/
[2] https://patchwork.kernel.org/project/linux-remoteproc/cover/20220418104118.12878-1-p-mohan@ti.com/
[3] https://patchwork.kernel.org/project/linux-remoteproc/cover/20220418123004.9332-1-p-mohan@ti.com/

Thanks and Regards,
Puranjay Mohan

Puranjay Mohan (1):
  dt-bindings: net: Add ICSSG Ethernet Driver bindings

Roger Quadros (1):
  net: ti: icssg-prueth: Add ICSSG ethernet driver

 .../bindings/net/ti,icssg-prueth.yaml         |  174 ++
 drivers/net/ethernet/ti/Kconfig               |   15 +
 drivers/net/ethernet/ti/Makefile              |    3 +
 drivers/net/ethernet/ti/icssg_classifier.c    |  375 ++++
 drivers/net/ethernet/ti/icssg_config.c        |  443 ++++
 drivers/net/ethernet/ti/icssg_config.h        |  200 ++
 drivers/net/ethernet/ti/icssg_ethtool.c       |  301 +++
 drivers/net/ethernet/ti/icssg_mii_cfg.c       |  104 +
 drivers/net/ethernet/ti/icssg_mii_rt.h        |  151 ++
 drivers/net/ethernet/ti/icssg_prueth.c        | 1891 +++++++++++++++++
 drivers/net/ethernet/ti/icssg_prueth.h        |  247 +++
 drivers/net/ethernet/ti/icssg_switch_map.h    |  183 ++
 include/linux/pruss.h                         |    1 +
 13 files changed, 4088 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
 create mode 100644 drivers/net/ethernet/ti/icssg_classifier.c
 create mode 100644 drivers/net/ethernet/ti/icssg_config.c
 create mode 100644 drivers/net/ethernet/ti/icssg_config.h
 create mode 100644 drivers/net/ethernet/ti/icssg_ethtool.c
 create mode 100644 drivers/net/ethernet/ti/icssg_mii_cfg.c
 create mode 100644 drivers/net/ethernet/ti/icssg_mii_rt.h
 create mode 100644 drivers/net/ethernet/ti/icssg_prueth.c
 create mode 100644 drivers/net/ethernet/ti/icssg_prueth.h
 create mode 100644 drivers/net/ethernet/ti/icssg_switch_map.h

-- 
2.17.1

